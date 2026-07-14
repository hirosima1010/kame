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

    // 1. 全員のシフトスケジュールを取得する（登録画面の下半分の一覧表示用など）
	// 1. 全員のシフトスケジュールを取得する（登録画面の下半分の一覧表示用など）
    public List<Shift> findAllShifts() {
        List<Shift> list = new ArrayList<>();
        // usersテーブルと結合して、スタッフの本名（full_name）も一緒に引っ張ってくる
        // 💡 s.startTime ASC だったバグを s.start_time ASC に修正しました！
        String sql = "SELECT s.*, u.full_name FROM shifts s " +
                "JOIN users u ON s.username = u.username " +
                "ORDER BY CAST(s.work_date AS DATE) ASC, s.start_time ASC";

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

    // 2. 特定のユーザーのシフト実績を、その人の「現在の登録時給」と一緒に取得する（給料明細用）
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
                    s.setHourlyWage(rs.getInt("hourly_wage")); // ここで登録時給をドッキング！
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. 新しいシフト情報をデータベースに登録するメソッド
    public boolean insertShift(Shift s) {
        String sql = "INSERT INTO shifts (username, work_date, start_time, end_time, break_minutes) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql)) {
            
            pStmt.setString(1, s.getUsername());
            pStmt.setDate(2, s.getWorkDate());
            pStmt.setTime(3, s.getStartTime());
            pStmt.setTime(4, s.getEndTime());
            pStmt.setInt(5, s.getBreakMinutes());
            
            int result = pStmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4. シフトを更新（UPDATE）するメソッド（💡バグをきれいに修正しました！）
    public boolean updateShift(Shift shift) {
        // 💡 WHERE句の対象を「id」に統一しています
        String sql = "UPDATE shifts SET work_date = ?, start_time = ?, end_time = ?, break_minutes = ? WHERE id = ?";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, shift.getWorkDate());
            ps.setTime(2, shift.getStartTime());
            ps.setTime(3, shift.getEndTime());
            ps.setInt(4, shift.getBreakMinutes());
            ps.setInt(5, shift.getId()); // 👈 Shift.javaの「getId()」を正しくセット！

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. シフトを物理削除（DELETE）するメソッド
    public boolean deleteShift(int id) {
        // 💡 WHERE句の対象を「id」に統一しています
        String sql = "DELETE FROM shifts WHERE id = ?";
        
        try (Connection conn = DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
 // 💡 ShiftDAO.java に追加してください
    public List<Shift> findShiftsByDate(java.sql.Date workDate) {
        List<Shift> list = new ArrayList<>();
        String sql = "SELECT s.*, u.full_name FROM shifts s "
                   + "JOIN users u ON s.username = u.username "
                   + "WHERE s.work_date = ? ORDER BY s.start_time ASC";

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql)) {
            pStmt.setDate(1, workDate);
            try (ResultSet rs = pStmt.executeQuery()) {
                while (rs.next()) {
                    Shift s = new Shift();
                    s.setId(rs.getInt("id"));
                    s.setUsername(rs.getString("username"));
                    s.setStaffFullName(rs.getString("full_name"));
                    s.setStartTime(rs.getTime("start_time"));
                    s.setEndTime(rs.getTime("end_time"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
 // 💡 損益画面連携用：指定された期間内に発生した全スタッフの「総人件費（時給×実働時間）」を計算する
    public int getTotalLaborCost(java.sql.Date startDate, java.sql.Date endDate) {
        int totalLaborCost = 0;
        
        // シフトデータとユーザーデータを結合し、指定期間内のデータを取得
        String sql = "SELECT s.start_time, s.end_time, s.break_minutes, u.hourly_wage "
                   + "FROM shifts s "
                   + "JOIN users u ON s.username = u.username "
                   + "WHERE s.work_date BETWEEN ? AND ?";

        try (Connection conn = util.DBManager.getConnection();
             PreparedStatement pStmt = conn.prepareStatement(sql)) {
            
            pStmt.setDate(1, startDate);
            pStmt.setDate(2, endDate);
            
            try (ResultSet rs = pStmt.executeQuery()) {
                while (rs.next()) {
                    java.sql.Time startTime = rs.getTime("start_time");
                    java.sql.Time endTime = rs.getTime("end_time");
                    int breakMinutes = rs.getInt("break_minutes");
                    int hourlyWage = rs.getInt("hourly_wage");
                    
                    if (startTime != null && endTime != null) {
                        // ミリ秒単位で勤務時間を計算
                        long diffMillis = endTime.getTime() - startTime.getTime();
                        
                        // 日またぎシフトの簡易考慮（終了が開始より前なら24時間足す）
                        if (diffMillis <= 0) {
                            diffMillis += 24 * 60 * 60 * 1000;
                        }
                        
                        // 実働時間（分）＝ 総勤務時間（分） - 休憩（分）
                        double workingMinutes = (diffMillis / (1000 * 60)) - breakMinutes;
                        
                        if (workingMinutes > 0) {
                            double workingHours = workingMinutes / 60.0;
                            // このシフト1件分の人件費を計算して加算
                            totalLaborCost += (int) Math.round(workingHours * hourlyWage);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return totalLaborCost;
    }
}