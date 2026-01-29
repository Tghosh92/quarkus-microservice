# Test script for Quarkus Microservices

Write-Host "`n=== Testing Inventory Service ===" -ForegroundColor Green

Write-Host "`n1. Getting all products from inventory..."
$products = Invoke-RestMethod -Uri "http://localhost:8080/inventory" -Method Get
$products | Format-Table

Write-Host "`n2. Getting product with ID 1..."
$product = Invoke-RestMethod -Uri "http://localhost:8080/inventory/1" -Method Get
$product | Format-Table

Write-Host "`n3. Checking availability of product 1 (quantity: 2)..."
$availability = Invoke-RestMethod -Uri "http://localhost:8080/inventory/1/check?quantity=2" -Method Get
Write-Host "Available: $($availability.available)"

Write-Host "`n=== Testing Order Service ===" -ForegroundColor Green

Write-Host "`n4. Creating an order for 2 Laptops..."
$orderRequest = @{
    productId = 1
    quantity = 2
} | ConvertTo-Json

$order = Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Post -ContentType "application/json" -Body $orderRequest
$order | Format-Table

Write-Host "`n5. Getting all orders..."
$orders = Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Get
$orders | Format-Table

Write-Host "`n6. Checking updated inventory..."
$updatedProducts = Invoke-RestMethod -Uri "http://localhost:8080/inventory" -Method Get
$updatedProducts | Format-Table

Write-Host "`n7. Creating another order for 3 Mice..."
$orderRequest2 = @{
    productId = 2
    quantity = 3
} | ConvertTo-Json

$order2 = Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Post -ContentType "application/json" -Body $orderRequest2
$order2 | Format-Table

Write-Host "`n8. All orders:"
$allOrders = Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Get
$allOrders | Format-Table

Write-Host "`nTests completed!" -ForegroundColor Green

