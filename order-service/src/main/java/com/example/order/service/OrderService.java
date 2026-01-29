package com.example.order.service;

import com.example.order.client.InventoryClient;
import com.example.order.model.Order;
import com.example.order.model.Product;
import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.rest.client.inject.RestClient;
import org.jboss.logging.Logger;
import jakarta.inject.Inject;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

@ApplicationScoped
public class OrderService {

    private static final Logger LOG = Logger.getLogger(OrderService.class);

    @Inject
    @RestClient
    InventoryClient inventoryClient;

    private final List<Order> orders = new ArrayList<>();
    private final AtomicLong orderIdCounter = new AtomicLong(1);

    public OrderService() {
        LOG.info("🏗️ OrderService initialized");
    }

    public Order createOrder(Long productId, int quantity) {
        LOG.infof("🔄 Creating order - Product: %d, Quantity: %d", productId, quantity);

        try {
            // Check product availability from inventory service
            LOG.debugf("Checking availability for product %d", productId);
            InventoryClient.AvailabilityResponse availability =
                inventoryClient.checkAvailability(productId, quantity);

            if (!availability.available) {
                LOG.warnf("⚠️ Product %d not available for quantity %d", productId, quantity);
                return createFailedOrder(productId, "Unknown", quantity, "Product not available");
            }

            LOG.debugf("✅ Product %d is available", productId);

            // Get product details
            LOG.debugf("Fetching product details for %d", productId);
            Product product = inventoryClient.getProduct(productId);
            LOG.debugf("Product details: Name=%s", product.getName());

            // Reserve the product
            LOG.debugf("Reserving %d units of product %d", quantity, productId);
            InventoryClient.ReservationResponse reservation =
                inventoryClient.reserveProduct(productId, quantity);

            if (reservation.success) {
                Order order = new Order(
                    orderIdCounter.getAndIncrement(),
                    productId,
                    product.getName(),
                    quantity,
                    "CONFIRMED"
                );
                orders.add(order);
                LOG.infof("✅ Order created successfully - ID: %d, Product: %s, Quantity: %d",
                         order.getId(), product.getName(), quantity);
                return order;
            } else {
                LOG.warnf("⚠️ Failed to reserve product %d - %s", productId, reservation.message);
                return createFailedOrder(productId, product.getName(), quantity, "Failed to reserve product");
            }
        } catch (Exception e) {
            LOG.errorf(e, "❌ Error creating order for product %d", productId);
            return createFailedOrder(productId, "Unknown", quantity,
                "Error communicating with inventory service: " + e.getMessage());
        }
    }

    private Order createFailedOrder(Long productId, String productName, int quantity, String reason) {
        LOG.warnf("⚠️ Creating failed order - Product: %d, Reason: %s", productId, reason);
        Order order = new Order(
            orderIdCounter.getAndIncrement(),
            productId,
            productName,
            quantity,
            "FAILED: " + reason
        );
        orders.add(order);
        return order;
    }

    public List<Order> getAllOrders() {
        LOG.debugf("Fetching all orders (total: %d)", orders.size());
        return new ArrayList<>(orders);
    }

    public Order getOrder(Long orderId) {
        LOG.debugf("Looking up order with ID: %d", orderId);
        Order order = orders.stream()
            .filter(o -> o.getId().equals(orderId))
            .findFirst()
            .orElse(null);

        if (order == null) {
            LOG.debugf("Order with ID %d not found", orderId);
        }

        return order;
    }
}

