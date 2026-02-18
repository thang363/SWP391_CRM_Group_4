# Logic Trạng Thái: Campaign ↔ Landing Page

## 1. Tổng Quan

Mỗi **Campaign** (Chiến dịch) có thể chứa một hoặc nhiều **Landing Page** (LP). Trạng thái của Campaign ảnh hưởng trực tiếp đến khả năng hiển thị công khai của LP.

## 2. Danh Sách Trạng Thái

### Campaign Status
| Status | Ý nghĩa |
|:---|:---|
| **Draft** | Nháp – đang soạn thảo |
| **Active** | Đang chạy chiến dịch |
| **Paused** | Chiến dịch tạm dừng (do Manager set). |
| **Finished** | Chiến dịch đã kết thúc (tự động set khi hết hạn). |

### Landing Page Status
| Status | Ý nghĩa |
|:---|:---|
| **Draft** | Nháp – đang thiết kế nội dung |
| **Pending** | Chờ Manager duyệt |
| **Approved** | Đã duyệt nội dung |
| **Active** | Đang hoạt động (Public) |
| **Rejected** | Bị từ chối |

## 3. Quy Tắc Hiển Thị Công Khai (Public Access)

LP được hiển thị tại URL `/lp/{id}` theo logic sau:

```
Khách hàng truy cập /lp/{id}
    │
    ├── Campaign.status == "Active"?
    │       ├── CÓ → LP.status == "Active"?
    │       │       ├── CÓ → ✅ Hiển thị trang
    │       │       └── KHÔNG → ❌ 403 Forbidden
    │       │
    │       └── KHÔNG → Người dùng đã đăng nhập (Staff/Manager)?
    │               ├── CÓ → ✅ Cho xem (để kiểm tra/preview)
    │               └── KHÔNG → ❌ 403 Forbidden
```

> **Tóm lại:**
> - **Khách hàng**: Chỉ xem được khi `Campaign = Active` **VÀ** `LP = Active`.
> - **Nhân viên CRM** (đã đăng nhập): Xem được mọi lúc, kể cả khi Campaign đang Draft/Finished.

## 4. Quy Tắc Chuyển Đổi Trạng Thái Campaign

Manager là cấp cao nhất, **không cần gửi duyệt** cho ai. Do đó, Manager có thể chuyển đổi tự do giữa các trạng thái:

```
Draft ──► Active ──► Paused ──► Active (chạy lại)
                 ──► Finished
Draft ──► Cancelled
Active ──► Cancelled
```

> Không bắt buộc phải đi theo thứ tự. Manager có thể set trực tiếp từ Draft sang Finished nếu cần.

## 5. File Code Liên Quan

| File | Vai trò |
|:---|:---|
| `CampaignServiceImpl.java` | Validate danh sách status hợp lệ cho Campaign |
| `PublicLandingPageServlet.java` | Kiểm tra Campaign + LP status trước khi hiển thị cho khách |
| `campaigns.jsp` | UI Filter và Modal chỉ hiển thị các status hợp lệ |
| `campaigns.js` | Populate/Reset status field trong Edit/Create modal |

## 6. Ràng Buộc Database

Cột `Campaigns.status` là `VARCHAR(20)` — **không có CHECK constraint** ở tầng DB. Toàn bộ validate nằm ở tầng **Application (Java Service)**.
