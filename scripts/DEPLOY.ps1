# DEPLOY.ps1
# Clean build and deploy to GitHub Pages
# Usage: .\scripts\DEPLOY.ps1 -Message "Your commit message"

param(
    [string]$Message = "Update site"
)

$RepoPath = "C:\Users\Staff\guyana-news-blog-RESTORED"
Set-Location $RepoPath

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  GUYANA DAILY BRIEF - DEPLOY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Step 1: Validate recent posts
Write-Host "[1/7] Validating recent posts..." -ForegroundColor Yellow
$recentPosts = Get-ChildItem "content\posts\*.md" | Sort-Object LastWriteTime -Descending | Select-Object -First 5
$warnings = @()

foreach ($post in $recentPosts) {
    $content = Get-Content $post.FullName -Head 10
    $contentStr = $content -join "`n"
    
    # Check for timestamp in date
    if ($contentStr -match 'date:.*T\d{2}:\d{2}') {
        $warnings += "WARNING: $($post.Name) has timestamp in date"
    }
    
    # Check for YAML list format (multi-line categories)
    if ($contentStr -match 'categories:\s*$') {
        $warnings += "WARNING: $($post.Name) uses YAML list format for categories"
    }
}

if ($warnings.Count -gt 0) {
    foreach ($w in $warnings) {
        Write-Host "  $w" -ForegroundColor Yellow
    }
    Write-Host "  Run .\scripts\FIX-FRONTMATTER.ps1 first" -ForegroundColor Yellow
}
else {
    Write-Host "  All recent posts validated OK" -ForegroundColor Green
}

# Step 2: Clean public folder
Write-Host "[2/7] Cleaning old build..." -ForegroundColor Yellow
if (Test-Path "public") {
    Remove-Item -Recurse -Force "public"
}

# Step 3: Clean root-level build artifacts
Write-Host "[3/7] Cleaning root artifacts..." -ForegroundColor Yellow
Get-ChildItem -Path $RepoPath -File | Where-Object { 
    $_.Extension -in @('.html', '.xml', '.json') -and $_.Name -ne 'hugo.toml' -and $_.Name -ne 'config.toml'
} | Remove-Item -Force -ErrorAction SilentlyContinue

$buildFolders = @('categories', 'tags', 'posts', 'magazine', 'dueling', 'roundup', 'search', 'legal', 'success', 'about', 'assets')
foreach ($folder in $buildFolders) {
    $folderPath = Join-Path $RepoPath $folder
    if (Test-Path $folderPath) {
        Remove-Item -Recurse -Force $folderPath -ErrorAction SilentlyContinue
    }
}

# Step 4: Build with Hugo
Write-Host "[4/7] Building site..." -ForegroundColor Yellow
hugo
if ($LASTEXITCODE -ne 0) {
    Write-Host "Hugo build failed!" -ForegroundColor Red
    exit 1
}

# Step 5: Copy public to root
Write-Host "[5/7] Copying to root..." -ForegroundColor Yellow
Copy-Item -Path "public\*" -Destination "." -Recurse -Force

# Step 6: Git add
Write-Host "[6/7] Staging changes..." -ForegroundColor Yellow
git add -A 2>$null

# Step 7: Commit and push
Write-Host "[7/7] Deploying to GitHub..." -ForegroundColor Yellow
git commit -m $Message 2>$null
git push 2>$null

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  DEPLOYED! Live in ~2 minutes" -ForegroundColor Green
Write-Host "  https://guyanadailybrief.com" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
