-- ============================================================================
-- Script mở rộng cột password trong bảng users
-- Password hash cần khoảng 70+ ký tự
-- ============================================================================

USE testCRM;
GO

-- Mở rộng cột password từ size hiện tại sang 255 ký tự
ALTER TABLE users
ALTER COLUMN password NVARCHAR(255) NOT NULL;
GO

PRINT 'Đã mở rộng cột password thành NVARCHAR(255)';
GO

-- Kiểm tra cấu trúc bảng
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'password';
GO
