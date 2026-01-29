# Stop Podman Services Script
# This script stops and removes the microservice containers

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Stopping Microservices" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Stop containers
Write-Host "Stopping containers..." -ForegroundColor Yellow
podman stop inventory-service order-service 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Containers stopped" -ForegroundColor Green
} else {
    Write-Host "→ No containers were running" -ForegroundColor Gray
}

Write-Host ""

# Remove containers
Write-Host "Removing containers..." -ForegroundColor Yellow
podman rm inventory-service order-service 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Containers removed" -ForegroundColor Green
} else {
    Write-Host "→ No containers to remove" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Current Status:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Show running containers
$running = podman ps --format "table {{.Names}}\t{{.Status}}" | Select-String -Pattern "inventory|order"
if ($running) {
    Write-Host $running
} else {
    Write-Host "No microservice containers running" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Services stopped!" -ForegroundColor Green
Write-Host ""
Write-Host "To start again: " -NoNewline
Write-Host ".\run-podman-services.ps1" -ForegroundColor Yellow
Write-Host "To rebuild:     " -NoNewline
Write-Host ".\build-podman-images.ps1" -ForegroundColor Yellow
Write-Host ""

