@echo off
echo ========================================
echo Stopping Microservices
echo ========================================
echo.

REM Kill processes by window title
taskkill /FI "WINDOWTITLE eq INVENTORY-SERVICE-8080*" /F 2>nul
taskkill /FI "WINDOWTITLE eq ORDER-SERVICE-8081*" /F 2>nul

REM Kill processes on ports
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8080.*LISTENING" 2^>nul') do (
    echo Killing process on port 8080: PID %%a
    taskkill /F /PID %%a >nul 2>&1
)

for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8081.*LISTENING" 2^>nul') do (
    echo Killing process on port 8081: PID %%a
    taskkill /F /PID %%a >nul 2>&1
)

echo.
echo Services stopped.
timeout /t 2 /nobreak >nul

REM Verify
netstat -ano | findstr ":808" | findstr "LISTENING"
if %ERRORLEVEL% EQU 0 (
    echo WARNING: Some processes may still be running on ports 8080/8081
) else (
    echo SUCCESS: All services stopped, ports are free.
)

echo.
pause

