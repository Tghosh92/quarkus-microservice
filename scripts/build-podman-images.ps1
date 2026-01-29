# Build Podman Images Script
# This script builds both microservice images and displays them

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Building Quarkus Microservices" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to project directory
$projectDir = "C:\Users\ghosht\OneDrive - Amadeus Workplace\Documents\Orion\testproject"
Set-Location $projectDir

# Build Inventory Service
Write-Host "[1/2] Building Inventory Service..." -ForegroundColor Green
Set-Location "$projectDir\inventory-service"
$inventoryBuild = podman build -t inventory-service:latest . 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Inventory Service built successfully!" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to build Inventory Service" -ForegroundColor Red
    Write-Host $inventoryBuild
}

Write-Host ""

# Build Order Service
Write-Host "[2/2] Building Order Service..." -ForegroundColor Green
Set-Location "$projectDir\order-service"
$orderBuild = podman build -t order-service:latest . 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Order Service built successfully!" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to build Order Service" -ForegroundColor Red
    Write-Host $orderBuild
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Built Images:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Return to project directory
Set-Location $projectDir

# Display images
podman images | Select-String -Pattern "inventory-service|order-service|REPOSITORY"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Next Steps:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "1. View all images: " -NoNewline
Write-Host "podman images" -ForegroundColor Yellow
Write-Host "2. Run services: " -NoNewline
Write-Host ".\run-podman-services.ps1" -ForegroundColor Yellow
Write-Host "3. Stop services: " -NoNewline
Write-Host ".\stop-podman-services.ps1" -ForegroundColor Yellow
Write-Host ""

