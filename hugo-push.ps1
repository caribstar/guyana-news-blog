# ================================
# Hugo Auto Build & Git Push Script
# ================================

# --- Step 0: Git line ending config ---
git config --global core.autocrlf input

# --- Step 1: Build Hugo site ---
Write-Host "`n🚀 Building Hugo site..." -ForegroundColor Cyan
hugo

# --- Step 2: Stage content changes only (ignore public/) ---
Write-Host "`n📝 Staging content changes..." -ForegroundColor Yellow
git add -A :!public

# --- Step 3: Commit changes ---
$commitMessage = Read-Host "Enter commit message"
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Update Hugo content/templates"
}

git commit -m "$commitMessage"

# --- Step 4: Push to remote ---
Write-Host "`n📤 Pushing to remote repository..." -ForegroundColor Green
git push

Write-Host "`n✅ Done! Hugo site built and content pushed." -ForegroundColor Cyan
