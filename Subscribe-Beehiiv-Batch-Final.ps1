<#
.SYNOPSIS
Batch subscribe emails to The Guyana Daily Brief via Beehiiv API v2 with CSV backup.
#>

# ===== CONFIGURE =====
$apiKey = "Zs7Zvalok6HIttUUUvyMzdiKHhKUFSun5aVrKHQSDSvxgijq4mzjmxP2oS5Wjl5W"
$publicationId = "pub_2361dc8b-fd35-425f-a14e-a49bcb795b18"
$backupCsv = ".\subscribers_backup.csv"
# ====================

# Ensure CSV exists
if (-not (Test-Path $backupCsv)) {
    "Email,Date" | Out-File -FilePath $backupCsv -Encoding UTF8
}

Write-Host "Enter subscriber emails one by one. Type 'exit' or leave blank to finish." -ForegroundColor Cyan

while ($true) {
    $email = Read-Host "Email"

    if ([string]::IsNullOrWhiteSpace($email) -or $email -eq "exit") {
        Write-Host "Exiting batch subscription." -ForegroundColor Yellow
        break
    }

    # Validate email
    if ($email -notmatch '^[\w\.\-]+@[\w\-]+\.[\w]{2,}$') {
        Write-Host "❌ Invalid email format: $email" -ForegroundColor Red
        continue
    }

    # Prepare JSON body
    $body = @{ email = $email } | ConvertTo-Json

    # Try API call
    try {
        $response = Invoke-RestMethod -Uri "https://api.beehiiv.com/v2/publications/$publicationId/subscriptions" `
            -Method Post `
            -Body $body `
            -Headers @{
                "Authorization" = "Bearer $apiKey"
                "Content-Type"  = "application/json"
            }

        Write-Host "✅ Successfully subscribed $email!" -ForegroundColor Green

        # Log to CSV
        $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "$email,$date" | Out-File -FilePath $backupCsv -Append -Encoding UTF8

    } catch {
        $err = $_.Exception
        Write-Host "❌ Failed to subscribe ${email}: $($err.Message)" -ForegroundColor Red

        if ($err.Response -ne $null) {
            $reader = New-Object System.IO.StreamReader($err.Response.GetResponseStream())
            $body = $reader.ReadToEnd()
            Write-Host "Response body: $body"
        }
    }
}
