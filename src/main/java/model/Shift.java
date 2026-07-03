package model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Time;

public class Shift implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String username;
    private Date workDate;
    private Time startTime;
    private Time endTime;
    private int breakMinutes;

    // 給料明細の自動計算で使うための拡張フィールド（DBのテーブルには直接ない、計算用の一時データ）
    private String staffFullName; // スタッフの本名表示用
    private int hourlyWage;       // その時の時給

    public Shift() {}

    // ゲッターとセッター
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public Date getWorkDate() { return workDate; }
    public void setWorkDate(Date workDate) { this.workDate = workDate; }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }

    public int getBreakMinutes() { return breakMinutes; }
    public void setBreakMinutes(int breakMinutes) { this.breakMinutes = breakMinutes; }

    public String getStaffFullName() { return staffFullName; }
    public void setStaffFullName(String staffFullName) { this.staffFullName = staffFullName; }

    public int getHourlyWage() { return hourlyWage; }
    public void setHourlyWage(int hourlyWage) { this.hourlyWage = hourlyWage; }

    // 💡 実働時間を「時間（hours）」で計算する便利メソッド
    public double getWorkingHours() {
        if (startTime == null || endTime == null) return 0;
        long diff = endTime.getTime() - startTime.getTime(); // ミリ秒単位の差
        double diffHours = (double) diff / (1000 * 60 * 60); // 時間に変換
        double breakHours = (double) breakMinutes / 60;
        return Math.max(0, diffHours - breakHours);
    }
}