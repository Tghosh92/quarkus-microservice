# Container Status Summary

## ✅ YOUR CONTAINERS ARE RUNNING!

### Running Containers

1. **Inventory Service**
   - Container Name: `boring_bohr`
   - Image: `localhost/quarkus-microservices/inventory-service:latest`
   - Status: **Running** (Up 12+ minutes)
   - Port Mapping: `8082:8080`
   - Access URL: `http://localhost:8082/inventory`

2. **Order Service**
   - Container Name: `quirky_jennings`
   - Image: `localhost/quarkus-microservices/order-service:latest`
   - Status: **Running** (Up 12+ minutes)
   - Port Mappings: `8080-8081:8080-8081`
   - Access URL: `http://localhost:8080/orders`

### How to View in Podman Desktop

1. Open **Podman Desktop** application
2. Click on **Containers** in the left navigation panel
3. You will see your running containers with status indicators

### Container Management Commands

**View running containers:**
```bat
podman ps
```

**View all containers (including stopped):**
```bat
podman ps -a
```

**View container logs:**
```bat
podman logs boring_bohr          REM inventory service
podman logs quirky_jennings      REM order service
```

**Stop containers:**
```bat
podman stop boring_bohr quirky_jennings
```

**Start containers:**
```bat
podman start boring_bohr quirky_jennings
```

**Remove containers:**
```bat
podman rm -f boring_bohr quirky_jennings
```

### Test Endpoints with Postman

Use your Postman collection with these URLs:

- **Inventory Service**: `http://localhost:8082`
- **Order Service**: `http://localhost:8080`

**Note:** The inventory service is on port **8082** (not 8080) due to port mapping.

### Quick Status Check

Run this script anytime to check status:
```bat
.\check-container-status.bat
```

---
Generated: January 28, 2026

