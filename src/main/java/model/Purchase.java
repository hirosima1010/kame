package model;

import java.io.Serializable;
import java.util.Date;

public class Purchase implements Serializable {
    private static final long serialVersionUID = 1L;

    private int purchaseId;
    private String itemName;
    private int quantity;
    private int price;
    private Date purchaseDate;
    private String staffName;

    public Purchase() {}

    public Purchase(int purchaseId, String itemName, int quantity, int price, Date purchaseDate, String staffName) {
        this.purchaseId = purchaseId;
        this.itemName = itemName;
        this.quantity = quantity;
        this.price = price;
        this.purchaseDate = purchaseDate;
        this.staffName = staffName;
    }

    // ゲッターとセッター
    public int getPurchaseId() { return purchaseId; }
    public void setPurchaseId(int purchaseId) { this.purchaseId = purchaseId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public Date getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(Date purchaseDate) { this.purchaseDate = purchaseDate; }

    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }
}