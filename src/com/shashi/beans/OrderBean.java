package com.shashi.beans;

import java.io.Serializable;

@SuppressWarnings("serial")
public class OrderBean implements Serializable {

    private String transactionId;
    private String productId;
    private int quantity;
    private Double amount;       // final amount (including delivery if applied)
    private int shipped;
    private String postalCode;
    private String deliveryAddress;

    // NEW: delivery fee (can be null if not set)
    private Double deliveryFee;

    public OrderBean() {
        super();
        this.shipped = 0;
        this.deliveryFee = 0.0; // default
    }

    public OrderBean(String transactionId, String productId, int quantity, Double amount) {
        super();
        this.transactionId = transactionId;
        this.productId = productId;
        this.quantity = quantity;
        this.amount = amount;
        this.shipped = 0;
        this.deliveryFee = 0.0; // default
    }

    public OrderBean(String transactionId, String productId, int quantity, Double amount, int shipped) {
        super();
        this.transactionId = transactionId;
        this.productId = productId;
        this.quantity = quantity;
        this.amount = amount;
        this.shipped = shipped;
        this.deliveryFee = 0.0; // default
    }

    // OPTIONAL overloads (don’t remove the originals)
    public OrderBean(String transactionId, String productId, int quantity, Double amount, Double deliveryFee) {
        this(transactionId, productId, quantity, amount);
        this.deliveryFee = deliveryFee;
    }

    public OrderBean(String transactionId, String productId, int quantity, Double amount, int shipped, Double deliveryFee) {
        this(transactionId, productId, quantity, amount, shipped);
        this.deliveryFee = deliveryFee;
    }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }

    public int getShipped() { return shipped; }
    public void setShipped(int shipped) { this.shipped = shipped; }

    // NEW getter/setter
    public Double getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(Double deliveryFee) { this.deliveryFee = deliveryFee; }
    
    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }
}