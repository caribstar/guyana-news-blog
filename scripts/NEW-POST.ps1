# NEW-POST.ps1
# Creates a new post with correct frontmatter format
# Usage: .\scripts\NEW-POST.ps1 -Type "brief" -Title "Your Title"

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("brief", "ramesh", "speedeet", "deboys", "rumor", "progress", "roadblock", "patriots", "bamsally", "backatruck", "bounty")]
    [string]$Type,
    
    [Parameter(Mandatory=$true)]
    [string]$Title
)

$RepoPath = "C:\Users\Staff\guyana-news-blog-RESTORED"
$PostsPath = Join-Path $RepoPath "content\posts"
$today = Get-Date -Format "yyyy-MM-dd"
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# Define templates for each type
$templates = @{
    "brief" = @{
        filename = "$today-daily-brief.md"
        categories = '["Daily Brief", "News"]'
        tags = '["Guyana", "News", "Satire"]'
    }
    "ramesh" = @{
        filename = "$today-uncle-ramesh-take.md"
        categories = '["Uncle Ramesh", "Opinion"]'
        tags = '["Guyana", "Diaspora", "Pro-Government"]'
    }
    "speedeet" = @{
        filename = "$today-speedeet-wilar.md"
        categories = '["Speedeet and Wilar", "Fiction"]'
        tags = '["Guyana", "Youth", "Adventure"]'
    }
    "deboys" = @{
        filename = "$today-de-boys-seh.md"
        categories = '["De Boys Seh", "Commentary"]'
        tags = '["Guyana", "Street Talk", "Opinion"]'
    }
    "rumor" = @{
        filename = "$today-rumor-mill.md"
        categories = '["Bam-Bam Sally", "Rumor Mill"]'
        tags = '["Guyana", "Rumors", "Satire"]'
    }
    "progress" = @{
        filename = "$today-progress-report.md"
        categories = '["Government Progress", "Weekly"]'
        tags = '["Guyana", "Government", "Infrastructure"]'
    }
    "roadblock" = @{
        filename = "$today-dj-roadblock.md"
        categories = '["DJ Roadblock", "Traffic"]'
        tags = '["Guyana", "Traffic", "Georgetown"]'
    }
    "patriots" = @{
        filename = "$today-patriots-portfolio.md"
        categories = '["Patriots Portfolio", "Profiles"]'
        tags = '["Guyana", "Citizens", "Profiles"]'
    }
    "bamsally" = @{
        filename = "$today-bam-bam-sally.md"
        categories = '["Bam-Bam Sally", "Weekly"]'
        tags = '["Guyana", "Rumors", "Entertainment"]'
    }
    "backatruck" = @{
        filename = "$today-back-a-truck.md"
        categories = '["Back-a-Truck", "Reader Submissions"]'
        tags = '["Guyana", "Reader Content", "Community"]'
    }
    "bounty" = @{
        filename = "$today-bounty-board.md"
        categories = '["Bounty Board", "Uncle Ramesh"]'
        tags = '["Guyana", "Diaspora", "Community"]'
    }
}

$template = $templates[$Type]
$filePath = Join-Path $PostsPath $template.filename

$content = @"
---
title: "$Title"
date: $today
draft: false
categories: $($template.categories)
tags: $($template.tags)
---

<!-- Your content here -->

"@

[System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)

Write-Host ""
Write-Host "Created: $($template.filename)" -ForegroundColor Green
Write-Host "Path: $filePath" -ForegroundColor Cyan
Write-Host ""
Write-Host "Edit the file to add your content, then run:" -ForegroundColor Yellow
Write-Host "  .\scripts\DEPLOY.ps1 -Message 'Added $Type post'" -ForegroundColor Yellow
