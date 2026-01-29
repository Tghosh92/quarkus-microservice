# Microservices Architecture Diagram

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                         CLIENT                              │
│              (Browser, Postman, curl, etc.)                 │
└─────────────────┬───────────────────────┬───────────────────┘
                  │                       │
                  │ HTTP                  │ HTTP
                  │ POST /orders          │ GET /inventory
                  │                       │
       ┌──────────▼──────────┐           ┌▼────────────────────┐
       │   ORDER SERVICE     │           │  INVENTORY SERVICE  │
       │   Port: 8081        │◄──────────┤  Port: 8080         │
       │                     │   REST    │                     │
       │  - OrderResource    │  Client   │  - InventoryResource│
       │  - OrderService     │           │  - InventoryService │
       │  - InventoryClient  │           │  - Product Model    │
       └─────────────────────┘           └─────────────────────┘
```

## Communication Flow

### Creating an Order

```
1. Client Request
   ┌────────────────┐
   │ POST /orders   │
   │ {              │
   │  productId: 1  │
   │  quantity: 2   │
   │ }              │
   └────┬───────────┘
        │
        ▼
   ┌─────────────────────────────────┐
   │ Order Service                    │
   │ OrderResource.createOrder()      │
   └────┬────────────────────────────┘
        │
        ▼
   ┌─────────────────────────────────┐
   │ Order Service                    │
   │ OrderService.createOrder()       │
   └────┬────────────────────────────┘
        │
        ├─── Step 1: Check Availability ───┐
        │                                    │
        ▼                                    ▼
   ┌─────────────────────────────────────────────────┐
   │ REST Client Call                                 │
   │ GET /inventory/1/check?quantity=2                │
   │                                                   │
   │ Inventory Service responds: {"available": true}  │
   └────┬─────────────────────────────────────────────┘
        │
        ├─── Step 2: Get Product Details ───┐
        │                                     │
        ▼                                     ▼
   ┌─────────────────────────────────────────────────┐
   │ REST Client Call                                 │
   │ GET /inventory/1                                 │
   │                                                   │
   │ Inventory Service responds: Product details      │
   └────┬─────────────────────────────────────────────┘
        │
        ├─── Step 3: Reserve Product ───┐
        │                                 │
        ▼                                 ▼
   ┌─────────────────────────────────────────────────┐
   │ REST Client Call                                 │
   │ POST /inventory/1/reserve?quantity=2             │
   │                                                   │
   │ Inventory Service responds:                      │
   │ {"success": true, "message": "Reserved"}         │
   └────┬─────────────────────────────────────────────┘
        │
        ▼
   ┌─────────────────────────────────┐
   │ Order Service                    │
   │ Creates Order with CONFIRMED     │
   │ status                           │
   └────┬────────────────────────────┘
        │
        ▼
   ┌─────────────────────────────────┐
   │ Response to Client               │
   │ {                                │
   │   id: 1,                         │
   │   productId: 1,                  │
   │   productName: "Laptop",         │
   │   quantity: 2,                   │
   │   status: "CONFIRMED"            │
   │ }                                │
   └──────────────────────────────────┘
```

## Key Components

### Inventory Service
**Port:** 8080
**Responsibilities:**
- Store product inventory
- Check product availability
- Reserve products
- Update quantities

**Data Model:**
```
Product {
  id: Long
  name: String
  quantity: int
}
```

### Order Service
**Port:** 8081
**Responsibilities:**
- Create orders
- Validate requests
- Communicate with Inventory Service
- Track order status

**Data Models:**
```
Order {
  id: Long
  productId: Long
  productName: String
  quantity: int
  status: String
}
```

**REST Client:**
```
InventoryClient (Interface)
- Communicates with Inventory Service
- Uses Quarkus REST Client
- Configured in application.properties
```

## Technology Stack

```
┌─────────────────────────────────────┐
│          Application Layer          │
│  JAX-RS Resources (REST Endpoints)  │
├─────────────────────────────────────┤
│         Business Logic Layer        │
│  Services (CDI Beans)               │
├─────────────────────────────────────┤
│      Integration Layer              │
│  MicroProfile REST Client           │
├─────────────────────────────────────┤
│         Quarkus Framework           │
│  - Dependency Injection (CDI)       │
│  - JSON Processing (Jackson)        │
│  - HTTP Server (Vert.x)             │
└─────────────────────────────────────┘
```

## Configuration

### Inventory Service
```properties
quarkus.http.port=8080
quarkus.application.name=inventory-service
```

### Order Service
```properties
quarkus.http.port=8081
quarkus.application.name=order-service
quarkus.rest-client."inventory-api".url=http://localhost:8080
```

## Error Handling

The system handles various error scenarios:

1. **Product Not Available**
   - Order status: "FAILED: Product not available"

2. **Inventory Service Down**
   - Order status: "FAILED: Error communicating with inventory service"

3. **Invalid Request**
   - HTTP 400 Bad Request

4. **Product Not Found**
   - HTTP 404 Not Found

