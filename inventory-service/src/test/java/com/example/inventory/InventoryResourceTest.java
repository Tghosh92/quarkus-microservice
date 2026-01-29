package com.example.inventory;

import io.quarkus.test.junit.QuarkusTest;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.hamcrest.Matchers.greaterThan;

@QuarkusTest
@DisplayName("Inventory Resource Integration Tests")
public class InventoryResourceTest {

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

    @Test
    @DisplayName("Should return product by ID")
    public void testGetProductById() {
        given()
            .when()
                .get("/inventory/1")
            .then()
                .statusCode(200)
                .contentType(ContentType.JSON)
                .body("id", is(1))
                .body("name", notNullValue())
                .body("quantity", notNullValue());
    }

    @Test
    @DisplayName("Should return 404 for non-existent product")
    public void testGetProductByIdNotFound() {
        given()
            .when()
                .get("/inventory/999")
            .then()
                .statusCode(404);
    }

    @Test
    @DisplayName("Should check product availability successfully")
    public void testCheckAvailability() {
        given()
            .queryParam("quantity", 5)
            .when()
                .get("/inventory/1/check")
            .then()
                .statusCode(200)
                .body(is("true"));
    }

    @Test
    @DisplayName("Should return false when checking unavailable quantity")
    public void testCheckAvailabilityInsufficient() {
        given()
            .queryParam("quantity", 999999)
            .when()
                .get("/inventory/1/check")
            .then()
                .statusCode(200)
                .body(is("false"));
    }

    @Test
    @DisplayName("Should reserve product successfully")
    public void testReserveProduct() {
        given()
            .queryParam("quantity", 1)
            .when()
                .post("/inventory/1/reserve")
            .then()
                .statusCode(200);
    }

    @Test
    @DisplayName("Should fail to reserve with insufficient quantity")
    public void testReserveProductInsufficientQuantity() {
        given()
            .queryParam("quantity", 999999)
            .when()
                .post("/inventory/1/reserve")
            .then()
                .statusCode(400);
    }

    @Test
    @DisplayName("Should fail to reserve non-existent product")
    public void testReserveNonExistentProduct() {
        given()
            .queryParam("quantity", 1)
            .when()
                .post("/inventory/999/reserve")
            .then()
                .statusCode(404);
    }

    @Test
    @DisplayName("Should handle missing quantity parameter")
    public void testReserveWithoutQuantity() {
        given()
            .when()
                .post("/inventory/1/reserve")
            .then()
                .statusCode(400);
    }

    @Test
    @DisplayName("Should handle invalid product ID")
    public void testGetProductWithInvalidId() {
        given()
            .when()
                .get("/inventory/invalid")
            .then()
                .statusCode(404);
    }

    @Test
    @DisplayName("Should return correct product details")
    public void testProductDetails() {
        given()
            .when()
                .get("/inventory/1")
            .then()
                .statusCode(200)
                .body("id", is(1))
                .body("name", is("Laptop"))
                .body("quantity", notNullValue());
    }
}

