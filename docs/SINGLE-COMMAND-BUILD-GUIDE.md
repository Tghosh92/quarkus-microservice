# Single Command Build Guide

## 🚀 One Command Does Everything!

```bash
mvn -s ./.mvn/settings.xml clean install
```

This single command handles the complete build lifecycle for both microservices.

---

## 🎯 What This Command Does

When you run `mvn -s ./.mvn/settings.xml clean install`, Maven executes these phases in order:

### 1. **Clean Phase** (`clean`)
- Deletes `target/` directories
- Removes old compiled code
- Ensures fresh build

### 2. **Validate Phase**
- Validates project structure
- Checks pom.xml correctness

### 3. **Compile Phase** (part of `install`)
- Compiles all Java source files
- Creates `.class` files in `target/classes/`
- Compiles both inventory-service and order-service

### 4. **Test-Compile Phase**
- Compiles test source files
- Creates test `.class` files in `target/test-classes/`

### 5. **Test Phase** ⭐
- **Runs all 23 unit tests**
- Inventory Service: 12 tests
- Order Service: 11 tests
- Build fails if any test fails
- Generates test reports in `target/surefire-reports/`

### 6. **Package Phase**
- Creates JAR files
- Packages application with dependencies
- Creates `target/quarkus-app/quarkus-run.jar` for each service

### 7. **Container Image Build** 🐳
- Uses Quarkus JIB extension
- Creates container images:
  - `quarkus-microservices/inventory-service:latest`
  - `quarkus-microservices/order-service:latest`
- Images stored in local Podman/Docker registry

### 8. **Install Phase** (`install`)
- Installs artifacts to local Maven repository (~/.m2/repository)
- Makes artifacts available for other projects

---

## 📊 Complete Build Flow

```
mvn -s ./.mvn/settings.xml clean install
         ↓
    [1] Clean
         ↓
    [2] Compile main code (inventory + order services)
         ↓
    [3] Compile test code (both services)
         ↓
    [4] Run all tests (23 tests) ⭐
         ↓
    [5] Package as JAR files
         ↓
    [6] Build container images 🐳
         ↓
    [7] Install to local Maven repo
         ↓
    ✅ BUILD SUCCESS
```

---

## 🔧 What `-s ./.mvn/settings.xml` Does

The `-s` flag tells Maven to use custom settings from `.mvn/settings.xml`.

**Settings configured:**
```xml
<quarkus.container-image.build>true</quarkus.container-image.build>
<!-- Tests run by default -->
```

**Why use settings.xml?**
- ✅ Enables container image building automatically
- ✅ Applies to all modules (both services)
- ✅ Consistent configuration
- ✅ No need to type long Maven parameters

---

## ⚡ Command Variations

### 1. Full Build with Tests (Default) ⭐
```bash
mvn -s ./.mvn/settings.xml clean install
```
**Time:** ~2-3 minutes  
**Tests:** ✅ Run (23 tests)  
**Images:** ✅ Created  
**Use when:** Quality check before commit/deploy

### 2. Fast Build (Skip Tests)
```bash
mvn -s ./.mvn/settings.xml clean install -DskipTests
```
**Time:** ~1-2 minutes  
**Tests:** ❌ Skipped  
**Images:** ✅ Created  
**Use when:** Quick rebuild, testing manually

### 3. Build Without Images
```bash
mvn -s ./.mvn/settings.xml clean install -Dquarkus.container-image.build=false
```
**Time:** ~2-3 minutes  
**Tests:** ✅ Run  
**Images:** ❌ Not created  
**Use when:** Only need JAR files

### 4. Skip Tests AND Images
```bash
mvn -s ./.mvn/settings.xml clean package -DskipTests
```
**Time:** ~1 minute  
**Tests:** ❌ Skipped  
**Images:** ❌ Not created  
**Use when:** Fastest possible build

---

## 📈 Expected Output

### Successful Build:

```
[INFO] Scanning for projects...
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Build Order:
[INFO]
[INFO] inventory-service
[INFO] order-service
[INFO] ------------------------------------------------------------------------

[INFO] Building inventory-service 1.0.0-SNAPSHOT
[INFO] Compiling 3 source files to target/classes
[INFO] Compiling 1 test source file to target/test-classes

[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.example.inventory.InventoryResourceTest
[INFO] Tests run: 12, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] Results:
[INFO] Tests run: 12, Failures: 0, Errors: 0, Skipped: 0

[INFO] Building jar: target/inventory-service-1.0.0-SNAPSHOT.jar
[INFO] Created container image quarkus-microservices/inventory-service (sha256:abc123...)

[INFO] Building order-service 1.0.0-SNAPSHOT
[INFO] Compiling 5 source files to target/classes
[INFO] Compiling 1 test source file to target/test-classes

[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.example.order.OrderResourceTest
[INFO] Tests run: 11, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] Results:
[INFO] Tests run: 11, Failures: 0, Errors: 0, Skipped: 0

[INFO] Building jar: target/order-service-1.0.0-SNAPSHOT.jar
[INFO] Created container image quarkus-microservices/order-service (sha256:def456...)

[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] ------------------------------------------------------------------------
[INFO] inventory-service .................................. SUCCESS [45.2s]
[INFO] order-service ...................................... SUCCESS [42.8s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 1:28 min
[INFO] Finished at: 2026-01-28T12:30:45+05:30
[INFO] ------------------------------------------------------------------------
```

---

## 🎓 Understanding Maven Lifecycle

Maven executes phases in order. When you run `install`, it runs all previous phases:

| Phase | What Happens | Included in `install`? |
|-------|--------------|----------------------|
| clean | Delete target/ | Only if you add `clean` |
| validate | Check project | ✅ Yes |
| compile | Compile main code | ✅ Yes |
| test-compile | Compile tests | ✅ Yes |
| test | Run tests | ✅ Yes |
| package | Create JAR | ✅ Yes |
| verify | Verify JAR | ✅ Yes |
| install | Install to .m2 | ✅ Yes (target phase) |
| deploy | Deploy to remote | ❌ No (not run) |

---

## 🔍 Verifying the Build

After successful build:

### 1. Check JAR Files
```bash
ls inventory-service/target/quarkus-app/quarkus-run.jar
ls order-service/target/quarkus-app/quarkus-run.jar
```

### 2. Check Container Images
```bash
podman images | grep quarkus-microservices
# or
docker images | grep quarkus-microservices
```

Expected output:
```
quarkus-microservices/inventory-service  latest  abc123  2 minutes ago  437 MB
quarkus-microservices/order-service      latest  def456  1 minute ago   438 MB
```

### 3. Check Test Reports
```bash
ls inventory-service/target/surefire-reports/
ls order-service/target/surefire-reports/
```

### 4. Check Local Maven Repository
```bash
ls ~/.m2/repository/com/example/inventory-service/1.0.0-SNAPSHOT/
ls ~/.m2/repository/com/example/order-service/1.0.0-SNAPSHOT/
```

---

## 🐛 Troubleshooting

### Problem: Tests Fail
```
[ERROR] Tests run: 12, Failures: 1, Errors: 0, Skipped: 0
[INFO] BUILD FAILURE
```

**Solution:**
1. Check which test failed in the output
2. Fix the test or code
3. Run again, or skip tests temporarily:
   ```bash
   mvn -s ./.mvn/settings.xml clean install -DskipTests
   ```

### Problem: Out of Memory
```
[ERROR] Java heap space
```

**Solution:**
```bash
export MAVEN_OPTS="-Xmx2g"
mvn -s ./.mvn/settings.xml clean install
```

### Problem: Port Already in Use (During Tests)
```
[ERROR] Port 8081 already in use
```

**Solution:**
Stop running services before building:
```bash
# Stop services
podman stop inventory-service order-service
# Then build
mvn -s ./.mvn/settings.xml clean install
```

### Problem: Container Image Build Fails
```
[ERROR] Failed to build container image
```

**Solution:**
1. Check if Podman/Docker is running
2. Or skip image building:
   ```bash
   mvn -s ./.mvn/settings.xml clean install -Dquarkus.container-image.build=false
   ```

---

## 💡 Pro Tips

### 1. Parallel Builds (Faster!)
```bash
mvn -s ./.mvn/settings.xml clean install -T 2
# -T 2 uses 2 threads
```

### 2. Offline Mode (No Internet)
```bash
mvn -s ./.mvn/settings.xml clean install -o
# -o works offline (uses cached dependencies)
```

### 3. Verbose Output (Debugging)
```bash
mvn -s ./.mvn/settings.xml clean install -X
# -X shows debug information
```

### 4. Update Dependencies
```bash
mvn -s ./.mvn/settings.xml clean install -U
# -U forces update of dependencies
```

### 5. Only Build Specific Service
```bash
cd inventory-service
mvn clean install
# Builds only inventory-service
```

---

## 🎯 CI/CD Integration

### GitHub Actions
```yaml
name: Build and Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          
      - name: Build with Maven
        run: mvn -s ./.mvn/settings.xml clean install
```

### GitLab CI
```yaml
build:
  image: maven:3.8-openjdk-17
  script:
    - mvn -s ./.mvn/settings.xml clean install
  artifacts:
    paths:
      - "*/target/*.jar"
```

### Jenkins
```groovy
stage('Build') {
    steps {
        sh 'mvn -s ./.mvn/settings.xml clean install'
    }
}
```

---

## 📊 Comparison with Other Commands

| Command | Time | Tests | Images | Use Case |
|---------|------|-------|--------|----------|
| `mvn clean install` | 2-3 min | ✅ Run | ✅ Build | **Full quality check** ⭐ |
| `mvn clean install -DskipTests` | 1-2 min | ❌ Skip | ✅ Build | Fast rebuild |
| `mvn clean package` | 2-3 min | ✅ Run | ✅ Build | Package only |
| `mvn test` | 30 sec | ✅ Run | ❌ No | Test only |
| `mvn quarkus:dev` | Instant | ⚡ Live | ❌ No | Development |

---

## ✅ Summary

**The Single Command:**
```bash
mvn -s ./.mvn/settings.xml clean install
```

**What it does:**
1. ✅ Cleans previous builds
2. ✅ Compiles main code (both services)
3. ✅ Compiles test code (both services)
4. ✅ Runs all 23 unit tests
5. ✅ Packages applications as JAR files
6. ✅ Builds container images
7. ✅ Installs to local Maven repository

**When to use:**
- ✅ Before committing code
- ✅ Before deploying
- ✅ In CI/CD pipelines
- ✅ Quality check with tests

**Alternatives:**
- Fast build: Add `-DskipTests`
- Skip images: Add `-Dquarkus.container-image.build=false`
- Parallel: Add `-T 2`

**Result:**
- ✅ 2 JAR files ready to run
- ✅ 2 container images ready to deploy
- ✅ All tests passed
- ✅ Code quality verified

**This is your go-to command for production-ready builds! 🚀**

