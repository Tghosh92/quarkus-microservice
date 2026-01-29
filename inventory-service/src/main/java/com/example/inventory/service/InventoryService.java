package com.example.inventory.service;

import com.example.inventory.model.Product;
import jakarta.enterprise.context.ApplicationScoped;
import org.jboss.logging.Logger;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@ApplicationScoped
public class InventoryService {

    private static final Logger LOG = Logger.getLogger(InventoryService.class);

    private final Map<Long, Product> inventory = new HashMap<>();

    public InventoryService() {
        LOG.info("🏗️ Initializing InventoryService");
        // Initialize with some sample data
        inventory.put(1L, new Product(1L, "Laptop", 10));
        inventory.put(2L, new Product(2L, "Mouse", 50));
        inventory.put(3L, new Product(3L, "Keyboard", 30));
        LOG.infof("✅ InventoryService initialized with %d products", inventory.size());
    }

    public List<Product> getAllProducts() {
        LOG.debug("Fetching all products from inventory");
        return inventory.values().stream().toList();
    }

    public Product getProduct(Long id) {
        LOG.debugf("Looking up product with ID: %d", id);
        Product product = inventory.get(id);
        if (product == null) {
            LOG.debugf("Product with ID %d not found in inventory", id);
        }
        return product;
    }

    public boolean checkAvailability(Long productId, int quantity) {
        LOG.debugf("Checking availability - Product: %d, Requested: %d", (Object) productId, (Object) quantity);
        Product product = inventory.get(productId);

        if (product == null) {
            LOG.debugf("Product %d not found", productId);
            return false;
        }

        boolean available = product.getQuantity() >= quantity;
        LOG.debugf("Product %d availability: %b (available: %d, requested: %d)",
                  (Object) productId, (Object) available, (Object) product.getQuantity(), (Object) quantity);
        return available;
    }

    public boolean reserveProduct(Long productId, int quantity) {
        LOG.debugf("🔄 Attempting to reserve - Product: %d, Quantity: %d", (Object) productId, (Object) quantity);

        Product product = inventory.get(productId);
        if (product == null) {
            LOG.warnf("Cannot reserve - Product %d not found", productId);
            return false;
        }

        if (product.getQuantity() >= quantity) {
            int oldQuantity = product.getQuantity();
            product.setQuantity(oldQuantity - quantity);
            LOG.infof("✅ Reserved %d units of product %d (Before: %d, After: %d)",
                     (Object) quantity, (Object) productId, (Object) oldQuantity, (Object) product.getQuantity());
            return true;
        }

        LOG.warnf("⚠️ Insufficient stock for product %d (Available: %d, Requested: %d)",
                 (Object) productId, (Object) product.getQuantity(), (Object) quantity);
        return false;
    }
}

