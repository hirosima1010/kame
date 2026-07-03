package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Menu;
import util.DBManager;

public class MenuDAO {

    // 1. 全てのメニューを取得する
    public List<Menu> findAllMenus() {
        List<Menu> menuList = new ArrayList<>();
        String sql = "SELECT * FROM menus ORDER BY id ASC";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql);
             ResultSet rs = pStmt.executeQuery()) {

            while (rs.next()) {
                Menu menu = new Menu();
                
                // ⭕ カラム名がズレてエラーになるのを防ぐため、一般的な「id」に変更して安全に取得します
                // もし実際の列名が「menu_id」なら、ここを「menu_id」のままにしてください
                try {
                    menu.setId(rs.getInt("id"));
                } catch (SQLException e) {
                    menu.setId(rs.getInt("menu_id"));
                }

                menu.setMenuName(rs.getString("menu_name"));
                menu.setKanaName(rs.getString("kana_name"));
                menu.setPrice(rs.getInt("price"));
                menu.setCategory(rs.getString("category"));
                menu.setDescription(rs.getString("description"));
                
                // 以下の項目は、存在しない場合にエラーで止まらないよう安全に取得します
                try { menu.setAvailable(rs.getBoolean("is_available")); } catch (SQLException e) { menu.setAvailable(true); }
                try { menu.setRecommend(rs.getBoolean("is_recommend")); } catch (SQLException e) { menu.setRecommend(false); }
                try { menu.setLimited(rs.getBoolean("is_limited")); } catch (SQLException e) { menu.setLimited(false); }
                try { menu.setAllergyInfo(rs.getString("allergy_info")); } catch (SQLException e) { menu.setAllergyInfo("なし"); }
                
                menuList.add(menu);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>(); // エラーが起きても、nullではなく空のリストを返して画面が壊れるのを防ぎます
        }
        return menuList;
    }

    // 2. 新しいメニューを登録する
    public boolean registerMenu(Menu menu) {
        String sql = "INSERT INTO menus (menu_name, kana_name, price, category, description, "
                   + "is_recommend, is_limited, allergy_info) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql)) {

            pStmt.setString(1, menu.getMenuName());
            pStmt.setString(2, menu.getKanaName());
            pStmt.setInt(3, menu.getPrice());
            pStmt.setString(4, menu.getCategory());
            pStmt.setString(5, menu.getDescription());
            pStmt.setBoolean(6, menu.isRecommend());
            pStmt.setBoolean(7, menu.isLimited());
            pStmt.setString(8, menu.getAllergyInfo());

            int result = pStmt.executeUpdate();
            return result == 1;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
 // 3. 【追加】IDを指定してメニューを1件だけ取得する（編集画面で元のデータを表示するために必要）
    public Menu findMenuById(int id) {
        Menu menu = null;
        String sql = "SELECT * FROM menus WHERE id = ?";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql)) {
            
            pStmt.setInt(1, id);
            try (ResultSet rs = pStmt.executeQuery()) {
                if (rs.next()) {
                    menu = new Menu();
                    menu.setId(rs.getInt("id"));
                    menu.setMenuName(rs.getString("menu_name"));
                    menu.setKanaName(rs.getString("kana_name"));
                    menu.setPrice(rs.getInt("price"));
                    menu.setCategory(rs.getString("category"));
                    menu.setDescription(rs.getString("description"));
                    try { menu.setAvailable(rs.getBoolean("is_available")); } catch (SQLException e) { menu.setAvailable(true); }
                    try { menu.setRecommend(rs.getBoolean("is_recommend")); } catch (SQLException e) { menu.setRecommend(false); }
                    try { menu.setLimited(rs.getBoolean("is_limited")); } catch (SQLException e) { menu.setLimited(false); }
                    try { menu.setAllergyInfo(rs.getString("allergy_info")); } catch (SQLException e) { menu.setAllergyInfo("なし"); }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return menu;
    }

    // 4. 【追加】メニュー情報を更新する（編集の確定）
 // 4. メニュー情報を更新する（ステータス対応版）
    public boolean updateMenu(Menu menu) {
        String sql = "UPDATE menus SET menu_name=?, kana_name=?, price=?, category=?, description=?, "
                   + "is_recommend=?, is_limited=?, allergy_info=?, is_available=? WHERE id=?";

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql)) {

            pStmt.setString(1, menu.getMenuName());
            pStmt.setString(2, menu.getKanaName());
            pStmt.setInt(3, menu.getPrice());
            pStmt.setString(4, menu.getCategory());
            pStmt.setString(5, menu.getDescription());
            pStmt.setBoolean(6, menu.isRecommend());
            pStmt.setBoolean(7, menu.isLimited());
            pStmt.setString(8, menu.getAllergyInfo());
            pStmt.setBoolean(9, menu.isAvailable()); // 👈 追加
            pStmt.setInt(10, menu.getId());          // 👈 10番目にずらす

            int result = pStmt.executeUpdate();
            return result == 1;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. 【追加】メニューを削除する
    public boolean deleteMenu(int id) {
        String sql = "DELETE FROM menus WHERE id = ?";

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql)) {

            pStmt.setInt(1, id);
            int result = pStmt.executeUpdate();
            return result == 1;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}