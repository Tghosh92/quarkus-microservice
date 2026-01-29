@echo off
setlocal enabledelayedexpansion

REM Kill any existing Java processes running the services
echo Stopping any existing services...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8080.*LISTENING"') do taskkill /F /PID %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8081.*LISTENING"') do taskkill /F /PID %%a >nul 2>&1

timeout /t 2 /nobreak >nul

echo ========================================
echo Starting Microservices with Java
echo ========================================
echo.

cd /d "%~dp0"

REM Check if JAR files exist
if not exist "inventory-service\target\quarkus-app\quarkus-run.jar" (
    echo ERROR: Inventory service JAR not found!
    echo Please run build-with-maven.bat first.
    pause
    exit /b 1
)

if not exist "order-service\target\quarkus-app\quarkus-run.jar" (
    echo ERROR: Order service JAR not found!
    echo Please run build-with-maven.bat first.
    pause
    exit /b 1
)

REM Start inventory service
echo Starting Inventory Service on port 8080...
start "Inventory Service - Port 8080" /MIN cmd /k "cd /d "%~dp0inventory-service" && echo Starting Inventory Service... && java -jar target\quarkus-app\quarkus-run.jar"

echo Waiting 15 seconds for inventory service to start...
timeout /t 15 /nobreak

REM Check if inventory service started
netstat -ano | findstr ":8080.*LISTENING" >nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Inventory service failed to start on port 8080
    pause
    exit /b 1
)
echo SUCCESS: Inventory service is running!

REM Start order service
echo.
echo Starting Order Service on port 8081...
start "Order Service - Port 8081" /MIN cmd /k "cd /d "%~dp0order-service" && echo Starting Order Service... && java -jar target\quarkus-app\quarkus-run.jar"

echo Waiting 15 seconds for order service to start...
timeout /t 15 /nobreak

REM Check if order service started
netstat -ano | findstr ":8081.*LISTENING" >nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Order service failed to start on port 8081
    pause
    exit /b 1
)
echo SUCCESS: Order service is running!

echo.
echo ========================================
echo Services Started Successfully!
echo ========================================
echo.
echo Services are running:
echo   - Inventory Service: http://localhost:8080/inventory
echo   - Order Service:     http://localhost:8081/orders
echo.
echo Use Postman with these URLs:
echo   - Inventory: http://localhost:8080
echo   - Orders:    http://localhost:8081
echo.
echo To stop services, close the opened windows or run:
echo   taskkill /FI "WINDOWTITLE eq Inventory*" /F
echo   taskkill /FI "WINDOWTITLE eq Order*" /F
echo.
pause

