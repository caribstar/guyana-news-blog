# FINAL EMOJI FIX - Writes files with proper UTF-8 encoding
# This bypasses all Windows encoding corruption

cd C:\Users\Staff\guyana-news-blog

Write-Host "Creating clean files with proper UTF-8..." -ForegroundColor Cyan

# Read the broken files
$thursday = Get-Content "content\posts\2026-01-08-thursday-brief.md" -Raw
$friday = Get-Content "content\posts\2026-01-09-friday-brief.md" -Raw  
$saturday = Get-Content "content\posts\2026-01-10-saturday-brief.md" -Raw

# Fix ALL broken emoji patterns
$fixes = @{
    'ðŸ‡¬ðŸ‡¾' = '🇬🇾'
    'ðŸ"Š' = '📊'
    'ðŸ'¯' = '💯'
    'ðŸ"¥' = '🔥'
    'âš°ï¸' = '⚰️'
    'ðŸŽ­' = '🎭'
    'ðŸŽ¬' = '🎬'
    'ðŸ"¹' = '📹'
    'âœ…' = '✅'
    'â­' = '⭐'
    'âš ' = '⚠️'
    'â°ï¸' = '⏱️'
    'ðŸ†' = '🏆'
    'ðŸš§' = '🚧'
    'ðŸ'°' = '💰'
    'ðŸ"°' = '📰'
    'ðŸ"' = '📑'
    'â"' = '❓'
    'ðŸ˜‚' = '😂'
    'ðŸŽ‰' = '🎉'
    'ðŸ"¬' = '📬'
    'â' = '❌'
    'ðŸ'¥' = '💥'
    'ðŸŒ‰' = '🌉'
    'ðŸ ' = '🏛️'
    'ðŸ"œ' = '📜'
    'ðŸš¨' = '🚨'
    'ðŸŽª' = '🎪'
    'ðŸ"§' = '🔧'
    'ðŸ—£ï¸' = '📣'
    'ðŸ›ï¸' = '🏛️'
    'ðŸ›£ï¸' = '🛣️'
    'ðŸ"‹' = '📋'
    'ðŸ"„' = '🔄'
    'ðŸ"±' = '📱'
    'ðŸŽ"' = '🎓'
    'ðŸŒ¾' = '🌾'
    'ðŸ'¸' = '💸'
    'ðŸŽ¯' = '🎯'
    'ðŸ"š' = '📚'
    'ðŸ"®' = '🔮'
    'â˜ï¸' = '☀️'
    'ðŸŒ§ï¸' = '🌧️'
    'â›ˆï¸' = '⛈️'
    'ðŸŒ©ï¸' = '🌩️'
    'âš¡' = '⚡'
    'ðŸ"¦' = '📦'
    'âš–ï¸' = '⚖️'
    'ðŸ¤"' = '🤔'
    'ðŸ«' = '🏫'
    'â†'' = '→'
    'â¬†ï¸' = '⬆️'
    'â¬‡ï¸' = '⬇️'
    'ðŸŽ¥' = '🎥'
    'ðŸ—ï¸' = '🗝️'
    'ðŸŒŸ' = '🌟'
    'ðŸ"ž' = '📞'
    'ðŸ'­' = '💭'
    'ðŸ"ˆ' = '📈'
}

foreach ($pattern in $fixes.Keys) {
    $thursday = $thursday -replace [regex]::Escape($pattern), $fixes[$pattern]
    $friday = $friday -replace [regex]::Escape($pattern), $fixes[$pattern]
    $saturday = $saturday -replace [regex]::Escape($pattern), $fixes[$pattern]
}

# Write with UTF-8 no BOM
$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText("$PWD\content\posts\2026-01-08-thursday-brief.md", $thursday, $utf8)
[System.IO.File]::WriteAllText("$PWD\content\posts\2026-01-09-friday-brief.md", $friday, $utf8)
[System.IO.File]::WriteAllText("$PWD\content\posts\2026-01-10-saturday-brief.md", $saturday, $utf8)

Write-Host "Files fixed with proper UTF-8!" -ForegroundColor Green
Write-Host ""
Write-Host "Committing to git..." -ForegroundColor Cyan

git add content/posts/*.md
git commit -m "FINAL FIX: Replace all broken emojis with proper UTF-8"
git push origin main

Write-Host ""
Write-Host "DONE! Check site in 2 minutes!" -ForegroundColor Green
Write-Host "Homepage: https://guyanadailybrief.com" -ForegroundColor White
