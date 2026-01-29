# 🚀 Quarkus Microservices - Inventory & Order Management

A production-ready microservices application built with **Quarkus**, featuring inventory management and order processing with database persistence, comprehensive logging, and automated testing.

![Java](https://img.shields.io/badge/Java-17-orange)
![Quarkus](https://img.shields.io/badge/Quarkus-3.6.4-blue)
![Database](https://img.shields.io/badge/Database-H2%20%7C%20PostgreSQL-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [API Endpoints](#api-endpoints)
- [Database](#database)
- [Testing](#testing)
- [Documentation](#documentation)
- [Contributing](#contributing)

---

## ✨ Features

### Core Functionality
- ✅ **Inventory Management** - Track product stock levels
- ✅ **Order Processing** - Create and manage orders
- ✅ **Inter-service Communication** - REST client integration
- ✅ **Database Persistence** - H2 (dev) & PostgreSQL (prod)

### Technical Features
- ✅ **Comprehensive Logging** - Structured logging with emojis
- ✅ **Unit & Integration Tests** - 23 automated tests
- ✅ **Hot Reload** - Instant code changes in dev mode
- ✅ **Container Images** - Docker/Podman support
- ✅ **Production Ready** - Transaction support, error handling

---

## 🏗️ Architecture

```
┌─────────────────┐       ┌─────────────────┐
│  Order Service  │──────▶│Inventory Service│
│   (Port 8081)   │ REST  │   (Port 8080)   │
└────────┬────────┘       └────────┬────────┘
         │                         │
         ▼                         ▼
    ┌─────────┐              ┌─────────┐
    │Order DB │              │Inventory│
    │  (H2)   │              │  DB (H2)│
    └─────────┘              └─────────┘
```

### Services

#### Inventory Service (Port 8080)
- Manages product catalog and stock levels
- Handles inventory reservations
- Provides product availability checks

#### Order Service (Port 8081)
- Creates and manages customer orders
- Validates stock availability
- Coordinates with Inventory Service

---

## 🔧 Prerequisites

- **Java 17+** - [Download](https://adoptium.net/)
- **Maven 3.8+** - [Download](https://maven.apache.org/download.cgi)
- **Git** - [Download](https://git-scm.com/)
- **Podman/Docker** (optional) - For containers

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/quarkus-microservices.git
cd quarkus-microservices
```

### 2. Build the Services

```bash
mvn -s ./.mvn/settings.xml clean install
```

This command:
- Compiles both services
- Runs all 23 unit tests
- Creates JAR files
- Builds container images

### 3. Start the Services

**Option A: Using Java (Development)**
```bash
# Terminal 1 - Inventory Service
cd inventory-service
mvn quarkus:dev

# Terminal 2 - Order Service  
cd order-service
mvn quarkus:dev
```

**Option B: Using Scripts (Windows)**
```bash
START.bat
```

### 4. Test the APIs

**Get all products:**
```bash
curl http://localhost:8080/inventory
```

**Create an order:**
```bash
curl -X POST http://localhost:8081/orders \
  -H "Content-Type: application/json" \
  -d '{"productId": 1, "quantity": 2}'
```

---

## 📁 Project Structure

```
quarkus-microservices/
├── inventory-service/          # Inventory microservice
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/          # Source code
│   │   │   └── resources/     # Config & SQL
│   │   └── test/              # Unit tests (12 tests)
│   └── pom.xml
│
├── order-service/             # Order microservice
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/          # Source code
│   │   │   └── resources/     # Config & SQL
│   │   └── test/              # Unit tests (11 tests)
│   └── pom.xml
│
├── docs/                      # Documentation
├── postman/                   # API collection
├── scripts/                   # Build & deployment scripts
├── BUILD.bat                  # Build launcher
├── START.bat                  # Start launcher
├── STOP.bat                   # Stop launcher
└── TEST.bat                   # Test launcher
```

---

## 🌐 API Endpoints

### Inventory Service (http://localhost:8080)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/inventory` | Get all products |
| GET | `/inventory/{id}` | Get product by ID |
| GET | `/inventory/{id}/check?quantity={qty}` | Check availability |
| POST | `/inventory/{id}/reserve?quantity={qty}` | Reserve product |

### Order Service (http://localhost:8081)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/orders` | Get all orders |
| GET | `/orders/{id}` | Get order by ID |
| POST | `/orders` | Create new order |

**Example Request:**
```json
POST /orders
{
  "productId": 1,
  "quantity": 2
}
```

**Example Response:**
```json
{
  "id": 1,
  "productId": 1,
  "productName": "Laptop",
  "quantity": 2,
  "status": "CONFIRMED"
}
```

---

## 💾 Database

### Development (H2)
- **Type:** Embedded file-based database
- **Location:** `./data/inventory-db`, `./data/order-db`
- **Persistence:** Data survives restarts
- **No installation needed**

### Production (PostgreSQL)

Update `application.properties`:

```properties
# Uncomment for PostgreSQL
quarkus.datasource.db-kind=postgresql
quarkus.datasource.username=your_user
quarkus.datasource.password=your_password
quarkus.datasource.jdbc.url=jdbc:postgresql://localhost:5432/your_db
```

### Initial Data

Products are auto-loaded on startup:
- Laptop (10 units)
- Mouse (50 units)  
- Keyboard (30 units)
- Monitor (15 units)
- Webcam (25 units)

---

## 🧪 Testing

### Run All Tests

```bash
# Using Maven
mvn test

# Using launcher
TEST.bat
```

### Test Coverage

- **23 automated tests** (12 inventory + 11 order)
- **Integration tests** with Quarkus Test Framework
- **REST API testing** with Rest Assured

**Example Test:**
```java
@Test
public void testCreateOrder() {
    given()
        .contentType(ContentType.JSON)
        .body("{\"productId\": 1, \"quantity\": 2}")
    .when()
        .post("/orders")
    .then()
        .statusCode(201)
        .body("productId", is(1))
        .body("quantity", is(2));
}
```

---

## 📚 Documentation

Comprehensive documentation available in the `docs/` folder:

- **[START-HERE.md](docs/START-HERE.md)** - Quick start guide
- **[DATABASE-GUIDE.md](docs/DATABASE-GUIDE.md)** - Database setup & migration
- **[LOGGING-GUIDE.md](docs/LOGGING-GUIDE.md)** - Logging configuration
- **[TESTING-GUIDE.md](docs/UNIT-TESTING-GUIDE.md)** - Testing documentation
- **[API-EXAMPLES.md](docs/API-EXAMPLES.md)** - API usage examples

### Postman Collection

Import the Postman collection for easy API testing:
```
postman/Quarkus-Microservices.postman_collection.json
```

---

## 🐳 Docker/Podman Support

### Build Container Images

Images are automatically built with:
```bash
mvn -s ./.mvn/settings.xml clean install
```

### Run Containers

```bash
# Inventory Service
podman run -d -p 8080:8080 quarkus-microservices/inventory-service:latest

# Order Service
podman run -d -p 8081:8081 quarkus-microservices/order-service:latest
```

---

## 🔥 Development Workflow

### Hot Reload Development

```bash
cd inventory-service
mvn quarkus:dev
```

Features:
- ⚡ Instant code reload on save
- 🧪 Continuous testing (press 'r')
- 🎨 Dev UI: http://localhost:8080/q/dev
- 🐛 Debug mode enabled

### Build for Production

```bash
mvn -s ./.mvn/settings.xml clean install -DskipTests
```

---

## 📊 Monitoring & Logging

### Structured Logging

All operations are logged with:
- 📋 INFO - Business operations
- 🔍 DEBUG - Detailed information
- ⚠️ WARN - Potential issues
- ❌ ERROR - Errors with stack traces

**Example Log Output:**
```
12:34:56.789 [INFO] [OrderService] 🔄 Creating order - Product: 1, Quantity: 2
12:34:56.790 [DEBUG] [OrderService] Checking availability for product 1
12:34:56.791 [INFO] [InventoryService] 📦 Reserve request - Product ID: 1, Quantity: 2
12:34:56.792 [INFO] [OrderService] ✅ Order created successfully
```

### Log Files

- `logs/inventory-service.log` - Inventory service logs
- `logs/order-service.log` - Order service logs

---

## 🛠️ Technology Stack

| Technology | Purpose |
|------------|---------|
| **Quarkus 3.6.4** | Microservices framework |
| **Java 17** | Programming language |
| **Hibernate ORM Panache** | Database ORM |
| **H2 Database** | Development database |
| **PostgreSQL** | Production database |
| **JUnit 5** | Testing framework |
| **Rest Assured** | API testing |
| **JBoss Logging** | Logging framework |
| **Maven** | Build tool |
| **JIB** | Container image builder |

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👥 Authors

- **Your Name** - *Initial work*

---

## 🙏 Acknowledgments

- Quarkus team for the amazing framework
- Contributors and testers
- Open source community

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/YOUR_USERNAME/quarkus-microservices/issues)
- **Documentation:** See `docs/` folder
- **Email:** your.email@example.com

---

## 🎯 Roadmap

- [ ] Add authentication/authorization
- [ ] Implement caching layer
- [ ] Add metrics and monitoring
- [ ] Create Kubernetes deployment
- [ ] Add CI/CD pipeline
- [ ] Implement event-driven architecture

---

**⭐ Star this repository if you find it helpful!**

**🔗 Connect:** [LinkedIn](https://linkedin.com/in/yourprofile) | [Twitter](https://twitter.com/yourhandle)

