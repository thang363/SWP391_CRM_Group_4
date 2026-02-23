# Kịch bản Kiểm thử (Test Cases): Logic Phân quyền Landing Page & Campaign

Dưới đây là 6 kịch bản kiểm thử (Test Cases) vét cạn các trường hợp có thể xảy ra đối với cấu hình trạng thái của Landing Page (LP) và Campaign. 
Bạn hãy đóng vai 2 người dùng để test:
- **Khách Public:** Là người dùng ẩn danh (Mở tab Ẩn danh/Incognito), chưa đăng nhập vào CRM.
- **Nhân viên (Internal):** Là tài khoản Marketing/Manager đang đăng nhập trên hệ thống CRM.

---

## 🟢 Case 1: Campaign chưa chạy (Nháp)
- **Điều kiện:** Campaign = `Draft`, Landing Page = `Bất kỳ` (Draft / Pending / Approved)
- **Hành động & Kết quả mong đợi:**
  - **Khách Public:** Truy cập link LP -> Bị chặn (Lỗi `403 Forbidden` / Không có quyền truy cập).
  - **Nhân viên:** Truy cập link LP -> Xem được bình thường, **HIỂN THỊ** Form điền. 
  - **Test Submit (Nhân viên):** Điền form và Gửi -> Thành công. 
  - **Check DB/Report:** Kéo về mục Danh sách Đăng ký (`submissions.jsp`), data phải có nhãn màu vàng: **`Internal Test (Draft Campaign)`**.

## 🟡 Case 2: Campaign đang chạy nhưng Landing Page chưa duyệt (LP Nháp)
- **Điều kiện:** Campaign = `Active`, Landing Page = `Draft` hoặc `Pending` hoặc `Rejected`
- **Hành động & Kết quả mong đợi:**
  - **Khách Public:** Truy cập link LP -> Bị chặn (Lỗi `403 Forbidden`).
  - **Nhân viên:** Truy cập link LP -> Xem được bình thường, **HIỂN THỊ** Form điền. 
  - **Test Submit (Nhân viên):** Điền form và Gửi -> Thành công.
  - **Check DB/Report:** Kéo về mục Danh sách Đăng ký, data phải có nhãn màu vàng: **`Internal Test (Draft LP)`**.

## 🎉 Case 3: Trạng thái VÀNG (Sẵn sàng đón khách)
- **Điều kiện:** Campaign = `Active`, Landing Page = `Approved` (hoặc `active`)
- **Hành động & Kết quả mong đợi:**
  - **Khách Public:** Truy cập link LP -> Xem được bình thường, Form **HIỂN THỊ**.
  - **Nhân viên:** Truy cập link LP -> Xem được bình thường, Form **HIỂN THỊ**.
  - **Test Submit (Từ bất kỳ ai):** Điền form và Gửi -> Thành công.
  - **Check DB/Report:** Kéo về mục Danh sách Đăng ký, data phải hiển thị nhãn màu xanh dương (chuẩn): **`Landing Page`**. Đây là lead thật dùng để Sales chốt Sale.

## ⛔ Case 4: Campaign Tạm dừng
- **Điều kiện:** Campaign = `Paused`, Landing Page = `Bất kỳ` (Kể cả Approved)
- **Hành động & Kết quả mong đợi:**
  - **Khách Public:** Truy cập link LP -> Bị chặn (Lỗi `403 Forbidden`).
  - **Nhân viên:** Truy cập link LP -> Xem được, nhưng **KHÔNG THẤY FORM**. Chỉ thấy dòng chữ *"Chiến dịch đã kết thúc hoặc tạm dừng..."*.
  - **Test Hack Submit (Dành cho Dev/Tester):** Dùng Postman (có set gửi Cookie Session login) bắn POST request trực tiếp vào `/lp/submit` cùng tham số. 
  - **Check Server:** Server phải chối từ và trả về JSON: `{"success": false, "message": "Chiến dịch này hiện không nhận đăng ký..."}`.

## 🔴 Case 5: Campaign Đóng sổ / Hoàn thành
- **Điều kiện:** Campaign = `Finished`, Landing Page = `Bất kỳ` (Kể cả Approved)
- **Hành động & Kết quả mong đợi:**
  - **Khách Public:** Truy cập link LP -> Bị chặn (Lỗi `403 Forbidden`).
  - **Nhân viên:** Truy cập link LP -> Xem được thiết kế LP để lưu kho, **KHÔNG THẤY FORM**. Màn hình báo chiến dịch đã chốt.
  - **Test Hack Submit:** Bắn Postman ép data vào -> Backend giội ngược trả lại JSON lỗi `success: false`.

## ⚠️ Case 6: Cấu hình mồ côi / Lỗi Data (Orphaned LP)
- **Điều kiện:** Landing Page = `Approved` (rất đẹp) nhưng do lỗi gì đó **Không được gán Campaign** (`campaign_id` = null) hoặc Campaign ID gán vào đã **bị xóa cạn khỏi DB** (Deleted).
- **Hành động & Kết quả mong đợi:**
  - **Khách Public:** Bị chặn.
  - **Nhân viên:** Xem được giao diện.
  - **Test Submit (Nhân viên):** Điền form và Gửi -> Backend do không dò trúng Campaign hợp lệ dưới gầm DB nên sẽ phải nhổ ra lỗi: `Error: Associated Campaign not found.`
  
---
**Ghi chú cho Tester:**
Sau khi submit thành công cho **Case 1/2/3**, vui lòng tải lại trang `submissions.jsp` (Mục Marketing -> Danh sách Đăng ký) để quan sát màu sắc của giao diện hiển thị badge!
