# Trace where "Guyana Brief" appears on homepage
param([string]$RepoPath = "C:\Users\Staff\guyana-news-blog-RESTORED")

Write-Host "=== Trace 'Guyana Brief' string on homepage ===" -ForegroundColor Cyan
Write-Host ""

# 1. Check hugo config for menu entries
Write-Host "--- 1. hugo.toml / hugo.yaml / config files ---" -ForegroundColor Yellow
Get-ChildItem "$RepoPath" -Include "hugo.toml","hugo.yaml","hugo.yml","config.toml","config.yaml","config.yml" -File -ErrorAction SilentlyContinue | ForEach-Object {
  Write-Host "FILE: $($_.FullName)" -ForegroundColor Gray
  $matches = Select-String -Path $_.FullName -Pattern "Guyana Brief" -SimpleMatch
  if ($matches) {
    $matches | ForEach-Object { Write-Host "  line $($_.LineNumber): $($_.Line.Trim())" }
  } else {
    Write-Host "  no match"
  }
}

# 2. Check all custom layouts
Write-Host ""
Write-Host "--- 2. All layouts (custom) ---" -ForegroundColor Yellow
$hits = Get-ChildItem "$RepoPath\layouts" -Recurse -Include "*.html" -ErrorAction SilentlyContinue | 
  Select-String -Pattern "Guyana Brief" -SimpleMatch
if ($hits) {
  $hits | ForEach-Object { Write-Host "  $($_.Path):$($_.LineNumber): $($_.Line.Trim())" }
} else {
  Write-Host "  no match in custom layouts"
}

# 3. Extract context from homepage HTML around each "Guyana Brief" occurrence
Write-Host ""
Write-Host "--- 3. Context in public/index.html ---" -ForegroundColor Yellow
$homepageHtml = Get-Content "$RepoPath\public\index.html" -Raw -ErrorAction SilentlyContinue
if ($homepageHtml) {
  $pattern = "Guyana Brief"
  $idx = 0
  $count = 0
  while (($pos = $homepageHtml.IndexOf($pattern, $idx)) -ne -1 -and $count -lt 5) {
    $start = [Math]::Max(0, $pos - 80)
    $end = [Math]::Min($homepageHtml.Length, $pos + $pattern.Length + 80)
    $snippet = $homepageHtml.Substring($start, $end - $start) -replace "\s+", " "
    Write-Host ("  [{0}] ...{1}..." -f $count, $snippet)
    $idx = $pos + 1
    $count++
  }
  Write-Host ("  Total occurrences: {0}" -f $count)
}

# 4. Check theme header if partial exists
Write-Host ""
Write-Host "--- 4. PaperMod theme header ---" -ForegroundColor Yellow
$themeHeader = "$RepoPath\themes\PaperMod\layouts\partials\header.html"
if (Test-Path $themeHeader) {
  $hits = Select-String -Path $themeHeader -Pattern "Guyana Brief" -SimpleMatch
  if ($hits) {
    $hits | ForEach-Object { Write-Host "  line $($_.LineNumber): $($_.Line.Trim())" }
  } else {
    Write-Host "  no match in theme header"
  }
}
