package com.example.inventory.resource;

import com.example.inventory.model.Product;
import com.example.inventory.service.InventoryService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.jboss.logging.Logger;
import java.util.List;

@Path("/inventory")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class InventoryResource {

    private static final Logger LOG = Logger.getLogger(InventoryResource.class);

    @Inject
    InventoryService inventoryService;

    @GET
    public List<Product> getAllProducts() {
        LOG.info("📋 Fetching all products");
        List<Product> products = inventoryService.getAllProducts();
        LOG.infof("✅ Retrieved %d products", products.size());
        return products;
    }

    @GET
    @Path("/{id}")
    public Response getProduct(@PathParam("id") Long id) {
        LOG.infof("🔍 Fetching product with ID: %d", id);
        Product product = inventoryService.getProduct(id);
        if (product != null) {
            LOG.debugf("Found product: %s (quantity: %d)", product.getName(), product.getQuantity());
            return Response.ok(product).build();
        }
        LOG.warnf("⚠️ Product not found with ID: %d", id);
        return Response.status(Response.Status.NOT_FOUND).build();
    }

    @GET
    @Path("/{id}/check")
    public Response checkAvailability(@PathParam("id") Long id, @QueryParam("quantity") int quantity) {
        LOG.infof("🔎 Checking availability - Product ID: %d, Quantity: %d", id, quantity);
        boolean available = inventoryService.checkAvailability(id, quantity);
        LOG.debugf("Availability check result: %b", available);
        return Response.ok(new AvailabilityResponse(available)).build();
    }

    @POST
    @Path("/{id}/reserve")
    public Response reserveProduct(@PathParam("id") Long id, @QueryParam("quantity") int quantity) {
        LOG.infof("📦 Reserve request - Product ID: %d, Quantity: %d", id, quantity);

        try {
            boolean reserved = inventoryService.reserveProduct(id, quantity);
            if (reserved) {
                LOG.infof("✅ Successfully reserved %d units of product %d", quantity, id);
                return Response.ok(new ReservationResponse(true, "Product reserved successfully")).build();
            }
            LOG.warnf("⚠️ Failed to reserve product %d - Insufficient quantity or not found", id);
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ReservationResponse(false, "Insufficient quantity or product not found"))
                    .build();
        } catch (Exception e) {
            LOG.errorf(e, "❌ Error reserving product %d", id);
            return Response.serverError()
                    .entity(new ReservationResponse(false, "Internal server error"))
                    .build();
        }
    }

    public static class AvailabilityResponse {
        public boolean available;

        public AvailabilityResponse() {
        }

        public AvailabilityResponse(boolean available) {
            this.available = available;
        }
    }

    public static class ReservationResponse {
        public boolean success;
        public String message;

        public ReservationResponse() {
        }

        public ReservationResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }
}

