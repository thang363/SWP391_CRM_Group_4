package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Utility class để tạo users mặc định trong database với password đã hash.
 * Chạy class này một lần để khởi tạo dữ liệu test.
 * 
 * Cách chạy:
 * 1. Compile: javac -cp . util/InitializeDefaultUsers.java
 * 2. Run: java -cp . util.InitializeDefaultUsers
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
                
                // 2. Clean up old users
                String deleteSql = "DELETE FROM users WHERE username IN ('manager', 'marketing', 'sale', 'support')";
                try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                    int deleted = deleteStmt.executeUpdate();
                    System.out.println("Đã xóa " + deleted + " user(s) cũ nếu tồn tại.");
                }
                
                // 3. Insert new users
                String insertSql = "INSERT INTO users (username, password_hash, email, full_name, phone, role, status, created_at) " +
                        "VALUES (?, ?, ?, ?, ?, ?, 'Active', GETDATE())";
                
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    // 1. Manager
                    insertStmt.setString(1, "manager");
                    insertStmt.setString(2, passwordHash);
                    insertStmt.setString(3, "manager@crm.com");
                    insertStmt.setString(4, "Quản lý");
                    insertStmt.setString(5, "0909000001");
                    insertStmt.setString(6, "Manager");
                    insertStmt.executeUpdate();
                    System.out.println("✅ Đã tạo: manager / 123 (Manager)");
                    
                    // 2. Marketing
                    insertStmt.setString(1, "marketing");
                    insertStmt.setString(2, passwordHash);
                    insertStmt.setString(3, "marketing@crm.com");
                    insertStmt.setString(4, "NV Tiếp thị");
                    insertStmt.setString(5, "0909000002");
                    insertStmt.setString(6, "Marketing");
                    insertStmt.executeUpdate();
                    System.out.println("✅ Đã tạo: marketing / 123 (Marketing)");

                    // 3. Sale
                    insertStmt.setString(1, "sale");
                    insertStmt.setString(2, passwordHash);
                    insertStmt.setString(3, "sale@crm.com");
                    insertStmt.setString(4, "NV Kinh doanh");
                    insertStmt.setString(5, "0909000003");
                    insertStmt.setString(6, "Sale");
                    insertStmt.executeUpdate();
                    System.out.println("✅ Đã tạo: sale / 123 (Sale)");

                    // 4. Support
                    insertStmt.setString(1, "support");
                    insertStmt.setString(2, passwordHash);
                    insertStmt.setString(3, "support@crm.com");
                    insertStmt.setString(4, "NV Hỗ trợ");
                    insertStmt.setString(5, "0909000004");
                    insertStmt.setString(6, "Support");
                    insertStmt.executeUpdate();
                    System.out.println("✅ Đã tạo: support / 123 (Support)");
                }
                
                System.out.println("\n🎉 Khởi tạo hoàn tất! Bạn có thể đăng nhập ngay.");
                
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ Không tìm thấy JDBC Driver: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("❌ Lỗi database: " + e.getMessage());
            System.err.println("👉 LƯU Ý: Nếu lỗi 'CHECK constraint', hãy chạy SQL sau:");
            System.err.println("   ALTER TABLE users DROP CONSTRAINT [Tên_Constraint];");
            System.err.println("   ALTER TABLE users ADD CONSTRAINT CK_Users_Role CHECK (role IN ('Manager', 'Marketing', 'Sale', 'Support'));");
            e.printStackTrace();
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
