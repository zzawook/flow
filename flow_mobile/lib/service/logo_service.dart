class LogoService {
  String getLogoUrl(String brandDomain) {
    return generateLogoSearchUrl(brandDomain);
  }

  String generateLogoSearchUrl(String brandDomain) {
    String url =
        "https://cdn.brandfetch.io/$brandDomain/fallback/404?c=1idZKCCEynU5Tej88f8";
    return url;
  }
}
