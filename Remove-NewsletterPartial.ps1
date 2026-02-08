# ===============================
# Remove all references to newsletter.html partial
# ===============================

# Root path of your Hugo site
$rootPath = "C:\Users\Staff\guyana-news-blog-RESTORED"

# Find all .html layout files
$layoutFiles = Get-ChildItem -Path "$rootPath\layouts" -Recurse -Include *.html

foreach ($file in $layoutFiles) {
    $content = Get-Content $file.FullName -Raw

    # Replace any line containing 'partial "newsletter.html"' with a comment
    if ($content -match 'partial\s*"newsletter.html"') {
        Write-Host "Modifying $($file.FullName)"
        # Comment out the line(s)
        $newContent = $content -replace '(?m)^(.*partial\s*"newsletter.html".*)$', '{{$1}}' # Keep syntax safe
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
    }
}

Write-Host "✅ All references to newsletter.html partial have been removed or commented out."
