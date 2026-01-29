@echo off
echo ========================================
echo Container Status Check
echo ========================================
echo.

echo === Podman Version ===
podman version 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Podman not found or not running!
    pause
    exit /b 1
)

echo.
echo === All Images ===
podman images

echo.
echo === Running Containers ===
podman ps

echo.
echo === All Containers (including stopped) ===
podman ps -a

echo.
echo === Network Ports in Use ===
netstat -ano | findstr ":8080"
netstat -ano | findstr ":8081"

echo.
echo === Java Processes ===
tasklist | findstr "java.exe"

echo.
pause

