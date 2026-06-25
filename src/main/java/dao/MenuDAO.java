// データベース操作
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Menu;
import util.DBManager;

public class MenuDAO {
    
    public List<Menu> findAll() {
        List<Menu> menuList = new ArrayList<>();
        String sql = "SELECT id, name, price FROM menu";

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Menu menu = new Menu(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getInt("price")
                );
                menuList.add(menu);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return menuList;
    }
}