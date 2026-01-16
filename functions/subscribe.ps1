param(\)

try {
    # Parse JSON payload
    \ = \.Body | ConvertFrom-Json
} catch {
    return @{
        statusCode = 400
        body = '{"message":"Invalid JSON"}'
    }
}

\ = \.email

if (-not \) {
    return @{
        statusCode = 400
        body = '{"message":"Email is required"}'
    }
}

# Beehiiv API Key (keep secret!)
\ = "Zs7Zvalok6HIttUUUvyMzdiKHhKUFSun5aVrKHQSDSvxgijq4mzjmxP2oS5Wjl5W"
\ = "https://api.beehiiv.com/v1/publications/pub_2361dc8b-fd35-425f-a14e-a49bcb795b18/subscribers"

\ = @{ email = \ } | ConvertTo-Json

try {
    \ = Invoke-RestMethod -Uri \ -Method Post -Headers @{
        "Authorization" = "Bearer \"
        "Content-Type"  = "application/json"
    } -Body \

    return @{
        statusCode = 200
        body = '{"message":"Subscribed successfully!"}'
    }

} catch {
    return @{
        statusCode = 500
        body = "{"message":"Subscription failed: \"}"
    }
}
