package model;

import java.io.Serializable;
import java.sql.Date; // 日付型用

public class AppUser implements Serializable {
    private static final long serialVersionUID = 1L;

    // 1. ログイン・権限
    private int userId;
    private String username;
    private String password;
    private String role;
    private boolean isActive;

    // 2. 基本プロファイル
    private String fullName;
    private String kanaName;
    private String gender;
    private Date birthDate; // java.sql.Date を使用

    // 3. 連絡先・住所
    private String phone;
    private String email;
    private String postalCode;
    private String address;

    // 4. 給与・契約
    private int hourlyWage;
    private int transportationFee;
    private String bankName;
    private String bankBranch;
    private String accountNumber;

    // 5. 人事管理
    private Date hireDate;

    // デフォルトコンストラクタ
    public AppUser() {}

    // --- ここから下は Getter と Setter ---
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getKanaName() { return kanaName; }
    public void setKanaName(String kanaName) { this.kanaName = kanaName; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public Date getBirthDate() { return birthDate; }
    public void setBirthDate(Date birthDate) { this.birthDate = birthDate; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public int getHourlyWage() { return hourlyWage; }
    public void setHourlyWage(int hourlyWage) { this.hourlyWage = hourlyWage; }

    public int getTransportationFee() { return transportationFee; }
    public void setTransportationFee(int transportationFee) { this.transportationFee = transportationFee; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getBankBranch() { return bankBranch; }
    public void setBankBranch(String bankBranch) { this.bankBranch = bankBranch; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }

    public Date getHireDate() { return hireDate; }
    public void setHireDate(Date hireDate) { this.hireDate = hireDate; }
}