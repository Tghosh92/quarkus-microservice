# Using Postman with the Microservices

## 📥 Import the Collection

### Step 1: Open Postman
Launch Postman application on your computer.

### Step 2: Import the Collection
1. Click **"Import"** button (top-left corner)
2. Click **"Upload Files"** or drag and drop
3. Select the file: `Quarkus-Microservices.postman_collection.json`
4. Click **"Import"**

You'll now see a collection named **"Quarkus Microservices"** in your Collections panel!

---

## 🚀 Using the Collection

### The Collection Contains:

#### 📦 Inventory Service Folder
- **Get All Products** - View all available products
- **Get Product by ID** - View specific product details
- **Check Product Availability** - Check if quantity is available
- **Reserve Product** - Reserve product quantity

#### 🛒 Order Service Folder
- **Create Order - Laptop** - Pre-configured order for laptops
- **Create Order - Mouse** - Pre-configured order for mice
- **Create Order - Keyboard** - Pre-configured order for keyboards
- **Create Order - Custom** - Template for your own orders
- **Get All Orders** - View all orders
- **Get Order by ID** - View specific order details

#### 🧪 Test Scenarios Folder
- **Order Too Many Items** - Test insufficient inventory
- **Order Non-existent Product** - Test invalid product ID
- **Check Product Before Order** - Verify availability first

---

## 🎯 Quick Start Guide

### 1. Start Both Services
Make sure both services are running:
```bash
# Start inventory-service on port 8080
# Start order-service on port 8081
```

### 2. Test Inventory Service First

**Get All Products:**
- Open: `Inventory Service → Get All Products`
- Click **"Send"**
- You should see 3 products (Laptop, Mouse, Keyboard)

**Get Specific Product:**
- Open: `Inventory Service → Get Product by ID`
- Click **"Send"**
- You should see Laptop details (ID: 1)

### 3. Test Order Service (Microservice Communication!)

**Create an Order:**
- Open: `Order Service → Create Order - Laptop`
- Review the JSON body:
  ```json
  {
      "productId": 1,
      "quantity": 2
  }
  ```
- Click **"Send"**
- ✨ **This triggers communication between services!**
- You should see a response with `"status": "CONFIRMED"`

**Verify the Order:**
- Open: `Order Service → Get All Orders`
- Click **"Send"**
- You should see your order in the list

### 4. Verify Inventory Was Updated

**Check Updated Inventory:**
- Open: `Inventory Service → Get Product by ID`
- Click **"Send"**
- Notice the Laptop quantity decreased from 10 to 8!

---

## 📝 Step-by-Step Tutorial

### Tutorial 1: Complete Order Flow

**Step 1: Check Initial Inventory**
```
Request: GET http://localhost:8080/inventory/1
Response: 
{
    "id": 1,
    "name": "Laptop",
    "quantity": 10
}
```

**Step 2: Check Availability**
```
Request: GET http://localhost:8080/inventory/1/check?quantity=2
Response: 
{
    "available": true
}
```

**Step 3: Create Order**
```
Request: POST http://localhost:8081/orders
Body:
{
    "productId": 1,
    "quantity": 2
}
Response:
{
    "id": 1,
    "productId": 1,
    "productName": "Laptop",
    "quantity": 2,
    "status": "CONFIRMED"
}
```

**Step 4: Verify Inventory Updated**
```
Request: GET http://localhost:8080/inventory/1
Response: 
{
    "id": 1,
    "name": "Laptop",
    "quantity": 8  ← Reduced by 2!
}
```

---

## 🧪 Test Scenarios

### Scenario 1: Successful Order ✅

1. **Get All Products** → See available inventory
2. **Create Order - Mouse** → Order 5 mice
3. **Get All Orders** → Verify order was created
4. **Get All Products** → See inventory reduced

### Scenario 2: Failed Order (Insufficient Stock) ❌

1. **Get Product by ID** (Product 1) → See only 10 laptops
2. **Test Scenarios → Order Too Many Items** → Try to order 100 laptops
3. Response will show: `"status": "FAILED: Product not available"`

### Scenario 3: Multiple Orders 📦📦📦

1. **Create Order - Laptop** (2 units)
2. **Create Order - Mouse** (5 units)
3. **Create Order - Keyboard** (1 unit)
4. **Get All Orders** → See all 3 orders
5. **Get All Products** → See all inventory updated

---

## ⚙️ Customizing Requests

### Modify Product ID or Quantity

Open any **"Create Order"** request and edit the JSON body:

```json
{
    "productId": 2,    ← Change this (1=Laptop, 2=Mouse, 3=Keyboard)
    "quantity": 3      ← Change this to order different amount
}
```

### Change Query Parameters

For **"Check Product Availability"** or **"Reserve Product"**:
- Click on the **"Params"** tab
- Modify the `quantity` value
- The URL will update automatically

---

## 🎨 Postman Features to Use

### 1. Save Responses as Examples
After getting a successful response:
- Click **"Save Response"** → **"Save as Example"**
- Helps document expected responses

### 2. Use Variables
The collection includes variables:
- `{{inventory_url}}` = http://localhost:8080
- `{{order_url}}` = http://localhost:8081

You can use these in requests if you want!

### 3. Create a Test Script
Add tests to verify responses automatically:

```javascript
// Add this in the "Tests" tab
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Order is confirmed", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.status).to.include("CONFIRMED");
});
```

### 4. Run Collection
- Click **"..."** next to collection name
- Select **"Run collection"**
- Click **"Run Quarkus Microservices"**
- Watch all requests execute automatically!

---

## 📊 Available Products

| ID | Product  | Initial Quantity |
|----|----------|-----------------|
| 1  | Laptop   | 10              |
| 2  | Mouse    | 50              |
| 3  | Keyboard | 30              |

---

## 🔍 What to Look For

### Successful Order Response
```json
{
    "id": 1,
    "productId": 1,
    "productName": "Laptop",
    "quantity": 2,
    "status": "CONFIRMED"  ← Success!
}
```

### Failed Order Response
```json
{
    "id": 2,
    "productId": 1,
    "productName": "Laptop",
    "quantity": 100,
    "status": "FAILED: Product not available"  ← Failed!
}
```

### Availability Check
```json
{
    "available": true  ← Product is available
}
```

---

## 💡 Pro Tips

1. **Use the Custom Order template** to create your own test cases
2. **Check inventory before ordering** using the availability endpoint
3. **Monitor both services** - watch how order service calls inventory service
4. **Try failure scenarios** - test what happens when products aren't available
5. **Run the collection** - automate testing all endpoints at once

---

## 🚨 Troubleshooting

### Connection Refused / Can't Connect
- **Solution:** Make sure both services are running
  - Inventory Service: http://localhost:8080
  - Order Service: http://localhost:8081

### "Could not get any response"
- **Solution:** Check that the services started successfully
- Run: `mvn quarkus:dev` in each service directory

### 404 Not Found
- **Solution:** Verify the URL path is correct
- Check that you're using the right port (8080 or 8081)

### Order Status is "FAILED"
- **Solution:** This might be expected behavior
  - Check if enough inventory is available
  - Verify the product ID exists (1, 2, or 3)

---

## 🎯 Next Steps

1. ✅ Import the collection into Postman
2. ✅ Start both microservices
3. ✅ Run "Get All Products" to verify inventory service
4. ✅ Create your first order to test service communication
5. ✅ Try all test scenarios
6. ✅ Customize orders with different products and quantities
7. ✅ Run the entire collection automatically

---

**Happy Testing! 🚀**

For more details, check:
- `QUICKSTART.md` - Getting started guide
- `API-EXAMPLES.md` - PowerShell/curl examples
- `ARCHITECTURE.md` - How the services communicate

