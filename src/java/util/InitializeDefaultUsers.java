package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Utility class để tạo users mặc định trong database với password đã hash. Chạy
 * class này một lần để khởi tạo dữ liệu test.
 *
 * Cách chạy: 1. Compile: javac -cp . util/InitializeDefaultUsers.java 2. Run:
 * java -cp . util.InitializeDefaultUsers
 *
 * Hoặc chạy trực tiếp trong IDE.
 */
public class InitializeDefaultUsers {

    public static void main(String[] args) {
        System.out.println("===========================================");
        System.out.println("  Khởi tạo Users mặc định cho CRM");
        System.out.println("===========================================\n");

        // Generate password hashes
        String commonPassword = "123";
        String passwordHash = PasswordUtil.hashPassword(commonPassword);

        System.out.println("Password hash cho '123': " + passwordHash);
        System.out.println();

        // Kết nối database và cập nhật
        try {
            Class.forName(Constants.DB_DRIVER);

            try (Connection conn = DriverManager.getConnection(
                    Constants.DB_URL,
                    Constants.DB_USERNAME,
                    Constants.DB_PASSWORD)) {

                System.out.println("Kết nối database thành công!");

                // 1. Ensure Schema (Migration)
                ensureSchema(conn);

                // 2. Upsert Users (Update if exists, Insert if not)
                System.out.println("Đang cập nhật/tạo users...");

                // Manager 1
                upsertUser(conn, "manager", passwordHash, "manager@crm.com", "Nguyễn Văn A (Manager)", "0909000001", "Manager");

                // Manager 2
                upsertUser(conn, "manager2", passwordHash, "manager2@crm.com", "Trần Thị B (Manager)", "0909000002", "Manager");

                // Marketing1
                upsertUser(conn, "marketing", passwordHash, "marketing@crm.com", "NV Tiếp thị", "0909000002", "Marketing");
                // Marketing2
                upsertUser(conn, "marketing2", passwordHash, "marketing2@crm.com", "marketing2", "0909000003", "Marketing");

                // Sale
                upsertUser(conn, "sale", passwordHash, "sale@crm.com", "NV Kinh doanh", "0909000003", "Sale");

                // Support
                upsertUser(conn, "support", passwordHash, "support@crm.com", "NV Hỗ trợ", "0909000004", "Support");

                System.out.println("\n🎉 Khởi tạo hoàn tất! Bạn có thể đăng nhập ngay.");

            }

        } catch (ClassNotFoundException e) {
            System.err.println("❌ Không tìm thấy JDBC Driver: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("❌ Lỗi database: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static void upsertUser(Connection conn, String username, String passwordHash,
            String email, String fullName, String phone, String role) throws SQLException {

        // Check if user exists
        String checkSql = "SELECT count(*) FROM users WHERE username = ?";
        boolean exists = false;
        try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setString(1, username);
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    exists = true;
                }
            }
        }

        if (exists) {
            // UPDATE
            String updateSql = "UPDATE users SET password_hash = ?, email = ?, full_name = ?, phone = ?, role = ?, status = 'Active', created_at = GETDATE() WHERE username = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setString(1, passwordHash);
                updateStmt.setString(2, email);
                updateStmt.setString(3, fullName);
                updateStmt.setString(4, phone);
                updateStmt.setString(5, role);
                updateStmt.setString(6, username);
                updateStmt.executeUpdate();
                System.out.println("✅ Đã cập nhật: " + username + " (" + role + ")");
            }
        } else {
            // INSERT
            String insertSql = "INSERT INTO users (username, password_hash, email, full_name, phone, role, status, created_at) VALUES (?, ?, ?, ?, ?, ?, 'Active', GETDATE())";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setString(1, username);
                insertStmt.setString(2, passwordHash);
                insertStmt.setString(3, email);
                insertStmt.setString(4, fullName);
                insertStmt.setString(5, phone);
                insertStmt.setString(6, role);
                insertStmt.executeUpdate();
                System.out.println("✅ Đã tạo mới: " + username + " (" + role + ")");
            }
        }
    }

    private static void ensureSchema(Connection conn) {
        try {
            System.out.println("Đang kiểm tra và cập nhật schema...");

            // Check/Add Phone Column
            try (java.sql.Statement stmt = conn.createStatement()) {
                // Try selecting phone to see if it exists
                stmt.executeQuery("SELECT TOP 1 phone FROM users");
                System.out.println("- Cột 'phone' đã tồn tại.");
            } catch (SQLException e) {
                // If error, likely column missing. Add it.
                System.out.println("- Cột 'phone' chưa tồn tại. Đang thêm...");
                try (java.sql.Statement stmt = conn.createStatement()) {
                    stmt.executeUpdate("ALTER TABLE users ADD phone VARCHAR(20)");
                    System.out.println("  => Đã thêm cột 'phone'.");
                }
            }

        } catch (Exception e) {
            System.err.println("Lỗi khi cập nhật schema: " + e.getMessage());
        }
    }
}
