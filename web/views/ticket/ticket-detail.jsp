<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <title>${pageTitle} - CRM System</title>
                <%@ include file="/includes/head.jsp" %>
                    <style>
                        .activity-stream {
                            max-height: 350px;
                            overflow-y: auto;
                            padding: 15px;
                            padding-right: 10px;
                            background: #f8f9fa;
                            border: 1px solid #e0e0e0;
                            border-radius: 5px;
                            margin-bottom: 20px;
                        }

                        .activity-item {
                            margin-bottom: 15px;
                            padding: 10px;
                            border-radius: 8px;
                            position: relative;
                        }

                        .activity-item.comment {
                            background: #ffffff;
                            border: 1px solid #ddd;
                        }

                        .activity-item.internal {
                            background: #fff3cd;
                            /* Yellowish for internal */
                            border: 1px solid #ffeeba;
                        }

                        .activity-item.system {
                            background: #e2e3e5;
                            border-left: 4px solid #6c757d;
                            font-style: italic;
                            font-size: 0.9rem;
                        }

                        .activity-header {
                            font-size: 0.85rem;
                            color: #6c757d;
                            margin-bottom: 5px;
                            display: flex;
                            justify-content: space-between;
                        }

                        .activity-content {
                            white-space: pre-wrap;
                        }

                        .status-select {
                            font-weight: bold;
                        }

                        .status-Open {
                            color: #007bff;
                        }

                        .status-InProgress {
                            color: #dc3545;
                            /* Using InProgress to match common, though DB says 'In Progress' with space? Need to check DB enum */
                        }

                        .status-Resolved {
                            color: #28a745;
                        }

                        .status-Closed {
                            color: #6c757d;
                        }
                    </style>
            </head>

            <body>
                <div class="container-xxl position-relative bg-white d-flex p-0">
                    <!-- Sidebar Start -->
                    <%@ include file="/includes/sidebar.jsp" %>
                        <!-- Sidebar End -->

                        <!-- Content Start -->
                        <div class="content">
                            <%@ include file="/includes/topbar.jsp" %>

                                <div class="container-fluid pt-4 px-4">
                                    <div class="row g-4">

                                        <!-- Part A & B: Main Content -->
                                        <div class="col-md-9">

                                            <!-- Part A: Basic Info Header -->
                                            <div class="bg-light rounded p-4 mb-4">
                                                <div class="d-flex justify-content-between align-items-center mb-3">
                                                    <div>
                                                        <h4 class="mb-1">${ticket.title}</h4>
                                                        <p class="text-muted mb-0">
                                                            Khách hàng: <strong>${ticket.customerName}</strong>
                                                            &bull; Ngày tạo:
                                                            <fmt:formatDate value="${ticket.createdAt}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </p>
                                                    </div>
                                                    <div class="d-flex flex-column gap-2"
                                                        style="min-width: 200px; align-items: flex-end;">
                                                        <!-- Back Button -->
                                                        <a href="${pageContext.request.contextPath}/tickets"
                                                            class="btn btn-sm btn-outline-secondary mb-2">
                                                            <i class="fa fa-arrow-left me-1"></i> Quay lại
                                                        </a>

                                                        <!-- Status -->
                                                        <div
                                                            class="d-flex justify-content-between align-items-center w-100">
                                                            <label class="fw-bold me-2">Trạng thái:</label>
                                                            <select class="form-select form-select-sm w-auto"
                                                                id="statusSelect" onchange="updateStatus(${ticket.id})">
                                                                <option value="Open" ${ticket.status=='Open'
                                                                    ? 'selected' : '' }>Mới (Open)</option>
                                                                <option value="In Progress"
                                                                    ${ticket.status=='In Progress' ? 'selected' : '' }>
                                                                    Đang xử lý</option>
                                                                <option value="Resolved" ${ticket.status=='Resolved'
                                                                    ? 'selected' : '' }>Đã giải quyết</option>
                                                                <option value="Closed" ${ticket.status=='Closed'
                                                                    ? 'selected' : '' }>Đóng</option>
                                                            </select>
                                                        </div>

                                                        <!-- Assign -->
                                                        <div
                                                            class="d-flex justify-content-between align-items-center w-100">
                                                            <label class="fw-bold me-2">Assign:</label>
                                                            <div class="d-flex gap-1">
                                                                <select class="form-select form-select-sm w-auto"
                                                                    id="assignSelect" ${sessionScope.userRole
                                                                    !='MANAGER' ? 'disabled' : '' }>
                                                                    <option value="">-- Chưa gán --</option>
                                                                    <c:forEach var="agent" items="${agents}">
                                                                        <option value="${agent.id}"
                                                                            ${ticket.assignedTo==agent.id ? 'selected'
                                                                            : '' }>
                                                                            ${agent.fullName}
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                                <button type="button" class="btn btn-sm btn-primary"
                                                                    onclick="assignTicket(${ticket.id}, this)"
                                                                    ${sessionScope.userRole !='MANAGER' ? 'disabled'
                                                                    : '' }>
                                                                    <i class="fa fa-check"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="p-3 bg-white border rounded">
                                                    <h6 class="fw-bold">Mô tả chi tiết:</h6>
                                                    <p class="mb-0" style="white-space: pre-wrap;">${ticket.description}
                                                    </p>
                                                </div>
                                            </div>

                                            <!-- Part B: Activity Stream / Processing -->
                                            <div class="bg-light rounded p-4">
                                                <h5 class="mb-3"><i class="fa fa-history me-2"></i>Hoạt động & Xử lý
                                                </h5>

                                                <!-- Chat History -->
                                                <div class="activity-stream" id="activityStream">
                                                    <c:choose>
                                                        <c:when test="${empty activities}">
                                                            <div class="text-center text-muted py-4">Chưa có hoạt động
                                                                nào.</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach var="act" items="${activities}">
                                                                <div
                                                                    class="activity-item ${act.activityType == 'InternalNote' ? 'internal' : (act.activityType == 'System' ? 'system' : 'comment')}">
                                                                    <div class="activity-header">
                                                                        <strong>${act.userName}</strong>
                                                                        <span>
                                                                            <fmt:formatDate value="${act.createdAt}"
                                                                                pattern="dd/MM/yyyy HH:mm" />
                                                                        </span>
                                                                    </div>
                                                                    <div class="activity-content">${act.message}</div>
                                                                    <c:if test="${act.activityType == 'InternalNote'}">
                                                                        <div class="text-warning small mt-1"><i
                                                                                class="fa fa-lock me-1"></i>Ghi chú nội
                                                                            bộ</div>
                                                                    </c:if>
                                                                </div>
                                                            </c:forEach>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Input Form -->
                                                <div class="mt-3">
                                                    <form id="activityForm">
                                                        <input type="hidden" name="ticketId" value="${ticket.id}">
                                                        <input type="hidden" name="action" value="add-activity">

                                                        <div class="mb-3">
                                                            <textarea class="form-control" name="message" rows="2"
                                                                placeholder="Nhập nội dung xử lý hoặc trả lời..."
                                                                required></textarea>
                                                        </div>
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <!-- Internal Note: Chỉ Support và Manager mới thấy -->
                                                            <c:if
                                                                test="${sessionScope.userRole.name == 'SUPPORT' or sessionScope.userRole.name == 'MANAGER'}">
                                                                <div class="form-check">
                                                                    <input class="form-check-input" type="checkbox"
                                                                        name="isInternal" value="true"
                                                                        id="internalNoteCheck">
                                                                    <label class="form-check-label text-danger"
                                                                        for="internalNoteCheck">
                                                                        <i class="fa fa-lock me-1"></i>Internal Note
                                                                        (Chỉ
                                                                        nội bộ)
                                                                    </label>
                                                                </div>
                                                            </c:if>
                                                            <c:if
                                                                test="${sessionScope.userRole.name != 'SUPPORT' and sessionScope.userRole.name != 'MANAGER'}">
                                                                <div></div> <!-- Spacer for layout -->
                                                            </c:if>
                                                            <button type="button" class="btn btn-primary"
                                                                onclick="submitActivity()">
                                                                <i class="fa fa-paper-plane me-2"></i>Gửi
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>

                                        </div>

                                        <!-- Part C: Sidebar (Management) -->
                                        <div class="col-md-3">

                                            <!-- Claim Button for Support/Manager if unassigned -->
                                            <c:if
                                                test="${(empty ticket.assignedTo or ticket.assignedTo == 0) and (sessionScope.userRole.name == 'SUPPORT' or sessionScope.userRole.name == 'MANAGER')}">
                                                <div class="mb-4">
                                                    <button class="btn btn-warning w-100 fw-bold"
                                                        onclick="claimTicket(${ticket.id})">
                                                        <i class="fa fa-hand-paper me-2"></i>Nhận xử lý (Claim)
                                                    </button>
                                                </div>
                                            </c:if>

                                            <!-- Ticket Metadata -->
                                            <div class="bg-light rounded p-4 mb-4">
                                                <h6 class="mb-3 fw-bold border-bottom pb-2">Thông tin ticket</h6>
                                                <div class="mb-3">
                                                    <small class="text-muted d-block">Mã Ticket</small>
                                                    <!-- Priority -->
                                                    <div class="mb-3">
                                                        <small class="text-muted d-block mb-1">Độ ưu tiên</small>
                                                        <select class="form-select form-select-sm" id="prioritySelect"
                                                            onchange="updatePriority(${ticket.id})"
                                                            ${sessionScope.userRole.name !='MANAGER' ? 'disabled' : ''
                                                            }>
                                                            <option value="Low" ${ticket.priority=='Low' ? 'selected'
                                                                : '' }>Thấp (Low)</option>
                                                            <option value="Medium" ${ticket.priority=='Medium'
                                                                ? 'selected' : '' }>Trung bình (Medium)</option>
                                                            <option value="High" ${ticket.priority=='High' ? 'selected'
                                                                : '' }>Cao (High)</option>
                                                            <option value="Critical" ${ticket.priority=='Critical'
                                                                ? 'selected' : '' }>Khẩn cấp (Critical)</option>
                                                        </select>
                                                    </div>

                                                    <!-- Info Only -->
                                                    <p class="text-muted small">Thông tin quản lý đã được chuyển lên đầu
                                                        trang.</p>
                                                </div>

                                                <!-- Back Button -->
                                                <div class="d-grid">
                                                    <a href="${pageContext.request.contextPath}/tickets"
                                                        class="btn btn-outline-secondary">
                                                        <i class="fa fa-arrow-left me-2"></i>Quay lại danh sách
                                                    </a>
                                                </div>

                                            </div>
                                        </div>
                                    </div>

                                    <%@ include file="/includes/footer.jsp" %>
                                </div>
                                <!-- Content End -->
                        </div>

                        <!-- JavaScript Libraries -->
                        <%@ include file="/includes/scripts.jsp" %>

                            <script>
                                // Update Status
                                function updateStatus(ticketId) {
                                    const status = document.getElementById('statusSelect').value;
                                    if (!confirm('Bạn có chắc muốn đổi trạng thái sang ' + status + '?')) return;

                                    $.post('${pageContext.request.contextPath}/tickets', {
                                        action: 'update-status',
                                        id: ticketId,
                                        status: status
                                    }, function (response) {
                                        if (response.success) {
                                            alert(response.message);
                                            location.reload();
                                        } else {
                                            alert(response.message);
                                        }
                                    }).fail(function (xhr, status, error) {
                                        alert('Lỗi kết nối: ' + error);
                                    });
                                }

                                // Update Priority
                                function updatePriority(ticketId) {
                                    const priority = document.getElementById('prioritySelect').value;
                                    $.post('${pageContext.request.contextPath}/tickets', {
                                        action: 'update-priority',
                                        id: ticketId,
                                        priority: priority
                                    }, function (response) {
                                        alert(response.message);
                                    }).fail(function (xhr, status, error) {
                                        alert('Lỗi kết nối: ' + error);
                                    });
                                }

                                // Assign Ticket
                                function assignTicket(ticketId, btnElement) {
                                    console.log('assignTicket called with ticketId:', ticketId);

                                    const selectElement = document.getElementById('assignSelect');
                                    if (!selectElement) {
                                        console.error('assignSelect element not found');
                                        alert('Lỗi: Không tìm thấy danh sách nhân viên.');
                                        return;
                                    }
                                    const userId = selectElement.value;
                                    console.log('Selected userId:', userId);


                                    let confirmMsg = 'Phân công ticket cho nhân viên này?';
                                    if (!userId) {
                                        confirmMsg = 'Bạn có chắc muốn hủy phân công (Unassign) ticket này?';
                                    }

                                    if (!confirm(confirmMsg)) return;

                                    // Disable button
                                    if (btnElement) btnElement.disabled = true;

                                    console.log('Sending POST request...');
                                    $.post('${pageContext.request.contextPath}/tickets', {
                                        action: 'assign',
                                        id: ticketId,
                                        userId: userId
                                    }, function (response) {
                                        console.log('Response received:', response);
                                        if (response.success) {
                                            alert(response.message);
                                            window.location.href = '${pageContext.request.contextPath}/tickets';
                                        } else {
                                            alert(response.message);
                                            if (btnElement) btnElement.disabled = false;
                                        }
                                    }).fail(function (xhr, status, error) {
                                        console.error('AJAX error:', xhr, status, error);
                                        let msg = 'Lỗi kết nối server: ' + error;
                                        if (xhr.status === 200) {
                                            msg = 'Lỗi xử lý phản hồi (Invalid JSON). Xem console để biết thêm chi tiết.';
                                        }
                                        alert(msg);
                                        if (btnElement) btnElement.disabled = false;
                                    });
                                }

                                // Claim Ticket
                                function claimTicket(ticketId) {
                                    if (!confirm('Bạn có muốn nhận xử lý ticket này?')) return;

                                    $.post('${pageContext.request.contextPath}/tickets', {
                                        action: 'claim',
                                        id: ticketId
                                    }, function (response) {
                                        if (response.success) {
                                            alert(response.message);
                                            location.reload();
                                        } else {
                                            alert(response.message);
                                        }
                                    });
                                }

                                // Submit Activity
                                function submitActivity() {
                                    const form = document.getElementById('activityForm');
                                    if (!form.checkValidity()) {
                                        form.reportValidity();
                                        return;
                                    }

                                    const formData = $(form).serialize();

                                    $.post('${pageContext.request.contextPath}/tickets', formData, function (response) {
                                        if (response.success) {
                                            // Reload to show new comment
                                            location.reload();
                                        } else {
                                            alert(response.message);
                                        }
                                    });
                                }

                                // Scroll to bottom of chat
                                $(document).ready(function () {
                                    const stream = document.getElementById('activityStream');
                                    stream.scrollTop = stream.scrollHeight;
                                });
                            </script>
            </body>

            </html>