# Run Podman Services Script
# This script runs both microservices in containers

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Microservices with Podman" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create network if it doesn't exist
Write-Host "Creating network (if needed)..." -ForegroundColor Yellow
podman network create microservices-network 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Network created" -ForegroundColor Green
} else {
    Write-Host "→ Network already exists" -ForegroundColor Gray
}

Write-Host ""

# Stop and remove existing containers if they exist
Write-Host "Cleaning up old containers..." -ForegroundColor Yellow
podman stop inventory-service order-service 2>$null
podman rm inventory-service order-service 2>$null

Write-Host ""

# Start Inventory Service
Write-Host "Starting Inventory Service..." -ForegroundColor Green
podman run -d `
    --name inventory-service `
    --network microservices-network `
    -p 8080:8080 `
    inventory-service:latest

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Inventory Service started on port 8080" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to start Inventory Service" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Waiting for Inventory Service to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Start Order Service
Write-Host "Starting Order Service..." -ForegroundColor Green
podman run -d `
    --name order-service `
    --network microservices-network `
    -p 8081:8081 `
    -e QUARKUS_REST_CLIENT_INVENTORY_API_URL=http://inventory-service:8080 `
    order-service:latest

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Order Service started on port 8081" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to start Order Service" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Services Running:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Display running containers
podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Access Services:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Inventory Service: " -NoNewline
Write-Host "http://localhost:8080/inventory" -ForegroundColor Cyan
Write-Host "Order Service:     " -NoNewline
Write-Host "http://localhost:8081/orders" -ForegroundColor Cyan

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Useful Commands:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "View logs:   " -NoNewline
Write-Host "podman logs -f order-service" -ForegroundColor Yellow
Write-Host "Test API:    " -NoNewline
Write-Host ".\test-services.ps1" -ForegroundColor Yellow
Write-Host "Stop all:    " -NoNewline
Write-Host ".\stop-podman-services.ps1" -ForegroundColor Yellow
Write-Host ""

