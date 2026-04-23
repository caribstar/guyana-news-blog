# run-retrofit.ps1 — unblocks itself and runs retrofit + integrity
param(
  [string]$RepoPath = "C:\Users\Staff\guyana-news-blog-RESTORED"
)

Set-Location $RepoPath

Write-Host "--- Unblocking scripts ---" -ForegroundColor Yellow
Get-ChildItem "$RepoPath\*.ps1" | Unblock-File
Get-ChildItem "$RepoPath\*.py" | Unblock-File

Write-Host ""
Write-Host "--- Running retrofit v2 ---" -ForegroundColor Yellow
python retrofit_posts.py $RepoPath

Write-Host ""
Write-Host "--- Rebuilding ---" -ForegroundColor Yellow
taskkill /F /IM hugo.exe 2>$null | Out-Null
Remove-Item "$RepoPath\public" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$RepoPath\resources\_gen" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$RepoPath\.hugo_build.lock" -Force -ErrorAction SilentlyContinue
hugo --buildFuture

Write-Host ""
Write-Host "--- Running integrity test ---" -ForegroundColor Yellow
& "$RepoPath\integrity-test.ps1" -RepoPath $RepoPath
