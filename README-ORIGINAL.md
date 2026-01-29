# Quarkus Microservices Demo

This project demonstrates two microservices built with Quarkus that communicate with each other:

## Services

### 1. Inventory Service (Port 8080)
Manages product inventory with the following endpoints:
- `GET /inventory` - Get all products
- `GET /inventory/{id}` - Get a specific product
- `GET /inventory/{id}/check?quantity=X` - Check if product is available
- `POST /inventory/{id}/reserve?quantity=X` - Reserve product quantity

### 2. Order Service (Port 8081)
Manages orders and communicates with Inventory Service:
- `POST /orders` - Create a new order (communicates with inventory service)
- `GET /orders` - Get all orders
- `GET /orders/{id}` - Get a specific order

## Prerequisites
- Java 17 or higher
- Maven 3.8+

## Running the Services

### Option 1: Development Mode (Local)

**Step 1: Start Inventory Service**
```bash
cd inventory-service
mvn quarkus:dev
```
The service will start on http://localhost:8080

**Step 2: Start Order Service** (in another terminal)
```bash
cd order-service
mvn quarkus:dev
```
The service will start on http://localhost:8081

### Option 2: Build Everything (Production)

**Single command to compile, test, build, and create container images:**
```bash
mvn -s ./.mvn/settings.xml clean install
```

This command does everything:
- ✅ Compiles main code
- ✅ Compiles test code  
- ✅ Runs all unit tests (23 tests total)
- ✅ Packages applications as JAR files
- ✅ Creates container images
- ✅ Installs to local Maven repository

**What the settings.xml configures:**
- Container image building (`quarkus.container-image.build=true`)
- Test execution (runs all tests automatically)
- Multi-module reactor build (builds both services)

**Run the containers:**
```bash
podman run -d -p 8080:8080 quarkus-microservices/inventory-service:latest
podman run -d -p 8081:8081 quarkus-microservices/order-service:latest
```

> **Note:** If you want to skip tests for faster builds, use:
> ```bash
> mvn -s ./.mvn/settings.xml clean install -DskipTests
> ```

## Testing the Microservices

### Option 1: Using Postman (Easiest!) 🚀
We've included a complete Postman collection with all endpoints pre-configured!

**Steps:**
1. Open Postman
2. Click **Import** → Upload `Quarkus-Microservices.postman_collection.json`
3. Browse through the requests and click **Send**!

📖 **See detailed guide:** `POSTMAN-GUIDE.md`

### Option 2: Using PowerShell
```powershell
# Get all products from inventory
Invoke-RestMethod -Uri http://localhost:8080/inventory -Method Get

# Create an order
Invoke-RestMethod -Uri http://localhost:8081/orders -Method Post -ContentType "application/json" -Body '{"productId": 1, "quantity": 2}'

# Get all orders
Invoke-RestMethod -Uri http://localhost:8081/orders -Method Get
```

### Option 3: Using curl
```bash
# Get all products
curl http://localhost:8080/inventory

# Create an order (this will call inventory service to check and reserve)
curl -X POST http://localhost:8081/orders ^
  -H "Content-Type: application/json" ^
  -d "{\"productId\": 1, \"quantity\": 2}"

# Get all orders
curl http://localhost:8081/orders
```


## How It Works

1. **Inventory Service** maintains a list of products with quantities
2. **Order Service** uses Quarkus REST Client to communicate with Inventory Service
3. When creating an order:
   - Order Service checks product availability with Inventory Service
   - If available, it fetches product details
   - Then reserves the product quantity
   - Creates an order with status "CONFIRMED" or "FAILED"

## Architecture

```
Order Service (8081)  ----REST Client----> Inventory Service (8080)
                                           - Product data
                                           - Availability check
                                           - Reservation
```

## Sample Products (Preloaded in Inventory)
1. Laptop - Quantity: 10
2. Mouse - Quantity: 50
3. Keyboard - Quantity: 30

## Example Workflow

1. Start both services
2. Check available products: `curl http://localhost:8080/inventory`
3. Create an order: 
   ```bash
   curl -X POST http://localhost:8081/orders -H "Content-Type: application/json" -d "{\"productId\": 1, \"quantity\": 2}"
   ```
4. Verify the order was created and inventory was reduced
5. Check updated inventory: `curl http://localhost:8080/inventory/1`

## Technologies Used
- **Quarkus** - Supersonic Subatomic Java Framework
- **JAX-RS** - REST endpoints
- **MicroProfile REST Client** - Service-to-service communication
- **CDI** - Dependency injection
- **Jackson** - JSON serialization
- **Quarkus Container Image Extension (Jib)** - Container image building from Maven
- **Postman Collection** - Pre-configured API testing (included!)

