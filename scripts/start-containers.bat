@echo off
REM Start microservices containers with proper configuration

echo ========================================
echo Starting Microservices Containers
echo ========================================
echo.

REM Stop and remove old containers if they exist
echo Cleaning up old containers...
podman stop inventory-service order-service 2>nul
podman rm inventory-service order-service 2>nul

REM Create network if it doesn't exist
echo Creating network...
podman network create microservices-network 2>nul

echo.
echo Starting Inventory Service on port 8080...
podman run -d ^
  --name inventory-service ^
  --network microservices-network ^
  -p 8080:8080 ^
  localhost/quarkus-microservices/inventory-service:latest

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to start inventory-service
    pause
    exit /b 1
)

echo Waiting 10 seconds for inventory service to initialize...
timeout /t 10 /nobreak

echo.
echo Starting Order Service on port 8081...
podman run -d ^
  --name order-service ^
  --network microservices-network ^
  -p 8081:8081 ^
  -e QUARKUS_REST_CLIENT_INVENTORY_API_URL=http://inventory-service:8080 ^
  localhost/quarkus-microservices/order-service:latest

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to start order-service
    pause
    exit /b 1
)

echo.
echo ========================================
echo Services Started Successfully!
echo ========================================
echo.
podman ps
echo.
echo Access services at:
echo   Inventory: http://localhost:8080/inventory
echo   Orders:    http://localhost:8081/orders
echo.
echo To view logs:
echo   podman logs -f inventory-service
echo   podman logs -f order-service
echo.
echo To stop services:
echo   podman stop inventory-service order-service
echo.
pause

