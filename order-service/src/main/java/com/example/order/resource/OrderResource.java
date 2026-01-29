package com.example.order.resource;

import com.example.order.model.Order;
import com.example.order.service.OrderService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.jboss.logging.Logger;
import java.util.List;

@Path("/orders")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class OrderResource {

    private static final Logger LOG = Logger.getLogger(OrderResource.class);

    @Inject
    OrderService orderService;

    @POST
    public Response createOrder(OrderRequest request) {
        LOG.infof("📝 Create order request - Product ID: %d, Quantity: %d",
                 request.productId, request.quantity);

        if (request.productId == null || request.quantity <= 0) {
            LOG.warnf("⚠️ Invalid order request - Product ID: %s, Quantity: %d",
                     request.productId, request.quantity);
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Invalid product ID or quantity"))
                .build();
        }

        try {
            Order order = orderService.createOrder(request.productId, request.quantity);
            LOG.infof("✅ Order created successfully - Order ID: %d, Product: %d, Quantity: %d",
                     order.getId(), order.getProductId(), order.getQuantity());
            return Response.status(Response.Status.CREATED).entity(order).build();
        } catch (Exception e) {
            LOG.errorf(e, "❌ Failed to create order - Product: %d, Quantity: %d",
                      request.productId, request.quantity);
            return Response.serverError()
                .entity(new ErrorResponse("Failed to create order: " + e.getMessage()))
                .build();
        }
    }

    @GET
    public List<Order> getAllOrders() {
        LOG.info("📋 Fetching all orders");
        List<Order> orders = orderService.getAllOrders();
        LOG.infof("✅ Retrieved %d orders", orders.size());
        return orders;
    }

    @GET
    @Path("/{id}")
    public Response getOrder(@PathParam("id") Long id) {
        LOG.infof("🔍 Fetching order with ID: %d", id);
        Order order = orderService.getOrder(id);
        if (order != null) {
            LOG.debugf("Found order: ID=%d, Product=%d, Quantity=%d, Status=%s",
                      order.getId(), order.getProductId(), order.getQuantity(), order.getStatus());
            return Response.ok(order).build();
        }
        LOG.warnf("⚠️ Order not found with ID: %d", id);
        return Response.status(Response.Status.NOT_FOUND).build();
    }

    public static class OrderRequest {
        public Long productId;
        public int quantity;

        public OrderRequest() {
        }

        public OrderRequest(Long productId, int quantity) {
            this.productId = productId;
            this.quantity = quantity;
        }
    }

    public static class ErrorResponse {
        public String error;

        public ErrorResponse() {
        }

        public ErrorResponse(String error) {
            this.error = error;
        }
    }
}

