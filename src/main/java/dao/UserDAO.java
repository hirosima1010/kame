package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.AppUser;
import util.DBManager; // ※お使いの環境のDB接続クラス名に合わせてください（例: db.DBManager等）

public class UserDAO {

    // 1. 新しいスタッフをガチで登録するメソッド
    public boolean registerUser(AppUser user) {
        String sql = "INSERT INTO users ("
                   + "username, password, role, full_name, kana_name, gender, birth_date, "
                   + "phone, email, postal_code, address, hourly_wage, transportation_fee, "
                   + "bank_name, bank_branch, account_number"
                   + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getKanaName());
            ps.setString(6, user.getGender());
            ps.setDate(7, user.getBirthDate());
            ps.setString(8, user.getPhone());
            ps.setString(9, user.getEmail());
            ps.setString(10, user.getPostalCode());
            ps.setString(11, user.getAddress());
            ps.setInt(12, user.getHourlyWage());
            ps.setInt(13, user.getTransportationFee());
            ps.setString(14, user.getBankName());
            ps.setString(15, user.getBankBranch());
            ps.setString(16, user.getAccountNumber());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. 現在のスタッフ（在籍中のみ）を全員取得するメソッド
    public List<AppUser> findAllUsers() {
        List<AppUser> userList = new ArrayList<>();
        // 退職者（is_active = false）は除外して名前順に並べる
        String sql = "SELECT * FROM users WHERE is_active = true ORDER BY username ASC"; 
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                AppUser user = new AppUser();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                user.setFullName(rs.getString("full_name"));
                user.setKanaName(rs.getString("kana_name"));
                user.setGender(rs.getString("gender"));
                user.setBirthDate(rs.getDate("birth_date"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setPostalCode(rs.getString("postal_code"));
                user.setAddress(rs.getString("address"));
                user.setHourlyWage(rs.getInt("hourly_wage"));
                user.setTransportationFee(rs.getInt("transportation_fee"));
                user.setBankName(rs.getString("bank_name"));
                user.setBankBranch(rs.getString("bank_branch"));
                user.setAccountNumber(rs.getString("account_number"));
                user.setHireDate(rs.getDate("hire_date"));
                
                userList.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }
    
 // 3. 指定されたusernameのユーザー情報を1人分だけガッツリ取得するメソッド
    public AppUser findByUsername(String username) {
        AppUser user = null;
        String sql = "SELECT * FROM users WHERE username = ?";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new AppUser();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setActive(rs.getBoolean("is_active"));
                    user.setFullName(rs.getString("full_name"));
                    user.setKanaName(rs.getString("kana_name"));
                    user.setGender(rs.getString("gender"));
                    user.setBirthDate(rs.getDate("birth_date"));
                    user.setPhone(rs.getString("phone"));
                    user.setEmail(rs.getString("email"));
                    user.setPostalCode(rs.getString("postal_code"));
                    user.setAddress(rs.getString("address"));
                    user.setHourlyWage(rs.getInt("hourly_wage"));
                    user.setTransportationFee(rs.getInt("transportation_fee"));
                    user.setBankName(rs.getString("bank_name"));
                    user.setBankBranch(rs.getString("bank_branch"));
                    user.setAccountNumber(rs.getString("account_number"));
                    user.setHireDate(rs.getDate("hire_date"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // 4. 編集されたユーザー情報をデータベースに上書き（UPDATE）するメソッド
    public boolean updateUser(AppUser user) {
        String sql = "UPDATE users SET "
                   + "password = ?, role = ?, full_name = ?, kana_name = ?, gender = ?, birth_date = ?, "
                   + "phone = ?, email = ?, postal_code = ?, address = ?, hourly_wage = ?, transportation_fee = ?, "
                   + "bank_name = ?, bank_branch = ?, account_number = ? "
                   + "WHERE username = ?"; // usernameを基準に上書きする
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getPassword());
            ps.setString(2, user.getRole());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getKanaName());
            ps.setString(5, user.getGender());
            ps.setDate(6, user.getBirthDate());
            ps.setString(7, user.getPhone());
            ps.setString(8, user.getEmail());
            ps.setString(9, user.getPostalCode());
            ps.setString(10, user.getAddress());
            ps.setInt(11, user.getHourlyWage());
            ps.setInt(12, user.getTransportationFee());
            ps.setString(13, user.getBankName());
            ps.setString(14, user.getBankBranch());
            ps.setString(15, user.getAccountNumber());
            ps.setString(16, user.getUsername()); // WHERE句の ? に入る
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    // 5. 指定されたusernameのスタッフを退職（無効）扱いにするメソッド
    public boolean deleteUser(String username) {
        // 物理的に消すのではなく、在籍フラグ(is_active)を false に更新する
        String sql = "UPDATE users SET is_active = false WHERE username = ?";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
 // 6. 退職したスタッフ（is_active = false）だけを全員取得するメソッド
    public List<AppUser> findInactiveUsers() {
        List<AppUser> userList = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE is_active = false ORDER BY username ASC"; 
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                AppUser user = new AppUser();
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                userList.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }

    // 7. 指定されたusernameのスタッフを復元（在籍中に戻す）するメソッド
    public boolean reactivateUser(String username) {
        String sql = "UPDATE users SET is_active = true WHERE username = ?";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
 // 8. 追加：ログイン時にユーザーIDとパスワードで存在チェックをするメソッド
    public AppUser findUser(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND is_active = true";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AppUser user = new AppUser();
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setFullName(rs.getString("full_name"));
                    // 必要に応じて他の項目（値）もrsからセットしてください
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // 見つからなかったりエラーならnullを返す
    }
}