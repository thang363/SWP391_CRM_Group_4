-- ============================================================================
-- Script cập nhật password cho users trong database testCRM
-- Password được hash theo format SHA-256 + Salt của PasswordUtil
-- ============================================================================

USE testCRM;
GO

-- Xóa users cũ nếu có
DELETE FROM users WHERE username IN ('admin', 'user');
GO

-- Thêm user admin với password: admin123
-- Hash được generate từ PasswordUtil.hashPassword("admin123")
-- Format: base64(salt):base64(sha256(salt + password))
INSERT INTO users (username, password, email, full_name, role, is_active, created_at, updated_at)
VALUES (
    'admin',
    -- Bạn cần chạy Java code để generate hash này
    -- Tạm thời để placeholder, sẽ cập nhật sau
    'PLACEHOLDER_HASH',
    'admin@crm.com',
    N'Quản trị viên',
    'ADMIN',
    1,
    GETDATE(),
    GETDATE()
);
GO

-- Thêm user test với password: user123
INSERT INTO users (username, password, email, full_name, phone, role, is_active, created_at, updated_at)
VALUES (
    'user',
    'PLACEHOLDER_HASH',
    'user@crm.com',
    N'Người dùng test',
    '0123456789',
    'USER',
    1,
    GETDATE(),
    GETDATE()
);
GO

PRINT 'Lưu ý: Cần chạy Java code để generate password hash đúng format!';
GO
