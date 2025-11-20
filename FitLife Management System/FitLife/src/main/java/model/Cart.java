package model;

import java.sql.Timestamp;

public class Cart {
    private int cartId;
    private int userId;
    private String itemType; // 'workout', 'coach', hoặc 'course'
    private int itemId; // workout_id, coach_id, hoặc course_id
    private int quantity;
    private double price;
    private double totalAmount;
    private String status; // 'pending', 'completed', 'cancelled'
    private Timestamp addedDate;

    public Cart() {}

    public Cart(int cartId, int userId, String itemType, int itemId, int quantity, 
                double price, double totalAmount, String status, Timestamp addedDate) {
        this.cartId = cartId;
        this.userId = userId;
        this.itemType = itemType;
        this.itemId = itemId;
        this.quantity = quantity;
        this.price = price;
        this.totalAmount = totalAmount;
        this.status = status;
        this.addedDate = addedDate;
    }

    // Getters and Setters
    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getAddedDate() {
        return addedDate;
    }

    public void setAddedDate(Timestamp addedDate) {
        this.addedDate = addedDate;
    }
}







