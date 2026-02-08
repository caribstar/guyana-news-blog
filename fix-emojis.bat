@echo off
chcp 65001 > nul
echo Fixing emoji encoding...
powershell -Command "$files=@('content/posts/2026-01-08-thursday-brief.md','content/posts/2026-01-09-friday-brief.md','content/posts/2026-01-10-saturday-brief.md','content/about.md');foreach($f in $files){$c=[IO.File]::ReadAllText($f,[Text.Encoding]::UTF8);[IO.File]::WriteAllText($f,$c,[Text.UTF8Encoding]::new($false));Write-Host \"Fixed: $f\"}"
echo Done!
pause
