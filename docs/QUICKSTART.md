# Quick Start Guide

## What Was Created

Two Quarkus microservices that communicate with each other:

### 📦 Inventory Service (Port 8080)
- **Location:** `inventory-service/`
- **Purpose:** Manages product inventory
- **Endpoints:**
  - `GET /inventory` - List all products
  - `GET /inventory/{id}` - Get product details
  - `GET /inventory/{id}/check?quantity=X` - Check availability
  - `POST /inventory/{id}/reserve?quantity=X` - Reserve products

### 🛒 Order Service (Port 8081)
- **Location:** `order-service/`
- **Purpose:** Creates orders and communicates with Inventory Service
- **Endpoints:**
  - `POST /orders` - Create new order
  - `GET /orders` - List all orders
  - `GET /orders/{id}` - Get order details
- **Communication:** Uses Quarkus REST Client to call Inventory Service

## 🏗️ Building Container Images

Want to run in containers? Build images directly with Maven (no Dockerfile needed!):

```powershell
# Build inventory service
cd inventory-service
mvn clean package -Dquarkus.container-image.build=true

# Build order service
cd ../order-service
mvn clean package -Dquarkus.container-image.build=true
```

**Or use the script:**
```powershell
.\build-with-maven.bat
```

**Then run with Podman/Docker:**
```powershell
podman run -d -p 8080:8080 quarkus-microservices/inventory-service:latest
podman run -d -p 8081:8081 quarkus-microservices/order-service:latest
```

📖 **Full details:** See `BUILD-WITH-MAVEN.md`

## 🚀 Running the Services

### Option 1: Development Mode (Easiest)
Just double-click: **`start-services.bat`**

Or manually:
```bash
# Terminal 1
cd inventory-service
mvn quarkus:dev

# Terminal 2 (open another terminal)
cd order-service
mvn quarkus:dev
```

### Option 2: Container Mode
After building images (see above):
```powershell
.\run-services.bat
```

## 🧪 Testing

### Option 1: Use Postman (Recommended!) 📮
Import the included Postman collection for easy API testing:
1. Open Postman
2. Import `Quarkus-Microservices.postman_collection.json`
3. Click any request and hit **Send**!

📖 **Full guide:** See `POSTMAN-GUIDE.md`

### Option 2: Use PowerShell Test Script
```powershell
.\test-services.ps1
```

### Option 3: Manual Testing with PowerShell

**Test Inventory Service:**
```powershell
# Get all products
Invoke-RestMethod http://localhost:8080/inventory

# Get specific product
Invoke-RestMethod http://localhost:8080/inventory/1
```

**Test Order Service (creates inter-service communication):**
```powershell
# Create an order - this will call inventory service!
Invoke-RestMethod -Uri http://localhost:8081/orders -Method Post -ContentType "application/json" -Body '{"productId": 1, "quantity": 2}'

# View all orders
Invoke-RestMethod http://localhost:8081/orders
```

## 📊 Sample Data

The inventory service comes preloaded with:
- **Product 1:** Laptop (Quantity: 10)
- **Product 2:** Mouse (Quantity: 50)
- **Product 3:** Keyboard (Quantity: 30)

## 🔄 How Communication Works

```
1. User creates order via Order Service
   POST http://localhost:8081/orders
   
2. Order Service calls Inventory Service to check availability
   GET http://localhost:8080/inventory/1/check?quantity=2
   
3. Order Service gets product details
   GET http://localhost:8080/inventory/1
   
4. Order Service reserves the product
   POST http://localhost:8080/inventory/1/reserve?quantity=2
   
5. Order Service returns the created order with status
```

## 🛠️ Technologies Used

- **Quarkus 3.6.4** - Modern Java framework
- **JAX-RS** - REST API endpoints
- **MicroProfile REST Client** - Inter-service communication
- **Jackson** - JSON processing
- **CDI** - Dependency injection
- **Maven** - Build tool

## 📁 Project Structure

```
testproject/
├── inventory-service/          # Inventory microservice
│   ├── src/main/java/
│   │   └── com/example/inventory/
│   │       ├── model/         # Product model
│   │       ├── service/       # Business logic
│   │       └── resource/      # REST endpoints
│   └── pom.xml
│
├── order-service/             # Order microservice
│   ├── src/main/java/
│   │   └── com/example/order/
│   │       ├── model/         # Order & Product models
│   │       ├── client/        # REST client for inventory
│   │       ├── service/       # Business logic
│   │       └── resource/      # REST endpoints
│   └── pom.xml
│
├── README.md                  # Detailed documentation
├── QUICKSTART.md             # This file
├── start-services.bat        # Start both services
└── test-services.ps1         # Test script
```

## ✅ Next Steps

1. Run both services using `start-services.bat`
2. Wait for services to start (watch the console output)
3. Run `.\test-services.ps1` to test the communication
4. Try creating your own orders with different products!

## 🐛 Troubleshooting

- **Services won't start:** Make sure ports 8080 and 8081 are free
- **Order creation fails:** Ensure inventory service is running first
- **Maven errors:** Verify Java 17+ and Maven 3.8+ are installed

Enjoy your microservices! 🎉

