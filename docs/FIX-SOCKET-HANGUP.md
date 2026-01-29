# How to Fix "Socket Hang Up" in Postman

## Quick Solution (3 Steps)

### Step 1: Build the Services
Double-click: **`build-with-maven.bat`**

Wait for "BUILD COMPLETE!" message.

### Step 2: Start the Services
Double-click: **`START-SERVICES.bat`**

This will open 2 new windows:
- **INVENTORY-SERVICE-8080** (Green window)
- **ORDER-SERVICE-8081** (Blue window)

Wait for both to show: `Listening on: http://0.0.0.0:808X`

### Step 3: Test in Postman
Use these URLs:
- `http://localhost:8080/inventory` (GET)
- `http://localhost:8081/orders` (GET)

---

## Detailed Instructions

### Before Testing - Ensure Services Are Built

```bat
build-with-maven.bat
```

Expected output:
```
BUILD SUCCESS
BUILD COMPLETE!
```

### Starting Services

**Option A: Using the Startup Script (Recommended)**
```bat
START-SERVICES.bat
```

**Option B: Manual Startup**

**Terminal 1:**
```bat
cd inventory-service
java -jar target\quarkus-app\quarkus-run.jar
```

**Terminal 2:**
```bat
cd order-service
java -jar target\quarkus-app\quarkus-run.jar
```

### Verify Services Are Running

**Command Line Check:**
```bat
netstat -ano | findstr ":8080.*LISTENING"
netstat -ano | findstr ":8081.*LISTENING"
```

Both commands should show output like:
```
TCP    0.0.0.0:8080    0.0.0.0:0    LISTENING    12345
```

**PowerShell Test:**
```powershell
Invoke-WebRequest -Uri http://localhost:8080/inventory -UseBasicParsing
Invoke-WebRequest -Uri http://localhost:8081/orders -UseBasicParsing
```

Expected: Status Code 200

### Stopping Services

**Option A: Using the Stop Script**
```bat
STOP-SERVICES.bat
```

**Option B: Close the Windows**
Close the INVENTORY-SERVICE and ORDER-SERVICE windows.

**Option C: Kill Processes**
```bat
for /f "tokens=5" %a in ('netstat -aon ^| findstr ":8080.*LISTENING"') do taskkill /F /PID %a
for /f "tokens=5" %a in ('netstat -aon ^| findstr ":8081.*LISTENING"') do taskkill /F /PID %a
```

---

## Postman Configuration

### 1. Import Collection
Import: `Quarkus-Microservices.postman_collection.json`

### 2. Verify URLs
All requests should use:
- **Inventory:** `http://localhost:8080`
- **Orders:** `http://localhost:8081`

### 3. Check Postman Settings

**File → Settings → General:**
- Request timeout: `30000` ms (or more)
- SSL certificate verification: `OFF` (for localhost)

**File → Settings → Proxy:**
- Use System Proxy: `OFF`
- OR add `localhost, 127.0.0.1` to bypass list

### 4. Test Requests in Order

**Test 1: Get All Products**
```
GET http://localhost:8080/inventory
```
Expected: Array of products with status 200

**Test 2: Get Product by ID**
```
GET http://localhost:8080/inventory/1
```
Expected: Single product object

**Test 3: Check Availability**
```
GET http://localhost:8080/inventory/1/check?quantity=2
```
Expected: `true` or `false`

**Test 4: Get All Orders**
```
GET http://localhost:8081/orders
```
Expected: Array of orders (may be empty initially)

**Test 5: Create Order**
```
POST http://localhost:8081/orders
Content-Type: application/json

{
  "productId": 1,
  "quantity": 2
}
```
Expected: New order object with status CONFIRMED

---

## Common Issues & Solutions

### Issue 1: "Socket Hang Up" Error
**Cause:** Services not running
**Solution:** Start services with `START-SERVICES.bat`

### Issue 2: "Port 8080 already in use"
**Cause:** Another process using the port
**Solution:** Run `STOP-SERVICES.bat` then start again

### Issue 3: "Connection Refused"
**Cause:** Services crashed or didn't start
**Solution:** Check service windows for error messages

### Issue 4: Postman Timeout
**Cause:** Request timeout too short
**Solution:** Increase timeout in Postman settings to 60000 ms

### Issue 5: Services Start Then Stop
**Cause:** Build artifacts missing or corrupted
**Solution:** 
1. Run `STOP-SERVICES.bat`
2. Delete `inventory-service\target` and `order-service\target`
3. Run `build-with-maven.bat`
4. Run `START-SERVICES.bat`

---

## File Structure

```
testproject/
├── build-with-maven.bat          # Build both services
├── START-SERVICES.bat            # Start services (USE THIS)
├── STOP-SERVICES.bat             # Stop services
├── Quarkus-Microservices.postman_collection.json  # Import to Postman
├── TROUBLESHOOTING-POSTMAN.md    # Detailed troubleshooting
├── inventory-service/
│   └── target/
│       └── quarkus-app/
│           └── quarkus-run.jar   # Built artifact
└── order-service/
    └── target/
        └── quarkus-app/
            └── quarkus-run.jar   # Built artifact
```

---

## Quick Reference Card

| Action | Command |
|--------|---------|
| Build | `build-with-maven.bat` |
| Start | `START-SERVICES.bat` |
| Stop | `STOP-SERVICES.bat` |
| Check Status | `netstat -ano \| findstr ":808"` |
| Test Inventory | `curl http://localhost:8080/inventory` |
| Test Orders | `curl http://localhost:8081/orders` |

---

## Expected Service Output

When services start successfully, you should see:

```
__  ____  __  _____   ___  __ ____  ______
 --/ __ \/ / / / _  / _ \/ //_/ / / / __/
 -/ /_/ / /_/ / __ / , _/ ,< / /_/ /\ \
--\___\_\____/_/ _/_/_/_/_\____/___/
2026-01-28 11:xx:xx,xxx INFO  [io.quarkus] Inventory service 1.0.0-SNAPSHOT on JVM started in X.XXXs.
2026-01-28 11:xx:xx,xxx INFO  [io.quarkus] Listening on: http://0.0.0.0:8080
```

If you see this, the service is ready!

---

## Next Steps After Services Are Running

1. ✅ Verify services with browser:
   - http://localhost:8080/inventory
   - http://localhost:8081/orders

2. ✅ Test with Postman collection

3. ✅ Create orders and verify inventory updates

4. ✅ Check logs in service windows for debugging

---

## Need Help?

Check these files:
- `TROUBLESHOOTING-POSTMAN.md` - Detailed troubleshooting
- Service windows - Look for error messages
- `netstat -ano | findstr ":808"` - Check if ports are in use

