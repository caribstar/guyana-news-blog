<#
.SYNOPSIS
Subscribe an email to The Guyana Daily Brief via Beehiiv API (interactive, PowerShell-only).
#>

# ===== CONFIGURE =====
$apiKey = "Zs7Zvalok6HIttUUUvyMzdiKHhKUFSun5aVrKHQSDSvxgijq4mzjmxP2oS5Wjl5W"
$newsletterId = "pub_2361dc8b-fd35-425f-a14e-a49bcb795b18"   # The Guyana Daily Brief (API V2)
# ====================

# Prompt for email interactively
$email = Read-Host "Enter the subscriber's email"

# Validate email format
if ($email -notmatch '^[\w\.\-]+@[\w\-]+\.[\w]{2,}$') {
    Write-Host "❌ Invalid email format: $email" -ForegroundColor Red
    exit
}

# Prepare JSON body
$body = @{ email = $email } | ConvertTo-Json

# Submit to Beehiiv API
try {
    $response = Invoke-RestMethod -Uri "https://api.beehiiv.com/v1/newsletter/$newsletterId/subscribers" `
        -Method Post `
        -Body $body `
        -Headers @{
            "Authorization" = "Bearer $apiKey"
            "Content-Type"  = "application/json"
        }

    Write-Host "✅ Successfully subscribed $($response.email)!" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to subscribe: $($_.Exception.Message)" -ForegroundColor Red
}
