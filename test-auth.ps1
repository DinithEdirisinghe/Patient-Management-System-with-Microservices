$headers = @{
    "Content-Type" = "application/json"
}

# Test with simple user
Write-Host "Testing with simple test user (simple@test.com, test123)..."

$body = @{
    email = "simple@test.com"
    password = "test123"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4005/login" -Method POST -Headers $headers -Body $body
    Write-Host "✅ SUCCESS! Login worked!"
    Write-Host "JWT Token received:"
    Write-Host ($response | ConvertTo-Json -Depth 3)
} catch {
    Write-Host "❌ Failed: $($_.Exception.Message)"
    if ($_.ErrorDetails) {
        Write-Host "Error details: $($_.ErrorDetails.Message)"
    }
}

Write-Host "`n" + "="*50
Write-Host "Now testing with original user (different passwords)..."

$passwords = @("password", "admin", "test123", "123456", "testuser", "secret")

foreach ($pwd in $passwords) {
    Write-Host "Trying password: $pwd"
    
    $body = @{
        email = "testuser@test.com"
        password = $pwd
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri "http://localhost:4005/login" -Method POST -Headers $headers -Body $body
        Write-Host "✅ SUCCESS! Password '$pwd' worked!"
        Write-Host "JWT Token received:"
        Write-Host ($response | ConvertTo-Json -Depth 3)
        break
    } catch {
        Write-Host "❌ Failed with password '$pwd': $($_.Exception.Message)"
    }
    Write-Host ""
}
