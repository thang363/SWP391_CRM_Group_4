# Đặc tả Nghiệp vụ: Thu thập & Quản lý Lead

Tài liệu này mô tả luồng quy trình (Business Flow) cho việc thu thập Lead từ Landing Page và Import từ nguồn bên ngoài.

## 1. Quy trình Xử lý Đăng ký từ Landing Page (Lead Collection)

Đây là quy trình chuyển đổi người quan tâm (Submission) thành Khách hàng tiềm năng (Lead) để Sale chăm sóc.

### Luồng nghiệp vụ:
1.  **Tiếp nhận (Capture)**:
    - Khách hàng điền form trên Landing Page (Tên, SĐT, Email).
    - Hệ thống lưu vào danh sách "Đăng ký mới" (Submissions). Trạng thái ban đầu: *Chưa xử lý*.

2.  **Sàng lọc & Phân loại (Review & Categorize)**:
    - Nhân viên Marketing/Sale xem danh sách các Đăng ký mới.
    - Tại đây, nhân viên quyết định:
        - **Duyệt (Convert to Lead)**: Nếu thông tin có vẻ hợp lệ -> Chuyển thành Lead.
        - **Xóa (Delete)**: Nếu là spam hoặc rác -> Xóa khỏi hệ thống.

3.  **Chuyển đổi (Conversion Logic)**:
    - Khi nhân viên nhấn "Chuyển thành Lead", hệ thống thực hiện:
        - **Kiểm tra trùng lặp (Duplicate Check)**: So sánh SĐT/Email với dữ liệu Lead đang có.
            - *Trường hợp 1 (Chưa có)*: Tạo Lead mới.
                - Tự động gắn **Nguồn (Source)** = "Landing Page".
                - Tự động gắn **Chiến dịch (Campaign)** = Chiến dịch tương ứng của Landing Page đó.
                - Trạng thái Lead = "New".
            - *Trường hợp 2 (Đã có)*: Cảnh báo nhân viên.
                - Tùy chọn: Cập nhật thông tin Lead cũ hoặc Bỏ qua.


## 2. Quy trình Import Lead từ File (Import External Leads)

Dành cho việc nạp danh sách khách hàng tiềm năng có sẵn (ví dụ: data đi mua, data từ sự kiện offline) vào hệ thống.

### Luồng nghiệp vụ:
1.  **Chuẩn bị dữ liệu**:
    - Nhân viên chuẩn bị file danh sách (Excel/CSV) theo mẫu quy định (Họ tên, SĐT, Email, Địa chỉ...).

2.  **Cấu hình Import**:
    - Nhân viên upload file lên hệ thống.
    - **Bắt buộc chọn**:
        - **Chiến dịch (Campaign)**: Lead này thuộc chiến dịch nào? (để đo lường hiệu quả).
        - **Nguồn (Source)**: Lead này từ đâu? (VD: Data mua, Hội thảo, Giới thiệu...).

3.  **Xử lý & Kết quả**:
    - Hệ thống quét từng dòng trong file:
        - **Valid**: Tạo Lead mới với Campaign & Source đã chọn.
        - **Duplicate**: Nếu trùng SĐT/Email -> Ghi nhận là "Trùng lặp" và không tạo mới (hoặc ghi đè tùy cấu hình).
    - **Báo cáo**: Hiển thị kết quả ("Thành công: 50, Trùng: 5, Lỗi: 2").

## 3. Ý nghĩa Dữ liệu (Business Value)
Việc phân loại kỹ (Categorize) ngay từ đầu giúp:
- **Automation**: Hệ thống Email Marketing có thể tự động gửi email chào mừng phù hợp với từng Chiến dịch/Nguồn.
- **Reporting**: Biết được Chiến dịch nào (Landing Page hay Data ngoài) mang lại nhiều Lead chất lượng hơn.

## 4. Quy định về Dữ liệu (Data Validation)

Để đảm bảo chất lượng dữ liệu đầu vào (Data Integrity), hệ thống áp dụng các quy tắc sau:

### 4.1. Thông tin Cá nhân (Landing Page & Import)
- **Họ và Tên**: Bắt buộc. Độ dài tối đa 100 ký tự.
- **Email**: 
    - Bắt buộc.
    - Phải đúng định dạng email (Ví dụ: `user@domain.com`).
    - Sử dụng Regex chuẩn để kiểm tra.
- **Số Điện Thoại**:
    - Không bắt buộc (tùy Landing Page), nhưng nếu nhập phải đúng định dạng.
    - Định dạng VN: 10 chữ số, bắt đầu bằng số `0`.
- **Nội dung (Message)**: Tối đa 1000 ký tự.

### 4.2. Xử lý Lỗi
- **Frontend**: Hiển thị lỗi ngay bên dưới trường nhập liệu (Inline Validation) trước khi gửi.
- **Backend**: Trả về lỗi JSON cụ thể nếu dữ liệu không hợp lệ (Phòng trường hợp Spam/Bot bypass Frontend).
