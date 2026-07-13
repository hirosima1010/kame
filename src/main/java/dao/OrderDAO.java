package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Order;
import model.OrderDetail;
import util.DBManager; // 💡 MenuDAOと同じDBManagerをインポート！

public class OrderDAO {

    /**
     * 🛒 注文情報と明細情報をまとめてデータベースに保存する（トランザクション処理）
     */
    public boolean insertOrder(Order order) {
        String insertOrderSql = "INSERT INTO orders (staff_name, eat_style, my_kame_shell, total_price, receipt_name) VALUES (?, ?, ?, ?, ?)";
        String insertDetailSql = "INSERT INTO order_details (order_id, menu_name, price, quantity) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet rs = null;

        try {
            // MenuDAOと同じく、共通の管理クラスから接続を取得
            conn = DBManager.getConnection();
            
            // 💡 トランザクション開始（親と子のインサートを「一蓮托生」にする）
            conn.setAutoCommit(false);

            // 1. 親テーブル(orders)に保存。同時に、自動生成されたorder_idを取得する
            psOrder = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, order.getStaffName());
            psOrder.setString(2, order.getEatStyle());
            psOrder.setBoolean(3, order.isMyKameShell());
            psOrder.setInt(4, order.getTotalPrice());
            psOrder.setString(5, order.getReceiptName());
            psOrder.executeUpdate();

            // 生成されたばかりの order_id を取り出す
            int generatedOrderId = -1;
            rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                generatedOrderId = rs.getInt(1);
            }

            // 2. 子テーブル(order_details)に注文商品をすべてループで保存
            if (generatedOrderId != -1 && order.getDetails() != null) {
                psDetail = conn.prepareStatement(insertDetailSql);
                for (OrderDetail detail : order.getDetails()) {
                    psDetail.setInt(1, generatedOrderId); // 親のIDをここで紐付け！
                    psDetail.setString(2, detail.getMenuName());
                    psDetail.setInt(3, detail.getPrice());
                    psDetail.setInt(4, detail.getQuantity());
                    psDetail.addBatch(); // メモリにためる
                }
                psDetail.executeBatch(); // まとめてデータベースにドカン！
            }

            // ここまで全部無事に行ったら、データを確定（コミット）
            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            // 💡 どこかで失敗したら、すべての操作をなかったことにして巻き戻す（ロールバック）
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException se) { se.printStackTrace(); }
            }
            return false;
        } finally {
            // 安全確実にお片付け（クローズ処理）
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (psOrder != null) psOrder.close(); } catch (SQLException e) {}
            try { if (psDetail != null) psDetail.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }

    /**
     * 📜 過去の注文履歴をすべて取得する（新しい順）
     */
    public List<Order> findAllOrders() {
        List<Order> orderList = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";

        // MenuDAOと同じく、try-with-resources で安全に接続
        try (Connection conn = DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setStaffName(rs.getString("staff_name"));
                order.setEatStyle(rs.getString("eat_style"));
                order.setMyKameShell(rs.getBoolean("my_kame_shell"));
                order.setTotalPrice(rs.getInt("total_price"));
                order.setReceiptName(rs.getString("receipt_name"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                
                // この注文に紐づいている商品明細も一緒に引っ張ってきてセットする！
                order.setDetails(findDetailsByOrderId(order.getOrderId(), conn));
                
                orderList.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>(); // エラー時は空リストを返して画面崩れを防ぐ
        }
        return orderList;
    }

    /**
     * 📝 注文IDに紐づく明細一覧を取得する（内部用のヘルパーメソッド）
     */
    private List<OrderDetail> findDetailsByOrderId(int orderId, Connection conn) throws SQLException {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT * FROM order_details WHERE order_id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail detail = new OrderDetail();
                    detail.setDetailId(rs.getInt("detail_id"));
                    detail.setOrderId(rs.getInt("order_id"));
                    detail.setMenuName(rs.getString("menu_name"));
                    detail.setPrice(rs.getInt("price"));
                    detail.setQuantity(rs.getInt("quantity"));
                    details.add(detail);
                }
            }
        }
        return details;
    }
    /**
     * 📅 【期間別】売上ランキングを取得する
     * periodType: "DAY" (今日), "MONTH" (今月), "YEAR" (今年)
     */
    public List<String[]> findMenuRankingByPeriod(String periodType) {
        List<String[]> ranking = new ArrayList<>();
        String dateCondition = "WHERE DATE(o.order_date) = CURRENT_DATE "; // デフォルトは今日
        
        if ("MONTH".equals(periodType)) {
            dateCondition = "WHERE DATE_TRUNC('month', o.order_date) = DATE_TRUNC('month', CURRENT_DATE) ";
        } else if ("YEAR".equals(periodType)) {
            dateCondition = "WHERE DATE_TRUNC('year', o.order_date) = DATE_TRUNC('year', CURRENT_DATE) ";
        }

        String sql = "SELECT od.menu_name, SUM(od.quantity) AS total_qty, SUM(od.price * od.quantity) AS total_sales " +
                     "FROM order_details od " +
                     "JOIN orders o ON od.order_id = o.order_id " +
                     dateCondition +
                     "GROUP BY od.menu_name " +
                     "ORDER BY total_qty DESC LIMIT 5";

        try (Connection conn = util.DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ranking.add(new String[]{ rs.getString("menu_name"), String.valueOf(rs.getInt("total_qty")), String.valueOf(rs.getInt("total_sales")) });
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return ranking;
    }

    /**
     * 👤 【年齢層別】の人気メニューランキングを取得する
     */
    public List<String[]> findMenuRankingByAge(String ageGroup) {
        List<String[]> ranking = new ArrayList<>();
        String sql = "SELECT od.menu_name, SUM(od.quantity) AS total_qty " +
                     "FROM order_details od " +
                     "JOIN orders o ON od.order_id = o.order_id " +
                     "WHERE o.age_group = ? " +
                     "GROUP BY od.menu_name " +
                     "ORDER BY total_qty DESC LIMIT 3"; // 各年齢層のTOP3

        try (Connection conn = util.DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ageGroup);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ranking.add(new String[]{ rs.getString("menu_name"), String.valueOf(rs.getInt("total_qty")) });
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return ranking;
    }

    /**
     * 💰 【年齢層別】の売上総額と注文数を取得する
     */
    public List<String[]> findSalesSummaryByAge() {
        List<String[]> summary = new ArrayList<>();
        String sql = "SELECT age_group, COUNT(*) AS order_cnt, SUM(total_price) AS total_sales " +
                     "FROM orders GROUP BY age_group ORDER BY total_sales DESC";

        try (Connection conn = util.DBManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                summary.add(new String[]{
                    rs.getString("age_group"),
                    String.valueOf(rs.getInt("order_cnt")),
                    String.valueOf(rs.getInt("total_sales"))
                });
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return summary;
    }
}