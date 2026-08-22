param([Parameter(Mandatory=$true)][string]$ProjectDir)
$ErrorActionPreference = 'Stop'
$overlayDir = Join-Path $env:GITHUB_WORKSPACE '.github\v075-overlay'
$appDir = Join-Path $ProjectDir 'app'
Copy-Item (Join-Path $overlayDir 'v075-store-confirm-fix.js') (Join-Path $appDir 'v075-store-confirm-fix.js') -Force
Copy-Item (Join-Path $overlayDir 'v075-store-confirm-fix.css') (Join-Path $appDir 'v075-store-confirm-fix.css') -Force
$indexPath = Join-Path $appDir 'index.html'
$index = Get-Content -LiteralPath $indexPath -Raw -Encoding UTF8
$index = $index.Replace('0.7.4','0.7.5')
if (-not $index.Contains('v075-store-confirm-fix.css')) {
  $index = $index.Replace('</head>', '<link rel="stylesheet" href="v075-store-confirm-fix.css"></head>')
}
if (-not $index.Contains('v075-store-confirm-fix.js')) {
  $index = $index.Replace('</body>', '<script src="v075-store-confirm-fix.js"></script></body>')
}
Set-Content -LiteralPath $indexPath -Value $index -Encoding UTF8
$pkgPath = Join-Path $ProjectDir 'package.json'
$pkg = Get-Content -LiteralPath $pkgPath -Raw -Encoding UTF8 | ConvertFrom-Json
$pkg.version = '0.7.5'
$pkg | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $pkgPath -Encoding UTF8
foreach ($rel in @('settings.html','release-manifest.example.json','README.md')) {
  $p = Join-Path $ProjectDir $rel
  if (Test-Path $p) {
    $t = Get-Content -LiteralPath $p -Raw -Encoding UTF8
    $t = $t.Replace('0.7.4','0.7.5')
    Set-Content -LiteralPath $p -Value $t -Encoding UTF8
  }
}
Write-Host 'Applied v0.7.5 store-confirm overlay.'
