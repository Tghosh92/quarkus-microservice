# 🔍 Command Comparison: `quarkus:dev` vs `clean install`

## Two Completely Different Commands for Different Purposes!

---

## 📊 Quick Comparison Table

| Aspect | `mvn quarkus:dev` | `mvn clean install` |
|--------|-------------------|---------------------|
| **Purpose** | Development mode | Production build |
| **Speed** | ⚡ Instant startup | 🕐 2-3 minutes |
| **Hot Reload** | ✅ Yes - Auto reload | ❌ No - Must rebuild |
| **Tests** | ⚡ Continuous | ✅ Run once |
| **Container Images** | ❌ Not created | ✅ Created |
| **JAR Files** | ❌ Not created | ✅ Created |
| **Use Case** | Active development | Production deployment |
| **Keeps Running** | ✅ Yes (until Ctrl+C) | ❌ No (exits after build) |
| **Code Changes** | ✅ Auto-detected | ❌ Must rebuild |
| **Dev UI** | ✅ Available | ❌ Not available |

---

## 🎯 Command 1: `mvn quarkus:dev` - Development Mode

### What It Does:
```bash
cd inventory-service
mvn quarkus:dev
```

**This is for ACTIVE DEVELOPMENT:**
- ✅ Starts application in development mode
- ✅ Runs on http://localhost:8080 (live server)
- ✅ **Hot reload** - automatically recompiles on code changes
- ✅ **Continuous testing** - tests re-run on changes
- ✅ Dev UI available at http://localhost:8080/q/dev
- ✅ Fast startup (seconds, not minutes)
- ✅ Debug mode enabled
- ⚠️ Only runs ONE service at a time
- ⚠️ NO container images created
- ⚠️ NO JAR files created

### Output:
```
__  ____  __  _____   ___  __ ____  ______ 
 --/ __ \/ / / / _  / _ \/ //_/ / / / __/ 
 -/ /_/ / /_/ / __ / , _/ ,< / /_/ /\ \   
--\___\_\____/_/ _/_/_/_/_\____/___/   
2026-01-28 12:00:00,000 INFO  [io.quarkus] Listening on: http://localhost:8080

Tests paused
Press [r] to resume testing, [o] Toggle test output, [h] for more options>
```

**The application KEEPS RUNNING - you can:**
- Make code changes → Auto-reload ✨
- Press 'r' → Run tests
- Press 'h' → See help options
- Access http://localhost:8080/inventory
- Access http://localhost:8080/q/dev (Dev UI)
- Press Ctrl+C to stop

### When to Use:
- ✅ Writing new code
- ✅ Debugging issues
- ✅ Testing locally
- ✅ Quick feedback loop
- ✅ Learning and experimenting

### Workflow Example:
```bash
# Start dev mode
cd inventory-service
mvn quarkus:dev

# Edit code in your IDE
# Save file → Auto-reloads! ✨

# Press 'r' to run tests
# Tests run instantly

# Access API: http://localhost:8080/inventory
# Changes reflected immediately

# Press Ctrl+C when done
```

---

## 🎯 Command 2: `mvn clean install` - Production Build

### What It Does:
```bash
mvn -s ./.mvn/settings.xml clean install
```

**This is for PRODUCTION BUILD:**
- ✅ Compiles ALL code (both services)
- ✅ Compiles ALL tests
- ✅ Runs ALL tests (23 tests)
- ✅ Creates JAR files (deployable artifacts)
- ✅ Creates container images (Docker/Podman)
- ✅ Installs to Maven repository
- ✅ Validates everything works
- ⚠️ Takes 2-3 minutes
- ⚠️ NOT for active development
- ⚠️ No hot reload
- ⚠️ Exits after completion

### Output:
```
[INFO] Scanning for projects...
[INFO] Building inventory-service 1.0.0-SNAPSHOT
[INFO] Compiling 3 source files
[INFO] 
[INFO] Running tests...
[INFO] Tests run: 12, Failures: 0, Errors: 0
[INFO] 
[INFO] Building JAR: target/inventory-service-1.0.0-SNAPSHOT.jar
[INFO] Creating container image...
[INFO] 
[INFO] Building order-service 1.0.0-SNAPSHOT
[INFO] Tests run: 11, Failures: 0, Errors: 0
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 2:15 min
```

**The command EXITS after completion - you get:**
- ✅ JAR files in `target/quarkus-app/quarkus-run.jar`
- ✅ Container images: `quarkus-microservices/inventory-service:latest`
- ✅ Test reports
- ✅ Confidence that everything works

### When to Use:
- ✅ Before committing code
- ✅ Before deploying to production
- ✅ CI/CD pipelines
- ✅ Creating deployable artifacts
- ✅ Quality assurance checks
- ✅ Final verification

### Workflow Example:
```bash
# Make your changes in IDE
# Save files

# Build everything
mvn -s ./.mvn/settings.xml clean install

# Wait 2-3 minutes...
# BUILD SUCCESS!

# Now you have:
# - JAR files ready to deploy
# - Container images ready to run
# - All tests passed
```

---

## 🎓 Detailed Comparison

### Speed

**`quarkus:dev`:**
```
Startup: 2-5 seconds ⚡
Reload: < 1 second ⚡⚡⚡
```

**`clean install`:**
```
Full build: 2-3 minutes 🕐
```

---

### Hot Reload

**`quarkus:dev`:** ✨
```java
// Edit ProductResource.java
public class ProductResource {
    @GET
    public List<Product> getAll() {
        return products; // Change this
    }
}
// Save → AUTOMATICALLY RELOADED!
// No restart needed!
```

**`clean install`:** ❌
```bash
# Edit code
# Must run build again:
mvn -s ./.mvn/settings.xml clean install
# Wait 2-3 minutes
```

---

### Testing

**`quarkus:dev`:** Continuous Testing
```
Tests paused
Press [r] to resume testing

# Press 'r'
[INFO] Running tests...
[INFO] Tests run: 12, Failures: 0

# Edit test or code
# Tests auto-run! ⚡
```

**`clean install`:** One-Time Testing
```
[INFO] Running com.example.inventory.InventoryResourceTest
[INFO] Tests run: 12, Failures: 0, Errors: 0
# Tests run once, then done
```

---

### Output Artifacts

**`quarkus:dev`:**
```
✅ Running application (port 8080)
✅ Dev UI (http://localhost:8080/q/dev)
❌ No JAR files
❌ No container images
❌ No deployable artifacts
```

**`clean install`:**
```
✅ JAR files (target/quarkus-app/quarkus-run.jar)
✅ Container images (quarkus-microservices/*)
✅ Test reports (target/surefire-reports/)
✅ Deployable artifacts
❌ Not running (exits after build)
```

---

### Multiple Services

**`quarkus:dev`:**
```bash
# Terminal 1:
cd inventory-service
mvn quarkus:dev
# Runs on port 8080

# Terminal 2:
cd order-service
mvn quarkus:dev
# Runs on port 8081

# Need TWO terminals for TWO services
```

**`clean install`:**
```bash
# One command builds BOTH services:
mvn -s ./.mvn/settings.xml clean install
# Builds inventory-service AND order-service
```

---

### Dev UI

**`quarkus:dev`:** ✅ Available
```
Access: http://localhost:8080/q/dev

Features:
- Configuration editor
- Continuous testing UI
- Extensions management
- Dev services
- Metrics
- Health checks
```

**`clean install`:** ❌ Not Available
```
No dev UI - this is a build command, not a runtime
```

---

## 🎯 Use Case Scenarios

### Scenario 1: Writing New Code
```bash
# ✅ USE: quarkus:dev
cd inventory-service
mvn quarkus:dev

# Write code
# Save → Auto-reload
# Test instantly
# Fast feedback loop
```

### Scenario 2: Debugging an Issue
```bash
# ✅ USE: quarkus:dev
cd inventory-service
mvn quarkus:dev

# Set breakpoints in IDE
# Make requests
# Debug in real-time
```

### Scenario 3: Before Git Commit
```bash
# ✅ USE: clean install
mvn -s ./.mvn/settings.xml clean install

# Runs all tests
# Ensures nothing broken
# Quality check before commit
```

### Scenario 4: Deploying to Production
```bash
# ✅ USE: clean install
mvn -s ./.mvn/settings.xml clean install

# Creates container images
# Ready to deploy
# Production-ready artifacts
```

### Scenario 5: CI/CD Pipeline
```bash
# ✅ USE: clean install
mvn -s ./.mvn/settings.xml clean install

# Automated build
# All tests must pass
# Creates deployable artifacts
```

---

## 💡 Think of It This Way

### `quarkus:dev` = Your Development Workshop 🛠️
```
Like working in a workshop with:
- Tools readily available
- Instant feedback
- Easy to experiment
- Quick iterations
- Learning mode
```

**Analogy:**
- Live cooking show (make changes, see results immediately)
- Artist's studio (sketch, erase, sketch again)
- Test kitchen (try recipes, adjust on the fly)

### `clean install` = Production Factory 🏭
```
Like a manufacturing plant:
- Quality control (tests)
- Final assembly (packaging)
- Shipping preparation (container images)
- Certification (all checks pass)
- Production ready
```

**Analogy:**
- Publishing a book (final editing, printing, distribution)
- Building a car (assembly line, quality checks, ready to sell)
- Baking a wedding cake (final product, ready to deliver)

---

## 🔄 Typical Development Workflow

### Day-to-Day Development:
```bash
# Morning: Start dev mode
cd inventory-service
mvn quarkus:dev

# Work all day:
# - Write code
# - Save → Auto-reload
# - Test → Press 'r'
# - Debug
# - Iterate quickly

# Evening: Before going home
Ctrl+C  # Stop dev mode

# Before commit:
mvn -s ./.mvn/settings.xml clean install
# Final quality check

# If tests pass:
git commit -m "Feature complete"
```

---

## ⚠️ Common Mistakes

### Mistake 1: Using `clean install` for Development
```bash
❌ SLOW WORKFLOW:
# Edit code
mvn -s ./.mvn/settings.xml clean install  # Wait 2-3 minutes
# Test
# Edit code again
mvn -s ./.mvn/settings.xml clean install  # Wait 2-3 minutes again
# Repeat... 😫

✅ FAST WORKFLOW:
mvn quarkus:dev  # Start once
# Edit → Save → Auto-reload (instant!) ⚡
# Edit → Save → Auto-reload (instant!) ⚡
# Repeat endlessly! 😊
```

### Mistake 2: Using `quarkus:dev` for Production
```bash
❌ WRONG:
mvn quarkus:dev
# Copy running process to production
# NO! This is dev mode, not production-ready

✅ CORRECT:
mvn -s ./.mvn/settings.xml clean install
# Creates production-ready artifacts
# Deploy JAR or container image
```

---

## 📋 Quick Decision Guide

**Ask yourself:**

### Am I actively writing/debugging code?
- **YES** → `mvn quarkus:dev`
- **NO** → See next question

### Do I need deployable artifacts?
- **YES** → `mvn clean install`
- **NO** → `mvn quarkus:dev`

### Do I want hot reload and fast feedback?
- **YES** → `mvn quarkus:dev`
- **NO** → `mvn clean install`

### Is this for CI/CD or production?
- **YES** → `mvn clean install`
- **NO** → `mvn quarkus:dev`

### Do I need to build both services?
- **YES** → `mvn clean install`
- **NO (one service)** → `mvn quarkus:dev`

---

## 🎯 Summary

### `mvn quarkus:dev`
**Purpose:** Active development  
**Speed:** ⚡ Instant  
**Hot Reload:** ✅ Yes  
**Output:** Running application  
**Use When:** Writing code, debugging  
**Best For:** Development, learning  

### `mvn -s ./.mvn/settings.xml clean install`
**Purpose:** Production build  
**Speed:** 🕐 2-3 minutes  
**Hot Reload:** ❌ No  
**Output:** JAR files, container images  
**Use When:** Before deploy, CI/CD  
**Best For:** Production, quality checks  

---

## 🚀 Pro Tips

### For Development:
```bash
# Use quarkus:dev with continuous testing
cd inventory-service
mvn quarkus:dev

# In the console:
# Press 'r' to run tests
# Press 'w' to toggle continuous testing
# Press 'h' for help
```

### For Production:
```bash
# Full quality build before deploy
mvn -s ./.mvn/settings.xml clean install

# Then deploy:
podman run -d quarkus-microservices/inventory-service:latest
```

### For Both Services in Dev:
```bash
# Terminal 1:
cd inventory-service && mvn quarkus:dev

# Terminal 2:
cd order-service && mvn quarkus:dev -Dquarkus.http.port=8081
```

---

## ✅ Bottom Line

**Two different tools for two different jobs:**

🛠️ **Development:** `mvn quarkus:dev`  
- Fast, hot reload, continuous testing
- Your daily driver for coding

🏭 **Production:** `mvn clean install`  
- Complete build, all tests, deployable artifacts
- Your quality gate before deploy

**Use the right tool for the job! 🎯**

