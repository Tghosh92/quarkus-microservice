# Service Health Check Script
# Checks if microservices are running and healthy

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Microservices Health Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check containers
Write-Host "1. Checking Container Status..." -ForegroundColor Yellow
Write-Host "   Running: podman ps" -ForegroundColor Gray
$containers = podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>$null | Select-String -Pattern "inventory|order|NAMES"

if ($containers) {
    $containers | ForEach-Object { Write-Host "   $_" -ForegroundColor Green }
    Write-Host ""
} else {
    Write-Host "   ✗ No microservice containers running!" -ForegroundColor Red
    Write-Host ""
    Write-Host "   To start services, run:" -ForegroundColor Yellow
    Write-Host "   .\run-services.bat" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

# Check Inventory Service
Write-Host "2. Testing Inventory Service (http://localhost:8080)..." -ForegroundColor Yellow
try {
    $inventory = Invoke-RestMethod -Uri "http://localhost:8080/inventory" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "   ✓ Inventory Service is UP" -ForegroundColor Green
    Write-Host "   ✓ Products available: $($inventory.Count)" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Inventory Service is DOWN or not responding" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Gray
}

Write-Host ""

# Check Order Service
Write-Host "3. Testing Order Service (http://localhost:8081)..." -ForegroundColor Yellow
try {
    $orders = Invoke-RestMethod -Uri "http://localhost:8081/orders" -TimeoutSec 5 -ErrorAction Stop
    Write-Host "   ✓ Order Service is UP" -ForegroundColor Green
    Write-Host "   ✓ Orders in system: $($orders.Count)" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Order Service is DOWN or not responding" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Gray
}

Write-Host ""

# Check ports
Write-Host "4. Checking Network Ports..." -ForegroundColor Yellow
$port8080 = Test-NetConnection -ComputerName localhost -Port 8080 -WarningAction SilentlyContinue -InformationLevel Quiet
$port8081 = Test-NetConnection -ComputerName localhost -Port 8081 -WarningAction SilentlyContinue -InformationLevel Quiet

if ($port8080) {
    Write-Host "   ✓ Port 8080 (Inventory) is OPEN" -ForegroundColor Green
} else {
    Write-Host "   ✗ Port 8080 (Inventory) is CLOSED" -ForegroundColor Red
}

if ($port8081) {
    Write-Host "   ✓ Port 8081 (Order) is OPEN" -ForegroundColor Green
} else {
    Write-Host "   ✗ Port 8081 (Order) is CLOSED" -ForegroundColor Red
}

Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Health Check Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Access Services:" -ForegroundColor Yellow
Write-Host "  Inventory: http://localhost:8080/inventory" -ForegroundColor Cyan
Write-Host "  Orders:    http://localhost:8081/orders" -ForegroundColor Cyan
Write-Host ""
Write-Host "View Logs:" -ForegroundColor Yellow
Write-Host "  podman logs -f inventory-service" -ForegroundColor Cyan
Write-Host "  podman logs -f order-service" -ForegroundColor Cyan
Write-Host ""

