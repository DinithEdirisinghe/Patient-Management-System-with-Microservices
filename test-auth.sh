#!/bin/bash
echo "Testing auth service login endpoint..."
echo "Request body: {\"email\":\"debug@test.com\",\"password\":\"password123\"}"

response=$(curl -s -w "\nHTTP_CODE:%{http_code}\nRESPONSE_TIME:%{time_total}" \
  -X POST "http://localhost:4005/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"debug@test.com","password":"password123"}')

echo "Response:"
echo "$response"
