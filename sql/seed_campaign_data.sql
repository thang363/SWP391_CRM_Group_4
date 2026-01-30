-- Script insert dữ liệu mẫu cho bảng Campaigns
USE CRM;
GO

-- 1. Tìm ID của một Manager để gán cho chiến dịch (Lấy Manager đầu tiên tìm thấy)
DECLARE @ManagerId INT;
SELECT TOP 1 @ManagerId = id FROM Users WHERE role = 'Manager';

-- Nếu chưa có Manager nào, bạn có thể uncomment dòng dưới để tạo một Manager mẫu
-- INSERT INTO Users (username, password, email, full_name, phone, role, status, created_at)
-- VALUES ('manager_demo', '123456', 'manager@crm.com', N'Nguyễn Văn Quản Lý', '0909123456', 'Manager', 'Active', GETDATE());
-- SET @ManagerId = SCOPE_IDENTITY();

-- 2. Insert các chiến dịch mẫu
INSERT INTO Campaigns (name, budget, start_date, end_date, manager_id, status, description, created_at)
VALUES 
-- Chiến dịch đang chạy (Active)
(N'Chiến dịch Tết Ất Tỵ 2025', 500000000, '2025-01-01', '2025-02-15', @ManagerId, 'Active', N'Chiến dịch quảng bá sản phẩm dịp Tết Nguyên Đán, tập trung vào các set quà tặng doanh nghiệp cao cấp.', GETDATE()),

-- Chiến dịch nháp (Draft)
(N'Summer Vibes Collection Launch', 200000000, '2025-06-01', '2025-08-31', @ManagerId, 'Draft', N'Kế hoạch ra mắt bộ sưu tập mùa hè. Đang chờ duyệt chi tiết content và KOLs.', GETDATE()),

-- Chiến dịch đã kết thúc (Finished)
(N'Ra mắt sản phẩm Smartphone X', 1000000000, '2024-10-01', '2024-12-31', @ManagerId, 'Finished', N'Chiến dịch branding cho dòng điện thoại mới. Đạt KPI về reach và engagement.', DATEADD(month, -3, GETDATE())),

-- Chiến dịch chờ duyệt (Pending)
(N'Tri ân khách hàng thân thiết Q1', 50000000, '2025-03-01', '2025-03-31', @ManagerId, 'Pending', N'Gửi quà tặng và voucher cho top 500 khách hàng có doanh số cao nhất năm 2024.', GETDATE()),

-- Chiến dịch bị từ chối (Rejected)
(N'Flash Sale 20/10', 0, '2024-10-20', '2024-10-20', @ManagerId, 'Rejected', N'Đề xuất chạy flash sale giảm giá 50% toàn sàn. Bị từ chối do ảnh hưởng biên lợi nhuận.', DATEADD(month, -4, GETDATE())),

-- Chiến dịch đã được duyệt (Approved) - chuẩn bị chạy
(N'Back to School 2025', 150000000, '2025-08-15', '2025-09-05', @ManagerId, 'Approved', N'Chương trình khuyến mãi dụng cụ học tập và laptop cho sinh viên.', GETDATE());

-- 3. Kiểm tra lại dữ liệu đã insert
SELECT * FROM Campaigns;
