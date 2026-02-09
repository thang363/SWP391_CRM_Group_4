<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <%@ include file="/includes/head.jsp" %>
                <title>Quản lý Landing Page - CRM</title>
        </head>

        <body>
            <div class="container-xxl position-relative bg-white d-flex p-0">
                <!-- Spinner Start -->
                <div id="spinner"
                    class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                    <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
                <!-- Spinner End -->

                <%@ include file="/includes/sidebar.jsp" %>

                    <!-- Content Start -->
                    <div class="content">
                        <%@ include file="/includes/topbar.jsp" %>

                            <!-- Landing Pages List Start -->
                            <div class="container-fluid pt-4 px-4">
                                <div class="row g-4">
                                    <div class="col-12">
                                        <div class="bg-light rounded h-100 p-4">
                                            <div class="d-flex justify-content-between align-items-center mb-4">
                                                <h4 class="mb-0">
                                                    <i class="fa fa-file-code me-2"></i>Quản lý Landing Page
                                                </h4>
                                                <button class="btn btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#createLPModal">
                                                    <i class="fa fa-plus me-2"></i>Tạo LP mới
                                                </button>
                                            </div>

                                            <!-- Filter Section -->
                                            <form id="filterForm" method="GET"
                                                action="${pageContext.request.contextPath}/landing-pages" class="mb-4">
                                                <div class="row g-3 align-items-end">
                                                    <div class="col-md-4">
                                                        <label class="form-label">Lọc theo Chiến dịch</label>
                                                        <select class="form-select" name="campaignId"
                                                            onchange="this.form.submit()">
                                                            <option value="">-- Tất cả --</option>
                                                            <c:forEach var="c" items="${campaigns}">
                                                                <option value="${c.id}" ${campaignIdFilter eq c.id
                                                                    ? 'selected' : '' }>${c.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <a href="${pageContext.request.contextPath}/landing-pages"
                                                            class="btn btn-outline-secondary w-100">
                                                            <i class="fa fa-refresh me-1"></i>Reset
                                                        </a>
                                                    </div>
                                                </div>
                                            </form>

                                            <!-- Table -->
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Tên LP</th>
                                                            <th>Chiến dịch</th>
                                                            <th>Người phụ trách</th>
                                                            <th>Trạng thái</th>
                                                            <th>Ngày tạo</th>
                                                            <th>Lượt xem</th>
                                                            <th>Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:choose>
                                                            <c:when test="${empty landingPages}">
                                                                <tr>
                                                                    <td colspan="8" class="text-center text-muted py-4">
                                                                        <i class="fa fa-inbox fa-3x mb-3 d-block"></i>
                                                                        Chưa có Landing Page nào.
                                                                    </td>
                                                                </tr>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach var="lp" items="${landingPages}">
                                                                    <tr>
                                                                        <td>${lp.id}</td>
                                                                        <td>
                                                                            <strong>${lp.name}</strong>
                                                                        </td>
                                                                        <td>
                                                                            <a href="${pageContext.request.contextPath}/landing-pages?campaignId=${lp.campaignId}"
                                                                                class="text-decoration-none">
                                                                                ${lp.campaignName}
                                                                            </a>
                                                                        </td>
                                                                        <td>
                                                                            <i
                                                                                class="fa fa-user me-1"></i>${lp.createdByName}
                                                                        </td>
                                                                        <td>
                                                                            <span
                                                                                class="badge bg-${lp.statusBadgeClass}">${lp.status}</span>
                                                                        </td>
                                                                        <td>${lp.formattedCreatedAt}</td>
                                                                        <td>
                                                                            <span
                                                                                class="badge bg-secondary">${lp.viewCount}</span>
                                                                        </td>
                                                                        <td>
                                                                            <div class="btn-group btn-group-sm">
                                                                                <a href="#"
                                                                                    class="btn btn-outline-primary"
                                                                                    title="Xem trước">
                                                                                    <i class="fa fa-eye"></i>
                                                                                </a>
                                                                                <a href="#"
                                                                                    class="btn btn-outline-warning"
                                                                                    title="Chỉnh sửa">
                                                                                    <i class="fa fa-edit"></i>
                                                                                </a>
                                                                                <button type="button"
                                                                                    class="btn btn-outline-danger"
                                                                                    onclick="confirmDelete(${lp.id}, '${lp.name}')"
                                                                                    title="Xóa">
                                                                                    <i class="fa fa-trash"></i>
                                                                                </button>
                                                                            </div>
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
                                </div>
                            </div>
                            <!-- Landing Pages List End -->

                            <%@ include file="/includes/footer.jsp" %>
                    </div>
                    <!-- Content End -->
            </div>

            <!-- Create LP Modal -->
            <div class="modal fade" id="createLPModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="fa fa-plus-circle me-2"></i>Tạo Landing Page Mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="createLPForm">
                                <div class="mb-3">
                                    <label for="campaignSelect" class="form-label">Chiến dịch <span
                                            class="text-danger">*</span></label>
                                    <select class="form-select" id="campaignSelect" name="campaignId" required>
                                        <option value="">-- Chọn Chiến dịch --</option>
                                        <c:forEach var="c" items="${campaigns}">
                                            <option value="${c.id}">${c.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="marketingSelect" class="form-label">Nhân viên phụ trách <span
                                            class="text-danger">*</span></label>
                                    <select class="form-select" id="marketingSelect" name="marketingId" required>
                                        <option value="">-- Chọn Nhân viên --</option>
                                        <c:forEach var="staff" items="${marketingStaffs}">
                                            <option value="${staff.id}">${staff.fullName} (${staff.email})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="briefInput" class="form-label">Mô tả / Yêu cầu</label>
                                    <textarea class="form-control" id="briefInput" name="brief" rows="3"
                                        placeholder="Nhập mô tả yêu cầu thiết kế..." maxlength="2000"></textarea>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-primary" onclick="submitCreateLP()">
                                <i class="fa fa-paper-plane me-2"></i>Tạo LP
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <%@ include file="/includes/scripts.jsp" %>

                <script>
                    const contextPath = '${pageContext.request.contextPath}';

                    function submitCreateLP() {
                        const campaignId = document.getElementById('campaignSelect').value;
                        const marketingId = document.getElementById('marketingSelect').value;
                        const brief = document.getElementById('briefInput').value;

                        if (!campaignId || !marketingId) {
                            alert('Vui lòng chọn Chiến dịch và Nhân viên phụ trách');
                            return;
                        }

                        const params = new URLSearchParams();
                        params.append('action', 'create');
                        params.append('campaignId', campaignId);
                        params.append('marketingId', marketingId);
                        params.append('brief', brief);

                        fetch(contextPath + '/landing-pages', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                            body: params
                        })
                            .then(res => res.json())
                            .then(result => {
                                if (result.success) {
                                    alert('Tạo Landing Page thành công!');
                                    window.location.reload();
                                } else {
                                    alert(result.message || 'Lỗi khi tạo Landing Page');
                                }
                            })
                            .catch(err => {
                                console.error('Error:', err);
                                alert('Có lỗi xảy ra: ' + err.message);
                            });
                    }

                    function confirmDelete(id, name) {
                        if (!confirm('Bạn có chắc muốn xóa Landing Page "' + name + '"?')) {
                            return;
                        }

                        const params = new URLSearchParams();
                        params.append('action', 'delete');
                        params.append('id', id);

                        fetch(contextPath + '/landing-pages', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                            body: params
                        })
                            .then(res => res.json())
                            .then(result => {
                                if (result.success) {
                                    alert('Xóa thành công!');
                                    window.location.reload();
                                } else {
                                    alert(result.message || 'Lỗi khi xóa');
                                }
                            })
                            .catch(err => {
                                console.error('Error:', err);
                                alert('Có lỗi xảy ra: ' + err.message);
                            });
                    }

                    // Hide spinner
                    document.addEventListener('DOMContentLoaded', function () {
                        const spinner = document.getElementById('spinner');
                        if (spinner) spinner.classList.remove('show');
                    });
                </script>

        </body>

        </html>