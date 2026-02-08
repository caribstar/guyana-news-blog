Write-Host "`n🔄 RESTORING GUYANA DAILY BRIEF" -ForegroundColor Cyan

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = Read-Host "Enter restore destination (e.g. C:\Projects\guyana-news-blog)"

if (-not (Test-Path $target)) {
    New-Item -ItemType Directory -Path $target | Out-Null
}

Write-Host "`n📁 Restoring files..." -ForegroundColor Yellow
Copy-Item "$root\content"  "$target\content" -Recurse -Force
Copy-Item "$root\layouts"  "$target\layouts" -Recurse -Force
Copy-Item "$root\static"   "$target\static" -Recurse -Force
Copy-Item "$root\themes"   "$target\themes" -Recurse -Force
Copy-Item "$root\hugo.toml" "$target\hugo.toml" -Force
Copy-Item "$root\hugo-push.ps1" "$target\hugo-push.ps1" -Force
Copy-Item "$root\.gitignore" "$target\.gitignore" -Force

Write-Host "`n✅ Restore complete!" -ForegroundColor Green
Write-Host "`n🚀 Starting Hugo server..." -ForegroundColor Cyan
Set-Location $target
hugo server -D
