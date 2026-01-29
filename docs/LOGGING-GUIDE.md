# 🔍 Logging for Debugging - Complete Guide

## 📋 Logging in Quarkus Microservices

Quarkus uses **JBoss Logging** by default, which is fast, efficient, and easy to use.

---

## 🚀 Quick Start - Adding Logs

### Step 1: Import Logger

In any Java class, add:

```java
import org.jboss.logging.Logger;

public class YourClass {
    private static final Logger LOG = Logger.getLogger(YourClass.class);
}
```

### Step 2: Use Logger

```java
LOG.info("Information message");
LOG.debug("Debug message");
LOG.warn("Warning message");
LOG.error("Error message", exception);
```

---

## 🎯 Log Levels

| Level | When to Use | Example |
|-------|-------------|---------|
| **TRACE** | Very detailed debugging | Method entry/exit, loop iterations |
| **DEBUG** | Development debugging | Variable values, logic flow |
| **INFO** | General information | Service started, request processed |
| **WARN** | Potential issues | Deprecated API, fallback used |
| **ERROR** | Errors that need attention | Exceptions, failures |

---

## 📝 Practical Examples

### Example 1: Logging in REST Resource

**File:** `inventory-service/src/main/java/com/example/inventory/resource/InventoryResource.java`

```java
package com.example.inventory.resource;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.jboss.logging.Logger;
import java.util.List;

@Path("/inventory")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class InventoryResource {
    
    private static final Logger LOG = Logger.getLogger(InventoryResource.class);
    
    @Inject
    InventoryService inventoryService;
    
    @GET
    public List<Product> getAllProducts() {
        LOG.info("📋 Getting all products");
        List<Product> products = inventoryService.findAll();
        LOG.info("✅ Found " + products.size() + " products");
        return products;
    }
    
    @GET
    @Path("/{id}")
    public Product getProductById(@PathParam("id") Long id) {
        LOG.info("🔍 Getting product with ID: " + id);
        
        Product product = inventoryService.findById(id);
        
        if (product == null) {
            LOG.warn("⚠️ Product not found with ID: " + id);
            throw new NotFoundException("Product not found");
        }
        
        LOG.debug("Found product: " + product.getName());
        return product;
    }
    
    @POST
    @Path("/{id}/reserve")
    public Response reserveProduct(
            @PathParam("id") Long id,
            @QueryParam("quantity") Integer quantity) {
        
        LOG.info("📦 Reserve request - Product ID: " + id + ", Quantity: " + quantity);
        
        try {
            if (quantity == null || quantity <= 0) {
                LOG.warn("❌ Invalid quantity: " + quantity);
                return Response.status(400)
                    .entity("Quantity must be positive")
                    .build();
            }
            
            boolean reserved = inventoryService.reserve(id, quantity);
            
            if (reserved) {
                LOG.info("✅ Successfully reserved " + quantity + " units of product " + id);
                return Response.ok().build();
            } else {
                LOG.warn("⚠️ Insufficient inventory for product " + id);
                return Response.status(400)
                    .entity("Insufficient inventory")
                    .build();
            }
            
        } catch (Exception e) {
            LOG.error("❌ Error reserving product: " + id, e);
            return Response.serverError()
                .entity("Error processing reservation")
                .build();
        }
    }
}
```

---

### Example 2: Logging in Service Layer

**File:** `inventory-service/src/main/java/com/example/inventory/service/InventoryService.java`

```java
package com.example.inventory.service;

import jakarta.enterprise.context.ApplicationScoped;
import org.jboss.logging.Logger;
import java.util.*;

@ApplicationScoped
public class InventoryService {
    
    private static final Logger LOG = Logger.getLogger(InventoryService.class);
    
    private Map<Long, Product> inventory = new HashMap<>();
    
    public InventoryService() {
        LOG.info("🏗️ Initializing InventoryService");
        initializeInventory();
        LOG.info("✅ InventoryService initialized with " + inventory.size() + " products");
    }
    
    private void initializeInventory() {
        LOG.debug("Loading initial inventory data");
        inventory.put(1L, new Product(1L, "Laptop", 100));
        inventory.put(2L, new Product(2L, "Mouse", 250));
        inventory.put(3L, new Product(3L, "Keyboard", 150));
    }
    
    public List<Product> findAll() {
        LOG.debug("Fetching all products from inventory");
        return new ArrayList<>(inventory.values());
    }
    
    public Product findById(Long id) {
        LOG.debug("Searching for product with ID: " + id);
        Product product = inventory.get(id);
        
        if (product == null) {
            LOG.warn("Product not found in inventory: " + id);
        } else {
            LOG.trace("Product found: " + product);
        }
        
        return product;
    }
    
    public boolean reserve(Long productId, int quantity) {
        LOG.info("🔄 Processing reservation - Product: " + productId + ", Qty: " + quantity);
        
        Product product = inventory.get(productId);
        
        if (product == null) {
            LOG.error("❌ Cannot reserve - Product not found: " + productId);
            return false;
        }
        
        if (product.getQuantity() < quantity) {
            LOG.warn("⚠️ Insufficient stock - Available: " + product.getQuantity() + 
                    ", Requested: " + quantity);
            return false;
        }
        
        int oldQuantity = product.getQuantity();
        product.setQuantity(oldQuantity - quantity);
        
        LOG.info("✅ Reservation successful - Product: " + productId + 
                ", Old Qty: " + oldQuantity + 
                ", New Qty: " + product.getQuantity());
        
        return true;
    }
}
```

---

## ⚙️ Logging Configuration

### application.properties Configuration

**File:** `inventory-service/src/main/resources/application.properties`

```properties
# Application name
quarkus.application.name=inventory-service

# HTTP port
quarkus.http.port=8080

# Container Image Configuration
quarkus.container-image.build=true
quarkus.container-image.group=quarkus-microservices
quarkus.container-image.name=inventory-service
quarkus.container-image.tag=latest

# ============================================
# LOGGING CONFIGURATION
# ============================================

# Global log level (TRACE, DEBUG, INFO, WARN, ERROR, OFF)
quarkus.log.level=INFO

# Console logging
quarkus.log.console.enable=true
quarkus.log.console.format=%d{HH:mm:ss.SSS} [%p] [%c{2}] %s%e%n
quarkus.log.console.level=INFO
quarkus.log.console.color=true

# File logging (optional)
quarkus.log.file.enable=true
quarkus.log.file.path=logs/inventory-service.log
quarkus.log.file.level=DEBUG
quarkus.log.file.format=%d{yyyy-MM-dd HH:mm:ss.SSS} [%p] [%t] [%c{3}] %s%e%n
quarkus.log.file.rotation.max-file-size=10M
quarkus.log.file.rotation.max-backup-index=5

# Category-specific log levels
quarkus.log.category."com.example".level=DEBUG
quarkus.log.category."com.example.inventory.resource".level=INFO
quarkus.log.category."com.example.inventory.service".level=DEBUG

# HTTP access logging
quarkus.http.access-log.enabled=true
quarkus.http.access-log.pattern=%h %l %u %t "%r" %s %b "%{i,Referer}" "%{i,User-Agent}"

# Quarkus framework logging (reduce noise)
quarkus.log.category."io.quarkus".level=INFO
quarkus.log.category."io.netty".level=WARN
quarkus.log.category."io.vertx".level=WARN

# SQL logging (if using database)
# quarkus.log.category."org.hibernate.SQL".level=DEBUG
# quarkus.log.category."org.hibernate.type.descriptor.sql.BasicBinder".level=TRACE
```

---

## 🎨 Log Format Patterns

### Format Tokens

| Token | Description | Example |
|-------|-------------|---------|
| `%d{format}` | Date/time | `%d{HH:mm:ss.SSS}` |
| `%p` | Log level | INFO, DEBUG, ERROR |
| `%c` | Logger category | com.example.inventory |
| `%c{2}` | Short category | inventory.InventoryService |
| `%t` | Thread name | executor-thread-1 |
| `%s` | Message | "User logged in" |
| `%e` | Exception | Stack trace |
| `%n` | New line | |
| `%X{key}` | MDC value | Request ID |

### Example Formats

**Development (readable):**
```properties
%d{HH:mm:ss.SSS} [%p] [%c{2}] %s%e%n
```
Output: `12:34:56.789 [INFO] [InventoryResource] Getting all products`

**Production (detailed):**
```properties
%d{yyyy-MM-dd HH:mm:ss.SSS} [%p] [%t] [%c{3}] %s%e%n
```
Output: `2026-01-28 12:34:56.789 [INFO] [executor-thread-1] [inventory.resource.InventoryResource] Getting all products`

---

## 🎯 Logging Best Practices

### 1. Use Appropriate Log Levels

```java
// ✅ Good
LOG.debug("Processing order with details: " + orderDetails);
LOG.info("Order created successfully: " + orderId);
LOG.warn("Low inventory detected for product: " + productId);
LOG.error("Failed to process payment", exception);

// ❌ Bad
LOG.info("Debug info: x=" + x + ", y=" + y);  // Should be DEBUG
LOG.error("User logged in");  // Should be INFO
```

### 2. Include Context

```java
// ✅ Good - Includes context
LOG.info("User " + userId + " created order " + orderId);
LOG.error("Failed to process payment for order " + orderId, exception);

// ❌ Bad - No context
LOG.info("Order created");
LOG.error("Payment failed", exception);
```

### 3. Use String Formatting

```java
// ✅ Good - Efficient (lazy evaluation)
LOG.infof("Processing order %d for user %s", orderId, userId);
LOG.debugf("Values: x=%d, y=%d, z=%d", x, y, z);

// ❌ Bad - Always creates string (even if not logged)
LOG.info("Processing order " + orderId + " for user " + userId);
```

### 4. Log Exceptions Properly

```java
// ✅ Good - Exception with context
try {
    processOrder(order);
} catch (Exception e) {
    LOG.error("Failed to process order: " + order.getId(), e);
    throw e;
}

// ❌ Bad - No exception, just message
try {
    processOrder(order);
} catch (Exception e) {
    LOG.error("Failed to process order: " + e.getMessage());
}
```

### 5. Don't Log Sensitive Data

```java
// ✅ Good - Sanitized
LOG.info("User logged in: " + username);
LOG.debug("Processing payment for order: " + orderId);

// ❌ Bad - Sensitive data
LOG.info("User password: " + password);
LOG.debug("Credit card: " + creditCardNumber);
```

---

## 🔍 Structured Logging with MDC

### Using Mapped Diagnostic Context (MDC)

```java
import org.jboss.logging.MDC;

@Path("/orders")
public class OrderResource {
    
    @POST
    public Response createOrder(Order order) {
        // Add request ID to MDC
        String requestId = UUID.randomUUID().toString();
        MDC.put("requestId", requestId);
        
        try {
            LOG.info("Creating order");  // Will include requestId
            // ... process order ...
            return Response.ok().build();
        } finally {
            MDC.remove("requestId");
        }
    }
}
```

**Configure format to include MDC:**
```properties
quarkus.log.console.format=%d{HH:mm:ss.SSS} [%p] [%X{requestId}] %s%e%n
```

**Output:**
```
12:34:56.789 [INFO] [abc-123-def] Creating order
```

---

## 🎯 Logging in Different Environments

### Development Profile

**File:** `application-dev.properties`

```properties
# Verbose logging for development
quarkus.log.level=DEBUG
quarkus.log.category."com.example".level=TRACE
quarkus.log.console.color=true

# SQL logging
quarkus.log.category."org.hibernate.SQL".level=DEBUG
```

### Production Profile

**File:** `application-prod.properties`

```properties
# Less verbose for production
quarkus.log.level=INFO
quarkus.log.category."com.example".level=INFO

# File logging only
quarkus.log.console.enable=false
quarkus.log.file.enable=true
quarkus.log.file.path=/var/log/inventory-service.log
```

### Test Profile

**File:** `application-test.properties`

```properties
# Minimal logging for tests
quarkus.log.level=WARN
quarkus.log.category."com.example".level=INFO
quarkus.log.console.enable=true
```

---

## 🐛 Debugging Techniques

### 1. Request Tracing

```java
@Path("/inventory")
public class InventoryResource {
    
    @GET
    @Path("/{id}")
    public Product getById(@PathParam("id") Long id) {
        LOG.info("=== START: Get product by ID ===");
        LOG.debug("Request parameters - ID: " + id);
        
        try {
            Product product = inventoryService.findById(id);
            LOG.debug("Service returned: " + product);
            
            if (product == null) {
                LOG.warn("Product not found - returning 404");
            } else {
                LOG.info("Product found - returning 200");
            }
            
            return product;
        } finally {
            LOG.info("=== END: Get product by ID ===");
        }
    }
}
```

### 2. Performance Logging

```java
public Product getById(Long id) {
    long startTime = System.currentTimeMillis();
    LOG.debug("Starting product lookup for ID: " + id);
    
    try {
        Product product = inventory.get(id);
        long duration = System.currentTimeMillis() - startTime;
        
        LOG.debugf("Product lookup completed in %dms", duration);
        
        if (duration > 100) {
            LOG.warn("Slow query detected: " + duration + "ms");
        }
        
        return product;
    } catch (Exception e) {
        long duration = System.currentTimeMillis() - startTime;
        LOG.errorf(e, "Product lookup failed after %dms", duration);
        throw e;
    }
}
```

### 3. State Debugging

```java
public boolean reserve(Long productId, int quantity) {
    LOG.debugf("BEFORE: Product %d has quantity %d", 
              productId, product.getQuantity());
    
    product.setQuantity(product.getQuantity() - quantity);
    
    LOG.debugf("AFTER: Product %d has quantity %d", 
              productId, product.getQuantity());
    
    return true;
}
```

---

## 📊 Viewing Logs

### In Dev Mode

**Console output shows all logs:**
```bash
mvn quarkus:dev

12:34:56.789 [INFO] [InventoryResource] 📋 Getting all products
12:34:56.790 [DEBUG] [InventoryService] Fetching all products from inventory
12:34:56.791 [INFO] [InventoryResource] ✅ Found 3 products
```

### In Dev UI

```
http://localhost:8080/q/dev
→ Click "Logging" card
→ View logs with filtering
→ Change log levels dynamically
```

### In Production

**Check log files:**
```bash
tail -f logs/inventory-service.log
```

**Or use Docker/Podman logs:**
```bash
podman logs -f inventory-service
```

---

## 🚀 Testing Your Logging

### Step 1: Add Logging

Edit `InventoryResource.java` and add logs (see examples above)

### Step 2: Start Dev Mode

```bash
mvn quarkus:dev
```

### Step 3: Make Requests

```bash
curl http://localhost:8080/inventory
curl http://localhost:8080/inventory/1
```

### Step 4: Check Console

You'll see:
```
12:34:56.789 [INFO] [InventoryResource] 📋 Getting all products
12:34:56.790 [DEBUG] [InventoryService] Fetching all products
12:34:56.791 [INFO] [InventoryResource] ✅ Found 3 products
```

---

## 📋 Quick Reference

### Import Statement
```java
import org.jboss.logging.Logger;
```

### Logger Declaration
```java
private static final Logger LOG = Logger.getLogger(YourClass.class);
```

### Log Methods
```java
LOG.trace("Very detailed");
LOG.debug("Debug info");
LOG.info("General info");
LOG.warn("Warning");
LOG.error("Error", exception);
```

### Formatted Logging
```java
LOG.infof("User %s created order %d", username, orderId);
LOG.debugf("Values: x=%d, y=%d", x, y);
```

### Configuration (application.properties)
```properties
quarkus.log.level=INFO
quarkus.log.category."com.example".level=DEBUG
quarkus.log.console.enable=true
quarkus.log.file.enable=true
quarkus.log.file.path=logs/app.log
```

---

## ✅ Summary

**Logging gives you:**
- 🔍 Visibility into what's happening
- 🐛 Easy debugging
- 📊 Performance monitoring
- ⚠️ Error tracking
- 📝 Audit trail

**Quick Setup:**
1. Import Logger
2. Declare LOG
3. Add log statements
4. Configure in application.properties
5. View in console or files

**Your microservices now have professional logging! 📝✨**

