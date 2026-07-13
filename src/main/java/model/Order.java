package model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;

public class Order implements Serializable {
    private int orderId;
    private String staffName;
    private String eatStyle;
    private boolean myKameShell;
    private int totalPrice;
    private String receiptName;
    private Timestamp orderDate;
    private List<OrderDetail> details; // この注文に紐づく明細リスト
    private String ageGroup;           // 💡 追加：年齢層

    // コンストラクタ
    public Order() {}
    
    public Order(int orderId, String staffName, String eatStyle, boolean myKameShell, int totalPrice, String receiptName, Timestamp orderDate) {
        this.orderId = orderId;
        this.staffName = staffName;
        this.eatStyle = eatStyle;
        this.myKameShell = myKameShell;
        this.totalPrice = totalPrice;
        this.receiptName = receiptName;
        this.orderDate = orderDate;
    }

    // ゲッター・セッター
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }
    public String getEatStyle() { return eatStyle; }
    public void setEatStyle(String eatStyle) { this.eatStyle = eatStyle; }
    public boolean isMyKameShell() { return myKameShell; }
    public void setMyKameShell(boolean myKameShell) { this.myKameShell = myKameShell; }
    public int getTotalPrice() { return totalPrice; }
    public void setTotalPrice(int totalPrice) { this.totalPrice = totalPrice; }
    public String getReceiptName() { return receiptName; }
    public void setReceiptName(String receiptName) { this.receiptName = receiptName; }
    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
    public List<OrderDetail> getDetails() { return details; }
    public void setDetails(List<OrderDetail> details) { this.details = details; }
    
    // 💡 追加：ageGroup のゲッター・セッター
    public String getAgeGroup() { return ageGroup; }
    public void setAgeGroup(String ageGroup) { this.ageGroup = ageGroup; }
}