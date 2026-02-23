# Checklist: Màn hình Thu thập & Phân loại Lead (Lead Collection)

File này liệt kê chi tiết các đầu việc cần làm để hoàn thiện màn hình "Thu thập & Phân loại Lead" (trước đây là Submissions).

## 1. Backend (Java)

### 1.1. Data Access Layer (DAO)
- [ ] **LeadSubmissionDAO**:
    - [ ] `findAll(...)`: Lấy danh sách. **Lưu ý**: Cần xử lý trường hợp `landingPageId` bị NULL.
    - [ ] `count(...)`: Đếm tổng số.
    - [ ] `delete(int id)`: Xóa bản ghi.
    - [ ] `updateStatus(...)`: Cập nhật trạng thái.
    - [ ] `insertBatch(List<LeadSubmission> list)`: Insert nhiều dòng cùng lúc (Batch Optimize).
    - [ ] **Update**: Thêm cột `campaign_id` vào câu lệnh INSERT và SELECT.
- [ ] **LeadSubmission Entity**:
    - [ ] Thêm field `Integer campaignId`.
    - [ ] Update Getter/Setter.
- [ ] **ImportHistoryDAO** (Mới - Để chống Spam):
    - [ ] `insert(fileChecksum, fileName, userId, rowCount)`: Log lịch sử import.
    - [ ] `existsChecksum(String checksum)`: Check xem file đã import chưa.
    - [ ] `countImportToday(int userId)`: Đếm số lần import trong ngày của user.
- [ ] **LeadDAO**:
    - [ ] `checkDuplicate(String email, String phone)`: Kiểm tra xem đã tồn tại Lead chưa.
    - [ ] `insert(Lead lead)`: Tạo Lead mới từ Submission.
- [ ] **CampaignDAO**:
    - [ ] `findAll()`: Lấy danh sách chiến dịch để đổ vào Dropdown bộ lọc.
- [ ] **LandingPageDAO**:
    - [ ] `findByCampaignId(int campaignId)`: Lấy danh sách LP theo chiến dịch (cho Dropdown phụ thuộc).

### 1.2. Controller (Servlet)
- [ ] **SubmissionsServlet (`/marketing/submissions`)**:
    - [ ] **`doGet`**:
        - [ ] Nhận tham số lọc (keyword, campaignId, ...).
        - [ ] Gọi DAO lấy data + count.
        - [ ] Set attributes: `submissions`, `campaigns`, `currentPage`, `totalPages`.
        - [ ] Forward sang `submissions.jsp`.
    - [ ] **`doPost` (API)**:
        - [ ] Action `loadLandingPages`: Trả về JSON list LP khi chọn Campaign.
        - [ ] Action `convert`:
            - Check duplicate.
            - Nếu trùng -> Trả về JSON warning.
            - Nếu OK -> Gọi `LeadDAO.insert` -> `SubmissionDAO.updateStatus` -> Trả về JSON success.
- [ ] **PublicLandingPageServlet**:
    - [ ] `handleFormSubmission`: Query `LandingPage` để lấy `campaignId` -> Set vào `LeadSubmission`.
- [ ] **ImportLeadServlet (`/leads/import`)** - Action này cần bảo mật cao:
    - [ ] **Structure**:
        - `doGet`: Hiện form upload (Chọn Campaign + File).
        - `doPost`: Xử lý upload.
    - [ ] **Spam Protection Logic (Thứ tự check)**:
        1. Check logged in user & role (Marketing/Manager).
        2. Check **Rate Limit**: Gọi `ImportHistoryDAO.countImportToday`. Nếu >= 5 -> Báo lỗi.
        3. Parse file CSV -> List objects.
        4. Check **Row Limit**: Nếu > 1000 dòng -> Báo lỗi.
        5. Calculate **MD5 Checksum**: Gọi `ImportHistoryDAO.existsChecksum`. Nếu có -> Báo lỗi "File đã import".
    - [ ] **Transaction Handling**:
        - Mở Transaction (`conn.setAutoCommit(false)`).
        - Loop InsertBatch.
        - Nếu lỗi > 10% -> Rollback.
        - Nếu OK -> Commit -> Insert vào `ImportHistoryDAO` -> Redirect user.

## 2. Frontend (JSP & JS)

### 2.1. Cấu trúc HTML (`submissions.jsp`)
- [ ] **Layout**: Kế thừa `dashboard.jsp` (Sidebar, Navbar).
- [ ] **Top Cards**: 3 thẻ thống kê (Tổng, Chưa xử lý, Hôm nay).
- [ ] **Filter Bar**:
    - [ ] Input Search.
    - [ ] Select Campaign (id=`filterCampaign`).
    - [ ] Select Landing Page (id=`filterLP`).
    - [ ] Select Status.
    - [ ] Date Picker.
    - [ ] **Import Button**: Nút linked đến `/leads/import`.
    - [ ] **Bulk Actions**: Nút "Duyệt nhanh" (Ẩn mặc định).
- [ ] **Table**:
    - [ ] Header check all (`<input type="checkbox" id="checkAll">`).
    - [ ] Body: Checkbox từng dòng.
    - [ ] Cột Hành động: Nút ✅ (Convert) và 🗑️ (Delete).
- [ ] **Pagination**: Thanh phân trang ở dưới cùng.

### 2.2. CSS & Libraries
- [ ] **Select2**: Import CSS/JS của Select2 để làm ô chọn Campaign/LP có tìm kiếm.
- [ ] **Custom CSS**: Style cho các badge trạng thái (nếu chưa có trong template).

### 2.3. JavaScript Logic
- [ ] **Initialize**: Khởi tạo Select2 cho các dropdown.
- [ ] **Cascading Dropdown**: Bắt sự kiện `change` của Campaign -> AJAX lấy list LP -> Cập nhật dropdown LP.
- [ ] **Handle Convert**:
    - [ ] Bắt sự kiện click nút ✅.
    - [ ] Gửi AJAX post.
    - [ ] Xử lý phản hồi:
        - [ ] Success: Toast message "Thành công" + Đổi trạng thái dòng đó sang "Đã xử lý".
        - [ ] Duplicate: Hiện Confirm Dialog (Dùng `confirm()` hoặc SweetAlert).
            - [ ] Nếu User chọn "Vẫn tạo" -> Gửi request với flag `force=true`.
- [ ] **Handle Delete**:
    - [ ] Bắt sự kiện click nút 🗑️.
    - [ ] Confirm Dialog.
    - [ ] True -> AJAX delete -> Xóa dòng khỏi bảng.

## 3. Context Kỹ thuật & Database (Quan trọng cho AI Session sau)

### 3.1. Bảng `LeadSubmissions` (Đã đổi tên & cấu trúc)
Bảng này chứa cả data từ Landing Page (Form SQL) và data nhập thủ công từ Excel.
```sql
CREATE TABLE [dbo].[LeadSubmissions](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [landing_page_id] [int] NULL, -- NULL nếu import từ Excel
    [campaign_id] [int] NOT NULL, -- BẮT BUỘC: Để biết Lead quan tâm Campaign nào
    [source] [nvarchar](255) NULL, -- "Landing Page" hoặc "Import: filename.csv"
    [full_name] [nvarchar](255) NULL,
    [email] [varchar](100) NULL,
    [phone] [varchar](20) NULL,
    [raw_data] [nvarchar](max) NULL, -- Giữ lại để Audit
    [is_processed] [bit] NULL DEFAULT 0, -- 0: Pending, 1: Processed (Converted to Lead)
    [submitted_at] [datetime] NULL DEFAULT getdate(),
    PRIMARY KEY CLUSTERED ([id] ASC)
);
```

### 3.2. Bảng `ImportHistory` (Cần tạo mới - Chống Spam)
Bảng này dùng để track lịch sử import, ngăn chặn spam và duplicate file.
```sql
CREATE TABLE [dbo].[ImportHistory](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [file_name] [nvarchar](255) NOT NULL,
    [file_checksum] [varchar](32) NOT NULL, -- MD5 Hash của file content
    [row_count] [int] NOT NULL,
    [success_count] [int] NOT NULL,
    [error_count] [int] NOT NULL,
    [created_by] [int] NOT NULL, -- User ID thực hiện import
    [created_at] [datetime] DEFAULT getdate(),
    PRIMARY KEY CLUSTERED ([id] ASC)
);
-- Index check spam
CREATE INDEX IDX_CheckSpam_UserDate ON ImportHistory(created_by, created_at);
CREATE INDEX IDX_CheckDuplicate_Checksum ON ImportHistory(file_checksum);
```

## 4. Configuration
- [ ] **Sidebar**: Thêm link "Submissions" vào `sidebar.jsp`.
- [ ] **web.xml** (nếu dùng): Khai báo Servlet (hoặc dùng Annotation `@WebServlet`).
