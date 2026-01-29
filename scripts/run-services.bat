@echo off
REM Run services script for Podman/Docker
REM Run this after building images

echo ========================================
echo Starting Microservices
echo ========================================
echo.

REM Check if podman exists
where podman >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set CONTAINER_CMD=podman
    goto :run
)

REM Check if docker exists
where docker >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set CONTAINER_CMD=docker
    goto :run
)

echo ERROR: Neither Podman nor Docker found!
pause
exit /b 1

:run
echo Creating network...
%CONTAINER_CMD% network create microservices-network 2>nul

echo Stopping old containers if any...
%CONTAINER_CMD% stop inventory-service order-service 2>nul
%CONTAINER_CMD% rm inventory-service order-service 2>nul

echo.
echo Starting Inventory Service on port 8080...
%CONTAINER_CMD% run -d --name inventory-service --network microservices-network -p 8080:8080 inventory-service:latest
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to start inventory-service
    pause
    exit /b 1
)
echo SUCCESS: Inventory service started!

echo Waiting 10 seconds for inventory service to initialize...
timeout /t 10 /nobreak >nul

echo.
echo Starting Order Service on port 8081...
%CONTAINER_CMD% run -d --name order-service --network microservices-network -p 8081:8081 -e QUARKUS_REST_CLIENT_INVENTORY_API_URL=http://inventory-service:8080 order-service:latest
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to start order-service
    pause
    exit /b 1
)
echo SUCCESS: Order service started!

echo.
echo ========================================
echo Services Running!
echo ========================================
echo.
%CONTAINER_CMD% ps
echo.
echo Access services at:
echo Inventory: http://localhost:8080/inventory
echo Orders:    http://localhost:8081/orders
echo.
echo View logs: %CONTAINER_CMD% logs -f order-service
echo Stop all:  stop-services.bat
echo.
pause

