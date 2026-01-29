# Unit Testing Guide

## 🧪 Unit Tests Added to the Project

Unit tests have been added for both microservices using **JUnit 5** and **Rest Assured**.

---

## 📁 Test Structure

```
testproject/
├── TEST.bat                                    ← Run all tests (double-click!)
│
├── inventory-service/
│   ├── src/
│   │   ├── main/java/...                       ← Production code
│   │   └── test/                               ← Test code
│   │       ├── java/
│   │       │   └── com/example/inventory/
│   │       │       └── InventoryResourceTest.java   ← 12 test cases
│   │       └── resources/
│   │           └── application.properties      ← Test configuration
│   └── pom.xml                                 ← Updated with test dependencies
│
└── order-service/
    ├── src/
    │   ├── main/java/...                       ← Production code
    │   └── test/                               ← Test code
    │       ├── java/
    │       │   └── com/example/order/
    │       │       └── OrderResourceTest.java       ← 11 test cases
    │       └── resources/
    │           └── application.properties      ← Test configuration
    └── pom.xml                                 ← Updated with test dependencies
```

---

## 🚀 Quick Start - Running Tests

### Method 1: Using TEST.bat (Easiest) ⭐
```bash
# Just double-click!
TEST.bat
```

### Method 2: Using Maven (Command Line)
```bash
# Test both services:
mvn test

# Test specific service:
cd inventory-service
mvn test

cd ../order-service
mvn test
```

### Method 3: Using scripts/run-tests.bat
```bash
.\scripts\run-tests.bat
```

---

## 📊 Test Coverage

### Inventory Service Tests (12 Test Cases)

| Test | Description | What it Tests |
|------|-------------|---------------|
| `testGetAllProducts` | GET /inventory | Returns all products |
| `testGetProductById` | GET /inventory/{id} | Returns specific product |
| `testGetProductByIdNotFound` | GET /inventory/999 | Returns 404 for missing product |
| `testCheckAvailability` | GET /inventory/{id}/check | Checks product availability |
| `testCheckAvailabilityInsufficient` | GET /inventory/{id}/check | Returns false for unavailable quantity |
| `testReserveProduct` | POST /inventory/{id}/reserve | Reserves product successfully |
| `testReserveProductInsufficientQuantity` | POST /inventory/{id}/reserve | Fails with insufficient quantity |
| `testReserveNonExistentProduct` | POST /inventory/999/reserve | Fails for non-existent product |
| `testReserveWithoutQuantity` | POST /inventory/{id}/reserve | Fails without quantity parameter |
| `testGetProductWithInvalidId` | GET /inventory/invalid | Handles invalid ID |
| `testProductDetails` | GET /inventory/1 | Verifies correct product details |

**Total: 12 integration tests** covering all inventory endpoints.

---

### Order Service Tests (11 Test Cases)

| Test | Description | What it Tests |
|------|-------------|---------------|
| `testGetAllOrders` | GET /orders | Returns all orders |
| `testCreateOrder` | POST /orders | Creates order successfully |
| `testGetOrderById` | GET /orders/{id} | Returns specific order |
| `testGetOrderByIdNotFound` | GET /orders/99999 | Returns 404 for missing order |
| `testCreateOrderWithInvalidData` | POST /orders | Fails with null productId |
| `testCreateOrderWithZeroQuantity` | POST /orders | Fails with zero quantity |
| `testCreateOrderWithNegativeQuantity` | POST /orders | Fails with negative quantity |
| `testCreateMultipleOrders` | POST /orders (multiple) | Creates multiple orders |
| `testCreateOrderWithMalformedJson` | POST /orders | Handles malformed JSON |
| `testOrderResponseStructure` | POST /orders | Verifies response structure |

**Total: 11 integration tests** covering all order endpoints.

---

## 🔧 Test Dependencies Added

### In both pom.xml files:

```xml
<!-- Test Dependencies -->
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-junit5</artifactId>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>rest-assured</artifactId>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <scope>test</scope>
</dependency>
```

**Order Service also includes:**
```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-junit5-mockito</artifactId>
    <scope>test</scope>
</dependency>
```

---

## 🎯 Testing Approach

### Integration Tests with Quarkus Test Framework

All tests use **`@QuarkusTest`** annotation, which means:
- ✅ Starts a real Quarkus application
- ✅ Tests against actual HTTP endpoints
- ✅ Uses Rest Assured for HTTP testing
- ✅ Fast test execution with Quarkus dev mode
- ✅ Realistic testing environment

### Example Test:

```java
@Test
@DisplayName("Should return all products")
public void testGetAllProducts() {
    given()
        .when()
            .get("/inventory")
        .then()
            .statusCode(200)
            .contentType(ContentType.JSON)
            .body("size()", greaterThan(0));
}
```

---

## 📝 Test Configuration

### Inventory Service Test Config
**File:** `inventory-service/src/test/resources/application.properties`
```properties
quarkus.http.test-port=8081
quarkus.log.level=INFO
quarkus.log.console.enable=true
```

### Order Service Test Config
**File:** `order-service/src/test/resources/application.properties`
```properties
quarkus.http.test-port=8082
quarkus.log.level=INFO
quarkus.log.console.enable=true
quarkus.rest-client."inventory-api".url=http://localhost:8081
```

---

## 🎓 Running Tests in Different Ways

### 1. Run All Tests
```bash
# From project root:
mvn test

# Or use TEST.bat:
TEST.bat
```

### 2. Run Tests for Specific Service
```bash
# Inventory service only:
cd inventory-service
mvn test

# Order service only:
cd order-service
mvn test
```

### 3. Run Specific Test Class
```bash
mvn test -Dtest=InventoryResourceTest
mvn test -Dtest=OrderResourceTest
```

### 4. Run Specific Test Method
```bash
mvn test -Dtest=InventoryResourceTest#testGetAllProducts
mvn test -Dtest=OrderResourceTest#testCreateOrder
```

### 5. Run Tests with Detailed Output
```bash
mvn test -X
```

### 6. Run Tests and Generate Reports
```bash
mvn test
# Reports generated in: target/surefire-reports/
```

---

## 📊 Test Report Location

After running tests, reports are generated:

```
inventory-service/target/surefire-reports/
├── TEST-com.example.inventory.InventoryResourceTest.xml
└── com.example.inventory.InventoryResourceTest.txt

order-service/target/surefire-reports/
├── TEST-com.example.order.OrderResourceTest.xml
└── com.example.order.OrderResourceTest.txt
```

---

## 🔍 Understanding Test Output

### Successful Test Run:
```
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running com.example.inventory.InventoryResourceTest
Tests run: 12, Failures: 0, Errors: 0, Skipped: 0

Results:
Tests run: 12, Failures: 0, Errors: 0, Skipped: 0

[INFO] BUILD SUCCESS
```

### Failed Test Run:
```
Tests run: 12, Failures: 1, Errors: 0, Skipped: 0

[ERROR] Failures:
[ERROR]   InventoryResourceTest.testGetAllProducts:18
Expected status code 200 but was 404.

[INFO] BUILD FAILURE
```

---

## 🛠️ Common Testing Commands

### Build Without Running Tests (Faster)
```bash
# Skip tests during build:
mvn clean package -DskipTests

# Or use BUILD.bat (configured to skip tests):
BUILD.bat
```

### Build WITH Tests (Quality Check)
```bash
# Build and run all tests:
mvn clean install

# Tests must pass for build to succeed
```

### Continuous Testing (Dev Mode)
```bash
# Start Quarkus in dev mode with continuous testing:
cd inventory-service
mvn quarkus:dev

# Press 'r' to run tests
# Tests re-run automatically on code changes
```

---

## 🎯 Test Best Practices

### 1. **Descriptive Test Names**
```java
@DisplayName("Should return 404 for non-existent product")
public void testGetProductByIdNotFound() { }
```

### 2. **Test One Thing Per Test**
Each test focuses on a single scenario.

### 3. **Use Proper HTTP Status Codes**
- 200: Success
- 201: Created
- 400: Bad Request
- 404: Not Found

### 4. **Verify Response Structure**
```java
.body("id", notNullValue())
.body("name", notNullValue())
.body("quantity", notNullValue())
```

### 5. **Test Edge Cases**
- Invalid IDs
- Missing parameters
- Negative values
- Malformed JSON

---

## 🐛 Troubleshooting Tests

### Problem: Tests Fail with "Port Already in Use"
**Solution:**
```bash
# Stop running services:
STOP.bat

# Then run tests:
TEST.bat
```

### Problem: Tests Fail with "Connection Refused"
**Solution:**
Tests use different ports (8081, 8082) to avoid conflicts with running services.

### Problem: "Cannot Find Test Classes"
**Solution:**
```bash
# Rebuild project:
mvn clean compile
mvn test-compile
mvn test
```

### Problem: Tests Pass Individually but Fail Together
**Solution:**
Tests may have dependencies. Check test data and state.

---

## 📈 Continuous Integration

### Add Tests to CI/CD Pipeline

```yaml
# Example GitHub Actions workflow:
- name: Run Tests
  run: mvn test

# Example Jenkins pipeline:
stage('Test') {
    steps {
        sh 'mvn test'
    }
}
```

---

## 🎓 Learning Resources

### JUnit 5 Documentation
- https://junit.org/junit5/docs/current/user-guide/

### Rest Assured Documentation
- https://rest-assured.io/

### Quarkus Testing Guide
- https://quarkus.io/guides/getting-started-testing

---

## 📋 Quick Reference

| Command | Description |
|---------|-------------|
| `TEST.bat` | Run all tests (easiest) |
| `mvn test` | Run all tests with Maven |
| `mvn test -Dtest=ClassName` | Run specific test class |
| `mvn test -X` | Verbose test output |
| `mvn clean package -DskipTests` | Build without tests |
| `mvn quarkus:dev` | Dev mode with continuous testing |

---

## ✅ Test Checklist

Before committing code:
- [ ] All tests pass locally (`TEST.bat`)
- [ ] New features have tests
- [ ] Tests are well-named and documented
- [ ] Edge cases are covered
- [ ] Tests run in CI/CD

---

## 🎉 Summary

**Tests Added:**
- ✅ 12 tests for Inventory Service
- ✅ 11 tests for Order Service
- ✅ Total: 23 integration tests
- ✅ Test dependencies added to pom.xml
- ✅ Test configuration files created
- ✅ TEST.bat launcher created
- ✅ scripts/run-tests.bat created

**Coverage:**
- ✅ All REST endpoints tested
- ✅ Success scenarios covered
- ✅ Error scenarios covered
- ✅ Edge cases included
- ✅ Response structure validated

**Usage:**
```bash
# Run tests:
TEST.bat

# Build with tests:
mvn clean install

# Build without tests:
BUILD.bat
```

**Your microservices now have comprehensive unit tests! 🧪✨**

