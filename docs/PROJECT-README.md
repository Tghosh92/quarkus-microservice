# Quarkus Microservices Project

A microservices architecture demo with Inventory and Order services built with Quarkus.

## 🚀 Quick Start (3 Simple Steps)

### 1️⃣ Build
Double-click **`BUILD.bat`** in the project root

### 2️⃣ Start
Double-click **`START.bat`** in the project root

### 3️⃣ Test
Open Postman and import: `Quarkus-Microservices.postman_collection.json`

**That's it!** 🎉

---

## 📁 Project Structure

```
testproject/
├── BUILD.bat                    ⭐ Build both services (CLICK THIS FIRST)
├── START.bat                    ⭐ Start both services (CLICK THIS SECOND)
├── STOP.bat                     ⭐ Stop all services
│
├── README-SOLUTION.md           📖 Complete troubleshooting guide
├── FIX-SOCKET-HANGUP.md        🔧 Fix Postman socket errors
├── TROUBLESHOOTING-POSTMAN.md  🔧 Detailed Postman help
│
├── Quarkus-Microservices.postman_collection.json  📮 Postman API tests
│
├── scripts/                     📂 All build/start/stop scripts
│   ├── build-with-maven.bat
│   ├── START-SERVICES.bat
│   ├── STOP-SERVICES.bat
│   └── README.md               📖 Scripts documentation
│
├── inventory-service/          📦 Inventory microservice
│   └── src/main/java/...
│
└── order-service/              📦 Order microservice
    └── src/main/java/...
```

---

## 🌐 Service URLs

Once services are running:

| Service | URL | Description |
|---------|-----|-------------|
| **Inventory** | http://localhost:8080/inventory | Product inventory management |
| **Orders** | http://localhost:8081/orders | Order processing |

---

## 📝 Available Scripts

| Script | Description |
|--------|-------------|
| `BUILD.bat` | Build both services and create container images |
| `START.bat` | Start both services (opens 2 CMD windows) |
| `STOP.bat` | Stop all running services |

**Note:** All helper scripts are organized in the `scripts/` folder.

---

## 🧪 Testing with Postman

1. **Import Collection:** Import `postman\Quarkus-Microservices.postman_collection.json`
2. **Configure Settings:**
   - Request timeout: 60000 ms
   - SSL verification: OFF
   - Proxy: Disabled or bypass localhost
3. **Test Endpoints:**
   - GET http://localhost:8080/inventory
   - GET http://localhost:8081/orders
   - POST http://localhost:8081/orders

**Full Postman documentation:** See `postman\README.md`

---

## 🔧 Troubleshooting

### Socket Hang Up Error in Postman?
👉 Read **`README-SOLUTION.md`** for complete fix

### Services won't start?
1. Run `STOP.bat` to clean up
2. Run `BUILD.bat` to rebuild
3. Run `START.bat` to restart
4. Check the service windows for errors

### Port already in use?
Run `STOP.bat` to kill processes using ports 8080/8081

---

## 📚 Documentation

- **`README-SOLUTION.md`** - Complete setup and troubleshooting guide
- **`FIX-SOCKET-HANGUP.md`** - Fix Postman connection issues
- **`TROUBLESHOOTING-POSTMAN.md`** - Detailed Postman configuration
- **`scripts/README.md`** - Scripts documentation

---

## 🏗️ Architecture

- **Inventory Service (8080):** Manages product inventory
- **Order Service (8081):** Processes orders, calls Inventory Service
- **Technology:** Quarkus, Java 17, Maven, REST APIs

---

## ✅ Verify Services Are Running

**Browser Test:**
```
http://localhost:8080/inventory
http://localhost:8081/orders
```

**Command Line:**
```bat
netstat -ano | findstr ":8080.*LISTENING"
netstat -ano | findstr ":8081.*LISTENING"
```

Both should show output = services are running ✓

---

## 🛑 Stopping Services

**Option 1:** Double-click `STOP.bat`

**Option 2:** Close the service CMD windows

**Option 3:** Task Manager → End "java.exe" processes

---

## 📖 API Endpoints

### Inventory Service (8080)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/inventory` | Get all products |
| GET | `/inventory/{id}` | Get product by ID |
| GET | `/inventory/{id}/check?quantity=X` | Check availability |
| POST | `/inventory/{id}/reserve?quantity=X` | Reserve items |

### Order Service (8081)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/orders` | Get all orders |
| GET | `/orders/{id}` | Get order by ID |
| POST | `/orders` | Create new order |

**Example Order Creation:**
```json
POST http://localhost:8081/orders
Content-Type: application/json

{
  "productId": 1,
  "quantity": 2
}
```

---

## 🆘 Need Help?

1. Check **`README-SOLUTION.md`** - Most common issues solved here
2. Look at service CMD windows for error messages
3. Verify services are running: `netstat -ano | findstr ":808"`
4. Test in browser before testing in Postman

---

## 🎯 Success Indicators

When everything is working:
- ✅ Two CMD windows open (INVENTORY-SERVICE, ORDER-SERVICE)
- ✅ Both show "Listening on: http://0.0.0.0:80XX"
- ✅ Browser shows JSON data at http://localhost:8080/inventory
- ✅ Browser shows JSON data at http://localhost:8081/orders
- ✅ Postman returns 200 OK on GET requests

---

**Happy Coding! 🚀**

