-- ============================================================================
-- Script tạo bảng users cho database testCRM
-- ============================================================================

-- Đảm bảo sử dụng đúng database
USE testCRM;
GO

-- Tạo bảng users
CREATE TABLE users (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    full_name NVARCHAR(100),
    phone NVARCHAR(20),
    role NVARCHAR(20) NOT NULL DEFAULT 'USER',
    is_active BIT NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);
GO

-- Tạo index cho các cột thường được query
CREATE INDEX IX_users_username ON users(username);
CREATE INDEX IX_users_email ON users(email);
CREATE INDEX IX_users_is_active ON users(is_active);
GO

-- Thêm user admin mặc định (password: admin123)
-- Password được hash bằng BCrypt
INSERT INTO users (username, password, email, full_name, role, is_active, created_at, updated_at)
VALUES (
    'admin',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3mF7gZi0g3k9TE.HM7We',  -- admin123
    'admin@crm.com',
    N'Quản trị viên',
    'ADMIN',
    1,
    GETDATE(),
    GETDATE()
);
GO

-- Thêm user test mặc định (password: user123)
INSERT INTO users (username, password, email, full_name, phone, role, is_active, created_at, updated_at)
VALUES (
    'user',
    '$2a$10$EqKcp1WFKs6pVuX5V5Z5aeEzVJ7MEdXnS8xCHKkCf3AQX4xC0e6Iq',  -- user123
    'user@crm.com',
    N'Người dùng test',
    '0123456789',
    'USER',
    1,
    GETDATE(),
    GETDATE()
);
GO

PRINT 'Bảng users đã được tạo thành công!';
PRINT 'Tài khoản mặc định:';
PRINT '  - admin / admin123 (ADMIN)';
PRINT '  - user / user123 (USER)';
GO
