# Troubleshooting Guide - Socket Hang Up in Postman

## Problem
Getting "socket hang up" error in Postman when trying to access microservices.

## Root Causes and Solutions

### 1. **Services Not Running**
**Symptom:** Socket hang up or connection refused
**Solution:** Start the services first

### 2. **Wrong Port Numbers**
**Symptom:** Socket hang up on specific endpoints
**Solution:** Ensure Postman uses correct ports:
- Inventory Service: `http://localhost:8080`
- Order Service: `http://localhost:8081`

### 3. **Port Already in Use**
**Symptom:** Services fail to start with "Port already in use" error
**Solution:** Kill processes using the ports

## Step-by-Step Fix

### Step 1: Build the Services
```bat
cd "C:\Users\ghosht\OneDrive - Amadeus Workplace\Documents\Orion\testproject"
.\build-with-maven.bat
```

### Step 2: Verify Build Success
Check that these files exist:
- `inventory-service\target\quarkus-app\quarkus-run.jar`
- `order-service\target\quarkus-app\quarkus-run.jar`

### Step 3: Kill Any Existing Processes
```bat
REM Kill processes on port 8080
for /f "tokens=5" %a in ('netstat -aon ^| findstr ":8080.*LISTENING"') do taskkill /F /PID %a

REM Kill processes on port 8081
for /f "tokens=5" %a in ('netstat -aon ^| findstr ":8081.*LISTENING"') do taskkill /F /PID %a
```

### Step 4: Start Services Manually

**Terminal 1 - Inventory Service:**
```bat
cd "C:\Users\ghosht\OneDrive - Amadeus Workplace\Documents\Orion\testproject\inventory-service"
java -jar target\quarkus-app\quarkus-run.jar
```

Wait for output:
```
Listening on: http://0.0.0.0:8080
```

**Terminal 2 - Order Service:**
```bat
cd "C:\Users\ghosht\OneDrive - Amadeus Workplace\Documents\Orion\testproject\order-service"
java -jar target\quarkus-app\quarkus-run.jar
```

Wait for output:
```
Listening on: http://0.0.0.0:8081
```

### Step 5: Verify Services Are Running
```bat
netstat -ano | findstr ":8080.*LISTENING"
netstat -ano | findstr ":8081.*LISTENING"
```

Both should show output with process IDs.

### Step 6: Test Services with curl or PowerShell

**Test Inventory Service:**
```powershell
Invoke-WebRequest -Uri "http://localhost:8080/inventory" -UseBasicParsing
```

**Test Order Service:**
```powershell
Invoke-WebRequest -Uri "http://localhost:8081/orders" -UseBasicParsing
```

### Step 7: Update Postman Collection

Import the updated collection:
`Quarkus-Microservices.postman_collection.json`

**Verify these URLs in Postman:**
- Inventory Service: `http://localhost:8080/inventory`
- Order Service: `http://localhost:8081/orders`

## Common Postman Issues

### Issue 1: Request Timeout
**Settings to check:**
1. Open Postman Settings (File → Settings)
2. Go to General tab
3. Set "Request timeout" to at least 30000 ms (30 seconds)

### Issue 2: Proxy Configuration
**Settings to check:**
1. Open Postman Settings
2. Go to Proxy tab
3. Disable "Use System Proxy"
4. Or add `localhost` and `127.0.0.1` to proxy bypass list

### Issue 3: SSL Certificate Verification
**Settings to check:**
1. Open Postman Settings
2. Go to General tab
3. Turn OFF "SSL certificate verification" for local development

## Quick Verification Commands

**Check if services are running:**
```bat
netstat -ano | findstr ":808"
```

**Check Java processes:**
```bat
tasklist | findstr "java.exe"
```

**Test endpoint from command line:**
```bat
curl http://localhost:8080/inventory
curl http://localhost:8081/orders
```

## If All Else Fails - Use Quarkus Dev Mode

This is the most reliable way for development:

**Terminal 1:**
```bat
cd inventory-service
mvn quarkus:dev
```

**Terminal 2:**
```bat
cd order-service
mvn quarkus:dev
```

Dev mode provides:
- Auto-reload on code changes
- Better error messages
- Dev UI at http://localhost:8080/q/dev
- Continuous testing

## Endpoints to Test in Postman

### Inventory Service (Port 8080)

1. **GET** `http://localhost:8080/inventory` - Get all products
2. **GET** `http://localhost:8080/inventory/1` - Get product by ID
3. **GET** `http://localhost:8080/inventory/1/check?quantity=2` - Check availability
4. **POST** `http://localhost:8080/inventory/1/reserve?quantity=2` - Reserve product

### Order Service (Port 8081)

1. **GET** `http://localhost:8081/orders` - Get all orders
2. **GET** `http://localhost:8081/orders/1` - Get order by ID
3. **POST** `http://localhost:8081/orders` - Create new order
   ```json
   {
     "productId": 1,
     "quantity": 2
   }
   ```

## Expected Responses

### Successful Inventory Response:
```json
[
  {
    "id": 1,
    "name": "Laptop",
    "quantity": 100
  },
  {
    "id": 2,
    "name": "Mouse",
    "quantity": 250
  }
]
```

### Successful Order Response:
```json
{
  "id": 1,
  "productId": 1,
  "quantity": 2,
  "status": "CONFIRMED"
}
```

---

## Next Steps

1. Start both services in separate terminals
2. Verify they're listening on ports 8080 and 8081
3. Test endpoints with curl/PowerShell first
4. Then test in Postman
5. If issues persist, check Postman settings (timeout, proxy, SSL)

