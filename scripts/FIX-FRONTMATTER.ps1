# FIX-FRONTMATTER.ps1
# Fixes date format and category/tag arrays in all posts
# Preserves line breaks properly

$RepoPath = "C:\Users\Staff\guyana-news-blog-RESTORED"
$PostsPath = Join-Path $RepoPath "content\posts"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  FIX FRONTMATTER IN ALL POSTS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$fixedCount = 0
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

Get-ChildItem "$PostsPath\*.md" | ForEach-Object {
    $file = $_
    $lines = [System.IO.File]::ReadAllLines($file.FullName, [System.Text.Encoding]::UTF8)
    $modified = $false
    $newLines = @()
    $inFrontmatter = $false
    $frontmatterCount = 0
    $currentKey = ""
    $collectingArray = $false
    $arrayItems = @()
    
    foreach ($line in $lines) {
        # Track frontmatter boundaries
        if ($line -eq "---") {
            $frontmatterCount++
            $inFrontmatter = ($frontmatterCount -eq 1)
            
            # If we were collecting an array, output it now
            if ($collectingArray -and $arrayItems.Count -gt 0) {
                $arrayStr = '["' + ($arrayItems -join '", "') + '"]'
                $newLines += "${currentKey}: $arrayStr"
                $collectingArray = $false
                $arrayItems = @()
                $modified = $true
            }
            
            $newLines += $line
            continue
        }
        
        if ($inFrontmatter) {
            # Fix date with timestamp -> simple date
            if ($line -match '^date:\s*(\d{4}-\d{2}-\d{2})T') {
                $newLines += "date: $($Matches[1])"
                $modified = $true
                continue
            }
            
            # Check if this is start of a YAML list (categories: or tags: followed by nothing or whitespace)
            if ($line -match '^(categories|tags):\s*$') {
                $currentKey = $Matches[1]
                $collectingArray = $true
                $arrayItems = @()
                continue
            }
            
            # Check if this is a YAML list item
            if ($collectingArray -and $line -match '^\s+-\s*"?([^"]+)"?\s*$') {
                $arrayItems += $Matches[1].Trim()
                continue
            }
            
            # If we hit a non-list line while collecting, output the array
            if ($collectingArray -and $line -notmatch '^\s+-') {
                if ($arrayItems.Count -gt 0) {
                    $arrayStr = '["' + ($arrayItems -join '", "') + '"]'
                    $newLines += "${currentKey}: $arrayStr"
                    $modified = $true
                }
                $collectingArray = $false
                $arrayItems = @()
            }
            
            # Pass through other frontmatter lines
            $newLines += $line
        }
        else {
            # Outside frontmatter, pass through unchanged
            $newLines += $line
        }
    }
    
    if ($modified) {
        $content = $newLines -join "`n"
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
        Write-Host "  Fixed: $($file.Name)" -ForegroundColor Green
        $fixedCount++
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Fixed $fixedCount files" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Now run: .\scripts\DEPLOY.ps1" -ForegroundColor Yellow
