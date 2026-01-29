# Scripts Folder - Detailed Documentation

This folder contains all build, start, stop, and utility scripts for the microservices project.

---

## 🎯 Quick Reference

**For Regular Use - Use Launchers in Project Root:**
- `BUILD.bat` → Builds services
- `START.bat` → Starts services
- `STOP.bat` → Stops services

**For Advanced Users - Run Scripts Directly:**
- See detailed documentation below for each script

---

## 📦 Build Scripts

### `build-with-maven.bat` ⭐ MAIN BUILD SCRIPT

**What it does:**
- Cleans previous builds
- Compiles both inventory-service and order-service
- Packages them as JAR files
- Creates Podman/Docker container images
- Displays built images at the end

**Why use it:**
- Single command to build everything
- Creates both JAR files and container images
- Most reliable build method

**When to use:**
- First time setup
- After modifying source code
- Before deploying services
- When JAR files are missing or corrupted

**How to use:**
```bat
# From project root (RECOMMENDED):
BUILD.bat

# Or directly from scripts folder:
cd scripts
build-with-maven.bat
```

**Expected Output:**
```
[INFO] BUILD SUCCESS
[INFO] Created container image quarkus-microservices/inventory-service
[INFO] Created container image quarkus-microservices/order-service
BUILD COMPLETE!
```

**Dependencies:**
- Maven must be installed
- Java 17+ must be installed
- Internet connection (first build to download dependencies)

---

### `build.bat`

**What it does:**
- Alternative build script
- Builds services without creating container images
- Faster than build-with-maven.bat

**Why use it:**
- When you only need JAR files (not container images)
- Faster build times
- Testing code changes quickly

**When to use:**
- During active development
- When you run services with Java directly (not containers)
- Quick code testing

**How to use:**
```bat
cd scripts
build.bat
```

**Difference from build-with-maven.bat:**
- ✅ Faster (no container image creation)
- ❌ Doesn't create Podman/Docker images
- ✅ Good for development

---

### `build-podman-images.ps1`

**What it does:**
- PowerShell script to build Podman container images
- Assumes JAR files already exist
- Only builds container images (doesn't compile code)

**Why use it:**
- When JAR files exist but container images are missing
- To rebuild images after configuration changes
- PowerShell-specific workflows

**When to use:**
- After running build.bat
- When you need to rebuild only images
- In PowerShell automation scripts

**How to use:**
```powershell
cd scripts
.\build-podman-images.ps1
```

**Prerequisites:**
- JAR files must exist in target/ folders
- Podman must be installed and running

---

## 🚀 Start/Run Scripts

### `START-SERVICES.bat` ⭐ MAIN START SCRIPT

**What it does:**
- Kills any existing processes on ports 8080 and 8081
- Checks if JAR files exist
- Starts Inventory Service on port 8080 in a new CMD window
- Waits 20 seconds for it to initialize
- Starts Order Service on port 8081 in a new CMD window
- Verifies both services are listening on their ports
- Displays status and URLs

**Why use it:**
- Most reliable way to start services
- Shows service logs in separate windows
- Easy to troubleshoot (you can see errors)
- Verifies services are running

**When to use:**
- Every time you want to start your microservices
- After building with BUILD.bat
- For development and testing

**How to use:**
```bat
# From project root (RECOMMENDED):
START.bat

# Or directly from scripts folder:
cd scripts
START-SERVICES.bat
```

**What you'll see:**
- Two CMD windows open:
  - `INVENTORY-SERVICE-8080`
  - `ORDER-SERVICE-8081`
- Both will show Quarkus startup logs
- Final message: "Listening on: http://0.0.0.0:8080"

**Troubleshooting:**
- If "Port already in use" → Run STOP.bat first
- If "JAR not found" → Run BUILD.bat first
- Check service windows for error messages

---

### `start-services-reliable.bat`

**What it does:**
- Alternative startup script with more error handling
- Similar to START-SERVICES.bat but with additional checks
- Better error messages

**Why use it:**
- When START-SERVICES.bat fails
- More verbose error reporting
- Better for debugging startup issues

**When to use:**
- When services fail to start with main script
- Troubleshooting startup problems
- Need detailed error messages

**How to use:**
```bat
cd scripts
start-services-reliable.bat
```

---

### `start-containers.bat`

**What it does:**
- Starts services as Podman/Docker containers (not direct Java)
- Creates microservices-network
- Runs inventory-service container on port 8080
- Runs order-service container on port 8081
- Sets up inter-service communication

**Why use it:**
- Production-like environment
- Container isolation
- Easier scaling and deployment
- Network isolation between services

**When to use:**
- Testing containerized deployment
- Before pushing to production
- When you need container features (networking, isolation)

**How to use:**
```bat
cd scripts
start-containers.bat
```

**Prerequisites:**
- Container images must be built (run BUILD.bat first)
- Podman or Docker must be running

---

### `run-services.bat`

**What it does:**
- Runs services in Podman/Docker containers
- Checks for Podman or Docker installation
- Creates network and starts containers
- Waits for services to initialize

**Why use it:**
- Container-based execution
- Alternative to start-containers.bat
- Automatic container runtime detection

**When to use:**
- Testing with containers
- You have either Podman or Docker installed
- Container-based development

**How to use:**
```bat
cd scripts
run-services.bat
```

---

### `run-services-java.bat`

**What it does:**
- Runs services directly with Java (no containers)
- Starts JAR files in separate CMD windows
- Simpler than container-based approaches

**Why use it:**
- Don't have/want to use containers
- Faster startup times
- Direct Java execution
- Easier debugging

**When to use:**
- Development and testing
- When containers aren't needed
- Quick service testing
- Debugging Java applications

**How to use:**
```bat
cd scripts
run-services-java.bat
```

**Difference from START-SERVICES.bat:**
- Similar functionality
- Less error checking
- Simpler implementation

---

### `run-podman-services.ps1`

**What it does:**
- PowerShell script to run services in Podman containers
- Creates network, starts containers
- Sets up environment variables
- Displays container status

**Why use it:**
- PowerShell-based workflow
- Podman-specific features
- Scripting and automation

**When to use:**
- PowerShell environment
- Automated deployment scripts
- CI/CD pipelines

**How to use:**
```powershell
cd scripts
.\run-podman-services.ps1
```

---

### `start-services.bat`

**What it does:**
- Alternative startup script (older version)
- Basic service startup functionality

**Why use it:**
- Backup if other start scripts fail
- Legacy support

**When to use:**
- When other start scripts don't work
- As fallback option

**How to use:**
```bat
cd scripts
start-services.bat
```

**Note:** Prefer using START-SERVICES.bat (via START.bat launcher)

---

## 🛑 Stop Scripts

### `stop-services.bat` (Note: Actual file is `STOP-SERVICES.bat`)

**What it does:**
- Kills all processes on ports 8080 and 8081
- Closes service CMD windows
- Frees up ports for next run
- Displays confirmation

**Why use it:**
- Clean shutdown of all services
- Prevents "port in use" errors
- Frees system resources

**When to use:**
- When done testing/developing
- Before rebuilding services
- When services are hung/frozen
- Before shutting down computer

**How to use:**
```bat
# From project root (RECOMMENDED):
STOP.bat

# Or directly from scripts folder:
cd scripts
STOP-SERVICES.bat
```

**What it does:**
1. Finds processes listening on ports 8080 and 8081
2. Kills those processes
3. Verifies ports are free
4. Shows success/failure message

---

### `stop-podman-services.ps1`

**What it does:**
- PowerShell script to stop Podman containers
- Stops and removes inventory-service container
- Stops and removes order-service container
- Removes microservices-network
- Cleans up Podman resources

**Why use it:**
- Stop containerized services
- Clean up Podman resources
- PowerShell-based workflow

**When to use:**
- When services are running as containers
- Need to remove containers completely
- PowerShell environment
- Container cleanup

**How to use:**
```powershell
cd scripts
.\stop-podman-services.ps1
```

**What it cleans up:**
- Running containers
- Stopped containers
- Container networks
- Orphaned resources

---

## 🔧 Utility Scripts

### `check-container-status.bat`

**What it does:**
- Shows Podman version and info
- Lists all container images
- Shows running containers
- Shows all containers (including stopped)
- Displays network ports in use (8080, 8081)
- Lists Java processes

**Why use it:**
- Diagnose service issues
- Check if containers are running
- See what's using ports 8080/8081
- Verify container images exist

**When to use:**
- Services won't start ("port in use" error)
- Checking current status
- Troubleshooting
- Before/after starting services

**How to use:**
```bat
cd scripts
check-container-status.bat
```

**Output shows:**
- Podman version
- All images (including microservices images)
- Running containers with ports
- All containers (including stopped)
- What's using ports 8080 and 8081
- Java processes running

**Example Output:**
```
=== Podman Version ===
Version: 5.7.1

=== All Images ===
localhost/quarkus-microservices/inventory-service  latest  abc123  1 hour ago

=== Running Containers ===
CONTAINER ID  IMAGE                           STATUS      PORTS
abc123def     .../inventory-service:latest   Up 5 mins   0.0.0.0:8080->8080/tcp
```

---

### `check-services.ps1`

**What it does:**
- PowerShell script to check service health
- Tests HTTP endpoints
- Verifies services are responding
- Shows response status codes

**Why use it:**
- Verify services are working
- Health check before testing
- Automated monitoring
- Integration testing

**When to use:**
- After starting services
- Before running tests
- Automated health checks
- CI/CD pipelines

**How to use:**
```powershell
cd scripts
.\check-services.ps1
```

**What it checks:**
- http://localhost:8080/inventory (Inventory Service)
- http://localhost:8081/orders (Order Service)
- Response times
- HTTP status codes

**Expected Output:**
```
Checking Inventory Service...
✓ Status: 200 OK
Checking Order Service...
✓ Status: 200 OK
All services are healthy!
```

---

### `test-services.ps1`

**What it does:**
- PowerShell script to test service endpoints
- Sends sample requests to services
- Tests GET and POST operations
- Validates responses
- Shows detailed results

**Why use it:**
- Automated testing
- Verify functionality after deployment
- Integration testing
- API endpoint validation

**When to use:**
- After starting services
- After code changes
- Before committing code
- Automated testing in CI/CD

**How to use:**
```powershell
cd scripts
.\test-services.ps1
```

**What it tests:**
1. GET all products from inventory
2. GET specific product by ID
3. Check product availability
4. Create a new order
5. Verify order was created

**Sample Output:**
```
Testing Inventory Service...
✓ GET /inventory - 200 OK - 3 products found
✓ GET /inventory/1 - 200 OK - Product: Laptop
✓ GET /inventory/1/check?quantity=2 - 200 OK - Available: true

Testing Order Service...
✓ POST /orders - 201 Created - Order ID: 1
✓ GET /orders/1 - 200 OK - Order status: CONFIRMED

All tests passed! ✓
```

---

## 📊 Script Comparison Matrix

| Script | Purpose | Runtime | Creates Images | Runs Services | Use Case |
|--------|---------|---------|----------------|---------------|----------|
| build-with-maven.bat | Build + Images | Maven | ✅ Yes | ❌ No | **Production build** |
| build.bat | Build only | Maven | ❌ No | ❌ No | Dev build |
| build-podman-images.ps1 | Images only | Podman | ✅ Yes | ❌ No | Rebuild images |
| START-SERVICES.bat | Start Java | Java | ❌ No | ✅ Yes | **Main startup** |
| start-containers.bat | Start containers | Podman | ❌ No | ✅ Yes | Container mode |
| run-services.bat | Run containers | Podman/Docker | ❌ No | ✅ Yes | Container alternative |
| run-services-java.bat | Run Java | Java | ❌ No | ✅ Yes | Direct Java run |
| STOP-SERVICES.bat | Stop all | System | ❌ No | ❌ No | **Main shutdown** |
| check-container-status.bat | Status check | System | ❌ No | ❌ No | Diagnostics |
| check-services.ps1 | Health check | PowerShell | ❌ No | ❌ No | Monitoring |
| test-services.ps1 | Test APIs | PowerShell | ❌ No | ❌ No | Testing |

---

## 🎯 Common Workflows

### Workflow 1: Normal Development (Recommended)
```bat
1. BUILD.bat              # Build everything
2. START.bat              # Start services
3. [Test with Postman]    # Do your testing
4. STOP.bat               # Stop when done
```

### Workflow 2: Quick Code Changes
```bat
1. STOP.bat               # Stop services
2. [Make code changes]    # Edit your code
3. BUILD.bat              # Rebuild
4. START.bat              # Restart
```

### Workflow 3: Container-Based Testing
```bat
1. BUILD.bat                      # Build JAR + images
2. scripts\start-containers.bat   # Start as containers
3. [Test]                         # Test containerized app
4. scripts\stop-podman-services.ps1  # Stop containers
```

### Workflow 4: Troubleshooting
```bat
1. scripts\check-container-status.bat  # Check what's running
2. STOP.bat                            # Stop everything
3. [Check service windows for errors]  # Diagnose issues
4. BUILD.bat                           # Rebuild if needed
5. START.bat                           # Try again
```

### Workflow 5: Automated Testing
```powershell
1. BUILD.bat                    # Build
2. START.bat                    # Start
3. Start-Sleep -Seconds 30      # Wait for startup
4. .\scripts\check-services.ps1 # Verify running
5. .\scripts\test-services.ps1  # Run tests
6. STOP.bat                     # Cleanup
```

---

## 🆘 Troubleshooting Guide

### "Port 8080/8081 already in use"
**Solution:** Run `STOP.bat` or `scripts\check-container-status.bat` to see what's using the ports

### "JAR file not found"
**Solution:** Run `BUILD.bat` to create JAR files

### "Container image not found"
**Solution:** Run `BUILD.bat` or `scripts\build-podman-images.ps1`

### Services start then immediately stop
**Solution:** 
1. Check service CMD windows for error messages
2. Verify Java 17+ is installed: `java -version`
3. Rebuild: `BUILD.bat`

### Container commands don't work
**Solution:**
1. Check if Podman is installed: `podman version`
2. Start Podman Desktop
3. Use Java-based scripts instead: `START.bat`

---

## 💡 Pro Tips

1. **Always use launchers from root** (`BUILD.bat`, `START.bat`, `STOP.bat`) for simplest experience
2. **Keep service windows open** when services are running - don't close them!
3. **Check service windows first** when troubleshooting - error messages appear there
4. **Use check-container-status.bat** before starting to see if ports are free
5. **Run STOP.bat before BUILD.bat** to ensure clean rebuild

---

## 📚 Related Documentation

- **../START-HERE.md** - Main project quick start
- **../README-SOLUTION.md** - Fix Postman socket hang up issues
- **../VISUAL-GUIDE.md** - Visual quick start guide
- **../TROUBLESHOOTING-POSTMAN.md** - Detailed Postman help

---

**Need Help?** 
- Check service CMD windows for error messages
- Run `check-container-status.bat` to diagnose issues
- Read `../README-SOLUTION.md` for troubleshooting
- Verify ports are free: `netstat -ano | findstr ":808"`

