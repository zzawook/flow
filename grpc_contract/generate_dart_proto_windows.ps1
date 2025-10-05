# generate_dart_proto_windows.ps1
$ErrorActionPreference = 'Stop'

# 1) Ensure Dart protoc_plugin is available and add it to PATH for this session
Write-Host "Activating protoc_plugin 22.5.0 for Dart..."
dart pub global activate protoc_plugin 22.5.0 | Out-Null

$pubCache = if ($env:PUB_CACHE) { $env:PUB_CACHE } else { Join-Path $env:LOCALAPPDATA 'Pub\Cache' }
$pubBin   = Join-Path $pubCache 'bin'
if (-not (Test-Path $pubBin)) {
  Write-Host "WARN: Expected pub bin at $pubBin not found; protoc may not see protoc-gen-dart."
}
$env:Path = "$env:Path;$pubBin"

# 2) Paths / variables (match your original intent)
$OUT        = "..\flow_mobile\lib\generated"
$PROTO_ROOT = "."
New-Item -ItemType Directory -Force -Path $OUT | Out-Null

# 3) Find protoc and try to infer the include folder for well-known types (WKT)
$protocCmd = Get-Command protoc -ErrorAction SilentlyContinue
if (-not $protocCmd) {
  throw "protoc not found on PATH. Install protoc and ensure protoc.exe is on PATH."
}

$wktDirCandidates = @(
  $env:PROTOC_INCLUDE,                                                        # user override
  (Join-Path (Split-Path $protocCmd.Path -Parent) 'include'),                 # alongside protoc.exe
  (Join-Path $env:ProgramFiles 'protoc\include'),                             # common manual install
  (Join-Path $env:ChocolateyInstall 'lib\protobuf\tools\chocolatey\include')  # Chocolatey layout
) | Where-Object { $_ -and (Test-Path $_) }

$WKT_DIR = if ($wktDirCandidates.Count -gt 0) { $wktDirCandidates[0] } else { $null }
if ($null -eq $WKT_DIR) {
  Write-Host "WARN: Could not auto-detect WKT include directory. If you import google/protobuf/*.proto, set PROTOC_INCLUDE or edit this script."
}

# 4) Collect all .proto files in the repo
$allProtos = Get-ChildItem -Path $PROTO_ROOT -Recurse -Filter *.proto | ForEach-Object { $_.FullName }

# 5) (Optional) Collect referenced WKT files like google/protobuf/timestamp.proto, etc.
#    protoc doesn't require them as explicit inputs, just needs the include path.
#    This block keeps parity with your bash script that appended $WKT to the input list.
$wktFiles = @()
if ($WKT_DIR) {
  $wktPattern = 'google/protobuf/[a-z_]*\.proto'
  $wktMatches = Select-String -Path $allProtos -Pattern $wktPattern -AllMatches |
    ForEach-Object { $_.Matches.Value } | Sort-Object -Unique

  foreach ($rel in $wktMatches) {
    $candidate = Join-Path $WKT_DIR $rel
    if (Test-Path $candidate) { $wktFiles += $candidate }
  }
}

# 6) Single call covering all protos (+ WKT include if available)
Write-Host "Running protoc for all protos (this may take a moment)..."
$includeArgs = @('-I', $PROTO_ROOT)
if ($WKT_DIR) { $includeArgs += @('-I', $WKT_DIR) }

& protoc @includeArgs --dart_out=grpc:$OUT @allProtos @wktFiles

# 7) Additional explicit calls you had in the bash script (kept for parity).
#    Wildcards are expanded via Get-ChildItem to avoid quoting issues on Windows.
Write-Host "Running explicit package protoc invocations (parity with bash script)..."
& protoc -I . --dart_out=grpc:$OUT account/v1/account.proto
& protoc -I . --dart_out=grpc:$OUT auth/v1/auth.proto

$commonProtos = Get-ChildItem -Path "common/v1" -Filter *.proto -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }
if ($commonProtos.Count -gt 0) {
  & protoc -I . --dart_out=grpc:$OUT @commonProtos
}

& protoc -I . --dart_out=grpc:$OUT refresh/v1/refresh.proto
& protoc -I . --dart_out=grpc:$OUT transaction_history/v1/transaction_history.proto
& protoc -I . --dart_out=grpc:$OUT transfer/v1/transfer.proto
& protoc -I . --dart_out=grpc:$OUT user/v1/user.proto

Write-Host "Done. Generated Dart files are in: $OUT"
