package model;

import java.io.Serializable;

public class OrderDetail implements Serializable {
    private int detailId;
    private int orderId;
    private String menuName;
    private int price;
    private int quantity;

    public OrderDetail() {}

    public OrderDetail(int detailId, int orderId, String menuName, int price, int quantity) {
        this.detailId = detailId;
        this.orderId = orderId;
        this.menuName = menuName;
        this.price = price;
        this.quantity = quantity;
    }

    // ゲッター・セッター
    public int getDetailId() { return detailId; }
    public void setDetailId(int detailId) { this.detailId = detailId; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public String getMenuName() { return menuName; }
    public void setMenuName(String menuName) { this.menuName = menuName; }
    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}