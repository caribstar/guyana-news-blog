# ============================
# Subscribe-Webhook-Fixed.ps1
# Simple PowerShell HTTP Listener for newsletter signups
# ============================

$port = 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:$port/subscribe/")
$listener.Start()

Write-Host "🚀 Listening for subscription requests on port $port..."

while ($true) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    try {
        if ($request.HttpMethod -eq "POST") {

            # ---------------------------
            # Read POST body
            # ---------------------------
            $reader = New-Object System.IO.StreamReader($request.InputStream)
            $body = $reader.ReadToEnd()
            $reader.Close()

            # ---------------------------
            # SAFE parsing code for email
            # ---------------------------
            $params = @{}
            foreach ($pair in $body -split '&') {
                $kv = $pair -split '='
                if ($kv.Length -eq 2) {
                    $params[$kv[0]] = [System.Web.HttpUtility]::UrlDecode($kv[1])
                }
            }

            if (-not $params.ContainsKey("email")) {
                throw "No email provided"
            }

            $email = $params["email"]

            # ---------------------------
            # Call your subscription script
            # ---------------------------
            & "C:\Users\Staff\guyana-news-blog-RESTORED\Subscribe-Beehiiv.ps1" -Email $email

            # ---------------------------
            # Send success response
            # ---------------------------
            $response.StatusCode = 200
            $response.ContentType = "text/plain"
            $respBytes = [System.Text.Encoding]::UTF8.GetBytes("✅ Successfully subscribed $email!")
            $response.OutputStream.Write($respBytes, 0, $respBytes.Length)
        }
        else {
            # Only allow POST
            $response.StatusCode = 405
            $respBytes = [System.Text.Encoding]::UTF8.GetBytes("Method Not Allowed")
            $response.OutputStream.Write($respBytes, 0, $respBytes.Length)
        }
    }
    catch {
        $response.StatusCode = 500
        $response.ContentType = "text/plain"
        $respBytes = [System.Text.Encoding]::UTF8.GetBytes("❌ Failed: $($_.Exception.Message)")
        $response.OutputStream.Write($respBytes, 0, $respBytes.Length)
    }

    $response.OutputStream.Close()
}
