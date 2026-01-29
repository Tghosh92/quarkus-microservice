# 🧪 Testing Changes in Dev Mode - Complete Guide

## 🚀 Quick Start - Testing in Dev Mode

When you run `mvn quarkus:dev`, you get multiple ways to test your changes instantly!

---

## 📋 Step-by-Step: Testing Your Changes

### Step 1: Start Dev Mode

```bash
cd inventory-service
mvn quarkus:dev
```

**You'll see:**
```
__  ____  __  _____   ___  __ ____  ______ 
 --/ __ \/ / / / _  / _ \/ //_/ / / / __/ 
 -/ /_/ / /_/ / __ / , _/ ,< / /_/ /\ \   
--\___\_\____/_/ _/_/_/_/_\____/___/   

2026-01-28 12:00:00,000 INFO  Listening on: http://localhost:8080
2026-01-28 12:00:00,001 INFO  Dev UI available at: http://localhost:8080/q/dev

Tests paused
Press [r] to resume testing, [o] Toggle test output, [:] for the terminal, [h] for more options>
```

---

## 🎯 Method 1: Auto-Reload Testing (Easiest!)

### Make a Code Change

**Example: Edit `InventoryResource.java`**

```java
// Before:
@GET
@Path("/{id}")
public Product getById(@PathParam("id") Long id) {
    return inventoryService.findById(id);
}

// Change to:
@GET
@Path("/{id}")
public Product getById(@PathParam("id") Long id) {
    System.out.println("🔍 Fetching product with ID: " + id);  // Add this line
    return inventoryService.findById(id);
}
```

**Save the file** → Quarkus automatically detects the change!

**Console output:**
```
2026-01-28 12:01:00,123 INFO  Changes detected - recompiling
2026-01-28 12:01:01,456 INFO  Hot replace successful
```

### Test Immediately

**Open browser or use curl:**
```bash
# Test the change:
curl http://localhost:8080/inventory/1
```

**See the output in the console:**
```
🔍 Fetching product with ID: 1
```

**✨ Your change is live! No restart needed!**

---

## 🎯 Method 2: Browser Testing

### Access Your API Directly

```bash
# Service is running on:
http://localhost:8080
```

**Test endpoints in browser:**

1. **Get all products:**
   ```
   http://localhost:8080/inventory
   ```

2. **Get product by ID:**
   ```
   http://localhost:8080/inventory/1
   ```

3. **Check availability:**
   ```
   http://localhost:8080/inventory/1/check?quantity=5
   ```

**Browser shows JSON response immediately!**

---

## 🎯 Method 3: Using Dev UI (Visual Testing)

### Access Dev UI
```
http://localhost:8080/q/dev
```

**Dev UI Features:**

1. **Configuration Editor**
   - View and modify configuration
   - Change properties on the fly

2. **Continuous Testing**
   - See test results visually
   - Run/pause tests

3. **Endpoints**
   - View all REST endpoints
   - Test them directly from UI

4. **Extensions**
   - See installed Quarkus extensions
   - Manage dependencies

5. **Dev Services**
   - Database connections
   - Test containers

**Example: Testing Endpoint from Dev UI**

1. Open http://localhost:8080/q/dev
2. Click "Endpoints" card
3. See all your REST endpoints listed
4. Click any endpoint to test it
5. See response in real-time!

---

## 🎯 Method 4: Running Tests Manually

### Press 'r' to Run Tests

**In the dev mode console, press 'r':**

```
Press [r] to resume testing
r ← (press this)

[INFO] Running com.example.inventory.InventoryResourceTest
[INFO] Tests run: 12, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] All tests passed! ✅
```

**Tests run instantly (seconds, not minutes)!**

### Continuous Testing Mode

**Press 'w' to enable continuous testing:**

```
Press [w] for continuous testing
w ← (press this)

Continuous testing activated ✅
Tests will run automatically on code changes
```

**Now when you save a file:**
```
File changed: InventoryResource.java
Running tests...
[INFO] Tests run: 12, Failures: 0, Errors: 0
✅ All tests passed!
```

---

## 🎯 Method 5: Using Postman

### Keep Dev Mode Running + Use Postman

**Your service is live at http://localhost:8080**

**In Postman:**

1. **Import collection** (if not already):
   ```
   postman/Quarkus-Microservices.postman_collection.json
   ```

2. **Update URL to port 8080**:
   ```
   http://localhost:8080/inventory
   ```

3. **Send requests**:
   - GET http://localhost:8080/inventory
   - GET http://localhost:8080/inventory/1
   - POST http://localhost:8080/inventory/1/reserve?quantity=2

4. **Make code changes**:
   - Edit Java files
   - Save
   - Auto-reload happens

5. **Send request again**:
   - See your changes immediately!

**No restart needed between requests!** ✨

---

## 🎯 Method 6: Using curl (Command Line)

### Quick API Testing

**While dev mode is running, open another terminal:**

```bash
# Test GET request
curl http://localhost:8080/inventory

# Test with pretty JSON
curl http://localhost:8080/inventory | jq

# Test specific product
curl http://localhost:8080/inventory/1

# Test with query parameter
curl "http://localhost:8080/inventory/1/check?quantity=5"

# Test POST request
curl -X POST "http://localhost:8080/inventory/1/reserve?quantity=2"
```

**Edit code → Save → Run curl again → See changes!**

---

## 🎯 Method 7: Using PowerShell (Windows)

```powershell
# Test GET request
Invoke-WebRequest -Uri "http://localhost:8080/inventory" -UseBasicParsing

# Get just the content
(Invoke-WebRequest -Uri "http://localhost:8080/inventory").Content

# Test specific endpoint
Invoke-WebRequest -Uri "http://localhost:8080/inventory/1" -UseBasicParsing

# Test with query parameter
Invoke-WebRequest -Uri "http://localhost:8080/inventory/1/check?quantity=5" -UseBasicParsing
```

---

## 📝 Complete Workflow Example

### Scenario: Add a New Endpoint

**Step 1: Start Dev Mode**
```bash
cd inventory-service
mvn quarkus:dev
```

**Step 2: Add New Method**

Edit `InventoryResource.java`:

```java
@GET
@Path("/count")
public long getProductCount() {
    return inventoryService.count();
}
```

**Save the file** → Auto-reload happens!

**Step 3: Test Immediately**

**Option A: Browser**
```
http://localhost:8080/inventory/count
```

**Option B: curl**
```bash
curl http://localhost:8080/inventory/count
```

**Option C: Dev UI**
```
http://localhost:8080/q/dev → Endpoints → /inventory/count
```

**Step 4: Add Test**

Edit `InventoryResourceTest.java`:

```java
@Test
@DisplayName("Should return product count")
public void testGetProductCount() {
    given()
        .when()
            .get("/inventory/count")
        .then()
            .statusCode(200)
            .body(notNullValue());
}
```

**Save the file** → Auto-reload!

**Step 5: Run Test**

Press 'r' in dev console:
```
r ← press this

[INFO] Tests run: 13, Failures: 0, Errors: 0
✅ Test passed!
```

**Done! New feature tested and working!**

---

## 🎯 Interactive Dev Mode Commands

While dev mode is running, press these keys:

| Key | Action |
|-----|--------|
| **r** | Run tests manually |
| **w** | Toggle continuous testing on/off |
| **o** | Toggle test output |
| **i** | Toggle instrumentation-based reload |
| **l** | Toggle live reload |
| **s** | Force restart |
| **h** | Show help (all commands) |
| **Ctrl+C** | Stop dev mode |

---

## 🔍 Debugging in Dev Mode

### Method 1: Console Output

Add print statements:

```java
@GET
@Path("/{id}")
public Product getById(@PathParam("id") Long id) {
    System.out.println("DEBUG: Received request for product: " + id);
    Product product = inventoryService.findById(id);
    System.out.println("DEBUG: Found product: " + product);
    return product;
}
```

**Save → See output immediately in console!**

### Method 2: IDE Debugger

**Attach debugger to running dev mode:**

1. Dev mode runs on debug port 5005 by default
2. In your IDE (IntelliJ/Eclipse):
   - Create "Remote Debug" configuration
   - Host: localhost
   - Port: 5005
3. Set breakpoints in your code
4. Make API request
5. Debugger stops at breakpoint!

**No restart needed for debugging!**

### Method 3: Quarkus Dev UI Logs

```
http://localhost:8080/q/dev
```

- View application logs
- Filter by level (INFO, DEBUG, ERROR)
- Search logs in real-time

---

## 📊 Real-World Testing Scenarios

### Scenario 1: Testing a Bug Fix

```bash
# 1. Start dev mode
mvn quarkus:dev

# 2. Reproduce the bug
curl http://localhost:8080/inventory/1

# 3. Fix the code
# Edit InventoryService.java
# Save file → Auto-reload

# 4. Test the fix
curl http://localhost:8080/inventory/1
# Bug fixed! ✅

# 5. Run tests
Press 'r'
# All tests pass! ✅
```

### Scenario 2: Adding Validation

```java
// Add validation to ProductResource.java
@POST
@Path("/{id}/reserve")
public Response reserve(@PathParam("id") Long id, @QueryParam("quantity") Integer quantity) {
    if (quantity == null || quantity <= 0) {
        return Response.status(400).entity("Quantity must be positive").build();
    }
    // ...existing code...
}
```

**Save → Test immediately:**
```bash
# Test invalid input
curl -X POST "http://localhost:8080/inventory/1/reserve?quantity=0"
# Returns 400 Bad Request ✅

# Test valid input
curl -X POST "http://localhost:8080/inventory/1/reserve?quantity=5"
# Returns 200 OK ✅
```

### Scenario 3: Changing Response Format

```java
// Modify response in ProductResource.java
@GET
public Response getAll() {
    List<Product> products = inventoryService.findAll();
    return Response.ok()
        .entity(Map.of(
            "count", products.size(),
            "products", products
        ))
        .build();
}
```

**Save → Test in browser:**
```
http://localhost:8080/inventory
```

**See new JSON format immediately:**
```json
{
  "count": 3,
  "products": [
    {"id": 1, "name": "Laptop", "quantity": 100},
    {"id": 2, "name": "Mouse", "quantity": 250}
  ]
}
```

---

## ⚡ Hot Reload Details

### What Gets Reloaded Automatically?

✅ **Hot Reloaded:**
- Java source files (.java)
- Configuration files (application.properties)
- Resources (templates, HTML, etc.)
- Dependencies (after Maven build)

⚠️ **Requires Restart:**
- pom.xml changes (add `mvn quarkus:dev` again)
- Native library changes

### How Fast is Hot Reload?

```
Code change → Save → Reload: ~1 second ⚡
```

**Example timing:**
- Edit file: 10 seconds
- Save: Instant
- Hot reload: 0.5-1 second
- Test: 5 seconds
**Total: 16 seconds** from idea to tested!

Compare to `mvn clean install`:
- Edit file: 10 seconds
- Build: 180 seconds
- Test: 5 seconds
**Total: 195 seconds!**

**Hot reload is 12x faster!** 🚀

---

## 🎓 Best Practices

### 1. Use Continuous Testing

```
Press 'w' in dev console
Tests run automatically on every change
Immediate feedback!
```

### 2. Keep Dev UI Open

```
Open in browser: http://localhost:8080/q/dev
Monitor logs, endpoints, configuration
Visual feedback on your changes
```

### 3. Use Multiple Terminals

```
Terminal 1: mvn quarkus:dev (inventory-service)
Terminal 2: mvn quarkus:dev -Dquarkus.http.port=8081 (order-service)
Terminal 3: curl commands for testing
```

### 4. Console Logging

```java
// Add meaningful logs
System.out.println("🔍 Processing order: " + orderId);
System.out.println("✅ Order created successfully");
System.out.println("❌ Error: " + error.getMessage());
```

### 5. Test Edge Cases

```bash
# Test valid inputs
curl http://localhost:8080/inventory/1

# Test invalid inputs
curl http://localhost:8080/inventory/999  # Non-existent
curl http://localhost:8080/inventory/abc  # Invalid format

# Test boundary conditions
curl "http://localhost:8080/inventory/1/check?quantity=0"
curl "http://localhost:8080/inventory/1/check?quantity=-1"
```

---

## 🐛 Troubleshooting Dev Mode

### Issue: Port Already in Use

```bash
# Stop other services first
STOP.bat

# Or use different port
mvn quarkus:dev -Dquarkus.http.port=8081
```

### Issue: Changes Not Reloading

```
Press 's' in dev console to force restart
```

### Issue: Tests Failing

```
Press 'r' to run tests manually
Check console for error details
Fix issue → Save → Auto-reload → Press 'r' again
```

### Issue: Hot Reload Takes Long

```
# Check if you have many dependencies
# Consider using faster computer/SSD
# Normal: 0.5-2 seconds
# If > 5 seconds, check system resources
```

---

## 📋 Quick Reference Card

### Dev Mode Testing Checklist

1. ✅ Start dev mode: `mvn quarkus:dev`
2. ✅ Wait for "Listening on: http://localhost:8080"
3. ✅ Make code changes
4. ✅ Save file → Auto-reload (1 sec)
5. ✅ Test immediately:
   - Browser: http://localhost:8080/your-endpoint
   - Postman: Send request
   - curl: `curl http://localhost:8080/your-endpoint`
   - Dev UI: http://localhost:8080/q/dev
   - Tests: Press 'r' in console
6. ✅ See results instantly!
7. ✅ Repeat steps 3-6 as needed
8. ✅ Press Ctrl+C when done

---

## 🎯 Complete Example: End-to-End Testing

### Full Workflow with All Methods

```bash
# Terminal 1: Start dev mode
cd inventory-service
mvn quarkus:dev

# Terminal 2: Testing commands
# Test 1: Basic endpoint
curl http://localhost:8080/inventory

# Edit ProductResource.java (add logging)
# Save → Auto-reload (1 sec)

# Test 2: See the logs
curl http://localhost:8080/inventory/1
# Console shows your log statements

# Terminal 1: Press 'r' to run tests
# All tests pass!

# Open browser: http://localhost:8080/q/dev
# Explore endpoints visually

# Open Postman: Test more complex scenarios
# POST requests, query parameters, etc.

# Make another code change
# Save → Auto-reload
# Test immediately in Postman

# Terminal 1: Press 'w' for continuous testing
# Now tests run automatically on every save!

# Edit test file
# Save → Auto-reload → Tests run automatically!

# All done! Press Ctrl+C to stop
```

---

## ✅ Summary

**Dev Mode Testing = Multiple Options:**

1. ✅ **Auto-reload** - Save file, see changes (1 sec)
2. ✅ **Browser** - Visual testing (http://localhost:8080)
3. ✅ **Dev UI** - Rich interface (http://localhost:8080/q/dev)
4. ✅ **Tests** - Press 'r' or 'w' for continuous
5. ✅ **Postman** - Full API testing
6. ✅ **curl** - Quick command-line tests
7. ✅ **Console logs** - Debugging output

**Speed:**
- Hot reload: ~1 second ⚡
- Test execution: Instant ⚡
- Full feedback loop: < 20 seconds ⚡⚡⚡

**Best Practice:**
```bash
mvn quarkus:dev  # Start once
Edit → Save → Test → Repeat  # All day!
Ctrl+C  # Done for the day
```

**Dev mode = Fastest way to test changes! 🚀**

