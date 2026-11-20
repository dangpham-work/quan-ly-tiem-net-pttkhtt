package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String HOST     = "127.0.0.1";
    private static final String PORT     = "3306";
    private static final String USER     = "root";
    private static final String PASS     = "12345";
    private static final String DATABASE = "quanlytiemnet_simple";
    private static final String URL =
            "jdbc:mysql://" + HOST + ":" + PORT + "/" + DATABASE
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=Asia/Ho_Chi_Minh"
            + "&useUnicode=true"
            + "&characterEncoding=UTF-8";

    // Force-load driver khi class được nạp (quan trọng với Tomcat)
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("[DBConnection] MySQL Driver loaded OK.");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] CRITICAL: MySQL Driver NOT found! " + e.getMessage());
        }
    }

    /**
     * Trả về một Connection MỚI mỗi lần gọi.
     * Caller có trách nhiệm close() connection sau khi dùng xong.
     * Dùng try-with-resources trong DAO.
     */
    public static Connection getConnection() {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASS);
            return conn;
        } catch (SQLException e) {
            System.err.println("[DBConnection] Lỗi kết nối database: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("[DBConnection] Lỗi đóng kết nối: " + e.getMessage());
            }
        }
    }

    // Giữ backward-compat với DAO cũ gọi closeConnection() không tham số
    public static void closeConnection() {
        // no-op - connection được close trong DAO
    }

    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }
}