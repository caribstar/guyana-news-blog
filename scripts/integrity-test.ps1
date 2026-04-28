# Content Integrity Test v2
# Smarter: distinguishes content contamination from metadata references

param(
  [string]$RepoPath = "C:\Users\Staff\guyana-news-blog-RESTORED"
)

$ErrorActionPreference = "Continue"
$errors = 0

Write-Host "========================================" -ForegroundColor Yellow
Write-Host "CONTENT INTEGRITY TEST v2" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow

$countryNetwork = @("Guyana Brief", "Yard Brief", "Trini Brief", "Bajan Brief", "Ghana Brief", "Naija Brief", "Kenya Brief", "SA Brief")
$gdbFamily = @("Daily Brief", "Uncle Ramesh", "Caribbean Brief")

# ----- Helper: extract body-only content, strip head/meta/structured-data -----
function Get-BodyContent($html) {
  if (-not $html) { return "" }
  # Remove <head>...</head> (case-insensitive)
  $body = $html -replace '(?is)<head[^>]*>.*?</head>', ''
  # Remove all <script>...</script> (structured data lives here on some builds)
  $body = $body -replace '(?is)<script[^>]*>.*?</script>', ''
  # Remove <style>...</style>
  $body = $body -replace '(?is)<style[^>]*>.*?</style>', ''
  # Remove any inline JSON-LD blocks that slipped through
  $body = $body -replace '(?is)<script\s+type=["'']application/ld\+json["''][^>]*>.*?</script>', ''
  # Remove nav + footer (shared chrome with nav links)
  $body = $body -replace '(?is)<nav[^>]*>.*?</nav>', ''
  $body = $body -replace '(?is)<footer[^>]*>.*?</footer>', ''
  return $body
}

# Test 1: Homepage leak - CONTENT AREA ONLY (not meta/script/nav/footer)
Write-Host ""
Write-Host "TEST 1: Homepage satire leak (content area only)" -ForegroundColor Cyan
if (Test-Path "$RepoPath\public\index.html") {
  $homepageHtml = Get-Content "$RepoPath\public\index.html" -Raw
  if (-not $homepageHtml) {
    Write-Host "  SKIP: homepage empty" -ForegroundColor Yellow
  } else {
    $body = Get-BodyContent $homepageHtml
    Write-Host ("  Loaded: {0} chars total, {1} chars after stripping head/nav/footer/scripts" -f $homepageHtml.Length, $body.Length) -ForegroundColor Gray
    
    $leaks = @()
    foreach ($cn in $countryNetwork) {
      if ($body -match [regex]::Escape($cn)) { $leaks += $cn }
    }
    if ($leaks.Count -gt 0) {
      Write-Host ("  FAIL: Satire categories in content area: {0}" -f ($leaks -join ', ')) -ForegroundColor Red
      $errors++
    } else {
      Write-Host "  PASS: No satire categories in content area" -ForegroundColor Green
    }

    $satirePhrases = @("Mi Soon Come", "Taxi Driver Confirms", "Generator Becomes", "No Wahala", "Oil Money Will Definitely", "Dancehall Artist Releases", "Tuko Njiani", "Cousin Leroy", "Miss Violet", "Bajan Bugle", "Yard Report", "Trini Dispatch", "Auntie Cheryl")
    $titleLeaks = @()
    foreach ($p in $satirePhrases) {
      if ($body -match [regex]::Escape($p)) { $titleLeaks += $p }
    }
    if ($titleLeaks.Count -gt 0) {
      Write-Host ("  FAIL: Satire phrases in content: {0}" -f ($titleLeaks -join ', ')) -ForegroundColor Red
      $errors++
    } else {
      Write-Host "  PASS: No satire phrases in content" -ForegroundColor Green
    }
  }
} else {
  Write-Host "  SKIP: public/index.html not found. Run hugo first." -ForegroundColor Yellow
}

# Test 1b: Brand consistency (JSON-LD matches hugo.toml)
Write-Host ""
Write-Host "TEST 1b: Brand consistency (JSON-LD matches site config)" -ForegroundColor Cyan
$configTitle = ""
if (Test-Path "$RepoPath\hugo.toml") {
  $config = Get-Content "$RepoPath\hugo.toml" -Raw
  if ($config -match '(?m)^\s*title\s*=\s*"([^"]+)"') {
    $configTitle = $matches[1]
  }
}
if ($configTitle -and (Test-Path "$RepoPath\public\index.html")) {
  $hp = Get-Content "$RepoPath\public\index.html" -Raw
  if ($hp -match '(?s)<script[^>]+application/ld\+json[^>]*>(.+?)</script>') {
    $jsonld = $matches[1]
    if ($jsonld -match '"name"\s*:\s*"([^"]+)"') {
      $jsonldName = $matches[1]
      if ($jsonldName -eq $configTitle -or $jsonldName -eq ($configTitle -replace '^The ', '')) {
        Write-Host ("  PASS: JSON-LD name '{0}' matches config '{1}'" -f $jsonldName, $configTitle) -ForegroundColor Green
      } else {
        Write-Host ("  FAIL: JSON-LD name '{0}' != config title '{1}'" -f $jsonldName, $configTitle) -ForegroundColor Red
        $errors++
      }
    }
  }
}

# Test 2: Schema completeness
Write-Host ""
Write-Host "TEST 2: Schema completeness" -ForegroundColor Cyan
$allPosts = Get-ChildItem "$RepoPath\content\posts\*.md" -ErrorAction SilentlyContinue
$noTone = ($allPosts | Where-Object { (Get-Content $_.FullName -Raw) -notmatch '(?m)^tone:' }).Count
if ($noTone -gt 0) {
  Write-Host ("  WARN: {0} posts lack tone field" -f $noTone) -ForegroundColor Yellow
} else {
  Write-Host "  PASS: All posts have tone field" -ForegroundColor Green
}

# Test 3: Ghost category detection
Write-Host ""
Write-Host "TEST 3: Ghost category detection" -ForegroundColor Cyan
$ghostCount = ($allPosts | Where-Object {
  $raw = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
  $raw -match '"Jamaica Brief"'
}).Count
if ($ghostCount -gt 0) {
  Write-Host ("  FAIL: {0} posts still use 'Jamaica Brief'" -f $ghostCount) -ForegroundColor Red
  $errors++
} else {
  Write-Host "  PASS: No 'Jamaica Brief' ghost posts" -ForegroundColor Green
}

# Test 4: Country field on satire posts
Write-Host ""
Write-Host "TEST 4: Country Network posts have country field" -ForegroundColor Cyan
$satirePosts = $allPosts | Where-Object {
  $raw = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
  $m = $false
  foreach ($cn in $countryNetwork) {
    if ($raw -match [regex]::Escape('"' + $cn + '"')) { $m = $true; break }
  }
  $m
}
$noCountry = ($satirePosts | Where-Object { (Get-Content $_.FullName -Raw) -notmatch '(?m)^country:' }).Count
if ($noCountry -gt 0) {
  Write-Host ("  WARN: {0} Country Network posts lack country field" -f $noCountry) -ForegroundColor Yellow
} else {
  Write-Host ("  PASS: All {0} Country Network posts have country field" -f $satirePosts.Count) -ForegroundColor Green
}

# Test 5: Country page isolation (content area only)
Write-Host ""
Write-Host "TEST 5: Country page isolation (content area)" -ForegroundColor Cyan
$countryPageMap = @{
  "guyana"       = "Guyana Brief"
  "jamaica"      = "Yard Brief"
  "trinidad"     = "Trini Brief"
  "barbados"     = "Bajan Brief"
  "ghana"        = "Ghana Brief"
  "nigeria"      = "Naija Brief"
  "kenya"        = "Kenya Brief"
  "south-africa" = "SA Brief"
}
$crossLeaks = 0
foreach ($slug in $countryPageMap.Keys) {
  $pagePath = "$RepoPath\public\$slug\index.html"
  if (Test-Path $pagePath) {
    $pageHtml = Get-Content $pagePath -Raw
    $pageBody = Get-BodyContent $pageHtml
    $ownCat = $countryPageMap[$slug]
    foreach ($cn in $countryNetwork) {
      if ($cn -ne $ownCat -and $pageBody -match [regex]::Escape($cn)) {
        Write-Host ("  FAIL: /{0}/ contains '{1}' in content" -f $slug, $cn) -ForegroundColor Red
        $crossLeaks++
      }
    }
  }
}
if ($crossLeaks -eq 0) {
  Write-Host "  PASS: No country page cross-contamination in content" -ForegroundColor Green
} else {
  $errors += $crossLeaks
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
if ($errors -eq 0) {
  Write-Host ("INTEGRITY TEST PASSED ({0} errors)" -f $errors) -ForegroundColor Green
} else {
  Write-Host ("INTEGRITY TEST FAILED ({0} errors)" -f $errors) -ForegroundColor Red
}
Write-Host "========================================" -ForegroundColor Yellow
exit $errors
