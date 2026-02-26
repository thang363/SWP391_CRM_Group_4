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

                        .readonly-select {
                            appearance: none;
                            -webkit-appearance: none;
                            -moz-appearance: none;
                            background-image: none !important;
                            background-color: #f8f9fa !important;
                            cursor: default;
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
                                            <c:if test="${ticket.status == 'Closed'}">
                                                <div class="alert alert-warning" role="alert">
                                                    <i class="fa fa-lock me-2"></i>
                                                    Ticket này đã được đóng. Vui lòng tạo ticket mới nếu có vấn đề phát
                                                    sinh.
                                                </div>
                                            </c:if>
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



                                                        <!-- Assign -->
                                                        <c:if test="${sessionScope.userRole.name == 'MANAGER'}">
                                                            <div
                                                                class="d-flex justify-content-between align-items-center w-100">
                                                                <label class="fw-bold me-2">Assign:</label>
                                                                <div
                                                                    class="d-flex gap-1 align-items-start position-relative w-100">
                                                                    <div class="position-relative w-100">
                                                                        <input type="text"
                                                                            class="form-control form-control-sm"
                                                                            id="assignSearchInput"
                                                                            placeholder="Tìm nhân viên..."
                                                                            autocomplete="off"
                                                                            value="${ticket.assignedToName}">
                                                                        <input type="hidden" id="assignSelect"
                                                                            value="${ticket.assignedTo}">

                                                                        <div id="assignDropdownList"
                                                                            class="position-absolute bg-white border w-100 shadow rounded mt-1"
                                                                            style="display:none; max-height: 200px; overflow-y: auto; z-index: 1050;">
                                                                            <!-- "Unassigned" option -->
                                                                            <div class="assign-option p-2 border-bottom text-muted"
                                                                                data-id="" data-name="None"
                                                                                style="cursor: pointer;">
                                                                                None
                                                                            </div>
                                                                            <c:forEach var="agent" items="${agents}">
                                                                                <div class="assign-option p-2 border-bottom"
                                                                                    data-id="${agent.id}"
                                                                                    data-name="${agent.fullName}"
                                                                                    style="cursor: pointer;">
                                                                                    ${agent.fullName}
                                                                                </div>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </div>
                                                                    <button type="button" class="btn btn-sm btn-primary"
                                                                        onclick="assignTicket(${ticket.id}, this)">
                                                                        <i class="fa fa-check"></i>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </c:if>
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
                                                <div class="mt-3" ${ticket.status=='Closed' ? 'style="display:none;"'
                                                    : '' }>
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

                                            <!-- Claim Button -->
                                            <c:if test="${canClaim}">
                                                <div class="mb-4">
                                                    <button class="btn btn-warning w-100 fw-bold"
                                                        onclick="claimTicket(${ticket.id})">
                                                        <i class="fa fa-hand-paper me-2"></i>Nhận xử lý (Claim)
                                                    </button>
                                                </div>
                                            </c:if>

                                            <!-- Resolve Button -->
                                            <c:if
                                                test="${ticket.status != 'Closed' && ticket.status != 'Resolved' && (canEdit || sessionScope.userRole.name == 'MANAGER')}">
                                                <div class="mb-4">
                                                    <button class="btn btn-success w-100 fw-bold" data-bs-toggle="modal"
                                                        data-bs-target="#resolveModal">
                                                        <i class="fa fa-check-circle me-2"></i>Xử lý xong (Resolve)
                                                    </button>
                                                </div>
                                            </c:if>

                                            <!-- Re-open Button (Manager only) -->
                                            <c:if
                                                test="${ticket.status == 'Closed' && sessionScope.userRole.name == 'MANAGER'}">
                                                <div class="mb-4">
                                                    <button class="btn btn-danger w-100 fw-bold"
                                                        onclick="reopenTicket(${ticket.id})">
                                                        <i class="fa fa-undo me-2"></i>Mở lại ticket (Re-open)
                                                    </button>
                                                </div>
                                            </c:if>

                                            <!-- Ticket Metadata -->
                                            <div class="bg-light rounded p-4 mb-4">
                                                <h6 class="mb-3 fw-bold border-bottom pb-2">Thông tin ticket</h6>
                                                <div class="mb-3">
                                                    <small class="text-muted d-block mb-3">Mã Ticket :
                                                        ${ticket.id}</small>

                                                    <!-- Status -->
                                                    <div class="mb-3">
                                                        <small class="text-muted d-block mb-1">Trạng thái</small>
                                                        <select class="form-select form-select-sm readonly-select"
                                                            id="statusSelect" disabled>
                                                            <option value="Open" ${ticket.status=='Open' ? 'selected'
                                                                : '' }>Mới (Open)</option>
                                                            <option value="In Progress" ${ticket.status=='In Progress'
                                                                ? 'selected' : '' }>
                                                                Đang xử lý</option>
                                                            <option value="Resolved" ${ticket.status=='Resolved'
                                                                ? 'selected' : '' }>Đã giải quyết</option>
                                                            <option value="Closed" ${ticket.status=='Closed'
                                                                ? 'selected' : '' }>Đóng</option>
                                                        </select>
                                                    </div>
                                                    <!-- Priority -->
                                                    <div class="mb-3">
                                                        <small class="text-muted d-block mb-1">Độ ưu tiên</small>
                                                        <select class="form-select form-select-sm readonly-select"
                                                            id="prioritySelect" onchange="updatePriority(${ticket.id})"
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
                                    showConfirmDialog(
                                        'Bạn có chắc muốn đổi trạng thái sang <strong>' + status + '</strong>?',
                                        function () {
                                            $.post('${pageContext.request.contextPath}/tickets', {
                                                action: 'update-status',
                                                id: ticketId,
                                                status: status
                                            }, function (response) {
                                                if (response.success) {
                                                    location.reload();
                                                } else {
                                                    showToast('error', response.message);
                                                }
                                            }).fail(function (xhr, status, error) {
                                                showToast('error', 'Lỗi kết nối: ' + error);
                                            });
                                        },
                                        { title: 'Đổi trạng thái', confirmText: 'Đồng ý', confirmClass: 'btn-primary' }
                                    );
                                }

                                // Update Priority
                                function updatePriority(ticketId) {
                                    const priority = document.getElementById('prioritySelect').value;
                                    $.post('${pageContext.request.contextPath}/tickets', {
                                        action: 'update-priority',
                                        id: ticketId,
                                        priority: priority
                                    }, function (response) {
                                        if (response.success) {
                                            location.reload();
                                        } else {
                                            showToast('error', response.message);
                                        }
                                    }).fail(function (xhr, status, error) {
                                        showToast('error', 'Lỗi kết nối: ' + error);
                                    });
                                }

                                // Assign Ticket
                                function assignTicket(ticketId, btnElement) {

                                    const selectElement = document.getElementById('assignSelect');
                                    if (!selectElement) {
                                        console.error('assignSelect element not found');
                                        showToast('error', 'Lỗi: Không tìm thấy danh sách nhân viên.');
                                        return;
                                    }
                                    const userId = selectElement.value;


                                    let confirmMsg = 'Phân công ticket cho nhân viên này?';
                                    if (!userId) {
                                        confirmMsg = 'Bạn có chắc muốn hủy phân công (Unassign) ticket này?';
                                    }

                                    showConfirmDialog(
                                        confirmMsg,
                                        function () {
                                            // Disable button
                                            if (btnElement) btnElement.disabled = true;

                                            $.post('${pageContext.request.contextPath}/tickets', {
                                                action: 'assign',
                                                id: ticketId,
                                                userId: userId
                                            }, function (response) {
                                                if (response.success) {
                                                    window.location.href = '${pageContext.request.contextPath}/tickets';
                                                } else {
                                                    showToast('error', response.message);
                                                    if (btnElement) btnElement.disabled = false;
                                                }
                                            }).fail(function (xhr, status, error) {
                                                let msg = 'Lỗi kết nối server: ' + error;
                                                if (xhr.status === 200) {
                                                    msg = 'Lỗi xử lý phản hồi (Invalid JSON). Xem console để biết thêm chi tiết.';
                                                }
                                                showToast('error', msg);
                                                if (btnElement) btnElement.disabled = false;
                                            });
                                        },
                                        { title: 'Phân công ticket', confirmText: 'Xác nhận', confirmClass: 'btn-primary' }
                                    );
                                }

                                // Claim Ticket
                                function claimTicket(ticketId) {
                                    showConfirmDialog(
                                        'Bạn có muốn nhận xử lý ticket này?',
                                        function () {
                                            $.post('${pageContext.request.contextPath}/tickets', {
                                                action: 'claim',
                                                id: ticketId
                                            }, function (response) {
                                                if (response.success) {
                                                    location.reload();
                                                } else {
                                                    showToast('error', response.message);
                                                }
                                            });
                                        },
                                        { title: 'Nhận xử lý ticket', confirmText: 'Nhận xử lý', confirmClass: 'btn-warning' }
                                    );
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
                                            showToast('error', response.message);
                                        }
                                    });
                                }

                                // Scroll to bottom of chat
                                $(document).ready(function () {
                                    const stream = document.getElementById('activityStream');
                                    stream.scrollTop = stream.scrollHeight;
                                });

                                // Searchable Assign Logic
                                $(document).ready(function () {
                                    const $input = $('#assignSearchInput');
                                    const $dropdown = $('#assignDropdownList');
                                    const $hiddenInput = $('#assignSelect');
                                    const $options = $('.assign-option');

                                    // Show dropdown on focus or click
                                    $input.on('focus click', function () {
                                        $dropdown.show();
                                    });

                                    // Filter options
                                    $input.on('input', function () {
                                        const query = $(this).val().toLowerCase();
                                        $options.each(function () {
                                            const name = $(this).data('name').toLowerCase();
                                            if (name.includes(query)) {
                                                $(this).show();
                                            } else {
                                                $(this).hide();
                                            }
                                        });
                                        $dropdown.show();
                                    });

                                    // Handle selection
                                    $dropdown.on('click', '.assign-option', function () {
                                        const id = $(this).data('id');
                                        const name = $(this).data('name');

                                        $hiddenInput.val(id);
                                        $input.val(name);
                                        $dropdown.hide();
                                    });

                                    // Close dropdown when clicking outside
                                    $(document).on('click', function (e) {
                                        if (!$(e.target).closest('.position-relative').length) {
                                            $dropdown.hide();
                                        }
                                    });
                                });

                                // Resolve Ticket
                                function submitResolve() {
                                    const note = document.getElementById('solutionNote').value;
                                    if (!note.trim()) {
                                        showToast('error', 'Vui lòng nhập giải pháp xử lý.');
                                        return;
                                    }

                                    // Close the resolve modal first
                                    var resolveModal = bootstrap.Modal.getInstance(document.getElementById('resolveModal'));
                                    if (resolveModal) resolveModal.hide();

                                    $.post('${pageContext.request.contextPath}/tickets', {
                                        action: 'resolve',
                                        ticketId: ${ ticket.id },
                                        solutionNote: note
                                    }, function (response) {
                                    if (response.success) {
                                        location.reload();
                                    } else {
                                        showToast('error', response.message);
                                    }
                                });
                                }

                                // Re-open Ticket
                                function reopenTicket(ticketId) {
                                    showConfirmDialog(
                                        'Bạn có chắc muốn mở lại ticket này?',
                                        function () {
                                            $.post('${pageContext.request.contextPath}/tickets', {
                                                action: 'reopen',
                                                ticketId: ticketId
                                            }, function (response) {
                                                if (response.success) {
                                                    location.reload();
                                                } else {
                                                    showToast('error', response.message);
                                                }
                                            });
                                        },
                                        { title: 'Mở lại ticket', confirmText: 'Mở lại', confirmClass: 'btn-danger' }
                                    );
                                }

                                // Toast notification helper
                                function showToast(type, message) {
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
                                    setTimeout(function () {
                                        if (toast.parentNode) {
                                            toast.style.transition = 'opacity 0.3s';
                                            toast.style.opacity = '0';
                                            setTimeout(function () { toast.remove(); }, 300);
                                        }
                                    }, 3000);
                                }
                            </script>

                            <!-- Resolve Modal -->
                            <div class="modal fade" id="resolveModal" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Xác nhận xử lý xong</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label for="solutionNote" class="form-label">Giải pháp / Ghi chú <span
                                                        class="text-danger">*</span></label>
                                                <textarea class="form-control" id="solutionNote" rows="4"
                                                    placeholder="Mô tả cách bạn đã giải quyết vấn đề..."></textarea>
                                            </div>
                                            <div class="alert alert-info small">
                                                <i class="fa fa-info-circle me-1"></i>
                                                Sau khi xác nhận, hệ thống sẽ gửi email cho khách hàng để họ kiểm tra
                                                lại.
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Hủy</button>
                                            <button type="button" class="btn btn-success" onclick="submitResolve()">Xác
                                                nhận Resolve</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
            </body>

            </html>