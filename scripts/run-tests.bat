@echo off
REM Run unit tests for both microservices
echo ========================================
echo Running Unit Tests
echo ========================================
echo.

cd /d "%~dp0.."

echo Testing Inventory Service...
echo.
cd inventory-service
call mvn test
set INVENTORY_RESULT=%ERRORLEVEL%

echo.
echo Testing Order Service...
echo.
cd ../order-service
call mvn test
set ORDER_RESULT=%ERRORLEVEL%

cd ..

echo.
echo ========================================
echo Test Results Summary
echo ========================================
echo.

if %INVENTORY_RESULT% EQU 0 (
    echo [PASS] Inventory Service Tests: SUCCESS
) else (
    echo [FAIL] Inventory Service Tests: FAILED
)

if %ORDER_RESULT% EQU 0 (
    echo [PASS] Order Service Tests: SUCCESS
) else (
    echo [FAIL] Order Service Tests: FAILED
)

echo.
if %INVENTORY_RESULT% EQU 0 if %ORDER_RESULT% EQU 0 (
    echo ========================================
    echo ALL TESTS PASSED!
    echo ========================================
) else (
    echo ========================================
    echo SOME TESTS FAILED!
    echo ========================================
    pause
    exit /b 1
)

echo.
pause

