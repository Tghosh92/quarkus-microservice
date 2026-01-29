# 🔍 Logging Quick Reference

## ✅ Logging Already Configured!

Logging has been added to both microservices with comprehensive configuration.

---

## 🚀 Quick Start

### 1. Import Logger in Your Class

```java
import org.jboss.logging.Logger;

public class YourClass {
    private static final Logger LOG = Logger.getLogger(YourClass.class);
}
```

### 2. Add Log Statements

```java
// Info level (general information)
LOG.info("📋 Processing request");

// Debug level (detailed debugging)
LOG.debug("🔍 Variable value: " + value);

// Warn level (potential issues)
LOG.warn("⚠️ Low inventory detected");

// Error level (with exception)
LOG.error("❌ Failed to process", exception);
```

### 3. Use Formatted Logging (More Efficient)

```java
LOG.infof("User %s created order %d", username, orderId);
LOG.debugf("Processing: x=%d, y=%d", x, y);
```

---

## 📋 What's Already Configured

### ✅ Console Logging
- Colored output in dev mode
- Format: `HH:mm:ss.SSS [LEVEL] [ClassName] Message`
- Example: `12:34:56.789 [INFO] [InventoryResource] Getting all products`

### ✅ File Logging
- **Inventory:** `logs/inventory-service.log`
- **Order:** `logs/order-service.log`
- DEBUG level (more detailed than console)
- Auto-rotation at 10MB
- Keeps last 5 files

### ✅ HTTP Access Logging
- All incoming requests logged
- Shows: IP, timestamp, request, status, size

### ✅ Category Levels
- Your code (`com.example.*`): DEBUG
- Quarkus framework: INFO
- Netty/Vertx: WARN (reduced noise)

---

## 🎯 Log Levels

| Level | Use When | Example |
|-------|----------|---------|
| **DEBUG** | Development details | `LOG.debug("Found " + items.size() + " items")` |
| **INFO** | Normal operations | `LOG.info("Order created: " + orderId)` |
| **WARN** | Potential issues | `LOG.warn("Low stock: " + productId)` |
| **ERROR** | Errors/exceptions | `LOG.error("Failed to save", exception)` |

---

## 📝 Practical Examples

### Example 1: REST Endpoint Logging

```java
@GET
@Path("/{id}")
public Product getById(@PathParam("id") Long id) {
    LOG.info("🔍 Getting product with ID: " + id);
    
    Product product = service.findById(id);
    
    if (product == null) {
        LOG.warn("⚠️ Product not found: " + id);
        throw new NotFoundException();
    }
    
    LOG.debug("Found product: " + product.getName());
    return product;
}
```

### Example 2: Service Layer Logging

```java
public boolean reserve(Long productId, int quantity) {
    LOG.infof("📦 Reserving %d units of product %d", quantity, productId);
    
    try {
        // ... business logic ...
        LOG.info("✅ Reservation successful");
        return true;
    } catch (Exception e) {
        LOG.error("❌ Reservation failed for product: " + productId, e);
        throw e;
    }
}
```

### Example 3: Error Handling

```java
try {
    processOrder(order);
} catch (InsufficientInventoryException e) {
    LOG.warn("⚠️ Insufficient inventory: " + e.getMessage());
    return Response.status(400).entity("Out of stock").build();
} catch (Exception e) {
    LOG.error("❌ Unexpected error processing order: " + order.getId(), e);
    return Response.serverError().build();
}
```

---

## 🔧 Changing Log Levels

### In application.properties

```properties
# Make everything more verbose
quarkus.log.level=DEBUG

# Only your code verbose
quarkus.log.category."com.example".level=TRACE

# Specific class verbose
quarkus.log.category."com.example.inventory.InventoryResource".level=TRACE
```

### In Dev Mode (Runtime)

```
1. Open: http://localhost:8080/q/dev
2. Click "Configuration" card
3. Find logging properties
4. Change levels on the fly!
```

---

## 📊 Viewing Logs

### In Dev Mode Console

```bash
mvn quarkus:dev

# Logs appear in console:
12:34:56.789 [INFO] [InventoryResource] 📋 Getting all products
12:34:56.790 [DEBUG] [InventoryService] Fetching from database
```

### In Log Files

```bash
# View logs
cat logs/inventory-service.log
tail -f logs/inventory-service.log  # Follow logs

# In Windows:
type logs\inventory-service.log
Get-Content logs\inventory-service.log -Wait  # PowerShell
```

### In Dev UI

```
http://localhost:8080/q/dev
→ Click "Logging" card
→ View/search logs
→ Change levels
```

---

## 🎨 Using Emojis for Visual Debugging

```java
LOG.info("📋 Listing products");      // List operation
LOG.info("🔍 Searching for product"); // Search operation
LOG.info("📦 Reserving inventory");   // Reserve operation
LOG.info("✅ Operation successful");  // Success
LOG.warn("⚠️ Warning condition");     // Warning
LOG.error("❌ Operation failed");     // Error
```

**Makes logs easy to scan visually!**

---

## 🐛 Debugging Tips

### 1. Add Contextual Logging

```java
// Before method
LOG.debug("=== START: processOrder ===");
LOG.debugf("Input: orderId=%d, userId=%s", orderId, userId);

// Inside method
LOG.debug("Step 1: Validating order");
LOG.debug("Step 2: Checking inventory");
LOG.debug("Step 3: Creating order");

// After method
LOG.debug("=== END: processOrder ===");
```

### 2. Log State Changes

```java
LOG.debugf("BEFORE: quantity=%d", product.getQuantity());
product.setQuantity(product.getQuantity() - reserved);
LOG.debugf("AFTER: quantity=%d", product.getQuantity());
```

### 3. Performance Logging

```java
long start = System.currentTimeMillis();
// ... operation ...
long duration = System.currentTimeMillis() - start;
LOG.infof("Operation completed in %dms", duration);

if (duration > 1000) {
    LOG.warn("Slow operation detected: " + duration + "ms");
}
```

---

## ⚡ Testing Your Logging

### Step 1: Start Dev Mode

```bash
cd inventory-service
mvn quarkus:dev
```

### Step 2: Make a Request

```bash
curl http://localhost:8080/inventory
```

### Step 3: Check Console

You'll see logs in the console!

### Step 4: Check Log File

```bash
cat logs/inventory-service.log
```

More detailed logs in the file!

---

## 📚 Configuration Reference

### Current Configuration (Both Services)

```properties
# Console: INFO level, colored
quarkus.log.console.level=INFO
quarkus.log.console.color=true

# File: DEBUG level, detailed
quarkus.log.file.level=DEBUG
quarkus.log.file.path=logs/[service-name].log

# Your code: DEBUG level
quarkus.log.category."com.example".level=DEBUG

# HTTP requests: Enabled
quarkus.http.access-log.enabled=true
```

---

## 🎯 Common Patterns

### Pattern 1: Entry/Exit Logging

```java
public void processOrder(Order order) {
    LOG.infof("→ Processing order: %d", order.getId());
    try {
        // ... logic ...
        LOG.infof("← Order processed: %d", order.getId());
    } catch (Exception e) {
        LOG.errorf(e, "✗ Failed to process order: %d", order.getId());
        throw e;
    }
}
```

### Pattern 2: Conditional Logging

```java
if (LOG.isDebugEnabled()) {
    LOG.debug("Detailed info: " + expensiveToString());
}
```

### Pattern 3: Structured Context

```java
LOG.infof("Order created: id=%d, user=%s, total=%.2f", 
         order.getId(), order.getUserId(), order.getTotal());
```

---

## ✅ What You Get

### ✅ Immediate Benefits
- 🔍 See what your code is doing
- 🐛 Debug issues easily
- 📊 Track performance
- ⚠️ Catch warnings early
- 📝 Audit trail of operations

### ✅ Configured Features
- Console logging (colored, formatted)
- File logging (detailed, rotated)
- HTTP access logs
- Category-based levels
- Framework noise reduced

### ✅ Files Created
- `docs/LOGGING-GUIDE.md` - Complete guide
- Updated: `inventory-service/src/main/resources/application.properties`
- Updated: `order-service/src/main/resources/application.properties`

---

## 🚀 Next Steps

1. **Add logs to your code** (see examples above)
2. **Start dev mode:** `mvn quarkus:dev`
3. **Make requests** and watch the logs
4. **Check log files:** `logs/[service-name].log`
5. **Adjust levels** in `application.properties` as needed

---

## 📖 Full Documentation

See **`docs/LOGGING-GUIDE.md`** for:
- Complete examples
- Best practices
- Advanced configuration
- MDC (Mapped Diagnostic Context)
- Different environments (dev/test/prod)
- Performance tips

---

**Your microservices now have professional logging for debugging! 📝✨**

