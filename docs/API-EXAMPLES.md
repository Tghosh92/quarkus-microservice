# API Testing Examples

## PowerShell Commands

### Inventory Service (Port 8080)

#### 1. Get All Products
```powershell
Invoke-RestMethod -Uri "http://localhost:8080/inventory" -Method Get | Format-Table
```

#### 2. Get Specific Product
```powershell
Invoke-RestMethod -Uri "http://localhost:8080/inventory/1" -Method Get
```

#### 3. Check Product Availability
```powershell
Invoke-RestMethod -Uri "http://localhost:8080/inventory/1/check?quantity=2" -Method Get
```

#### 4. Reserve Product
```powershell
Invoke-RestMethod -Uri "http://localhost:8080/inventory/1/reserve?quantity=2" -Method Post
```

---

### Order Service (Port 8081)

#### 1. Create Order for Laptop
```powershell
$body = @{
    productId = 1
    quantity = 2
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Post -ContentType "application/json" -Body $body
```

#### 2. Create Order for Mouse
```powershell
$body = @{
    productId = 2
    quantity = 5
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Post -ContentType "application/json" -Body $body
```

#### 3. Create Order for Keyboard
```powershell
$body = @{
    productId = 3
    quantity = 1
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Post -ContentType "application/json" -Body $body
```

#### 4. Get All Orders
```powershell
Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Get | Format-Table
```

#### 5. Get Specific Order
```powershell
Invoke-RestMethod -Uri "http://localhost:8081/orders/1" -Method Get
```

---

## CMD/Batch with curl

### Inventory Service

#### 1. Get All Products
```batch
curl http://localhost:8080/inventory
```

#### 2. Get Specific Product
```batch
curl http://localhost:8080/inventory/1
```

#### 3. Check Availability
```batch
curl "http://localhost:8080/inventory/1/check?quantity=2"
```

#### 4. Reserve Product
```batch
curl -X POST "http://localhost:8080/inventory/1/reserve?quantity=2"
```

---

### Order Service

#### 1. Create Order
```batch
curl -X POST http://localhost:8081/orders ^
  -H "Content-Type: application/json" ^
  -d "{\"productId\": 1, \"quantity\": 2}"
```

#### 2. Get All Orders
```batch
curl http://localhost:8081/orders
```

#### 3. Get Specific Order
```batch
curl http://localhost:8081/orders/1
```

---

## Test Scenarios

### Scenario 1: Successful Order
```powershell
# Step 1: Check initial inventory
Write-Host "Initial Inventory:" -ForegroundColor Yellow
Invoke-RestMethod "http://localhost:8080/inventory/1"

# Step 2: Create order
Write-Host "`nCreating Order:" -ForegroundColor Yellow
$order = @{ productId = 1; quantity = 2 } | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Post -ContentType "application/json" -Body $order

# Step 3: Check updated inventory
Write-Host "`nUpdated Inventory:" -ForegroundColor Yellow
Invoke-RestMethod "http://localhost:8080/inventory/1"
```

### Scenario 2: Order with Insufficient Quantity
```powershell
# Try to order more than available
$order = @{ productId = 1; quantity = 100 } | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Post -ContentType "application/json" -Body $order
```

### Scenario 3: Order Non-existent Product
```powershell
# Try to order product that doesn't exist
$order = @{ productId = 999; quantity = 1 } | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Post -ContentType "application/json" -Body $order
```

### Scenario 4: Multiple Orders
```powershell
# Create multiple orders in sequence
Write-Host "Creating multiple orders..." -ForegroundColor Green

# Order 1: 2 Laptops
$order1 = @{ productId = 1; quantity = 2 } | ConvertTo-Json
$result1 = Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Post -ContentType "application/json" -Body $order1
Write-Host "Order 1 Status: $($result1.status)"

# Order 2: 5 Mice
$order2 = @{ productId = 2; quantity = 5 } | ConvertTo-Json
$result2 = Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Post -ContentType "application/json" -Body $order2
Write-Host "Order 2 Status: $($result2.status)"

# Order 3: 1 Keyboard
$order3 = @{ productId = 3; quantity = 1 } | ConvertTo-Json
$result3 = Invoke-RestMethod -Uri "http://localhost:8081/orders" -Method Post -ContentType "application/json" -Body $order3
Write-Host "Order 3 Status: $($result3.status)"

# Show all orders
Write-Host "`nAll Orders:" -ForegroundColor Green
Invoke-RestMethod "http://localhost:8081/orders" | Format-Table

# Show updated inventory
Write-Host "`nUpdated Inventory:" -ForegroundColor Green
Invoke-RestMethod "http://localhost:8080/inventory" | Format-Table
```

---

## Expected Responses

### Successful Order Creation
```json
{
  "id": 1,
  "productId": 1,
  "productName": "Laptop",
  "quantity": 2,
  "status": "CONFIRMED"
}
```

### Failed Order (Insufficient Stock)
```json
{
  "id": 2,
  "productId": 1,
  "productName": "Laptop",
  "quantity": 100,
  "status": "FAILED: Product not available"
}
```

### Product Response
```json
{
  "id": 1,
  "name": "Laptop",
  "quantity": 10
}
```

### Availability Check
```json
{
  "available": true
}
```

### Reservation Response
```json
{
  "success": true,
  "message": "Product reserved successfully"
}
```

