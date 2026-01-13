<%-- profile.jsp - Trang Hồ sơ cá nhân --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%-- Đặt biến currentPage để highlight menu active --%>
            <% request.setAttribute("currentPage", "profile" ); %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>Hồ sơ cá nhân - CRM System</title>
                    <%@ include file="/includes/head.jsp" %>
                </head>

                <body>
                    <div class="container-xxl position-relative bg-white d-flex p-0">
                        <!-- Spinner Start -->
                        <div id="spinner"
                            class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                            <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                                <span class="sr-only">Loading...</span>
                            </div>
                        </div>
                        <!-- Spinner End -->

                        <%-- Include Sidebar --%>
                            <%@ include file="/includes/sidebar.jsp" %>

                                <!-- Content Start -->
                                <div class="content">
                                    <%-- Include Top Navbar --%>
                                        <%@ include file="/includes/topbar.jsp" %>

                                            <!-- Page Header -->
                                            <div class="container-fluid pt-4 px-4">
                                                <div class="row g-4">
                                                    <div class="col-12">
                                                        <div
                                                            class="d-flex justify-content-between align-items-center mb-4">
                                                            <h3 class="mb-0"><i class="fa fa-user-circle me-2"></i>Hồ sơ
                                                                cá nhân</h3>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Profile Content -->
                                            <div class="container-fluid px-4">
                                                <div class="row g-4">
                                                    <!-- Profile Card -->
                                                    <div class="col-lg-4">
                                                        <div class="bg-light rounded p-4 text-center">
                                                            <div class="position-relative d-inline-block mb-3">
                                                                <img src="${pageContext.request.contextPath}/img/user.jpg"
                                                                    alt="Avatar" class="rounded-circle"
                                                                    style="width: 150px; height: 150px; object-fit: cover; border: 4px solid #fff; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
                                                                <button
                                                                    class="btn btn-primary btn-sm position-absolute bottom-0 end-0 rounded-circle"
                                                                    style="width: 40px; height: 40px;">
                                                                    <i class="fa fa-camera"></i>
                                                                </button>
                                                            </div>
                                                            <h4 class="mb-1">${sessionScope.userName != null ?
                                                                sessionScope.userName : 'Nguyễn Văn A'}</h4>
                                                            <p class="text-muted mb-3">${sessionScope.userRole != null ?
                                                                sessionScope.userRole : 'Sales Manager'}</p>

                                                            <div class="d-flex justify-content-center gap-2 mb-4">
                                                                <span class="badge bg-primary"><i
                                                                        class="fa fa-envelope me-1"></i>Email</span>
                                                                <span class="badge bg-success"><i
                                                                        class="fa fa-check me-1"></i>Verified</span>
                                                            </div>

                                                            <hr>

                                                            <div class="text-start">
                                                                <p class="mb-2"><i
                                                                        class="fa fa-briefcase me-2 text-primary"></i><strong>Phòng
                                                                        ban:</strong> Sales</p>
                                                                <p class="mb-2"><i
                                                                        class="fa fa-calendar me-2 text-primary"></i><strong>Ngày
                                                                        vào:</strong> 01/01/2024</p>
                                                                <p class="mb-0"><i
                                                                        class="fa fa-id-badge me-2 text-primary"></i><strong>Mã
                                                                        NV:</strong> NV001</p>
                                                            </div>
                                                        </div>

                                                        <!-- Stats Card -->
                                                        <div class="bg-light rounded p-4 mt-4">
                                                            <h6 class="mb-3"><i class="fa fa-chart-bar me-2"></i>Thống
                                                                kê cá nhân</h6>
                                                            <div class="row g-3">
                                                                <div class="col-6">
                                                                    <div class="bg-white rounded p-3 text-center">
                                                                        <h4 class="text-primary mb-1">45</h4>
                                                                        <small class="text-muted">Deals</small>
                                                                    </div>
                                                                </div>
                                                                <div class="col-6">
                                                                    <div class="bg-white rounded p-3 text-center">
                                                                        <h4 class="text-success mb-1">$125K</h4>
                                                                        <small class="text-muted">Doanh số</small>
                                                                    </div>
                                                                </div>
                                                                <div class="col-6">
                                                                    <div class="bg-white rounded p-3 text-center">
                                                                        <h4 class="text-warning mb-1">32</h4>
                                                                        <small class="text-muted">Khách hàng</small>
                                                                    </div>
                                                                </div>
                                                                <div class="col-6">
                                                                    <div class="bg-white rounded p-3 text-center">
                                                                        <h4 class="text-info mb-1">89%</h4>
                                                                        <small class="text-muted">Tỷ lệ chốt</small>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Profile Form -->
                                                    <div class="col-lg-8">
                                                        <div class="bg-light rounded p-4">
                                                            <h5 class="mb-4"><i class="fa fa-edit me-2"></i>Thông tin cá
                                                                nhân</h5>

                                                            <form action="${pageContext.request.contextPath}/profile"
                                                                method="post">
                                                                <div class="row g-3">
                                                                    <div class="col-md-6">
                                                                        <label class="form-label">Họ và tên</label>
                                                                        <input type="text" class="form-control"
                                                                            name="fullName"
                                                                            value="${sessionScope.userName != null ? sessionScope.userName : 'Nguyễn Văn A'}">
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <label class="form-label">Email</label>
                                                                        <input type="email" class="form-control"
                                                                            name="email" value="nguyenvana@company.com">
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <label class="form-label">Số điện thoại</label>
                                                                        <input type="tel" class="form-control"
                                                                            name="phone" value="0901234567">
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <label class="form-label">Ngày sinh</label>
                                                                        <input type="date" class="form-control"
                                                                            name="birthday" value="1990-01-15">
                                                                    </div>
                                                                    <div class="col-12">
                                                                        <label class="form-label">Địa chỉ</label>
                                                                        <input type="text" class="form-control"
                                                                            name="address"
                                                                            value="123 Nguyễn Huệ, Quận 1, TP.HCM">
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <label class="form-label">Phòng ban</label>
                                                                        <select class="form-select" name="department"
                                                                            disabled>
                                                                            <option value="sales" selected>Sales
                                                                            </option>
                                                                            <option value="marketing">Marketing</option>
                                                                            <option value="support">Support</option>
                                                                        </select>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <label class="form-label">Chức vụ</label>
                                                                        <input type="text" class="form-control"
                                                                            name="position" value="Sales Manager"
                                                                            disabled>
                                                                    </div>
                                                                </div>

                                                                <hr class="my-4">

                                                                <div class="d-flex justify-content-end gap-2">
                                                                    <button type="reset" class="btn btn-secondary">
                                                                        <i class="fa fa-undo me-2"></i>Hoàn tác
                                                                    </button>
                                                                    <button type="submit" class="btn btn-primary">
                                                                        <i class="fa fa-save me-2"></i>Lưu thay đổi
                                                                    </button>
                                                                </div>
                                                            </form>
                                                        </div>

                                                        <!-- Change Password -->
                                                        <div class="bg-light rounded p-4 mt-4">
                                                            <h5 class="mb-4"><i class="fa fa-lock me-2"></i>Đổi mật khẩu
                                                            </h5>

                                                            <form
                                                                action="${pageContext.request.contextPath}/profile/password"
                                                                method="post">
                                                                <div class="row g-3">
                                                                    <div class="col-md-4">
                                                                        <label class="form-label">Mật khẩu hiện
                                                                            tại</label>
                                                                        <input type="password" class="form-control"
                                                                            name="currentPassword" required>
                                                                    </div>
                                                                    <div class="col-md-4">
                                                                        <label class="form-label">Mật khẩu mới</label>
                                                                        <input type="password" class="form-control"
                                                                            name="newPassword" required>
                                                                    </div>
                                                                    <div class="col-md-4">
                                                                        <label class="form-label">Xác nhận mật
                                                                            khẩu</label>
                                                                        <input type="password" class="form-control"
                                                                            name="confirmPassword" required>
                                                                    </div>
                                                                </div>

                                                                <div class="mt-3">
                                                                    <button type="submit" class="btn btn-warning">
                                                                        <i class="fa fa-key me-2"></i>Đổi mật khẩu
                                                                    </button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <%-- Include Footer --%>
                                                <%@ include file="/includes/footer.jsp" %>
                                </div>
                                <!-- Content End -->

                                <!-- Back to Top -->
                                <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                        class="bi bi-arrow-up"></i></a>
                    </div>

                    <%-- Include Scripts --%>
                        <%@ include file="/includes/scripts.jsp" %>

                            <!-- Inline script để đảm bảo ẩn spinner -->
                            <script>
                                document.addEventListener('DOMContentLoaded', function () {
                                    var spinner = document.getElementById('spinner');
                                    if (spinner) {
                                        spinner.classList.remove('show');
                                    }
                                });
                            </script>
                </body>

                </html>