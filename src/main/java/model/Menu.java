package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Menu implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String menuName;
    private String kanaName;
    private int price;
    private String category;
    private String description;
    private String imagePath;
    private boolean isAvailable;
    private boolean isRecommend;
    private boolean isLimited;
    private String allergyInfo;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // コンストラクタ
    public Menu() {}

    // ゲッターとセッター
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getMenuName() { return menuName; }
    public void setMenuName(String menuName) { this.menuName = menuName; }

    public String getKanaName() { return kanaName; }
    public void setKanaName(String kanaName) { this.kanaName = kanaName; }

    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean isAvailable) { this.isAvailable = isAvailable; }

    public boolean isRecommend() { return isRecommend; }
    public void setRecommend(boolean isRecommend) { this.isRecommend = isRecommend; }

    public boolean isLimited() { return isLimited; }
    public void setLimited(boolean isLimited) { this.isLimited = isLimited; }

    public String getAllergyInfo() { return allergyInfo; }
    public void setAllergyInfo(String allergyInfo) { this.allergyInfo = allergyInfo; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}