# Kế hoạch sửa lỗi Logic Trạng thái Campaign (Campaign Status Logic Fix)

## Danh sách công việc (Checklist)

- [x] 1. **Cập nhật giao diện `campaigns.jsp`**: 
    - Bao bọc trường `select` chọn Trạng thái (Status) trong một thẻ `div` và gán cho nó một `id` (ví dụ: `statusContainer`) để dễ dàng điều khiển việc ẩn/hiện bằng JavaScript.
  
- [x] 2. **Cập nhật JavaScript `campaigns.js`**: 
    - Sửa hàm `openCreateModal()`: Ẩn phần tử `statusContainer` đi và ngầm định gán giá trị của nó thành `Draft`. Như vậy người dùng sẽ không thấy trường trạng thái khi mới tạo.
    - Sửa hàm `editCampaign()`: Hiển thị lại phần tử `statusContainer` và set giá trị tương ứng với trạng thái hiện tại của chiến dịch đó.

- [x] 3. **Cập nhật Backend `CampaignServlet.java`**: 
    - Trong phương thức `handleCreate()`, bắt buộc gán `campaign.setStatus("Draft")` trước khi thực hiện lưu xuống Database. Việc này đảm bảo kể cả khi người dùng cố tình bỏ qua bước chặn ở Frontend thì dữ liệu vẫn sẽ luôn đúng quy chuẩn.

---

## Nghiệp vụ (Business Logic): Giới hạn Đăng ký Form Landing Page

### 1. Vấn đề hiện tại
- Landing Page (LP) đang ẩn/cấm khách ngoài (public) đối với các Campaign không `Active`.
- Khách nội bộ (đã login) vẫn vào xem LP được dù Campaign đã `Finished`, `Paused` hoặc đang `Draft` (nháp).
- Nếu không có ràng buộc, nhân viên có thể vô tình/cố ý submit Form vào Campaign đã chốt (Finished) hoặc Campaign nháp (Draft), làm sai lệch số liệu thống kê.

### 2. Giải pháp được chọn
- **Đối với Draft**: Nhân viên (đang test) sẽ thấy form và được submit bình thường. Tuy nhiên, hệ thống sẽ tự động gán nguồn (`Source`) là `"Internal Test (Draft)"` để phân biệt với Lead thật, giúp quản lý dễ lọc ra khỏi báo cáo kinh doanh chính thức.
- **Đối với Paused / Finished**: Đây là các trạng thái đã chốt hoặc ngưng hoạt động. Nhân viên vào xem LP sẽ KHÔNG THẤY FORM. Thông báo *"Chiến dịch đã đóng/tạm dừng"* sẽ hiện ra. Backend cũng sẽ từ chối nhận API gửi vào.

### 3. Checklist
- [x] **JSP (`landing-page.jsp`)**: Khai báo thư viện JSTL, bao bọc Form Contact trong `<c:choose>`. Nếu `campaignStatus` = `Paused`|`Finished` thì ẩn Form, hiện thông báo ngưng nhận đăng ký.
- [x] **Servlet `doGet` (`PublicLandingPageServlet.java`)**: Truyền `campaignStatus` xuống JSP qua attribute.
- [x] **Servlet `doPost` (`PublicLandingPageServlet.java`)**:
  - Chặn request API nếu `campaignStatus` = `Paused/Finished`.
  - Thay đổi `Source` của Lead thành `"Internal Test (Draft)"` nếu submit lúc đang `Draft`.

---

## Vá lỗ hổng: Campaign Active nhưng LP Draft/Pending
- [ ] **Vấn đề**: Khi Campaign đang chạy (Active) nhưng thẻ Landing Page chưa duyệt (Draft/Pending), nhân viên nội bộ vẫn xem được LP và nếu Submit Form, hệ thống ghi nhận `Source` là `"Landing Page"` (giống Lead thật). Điều này sai logic.
- [ ] **Giải pháp (`PublicLandingPageServlet.java`)**: Bổ sung điều kiện trong `doPost()`. Dù Campaign đang `Active`, nhưng nếu LP chưa `Approved`/`Active` thì ép `Source` thành `"Internal Test (Draft LP)"`.
- [ ] **Giao diện (`submissions.jsp`)**: Cập nhật vòng lặp `c:choose` để bắt thêm nhãn `"Internal Test (Draft LP)"` cùng với `"Internal Test (Draft Campaign)"`.
