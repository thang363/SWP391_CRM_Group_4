<%-- profile.jsp - Trang Hồ sơ cá nhân --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
                                <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;"
                                    role="status">
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
                                                                <h3 class="mb-0"><i
                                                                        class="fa fa-user-circle me-2"></i>Hồ sơ cá nhân
                                                                </h3>
                                                            </div>

                                                            <%-- Alerts --%>
                                                                <c:if test="${not empty successMessage}">
                                                                    <div class="alert alert-success alert-dismissible fade show"
                                                                        role="alert">
                                                                        <i
                                                                            class="fa fa-check-circle me-2"></i>${successMessage}
                                                                        <% session.removeAttribute("successMessage"); %>
                                                                            <button type="button" class="btn-close"
                                                                                data-bs-dismiss="alert"
                                                                                aria-label="Close"></button>
                                                                    </div>
                                                                </c:if>
                                                                <c:if test="${not empty errorMessage}">
                                                                    <div class="alert alert-danger alert-dismissible fade show"
                                                                        role="alert">
                                                                        <i
                                                                            class="fa fa-exclamation-circle me-2"></i>${errorMessage}
                                                                        <button type="button" class="btn-close"
                                                                            data-bs-dismiss="alert"
                                                                            aria-label="Close"></button>
                                                                    </div>
                                                                </c:if>
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
                                                                </div>
                                                                <h4 class="mb-1">${user.fullName}</h4>
                                                                <p class="text-muted mb-3">${user.role}</p>

                                                                <div class="d-flex justify-content-center gap-2 mb-4">
                                                                    <span class="badge bg-primary"><i
                                                                            class="fa fa-envelope me-1"></i>${user.email}</span>
                                                                    <span class="badge bg-success"><i
                                                                            class="fa fa-check me-1"></i>${user.status}</span>
                                                                </div>

                                                                <hr>

                                                                <div class="text-start">
                                                                    <p class="mb-2"><i
                                                                            class="fa fa-id-badge me-2 text-primary"></i><strong>Username:</strong>
                                                                        ${user.username}</p>
                                                                    <p class="mb-2"><i
                                                                            class="fa fa-phone me-2 text-primary"></i><strong>SĐT:</strong>
                                                                        ${user.phone}</p>
                                                                    <p class="mb-0"><i
                                                                            class="fa fa-calendar me-2 text-primary"></i><strong>Ngày
                                                                            tạo:</strong> ${user.createdAt}</p>
                                                                </div>
                                                            </div>

                                                            <!-- Stats Card (Placeholder) -->
                                                            <div class="bg-light rounded p-4 mt-4">
                                                                <h6 class="mb-3"><i
                                                                        class="fa fa-chart-bar me-2"></i>Thống kê cá
                                                                    nhân</h6>
                                                                <div class="row g-3">
                                                                    <div class="col-6">
                                                                        <div class="bg-white rounded p-3 text-center">
                                                                            <h4 class="text-primary mb-1">-</h4>
                                                                            <small class="text-muted">Tasks</small>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <div class="bg-white rounded p-3 text-center">
                                                                            <h4 class="text-success mb-1">-</h4>
                                                                            <small class="text-muted">Perf</small>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Profile Form -->
                                                        <div class="col-lg-8">
                                                            <div class="bg-light rounded p-4">
                                                                <h5 class="mb-4"><i class="fa fa-edit me-2"></i>Thông
                                                                    tin cá nhân</h5>

                                                                <form
                                                                    action="${pageContext.request.contextPath}/profile"
                                                                    method="post">
                                                                    <div class="row g-3">
                                                                        <div class="col-md-6">
                                                                            <label class="form-label">Họ và tên</label>
                                                                            <input type="text" class="form-control"
                                                                                name="fullName" value="${user.fullName}"
                                                                                required>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label class="form-label">Email</label>
                                                                            <input type="email" class="form-control"
                                                                                name="email" value="${user.email}"
                                                                                required>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label class="form-label">Số điện
                                                                                thoại</label>
                                                                            <input type="tel" class="form-control"
                                                                                name="phone" value="${user.phone}"
                                                                                pattern="^0[0-9]{9,10}$">
                                                                            <div class="invalid-feedback">
                                                                                Số điện thoại phải bắt đầu bằng 0 và có
                                                                                10-11 chữ số.
                                                                            </div>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label class="form-label">Vai trò</label>
                                                                            <input type="text" class="form-control"
                                                                                value="${user.role}" disabled>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label class="form-label">Tên đăng
                                                                                nhập</label>
                                                                            <input type="text" class="form-control"
                                                                                value="${user.username}" disabled>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label class="form-label">Trạng thái</label>
                                                                            <input type="text" class="form-control"
                                                                                value="${user.status}" disabled>
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

                                                            <!-- Defer Password Change -->
                                                            <div class="bg-light rounded p-4 mt-4 opacity-50">
                                                                <h5 class="mb-4"><i class="fa fa-lock me-2"></i>Đổi mật
                                                                    khẩu (Sắp ra mắt)</h5>
                                                                <p class="text-muted">Tính năng đổi mật khẩu đang được
                                                                    phát triển.</p>
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

                                <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        var spinner = document.getElementById('spinner');
                                        if (spinner) {
                                            spinner.classList.remove('show');
                                        }

                                        // Bootstrap validation
                                        var forms = document.querySelectorAll('.needs-validation');
                                        Array.prototype.slice.call(forms).forEach(function (form) {
                                            form.addEventListener('submit', function (event) {
                                                if (!form.checkValidity()) {
                                                    event.preventDefault();
                                                    event.stopPropagation();
                                                }
                                                form.classList.add('was-validated');
                                            }, false);
                                        });
                                    });
                                </script>
                    </body>

                    </html>