# SOLUTION: Fix Socket Hang Up in Postman

## Problem Summary
You're getting "socket hang up" errors in Postman because the microservices are not running or not accessible on the expected ports.

## Complete Solution (Follow These Steps EXACTLY)

### STEP 1: Open File Explorer
Navigate to:
```
C:\Users\ghosht\OneDrive - Amadeus Workplace\Documents\Orion\testproject
```

### STEP 2: Build Services
1. Double-click **`BUILD.bat`** in the project root folder
2. Wait until you see "BUILD COMPLETE!"
3. You should see messages like:
   - "Created container image quarkus-microservices/inventory-service"
   - "Created container image quarkus-microservices/order-service"

### STEP 3: Start Services
1. Double-click **`START.bat`** in the project root folder
2. **TWO NEW CMD WINDOWS will open:**
   - Window 1: "INVENTORY-SERVICE-8080"
   - Window 2: "ORDER-SERVICE-8081"
3. **Wait for BOTH windows to show:** `Listening on: http://0.0.0.0:80XX`
4. **DO NOT CLOSE THESE WINDOWS** - Keep them running!

### STEP 4: Verify Services Are Running

**Option A: Use Your Browser**
1. Open browser and go to: `http://localhost:8080/inventory`
2. You should see JSON data (list of products)
3. Open another tab: `http://localhost:8081/orders`
4. You should see JSON data (list of orders, may be empty)

**Option B: Use PowerShell**
1. Open PowerShell
2. Run these commands:
```powershell
Invoke-WebRequest -Uri http://localhost:8080/inventory -UseBasicParsing
Invoke-WebRequest -Uri http://localhost:8081/orders -UseBasicParsing
```
3. Both should return "StatusCode : 200"

### STEP 5: Fix Postman Collection Ports

The Postman collection has been updated to use the correct ports:
- **Inventory Service:** Port 8080 (was 8082)
- **Order Service:** Port 8081 (unchanged)

**Re-import the collection:**
1. Open Postman
2. Go to File → Import
3. Select: `postman\Quarkus-Microservices.postman_collection.json`
4. Click "Import" (overwrite existing if prompted)

### STEP 6: Configure Postman Settings

**Check these settings in Postman:**

1. **File → Settings → General**
   - Request timeout: Set to **60000** ms (60 seconds)
   - SSL certificate verification: **OFF**

2. **File → Settings → Proxy**
   - **Disable** "Use System Proxy"
   - OR add `localhost, 127.0.0.1` to proxy bypass list

### STEP 7: Test in Postman

**Test these requests in order:**

1. **GET All Products**
   ```
   GET http://localhost:8080/inventory
   ```
   Expected: 200 OK with product array

2. **GET Product by ID**
   ```
   GET http://localhost:8080/inventory/1
   ```
   Expected: 200 OK with single product

3. **GET All Orders**
   ```
   GET http://localhost:8081/orders
   ```
   Expected: 200 OK with orders array

4. **POST Create Order**
   ```
   POST http://localhost:8081/orders
   Content-Type: application/json
   
   {
     "productId": 1,
     "quantity": 2
   }
   ```
   Expected: 201 Created with order details

---

## Troubleshooting

### If Services Don't Start

**Check 1: Verify JARs were built**
```
dir inventory-service\target\quarkus-app\quarkus-run.jar
dir order-service\target\quarkus-app\quarkus-run.jar
```
Both should exist. If not, run `BUILD.bat` again.

**Check 2: Ports might be in use**
Run `STOP.bat` to kill any existing processes, then run `START.bat` again.

**Check 3: Look at service windows**
The INVENTORY-SERVICE and ORDER-SERVICE windows will show error messages if something fails.

### If Postman Still Shows Socket Hang Up

1. **Verify services are running:**
   ```
   netstat -ano | findstr ":8080.*LISTENING"
   netstat -ano | findstr ":8081.*LISTENING"
   ```
   Both should show output. If not, services aren't running.

2. **Test with browser FIRST** (http://localhost:8080/inventory)
   - If browser works but Postman doesn't → Postman configuration issue
   - If browser doesn't work → Service issue

3. **Check Postman proxy settings** (most common issue)
   - Disable proxy OR add localhost to bypass

4. **Restart Postman** after changing settings

### If Services Crash

Check the service windows for error messages. Common issues:
- **"Port already in use"** → Run `STOP.bat`
- **"OutOfMemoryError"** → Restart your computer
- **"Class not found"** → Re-run `BUILD.bat`

---

## Quick Command Reference

| Task | Command/Action |
|------|----------------|
| Build | Double-click `BUILD.bat` |
| Start | Double-click `START.bat` |
| Stop | Double-click `STOP.bat` OR close service windows |
| Check if running | Browser: `http://localhost:8080/inventory` |
| View inventory | `http://localhost:8080/inventory` |
| View orders | `http://localhost:8081/orders` |

---

## Service Endpoints for Postman

### Inventory Service (http://localhost:8080)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/inventory` | Get all products |
| GET | `/inventory/{id}` | Get product by ID |
| GET | `/inventory/{id}/check?quantity=X` | Check if X items available |
| POST | `/inventory/{id}/reserve?quantity=X` | Reserve X items |

### Order Service (http://localhost:8081)

| Method | Endpoint | Body | Description |
|--------|----------|------|-------------|
| GET | `/orders` | - | Get all orders |
| GET | `/orders/{id}` | - | Get order by ID |
| POST | `/orders` | `{"productId":1,"quantity":2}` | Create new order |

---

## What Should Happen

### When Services Start Successfully:
```
========================================
Checking Service Status
========================================

[OK] Inventory Service is running on port 8080
[OK] Order Service is running on port 8081

========================================
Ready for Testing
========================================

Postman URLs:
  GET  http://localhost:8080/inventory
  GET  http://localhost:8081/orders
```

### When You Test in Browser:
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
  },
  {
    "id": 3,
    "name": "Keyboard",
    "quantity": 150
  }
]
```

### When You Create an Order in Postman:
```json
{
  "id": 1,
  "productId": 1,
  "quantity": 2,
  "status": "CONFIRMED"
}
```

---

## Still Having Issues?

1. Check `TROUBLESHOOTING-POSTMAN.md` for detailed troubleshooting
2. Look at the service CMD windows for error messages
3. Make sure both service windows say "Listening on: http://0.0.0.0:80XX"
4. Test with browser BEFORE testing with Postman
5. Restart your computer if all else fails (clears port bindings)

---

## Summary Checklist

- [ ] Built services with `BUILD.bat`
- [ ] Started services with `START.bat`
- [ ] Both service windows are open and running
- [ ] Both windows show "Listening on: http://0.0.0.0:80XX"
- [ ] Tested http://localhost:8080/inventory in browser - returns JSON
- [ ] Tested http://localhost:8081/orders in browser - returns JSON
- [ ] Re-imported Postman collection
- [ ] Configured Postman settings (timeout, proxy)
- [ ] Tested GET requests in Postman - all return 200 OK

If all checkboxes are checked, everything should work! ✅

