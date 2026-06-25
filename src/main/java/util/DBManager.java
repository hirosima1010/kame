// DB接続などの共通処理
package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBManager {
    // データベース接続情報
    private static final String URL = "jdbc:postgresql://localhost:5432/kame";
    private static final String USER = "postgres"; // 必要に応じて環境に合わせて変更してください
    private static final String PASS = "post"; // 設定したパスワード

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL JDBC Driverが見つかりません", e);
        }
        
        // ★ここを追加：コンソールにURLを表示する
        System.out.println("★接続先URL: " + URL);
        
        return DriverManager.getConnection(URL, USER, PASS);
    }
}