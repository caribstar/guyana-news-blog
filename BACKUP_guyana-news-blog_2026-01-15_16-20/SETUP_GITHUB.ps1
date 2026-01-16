# GitHub Setup Script
Write-Host "`n📦 Setting up GitHub repository..." -ForegroundColor Cyan

$repoUser = Read-Host "Enter your GitHub username"
$repoURL = "https://github.com/$repoUser/guyana-news-blog.git"

Write-Host "`n1️⃣ Initializing Git..." -ForegroundColor Yellow
git init
git add .
git commit -m "Initial commit from backup"

Write-Host "`n2️⃣ Creating main branch..." -ForegroundColor Yellow
git branch -M main

Write-Host "`n3️⃣ Connecting to GitHub..." -ForegroundColor Yellow
Write-Host "⚠️  Make sure repo exists: https://github.com/$repoUser/guyana-news-blog" -ForegroundColor Red
Read-Host "Press Enter when ready"

git remote add origin $repoURL
git push -u origin main

Write-Host "`n✅ Done! Your site is now on GitHub!" -ForegroundColor Green
Write-Host "Visit: https://github.com/$repoUser/guyana-news-blog`n" -ForegroundColor Cyan
