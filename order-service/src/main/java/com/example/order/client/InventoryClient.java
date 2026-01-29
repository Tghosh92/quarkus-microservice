package com.example.order.client;

import com.example.order.model.Product;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

@Path("/inventory")
@RegisterRestClient(configKey = "inventory-api")
public interface InventoryClient {

    @GET
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    Product getProduct(@PathParam("id") Long id);

    @GET
    @Path("/{id}/check")
    @Produces(MediaType.APPLICATION_JSON)
    AvailabilityResponse checkAvailability(@PathParam("id") Long id, @QueryParam("quantity") int quantity);

    @POST
    @Path("/{id}/reserve")
    @Produces(MediaType.APPLICATION_JSON)
    ReservationResponse reserveProduct(@PathParam("id") Long id, @QueryParam("quantity") int quantity);

    class AvailabilityResponse {
        public boolean available;

        public AvailabilityResponse() {
        }

        public AvailabilityResponse(boolean available) {
            this.available = available;
        }
    }

    class ReservationResponse {
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

