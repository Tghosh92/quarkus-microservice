@echo off
REM Run services using Java (without containers)
echo ========================================
echo Starting Microservices with Java
echo ========================================
echo.

cd /d "%~dp0"

REM Start inventory service
echo Starting Inventory Service on port 8080...
start "Inventory Service" cmd /k "cd inventory-service && java -jar target\quarkus-app\quarkus-run.jar"

echo Waiting 10 seconds for inventory service to start...
timeout /t 10 /nobreak

REM Start order service
echo Starting Order Service on port 8081...
start "Order Service" cmd /k "cd order-service && java -jar target\quarkus-app\quarkus-run.jar"

echo.
echo ========================================
echo Services Starting!
echo ========================================
echo.
echo Access services at:
echo Inventory: http://localhost:8080/inventory
echo Orders:    http://localhost:8081/orders
echo.
echo Close the opened windows to stop services.
echo.
pause

