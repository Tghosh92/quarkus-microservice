# 🚀 Quick Reference Card

## Single Command to Build Everything

```bash
mvn -s ./.mvn/settings.xml clean install
```

**Or simply:**
```bash
.\build.bat
```

---

## What Gets Built

✅ Inventory Service (compiled + container image)  
✅ Order Service (compiled + container image)  
✅ Installed to local Maven repository  

---

## View Images

```bash
podman images
```

## Run Services

```bash
# Start inventory service
podman run -d -p 8080:8080 quarkus-microservices/inventory-service:latest

# Start order service
podman run -d -p 8081:8081 quarkus-microservices/order-service:latest
```

## Test Services

```bash
# Test inventory
curl http://localhost:8080/inventory

# Create order
curl -X POST http://localhost:8081/orders -H "Content-Type: application/json" -d '{"productId": 1, "quantity": 2}'
```

---

## Files Created

- ✅ `.mvn/settings.xml` - Maven configuration
- ✅ `pom.xml` (root) - Parent POM
- ✅ `build.bat` - One-click build script

---

**That's all you need to know!** 🎉

