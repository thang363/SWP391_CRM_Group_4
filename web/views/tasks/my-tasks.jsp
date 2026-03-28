<%-- my-tasks.jsp - My Tasks (Support + Manager) --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>My Tasks - CRM System</title>
                    <%@ include file="/includes/head.jsp" %>
                        <style>
                            .stat-card {
                                border-radius: 10px;
                                padding: 20px;
                                text-align: center;
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
                                text-transform: uppercase;
                                letter-spacing: 1px;
                            }

                            .badge-renewal {
                                background-color: #ffc107;
                                color: #212529;
                            }

                            .badge-care {
                                background-color: #0dcaf0;
                                color: #212529;
                            }

                            .badge-open {
                                background-color: #0d6efd;
                                color: white;
                            }

                            .badge-inprogress {
                                background-color: #fd7e14;
                                color: white;
                            }

                            .badge-done {
                                background-color: #198754;
                                color: white;
                            }

                            .table td,
                            .table th {
                                vertical-align: middle;
                            }

                            .customer-link {
                                color: #0d6efd;
                                text-decoration: none;
                                font-weight: 500;
                            }

                            .customer-link:hover {
                                text-decoration: underline;
                            }

                            .btn-action {
                                padding: 4px 12px;
                                font-size: 0.8rem;
                                border-radius: 20px;
                            }

                            .filter-btn {
                                border-radius: 20px;
                                padding: 6px 16px;
                                font-size: 0.85rem;
                                margin-right: 5px;
                            }

                            .filter-btn.active {
                                font-weight: 600;
                            }

                            .task-title-cell {
                                max-width: 280px;
                                word-wrap: break-word;
                                overflow-wrap: break-word;
                                white-space: normal;
                            }

                            .customer-cell {
                                max-width: 200px;
                                word-wrap: break-word;
                                overflow-wrap: break-word;
                                white-space: normal;
                            }

                            .desc-tooltip {
                                display: block;
                                max-width: 100%;
                                white-space: nowrap;
                                overflow: hidden;
                                text-overflow: ellipsis;
                                cursor: help;
                            }

                            /* Ensure table doesn't force page overflow */
                            .table {
                                table-layout: fixed;
                                width: 100%;
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

                                    <div class="container-fluid pt-4 px-4">

                                        <!-- Page Header -->
                                        <div class="row mb-4">
                                            <div class="col-12">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <h3 class="mb-0"><i class="fa fa-clipboard-list me-2"></i>My Tasks
                                                    </h3>
                                                    <span class="text-muted">Danh sách công việc cần thực hiện</span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Statistics Cards -->
                                        <div class="row g-3 mb-4">
                                            <div class="col-md-4">
                                                <div class="stat-card bg-light">
                                                    <div class="stat-number text-primary">${openCount}</div>
                                                    <div class="stat-label text-muted">Chờ xử lý</div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="stat-card bg-light">
                                                    <div class="stat-number text-warning">${inProgressCount}</div>
                                                    <div class="stat-label text-muted">Đang làm</div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="stat-card bg-light">
                                                    <div class="stat-number text-success">${doneCount}</div>
                                                    <div class="stat-label text-muted">Hoàn thành</div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Filter Buttons -->
                                        <div class="row mb-3">
                                            <div class="col-12">
                                                <button class="btn btn-outline-secondary filter-btn active"
                                                    onclick="filterTasks('all')">
                                                    Tất cả
                                                </button>
                                                <button class="btn btn-outline-primary filter-btn"
                                                    onclick="filterTasks('Pending')">
                                                    <i class="fa fa-clock me-1"></i>Chờ xử lý
                                                </button>
                                                <button class="btn btn-outline-warning filter-btn"
                                                    onclick="filterTasks('Overdue')">
                                                    <i class="fa fa-spinner me-1"></i>Đang làm
                                                </button>
                                                <button class="btn btn-outline-success filter-btn"
                                                    onclick="filterTasks('Completed')">
                                                    <i class="fa fa-check me-1"></i>Hoàn thành
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Tasks Table -->
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="bg-light rounded p-4">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover align-middle" id="tasksTable">
                                                            <thead>
                                                                <tr>
                                                                    <th style="width: 5%">#</th>
                                                                    <th style="width: 25%">Tên công việc</th>
                                                                    <th style="width: 20%">Khách hàng</th>
                                                                    <th style="width: 12%">Loại</th>
                                                                    <th style="width: 13%">Trạng thái</th>
                                                                    <th style="width: 15%">Ngày tạo</th>
                                                                    <th style="width: 10%">Hành động</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:choose>
                                                                    <c:when test="${empty tasks}">
                                                                        <tr>
                                                                            <td colspan="7"
                                                                                class="text-center text-muted py-5">
                                                                                <i
                                                                                    class="fa fa-clipboard fa-3x mb-3 d-block"></i>
                                                                                Chưa có công việc nào. Hệ thống sẽ tự
                                                                                động tạo khi chạy Automation Rules.
                                                                            </td>
                                                                        </tr>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:forEach var="task" items="${tasks}"
                                                                            varStatus="loop">
                                                                            <tr class="task-row"
                                                                                data-status="${task.status}">
                                                                                <td>
                                                                                    <strong>${loop.index + 1}</strong>
                                                                                </td>
                                                                                <td class="task-title-cell">
                                                                                    <strong>${task.title}</strong>
                                                                                    <c:if
                                                                                        test="${not empty task.description}">
                                                                                        <br>
                                                                                        <small
                                                                                            class="text-muted desc-tooltip"
                                                                                            title="${task.description}">${task.description}</small>
                                                                                    </c:if>
                                                                                </td>
                                                                                <td class="customer-cell">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${not empty task.customerName}">
                                                                                            <a href="javascript:void(0)"
                                                                                                onclick="showCustomerInfo(${task.relatedRecordId})"
                                                                                                class="customer-link"
                                                                                                title="Xem thông tin nhanh">
                                                                                                <i
                                                                                                    class="fa fa-building me-1"></i>${task.customerName}
                                                                                            </a>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span
                                                                                                class="text-muted">—</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </td>
                                                                                <td>
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${task.taskType == 'Renewal'}">
                                                                                            <span
                                                                                                class="badge badge-renewal">
                                                                                                <i
                                                                                                    class="fa fa-sync-alt me-1"></i>Renewal
                                                                                            </span>
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${task.taskType == 'Care'}">
                                                                                            <span
                                                                                                class="badge badge-care">
                                                                                                <i
                                                                                                    class="fa fa-heart me-1"></i>Care
                                                                                            </span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span
                                                                                                class="badge bg-secondary">
                                                                                                ${task.taskType != null
                                                                                                ? task.taskType : '—'}
                                                                                            </span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </td>
                                                                                <td>
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${task.status == 'Pending'}">
                                                                                            <span
                                                                                                class="badge badge-open"><i
                                                                                                    class="fa fa-clock me-1"></i>Pending</span>
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${task.status == 'Overdue'}">
                                                                                            <span
                                                                                                class="badge badge-inprogress"><i
                                                                                                    class="fa fa-spinner me-1"></i>Overdue</span>
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${task.status == 'Completed'}">
                                                                                            <span
                                                                                                class="badge badge-done"><i
                                                                                                    class="fa fa-check me-1"></i>Completed</span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span
                                                                                                class="badge bg-secondary">${task.status}</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </td>
                                                                                <td>
                                                                                    <fmt:formatDate
                                                                                        value="${task.createdAt}"
                                                                                        pattern="dd/MM/yyyy HH:mm" />
                                                                                </td>
                                                                                <td>
                                                                                    <%-- Nút Bắt đầu đã được xóa theo yêu cầu --%>
                                                                                    <c:if
                                                                                        test="${task.status == 'Overdue'}">
                                                                                        <form method="post"
                                                                                            action="${pageContext.request.contextPath}/my-tasks"
                                                                                            style="display:inline">
                                                                                            <input type="hidden"
                                                                                                name="action"
                                                                                                value="done">
                                                                                            <input type="hidden"
                                                                                                name="taskId"
                                                                                                value="${task.id}">
                                                                                            <button type="submit"
                                                                                                class="btn btn-success btn-action">
                                                                                                <i
                                                                                                    class="fa fa-check me-1"></i>Hoàn
                                                                                                thành
                                                                                            </button>
                                                                                        </form>
                                                                                    </c:if>

                                                                                    <c:if test="${task.status != 'Completed'}">
                                                                                        <button type="button" class="btn btn-outline-info btn-action ms-1"
                                                                                            onclick="showTaskDetail('${task.id}', '${task.title}', '${task.description}', '${task.customerName}', '${task.taskType}', '${task.status}', '${task.relatedRecordId}')">
                                                                                            <i class="fa fa-eye me-1"></i>Chi tiết
                                                                                        </button>
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
                                        </div>

                                    </div>

                                    <%@ include file="/includes/footer.jsp" %>
                            </div>
                            <!-- Content End -->

                            <!-- Customer Info Modal -->
                            <div class="modal fade" id="customerInfoModal" tabindex="-1"
                                aria-labelledby="customerInfoModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content">
                                        <div class="modal-header bg-primary text-white">
                                            <h5 class="modal-title" id="customerInfoModalLabel">
                                                <i class="fa fa-info-circle me-2"></i>Thông tin khách hàng
                                            </h5>
                                            <button type="button" class="btn-close btn-close-white"
                                                data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body" id="customerInfoBody">
                                            <!-- Nội dung sẽ được load qua AJAX -->
                                            <div class="text-center py-4" id="modalLoader">
                                                <div class="spinner-border text-primary" role="status">
                                                    <span class="sr-only">Đang tải...</span>
                                                </div>
                                            </div>
                                            <div id="modalContent" style="display: none;">
                                                <div class="d-flex align-items-center mb-3">
                                                    <h4 id="modalCompanyName" class="mb-0 me-2"></h4>
                                                    <span id="modalTier" class="badge"></span>
                                                </div>
                                                <hr>
                                                <div class="row g-3">
                                                    <div class="col-sm-6">
                                                        <label class="text-muted small d-block">Điện thoại</label>
                                                        <a href="" id="modalPhoneLink"
                                                            class="text-dark fw-bold text-decoration-none">
                                                            <i class="fa fa-phone-alt me-1 text-primary"></i> <span
                                                                id="modalPhone"></span>
                                                        </a>
                                                    </div>
                                                    <div class="col-sm-6">
                                                        <label class="text-muted small d-block">Email</label>
                                                        <span id="modalEmail" class="fw-bold"></span>
                                                    </div>
                                                    <div class="col-sm-6">
                                                        <label class="text-muted small d-block">Ngành nghề</label>
                                                        <span id="modalIndustry" class="fw-bold"></span>
                                                    </div>
                                                    <div class="col-sm-6">
                                                        <label class="text-muted small d-block">CS cuối</label>
                                                        <span id="modalLastCare" class="fw-bold"></span>
                                                    </div>
                                                    <div class="col-sm-6">
                                                        <label class="text-muted small d-block">Địa điểm</label>
                                                        <span id="modalLocation" class="fw-bold"></span>
                                                    </div>
                                                    <div class="col-sm-6">
                                                        <label class="text-muted small d-block">Website</label>
                                                        <a href="" id="modalWebsiteLink" target="_blank"
                                                            class="fw-bold text-truncate d-block">
                                                            <span id="modalWebsite"></span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Đóng</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Task Detail Modal -->
                            <div class="modal fade" id="taskDetailModal" tabindex="-1"
                                aria-labelledby="taskDetailModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header bg-info text-white">
                                            <h5 class="modal-title" id="taskDetailModalLabel">
                                                <i class="fa fa-clipboard-list me-2"></i>Chi tiết công việc
                                            </h5>
                                            <button type="button" class="btn-close btn-close-white"
                                                data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="row g-3 mb-3">
                                                <div class="col-sm-8">
                                                    <label class="text-muted small d-block">Tên công việc</label>
                                                    <strong id="detailTitle"></strong>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="text-muted small d-block">Loại</label>
                                                    <span id="detailType" class="badge"></span>
                                                </div>
                                                <div class="col-sm-6">
                                                    <label class="text-muted small d-block">Khách hàng</label>
                                                    <strong id="detailCustomer"></strong>
                                                </div>
                                                <div class="col-sm-6">
                                                    <label class="text-muted small d-block">Trạng thái</label>
                                                    <span id="detailStatus" class="badge"></span>
                                                </div>
                                                <div class="col-12">
                                                    <label class="text-muted small d-block">Mô tả</label>
                                                    <p id="detailDescription" class="mb-0"></p>
                                                </div>
                                            </div>
                                            <hr>
                                            <h6 class="mb-3"><i class="fa fa-tasks me-1"></i>Hành động</h6>

                                            <!-- Renewal Actions -->
                                            <div id="renewalActions" style="display:none;">
                                                <div class="d-flex gap-2 flex-wrap">
                                                    <form method="post" action="${pageContext.request.contextPath}/my-tasks" style="display:inline">
                                                        <input type="hidden" name="action" value="complete_renewal">
                                                        <input type="hidden" name="taskId" id="renewalTaskId">
                                                        <button type="submit" class="btn btn-success">
                                                            <i class="fa fa-check-circle me-1"></i>Hoàn thành gia hạn
                                                        </button>
                                                    </form>
                                                    <form method="post" action="${pageContext.request.contextPath}/my-tasks" style="display:inline"
                                                        onsubmit="return submitWithToast(this, 'Đã ghi nhận khách hàng hủy dịch vụ. Trạng thái cập nhật thành Inactive.');">
                                                        <input type="hidden" name="action" value="cancel_service">
                                                        <input type="hidden" name="taskId" id="cancelTaskId">
                                                        <button type="submit" class="btn btn-danger">
                                                            <i class="fa fa-times-circle me-1"></i>Khách hủy dịch vụ
                                                        </button>
                                                    </form>
                                                    <form method="post" action="${pageContext.request.contextPath}/my-tasks" style="display:inline"
                                                        onsubmit="return submitWithToast(this, 'Hệ thống đang tạo Opportunity mới và chuyển cho Sales phụ trách.');">
                                                        <input type="hidden" name="action" value="transfer_to_sales">
                                                        <input type="hidden" name="taskId" id="renewalTransferTaskId">
                                                        <button type="submit" class="btn btn-primary">
                                                            <i class="fa fa-share me-1"></i>Chuyển sang Opportunity Sales
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>

                                            <!-- Care Actions -->
                                            <div id="careActions" style="display:none;">
                                                <div class="d-flex gap-2 flex-wrap">
                                                    <form method="post" action="${pageContext.request.contextPath}/my-tasks" style="display:inline">
                                                        <input type="hidden" name="action" value="mark_called">
                                                        <input type="hidden" name="taskId" id="calledTaskId">
                                                        <button type="submit" class="btn btn-success">
                                                            <i class="fa fa-heart me-1"></i>Đã chăm sóc
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                    </div>

                            <!-- Toast Notification Container -->
                            <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 1100">
                                <div id="actionToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                                    <div class="d-flex">
                                        <div class="toast-body" id="toastMessage">
                                            <!-- Message here -->
                                        </div>
                                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                                    </div>
                                </div>
                            </div>

                    <!-- JavaScript Libraries -->
                    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script src="${pageContext.request.contextPath}/lib/easing/easing.min.js"></script>
                    <script src="${pageContext.request.contextPath}/lib/waypoints/waypoints.min.js"></script>

                    <!-- Template Javascript -->
                    <script src="${pageContext.request.contextPath}/js/main.js"></script>

                    <script>
                        function submitWithToast(formEl, message) {
                            var toastEl = document.getElementById('actionToast');
                            document.getElementById('toastMessage').innerText = message;
                            var toast = new bootstrap.Toast(toastEl, { delay: 2000 });
                            toast.show();
                            
                            var btn = formEl.querySelector('button[type="submit"]');
                            if (btn) btn.disabled = true;

                            setTimeout(function() {
                                formEl.submit();
                            }, 1200);

                            return false;
                        }

                        function filterTasks(status) {
                            var rows = document.querySelectorAll('.task-row');
                            var buttons = document.querySelectorAll('.filter-btn');

                            // Update button active state
                            buttons.forEach(function (btn) {
                                btn.classList.remove('active');
                            });
                            event.target.classList.add('active');

                            // Filter rows
                            rows.forEach(function (row) {
                                if (status === 'all' || row.getAttribute('data-status') === status) {
                                    row.style.display = '';
                                } else {
                                    row.style.display = 'none';
                                }
                            });
                        }

                        function showCustomerInfo(customerId) {
                            var modal = new bootstrap.Modal(document.getElementById('customerInfoModal'));
                            var loader = document.getElementById('modalLoader');
                            var content = document.getElementById('modalContent');

                            loader.style.display = 'block';
                            content.style.display = 'none';
                            modal.show();

                            $.ajax({
                                url: '${pageContext.request.contextPath}/customer-info',
                                data: { id: customerId },
                                type: 'GET',
                                success: function (data) {
                                    if (data.error) {
                                        alert('Lỗi: ' + data.error);
                                        modal.hide();
                                        return;
                                    }

                                    // Điền dữ liệu
                                    $('#modalCompanyName').text(data.companyName || '—');
                                    $('#modalPhone').text(data.phone || '—');
                                    $('#modalPhoneLink').attr('href', data.phone ? 'tel:' + data.phone : 'javascript:void(0)');
                                    $('#modalEmail').text(data.email || '—');
                                    $('#modalIndustry').text(data.industry || '—');
                                    $('#modalLastCare').text(data.lastCareDate || 'Chưa chăm sóc');
                                    $('#modalLocation').text((data.city || '') + (data.city && data.country ? ', ' : '') + (data.country || '') || '—');
                                    $('#modalWebsite').text(data.website || '—');
                                    $('#modalWebsiteLink').attr('href', data.website ? (data.website.startsWith('http') ? data.website : 'http://' + data.website) : 'javascript:void(0)');

                                    // Tier Badge logic
                                    var tierClass = 'bg-secondary';
                                    if (data.tier === 'VIP') tierClass = 'bg-danger';
                                    else if (data.tier === 'Premium') tierClass = 'bg-success';
                                    else if (data.tier === 'Standard') tierClass = 'bg-info text-dark';

                                    $('#modalTier').text(data.tier || 'Standard').removeClass().addClass('badge ' + tierClass);

                                    // Link full profile
                                    $('#viewFullProfileBtn').attr('href', '${pageContext.request.contextPath}/customers?action=view&id=' + data.id);

                                    loader.style.display = 'none';
                                    content.style.display = 'block';
                                },
                                error: function () {
                                    alert('Không thể kết nối đến máy chủ. Vui lòng thử lại.');
                                    modal.hide();
                                }
                            });
                        }

                        function showTaskDetail(taskId, title, description, customerName, taskType, status, relatedRecordId) {
                            // Populate modal fields
                            document.getElementById('detailTitle').textContent = title || '—';
                            document.getElementById('detailDescription').textContent = description || 'Không có mô tả';
                            document.getElementById('detailCustomer').textContent = customerName || '—';

                            // Type badge
                            var typeEl = document.getElementById('detailType');
                            if (taskType === 'Renewal') {
                                typeEl.textContent = 'Renewal (Gia hạn)';
                                typeEl.className = 'badge badge-renewal';
                            } else if (taskType === 'Care') {
                                typeEl.textContent = 'Chăm sóc KH';
                                typeEl.className = 'badge badge-care';
                            } else {
                                typeEl.textContent = taskType || '—';
                                typeEl.className = 'badge bg-secondary';
                            }

                            // Status badge
                            var statusEl = document.getElementById('detailStatus');
                            if (status === 'Pending') {
                                statusEl.textContent = 'Chờ xử lý';
                                statusEl.className = 'badge badge-open';
                            } else if (status === 'Overdue') {
                                statusEl.textContent = 'Đang làm';
                                statusEl.className = 'badge badge-inprogress';
                            } else {
                                statusEl.textContent = status;
                                statusEl.className = 'badge bg-secondary';
                            }

                            // Toggle action sections
                            var renewalActions = document.getElementById('renewalActions');
                            var careActions = document.getElementById('careActions');
                            renewalActions.style.display = 'none';
                            careActions.style.display = 'none';

                            if (taskType === 'Renewal') {
                                renewalActions.style.display = 'block';
                                document.getElementById('renewalTaskId').value = taskId;
                                document.getElementById('cancelTaskId').value = taskId;
                                document.getElementById('renewalTransferTaskId').value = taskId;
                            } else if (taskType === 'Care') {
                                careActions.style.display = 'block';
                                document.getElementById('calledTaskId').value = taskId;
                            }

                            // Show modal
                            var modal = new bootstrap.Modal(document.getElementById('taskDetailModal'));
                            modal.show();
                        }
                    </script>
                </body>

                </html>