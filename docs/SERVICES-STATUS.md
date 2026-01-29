# ✅ YOUR SERVICES ARE RUNNING!

## 📊 Current Status

I checked your system and found:

### Running Containers:
✅ **Order Service** - Running for 2 minutes
   - Container: `boring_chaplygin`
   - Ports: 8080-8081, 8443
   
✅ **Inventory Service** - Running for 2 minutes  
   - Container: `festive_robinson`
   - Ports: 8082→8080, 8444→8443

---

## 🌐 How to Access Your Services

### Inventory Service:
```
http://localhost:8082/inventory
```
(Note: It's mapped to port 8082, not 8080)

### Order Service:
```
http://localhost:8080/orders
```
or
```
http://localhost:8081/orders
```

---

## 🔍 Quick Check Commands

### See Running Containers:
```bash
podman ps
```

### Test Endpoints:
```bash
# Inventory (note port 8082!)
curl http://localhost:8082/inventory

# Orders
curl http://localhost:8080/orders
```

Or in PowerShell:
```powershell
Invoke-RestMethod http://localhost:8082/inventory
Invoke-RestMethod http://localhost:8080/orders
```

### View Logs:
```bash
# Order service
podman logs -f boring_chaplygin

# Inventory service  
podman logs -f festive_robinson
```

---

## 📋 Management Commands

### Stop Services:
```bash
podman stop boring_chaplygin festive_robinson
```

### Restart Services:
```bash
podman restart boring_chaplygin festive_robinson
```

### Remove Containers:
```bash
podman rm -f boring_chaplygin festive_robinson
```

---

## 🚀 Quick Test

Try this in PowerShell:
```powershell
# Test inventory service
Invoke-RestMethod http://localhost:8082/inventory

# Test order service  
Invoke-RestMethod http://localhost:8080/orders

# Create an order
$order = @{ productId = 1; quantity = 2 } | ConvertTo-Json
Invoke-RestMethod -Uri http://localhost:8080/orders -Method Post -ContentType "application/json" -Body $order
```

---

## ✅ Your Services Status: RUNNING! 🎉

Both microservices are up and running successfully!

