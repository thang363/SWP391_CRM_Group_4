<%-- submissions.jsp - Quản lý Danh sách Đăng ký (Lead Submissions) --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <% request.setAttribute("currentPage", "submissions" ); %>

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <title>Danh sách Đăng ký - CRM System</title>
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
                                                                        class="fa fa-clipboard-list me-2"></i>Danh sách
                                                                    Đăng ký</h3>
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
                                                    <div class="filter-section">
                                                        <form id="filterForm" method="get"
                                                            action="${pageContext.request.contextPath}/marketing/submissions">
                                                            <input type="hidden" name="page" id="pageInput" value="1">
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
                                                                        <c:forEach var="campaign" items="${campaigns}">
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
                                                                            ${param.status=='PENDING' ? 'selected' : ''
                                                                            }>Chưa xử lý
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
                                                                        <i class="fa fa-search me-1"></i>Lọc
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
                                                                                <th>Nguồn</th>
                                                                                <th>Khách hàng</th>
                                                                                <th>Trạng thái</th>
                                                                                <th class="table-actions">Hành động</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody id="submissionTableBody">
                                                                            <c:choose>
                                                                                <c:when test="${empty submissions}">
                                                                                    <tr>
                                                                                        <td colspan="6"
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
                                                                                                        test="${sub.landingPageId != null}">
                                                                                                        <span
                                                                                                            class="badge bg-info source-badge">Landing
                                                                                                            Page</span>
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                        <span
                                                                                                            class="badge bg-secondary source-badge">
                                                                                                            <c:choose>
                                                                                                                <c:when
                                                                                                                    test="${not empty sub.source}">
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
                                                                                            <td class="table-actions">
                                                                                                <c:if
                                                                                                    test="${!sub.isProcessed}">
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

                                                                <!-- Pagination -->
                                                                <c:if test="${totalPages > 1}">
                                                                    <nav aria-label="Page navigation" class="mt-4">
                                                                        <ul class="pagination justify-content-center">
                                                                            <li
                                                                                class="page-item ${currentPageNumber == 1 ? 'disabled' : ''}">
                                                                                <button class="page-link"
                                                                                    onclick="goToPage(${currentPageNumber - 1})"
                                                                                    ${currentPageNumber==1 ? 'disabled'
                                                                                    : '' }>
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
                                                                        Hiển thị trang ${currentPageNumber} trên tổng số
                                                                        ${totalPages} trang (${totalItems} kết quả)
                                                                    </div>
                                                                </c:if>
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
                                        if (!confirm('Bạn có muốn chuyển đổi đăng ký #' + id + ' thành Lead?')) return;

                                        fetch(contextPath + '/marketing/submissions', {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                            body: 'action=convert&id=' + id
                                        })
                                            .then(function (res) { return res.json(); })
                                            .then(function (data) {
                                                if (data.success) {
                                                    // Update row in-place
                                                    var row = document.getElementById('submission-row-' + id);
                                                    if (row) {
                                                        // Update badge
                                                        var badgeCell = row.cells[4];
                                                        badgeCell.innerHTML = '<span class="badge badge-processed">Đã xử lý</span>';

                                                        // Remove convert button, keep delete
                                                        var actionCell = row.cells[5];
                                                        actionCell.innerHTML =
                                                            '<button class="btn btn-sm btn-danger" onclick="handleDelete(' + id + ')" title="Xóa">' +
                                                            '<i class="fa fa-trash"></i></button>';
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
                                    }

                                    // ==================== Delete ====================
                                    function handleDelete(id) {
                                        if (!confirm('Bạn có chắc chắn muốn xóa bản ghi #' + id + '? Hành động này không thể hoàn tác.')) return;

                                        fetch(contextPath + '/marketing/submissions', {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                            body: 'action=delete&id=' + id
                                        })
                                            .then(function (res) { return res.json(); })
                                            .then(function (data) {
                                                if (data.success) {
                                                    // Remove row from table
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
                                </script>
                    </body>

                    </html>