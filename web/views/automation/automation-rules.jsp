<%-- automation-rules.jsp - Automation Rules Management (Manager Only) --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>Automation Rules - CRM System</title>
                    <%@ include file="/includes/head.jsp" %>
                        <style>
                            .filter-section {
                                background-color: #f8f9fa;
                                padding: 1.5rem;
                                border-radius: 0.5rem;
                                margin-bottom: 1.5rem;
                            }

                            .badge-active {
                                background-color: #28a745;
                                color: white;
                            }

                            .badge-inactive {
                                background-color: #6c757d;
                                color: white;
                            }

                            .badge-expiring {
                                background-color: #ffc107;
                                color: black;
                            }

                            .badge-highpotential {
                                background-color: #17a2b8;
                                color: white;
                            }

                            .form-switch .form-check-input {
                                cursor: pointer;
                            }

                            .condition-row {
                                border: 1px solid #dee2e6;
                                border-radius: 0.375rem;
                                padding: 0.75rem;
                                margin-bottom: 0.5rem;
                                background-color: #f8f9fa;
                            }

                            .condition-row:hover {
                                background-color: #e9ecef;
                            }

                            .table td,
                            .table th {
                                vertical-align: middle;
                            }

                            .action-btn {
                                padding: 0.25rem 0.5rem;
                                font-size: 0.85rem;
                            }

                            .table td:last-child {
                                display: flex;
                                gap: 0.35rem;
                                white-space: nowrap;
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

                        <%-- Include Sidebar --%>
                            <%@ include file="/includes/sidebar.jsp" %>

                                <!-- Content Start -->
                                <div class="content">
                                    <%-- Include Top Navbar --%>
                                        <%@ include file="/includes/topbar.jsp" %>

                                            <!-- Automation Rules Content -->
                                            <div class="container-fluid pt-4 px-4">

                                                <!-- Page Header -->
                                                <div class="row mb-4">
                                                    <div class="col-12">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <h3 class="mb-0"><i class="fa fa-cogs me-2"></i>Automation
                                                                Rules</h3>
                                                            <button type="button" class="btn btn-primary"
                                                                onclick="openCreateModal()">
                                                                <i class="fa fa-plus me-2"></i>Tạo Rule mới
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Rules Table -->
                                                <div class="row">
                                                    <div class="col-12">
                                                        <div class="bg-light rounded p-4">
                                                            <div class="table-responsive">
                                                                <table class="table table-hover align-middle">
                                                                    <thead>
                                                                        <tr>
                                                                            <th style="width:5%">#</th>
                                                                            <th style="width:22%">Tên kịch bản</th>
                                                                            <th style="width:13%">Loại đối tượng</th>
                                                                            <th style="width:13%">Hành động</th>
                                                                            <th style="width:17%">Phân công cho</th>
                                                                            <th style="width:10%">Trạng thái</th>
                                                                            <th style="width:12%">Ngày tạo</th>
                                                                            <th style="width:10%">Thao tác</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:choose>
                                                                            <c:when test="${empty rules}">
                                                                                <tr>
                                                                                    <td colspan="8"
                                                                                        class="text-center text-muted py-5">
                                                                                        <i
                                                                                            class="fa fa-inbox fa-3x mb-3 d-block"></i>
                                                                                        Chưa có rule nào. Hãy tạo rule
                                                                                        đầu tiên!
                                                                                    </td>
                                                                                </tr>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:forEach var="rule" items="${rules}"
                                                                                    varStatus="loop">
                                                                                    <tr>
                                                                                        <td><strong>${loop.index +
                                                                                                1}</strong></td>
                                                                                        <td>
                                                                                            <strong>${rule.ruleName}</strong>
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${rule.targetType == 'Expiring'}">
                                                                                                    <span
                                                                                                        class="badge badge-expiring">
                                                                                                        <i
                                                                                                            class="fa fa-clock me-1"></i>Expiring
                                                                                                    </span>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="badge badge-highpotential">
                                                                                                        <i
                                                                                                            class="fa fa-heart me-1"></i>Care
                                                                                                    </span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${rule.actionType == 'CreateTask'}">
                                                                                                    <i
                                                                                                        class="fa fa-tasks text-primary me-1"></i>Tạo
                                                                                                    Task
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <i
                                                                                                        class="fa fa-envelope text-info me-1"></i>Gửi
                                                                                                    Email
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${not empty rule.assignToUserName}">
                                                                                                    <i
                                                                                                        class="fa fa-user me-1"></i>${rule.assignToUserName}
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="text-muted fst-italic">Chưa
                                                                                                        gán</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <div
                                                                                                class="form-check form-switch">
                                                                                                <input
                                                                                                    class="form-check-input"
                                                                                                    type="checkbox"
                                                                                                    id="toggle_${rule.id}"
                                                                                                    ${rule.status=='Active'
                                                                                                    ? 'checked' : '' }
                                                                                                    onchange="toggleStatus(${rule.id}, this.checked)">
                                                                                                <label
                                                                                                    class="form-check-label"
                                                                                                    for="toggle_${rule.id}">
                                                                                                    <span
                                                                                                        class="badge badge-${rule.status == 'Active' ? 'active' : 'inactive'}">
                                                                                                        ${rule.status}
                                                                                                    </span>
                                                                                                </label>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td>
                                                                                            <fmt:formatDate
                                                                                                value="${rule.createdAt}"
                                                                                                pattern="dd/MM/yyyy" />
                                                                                        </td>
                                                                                        <td>
                                                                                            <button
                                                                                                class="btn btn-sm btn-outline-primary action-btn me-1"
                                                                                                onclick="openEditModal(${rule.id})"
                                                                                                title="Sửa">
                                                                                                <i
                                                                                                    class="fa fa-edit"></i>
                                                                                            </button>
                                                                                            <button
                                                                                                class="btn btn-sm btn-outline-danger action-btn"
                                                                                                onclick="deleteRule(${rule.id})"
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
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <%-- Include Footer --%>
                                                <%@ include file="/includes/footer.jsp" %>
                                </div>
                                <!-- Content End -->

                    </div>

                    <!-- Toast Container -->
                    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1060;">
                        <div id="liveToast" class="toast align-items-center border-0" role="alert" aria-live="assertive"
                            aria-atomic="true">
                            <div class="d-flex">
                                <div class="toast-body" id="toastMessage">
                                    Thông báo ở đây.
                                </div>
                                <button type="button" class="btn-close btn-close-white me-2 m-auto"
                                    data-bs-dismiss="toast" aria-label="Close"></button>
                            </div>
                        </div>
                    </div>

                    <!-- Create/Edit Rule Modal -->
                    <div class="modal fade" id="ruleModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header bg-primary text-white">
                                    <h5 class="modal-title" id="ruleModalTitle">Tạo Rule mới</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="ruleForm">
                                        <input type="hidden" id="ruleId" name="id">

                                        <div class="row g-3">
                                            <!-- Rule Name -->
                                            <div class="col-md-12">
                                                <label class="form-label fw-bold">Tên kịch bản <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="ruleName" name="ruleName"
                                                    placeholder="VD: Nhắc gia hạn hợp đồng trước 30 ngày" required>
                                            </div>

                                            <!-- Target Type -->
                                            <div class="col-md-6">
                                                <label class="form-label fw-bold">Loại đối tượng <span
                                                        class="text-danger">*</span></label>
                                                <select class="form-select" id="targetType" name="targetType" required onchange="onTargetTypeChange(this.value)">
                                                    <option value="">-- Chọn --</option>
                                                    <option value="Expiring">Khách sắp hết hạn</option>
                                                    <option value="HighPotential">Chăm sóc khách hàng</option>
                                                </select>
                                            </div>

                                            <!-- Action Type -->
                                            <div class="col-md-6">
                                                <label class="form-label fw-bold">Hành động tự động <span
                                                        class="text-danger">*</span></label>
                                                <select class="form-select" id="actionType" name="actionType" required>
                                                    <option value="CreateTask" selected>Tự động tạo Task</option>
                                                </select>
                                            </div>

                                            <!-- Conditions -->
                                            <div class="col-md-12" id="conditionsSection" style="display:none">
                                                <label class="form-label fw-bold">Điều kiện kích hoạt</label>
                                                <div id="conditionsContainer">
                                                    <!-- Dynamic condition rows will be added here -->
                                                </div>
                                                <button type="button" class="btn btn-outline-secondary btn-sm mt-2"
                                                    id="addCondBtn" onclick="addConditionRow()" style="display:none">
                                                    <i class="fa fa-plus me-1"></i>Thêm điều kiện
                                                </button>
                                            </div>

                                            <!-- Phân công cho -->
                                            <div class="col-md-6">
                                                <label class="form-label fw-bold">Phân công cho</label>
                                                <select class="form-select" id="assignToUser" name="assignToUser">
                                                    <option value="">-- Chọn nhân viên Support --</option>
                                                    <c:forEach var="user" items="${users}">
                                                        <option value="${user.id}">${user.fullName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <!-- Status -->
                                            <div class="col-md-6">
                                                <label class="form-label fw-bold">Trạng thái</label>
                                                <select class="form-select" id="ruleStatus" name="status">
                                                    <option value="Active">Bật (Active)</option>
                                                    <option value="Inactive">Tắt (Inactive)</option>
                                                </select>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="button" class="btn btn-primary" onclick="saveRule()">
                                        <i class="fa fa-save me-2"></i>Lưu Rule
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- Include Scripts --%>
                        <%@ include file="/includes/scripts.jsp" %>

                            <script>
                                // Spinner
                                document.addEventListener('DOMContentLoaded', function () {
                                    var spinner = document.getElementById('spinner');
                                    if (spinner) spinner.classList.remove('show');
                                });

                                let ruleModal;
                                let toastElement;
                                let toast;

                                $(document).ready(function () {
                                    ruleModal = new bootstrap.Modal(document.getElementById('ruleModal'));
                                    toastElement = document.getElementById('liveToast');
                                    toast = new bootstrap.Toast(toastElement, { delay: 3000 });
                                });

                                function showAlert(message, type = 'success') {
                                    const toastMsg = document.getElementById('toastMessage');
                                    toastMsg.textContent = message;

                                    // Reset classes
                                    toastElement.classList.remove('bg-success', 'bg-danger', 'text-white');

                                    if (type === 'success') {
                                        toastElement.classList.add('bg-success', 'text-white');
                                    } else {
                                        toastElement.classList.add('bg-danger', 'text-white');
                                    }

                                    toast.show();
                                }

                                // ======= CONDITION ROWS =======
                                const TIER_OPTIONS = ['Standard', 'Silver', 'Gold', 'Platinum', 'VIP'];

                                // Called when Loại đối tượng changes
                                function onTargetTypeChange(targetType) {
                                    const section = document.getElementById('conditionsSection');
                                    const addBtn = document.getElementById('addCondBtn');
                                    const container = document.getElementById('conditionsContainer');
                                    container.innerHTML = '';

                                    if (!targetType) {
                                        section.style.display = 'none';
                                        return;
                                    }
                                    section.style.display = '';

                                    if (targetType === 'Expiring') {
                                        addBtn.style.display = '';
                                        addConditionRow('lastCareDays', null, null, 'Expiring');
                                    } else if (targetType === 'HighPotential') {
                                        addBtn.style.display = 'none';
                                        addConditionRow('foundedDate', '=', 'TODAY', 'HighPotential');
                                    }
                                }

                                function buildValueInput(field, value) {
                                    if (field === 'tier') {
                                        let opts = TIER_OPTIONS.map(t =>
                                            '<option value="' + t + '"' + (value === t ? ' selected' : '') + '>' + t + '</option>'
                                        ).join('');
                                        return '<select class="form-select form-select-sm cond-value" style="width:40%">' + opts + '</select>';
                                    } else {
                                        return '<input type="number" min="0" class="form-control form-control-sm cond-value" style="width:40%" placeholder="Số ngày (VD: 30)" value="' + (value || '') + '">';
                                    }
                                }

                                function buildOperatorSelect(field, operator) {
                                    if (field === 'tier') {
                                        return '<select class="form-select form-select-sm cond-operator" style="width:15%">' +
                                            '<option value="="' + (!operator || operator === '=' ? ' selected' : '') + '>=</option>' +
                                            '<option value="!="' + (operator === '!=' ? ' selected' : '') + '>!=</option>' +
                                            '</select>';
                                    } else {
                                        return '<select class="form-select form-select-sm cond-operator" style="width:15%">' +
                                            '<option value=">="' + (operator === '>=' ? ' selected' : '') + '>&gt;=</option>' +
                                            '<option value="<="' + (operator === '<=' ? ' selected' : '') + '>&lt;=</option>' +
                                            '<option value="="' + (operator === '=' ? ' selected' : '') + '>=</option>' +
                                            '<option value="!="' + (operator === '!=' ? ' selected' : '') + '>!=</option>' +
                                            '<option value=">"' + (operator === '>' ? ' selected' : '') + '>&gt;</option>' +
                                            '<option value="<"' + (operator === '<' ? ' selected' : '') + '>&lt;</option>' +
                                            '</select>';
                                    }
                                }

                                function addConditionRow(field, operator, value, targetType) {
                                    // Infer targetType from current select if not provided
                                    if (!targetType) {
                                        targetType = document.getElementById('targetType').value;
                                    }

                                    const container = document.getElementById('conditionsContainer');
                                    const row = document.createElement('div');
                                    row.className = 'condition-row d-flex align-items-center gap-2';

                                    if (targetType === 'HighPotential') {
                                        // Fixed: founded_date = TODAY — show as info badge, no editable inputs
                                        row.innerHTML =
                                            '<span class="badge bg-info text-dark fs-6 py-2 px-3" style="width:100%">' +
                                            '<i class="fa fa-birthday-cake me-2"></i>' +
                                            'Kỷ niệm thành lập: <strong>founded_date = Ngày hiện tại</strong>' +
                                            '</span>' +
                                            '<input type="hidden" class="cond-field" value="foundedDate">' +
                                            '<input type="hidden" class="cond-operator" value="=">' +
                                            '<input type="hidden" class="cond-value" value="TODAY">';
                                    } else {
                                        // Expiring: lastCareDays or tier
                                        const selectedField = field || 'lastCareDays';
                                        row.innerHTML =
                                            '<select class="form-select form-select-sm cond-field" style="width:35%" onchange="onCondFieldChange(this)">' +
                                            '<option value="lastCareDays"' + (selectedField === 'lastCareDays' ? ' selected' : '') + '>Ngày chưa care (Last Care Date)</option>' +
                                            '<option value="tier"' + (selectedField === 'tier' ? ' selected' : '') + '>Hạng KH (Tier)</option>' +
                                            '</select>' +
                                            buildOperatorSelect(selectedField, operator) +
                                            buildValueInput(selectedField, value) +
                                            '<button type="button" class="btn btn-sm btn-outline-danger" onclick="this.parentElement.remove()">' +
                                            '<i class="fa fa-times"></i>' +
                                            '</button>';
                                    }
                                    container.appendChild(row);
                                }

                                function onCondFieldChange(selectEl) {
                                    const row = selectEl.parentElement;
                                    const field = selectEl.value;
                                    // Replace operator
                                    const oldOp = row.querySelector('.cond-operator');
                                    oldOp.outerHTML = buildOperatorSelect(field, null);
                                    // Replace value input
                                    const oldVal = row.querySelector('.cond-value');
                                    oldVal.outerHTML = buildValueInput(field, null);
                                }

                                function getConditionsJson() {
                                    const rows = document.querySelectorAll('.condition-row');
                                    const conditions = [];
                                    rows.forEach(function (row) {
                                        const field = row.querySelector('.cond-field').value;
                                        const operator = row.querySelector('.cond-operator').value;
                                        const value = row.querySelector('.cond-value').value.trim();
                                        if (field && value) {
                                            conditions.push({ field: field, operator: operator, value: value });
                                        }
                                    });
                                    return JSON.stringify(conditions);
                                }

                                function loadConditions(conditionsJsonStr, targetType) {
                                    document.getElementById('conditionsContainer').innerHTML = '';
                                    if (!conditionsJsonStr) return;
                                    try {
                                        const conditions = JSON.parse(conditionsJsonStr);
                                        conditions.forEach(function (c) {
                                            addConditionRow(c.field, c.operator, c.value, targetType);
                                        });
                                    } catch (e) {
                                        console.error('Error parsing conditions:', e);
                                    }
                                }

                                // ======= MODAL OPEN =======
                                function openCreateModal() {
                                    document.getElementById('ruleModalTitle').textContent = 'Tạo Rule mới';
                                    document.getElementById('ruleForm').reset();
                                    document.getElementById('ruleId').value = '';
                                    document.getElementById('conditionsContainer').innerHTML = '';
                                    document.getElementById('conditionsSection').style.display = 'none';
                                    document.getElementById('addCondBtn').style.display = 'none';
                                    ruleModal.show();
                                }

                                function openEditModal(id) {
                                    document.getElementById('ruleModalTitle').textContent = 'Chỉnh sửa Rule';

                                    $.ajax({
                                        url: '${pageContext.request.contextPath}/automation-rules',
                                        data: { action: 'get', id: id },
                                        dataType: 'json',
                                        success: function (response) {
                                            if (response.success) {
                                                const d = response.data;
                                                document.getElementById('ruleId').value = d.id;
                                                document.getElementById('ruleName').value = d.ruleName;
                                                document.getElementById('targetType').value = d.targetType;
                                                document.getElementById('actionType').value = d.actionType;
                                                document.getElementById('ruleStatus').value = d.status;

                                                // Assign to user
                                                if (d.assignToUser) {
                                                    document.getElementById('assignToUser').value = d.assignToUser;
                                                }

                                                // Show conditions section
                                                document.getElementById('conditionsSection').style.display = '';
                                                if (d.targetType === 'HighPotential') {
                                                    document.getElementById('addCondBtn').style.display = 'none';
                                                } else {
                                                    document.getElementById('addCondBtn').style.display = '';
                                                }
                                                // Load conditions
                                                loadConditions(JSON.stringify(d.conditionsJson), d.targetType);

                                                ruleModal.show();
                                            } else {
                                                showAlert(response.message, 'danger');
                                            }
                                        },
                                        error: function () {
                                            showAlert('Lỗi tải dữ liệu rule!', 'danger');
                                        }
                                    });
                                }

                                // ======= SAVE =======
                                function saveRule() {
                                    const form = document.getElementById('ruleForm');
                                    if (!form.checkValidity()) {
                                        form.reportValidity();
                                        return;
                                    }

                                    const ruleId = document.getElementById('ruleId').value;
                                    const isEdit = ruleId && ruleId.length > 0;

                                    const params = {
                                        action: isEdit ? 'update' : 'create',
                                        ruleName: document.getElementById('ruleName').value,
                                        targetType: document.getElementById('targetType').value,
                                        conditionsJson: getConditionsJson(),
                                        actionType: document.getElementById('actionType').value,
                                        assignToUser: document.getElementById('assignToUser').value,
                                        status: document.getElementById('ruleStatus').value
                                    };

                                    if (isEdit) params.id = ruleId;

                                    $.post('${pageContext.request.contextPath}/automation-rules', params, function (response) {
                                        if (response.success) {
                                            showAlert(response.message);
                                            setTimeout(() => location.reload(), 1000);
                                        } else {
                                            showAlert(response.message, 'danger');
                                        }
                                    }, 'json').fail(function () {
                                        showAlert('Lỗi kết nối server!', 'danger');
                                    });
                                }

                                // ======= TOGGLE STATUS =======
                                function toggleStatus(id, isActive) {
                                    const status = isActive ? 'Active' : 'Inactive';
                                    $.post('${pageContext.request.contextPath}/automation-rules', {
                                        action: 'toggle-status',
                                        id: id,
                                        status: status
                                    }, function (response) {
                                        if (response.success) {
                                            showAlert(response.message);
                                            setTimeout(() => location.reload(), 500);
                                        } else {
                                            showAlert(response.message, 'danger');
                                            setTimeout(() => location.reload(), 1000);
                                        }
                                    }, 'json').fail(function () {
                                        showAlert('Lỗi kết nối server!', 'danger');
                                        setTimeout(() => location.reload(), 1000);
                                    });
                                }

                                // ======= DELETE =======
                                function deleteRule(id) {
                                    showConfirmDialog(
                                        'Bạn có chắc muốn xóa rule này?',
                                        function () {
                                            $.post('${pageContext.request.contextPath}/automation-rules', {
                                                action: 'delete',
                                                id: id
                                            }, function (response) {
                                                if (response.success) {
                                                    showAlert(response.message);
                                                    setTimeout(() => location.reload(), 1000);
                                                } else {
                                                    showAlert(response.message, 'danger');
                                                }
                                            }, 'json').fail(function () {
                                                showAlert('Lỗi kết nối server!', 'danger');
                                            });
                                        },
                                        { title: 'Xóa Rule', confirmText: 'Xóa', confirmClass: 'btn-danger' }
                                    );
                                }
                            </script>
                </body>

                </html>