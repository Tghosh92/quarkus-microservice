@echo off
REM Build both services using Maven settings.xml
echo ========================================
echo Building Microservices
echo ========================================
echo.

cd /d "%~dp0"

echo Building with: mvn -s ./.mvn/settings.xml clean install
echo.
mvn -s ./.mvn/settings.xml clean install

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    pause
    exit /b 1
)

echo.
echo ========================================
echo BUILD COMPLETE!
echo ========================================
echo.
echo Container images created:
podman images | findstr "quarkus-microservices"
echo.
pause

