package model;

import java.sql.Timestamp;

public class Order {
    private int orderId;
    private int userId;
    private String orderType; // 'workout', 'course', 'coach'
    private Integer itemId;
    private String itemName;
    private double price;
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private String paymentMethod;
    private String status; // 'pending', 'completed', 'cancelled'
    private Timestamp orderDate;

    public Order() {}

    public Order(int orderId, int userId, String orderType, Integer itemId, String itemName, 
                 double price, String fullName, String email, String phone, String address, 
                 String paymentMethod, String status, Timestamp orderDate) {
        this.orderId = orderId;
        this.userId = userId;
        this.orderType = orderType;
        this.itemId = itemId;
        this.itemName = itemName;
        this.price = price;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.orderDate = orderDate;
    }

    // Getters and Setters
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getOrderType() { return orderType; }
    public void setOrderType(String orderType) { this.orderType = orderType; }

    public Integer getItemId() { return itemId; }
    public void setItemId(Integer itemId) { this.itemId = itemId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
}

