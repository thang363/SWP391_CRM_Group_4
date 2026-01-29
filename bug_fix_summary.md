# Tổng hợp các lỗi và giải pháp sửa lỗi module Quản lý Chiến dịch

Tài liệu này tổng hợp lại các vấn đề kỹ thuật đã gặp phải trong quá trình hoàn thiện chức năng Quản lý Chiến dịch (CRUD) và cách xử lý chi tiết.

## 1. Lỗi "Unexpected token < in JSON at position 0"

### Hiện tượng
*   Khi nhấn nút **Edit** (Sửa), console báo lỗi: `SyntaxError: Unexpected token '<', "<!DOCTYPE "... is not valid JSON`.
*   Modal không hiện dữ liệu hoặc không mở lên.

### Nguyên nhân
*   Mã JavaScript gọi `fetch('/campaigns?action=get&id=...')` bằng phương thức **GET**.
*   Tại backend (`CampaignServlet.java`), phương thức `doGet` mặc định luôn forward về trang `campaigns.jsp` (trả về HTML) để hiển thị danh sách, chưa có logic xử lý trả về JSON cho API.
*   Do đó, trình duyệt nhận được HTML thay vì JSON, dẫn đến lỗi khi gọi `response.json()`.

### Cách sửa
*   **Backend (`CampaignServlet.java`):** Thêm logic kiểm tra tham số `action` trong hàm `doGet`. Nếu `action="get"`, thực hiện trả về JSON thay vì forward sang JSP.

```java
// Trong CampaignServlet.doGet
String action = request.getParameter("action");
if ("get".equals(action)) {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    handleGet(request, response);
    return; // Kết thúc xử lý, không forward về JSP
}
```

## 2. Lỗi không nhận được dữ liệu khi Lưu (Create/Update) hoặc Xóa

### Hiện tượng
*   Khi nhấn **Lưu** hoặc **Xóa**, backend báo lỗi hoặc nhận các tham số (`action`, `id`, `name`...) là `null`.
*   Chức năng không hoạt động dù không báo lỗi JS nghiêm trọng.

### Nguyên nhân
*   Frontend (`campaigns.jsp`) sử dụng `FormData` để gửi dữ liệu. Mặc định `FormData` sẽ gửi với `Content-Type: multipart/form-data`.
*   Trong Servlet chuẩn của Java, để đọc được dữ liệu `multipart/form-data`, Servlet cần có annotation `@MultipartConfig` hoặc sử dụng thư viện upload file. `CampaignServlet` hiện tại chưa có cấu hình này, nên `request.getParameter(...)` trả về `null`.

### Cách sửa
*   **Frontend (`campaigns.jsp`):** Chuyển từ `FormData` sang `URLSearchParams` để gửi dữ liệu dưới dạng `application/x-www-form-urlencoded`. Đây là định dạng chuẩn mà mọi Servlet đều đọc được qua `request.getParameter()`.

```javascript
// Thay vì dùng new FormData(form), sử dụng:
const params = new URLSearchParams();
new FormData(form).forEach((value, key) => params.append(key, value)); // Copy dữ liệu từ form sang params

// Gửi fetch
fetch(url, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' // Quan trọng
    },
    body: params
});
```

## 3. Lỗi Modal không mở hoặc mở chồng chéo (Bootstrap 5)

### Hiện tượng
*   Nhấn nút Edit lần đầu có thể được, nhưng các lần sau có thể bị lỗi hoặc không phản hồi.

### Nguyên nhân
*   Code cũ tạo mới `new bootstrap.Modal(...)` mỗi lần nhấn nút mà không kiểm tra xem instance của Modal đó đã tồn tại hay chưa. Điều này có thể gây xung đột DOM hoặc memory leak nhẹ.

### Cách sửa
*   Sử dụng `bootstrap.Modal.getInstance(element)` để lấy instance đã có. Chỉ tạo mới nếu chưa tồn tại.

```javascript
const modalEl = document.getElementById('campaignModal');
let modalInstance = bootstrap.Modal.getInstance(modalEl);
if (!modalInstance) {
    modalInstance = new bootstrap.Modal(modalEl);
}
modalInstance.show();
```

## 4. Lỗi bố cục nút Tìm kiếm / Đặt lại

### Kiến nghị
*   Điều chỉnh lại Class Bootstrap `col-md-*` và thêm `w-100` để các nút căn đều và đẹp hơn trên giao diện.

---
**Trạng thái hiện tại:** Tất cả các lỗi trên đã được khắc phục. Hệ thống CRUD hiện hoạt động ổn định.
