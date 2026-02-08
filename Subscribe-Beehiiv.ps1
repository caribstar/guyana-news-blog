param(
    [Parameter(Mandatory=$true)]
    [string]$Email
)

# ✅ Beehiiv API endpoint (with your publication ID)
$apiUrl = "https://api.beehiiv.com/v2/publications/pub_2361dc8b-fd35-425f-a14e-a49bcb795b18/subscribers"

# ✅ Your Beehiiv API key
$apiKey = "Zs7Zvalok6HIttUUUvyMzdiKHhKUFSun5aVrKHQSDSvxgijq4mzjmxP2oS5Wjl5W"

# Prepare the JSON body with the subscriber's email
$body = @{
    email = $Email
} | ConvertTo-Json

try {
    # Send subscription request
    $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers @{
        "Authorization" = "Bearer $apiKey"
        "Content-Type"  = "application/json"
    } -Body $body

    Write-Host "✅ Successfully subscribed ${Email} to Beehiiv!"
}
catch {
    # Properly handle errors
    Write-Host "❌ Failed to subscribe ${Email}: $($_.Exception.Message)"
}
