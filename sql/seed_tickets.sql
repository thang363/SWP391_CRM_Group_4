-- Seed data for Tickets table
USE [CRM]
GO

-- 1. Get an existing customer ID (or create one if none exist)
DECLARE @CustomerId INT;
SELECT TOP 1 @CustomerId = id FROM Customers;

IF @CustomerId IS NULL
BEGIN
    INSERT INTO Customers (company_name, tax_code, website, industry, phone, email, status, tier, created_at)
    VALUES (N'Công ty TNHH Demo', '0101234567', 'https://demo.com', N'Công nghệ', '0243123456', 'contact@demo.com', 'Active', 'Standard', GETDATE());
    SET @CustomerId = SCOPE_IDENTITY();
END

-- 2. Get an existing user ID with role 'Support' or 'Manager'
DECLARE @AssignedTo INT;
SELECT TOP 1 @AssignedTo = id FROM Users WHERE role IN ('Support', 'Manager');

IF @AssignedTo IS NULL
BEGIN
    INSERT INTO Users (username, password_hash, full_name, email, phone, role, status, created_at)
    VALUES ('support_demo', 'dummy_hash', N'Nguyễn Văn Hỗ Trợ', 'support@crm.com', '0908123456', 'Support', 'Active', GETDATE());
    SET @AssignedTo = SCOPE_IDENTITY();
END

-- 3. Insert some sample tickets
INSERT INTO [dbo].[Tickets] ([customer_id], [title], [description], [status], [priority], [assigned_to], [created_at], [updated_at])
VALUES 
(@CustomerId, N'Cần hỗ trợ cài đặt phần mềm', N'Khách hàng báo lỗi khi cài đặt phiên bản mới nhất trên Windows 11.', 'Open', 'Medium', @AssignedTo, DATEADD(hour, -5, GETDATE()), GETDATE()),
(@CustomerId, N'Lỗi đăng nhập không thành công', N'Khách hàng không thể đăng nhập vào hệ thống từ sáng nay.', 'In Progress', 'High', @AssignedTo, DATEADD(day, -1, GETDATE()), GETDATE()),
(@CustomerId, N'Yêu cầu báo giá gói VIP', N'Khách hàng muốn tìm hiểu về các tính năng vượt trội của gói VIP.', 'Open', 'Low', NULL, GETDATE(), GETDATE()),
(@CustomerId, N'Lỗi hiển thị dữ liệu báo cáo', N'Dữ liệu báo cáo tháng 2 bị lệch so với thực tế.', 'Resolved', 'Critical', @AssignedTo, DATEADD(day, -3, GETDATE()), DATEADD(day, -1, GETDATE()));

-- 4. Verify data
SELECT t.*, c.company_name, u.full_name as assigned_to
FROM Tickets t
LEFT JOIN Customers c ON t.customer_id = c.id
LEFT JOIN Users u ON t.assigned_to = u.id;
GO
