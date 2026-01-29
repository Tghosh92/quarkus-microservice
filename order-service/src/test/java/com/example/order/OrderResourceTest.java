package com.example.order;

import io.quarkus.test.junit.QuarkusTest;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;

@QuarkusTest
@DisplayName("Order Resource Integration Tests")
public class OrderResourceTest {

    @Test
    @DisplayName("Should return all orders")
    public void testGetAllOrders() {
        given()
            .when()
                .get("/orders")
            .then()
                .statusCode(200)
                .contentType(ContentType.JSON)
                .body("size()", greaterThanOrEqualTo(0));
    }

    @Test
    @DisplayName("Should create order successfully")
    public void testCreateOrder() {
        String orderJson = """
            {
                "productId": 1,
                "quantity": 2
            }
            """;

        given()
            .contentType(ContentType.JSON)
            .body(orderJson)
            .when()
                .post("/orders")
            .then()
                .statusCode(201)
                .contentType(ContentType.JSON)
                .body("id", notNullValue())
                .body("productId", is(1))
                .body("quantity", is(2))
                .body("status", notNullValue());
    }

    @Test
    @DisplayName("Should get order by ID")
    public void testGetOrderById() {
        // First create an order
        String orderJson = """
            {
                "productId": 1,
                "quantity": 1
            }
            """;

        Integer orderId = given()
            .contentType(ContentType.JSON)
            .body(orderJson)
            .when()
                .post("/orders")
            .then()
                .statusCode(201)
                .extract()
                .path("id");

        // Then retrieve it
        given()
            .when()
                .get("/orders/" + orderId)
            .then()
                .statusCode(200)
                .contentType(ContentType.JSON)
                .body("id", is(orderId))
                .body("productId", is(1))
                .body("quantity", is(1));
    }

    @Test
    @DisplayName("Should return 404 for non-existent order")
    public void testGetOrderByIdNotFound() {
        given()
            .when()
                .get("/orders/99999")
            .then()
                .statusCode(404);
    }

    @Test
    @DisplayName("Should fail to create order with invalid data")
    public void testCreateOrderWithInvalidData() {
        String invalidOrder = """
            {
                "productId": null,
                "quantity": 1
            }
            """;

        given()
            .contentType(ContentType.JSON)
            .body(invalidOrder)
            .when()
                .post("/orders")
            .then()
                .statusCode(anyOf(is(400), is(500)));
    }

    @Test
    @DisplayName("Should fail to create order with zero quantity")
    public void testCreateOrderWithZeroQuantity() {
        String orderJson = """
            {
                "productId": 1,
                "quantity": 0
            }
            """;

        given()
            .contentType(ContentType.JSON)
            .body(orderJson)
            .when()
                .post("/orders")
            .then()
                .statusCode(anyOf(is(400), is(500)));
    }

    @Test
    @DisplayName("Should fail to create order with negative quantity")
    public void testCreateOrderWithNegativeQuantity() {
        String orderJson = """
            {
                "productId": 1,
                "quantity": -5
            }
            """;

        given()
            .contentType(ContentType.JSON)
            .body(orderJson)
            .when()
                .post("/orders")
            .then()
                .statusCode(anyOf(is(400), is(500)));
    }

    @Test
    @DisplayName("Should create multiple orders")
    public void testCreateMultipleOrders() {
        String order1 = """
            {
                "productId": 1,
                "quantity": 1
            }
            """;

        String order2 = """
            {
                "productId": 2,
                "quantity": 3
            }
            """;

        // Create first order
        given()
            .contentType(ContentType.JSON)
            .body(order1)
            .when()
                .post("/orders")
            .then()
                .statusCode(201);

        // Create second order
        given()
            .contentType(ContentType.JSON)
            .body(order2)
            .when()
                .post("/orders")
            .then()
                .statusCode(201);

        // Verify both exist
        given()
            .when()
                .get("/orders")
            .then()
                .statusCode(200)
                .body("size()", greaterThanOrEqualTo(2));
    }

    @Test
    @DisplayName("Should handle malformed JSON")
    public void testCreateOrderWithMalformedJson() {
        String malformedJson = "{productId: 1, quantity: 2"; // Missing closing brace

        given()
            .contentType(ContentType.JSON)
            .body(malformedJson)
            .when()
                .post("/orders")
            .then()
                .statusCode(400);
    }

    @Test
    @DisplayName("Should return order with all required fields")
    public void testOrderResponseStructure() {
        String orderJson = """
            {
                "productId": 1,
                "quantity": 2
            }
            """;

        given()
            .contentType(ContentType.JSON)
            .body(orderJson)
            .when()
                .post("/orders")
            .then()
                .statusCode(201)
                .body("id", notNullValue())
                .body("productId", notNullValue())
                .body("quantity", notNullValue())
                .body("status", notNullValue());
    }
}

