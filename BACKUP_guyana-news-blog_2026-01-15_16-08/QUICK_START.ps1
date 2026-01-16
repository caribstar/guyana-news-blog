# Quick Start Script
Write-Host "`n🇬🇾 GUYANA DAILY BRIEF - QUICK START" -ForegroundColor Green
Write-Host "`n1️⃣ Testing Hugo installation..." -ForegroundColor Cyan
hugo version
Write-Host "`n2️⃣ Building site..." -ForegroundColor Cyan
hugo --gc --minify
Write-Host "`n3️⃣ Starting local server..." -ForegroundColor Cyan
Write-Host "Visit: http://localhost:1313/" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop`n" -ForegroundColor White
hugo server -D
