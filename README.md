# Quarkus Microservices Project

A microservices architecture built with Quarkus framework, featuring inventory and order management services with Podman containerization.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [API Documentation](#api-documentation)
- [Monitoring & Logging](#monitoring--logging)
- [Troubleshooting](#troubleshooting)
- [Project Structure](#project-structure)

## 🎯 Overview

This project demonstrates a microservices architecture using:
- **Quarkus**: Supersonic Subatomic Java framework
- **Podman**: Container management and orchestration
- **Maven**: Build and dependency management
- **RESTful APIs**: Service communication
- **Logging**: Comprehensive debug and info logging

### Services

1. **Inventory Service** (Port 8081)
   - Manages product inventory
   - Stock level tracking
   - Product information management

2. **Order Service** (Port 8080)
   - Handles order creation and management
   - Integrates with inventory service
   - Order status tracking

## 🏗️ Architecture

```
┌─────────────────┐      ┌─────────────────┐
│  Order Service  │─────▶│ Inventory Svc   │
│   Port: 8080    │      │   Port: 8081    │
└─────────────────┘      └─────────────────┘
        │                         │
        └─────────────────────────┘
                  │
            Podman Network
```

## 📦 Prerequisites

- **Java**: JDK 17 or higher
- **Maven**: 3.8.1 or higher
- **Podman**: Latest version (already installed)
- **Git**: For version control
- **Postman** (optional): For API testing

## 🚀 Quick Start

### Single Command Build & Run

Build both services and create Podman images:

```powershell
mvn -s ./.mvn/settings.xml clean install
```

This command will:
- ✅ Clean previous builds
- ✅ Compile source code
- ✅ Run unit tests
- ✅ Package applications
- ✅ Create Podman container images
- ✅ Generate build artifacts

### Start Services

```powershell
.\START.bat
```

### Check Status

```powershell
podman ps
```

### Stop Services

```powershell
.\STOP.bat
```

## 💻 Development

### Development Mode (Hot Reload)

For rapid development with live reload:

```powershell
cd inventory-service
mvn quarkus:dev
```

Or for order service:

```powershell
cd order-service
mvn quarkus:dev
```

**Development Mode vs Production Build:**

| Feature | Dev Mode (`quarkus:dev`) | Production (`clean install`) |
|---------|-------------------------|------------------------------|
| Hot Reload | ✅ Yes | ❌ No |
| Fast Startup | ✅ Very fast | ⚠️ Normal |
| Container Image | ❌ No | ✅ Yes |
| Unit Tests | ⚠️ Optional | ✅ Always runs |
| Use Case | Active development | Deployment/Testing |

### Testing Changes in Dev Mode

1. Start service in dev mode:
   ```powershell
   cd inventory-service
   mvn quarkus:dev
   ```

2. Make code changes in your IDE

3. Changes are automatically reloaded (check console)

4. Test using Postman or curl:
   ```powershell
   curl http://localhost:8081/inventory
   ```

5. Press `r` in terminal to force restart if needed

## 🧪 Testing

### Run Unit Tests

```powershell
.\TEST.bat
```

Or manually:

```powershell
mvn -s ./.mvn/settings.xml test
```

### API Testing with Postman

1. Import collection: `postman/Quarkus-Microservices.postman_collection.json`
2. Ensure services are running
3. Run requests from the collection

**Common Issues:**
- **Socket Hang Up**: Services not running or wrong ports
- **Connection Refused**: Containers not started
- **Timeout**: Service taking too long to respond

See `postman/README.md` for detailed troubleshooting.

## 📦 Deployment

### Build Container Images

```powershell
.\BUILD.bat
```

Or use Maven directly:

```powershell
mvn -s ./.mvn/settings.xml clean install
```

### View Images

```powershell
podman images
```

Expected output:
```
REPOSITORY                    TAG      IMAGE ID      CREATED        SIZE
localhost/inventory-service   1.0.0    <id>         <time>         <size>
localhost/order-service       1.0.0    <id>         <time>         <size>
```

### Container Management

**Check Running Containers:**
```powershell
podman ps
```

**View Container Logs:**
```powershell
podman logs inventory-service
podman logs order-service
```

**Podman Desktop:**
- Open Podman Desktop application
- Navigate to "Containers" tab
- View status, logs, and metrics

## 📖 API Documentation

### Inventory Service (http://localhost:8081)

#### Get All Inventory Items
```http
GET /inventory
```

**Response:**
```json
[
  {
    "productId": "P001",
    "productName": "Laptop",
    "quantity": 50,
    "price": 999.99
  }
]
```

#### Get Inventory Item
```http
GET /inventory/{productId}
```

#### Check Stock
```http
GET /inventory/{productId}/stock
```

**Response:**
```json
{
  "productId": "P001",
  "available": true,
  "quantity": 50
}
```

### Order Service (http://localhost:8080)

#### Create Order
```http
POST /orders
Content-Type: application/json

{
  "productId": "P001",
  "quantity": 2,
  "customerId": "C001"
}
```

#### Get All Orders
```http
GET /orders
```

#### Get Order by ID
```http
GET /orders/{orderId}
```

For complete API examples, see: `docs/API-EXAMPLES.md`

## 📊 Monitoring & Logging

### Application Logs

**Service Logs:**
- Inventory: `inventory-service/logs/inventory-service.log`
- Order: `order-service/logs/order-service.log`

**Container Logs:**
```powershell
podman logs -f inventory-service
podman logs -f order-service
```

**Log Levels:**
- `INFO`: Normal operations, service startup, request handling
- `DEBUG`: Detailed debugging information, method entry/exit
- `WARN`: Warning conditions
- `ERROR`: Error conditions

See `docs/LOGGING-GUIDE.md` for configuration details.

### Health Checks

```powershell
# Inventory Service Health
curl http://localhost:8081/q/health

# Order Service Health
curl http://localhost:8080/q/health
```

## 🔧 Troubleshooting

### Services Won't Start

1. Check if ports are available:
   ```powershell
   netstat -ano | findstr "8080"
   netstat -ano | findstr "8081"
   ```

2. Verify Podman is running:
   ```powershell
   podman ps
   ```

3. Check container logs:
   ```powershell
   podman logs inventory-service
   ```

### Build Failures

1. Clean and rebuild:
   ```powershell
   mvn clean
   mvn -s ./.mvn/settings.xml clean install
   ```

2. Check Java version:
   ```powershell
   java -version
   ```

3. Verify Maven settings:
   ```powershell
   mvn -version
   ```

### Postman Socket Hang Up

- Ensure containers are running: `podman ps`
- Check service health endpoints
- Verify correct ports (8080, 8081)
- Wait for services to fully start (~30 seconds)

See `postman/TROUBLESHOOTING-POSTMAN.md` for more solutions.

## 📁 Project Structure

```
testproject/
├── inventory-service/          # Inventory microservice
│   ├── src/
│   │   ├── main/java/          # Source code
│   │   └── test/               # Unit tests
│   ├── logs/                   # Application logs
│   ├── pom.xml                 # Maven configuration with Jib
│   └── target/                 # Build output
│
├── order-service/              # Order microservice
│   ├── src/
│   │   ├── main/java/          # Source code
│   │   └── test/               # Unit tests
│   ├── logs/                   # Application logs
│   ├── pom.xml                 # Maven configuration with Jib
│   └── target/                 # Build output
│
├── scripts/                    # Build and deployment scripts
│   ├── build-podman-images.ps1
│   ├── start-services.bat
│   ├── stop-services.bat
│   └── README.md               # Scripts documentation
│
├── postman/                    # API testing
│   ├── Quarkus-Microservices.postman_collection.json
│   └── README.md               # Postman guide
│
├── docs/                       # Documentation
│   ├── QUICKSTART.md
│   ├── API-EXAMPLES.md
│   ├── ARCHITECTURE.md
│   └── ...
│
├── pom.xml                     # Parent POM
├── BUILD.bat                   # Build script
├── START.bat                   # Start services
├── STOP.bat                    # Stop services
├── TEST.bat                    # Run tests
└── README.md                   # This file
```

## 🔄 Common Workflows

### Daily Development

```powershell
# 1. Start in dev mode
cd inventory-service
mvn quarkus:dev

# 2. Make changes in IDE
# 3. Test with Postman
# 4. Changes auto-reload
```

### Building for Deployment

```powershell
# 1. Build everything
mvn -s ./.mvn/settings.xml clean install

# 2. Start containers
.\START.bat

# 3. Run tests
.\TEST.bat

# 4. Check status
podman ps
```

### Updating Services

```powershell
# 1. Stop running services
.\STOP.bat

# 2. Make code changes

# 3. Rebuild
mvn -s ./.mvn/settings.xml clean install

# 4. Restart
.\START.bat
```

## 📚 Additional Documentation

- **Quick Start Guide**: `docs/QUICKSTART.md`
- **Architecture Details**: `docs/ARCHITECTURE.md`
- **API Examples**: `docs/API-EXAMPLES.md`
- **Build Methods**: `docs/BUILD-METHODS-EXPLAINED.md`
- **Unit Testing**: `docs/UNIT-TESTING-GUIDE.md`
- **Logging Guide**: `docs/LOGGING-GUIDE.md`
- **Scripts Documentation**: `scripts/README.md`
- **Postman Guide**: `postman/README.md`

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Run tests: `mvn test`
4. Build: `mvn clean install`
5. Commit and push

## 📝 License

[Your License Here]

## 👥 Authors

Tarasankar GHOSH <tarasankarghosh.192@gmail.com>

## 🆘 Support

For issues or questions:
1. Check `postman/TROUBLESHOOTING-POSTMAN.md`
2. Review service logs in `logs/` directory
3. Check container logs: `podman logs <service-name>`
4. Review documentation in `docs/` folder

---

**Version**: 1.0.0  
**Last Updated**: January 2026

