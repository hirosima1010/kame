package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Shift;
import util.DBManager;

public class ShiftDAO {

    // 1. 全員のシフトスケジュールを取得する（カレンダー表示用）
    public List<Shift> findAllShifts() {
        List<Shift> list = new ArrayList<>();
        // usersテーブルと結合して、スタッフの本名（full_name）も一緒に引っ張ってくる
        String sql = "SELECT s.*, u.full_name FROM shifts s "
                   + "JOIN users u ON s.username = u.username "
                   + "ORDER BY s.work_date ASC, s.start_time ASC";

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql);
             ResultSet rs = pStmt.executeQuery()) {

            while (rs.next()) {
                Shift s = new Shift();
                s.setId(rs.getInt("id"));
                s.setUsername(rs.getString("username"));
                s.setWorkDate(rs.getDate("work_date"));
                s.setStartTime(rs.getTime("start_time"));
                s.setEndTime(rs.getTime("end_time"));
                s.setBreakMinutes(rs.getInt("break_minutes"));
                s.setStaffFullName(rs.getString("full_name")); // 本名をセット
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. 特定のユーザーのシフト実績を、その人の「現在の登録時経」と一緒に取得する（給料明細用）
    public List<Shift> findShiftsByUsername(String username) {
        List<Shift> list = new ArrayList<>();
        // usersテーブルから、その人の時給（hourly_wage）や本名（full_name）も引っ張る
        String sql = "SELECT s.*, u.full_name, u.hourly_wage FROM shifts s "
                   + "JOIN users u ON s.username = u.username "
                   + "WHERE s.username = ? "
                   + "ORDER BY s.work_date DESC";

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql)) {
            
            pStmt.setString(1, username);
            try (ResultSet rs = pStmt.executeQuery()) {
                while (rs.next()) {
                    Shift s = new Shift();
                    s.setId(rs.getInt("id"));
                    s.setUsername(rs.getString("username"));
                    s.setWorkDate(rs.getDate("work_date"));
                    s.setStartTime(rs.getTime("start_time"));
                    s.setEndTime(rs.getTime("end_time"));
                    s.setBreakMinutes(rs.getInt("break_minutes"));
                    s.setStaffFullName(rs.getString("full_name"));
                    s.setHourlyWage(rs.getInt("hourly_wage")); // 👈 ここで登録時給をドッキング！
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    /**
     * 新しいシフト情報をデータベースに登録するメソッド
     * @param s 登録するシフトオブジェクト
     * @return 登録成功ならtrue、失敗ならfalse
     */
    public boolean insertShift(Shift s) {
        // SQLインジェクションを防ぐため、プレースホルダ（?）を使用
        String sql = "INSERT INTO shifts (username, work_date, start_time, end_time, break_minutes) VALUES (?, ?, ?, ?, ?)";
        
        // DBManagerのパッケージ名やクラス名は、プロジェクトの既存の定義に合わせてください（例: dao.DBManager など）
        try (java.sql.Connection conn = DBManager.getConnection();
             java.sql.PreparedStatement pStmt = conn.prepareStatement(sql)) {
            
            // プレースホルダに値をセット
            pStmt.setString(1, s.getUsername());
            pStmt.setDate(2, s.getWorkDate());
            pStmt.setTime(3, s.getStartTime());
            pStmt.setTime(4, s.getEndTime());
            pStmt.setInt(5, s.getBreakMinutes());
            
            // SQLを実行し、1件以上登録されたら成功(true)を返す
            int result = pStmt.executeUpdate();
            return result > 0;
            
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}