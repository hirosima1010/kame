package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.AppUser;
import util.DBManager;

public class UserDAO {
    
    public AppUser findUser(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password_hash = ?";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                AppUser user = new AppUser();
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                return user; 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}