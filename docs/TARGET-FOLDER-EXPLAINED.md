# Understanding the `target` Folder

## 📂 What is the `target` Folder?

The **`target`** folder is Maven's **build output directory**. It's created automatically when you run Maven build commands like `mvn clean package` or when you use `BUILD.bat`.

**Location:**
```
inventory-service/target/
order-service/target/
```

---

## 🎯 Purpose

The `target` folder contains:
1. **Compiled classes** (`.class` files from your `.java` files)
2. **Packaged JAR files** (your application ready to run)
3. **Build metadata** (Maven artifacts, dependency info)
4. **Container image information** (if building container images)
5. **Test results** (if running tests)

---

## 📁 Structure of `target` Folder

After running `BUILD.bat`, you'll see:

```
target/
├── classes/                              ← Compiled .class files
│   ├── application.properties
│   └── com/
│       └── example/
│           └── inventory/
│               ├── InventoryResource.class
│               ├── Product.class
│               └── InventoryService.class
│
├── generated-sources/                    ← Auto-generated code
│   └── annotations/
│
├── maven-archiver/                       ← Maven packaging info
│   └── pom.properties
│
├── maven-status/                         ← Build status
│   └── maven-compiler-plugin/
│       └── compile/
│           └── default-compile/
│
├── quarkus-app/                          ← Quarkus runtime artifacts ⭐
│   ├── app/
│   │   └── inventory-service-1.0.0-SNAPSHOT.jar
│   ├── lib/                              ← Dependencies
│   │   ├── boot/                         ← Bootstrap JARs
│   │   └── main/                         ← Application JARs
│   ├── quarkus/
│   │   ├── generated-bytecode.jar
│   │   ├── quarkus-application.dat
│   │   └── transformed-bytecode.jar
│   ├── quarkus-app-dependencies.txt
│   └── quarkus-run.jar                   ← Main executable JAR ⭐
│
├── inventory-service-1.0.0-SNAPSHOT.jar  ← Packaged application
├── jib-image.digest                      ← Container image digest
├── jib-image.id                          ← Container image ID
└── quarkus-artifact.properties           ← Quarkus build properties
```

---

## 🔑 Key Files Explained

### 1. `quarkus-app/quarkus-run.jar` ⭐ MOST IMPORTANT

**What it is:**
- The main executable JAR file
- This is what runs when you start the service

**How it's used:**
```bash
java -jar target/quarkus-app/quarkus-run.jar
```

**Used by:**
- `START.bat` script
- All start/run scripts in `scripts/` folder

**Dependencies:**
- Requires the entire `quarkus-app/` folder structure
- Cannot be moved alone - needs `lib/`, `app/`, `quarkus/` folders

---

### 2. `classes/` Folder

**What it is:**
- Your compiled Java code (`.class` files)
- Copied resources (like `application.properties`)

**Example:**
```
classes/
├── application.properties
└── com/example/inventory/
    ├── InventoryResource.class      ← Compiled from InventoryResource.java
    ├── Product.class                ← Compiled from Product.java
    └── InventoryService.class       ← Compiled from InventoryService.java
```

**Purpose:**
- Intermediate build artifacts
- Used to create the final JAR files

---

### 3. `inventory-service-1.0.0-SNAPSHOT.jar`

**What it is:**
- Packaged application JAR
- Contains compiled classes and resources

**Difference from quarkus-run.jar:**
- This is the application JAR
- `quarkus-run.jar` is the runner that loads this JAR

---

### 4. `jib-image.id` and `jib-image.digest`

**What they are:**
- Created when building container images
- Contain Docker/Podman image identifiers

**Related to:**
- `quarkus-container-image-jib` dependency in `pom.xml`
- Container image building process

**Example content:**
```
jib-image.id: sha256:abc123def456...
jib-image.digest: sha256:xyz789abc123...
```

---

### 5. `quarkus-app/lib/` Folder

**What it is:**
- All dependency JAR files
- Libraries your application needs to run

**Structure:**
```
lib/
├── boot/                    ← Bootstrap dependencies
│   ├── quarkus-core-3.6.4.jar
│   └── ...
└── main/                    ← Application dependencies
    ├── jackson-core-2.15.3.jar
    ├── resteasy-reactive-3.6.4.jar
    └── ... (100+ JAR files)
```

**Why it's important:**
- Your application loads these at runtime
- Without `lib/`, the application won't start

---

## 🔄 When is `target` Created/Updated?

### Created When:
```bash
# First build:
BUILD.bat
# OR
mvn clean package
```

### Updated When:
```bash
# Every build:
BUILD.bat
# OR
mvn package
```

### Deleted When:
```bash
# Clean build (deletes target/ first):
mvn clean
# OR
mvn clean package  (in BUILD.bat)
```

---

## ⚠️ Important Notes

### Should You Commit `target/` to Git?

**NO! ❌ Never commit the `target/` folder to Git**

**Why:**
- It's generated code (not source code)
- It's large (100+ MB with dependencies)
- It's specific to your machine
- It can be regenerated anytime with `BUILD.bat`

**Your `.gitignore` should include:**
```
target/
*.class
*.jar
```

---

### Can You Delete `target/`?

**YES! ✅ It's safe to delete**

**Why:**
- It's regenerated on every build
- Maven creates it automatically
- No source code is stored here

**To regenerate:**
```bash
BUILD.bat
```

---

### Should You Backup `target/`?

**NO - Not necessary**

**Why:**
- It can be rebuilt from source code
- Backup your source code instead
- `target/` is temporary/transient

**What to backup:**
```
src/              ✅ YES - Source code
pom.xml           ✅ YES - Build configuration
target/           ❌ NO  - Generated artifacts
```

---

## 🔧 Related to pom.xml

Your `pom.xml` controls what goes into `target/`:

### Dependencies → `target/quarkus-app/lib/`

```xml
<dependencies>
    <dependency>
        <groupId>io.quarkus</groupId>
        <artifactId>quarkus-resteasy-reactive-jackson</artifactId>
    </dependency>
    <!-- More dependencies... -->
</dependencies>
```

**Result:** JAR files downloaded to `target/quarkus-app/lib/`

---

### Build Configuration → `target/` Structure

```xml
<build>
    <plugins>
        <plugin>
            <groupId>io.quarkus.platform</groupId>
            <artifactId>quarkus-maven-plugin</artifactId>
            <!-- Creates quarkus-app/ structure -->
        </plugin>
    </plugins>
</build>
```

**Result:** Creates `target/quarkus-app/` with Quarkus runtime

---

### Container Image Plugin → `jib-image.*` Files

```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-container-image-jib</artifactId>
</dependency>
```

**Result:** Creates `jib-image.id` and `jib-image.digest` files

---

## 📊 Typical Size

**After building both services:**
```
inventory-service/target/  ~150 MB
order-service/target/      ~150 MB
Total:                     ~300 MB
```

**Why so large?**
- Dependencies (100+ JAR files)
- Quarkus runtime
- Application code
- Build metadata

---

## 🚀 How Scripts Use `target/`

### BUILD.bat
```bash
# Creates/updates target/:
cd inventory-service
mvn clean package         # Deletes & recreates target/
cd ../order-service
mvn clean package         # Deletes & recreates target/
```

### START.bat
```bash
# Uses target/:
java -jar inventory-service/target/quarkus-app/quarkus-run.jar
java -jar order-service/target/quarkus-app/quarkus-run.jar
```

### STOP.bat
```bash
# Doesn't touch target/
# Only stops running processes
```

---

## 🔍 Inspecting `target/` Contents

### List Main Files:
```bash
# Windows:
dir inventory-service\target

# PowerShell:
Get-ChildItem inventory-service\target
```

### Check JAR File Size:
```bash
# PowerShell:
(Get-Item "inventory-service\target\quarkus-app\quarkus-run.jar").Length / 1MB
# Shows size in MB
```

### View Dependencies:
```bash
# List all dependency JARs:
dir inventory-service\target\quarkus-app\lib\main
```

---

## 🛠️ Troubleshooting

### Problem: "JAR not found" Error

**Cause:** `target/` doesn't exist or is incomplete

**Solution:**
```bash
BUILD.bat
```

---

### Problem: Old Code Running

**Cause:** `target/` contains old compiled code

**Solution:**
```bash
# Clean build:
cd inventory-service
mvn clean package
```

Or use `BUILD.bat` which does `mvn clean package` automatically.

---

### Problem: `target/` is Huge

**Cause:** Normal - includes all dependencies

**Solution:**
- This is expected (150+ MB per service)
- Safe to delete anytime
- Rebuild with `BUILD.bat`

---

### Problem: Build Fails

**Check:**
```bash
# Check if target/ can be written to:
# Delete manually and rebuild:
rmdir /s inventory-service\target
BUILD.bat
```

---

## 📚 Summary

| Aspect | Details |
|--------|---------|
| **Purpose** | Maven build output directory |
| **Contains** | Compiled code, JARs, dependencies, build artifacts |
| **Created by** | `mvn package` or `BUILD.bat` |
| **Size** | ~150 MB per service |
| **Commit to Git?** | ❌ NO - Add to `.gitignore` |
| **Safe to delete?** | ✅ YES - Regenerate with `BUILD.bat` |
| **Important file** | `target/quarkus-app/quarkus-run.jar` |
| **Used by** | START.bat, run scripts |

---

## 🎓 Key Takeaways

1. **`target/` is temporary** - It's generated, not source code
2. **Don't commit it** - Add to `.gitignore`
3. **Safe to delete** - Just run `BUILD.bat` to recreate
4. **quarkus-run.jar is key** - This is what runs your application
5. **lib/ folder matters** - Contains all dependencies
6. **Maven controls it** - Structure defined by `pom.xml`

---

## 🔗 Related Files

- **`pom.xml`** - Defines what goes into `target/`
- **`BUILD.bat`** - Creates/updates `target/`
- **`START.bat`** - Uses `target/quarkus-app/quarkus-run.jar`
- **`.gitignore`** - Should exclude `target/`

---

**In short:** The `target/` folder is Maven's build output. It's automatically created when you build, contains your runnable application, and should never be committed to Git. Just run `BUILD.bat` anytime to recreate it! 🚀

