import { parse as parseTld } from "tldts";
import Redis, { type RedisOptions } from "ioredis";

/** ======= ENV ======= */
const {
  SERPER_API_KEY,
  REQUEST_TIMEOUT_MS = "6000",
  REDIS_HOST = "",
  REDIS_PORT = "6379",
  REDIS_PASSWORD = "",
  REDIS_TLS = "",
  CACHE_TTL_SECONDS = "23328000", // ~270 days
  DEFAULT_COUNTRY = "sg", //  MUST BE LOWER CASE
  TAVILY_API_KEY = ""
} = process.env;

const TIMEOUT = Number(REQUEST_TIMEOUT_MS);

/** ======= Utils ======= */
type SerperOrganic = { link: string; title?: string; snippet?: string; position?: number };


const BLACKLIST = new Set([
  "facebook.com", "instagram.com", "x.com", "twitter.com", "linkedin.com",
  "youtube.com", "tiktok.com", "wikipedia.org", "reddit.com", "pinterest.com",
  "amazon.com", "apps.apple.com", "play.google.com", "ebay.com", "fandom.com"
]);

function etld1(urlStr: string): string {
  try {
    const u = new URL(urlStr);
    const p = parseTld(u.hostname);
    return p.domain || u.hostname;
  } catch { return ""; }
}
function isBlacklisted(host: string) {
  return [...BLACKLIST].some(b => host === b || host.endsWith("." + b));
}
function normalize(raw: string) {
  return (raw || "")
    .replace(/\b(pte\.?\s*ltd|ltd|inc|corp|co|company|s\.a\.|ag|gmbh|llc|plc)\b\.?/gi, "")
    .replace(/[®™]/g, "")
    .replace(/\s+/g, " ")
    .trim();
}
function withTimeout<T>(p: Promise<T>, ms: number) {
  return Promise.race([
    p,
    new Promise<T>((_, rej) => setTimeout(() => rej(new Error("timeout")), ms)),
  ]);
}

async function serper(q: string, num: number, country = DEFAULT_COUNTRY) {
  if (!SERPER_API_KEY) throw new Error("SERPER_API_KEY missing");
  const r = await withTimeout(fetch("https://google.serper.dev/search", {
    method: "POST",
    headers: { "X-API-KEY": SERPER_API_KEY, "Content-Type": "application/json" },
    body: JSON.stringify({ q, num, gl: String(country).toLowerCase() }),
  }), TIMEOUT);
  const data = await r.json();

  // include position in the raw buffer
  const raw: Array<{ url: string; title?: string; snippet?: string; position?: number }> = [];

  if (data?.knowledgeGraph?.website) {
    raw.push({
      url: data.knowledgeGraph.website,
      title: data.knowledgeGraph.title || "",
      snippet: "",
      position: 0, // treat KG website as strongest prior
    });
  }

  for (const s of (data?.organic || []) as SerperOrganic[]) {
    if (!s?.link) continue;
    raw.push({
      url: s.link,
      title: s.title || "",
      snippet: s.snippet || "",
      position: s.position,            // <-- CHANGED: keep SERP position
    });
  }

  const seen = new Set<string>();
  const trimmed: Array<{ title?: string; snippet?: string; url: string; domain: string; position?: number }> = [];

  for (const r of raw) {
    const domain = etld1(r.url);
    if (!domain) continue;
    if (isBlacklisted(domain)) continue;
    if (seen.has(domain)) continue;
    seen.add(domain);

    trimmed.push({
      title: r.title,
      snippet: r.snippet,
      url: r.url,
      domain,
      position: r.position,            // <-- CHANGED: surface position
    });

    if (trimmed.length >= num) break;
  }
  return trimmed;
}

async function web_search_serp(q: string, num = 8, country = DEFAULT_COUNTRY) {
  const results = await serper(q, Math.min(Math.max(num, 1), 10), country);
  return { results }; // results now carry {title, snippet, url, domain, position?}
}


/** ======= Canonical verifier ======= */
async function verify_canonical(url: string) {
  try {
    const r = await withTimeout(fetch(url, {
      method: "GET",
      headers: { "Accept": "text/html,application/xhtml+xml" }
    }), TIMEOUT);
    const html = await r.text();
    const title = html.match(/<title[^>]*>([^<]{0,300})<\/title>/i)?.[1]?.trim() || null;
    const can = html.match(/<link[^>]+rel=["']?canonical["']?[^>]*href=["']([^"']+)["'][^>]*>/i)?.[1];
    const canonical_domain = can ? etld1(new URL(can, url).toString()) : null;
    return { canonical_domain, title };
  } catch {
    return { canonical_domain: null, title: null };
  }
}

/** ======= Redis (ioredis) ======= */
let redis: Redis | null = null;
function getRedis(): Redis {
  if (redis) return redis;
  const opts: RedisOptions = {
    host: REDIS_HOST,
    port: Number(REDIS_PORT),
    lazyConnect: true,
    enableAutoPipelining: true,
    maxRetriesPerRequest: 2,
    retryStrategy: (times) => Math.min(times * 200, 2000),
  };
  if (REDIS_PASSWORD) (opts as any).password = REDIS_PASSWORD;
  if (REDIS_TLS?.toLowerCase() === "true") (opts as any).tls = {}; // for TLS-terminating NLB
  redis = new Redis(opts);
  return redis!;
}

async function cache_get(brand: string, country = "sg") {
  const key = `brand:domain:${country.toUpperCase()}#${normalize(brand)}`;
  const client = getRedis();
  if (!client.status || client.status === "end") await client.connect();
  const val = await client.get(key);
  return val ? JSON.parse(val) : { domain: null, confidence: null, evidenceUrls: [] };
}

async function cache_put(body: {
  brand: string; country: string; domain: string; confidence: number;
  evidenceUrls?: string[]; ttlSeconds?: number;
}) {
  const ttl = body.ttlSeconds ?? Number(CACHE_TTL_SECONDS);
  const key = `brand:domain:${body.country.toUpperCase()}#${normalize(body.brand)}`;
  const value = JSON.stringify({
    domain: body.domain,
    confidence: body.confidence,
    evidenceUrls: body.evidenceUrls ?? [],
    updatedAt: Date.now()
  });
  const client = getRedis();
  if (!client.status || client.status === "end") await client.connect();
  await client.set(key, value, "EX", ttl);
  return { ok: true };
}

type TavilyResult = { title?: string; url?: string; content?: string; score?: number };

async function tavilySearch(q: string, max = 8) {
  if (!TAVILY_API_KEY) throw new Error("TAVILY_API_KEY missing");
  const body = {
    api_key: TAVILY_API_KEY,
    query: q,
    include_answer: true,
    include_raw_content: false,
    max_results: Math.min(Math.max(max, 1), 10),
    search_depth: "basic"
  };
  const r = await withTimeout(fetch("https://api.tavily.com/search", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body)
  }), TIMEOUT);
  const data = await r.json();
  const results: TavilyResult[] = (data?.results || []).map((x: any) => ({
    title: x?.title || "",
    url: x?.url || "",
    content: x?.content || x?.snippet || "",
    score: typeof x?.score === "number" ? x.score : undefined
  }));
  return { answer: data?.answer || "", results };
}

async function brand_expand_serp(q: string, country = DEFAULT_COUNTRY) {
  const qn = normalize(q);                         // keep your normalize
  const { results } = await web_search_serp(`${qn} official site`, 8, country);

  // Build candidates from SERP (brand guess from title; include domain/url/title/position)
  const raw = results.map(r => {
    const guessBrand =
      (r.title || qn).split(/[-|–—:·•]/)[0]       // first chunk of title
        .replace(/\bofficial\b|\bwebsite\b|\bsite\b/gi, "")
        .trim() || qn;

    return {
      brand: normalize(guessBrand) || qn,
      domain: r.domain,
      url: r.url,
      title: r.title || "",
      position: typeof r.position === "number" ? r.position : undefined
    };
  });

  // Dedupe by (brand, domain); keep the one with smallest position (i.e., best rank)
  const key = (c: any) => `${c.brand.toLowerCase()}#${c.domain || ""}`;
  const dedup = new Map<string, typeof raw[number]>();
  for (const c of raw) {
    if (!c.domain) continue;                       // candidates must have a domain
    const k = key(c);
    const old = dedup.get(k);
    if (!old || (old.position ?? 9999) > (c.position ?? 9999)) dedup.set(k, c);
  }

  // Sort by position ascending, then shorter domain, then alpha
  const candidates = [...dedup.values()].sort((a, b) =>
    (a.position ?? 9999) - (b.position ?? 9999) ||
    (a.domain.length - b.domain.length) ||
    a.brand.localeCompare(b.brand)
  ).slice(0, 5);

  return { normalized: qn, candidates };
}

/** ======= HTTP router (API Gateway HTTP API or Function URL) ======= */
function getPath(event: any): string {
  return (event?.requestContext?.http?.path || event?.rawPath || event?.path || "/").toLowerCase();
}
function getQS(event: any): Record<string, string> {
  return event?.queryStringParameters || {};
}
async function readJsonBody(event: any): Promise<any> {
  if (!event?.body) return {};
  const isBase64 = event?.isBase64Encoded;
  const raw = isBase64 ? Buffer.from(event.body, "base64").toString("utf8") : event.body;
  try { return JSON.parse(raw); } catch { return {}; }
}
function json(statusCode: number, body: unknown) {
  return { statusCode, headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) };
}
function badRequest(msg: string) { return json(400, { error: msg }); }

// Add this utility near your other helpers
function isBedrockActionEvent(evt: any): boolean {
  return !!(evt && (evt.actionGroup || evt.apiPath || evt.parameters) && !evt.requestContext);
}

function paramsArrayToObject(params: Array<{ name: string, value: string }> = []) {
  const o: Record<string, string> = {};
  for (const p of params) if (p?.name) o[p.name] = String(p.value ?? "");
  return o;
}

// Build the Bedrock-style response envelope
function bedrockJson(statusCode: number, body: unknown, apiPath: string, httpMethod: string, actionGroup?: string, sessionAttributes?: Record<string, string>, promptSessionAttributes?: Record<string, string>) {
  return {
    messageVersion: "1.0",
    response: {
      actionGroup: actionGroup || "brand_tools_action_group",
      apiPath: apiPath,
      httpMethod: httpMethod,
      // You can return multiple content-types; we'll use JSON only
      httpStatusCode: statusCode,
      responseBody: {
        "application/json": {
          body: JSON.stringify(body)
        }
      }
    }
  };
}

/** ======= Lambda handler ======= */
export const handler = async (event: any) => {

  // Bedrock Lambda action group?
  if (isBedrockActionEvent(event)) {
    const apiPath = (event.apiPath || "").toLowerCase();
    const httpMethod = (event.httpMethod || "GET").toUpperCase();
    const sessionAttributes = event.sessionAttributes || {};
    const promptSessionAttributes = event.promptSessionAttributes || {};
    const qs = paramsArrayToObject(event.parameters || []);
    const ag = event.actionGroup;

    try {
      if (apiPath.endsWith("/web_search_serp") && httpMethod === "GET") {
        const q = qs.q || "";
        const num = parseInt(qs.num || "8", 10);
        const country = qs.country || process.env.DEFAULT_COUNTRY || "SG";
        if (!q.trim()) return bedrockJson(400, { error: "q is required" }, apiPath, httpMethod, ag);
        const body = await web_search_serp(q, num, country);
        return bedrockJson(200, body, apiPath, httpMethod, ag, sessionAttributes, promptSessionAttributes);
      }

      if (apiPath.endsWith("/verify_canonical") && httpMethod === "GET") {
        const url = qs.url || "";
        if (!url) return bedrockJson(400, { error: "url is required" }, apiPath, httpMethod, ag);
        const body = await verify_canonical(url);
        return bedrockJson(200, body, apiPath, httpMethod, ag, sessionAttributes, promptSessionAttributes);
      }

      if (apiPath.endsWith("/cache_get") && httpMethod === "GET") {
        if (!process.env.REDIS_HOST) return bedrockJson(400, { error: "Redis not configured" }, apiPath, httpMethod, ag);
        const brand = qs.brand || "";
        const country = qs.country || "SG";
        if (!brand.trim()) return bedrockJson(400, { error: "brand is required" }, apiPath, httpMethod, ag);
        const body = await cache_get(brand, country);
        return bedrockJson(200, body, apiPath, httpMethod, ag, sessionAttributes, promptSessionAttributes);
      }

      if (apiPath.endsWith("/cache_put") && httpMethod === "POST") {
        const bodyObj = typeof event.requestBody?.contentBody === "string"
          ? JSON.parse(event.requestBody.contentBody || "{}")
          : (event.requestBody?.contentBody || {});
        const { brand, country, domain, confidence, evidenceUrls, ttlSeconds } = bodyObj || {};
        if (!brand || !country || !domain || typeof confidence !== "number") {
          return bedrockJson(400, { error: "brand, country, domain, confidence are required" }, apiPath, httpMethod, ag, sessionAttributes, promptSessionAttributes);
        }
        if (!process.env.REDIS_HOST) return bedrockJson(400, { error: "Redis not configured" }, apiPath, httpMethod, ag, sessionAttributes, promptSessionAttributes);
        const res = await cache_put({ brand, country, domain, confidence, evidenceUrls, ttlSeconds });
        return bedrockJson(200, res, apiPath, httpMethod, ag, sessionAttributes, promptSessionAttributes);
      }

      if (apiPath.endsWith("/tavily_search") && httpMethod === "GET") {
        const q = qs.q || "";
        const max = parseInt(qs.max || "8", 10);
        if (!q.trim()) return bedrockJson(400, { error: "q is required" }, apiPath, httpMethod, ag, sessionAttributes, promptSessionAttributes);
        const body = await tavilySearch(q, max);
        return bedrockJson(200, body, apiPath, httpMethod, ag, sessionAttributes, promptSessionAttributes);
      }

      if (apiPath.endsWith("/brand_expand_serp") && httpMethod === "GET") {
        const q = qs.q || "";
        const country = (qs.country || DEFAULT_COUNTRY).toLowerCase();
        if (!q.trim()) return bedrockJson(400, { error: "q is required" }, apiPath, httpMethod, ag, sessionAttributes, promptSessionAttributes);
        const body = await brand_expand_serp(q, country);
        return bedrockJson(200, body, apiPath, httpMethod, ag, sessionAttributes, promptSessionAttributes);
      }

      return bedrockJson(404, { error: "not found" }, apiPath || "/", httpMethod || "GET", ag, sessionAttributes, promptSessionAttributes);
    } catch (e: any) {
      return bedrockJson(500, { error: e?.message || "internal error" }, apiPath || "/", httpMethod || "GET", ag, sessionAttributes, promptSessionAttributes);
    }
  }

  const path = getPath(event);
  const qs = getQS(event);

  try {
    if (path.endsWith("/web_search_serp")) {
      const q = qs.q || "";
      const num = parseInt(qs.num || "8", 10);
      const country = (qs.country || DEFAULT_COUNTRY).toLowerCase();
      if (!q.trim()) return badRequest("q is required");
      const body = await web_search_serp(q, num, country);
      return json(200, body);
    }

    if (path.endsWith("/verify_canonical")) {
      const url = qs.url || "";
      if (!url) return badRequest("url is required");
      const body = await verify_canonical(url);
      return json(200, body);
    }

    if (path.endsWith("/cache_get")) {
      const brand = qs.brand || "";
      const country = qs.country || "sg";
      if (!brand.trim()) return badRequest("brand is required");
      if (!REDIS_HOST) return badRequest("Redis not configured");
      const body = await cache_get(brand, country);
      return json(200, body);
    }

    if (path.endsWith("/cache_put")) {
      const body = await readJsonBody(event);
      const { brand, country, domain, confidence, evidenceUrls, ttlSeconds } = body || {};
      if (!brand || !country || !domain || typeof confidence !== "number") {
        return badRequest("brand, country, domain, confidence are required");
      }
      if (!REDIS_HOST) return badRequest("Redis not configured");
      const res = await cache_put({ brand, country, domain, confidence, evidenceUrls, ttlSeconds });
      return json(200, res);
    }

    if (path.endsWith("/tavily_search")) {
      const q = qs.q || "";
      const max = parseInt(qs.max || "8", 10);
      if (!q.trim()) return badRequest("q is required");
      const body = await tavilySearch(q, max);
      return json(200, body);
    }

    if (path.endsWith("/brand_expand_serp")) {
      const q = qs.q || "";
      const country = (qs.country || DEFAULT_COUNTRY).toLowerCase();
      if (!q.trim()) return badRequest("q is required");
      const body = await brand_expand_serp(q, country);
      return json(200, body);
    }
    return json(404, { error: "not found" });
  } catch (e: any) {
    return json(500, { error: e?.message || "internal error" });
  }
};
