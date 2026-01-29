# 🔍 How to Check if Your Services Are Running

## Quick Status Check

### Check Container Status
```bash
podman ps
```

**Expected output if services are running:**
```
CONTAINER ID  IMAGE                                           STATUS          PORTS                   NAMES
abc123def456  localhost/quarkus-microservices/inventory-service  Up 5 minutes    0.0.0.0:8080->8080/tcp  inventory-service
xyz789ghi012  localhost/quarkus-microservices/order-service      Up 5 minutes    0.0.0.0:8081->8081/tcp  order-service
```

### View All Containers (Including Stopped)
```bash
podman ps -a
```

---

## 🌐 Test Service Endpoints

### 1. Test Inventory Service (Port 8080)
```bash
# PowerShell
Invoke-RestMethod http://localhost:8080/inventory

# Or with curl
curl http://localhost:8080/inventory
```

**Expected response:**
```json
[
  {"id": 1, "name": "Laptop", "quantity": 10},
  {"id": 2, "name": "Mouse", "quantity": 50},
  {"id": 3, "name": "Keyboard", "quantity": 30}
]
```

### 2. Test Order Service (Port 8081)
```bash
# PowerShell
Invoke-RestMethod http://localhost:8081/orders

# Or with curl
curl http://localhost:8081/orders
```

**Expected response:**
```json
[]
```
(Empty array initially, until you create orders)

---

## 📊 View Service Logs

### View Inventory Service Logs
```bash
# Show last 50 lines
podman logs --tail 50 inventory-service

# Follow logs in real-time
podman logs -f inventory-service
```

### View Order Service Logs
```bash
# Show last 50 lines
podman logs --tail 50 order-service

# Follow logs in real-time
podman logs -f order-service
```

**What to look for in logs:**
```
__  ____  __  _____   ___  __ ____  ______ 
 --/ __ \/ / / / _ | / _ \/ //_/ / / / __/ 
 -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \   
--\___\_\____/_/ |_/_/|_/_/|_|\____/___/   
Listening on: http://0.0.0.0:8080
```

---

## 🩺 Health Check Commands

### Check if Port is Listening
```powershell
# Check port 8080 (Inventory)
Test-NetConnection -ComputerName localhost -Port 8080

# Check port 8081 (Order)
Test-NetConnection -ComputerName localhost -Port 8081
```

**Expected output:**
```
TcpTestSucceeded : True
```

### Using netstat
```bash
netstat -ano | findstr :8080
netstat -ano | findstr :8081
```

---

## 🎯 Complete Health Check Script

I'll create a PowerShell script to check everything:

**File: `check-services.ps1`**
```powershell
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Service Health Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check containers
Write-Host "1. Checking Container Status..." -ForegroundColor Yellow
$containers = podman ps --format "{{.Names}}\t{{.Status}}" 2>$null
if ($containers) {
    Write-Host $containers -ForegroundColor Green
} else {
    Write-Host "No containers running!" -ForegroundColor Red
}

Write-Host ""

# Check Inventory Service
Write-Host "2. Testing Inventory Service (Port 8080)..." -ForegroundColor Yellow
try {
    $inventory = Invoke-RestMethod -Uri "http://localhost:8080/inventory" -TimeoutSec 3 -ErrorAction Stop
    Write-Host "✓ Inventory Service is UP - $($inventory.Count) products available" -ForegroundColor Green
} catch {
    Write-Host "✗ Inventory Service is DOWN" -ForegroundColor Red
}

Write-Host ""

# Check Order Service
Write-Host "3. Testing Order Service (Port 8081)..." -ForegroundColor Yellow
try {
    $orders = Invoke-RestMethod -Uri "http://localhost:8081/orders" -TimeoutSec 3 -ErrorAction Stop
    Write-Host "✓ Order Service is UP - $($orders.Count) orders found" -ForegroundColor Green
} catch {
    Write-Host "✗ Order Service is DOWN" -ForegroundColor Red
}

Write-Host ""

# Check ports
Write-Host "4. Checking Ports..." -ForegroundColor Yellow
$port8080 = Test-NetConnection -ComputerName localhost -Port 8080 -WarningAction SilentlyContinue
$port8081 = Test-NetConnection -ComputerName localhost -Port 8081 -WarningAction SilentlyContinue

if ($port8080.TcpTestSucceeded) {
    Write-Host "✓ Port 8080 is OPEN" -ForegroundColor Green
} else {
    Write-Host "✗ Port 8080 is CLOSED" -ForegroundColor Red
}

if ($port8081.TcpTestSucceeded) {
    Write-Host "✓ Port 8081 is OPEN" -ForegroundColor Green
} else {
    Write-Host "✗ Port 8081 is CLOSED" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Health Check Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
```

---

## 🚀 Quick Commands Reference

### Check Services
```bash
# Are containers running?
podman ps

# Service logs
podman logs -f inventory-service
podman logs -f order-service

# Test endpoints
curl http://localhost:8080/inventory
curl http://localhost:8081/orders
```

### Start Services (if not running)
```bash
# Start inventory service
podman run -d --name inventory-service -p 8080:8080 quarkus-microservices/inventory-service:latest

# Start order service
podman run -d --name order-service -p 8081:8081 quarkus-microservices/order-service:latest
```

### Stop Services
```bash
podman stop inventory-service order-service
```

### Restart Services
```bash
podman restart inventory-service order-service
```

---

## 🌐 Access URLs

Once running, access services at:
- **Inventory Service:** http://localhost:8080/inventory
- **Order Service:** http://localhost:8081/orders

---

## 🐛 Troubleshooting

### Services Not Running?
```bash
# Check if containers exist but are stopped
podman ps -a

# Start them
podman start inventory-service order-service
```

### Port Already in Use?
```bash
# Find what's using the port
netstat -ano | findstr :8080

# Kill the process (replace PID)
taskkill /PID <process_id> /F
```

### Container Errors?
```bash
# View error logs
podman logs inventory-service
podman logs order-service

# Remove and recreate
podman rm -f inventory-service order-service
podman run -d --name inventory-service -p 8080:8080 quarkus-microservices/inventory-service:latest
podman run -d --name order-service -p 8081:8081 quarkus-microservices/order-service:latest
```

---

## 📊 Monitor Resource Usage

```bash
# View real-time stats
podman stats

# View specific container stats
podman stats inventory-service order-service
```

**Output shows:**
- CPU usage
- Memory usage
- Network I/O
- Block I/O

---

## ✅ Summary

**Quick check if services are running:**
```bash
podman ps
```

**Full health check:**
```bash
.\check-services.ps1
```

**Test endpoints:**
```bash
curl http://localhost:8080/inventory
curl http://localhost:8081/orders
```

**View logs:**
```bash
podman logs -f order-service
```

---

**Your services are running if you see them in `podman ps` and can access the URLs!** 🚀

