# Manually classify the 2 remaining unclassifiable posts
param(
  [string]$RepoPath = "C:\Users\Staff\guyana-news-blog-RESTORED"
)

Write-Host "=== Inspecting 2 stragglers ===" -ForegroundColor Cyan

$f1 = Join-Path $RepoPath "content\posts\2026-01-16-guyanese-horizon-georgetown.md"
if (Test-Path $f1) {
  Write-Host ""
  Write-Host "FILE 1: 2026-01-16-guyanese-horizon-georgetown.md" -ForegroundColor Yellow
  Write-Host "  (has empty categories: [])"
  Get-Content $f1 -TotalCount 15 | ForEach-Object { Write-Host "  $_" }
}

$f2 = Join-Path $RepoPath "content\posts\daily-brief-2026-01-24.md"
if (Test-Path $f2) {
  Write-Host ""
  Write-Host "FILE 2: daily-brief-2026-01-24.md" -ForegroundColor Yellow
  Write-Host "  (no frontmatter, no matching filename pattern)"
  Get-Content $f2 -TotalCount 15 | ForEach-Object { Write-Host "  $_" }
}

Write-Host ""
Write-Host "=== If these are GDB posts, patch them: ===" -ForegroundColor Yellow
Write-Host "Run this after inspecting:"
Write-Host '  python fix-stragglers.py "' $RepoPath '"'
