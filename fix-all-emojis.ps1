# Fix All Emoji Encoding Script
Write-Host "Fixing emoji encoding in all posts..." -ForegroundColor Cyan

$files = @(
    "content/posts/2026-01-08-thursday-brief.md",
    "content/posts/2026-01-09-friday-brief.md", 
    "content/posts/2026-01-10-saturday-brief.md",
    "content/about.md"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Fixing: $file" -ForegroundColor Yellow
        
        # Read with proper encoding
        $content = [System.IO.File]::ReadAllText($file, [System.Text.UTF8Encoding]::new($false))
        
        # Fix common broken emoji patterns
        $content = $content -replace 'ðŸ‡¬ðŸ‡¾', '🇬🇾'  # Guyana flag
        $content = $content -replace 'ðŸ', '🏛️'  # Building
        $content = $content -replace 'ðŸŒ‰', '🌉'  # Bridge
        $content = $content -replace 'ðŸ"Š', '📊'  # Chart
        $content = $content -replace 'ðŸŽ¬', '🎬'  # Movie camera
        $content = $content -replace 'ðŸ"¹', '📹'  # Video camera
        $content = $content -replace 'âœ…', '✅'  # Checkmark
        $content = $content -replace 'â­', '⭐'  # Star
        $content = $content -replace 'âš ', '⚠️'  # Warning
        $content = $content -replace 'â°ï¸', '⏱️'  # Stopwatch
        $content = $content -replace 'ðŸ†', '🏆'  # Trophy
        $content = $content -replace 'ðŸš§', '🚧'  # Construction
        $content = $content -replace 'ðŸ'°', '💰'  # Money bag
        $content = $content -replace 'ðŸ"°', '📰'  # Newspaper
        $content = $content -replace 'ðŸ"', '🔥'  # Fire
        $content = $content -replace 'ðŸ"', '📑'  # Bookmark tabs
        $content = $content -replace 'â"', '❓'  # Question mark
        $content = $content -replace 'ðŸ˜‚', '😂'  # Laughing
        $content = $content -replace 'ðŸŽ‰', '🎉'  # Party popper
        $content = $content -replace 'ðŸ"¬', '📬'  # Mailbox
        $content = $content -replace 'ðŸ'¯', '💯'  # 100
        $content = $content -replace 'â', '❌'  # X mark
        
        # Write with proper UTF-8 encoding (no BOM)
        [System.IO.File]::WriteAllText($file, $content, [System.Text.UTF8Encoding]::new($false))
        
        Write-Host "  ✓ Fixed!" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "All emojis fixed! ✅" -ForegroundColor Green
Write-Host "Now run: git add content/posts/*.md content/about.md" -ForegroundColor Cyan
