@echo off
echo ========================================
echo Starting Microservices
echo ========================================
echo.

REM Navigate to project root (parent of scripts folder)
cd /d "%~dp0.."

REM Kill existing processes on these ports
echo Cleaning up ports 8080 and 8081...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8080.*LISTENING" 2^>nul') do taskkill /F /PID %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8081.*LISTENING" 2^>nul') do taskkill /F /PID %%a >nul 2>&1
timeout /t 2 /nobreak >nul

REM Check if JAR files exist
if not exist "inventory-service\target\quarkus-app\quarkus-run.jar" (
    echo ERROR: Inventory service not built!
    echo Run: BUILD.bat first
    pause
    exit /b 1
)

if not exist "order-service\target\quarkus-app\quarkus-run.jar" (
    echo ERROR: Order service not built!
    echo Run: BUILD.bat first
    pause
    exit /b 1
)

echo Starting Inventory Service (Port 8080)...
start "INVENTORY-SERVICE-8080" cmd /k "cd /d "%~dp0..\inventory-service" && echo ========== INVENTORY SERVICE ========== && echo Port: 8080 && echo Endpoint: http://localhost:8080/inventory && echo ====================================== && echo. && java -jar target\quarkus-app\quarkus-run.jar"

echo Waiting 20 seconds for Inventory Service...
timeout /t 20 /nobreak

echo.
echo Starting Order Service (Port 8081)...
start "ORDER-SERVICE-8081" cmd /k "cd /d "%~dp0..\order-service" && echo ========== ORDER SERVICE ========== && echo Port: 8081 && echo Endpoint: http://localhost:8081/orders && echo =================================== && echo. && java -jar target\quarkus-app\quarkus-run.jar"

echo Waiting 20 seconds for Order Service...
timeout /t 20 /nobreak

echo.
echo ========================================
echo Checking Service Status
echo ========================================
echo.

netstat -ano | findstr ":8080.*LISTENING" >nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] Inventory Service is running on port 8080
) else (
    echo [FAIL] Inventory Service is NOT running on port 8080
)

netstat -ano | findstr ":8081.*LISTENING" >nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] Order Service is running on port 8081
) else (
    echo [FAIL] Order Service is NOT running on port 8081
)

echo.
echo ========================================
echo Ready for Testing
echo ========================================
echo.
echo Postman URLs:
echo   GET  http://localhost:8080/inventory
echo   GET  http://localhost:8081/orders
echo.
echo PowerShell Test:
echo   Invoke-WebRequest http://localhost:8080/inventory
echo   Invoke-WebRequest http://localhost:8081/orders
echo.
echo Press any key to close this window (services will keep running)
pause >nul

