$ErrorActionPreference = "Continue"
Set-Location "C:\Users\Staff\guyana-news-blog-RESTORED"

Write-Host "=== Removing stale GitHub Pages workflow ==="
git rm ".github/workflows/deploy.yml"

# If the workflows folder is now empty, remove it too
if ((Test-Path ".github\workflows") -and ((Get-ChildItem ".github\workflows" -Force | Measure-Object).Count -eq 0)) {
  Remove-Item ".github\workflows" -Force
  Write-Host "  Removed empty .github/workflows directory"
}
if ((Test-Path ".github") -and ((Get-ChildItem ".github" -Force | Measure-Object).Count -eq 0)) {
  Remove-Item ".github" -Force
  Write-Host "  Removed empty .github directory"
}

Write-Host ""
Write-Host "=== Commit + push ==="
git add -A
git commit -m "chore: remove stale GitHub Pages deploy workflow. Site has deployed via Netlify (netlify.toml) since the architectural migration; the GitHub Pages workflow tries to publish a non-existent docs folder and fails on every push, generating noise notifications. Netlify deploys are unaffected."
git push

Write-Host ""
Write-Host "=== DONE ==="
