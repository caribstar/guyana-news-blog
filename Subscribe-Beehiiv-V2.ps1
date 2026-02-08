<#
.SYNOPSIS
Subscribe an email to The Guyana Daily Brief via Beehiiv API v2 (interactive PowerShell).
#>

# ===== CONFIGURE =====
$apiKey = "Zs7Zvalok6HIttUUUvyMzdiKHhKUFSun5aVrKHQSDSvxgijq4mzjmxP2oS5Wjl5W"
$publicationId = "pub_2361dc8b-fd35-425f-a14e-a49bcb795b18"
# ====================

# Prompt for email interactively
$email = Read-Host "Enter the subscriber's email"

# Validate email format
if ($email -notmatch '^[\w\.\-]+@[\w\-]+\.[\w]{2,}$') {
    Write-Host "❌ Invalid email format: $email" -ForegroundColor Red
    exit
}

# Prepare JSON body
$bodyObject = @{
    email = $email
}
$bodyJson = $bodyObject | ConvertTo-Json

# Make API request
try {
    $response = Invoke-RestMethod -Uri "https://api.beehiiv.com/v2/publications/$publicationId/subscriptions" `
        -Method Post `
        -Body $bodyJson `
        -Headers @{
            "Authorization" = "Bearer $apiKey"
            "Content-Type"  = "application/json"
        }

    Write-Host "✅ Successfully subscribed $email!" -ForegroundColor Green
} catch {
    $err = $_.Exception
    Write-Host "❌ Failed to subscribe: $($err.Message)" -ForegroundColor Red

    # Optionally show response body if available
    if ($err.Response -ne $null) {
        $reader = New-Object System.IO.StreamReader($err.Response.GetResponseStream())
        $body = $reader.ReadToEnd()
        Write-Host "Response body: $body"
    }
}
