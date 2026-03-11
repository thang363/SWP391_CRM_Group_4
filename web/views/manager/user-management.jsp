<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("currentPage", "user-management"); %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <title>Quản lý người dùng - CRM System</title>
    <%@ include file="/includes/head.jsp" %>
    <style>
        .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .role-badge-manager { background-color: #dc3545; }
        .role-badge-sale { background-color: #0d6efd; }
        .role-badge-marketing { background-color: #6f42c1; }
        .role-badge-support { background-color: #198754; }

        .status-active { color: #198754; }
        .status-inactive { color: #dc3545; }

        .btn-action {
            padding: 4px 8px;
            font-size: 0.8rem;
            border-radius: 4px;
        }

        .table > tbody > tr > td {
            vertical-align: middle;
        }

        .password-requirements {
            font-size: 0.8rem;
            color: #6c757d;
        }

        .password-requirements li.valid {
            color: #198754;
        }

        .password-requirements li.invalid {
            color: #dc3545;
        }
    </style>
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

        <%@ include file="/includes/sidebar.jsp" %>

        <!-- Content Start -->
        <div class="content">
            <%@ include file="/includes/topbar.jsp" %>

            <!-- Page Header -->
            <div class="container-fluid pt-4 px-4">
                <div class="row g-4">
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="mb-0"><i class="fa fa-user-cog me-2 text-primary"></i>Quản lý người dùng</h3>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                                <i class="fa fa-plus me-2"></i>Thêm người dùng
                            </button>
                        </div>

                        <%-- Alerts --%>
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fa fa-check-circle me-2"></i>${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fa fa-exclamation-circle me-2"></i>${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- User Statistics -->
            <div class="container-fluid px-4">
                <div class="row g-4 mb-4">
                    <div class="col-sm-6 col-xl-3">
                        <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-primary border-4">
                            <i class="fa fa-users fa-3x text-primary"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2 text-muted fw-bold">Tổng người dùng</p>
                                <h4 class="mb-0">${users.size()}</h4>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-3">
                        <c:set var="activeCount" value="0" />
                        <c:forEach var="u" items="${users}">
                            <c:if test="${u.status == 'Active'}">
                                <c:set var="activeCount" value="${activeCount + 1}" />
                            </c:if>
                        </c:forEach>
                        <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-success border-4">
                            <i class="fa fa-user-check fa-3x text-success"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2 text-muted fw-bold">Đang hoạt động</p>
                                <h4 class="mb-0">${activeCount}</h4>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-3">
                        <c:set var="inactiveCount" value="0" />
                        <c:forEach var="u" items="${users}">
                            <c:if test="${u.status != 'Active'}">
                                <c:set var="inactiveCount" value="${inactiveCount + 1}" />
                            </c:if>
                        </c:forEach>
                        <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-danger border-4">
                            <i class="fa fa-user-times fa-3x text-danger"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2 text-muted fw-bold">Ngừng hoạt động</p>
                                <h4 class="mb-0">${inactiveCount}</h4>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-3">
                        <c:set var="managerCount" value="0" />
                        <c:forEach var="u" items="${users}">
                            <c:if test="${u.role == 'MANAGER'}">
                                <c:set var="managerCount" value="${managerCount + 1}" />
                            </c:if>
                        </c:forEach>
                        <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-warning border-4">
                            <i class="fa fa-user-shield fa-3x text-warning"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2 text-muted fw-bold">Quản lý</p>
                                <h4 class="mb-0">${managerCount}</h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- User Table -->
            <div class="container-fluid px-4">
                <div class="bg-light rounded p-4 shadow-sm">
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <h6 class="mb-0 fw-bold"><i class="fa fa-list me-2"></i>Danh sách người dùng</h6>
                    </div>

                    <div class="table-responsive">
                        <table class="table text-start align-middle table-hover mb-0" id="userTable">
                            <thead class="table-light">
                                <tr class="text-dark text-nowrap">
                                    <th scope="col">#</th>
                                    <th scope="col">Họ tên</th>
                                    <th scope="col">Username</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">SĐT</th>
                                    <th scope="col" class="text-center">Vai trò</th>
                                    <th scope="col" class="text-center">Trạng thái</th>
                                    <th scope="col">Ngày tạo</th>
                                    <th scope="col" class="text-center">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty users}">
                                        <tr>
                                            <td colspan="9" class="text-center py-4 text-muted">Chưa có người dùng nào.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="u" items="${users}" varStatus="loop">
                                            <tr>
                                                <td>${loop.index + 1}</td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="user-avatar me-2">
                                                            ${u.fullName.substring(0,1).toUpperCase()}
                                                        </div>
                                                        <strong>${u.fullName}</strong>
                                                    </div>
                                                </td>
                                                <td><code>${u.username}</code></td>
                                                <td>${u.email}</td>
                                                <td>${u.phone != null ? u.phone : '-'}</td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${u.role == 'MANAGER'}">
                                                            <span class="badge role-badge-manager">Quản lý</span>
                                                        </c:when>
                                                        <c:when test="${u.role == 'SALE'}">
                                                            <span class="badge role-badge-sale">Kinh doanh</span>
                                                        </c:when>
                                                        <c:when test="${u.role == 'MARKETING'}">
                                                            <span class="badge role-badge-marketing">Tiếp thị</span>
                                                        </c:when>
                                                        <c:when test="${u.role == 'SUPPORT'}">
                                                            <span class="badge role-badge-support">Hỗ trợ</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${u.role}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${u.status == 'Active'}">
                                                            <span class="badge bg-success"><i class="fa fa-check-circle me-1"></i>Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger"><i class="fa fa-times-circle me-1"></i>Ngừng HĐ</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-nowrap">${u.createdAt}</td>
                                                <td class="text-center text-nowrap">
                                                    <!-- Edit Button -->
                                                    <button class="btn btn-sm btn-outline-primary btn-action me-1 btn-edit-user"
                                                            title="Sửa thông tin"
                                                            data-id="${u.id}"
                                                            data-fullname="${u.fullName}"
                                                            data-email="${u.email}"
                                                            data-phone="${u.phone}"
                                                            data-role="${u.role.value}"
                                                            data-status="${u.status}"
                                                            data-username="${u.username}">
                                                        <i class="fa fa-edit"></i>
                                                    </button>
                                                    <!-- Reset Password Button -->
                                                    <button class="btn btn-sm btn-outline-warning btn-action me-1 btn-reset-pwd"
                                                            title="Reset mật khẩu"
                                                            data-id="${u.id}"
                                                            data-fullname="${u.fullName}">
                                                        <i class="fa fa-key"></i>
                                                    </button>
                                                    <!-- Toggle Status Button -->
                                                    <c:if test="${u.id != sessionScope.userId}">
                                                        <c:choose>
                                                            <c:when test="${u.status == 'Active'}">
                                                                <button type="button" class="btn btn-sm btn-outline-danger btn-action btn-toggle-status"
                                                                        title="Vô hiệu hóa"
                                                                        data-id="${u.id}"
                                                                        data-fullname="${u.fullName}"
                                                                        data-action-type="deactivate">
                                                                    <i class="fa fa-ban"></i>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-sm btn-outline-success btn-action btn-toggle-status"
                                                                        title="Kích hoạt"
                                                                        data-id="${u.id}"
                                                                        data-fullname="${u.fullName}"
                                                                        data-action-type="activate">
                                                                    <i class="fa fa-check"></i>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <%-- Footer --%>
            <%@ include file="/includes/footer.jsp" %>
        </div>
        <!-- Content End -->

        <!-- Back to Top -->
        <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>
    </div>

    <!-- ===================== MODALS ===================== -->

    <!-- Modal: Thêm người dùng mới -->
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/users" id="addUserForm">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="addUserModalLabel"><i class="fa fa-user-plus me-2"></i>Thêm người dùng mới</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="username" required
                                       pattern="^[a-zA-Z0-9_]{3,50}$"
                                       title="3-50 ký tự, chỉ gồm chữ, số và dấu gạch dưới">
                                <div class="form-text">3-50 ký tự, chỉ chữ, số và dấu gạch dưới</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="fullName" required minlength="2" maxlength="100">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" name="email" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" name="phone" pattern="^0[0-9]{9,10}$"
                                       title="Bắt đầu bằng 0, 10-11 chữ số">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Vai trò <span class="text-danger">*</span></label>
                                <select class="form-select" name="role" required>
                                    <option value="">-- Chọn vai trò --</option>
                                    <option value="Manager">Quản lý</option>
                                    <option value="Sale">Kinh doanh</option>
                                    <option value="Marketing">Tiếp thị</option>
                                    <option value="Support">Hỗ trợ</option>
                                </select>
                            </div>
                            <div class="col-md-6"></div>
                            <div class="col-md-6">
                                <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="password" class="form-control" name="password" id="addPassword" required
                                           minlength="6" oninput="validateAddPassword()">
                                    <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('addPassword', this)">
                                        <i class="fa fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="password" class="form-control" name="confirmPassword" id="addConfirmPassword" required
                                           minlength="6" oninput="validateAddPassword()">
                                    <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('addConfirmPassword', this)">
                                        <i class="fa fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-12">
                                <ul class="password-requirements list-unstyled mb-0" id="addPwdReqs">
                                    <li id="addReqLength"><i class="fa fa-circle me-1" style="font-size: 0.5rem;"></i> Ít nhất 6 ký tự</li>
                                    <li id="addReqLetter"><i class="fa fa-circle me-1" style="font-size: 0.5rem;"></i> Có chứa chữ cái</li>
                                    <li id="addReqDigit"><i class="fa fa-circle me-1" style="font-size: 0.5rem;"></i> Có chứa chữ số</li>
                                    <li id="addReqMatch"><i class="fa fa-circle me-1" style="font-size: 0.5rem;"></i> Mật khẩu khớp nhau</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fa fa-times me-1"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-primary" id="addUserBtn">
                            <i class="fa fa-save me-1"></i>Tạo người dùng
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal: Sửa thông tin -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/users" id="editUserForm">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="userId" id="editUserId">
                    <div class="modal-header bg-info text-white">
                        <h5 class="modal-title" id="editUserModalLabel"><i class="fa fa-edit me-2"></i>Sửa thông tin người dùng</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Tên đăng nhập</label>
                                <input type="text" class="form-control" id="editUsername" disabled>
                                <div class="form-text">Không thể thay đổi username</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="fullName" id="editFullName" required minlength="2" maxlength="100">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" name="email" id="editEmail" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" name="phone" id="editPhone" pattern="^0[0-9]{9,10}$">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Vai trò <span class="text-danger">*</span></label>
                                <select class="form-select" name="role" id="editRole" required>
                                    <option value="Manager">Quản lý</option>
                                    <option value="Sale">Kinh doanh</option>
                                    <option value="Marketing">Tiếp thị</option>
                                    <option value="Support">Hỗ trợ</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Trạng thái</label>
                                <select class="form-select" name="status" id="editStatus">
                                    <option value="Active">Đang hoạt động</option>
                                    <option value="Inactive">Ngừng hoạt động</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fa fa-times me-1"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-info text-white">
                            <i class="fa fa-save me-1"></i>Cập nhật
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal: Reset mật khẩu -->
    <div class="modal fade" id="resetPasswordModal" tabindex="-1" aria-labelledby="resetPasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/users" id="resetPasswordForm">
                    <input type="hidden" name="action" value="resetPassword">
                    <input type="hidden" name="userId" id="resetUserId">
                    <div class="modal-header bg-warning">
                        <h5 class="modal-title" id="resetPasswordModalLabel"><i class="fa fa-key me-2"></i>Reset mật khẩu</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-info py-2">
                            <i class="fa fa-info-circle me-1"></i>
                            Đặt mật khẩu mới cho: <strong id="resetUserName"></strong>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mật khẩu mới <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="password" class="form-control" name="newPassword" id="resetNewPassword"
                                       required minlength="6" oninput="validateResetPassword()">
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('resetNewPassword', this)">
                                    <i class="fa fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="password" class="form-control" name="confirmNewPassword" id="resetConfirmPassword"
                                       required minlength="6" oninput="validateResetPassword()">
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('resetConfirmPassword', this)">
                                    <i class="fa fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        <ul class="password-requirements list-unstyled mb-0" id="resetPwdReqs">
                            <li id="resetReqLength"><i class="fa fa-circle me-1" style="font-size: 0.5rem;"></i> Ít nhất 6 ký tự</li>
                            <li id="resetReqLetter"><i class="fa fa-circle me-1" style="font-size: 0.5rem;"></i> Có chứa chữ cái</li>
                            <li id="resetReqDigit"><i class="fa fa-circle me-1" style="font-size: 0.5rem;"></i> Có chứa chữ số</li>
                            <li id="resetReqMatch"><i class="fa fa-circle me-1" style="font-size: 0.5rem;"></i> Mật khẩu khớp nhau</li>
                        </ul>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fa fa-times me-1"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-warning" id="resetPwdBtn">
                            <i class="fa fa-key me-1"></i>Reset mật khẩu
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal: Xác nhận thay đổi trạng thái -->
    <div class="modal fade" id="confirmToggleModal" tabindex="-1" aria-labelledby="confirmToggleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header" id="confirmToggleHeader">
                    <h5 class="modal-title" id="confirmToggleModalLabel"><i class="fa fa-exclamation-triangle me-2"></i>Xác nhận</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-0" id="confirmToggleMessage"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fa fa-times me-1"></i>Hủy
                    </button>
                    <button type="button" class="btn" id="confirmToggleBtn">
                        <i class="fa fa-check me-1"></i>Xác nhận
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden form for toggle status submit -->
    <form method="post" action="${pageContext.request.contextPath}/users" id="toggleStatusForm" style="display:none;">
        <input type="hidden" name="action" value="toggleStatus">
        <input type="hidden" name="userId" id="toggleUserId">
    </form>

    <%-- Scripts --%>
    <%@ include file="/includes/scripts.jsp" %>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var spinner = document.getElementById('spinner');
            if (spinner) {
                spinner.classList.remove('show');
            }

            // Event delegation for Edit buttons
            document.querySelectorAll('.btn-edit-user').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var d = this.dataset;
                    document.getElementById('editUserId').value = d.id;
                    document.getElementById('editUsername').value = d.username;
                    document.getElementById('editFullName').value = d.fullname;
                    document.getElementById('editEmail').value = d.email;
                    document.getElementById('editPhone').value = d.phone || '';

                    var roleSelect = document.getElementById('editRole');
                    for (var i = 0; i < roleSelect.options.length; i++) {
                        if (roleSelect.options[i].value === d.role) {
                            roleSelect.selectedIndex = i;
                            break;
                        }
                    }

                    var statusSelect = document.getElementById('editStatus');
                    for (var i = 0; i < statusSelect.options.length; i++) {
                        if (statusSelect.options[i].value === d.status) {
                            statusSelect.selectedIndex = i;
                            break;
                        }
                    }

                    new bootstrap.Modal(document.getElementById('editUserModal')).show();
                });
            });

            // Event delegation for Reset Password buttons
            document.querySelectorAll('.btn-reset-pwd').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var d = this.dataset;
                    document.getElementById('resetUserId').value = d.id;
                    document.getElementById('resetUserName').textContent = d.fullname;
                    document.getElementById('resetNewPassword').value = '';
                    document.getElementById('resetConfirmPassword').value = '';
                    resetPasswordValidation('reset');
                    new bootstrap.Modal(document.getElementById('resetPasswordModal')).show();
                });
            });
            // Event delegation for Toggle Status buttons
            document.querySelectorAll('.btn-toggle-status').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var d = this.dataset;
                    var isDeactivate = d.actionType === 'deactivate';
                    var header = document.getElementById('confirmToggleHeader');
                    var message = document.getElementById('confirmToggleMessage');
                    var confirmBtn = document.getElementById('confirmToggleBtn');

                    if (isDeactivate) {
                        header.className = 'modal-header bg-danger text-white';
                        message.innerHTML = '<i class="fa fa-exclamation-circle text-danger me-2"></i>Bạn có chắc muốn <strong>vô hiệu hóa</strong> tài khoản <strong>' + d.fullname + '</strong>?';
                        confirmBtn.className = 'btn btn-danger';
                    } else {
                        header.className = 'modal-header bg-success text-white';
                        message.innerHTML = '<i class="fa fa-check-circle text-success me-2"></i>Bạn có chắc muốn <strong>kích hoạt</strong> tài khoản <strong>' + d.fullname + '</strong>?';
                        confirmBtn.className = 'btn btn-success';
                    }

                    document.getElementById('toggleUserId').value = d.id;

                    // Remove old handler and add new
                    var newBtn = confirmBtn.cloneNode(true);
                    confirmBtn.parentNode.replaceChild(newBtn, confirmBtn);
                    newBtn.addEventListener('click', function() {
                        document.getElementById('toggleStatusForm').submit();
                    });

                    new bootstrap.Modal(document.getElementById('confirmToggleModal')).show();
                });
            });
        });

        // Toggle password visibility
        function togglePassword(inputId, btn) {
            var input = document.getElementById(inputId);
            var icon = btn.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        // Password validation for Add form
        function validateAddPassword() {
            var pwd = document.getElementById('addPassword').value;
            var confirm = document.getElementById('addConfirmPassword').value;
            validatePasswordUI(pwd, confirm, 'add');
        }

        // Password validation for Reset form
        function validateResetPassword() {
            var pwd = document.getElementById('resetNewPassword').value;
            var confirm = document.getElementById('resetConfirmPassword').value;
            validatePasswordUI(pwd, confirm, 'reset');
        }

        function validatePasswordUI(pwd, confirm, prefix) {
            var hasLength = pwd.length >= 6;
            var hasLetter = /[a-zA-Z]/.test(pwd);
            var hasDigit = /[0-9]/.test(pwd);
            var isMatch = pwd === confirm && pwd.length > 0;

            setReqClass(prefix + 'ReqLength', hasLength);
            setReqClass(prefix + 'ReqLetter', hasLetter);
            setReqClass(prefix + 'ReqDigit', hasDigit);
            setReqClass(prefix + 'ReqMatch', isMatch);
        }

        function setReqClass(elemId, isValid) {
            var elem = document.getElementById(elemId);
            if (elem) {
                elem.classList.toggle('valid', isValid);
                elem.classList.toggle('invalid', !isValid);
            }
        }

        function resetPasswordValidation(prefix) {
            ['Length', 'Letter', 'Digit', 'Match'].forEach(function(req) {
                var elem = document.getElementById(prefix + 'Req' + req);
                if (elem) {
                    elem.classList.remove('valid', 'invalid');
                }
            });
        }
    </script>
</body>

</html>
