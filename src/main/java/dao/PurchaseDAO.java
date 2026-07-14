package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Purchase;
import util.DBManager;

public class PurchaseDAO {

    private Connection getConnection() throws SQLException {
        return DBManager.getConnection();
    }

    // 💡 サーブレットの63行目から呼ばれる、引数が1つの登録メソッドカメ！
    public boolean insertPurchase(Purchase purchase) {
        String sql = "INSERT INTO purchases (item_name, quantity, price, purchase_date, staff_name) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql)) {
            
            pStmt.setString(1, purchase.getItemName());
            pStmt.setInt(2, purchase.getQuantity());
            pStmt.setInt(3, purchase.getPrice());
            
            java.util.Date pDate = purchase.getPurchaseDate();
            if (pDate == null) {
                pDate = new java.util.Date();
            }
            java.sql.Date sqlDate = new java.sql.Date(pDate.getTime());
            pStmt.setDate(4, sqlDate);
            
            String staffName = purchase.getStaffName();
            if (staffName == null || staffName.isEmpty()) {
                staffName = "未設定（システム）"; 
            }
            pStmt.setString(5, staffName);
            
            int result = pStmt.executeUpdate();
            return result > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 💡 全ての発注データを取得するメソッド（担当者名も取得）
    public List<Purchase> findAllPurchases() {
        List<Purchase> list = new ArrayList<>();
        String sql = "SELECT * FROM purchases ORDER BY purchase_date DESC, purchase_id DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql);
             ResultSet rs = pStmt.executeQuery()) {
            
            while (rs.next()) {
                Purchase p = new Purchase();
                p.setPurchaseId(rs.getInt("purchase_id"));
                p.setItemName(rs.getString("item_name"));
                p.setQuantity(rs.getInt("quantity"));
                p.setPrice(rs.getInt("price"));
                p.setPurchaseDate(rs.getDate("purchase_date"));
                p.setStaffName(rs.getString("staff_name")); // 担当者名を取得
                
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 💡 指定された期間内の合計仕入れ金額を計算するメソッド
    public int getTotalPurchaseAmount(java.sql.Date startDate, java.sql.Date endDate) {
        int total = 0;
        String sql = "SELECT SUM(quantity * price) AS total_amount FROM purchases WHERE purchase_date BETWEEN ? AND ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql)) {
            
            pStmt.setDate(1, startDate);
            pStmt.setDate(2, endDate);
            
            try (ResultSet rs = pStmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("total_amount");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
}