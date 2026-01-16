# ===============================
# Automated Hugo Build & Git Push
# ===============================

Write-Host "`n🚀 Building Hugo site..." -ForegroundColor Cyan

# Build the Hugo site (output goes to public/)
hugo --gc --minify
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Hugo build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`n📝 Staging content changes..." -ForegroundColor Yellow

# Suppress CRLF warnings
git config core.autocrlf true
git config advice.addIgnoredFile false

# Stage all source files (layouts, content, static, etc.)
git add -u
git add layouts
git add content
git add static
git add hugo.toml

# Commit with a default message
$commitMessage = "AUTO: Hugo site updated $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git commit -m $commitMessage 2>$null

# Push to remote
Write-Host "`n📤 Pushing to remote repository..." -ForegroundColor Yellow
git push origin main

Write-Host "`n✅ Done! Hugo site built and content pushed." -ForegroundColor Green
