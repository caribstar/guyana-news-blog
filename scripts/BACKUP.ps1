# BACKUP.ps1
# Creates a timestamped backup of the entire site
# Usage: .\scripts\BACKUP.ps1

$RepoPath = "C:\Users\Staff\guyana-news-blog-RESTORED"
$BackupBase = "C:\Users\Staff"
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$BackupPath = Join-Path $BackupBase "guyana-news-blog-BACKUP-$timestamp"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CREATING BACKUP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "Source: $RepoPath" -ForegroundColor Yellow
Write-Host "Backup: $BackupPath" -ForegroundColor Yellow

# Create backup (exclude .git for speed, exclude public folder)
$excludes = @('.git', 'public', 'node_modules', 'resources')

Copy-Item -Path $RepoPath -Destination $BackupPath -Recurse -Force

# Remove excluded folders from backup
foreach ($exclude in $excludes) {
    $excludePath = Join-Path $BackupPath $exclude
    if (Test-Path $excludePath) {
        Remove-Item -Recurse -Force $excludePath -ErrorAction SilentlyContinue
    }
}

# Get backup size
$size = (Get-ChildItem -Path $BackupPath -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  BACKUP COMPLETE" -ForegroundColor Green
Write-Host "  Size: $([math]::Round($size, 2)) MB" -ForegroundColor Green
Write-Host "  Location: $BackupPath" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
