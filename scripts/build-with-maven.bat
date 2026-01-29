@echo off
REM Single command to build both services and create images
REM Navigate to project root (parent of scripts folder)
cd /d "%~dp0.."
cd inventory-service && call mvn clean package -Dquarkus.container-image.build=true -DskipTests && cd ../order-service && call mvn clean package -Dquarkus.container-image.build=true -DskipTests && cd .. && echo. && echo BUILD COMPLETE! && podman images | findstr "quarkus-microservices"

