# 🚀 SINGLE COMMAND TO BUILD AND CREATE IMAGES

## ⚡ The Simplest Command

Just run:

```bash
mvn -s ./.mvn/settings.xml clean install
```

That's it! One command builds both services and creates container images! 🎉

---

## 🎯 What This Does

This single command:
1. ✅ Uses custom Maven settings from `.mvn/settings.xml`
2. ✅ Cleans previous builds
3. ✅ Builds inventory-service
4. ✅ Creates inventory-service container image
5. ✅ Installs to local Maven repository
6. ✅ Builds order-service
7. ✅ Creates order-service container image
8. ✅ Installs to local Maven repository

All configured via the settings.xml file!

---

## 📁 Project Structure

```
testproject/
├── .mvn/
│   └── settings.xml          ← Custom Maven settings
├── pom.xml                   ← Parent POM (multi-module)
├── build.bat                 ← One-click build script
├── inventory-service/
│   └── pom.xml
└── order-service/
    └── pom.xml
```

---

## 🚀 Quick Build Options

### Option 1: Use the Batch Script (Easiest)
```bash
.\build.bat
```

### Option 2: Direct Maven Command
```bash
mvn -s ./.mvn/settings.xml clean install
```

### Option 3: Without Settings File (Manual flags)
```bash
mvn clean install -Dquarkus.container-image.build=true -DskipTests
```

---

## ⚙️ Settings Configuration

The `.mvn/settings.xml` contains:

```xml
<profile>
    <id>quarkus</id>
    <activation>
        <activeByDefault>true</activeByDefault>
    </activation>
    <properties>
        <quarkus.container-image.build>true</quarkus.container-image.build>
        <skipTests>true</skipTests>
    </properties>
</profile>
```

This automatically:
- ✅ Enables container image building
- ✅ Skips tests for faster builds
- ✅ Applies to all modules

---

## 📊 View Your Images

After running, check your images:
```bash
podman images
```

You'll see:
```
REPOSITORY                                  TAG       IMAGE ID      SIZE
quarkus-microservices/inventory-service     latest    abc123...     ~200MB
quarkus-microservices/order-service         latest    xyz789...     ~210MB
```

---

## ⏱️ How Long Does It Take?

- **First build:** 3-5 minutes (downloads dependencies)
- **Subsequent builds:** 30-60 seconds (uses cache)

---

## 🎨 Copy-Paste Ready Commands

### Single Command (Recommended):
```bash
mvn -s ./.mvn/settings.xml clean install
```

### With Custom Properties:
```bash
mvn -s ./.mvn/settings.xml clean install -Dquarkus.container-image.tag=v1.0.0
```

### Build + View Images:
```bash
mvn -s ./.mvn/settings.xml clean install && podman images
```

### Build + Run Containers:
```bash
mvn -s ./.mvn/settings.xml clean install && podman run -d -p 8080:8080 quarkus-microservices/inventory-service:latest && podman run -d -p 8081:8081 quarkus-microservices/order-service:latest
```

---

## 🔧 Customizing Settings

Edit `.mvn/settings.xml` to customize:

### Enable/Disable Container Image Build:
```xml
<quarkus.container-image.build>true</quarkus.container-image.build>
```

### Run Tests:
```xml
<skipTests>false</skipTests>
```

### Change Image Tag:
```xml
<quarkus.container-image.tag>1.0.0</quarkus.container-image.tag>
```

### Add Maven Mirror:
```xml
<mirrors>
    <mirror>
        <id>central-mirror</id>
        <name>Maven Central Mirror</name>
        <url>https://repo.maven.apache.org/maven2</url>
        <mirrorOf>central</mirrorOf>
    </mirror>
</mirrors>
```

---

## 💡 Pro Tips

### Create a Shell Alias:
**PowerShell:**
```powershell
function qbuild { mvn -s .\.mvn\settings.xml clean install }
```

**Bash/Zsh:**
```bash
alias qbuild='mvn -s ./.mvn/settings.xml clean install'
```

Then just type: `qbuild`

### Different Build Profiles:
```bash
# Development build (with tests)
mvn -s ./.mvn/settings.xml clean install -P dev

# Production build (optimized)
mvn -s ./.mvn/settings.xml clean install -P prod
```

---

## 🎯 Summary

**Simplest command ever:**
```bash
mvn -s ./.mvn/settings.xml clean install
```

**Or just:**
```bash
.\build.bat
```

**That's it!** One command builds everything with all configurations from settings.xml! 🎉

