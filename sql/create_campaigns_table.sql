-- =============================================
-- Migration: Create Campaigns Table
-- Description: Tạo bảng Campaigns cho quản lý chiến dịch Marketing
-- =============================================

-- Kiểm tra và tạo bảng Campaigns nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Campaigns')
BEGIN
    CREATE TABLE Campaigns (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(255) NOT NULL,
        budget DECIMAL(18,2) DEFAULT 0,
        start_date DATETIME NOT NULL,
        end_date DATETIME NOT NULL,
        manager_id INT,
        status VARCHAR(20) DEFAULT 'Draft' CHECK (status IN ('Draft', 'Pending', 'Approved', 'Active', 'Finished', 'Rejected')),
        description NVARCHAR(MAX),
        created_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_Campaigns_Manager FOREIGN KEY (manager_id) REFERENCES Users(id)
    );
    
    PRINT 'Campaigns table created successfully.';
END
ELSE
BEGIN
    PRINT 'Campaigns table already exists.';
END
GO

-- Tạo index cho các cột thường xuyên tìm kiếm
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Campaigns_Status' AND object_id = OBJECT_ID('Campaigns'))
BEGIN
    CREATE INDEX IX_Campaigns_Status ON Campaigns(status);
    PRINT 'Index IX_Campaigns_Status created.';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Campaigns_ManagerId' AND object_id = OBJECT_ID('Campaigns'))
BEGIN
    CREATE INDEX IX_Campaigns_ManagerId ON Campaigns(manager_id);
    PRINT 'Index IX_Campaigns_ManagerId created.';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Campaigns_Dates' AND object_id = OBJECT_ID('Campaigns'))
BEGIN
    CREATE INDEX IX_Campaigns_Dates ON Campaigns(start_date, end_date);
    PRINT 'Index IX_Campaigns_Dates created.';
END
GO

PRINT 'Campaign table migration completed successfully.';
