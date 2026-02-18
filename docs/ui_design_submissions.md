# Thiết kế Giao diện: Quản lý Danh sách đăng ký (Submissions)

Tài liệu này mô tả chi tiết giao diện màn hình `web/views/marketing/submissions.jsp`.

## 1. Tổng quan Layout
- **Tiêu đề**: "Danh sách đăng ký từ Landing Page"
- **Vị trí**: Nằm trong menu **Marketing**.
- **Template**: Sử dụng layout chuẩn của Dashmin (Sidebar bên trái, Header bên trên).

## 2. Các thành phần chính

### 2.1. Thống kê nhanh (Top Cards)
Hiển thị 3 thẻ (Card) trên cùng để nắm bắt tình hình:
1.  **Tổng số đăng ký**: Số liệu tổng.
2.  **Chưa xử lý**: Số lượng cần duyệt (Màu đỏ/Cam).
3.  **Hôm nay**: Số lượng đăng ký mới trong ngày.

### 2.2. Bộ lọc (Filter Bar)
Thanh công cụ lọc dữ liệu nằm ngay trên bảng:
- **🔍 Tìm kiếm**: Input text (Search theo Tên, Email, SĐT).
- **📢 Chiến dịch (Campaign)**: Dropdown có tìm kiếm (Searchable) - Giúp chọn nhanh trong danh sách dài.
- **📂 Landing Page**: Dropdown có tìm kiếm (Searchable).
- **📅 Thời gian**: Datepicker (Từ ngày - Đến ngày).
- **Trạng thái**: Dropdown (Tất cả / Chưa xử lý / Đã xử lý).
- **Nút Lọc**: Button "Tìm kiếm".


### 2.3. Bảng Dữ liệu (Main Table)
Hiển thị danh sách submission.

| Cột | Mô tả | Hiển thị |
| :--- | :--- | :--- |
| **ID** | Mã đăng ký | #123 |
| **Thời gian** | Thời điểm nộp form | `dd/MM/yyyy HH:mm` |
| **Landing Page** | Tên LP nguồn | "Khuyến mãi Tết" |
| **Khách hàng** | Thông tin gộp | **Nguyễn Văn A**<br>nguyenvana@email.com<br>0987654321 |
| **Lời nhắn** | Message | "Tôi muốn tư vấn về..." (Cắt ngắn nếu dài) |
| **Trạng thái** | Status Badge | <span style="color:red">Chưa xử lý</span> / <span style="color:green">Đã chuyển đổi</span> |
| **Hành động** | Actions | [✅ Duyệt] [🗑️ Xóa] |

## 3. Tương tác (Interactions)

### 3.1. Hành động: Duyệt (Convert to Lead)
- **Trigger**: Nhấn nút [✅ Duyệt] (Màu xanh).
- **Xử lý**: 
    - Hệ thống gọi API kiểm tra trùng lặp.
    - **Nếu OK**: Hiển thị Toast "Đã tạo Lead thành công!" và reload lại dòng đó (đổi trạng thái).
    - **Nếu Trùng**: Hiển thị Confirm Dialog:
        > "Email/SĐT này đã tồn tại trong danh sách Lead. Bạn có chắc chắn muốn tạo thêm Lead mới không?"
        > [Hủy bỏ] [Vẫn tạo]

### 3.2. Hành động: Xóa (Delete Spam)
- **Trigger**: Nhấn nút [🗑️ Xóa] (Màu đỏ).
- **Mục đích**: Loại bỏ các submission là Spam, Rác, Test sai.
- **Xử lý**:
    - Hiển thị Confirm Dialog: "Bạn có chắc chắn muốn xóa bản ghi này? Hành động này không thể hoàn tác."
    - Gọi API xóa vĩnh viễn (Hard Delete) khỏi database.

### 3.3. Hành động: Xem chi tiết (Optional)
- Mặc dù đã bỏ popup xem chi tiết, nhưng nếu cần xem Message dài:
- **Hover**: Rê chuột vào nội dung lời nhắn để hiện Tooltip đầy đủ.

## 4. CSS & Style
- Sử dụng Bootstrap 5 (theo Template Dashmin).
- **Button Duyệt**: `btn-success` (Màu xanh lá).
- **Badge Chưa xử lý**: `badge bg-danger` (Màu đỏ).
- **Badge Đã xử lý**: `badge bg-success` (Màu xanh).
