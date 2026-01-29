@echo off
REM SINGLE COMMAND BUILD - Builds both services and creates images
cd /d "%~dp0"
mvn -s .\.mvn\settings.xml clean install

