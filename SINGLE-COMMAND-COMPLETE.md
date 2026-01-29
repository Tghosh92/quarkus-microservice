# ✅ Single Command Build - Complete!

## 🎯 Your Single Command

```bash
mvn -s ./.mvn/settings.xml clean install
```

**This ONE command does EVERYTHING:**
- ✅ Compiles main code (both services)
- ✅ Compiles test code (both services)
- ✅ Runs all 23 unit tests
- ✅ Packages as JAR files
- ✅ Builds container images
- ✅ Installs to local Maven repository

---

## 🚀 Quick Reference

### Full Build with Tests (Recommended)
```bash
mvn -s ./.mvn/settings.xml clean install
```
**Time:** ~2-3 minutes  
**Tests:** ✅ All 23 tests run  
**Images:** ✅ Created  

### Fast Build (Skip Tests)
```bash
mvn -s ./.mvn/settings.xml clean install -DskipTests
```
**Time:** ~1-2 minutes  
**Tests:** ❌ Skipped  
**Images:** ✅ Created  

---

## 📋 What Changed

### 1. ✅ settings.xml Updated
**Before:**
```xml
<skipTests>true</skipTests>  <!-- Tests were skipped -->
```

**After:**
```xml
<!-- Tests run by default. To skip: add -DskipTests to command -->
```

### 2. ✅ README.md Updated
- Removed confusing BUILD.bat references
- Clear explanation of single command
- Shows what the command does

### 3. ✅ Documentation Added
- `docs/SINGLE-COMMAND-BUILD-GUIDE.md` - Complete guide

---

## 🎓 Understanding the Command

```bash
mvn -s ./.mvn/settings.xml clean install
│   │                      │     │
│   │                      │     └─ Install to local repo
│   │                      └─ Clean previous builds
│   └─ Use custom settings.xml
└─ Maven command
```

**What settings.xml provides:**
- Container image building enabled
- Multi-module reactor build
- Consistent configuration

---

## 📊 Build Phases Executed

```
clean
  ↓
validate
  ↓
compile (main code)
  ↓
test-compile (test code)
  ↓
test (run 23 tests) ⭐
  ↓
package (create JARs)
  ↓
verify
  ↓
install (to ~/.m2/repository)
  ↓
+ Container images built 🐳
```

---

## ✅ Verification

### After successful build, verify:

**1. JAR files created:**
```bash
ls inventory-service/target/quarkus-app/quarkus-run.jar
ls order-service/target/quarkus-app/quarkus-run.jar
```

**2. Container images created:**
```bash
podman images | grep quarkus-microservices
```

Expected:
```
quarkus-microservices/inventory-service  latest  ...  437 MB
quarkus-microservices/order-service      latest  ...  438 MB
```

**3. Tests passed:**
```
Tests run: 23, Failures: 0, Errors: 0, Skipped: 0
BUILD SUCCESS
```

---

## 🎯 Common Use Cases

### 1. Before Committing Code
```bash
mvn -s ./.mvn/settings.xml clean install
# Ensures all tests pass
```

### 2. Quick Rebuild
```bash
mvn -s ./.mvn/settings.xml clean install -DskipTests
# Faster, skip tests
```

### 3. CI/CD Pipeline
```yaml
script:
  - mvn -s ./.mvn/settings.xml clean install
```

### 4. Only Test (No Build)
```bash
mvn test
# Just runs tests
```

### 5. Development Mode
```bash
cd inventory-service
mvn quarkus:dev
# Live reload, continuous testing
```

---

## 💡 Pro Tips

**Parallel Build (Faster):**
```bash
mvn -s ./.mvn/settings.xml clean install -T 2
```

**Offline Mode:**
```bash
mvn -s ./.mvn/settings.xml clean install -o
```

**Update Dependencies:**
```bash
mvn -s ./.mvn/settings.xml clean install -U
```

**Verbose Output:**
```bash
mvn -s ./.mvn/settings.xml clean install -X
```

---

## 📚 Documentation

**Complete Guide:**
- `docs/SINGLE-COMMAND-BUILD-GUIDE.md` - Detailed explanation

**Also See:**
- `docs/UNIT-TESTING-GUIDE.md` - Testing documentation
- `docs/TARGET-FOLDER-EXPLAINED.md` - Understanding build output
- `README.md` - Project overview

---

## 🎉 Summary

**You now have ONE simple command for everything:**

```bash
mvn -s ./.mvn/settings.xml clean install
```

**What it provides:**
- ✅ Complete build automation
- ✅ Quality assurance (tests)
- ✅ Production-ready artifacts
- ✅ Container images
- ✅ Single source of truth

**No more confusion about BUILD.bat or other scripts!**

**This is THE command for production builds! 🚀**

