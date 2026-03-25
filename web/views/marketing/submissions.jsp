<%-- submissions.jsp - Quản lý Danh sách Đăng ký (Lead Submissions) --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <% request.setAttribute("currentPage", "submissions" ); %>

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <title>List Submissions - CRM System</title>
                        <%@ include file="/includes/head.jsp" %>
                            <style>
                                .stat-card {
                                    border-radius: 0.75rem;
                                    padding: 1.25rem;
                                    color: #fff;
                                    transition: transform 0.2s;
                                }

                                .stat-card:hover {
                                    transform: translateY(-3px);
                                }

                                .stat-card .stat-number {
                                    font-size: 2rem;
                                    font-weight: 700;
                                }

                                .stat-card .stat-label {
                                    font-size: 0.85rem;
                                    opacity: 0.9;
                                }

                                .stat-card-total {
                                    background: linear-gradient(135deg, #6366f1, #818cf8);
                                }

                                .stat-card-pending {
                                    background: linear-gradient(135deg, #f59e0b, #fbbf24);
                                }

                                .stat-card-today {
                                    background: linear-gradient(135deg, #10b981, #34d399);
                                }

                                .filter-section {
                                    background-color: #f8f9fa;
                                    padding: 1.5rem;
                                    border-radius: 0.5rem;
                                    margin-bottom: 1.5rem;
                                }

                                .table-actions {
                                    white-space: nowrap;
                                }

                                .customer-info .customer-name {
                                    font-weight: 600;
                                }

                                .customer-info .customer-detail {
                                    font-size: 0.8rem;
                                    color: #6c757d;
                                }

                                .badge-pending {
                                    background-color: #dc3545;
                                }

                                .badge-processed {
                                    background-color: #28a745;
                                }

                                .source-badge {
                                    font-size: 0.75rem;
                                    padding: 0.25rem 0.5rem;
                                }

                                .message-cell {
                                    max-width: 200px;
                                    overflow: hidden;
                                    text-overflow: ellipsis;
                                    white-space: nowrap;
                                }
                            </style>
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

                                                <!-- Submissions Management Content -->
                                                <div class="container-fluid pt-4 px-4">

                                                    <!-- Page Header -->
                                                    <div class="row mb-4">
                                                        <div class="col-12">
                                                            <div
                                                                class="d-flex justify-content-between align-items-center">
                                                                <h3 class="mb-0"><i
                                                                        class="fa fa-clipboard-list me-2"></i>List
                                                                    Submissions</h3>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Stat Cards -->
                                                    <div class="row mb-4 g-3">
                                                        <div class="col-md-4">
                                                            <div class="stat-card stat-card-total">
                                                                <div class="stat-label"><i
                                                                        class="fa fa-database me-1"></i>Tổng số đăng ký
                                                                </div>
                                                                <div class="stat-number">${statTotal}</div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="stat-card stat-card-pending">
                                                                <div class="stat-label"><i
                                                                        class="fa fa-clock me-1"></i>Chưa xử lý</div>
                                                                <div class="stat-number">${statPending}</div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="stat-card stat-card-today">
                                                                <div class="stat-label"><i
                                                                        class="fa fa-calendar-day me-1"></i>Hôm nay
                                                                </div>
                                                                <div class="stat-number">${statToday}</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Filter Section -->
                                                    <c:if test="${not isManagerView}">
                                                        <div class="filter-section">
                                                            <form id="filterForm" method="get"
                                                                action="${pageContext.request.contextPath}/marketing/submissions">
                                                                <input type="hidden" name="page" id="pageInput"
                                                                    value="1">
                                                                <div class="row g-3">
                                                                    <div class="col-md-3">
                                                                        <label class="form-label">Tìm kiếm</label>
                                                                        <input type="text" class="form-control"
                                                                            name="keyword" id="filterKeyword"
                                                                            placeholder="Tên, Email, SĐT..."
                                                                            value="${param.keyword}">
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                        <label class="form-label">Chiến dịch</label>
                                                                        <select class="form-select" name="campaignId"
                                                                            id="filterCampaign">
                                                                            <option value="">Tất cả</option>
                                                                            <c:forEach var="campaign"
                                                                                items="${campaigns}">
                                                                                <option value="${campaign.id}"
                                                                                    ${param.campaignId==campaign.id
                                                                                    ? 'selected' : '' }>
                                                                                    ${campaign.name}
                                                                                </option>
                                                                            </c:forEach>
                                                                        </select>
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                        <label class="form-label">Trạng thái</label>
                                                                        <select class="form-select" name="status"
                                                                            id="filterStatus">
                                                                            <option value="">Tất cả</option>
                                                                            <option value="PENDING"
                                                                                ${param.status=='PENDING' ? 'selected'
                                                                                : '' }>Chưa xử lý
                                                                            </option>
                                                                            <option value="PROCESSED"
                                                                                ${param.status=='PROCESSED' ? 'selected'
                                                                                : '' }>Đã xử lý
                                                                            </option>
                                                                        </select>
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                        <label class="form-label">Từ ngày</label>
                                                                        <input type="date" class="form-control"
                                                                            name="fromDate" id="filterFromDate"
                                                                            value="${param.fromDate}">
                                                                    </div>
                                                                    <div class="col-md-3 d-flex align-items-end gap-2">
                                                                        <div class="flex-grow-1">
                                                                            <label class="form-label">Đến ngày</label>
                                                                            <input type="date" class="form-control"
                                                                                name="toDate" id="filterToDate"
                                                                                value="${param.toDate}">
                                                                        </div>
                                                                        <button type="submit" class="btn btn-primary">
                                                                            <i class="fa fa-search me-1"></i>
                                                                        </button>
                                                                        <button type="button" class="btn btn-secondary"
                                                                            onclick="resetFilters()">
                                                                            <i class="fa fa-redo me-1"></i>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </form>
                                                        </div>

                                                        <!-- Submissions Table -->
                                                        <div class="row">
                                                            <div class="col-12">
                                                                <div class="bg-light rounded p-4">
                                                                    <div class="table-responsive">
                                                                        <table class="table table-hover align-middle">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th style="width:60px">ID</th>
                                                                                    <th>Thời gian</th>
                                                                                    <th>Chiến dịch</th>
                                                                                    <th>Nguồn</th>
                                                                                    <th>Khách hàng</th>
                                                                                    <th>Trạng thái</th>
                                                                                    <th class="table-actions">Hành động
                                                                                    </th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody id="submissionTableBody">
                                                                                <c:choose>
                                                                                    <c:when test="${empty submissions}">
                                                                                        <tr>
                                                                                            <td colspan="7"
                                                                                                class="text-center text-muted py-5">
                                                                                                <i
                                                                                                    class="fa fa-inbox fa-3x mb-3 d-block"></i>
                                                                                                Chưa có đăng ký nào
                                                                                            </td>
                                                                                        </tr>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <c:forEach var="sub"
                                                                                            items="${submissions}">
                                                                                            <tr
                                                                                                id="submission-row-${sub.id}">
                                                                                                <td><strong>#${sub.id}</strong>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <fmt:formatDate
                                                                                                        value="${sub.submittedAt}"
                                                                                                        pattern="dd/MM/yyyy HH:mm" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    <c:choose>
                                                                                                        <c:when
                                                                                                            test="${not empty sub.campaignName}">
                                                                                                            <span
                                                                                                                class="fw-bold text-primary">${sub.campaignName}</span>
                                                                                                        </c:when>

                                                                                                    </c:choose>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <c:choose>
                                                                                                        <c:when test="${sub.source eq 'Internal Test'}">
                                                                                                            <span class="badge bg-warning text-dark source-badge" title="Test Nội Bộ">
                                                                                                                <i class="fa fa-flask me-1"></i>
                                                                                                                Test Nội Bộ
                                                                                                                <c:if test="${sub.landingPageId != null}">
                                                                                                                    (<c:out value="${sub.landingPageName}" default="LP" />)
                                                                                                                </c:if>
                                                                                                            </span>
                                                                                                        </c:when>
                                                                                                        <c:when
                                                                                                            test="${sub.landingPageId != null}">
                                                                                                            <span
                                                                                                                class="badge bg-info source-badge"
                                                                                                                title="Landing Page">
                                                                                                                <i
                                                                                                                    class="fa fa-laptop-code me-1"></i>
                                                                                                                <c:out
                                                                                                                    value="${sub.landingPageName}"
                                                                                                                    default="Landing Page" />
                                                                                                            </span>
                                                                                                        </c:when>
                                                                                                        <c:otherwise>
                                                                                                            <span
                                                                                                                class="badge bg-secondary source-badge">
                                                                                                                <c:choose>
                                                                                                                    <c:when
                                                                                                                        test="${not empty sub.source}">
                                                                                                                        <i
                                                                                                                            class="fa fa-file-import me-1"></i>
                                                                                                                        ${sub.source}
                                                                                                                    </c:when>
                                                                                                                    <c:otherwise>
                                                                                                                        N/A
                                                                                                                    </c:otherwise>
                                                                                                                </c:choose>
                                                                                                            </span>
                                                                                                        </c:otherwise>
                                                                                                    </c:choose>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <div
                                                                                                        class="customer-info">
                                                                                                        <div
                                                                                                            class="customer-name">
                                                                                                            ${sub.fullName}
                                                                                                        </div>
                                                                                                        <c:if
                                                                                                            test="${not empty sub.email}">
                                                                                                            <div
                                                                                                                class="customer-detail">
                                                                                                                <i
                                                                                                                    class="fa fa-envelope me-1"></i>${sub.email}
                                                                                                            </div>
                                                                                                        </c:if>
                                                                                                        <c:if
                                                                                                            test="${not empty sub.phone}">
                                                                                                            <div
                                                                                                                class="customer-detail">
                                                                                                                <i
                                                                                                                    class="fa fa-phone me-1"></i>${sub.phone}
                                                                                                            </div>
                                                                                                        </c:if>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <c:choose>
                                                                                                        <c:when
                                                                                                            test="${sub.isProcessed}">
                                                                                                            <span
                                                                                                                class="badge badge-processed">Đã
                                                                                                                xử
                                                                                                                lý</span>
                                                                                                        </c:when>
                                                                                                        <c:otherwise>
                                                                                                            <span
                                                                                                                class="badge badge-pending">Chưa
                                                                                                                xử
                                                                                                                lý</span>
                                                                                                        </c:otherwise>
                                                                                                    </c:choose>
                                                                                                </td>
                                                                                                <td
                                                                                                    class="table-actions">
                                                                                                    <button
                                                                                                        class="btn btn-sm btn-info text-white"
                                                                                                        onclick='handleViewDetails(${sub.id}, "${sub.fullName}", "${sub.email}", "${sub.phone}", "${sub.campaignName}", "${sub.landingPageName}", "${sub.source}", "${sub.submittedAt}", "${sub.isProcessed}")'
                                                                                                        title="Xem chi tiết">
                                                                                                        <i
                                                                                                            class="fa fa-eye"></i>
                                                                                                    </button>
                                                                                                    <c:if
                                                                                                        test="${!sub.isProcessed && sub.source ne 'Internal Test'}">
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-success"
                                                                                                            onclick="handleConvert(${sub.id})"
                                                                                                            title="Chuyển thành Lead">
                                                                                                            <i
                                                                                                                class="fa fa-check"></i>
                                                                                                        </button>
                                                                                                    </c:if>
                                                                                                    <button
                                                                                                        class="btn btn-sm btn-danger"
                                                                                                        onclick="handleDelete(${sub.id})"
                                                                                                        title="Xóa">
                                                                                                        <i
                                                                                                            class="fa fa-trash"></i>
                                                                                                    </button>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </c:forEach>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>

                                                                    <!-- Details Modal -->
                                                                    <div class="modal fade" id="detailsModal"
                                                                        tabindex="-1" aria-hidden="true">
                                                                        <div class="modal-dialog modal-dialog-centered">
                                                                            <div class="modal-content">
                                                                                <div
                                                                                    class="modal-header bg-primary text-white">
                                                                                    <h5 class="modal-title"><i
                                                                                            class="fa fa-info-circle me-2"></i>Chi
                                                                                        tiết Đăng ký</h5>
                                                                                    <button type="button"
                                                                                        class="btn-close btn-close-white"
                                                                                        data-bs-dismiss="modal"
                                                                                        aria-label="Close"></button>
                                                                                </div>
                                                                                <div class="modal-body">
                                                                                    <div class="mb-3">
                                                                                        <h6
                                                                                            class="fw-bold text-primary border-bottom pb-2">
                                                                                            Thông tin Khách hàng</h6>
                                                                                        <p class="mb-1"><strong>Họ
                                                                                                tên:</strong> <span
                                                                                                id="modalFullName"></span>
                                                                                        </p>
                                                                                        <p class="mb-1">
                                                                                            <strong>Email:</strong>
                                                                                            <span
                                                                                                id="modalEmail"></span>
                                                                                        </p>
                                                                                        <p class="mb-1"><strong>Số điện
                                                                                                thoại:</strong> <span
                                                                                                id="modalPhone"></span>
                                                                                        </p>
                                                                                    </div>
                                                                                    <div class="mb-3">

                                                                                        <p class="mb-1"><strong>Chiến
                                                                                                dịch:</strong> <span
                                                                                                id="modalCampaign"></span>
                                                                                        </p>
                                                                                        <p class="mb-1">
                                                                                            <strong>Nguồn:</strong>
                                                                                            <span
                                                                                                id="modalSource"></span>
                                                                                        </p>
                                                                                        <p class="mb-1"><strong>Thời
                                                                                                gian
                                                                                                gửi:</strong> <span
                                                                                                id="modalTime"></span>
                                                                                        </p>
                                                                                    </div>
                                                                                    <div class="mb-3">
                                                                                        <h6
                                                                                            class="fw-bold text-primary border-bottom pb-2">
                                                                                            Trạng thái</h6>
                                                                                        <span id="modalStatus"></span>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="modal-footer">
                                                                                    <button type="button"
                                                                                        class="btn btn-secondary"
                                                                                        data-bs-dismiss="modal">Đóng</button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                    <!-- Pagination -->
                                                                    <c:if test="${totalPages > 1}">
                                                                        <nav aria-label="Page navigation" class="mt-4">
                                                                            <ul
                                                                                class="pagination justify-content-center">
                                                                                <li
                                                                                    class="page-item ${currentPageNumber == 1 ? 'disabled' : ''}">
                                                                                    <button class="page-link"
                                                                                        onclick="goToPage(${currentPageNumber - 1})"
                                                                                        ${currentPageNumber==1
                                                                                        ? 'disabled' : '' }>
                                                                                        Previous
                                                                                    </button>
                                                                                </li>
                                                                                <c:forEach begin="1" end="${totalPages}"
                                                                                    var="i">
                                                                                    <li
                                                                                        class="page-item ${currentPageNumber == i ? 'active' : ''}">
                                                                                        <button class="page-link"
                                                                                            onclick="goToPage(${i})">${i}</button>
                                                                                    </li>
                                                                                </c:forEach>
                                                                                <li
                                                                                    class="page-item ${currentPageNumber == totalPages ? 'disabled' : ''}">
                                                                                    <button class="page-link"
                                                                                        onclick="goToPage(${currentPageNumber + 1})"
                                                                                        ${currentPageNumber==totalPages
                                                                                        ? 'disabled' : '' }>
                                                                                        Next
                                                                                    </button>
                                                                                </li>
                                                                            </ul>
                                                                        </nav>
                                                                        <div class="text-center text-muted small">
                                                                            Hiển thị trang ${currentPageNumber} trên
                                                                            tổng số
                                                                            ${totalPages} trang (${totalItems} kết quả)
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                    </c:if>

                                                    <!-- Manager View Notice -->
                                                    <c:if test="${isManagerView}">
                                                        <div class="row mt-4">
                                                            <div class="col-12 text-center text-muted">
                                                                <i class="fa fa-chart-bar fa-3x mb-3"></i>
                                                                <h5>Chế độ Quản lý</h5>
                                                                <p>Bạn đang xem số liệu tổng hợp của toàn hệ thống. Để
                                                                    xem và xử lý chi tiết từng lượt đăng ký, vui lòng sử
                                                                    dụng tài khoản Marketing.</p>
                                                            </div>
                                                        </div>
                                                    </c:if>
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
                                    var contextPath = '${pageContext.request.contextPath}';

                                    // ==================== Pagination ====================
                                    function goToPage(page) {
                                        document.getElementById('pageInput').value = page;
                                        document.getElementById('filterForm').submit();
                                    }

                                    // ==================== Reset Filters ====================
                                    function resetFilters() {
                                        window.location.href = contextPath + '/marketing/submissions';
                                    }

                                    // ==================== Convert to Lead ====================
                                    function handleConvert(id) {
                                        showConfirmDialog(
                                            'Bạn có muốn chuyển đổi đăng ký <strong>#' + id + '</strong> thành Lead?',
                                            function () {
                                                fetch(contextPath + '/marketing/submissions', {
                                                    method: 'POST',
                                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                                    body: 'action=convert&id=' + id
                                                })
                                                    .then(function (res) { return res.json(); })
                                                    .then(function (data) {
                                                        if (data.success) {
                                                            window.location.reload();
                                                        } else {
                                                            showToast('error', data.message);
                                                        }
                                                    })
                                                    .catch(function (err) {
                                                        showToast('error', 'Lỗi kết nối server');
                                                        console.error(err);
                                                    });
                                            },
                                            { title: 'Chuyển đổi thành Lead', confirmText: 'Chuyển đổi', confirmClass: 'btn-success' }
                                        );
                                    }

                                    // ==================== Delete ====================
                                    function handleDelete(id) {
                                        showConfirmDialog(
                                            'Bạn có chắc chắn muốn xóa bản ghi <strong>#' + id + '</strong>? Hành động này không thể hoàn tác.',
                                            function () {
                                                fetch(contextPath + '/marketing/submissions', {
                                                    method: 'POST',
                                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                                    body: 'action=delete&id=' + id
                                                })
                                                    .then(function (res) { return res.json(); })
                                                    .then(function (data) {
                                                        if (data.success) {
                                                            var row = document.getElementById('submission-row-' + id);
                                                            if (row) {
                                                                row.style.transition = 'opacity 0.3s';
                                                                row.style.opacity = '0';
                                                                setTimeout(function () { row.remove(); }, 300);
                                                            }
                                                            showToast('success', data.message);
                                                        } else {
                                                            showToast('error', data.message);
                                                        }
                                                    })
                                                    .catch(function (err) {
                                                        showToast('error', 'Lỗi kết nối server');
                                                        console.error(err);
                                                    });
                                            },
                                            { title: 'Xóa bản ghi', confirmText: 'Xóa', confirmClass: 'btn-danger' }
                                        );
                                    }

                                    // ==================== Toast Notification ====================
                                    function showToast(type, message) {
                                        // Create toast container if not exists
                                        var container = document.getElementById('toast-container');
                                        if (!container) {
                                            container = document.createElement('div');
                                            container.id = 'toast-container';
                                            container.style.cssText = 'position:fixed;top:20px;right:20px;z-index:9999;';
                                            document.body.appendChild(container);
                                        }

                                        var toast = document.createElement('div');
                                        toast.className = 'alert alert-' + (type === 'success' ? 'success' : 'danger') + ' alert-dismissible fade show';
                                        toast.style.cssText = 'min-width:300px;box-shadow:0 4px 12px rgba(0,0,0,0.15);';
                                        toast.innerHTML =
                                            '<i class="fa ' + (type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle') + ' me-2"></i>' +
                                            message +
                                            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';

                                        container.appendChild(toast);

                                        // Auto dismiss after 3 seconds
                                        setTimeout(function () {
                                            if (toast.parentNode) {
                                                toast.style.transition = 'opacity 0.3s';
                                                toast.style.opacity = '0';
                                                setTimeout(function () { toast.remove(); }, 300);
                                            }
                                        }, 3000);
                                    }

                                    // ==================== View Details ====================
                                    function handleViewDetails(id, fullName, email, phone, campaign, landingPage, source, time, isProcessed) {
                                        document.getElementById('modalFullName').textContent = fullName;
                                        document.getElementById('modalEmail').textContent = email || 'N/A';
                                        document.getElementById('modalPhone').textContent = phone || 'N/A';
                                        document.getElementById('modalCampaign').textContent = campaign || 'Direct / Other';

                                        var sourceText = source;
                                        if (landingPage && landingPage !== 'null' && landingPage !== '') {
                                            sourceText = 'Landing Page: ' + landingPage;
                                        } else if (!source || source === 'null') {
                                            sourceText = 'N/A';
                                        }
                                        document.getElementById('modalSource').textContent = sourceText;

                                        document.getElementById('modalTime').textContent = time;

                                        var statusHtml = isProcessed === 'true'
                                            ? '<span class="badge bg-success">Đã xử lý</span>'
                                            : '<span class="badge bg-warning text-dark">Chưa xử lý</span>';
                                        document.getElementById('modalStatus').innerHTML = statusHtml;

                                        var modal = new bootstrap.Modal(document.getElementById('detailsModal'));
                                        modal.show();
                                    }
                                </script>
                    </body>

                    </html>