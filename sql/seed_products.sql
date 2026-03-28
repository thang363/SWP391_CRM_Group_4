-- Script insert dữ liệu mẫu cho bảng Products
USE CRM;
GO

INSERT INTO [dbo].[Products] ([product_code], [name], [category], [unit_price], [description], [is_active])
VALUES 
('P001', N'Laptop Dell XPS 15', N'Electronics', 45000000, N'Laptop cao cấp cho doanh nhân, màn hình 4K siêu nét.', 1),
('P002', N'iPhone 16 Pro Max', N'Electronics', 35000000, N'Điện thoại flagship mới nhất của Apple.', 1),
('P003', N'Gói phần mềm CRM Standard', N'Software', 12000000, N'Bản quyền phần mềm quản lý khách hàng cho doanh nghiệp vừa và nhỏ.', 1),
('P004', N'Dịch vụ tư vấn triển khai', N'Service', 5000000, N'Dịch vụ hỗ trợ cài đặt và hướng dẫn sử dụng phần mềm.', 1),
('P005', N'Màn hình LG 27 Inch 4K', N'Electronics', 10000000, N'Màn hình đồ họa cao cấp, hỗ trợ HDR.', 1);

-- Kiểm tra lại dữ liệu
SELECT * FROM Products;
