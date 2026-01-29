@echo off
REM Quick Git Push Script
echo ========================================
echo Git Push Helper
echo ========================================
echo.

cd /d "%~dp0"

echo This script will help you push to GitHub.
echo.
echo Prerequisites:
echo - Git installed
echo - GitHub account created
echo - Repository created on GitHub
echo.
pause

echo.
echo Step 1: Initializing Git (if needed)...
if not exist ".git" (
    git init
    echo Git initialized!
) else (
    echo Git already initialized.
)

echo.
echo Step 2: Adding files...
git add .

echo.
echo Step 3: Creating commit...
set /p COMMIT_MSG="Enter commit message (or press Enter for default): "
if "%COMMIT_MSG%"=="" set COMMIT_MSG=Update: Latest changes

git commit -m "%COMMIT_MSG%"

echo.
echo Step 4: Adding remote (if needed)...
set /p GITHUB_URL="Enter your GitHub repository URL (or press Enter to skip): "
if not "%GITHUB_URL%"=="" (
    git remote remove origin 2>nul
    git remote add origin %GITHUB_URL%
    echo Remote added!
)

echo.
echo Step 5: Setting main branch...
git branch -M main

echo.
echo Step 6: Pushing to GitHub...
echo.
echo You may be asked for authentication.
echo Use your Personal Access Token as password!
echo.
pause

git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo SUCCESS! 🎉
    echo ========================================
    echo.
    echo Your code is now on GitHub!
    echo.
) else (
    echo.
    echo ========================================
    echo PUSH FAILED
    echo ========================================
    echo.
    echo Common issues:
    echo - Authentication failed: Use Personal Access Token
    echo - Remote not set: Run script again with repository URL
    echo - Network issues: Check internet connection
    echo.
)

pause

