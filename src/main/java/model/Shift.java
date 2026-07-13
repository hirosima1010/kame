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
    private String staffFullName;
    private int hourlyWage;

    public Shift() {}

    // ゲッター・セッター（省略せず実装してください）
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

    // 実働時間計算ロジック
    public double getWorkingHours() {
        if (startTime == null || endTime == null) return 0.0;
        // getTime()はミリ秒を返す
        long diff = endTime.getTime() - startTime.getTime();
        double hours = (double) diff / (1000 * 60 * 60);
        double breakH = (double) breakMinutes / 60;
        return Math.max(0.0, hours - breakH);
    }
}