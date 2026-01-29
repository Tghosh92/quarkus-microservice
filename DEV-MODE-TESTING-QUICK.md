# 🧪 Testing in Dev Mode - Quick Guide

## 🚀 7 Ways to Test Your Changes Instantly

---

## Method 1: Auto-Reload (Easiest!) ⚡

```bash
# Start dev mode
mvn quarkus:dev

# Edit your Java file
# Save file

# ✨ AUTO-RELOAD happens (1 second)

# Test immediately:
curl http://localhost:8080/inventory
```

**No restart needed!**

---

## Method 2: Browser Testing 🌐

```
1. Start: mvn quarkus:dev
2. Open: http://localhost:8080/inventory
3. Edit code → Save
4. Refresh browser
5. See changes! ✅
```

---

## Method 3: Dev UI (Visual) 🎨

```
1. Start: mvn quarkus:dev
2. Open: http://localhost:8080/q/dev
3. Click "Endpoints" card
4. Test endpoints visually
5. See results in real-time!
```

---

## Method 4: Run Tests 🧪

**In dev mode console:**

```
Press 'r' → Run tests manually
Press 'w' → Auto-run tests on save

Tests run in seconds! ⚡
```

---

## Method 5: Postman 📮

```
1. Start: mvn quarkus:dev
2. Postman → http://localhost:8080/inventory
3. Send request
4. Edit code → Save → Auto-reload
5. Send request again → See changes!
```

---

## Method 6: curl (Command Line) 💻

```bash
# While dev mode running:
curl http://localhost:8080/inventory
curl http://localhost:8080/inventory/1
curl "http://localhost:8080/inventory/1/check?quantity=5"

# Edit code → Save → Auto-reload
# Run curl again → Changes applied!
```

---

## Method 7: PowerShell (Windows) 🪟

```powershell
Invoke-WebRequest -Uri "http://localhost:8080/inventory" -UseBasicParsing

# Edit code → Save
# Run command again → See changes!
```

---

## ⚡ Complete Workflow

```
1. Start:  mvn quarkus:dev
           ↓
2. Edit:   ProductResource.java
           ↓
3. Save:   File saved
           ↓
4. Reload: Auto (1 second) ⚡
           ↓
5. Test:   Choose any method above
           ↓
6. Repeat: Steps 2-5 all day!
```

---

## 🎯 Best Method for Each Scenario

| Scenario | Best Method |
|----------|-------------|
| Quick API check | Browser |
| Visual exploration | Dev UI |
| API testing | Postman |
| Quick tests | Press 'r' |
| Continuous testing | Press 'w' |
| Command line | curl |
| Debugging | Console logs + Dev UI |

---

## 💡 Pro Tips

### Enable Continuous Testing
```
Press 'w' in dev console
Tests run automatically on every save!
```

### Use Console Logging
```java
System.out.println("🔍 Debug: " + value);
// Save → See output immediately!
```

### Multiple Terminals
```
Terminal 1: mvn quarkus:dev (inventory)
Terminal 2: mvn quarkus:dev -Dquarkus.http.port=8081 (order)
Terminal 3: curl commands
```

### Hot Keys in Dev Mode
```
r - Run tests
w - Toggle continuous testing
s - Force restart
h - Show all commands
Ctrl+C - Stop
```

---

## 📊 Speed Comparison

**With Dev Mode (Hot Reload):**
```
Edit code → Save → Test
Total: 10-15 seconds ⚡⚡⚡
```

**Without Dev Mode (Rebuild):**
```
Edit code → mvn clean install → Test
Total: 3-5 minutes 🐢
```

**Dev mode is 12-20x faster!**

---

## ✅ Example: Testing a Code Change

```bash
# 1. Start dev mode
mvn quarkus:dev

# 2. Edit ProductResource.java
@GET
@Path("/hello")
public String hello() {
    return "Hello from Dev Mode!";
}

# 3. Save file → Auto-reload (1 sec) ⚡

# 4. Test immediately
curl http://localhost:8080/inventory/hello
# Output: Hello from Dev Mode! ✅

# 5. Change it again
public String hello() {
    return "Updated message!";
}

# 6. Save → Auto-reload (1 sec) ⚡

# 7. Test again
curl http://localhost:8080/inventory/hello
# Output: Updated message! ✅

# No restart needed! 🎉
```

---

## 🎓 Key Takeaway

**Dev mode gives you:**
- ⚡ Instant feedback (1 second reload)
- 🔄 No manual restarts
- 🧪 Quick test execution
- 🎨 Visual dev UI
- 🐛 Easy debugging
- 🚀 10-20x faster development

**Start it once, use it all day!**

```bash
mvn quarkus:dev
# Edit → Save → Test → Repeat! 🔁
```

---

**See full guide:** `docs/TESTING-IN-DEV-MODE.md`

