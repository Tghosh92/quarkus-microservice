# Postman Folder - API Testing Resources

This folder contains all Postman-related files for testing the microservices APIs.

---

## 📮 Files in This Folder

### 1. `Quarkus-Microservices.postman_collection.json` ⭐

**What it is:**
- Postman collection with all API endpoints
- Pre-configured requests for Inventory and Order services
- Ready to import and test

**What's included:**
- **Inventory Service Endpoints:**
  - GET all products
  - GET product by ID
  - Check product availability
  - Reserve products
  
- **Order Service Endpoints:**
  - GET all orders
  - GET order by ID
  - POST create new order

**How to use:**
1. Open Postman
2. Click **Import**
3. Select this file: `Quarkus-Microservices.postman_collection.json`
4. Click **Import**
5. Collection appears in left sidebar

**Service URLs:**
- Inventory Service: `http://localhost:8080`
- Order Service: `http://localhost:8081`

---

### 2. `POSTMAN-GUIDE.md`

**What it is:**
- Complete guide to using Postman with this project
- Step-by-step instructions
- Configuration settings
- Testing workflows

**When to read:**
- First time using the collection
- Learning how to test APIs
- Setting up Postman properly

**Topics covered:**
- Importing the collection
- Configuring Postman settings
- Testing each endpoint
- Creating test scenarios
- Best practices

---

### 3. `TROUBLESHOOTING-POSTMAN.md`

**What it is:**
- Detailed troubleshooting guide for Postman issues
- Solutions for common problems
- Configuration fixes
- Error resolution

**When to read:**
- Getting "socket hang up" errors
- Connection timeout issues
- Requests failing
- Can't connect to services

**Common issues solved:**
- Socket hang up errors
- Request timeouts
- Proxy configuration
- SSL certificate issues
- Port conflicts
- Service not responding

---

### 4. `POSTMAN-FIXED.md`

**What it is:**
- Documentation of fixes applied to Postman collection
- Port corrections (8082 → 8080)
- Configuration updates
- Change log

**When to read:**
- Understanding collection updates
- Checking what was fixed
- Reference for port mappings

---

## 🚀 Quick Start

### Step 1: Start Services
```bat
# From project root:
BUILD.bat
START.bat
```

Wait for both service windows to show: `Listening on: http://0.0.0.0:80XX`

### Step 2: Import Collection
1. Open Postman
2. Click **Import** button (top left)
3. Drag and drop `Quarkus-Microservices.postman_collection.json`
4. Click **Import**

### Step 3: Configure Postman
**File → Settings → General:**
- Request timeout: `60000` ms (60 seconds)
- SSL certificate verification: **OFF**

**File → Settings → Proxy:**
- Disable "Use System Proxy"
- OR add `localhost, 127.0.0.1` to bypass list

### Step 4: Test Endpoints

**Test 1: Get All Products**
```
GET http://localhost:8080/inventory
Expected: 200 OK with product array
```

**Test 2: Get Product by ID**
```
GET http://localhost:8080/inventory/1
Expected: 200 OK with product object
```

**Test 3: Get All Orders**
```
GET http://localhost:8081/orders
Expected: 200 OK with orders array
```

**Test 4: Create Order**
```
POST http://localhost:8081/orders
Body: {"productId": 1, "quantity": 2}
Expected: 201 Created
```

---

## 📋 API Endpoints Reference

### Inventory Service (Port 8080)

| Method | Endpoint | Description | Body |
|--------|----------|-------------|------|
| GET | `/inventory` | Get all products | - |
| GET | `/inventory/{id}` | Get product by ID | - |
| GET | `/inventory/{id}/check?quantity=X` | Check if X items available | - |
| POST | `/inventory/{id}/reserve?quantity=X` | Reserve X items | - |

**Example Response:**
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

### Order Service (Port 8081)

| Method | Endpoint | Description | Body |
|--------|----------|-------------|------|
| GET | `/orders` | Get all orders | - |
| GET | `/orders/{id}` | Get order by ID | - |
| POST | `/orders` | Create new order | `{"productId": 1, "quantity": 2}` |

**Example Create Order Request:**
```json
POST http://localhost:8081/orders
Content-Type: application/json

{
  "productId": 1,
  "quantity": 2
}
```

**Example Response:**
```json
{
  "id": 1,
  "productId": 1,
  "quantity": 2,
  "status": "CONFIRMED"
}
```

---

## 🔧 Postman Configuration

### Required Settings

**Timeout Settings:**
- Request timeout: 60000 ms (or higher)
- Why: Services need time to start and respond

**SSL Settings:**
- SSL certificate verification: OFF
- Why: Using localhost (no SSL certificate)

**Proxy Settings:**
- Option 1: Disable "Use System Proxy"
- Option 2: Add `localhost, 127.0.0.1` to bypass
- Why: Proxy can block localhost connections

---

## 🆘 Troubleshooting

### Problem: "Socket Hang Up" Error

**Cause:** Services not running or not accessible

**Solution:**
1. Check services are running:
   ```bat
   netstat -ano | findstr ":8080.*LISTENING"
   netstat -ano | findstr ":8081.*LISTENING"
   ```
2. If not running, start services:
   ```bat
   START.bat
   ```
3. Test in browser first:
   - http://localhost:8080/inventory
   - http://localhost:8081/orders

**Read:** `TROUBLESHOOTING-POSTMAN.md` for detailed solutions

---

### Problem: Request Timeout

**Cause:** Timeout too short or services slow to respond

**Solution:**
1. Increase timeout in Postman Settings → General
2. Set to 60000 ms or higher
3. Check if services are responding:
   ```powershell
   Invoke-WebRequest http://localhost:8080/inventory
   ```

---

### Problem: Connection Refused

**Cause:** Services not running on expected ports

**Solution:**
1. Verify services are running:
   ```bat
   ..\scripts\check-container-status.bat
   ```
2. Check correct ports:
   - Inventory: 8080
   - Orders: 8081
3. Restart services if needed:
   ```bat
   STOP.bat
   START.bat
   ```

---

### Problem: 404 Not Found

**Cause:** Wrong URL or endpoint path

**Solution:**
1. Verify URLs in collection:
   - Inventory: `http://localhost:8080/inventory`
   - Orders: `http://localhost:8081/orders`
2. Re-import collection if URLs are wrong
3. Check service is running on correct port

---

## 🎯 Testing Workflows

### Workflow 1: Basic API Testing
```
1. Start services (BUILD.bat → START.bat)
2. Import collection to Postman
3. Test GET /inventory
4. Test GET /orders
5. Test POST /orders (create order)
6. Verify order was created (GET /orders/{id})
```

### Workflow 2: Integration Testing
```
1. GET /inventory - Check available products
2. GET /inventory/1 - Get specific product details
3. GET /inventory/1/check?quantity=2 - Verify availability
4. POST /orders with productId=1 - Create order
5. GET /inventory/1 - Verify inventory reduced
6. GET /orders - Verify order exists
```

### Workflow 3: Error Testing
```
1. POST /orders with invalid productId - Expect error
2. POST /orders with quantity > available - Expect error
3. GET /inventory/999 - Expect 404
4. GET /orders/999 - Expect 404
```

---

## 💡 Pro Tips

1. **Test in browser first** before using Postman - faster to diagnose issues
2. **Save responses** in Postman for reference
3. **Use environments** for different configurations (dev, test, prod)
4. **Create test scripts** in Postman for automated testing
5. **Check service windows** for errors if requests fail
6. **Use Collections Runner** for automated testing sequences

---

## 📚 Documentation Reference

### Quick Help
- Socket hang up? → `TROUBLESHOOTING-POSTMAN.md`
- First time setup? → `POSTMAN-GUIDE.md`
- What was fixed? → `POSTMAN-FIXED.md`

### Main Project Docs (in parent folder)
- `../START-HERE.md` - Main quick start
- `../README-SOLUTION.md` - Complete troubleshooting
- `../VISUAL-GUIDE.md` - Visual guide
- `../PROJECT-README.md` - Project overview

---

## ✅ Pre-Testing Checklist

Before testing with Postman:
- [ ] Services built (`BUILD.bat` completed)
- [ ] Services running (two CMD windows open)
- [ ] Both services show "Listening on: http://0.0.0.0:80XX"
- [ ] Tested in browser (http://localhost:8080/inventory works)
- [ ] Postman collection imported
- [ ] Postman timeout set to 60000 ms
- [ ] Postman SSL verification OFF
- [ ] Postman proxy configured (disabled or localhost bypassed)

---

## 🎓 Learning Resources

### Understanding REST APIs
- GET: Retrieve data
- POST: Create new data
- PUT: Update existing data
- DELETE: Remove data

### HTTP Status Codes
- 200 OK: Success
- 201 Created: Resource created
- 400 Bad Request: Invalid data
- 404 Not Found: Resource doesn't exist
- 500 Server Error: Service error

### Testing Best Practices
1. Start with simple GET requests
2. Verify data format and structure
3. Test POST/PUT with valid data
4. Test error cases (invalid data)
5. Verify side effects (inventory changes)

---

## 🔍 Quick Diagnostics

**Services not responding?**
```bat
# Check if running:
netstat -ano | findstr ":808"

# Check service status:
..\scripts\check-container-status.bat

# Restart services:
..\STOP.bat
..\START.bat
```

**Collection not working?**
```
1. Re-import collection
2. Check URLs (8080, 8081)
3. Verify services are running
4. Test in browser first
5. Check Postman settings
```

---

## 📞 Getting Help

1. **Read TROUBLESHOOTING-POSTMAN.md** - Most issues solved here
2. **Check service CMD windows** - Error messages appear there
3. **Test in browser** - Isolate if it's Postman or service issue
4. **Verify ports** - `netstat -ano | findstr ":808"`
5. **Check logs** - Service windows show detailed logs

---

**Happy Testing! 🚀**

Remember: Start services → Import collection → Configure settings → Test!

