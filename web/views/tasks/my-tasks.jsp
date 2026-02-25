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

                            .badge-upsell {
                                background-color: #198754;
                                color: white;
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
                                max-width: 300px;
                            }

                            .desc-tooltip {
                                max-width: 200px;
                                white-space: nowrap;
                                overflow: hidden;
                                text-overflow: ellipsis;
                                cursor: help;
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
                                                                    <th style="width:5%">#</th>
                                                                    <th style="width:25%">Tên công việc</th>
                                                                    <th style="width:18%">Khách hàng</th>
                                                                    <th style="width:10%">Loại</th>
                                                                    <th style="width:12%">Trạng thái</th>
                                                                    <th style="width:12%">Ngày tạo</th>
                                                                    <th style="width:18%">Hành động</th>
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
                                                                                <td>
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${not empty task.customerName}">
                                                                                            <a href="${pageContext.request.contextPath}/customers?action=view&id=${task.relatedRecordId}"
                                                                                                class="customer-link">
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
                                                                                            test="${task.taskType == 'Upsell'}">
                                                                                            <span
                                                                                                class="badge badge-upsell">
                                                                                                <i
                                                                                                    class="fa fa-arrow-up me-1"></i>Upsell
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
                                                                                                    class="fa fa-clock me-1"></i>Chờ
                                                                                                xử lý</span>
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${task.status == 'Overdue'}">
                                                                                            <span
                                                                                                class="badge badge-inprogress"><i
                                                                                                    class="fa fa-spinner me-1"></i>Đang
                                                                                                làm</span>
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${task.status == 'Completed'}">
                                                                                            <span
                                                                                                class="badge badge-done"><i
                                                                                                    class="fa fa-check me-1"></i>Hoàn
                                                                                                thành</span>
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
                                                                                    <c:if
                                                                                        test="${task.status == 'Pending'}">
                                                                                        <form method="post"
                                                                                            action="${pageContext.request.contextPath}/my-tasks"
                                                                                            style="display:inline">
                                                                                            <input type="hidden"
                                                                                                name="action"
                                                                                                value="start">
                                                                                            <input type="hidden"
                                                                                                name="taskId"
                                                                                                value="${task.id}">
                                                                                            <button type="submit"
                                                                                                class="btn btn-primary btn-action">
                                                                                                <i
                                                                                                    class="fa fa-play me-1"></i>Bắt
                                                                                                đầu
                                                                                            </button>
                                                                                        </form>
                                                                                    </c:if>
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
                                                                                    <c:if
                                                                                        test="${task.status == 'Completed'}">
                                                                                        <form method="post"
                                                                                            action="${pageContext.request.contextPath}/my-tasks"
                                                                                            style="display:inline">
                                                                                            <input type="hidden"
                                                                                                name="action"
                                                                                                value="reopen">
                                                                                            <input type="hidden"
                                                                                                name="taskId"
                                                                                                value="${task.id}">
                                                                                            <button type="submit"
                                                                                                class="btn btn-outline-secondary btn-action">
                                                                                                <i
                                                                                                    class="fa fa-redo me-1"></i>Mở
                                                                                                lại
                                                                                            </button>
                                                                                        </form>
                                                                                    </c:if>
                                                                                    <c:if
                                                                                        test="${not empty task.customerName}">
                                                                                        <a href="${pageContext.request.contextPath}/customers?action=view&id=${task.relatedRecordId}"
                                                                                            class="btn btn-outline-info btn-action ms-1"
                                                                                            title="Xem khách hàng">
                                                                                            <i class="fa fa-eye"></i>
                                                                                        </a>
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
                    </div>

                    <!-- JavaScript Libraries -->
                    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script src="${pageContext.request.contextPath}/lib/easing/easing.min.js"></script>
                    <script src="${pageContext.request.contextPath}/lib/waypoints/waypoints.min.js"></script>

                    <!-- Template Javascript -->
                    <script src="${pageContext.request.contextPath}/js/main.js"></script>

                    <script>
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
                    </script>
                </body>

                </html>