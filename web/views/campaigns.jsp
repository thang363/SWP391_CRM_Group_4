<%-- campaigns.jsp - Quản lý Chiến dịch Marketing --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <% request.setAttribute("currentPage", "campaigns" ); %>

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <title>Quản lý Chiến dịch - CRM System</title>
                        <%@ include file="/includes/head.jsp" %>
                            <style>
                                .badge-draft {
                                    background-color: #6c757d;
                                }

                                .badge-pending {
                                    background-color: #ffc107;
                                }

                                .badge-approved {
                                    background-color: #17a2b8;
                                }

                                .badge-active {
                                    background-color: #28a745;
                                }

                                .badge-finished {
                                    background-color: #007bff;
                                }

                                .badge-rejected {
                                    background-color: #dc3545;
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

                                                <!-- Campaign Management Content -->
                                                <div class="container-fluid pt-4 px-4">
                                                    <!-- Page Header -->
                                                    <div class="row mb-4">
                                                        <div class="col-12">
                                                            <div
                                                                class="d-flex justify-content-between align-items-center">
                                                                <h3 class="mb-0"><i class="fa fa-bullhorn me-2"></i>Quản
                                                                    lý Chiến dịch</h3>
                                                                <button type="button" class="btn btn-primary"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#campaignModal"
                                                                    onclick="openCreateModal()">
                                                                    <i class="fa fa-plus me-2"></i>Thêm mới
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Filter Section -->
                                                    <div class="filter-section">
                                                        <form id="filterForm" method="get"
                                                            action="${pageContext.request.contextPath}/campaigns">
                                                            <div class="row g-3">
                                                                <div class="col-md-3">
                                                                    <label class="form-label">Tên chiến dịch</label>
                                                                    <input type="text" class="form-control" name="name"
                                                                        id="filterName" placeholder="Tìm kiếm..."
                                                                        value="${param.name}">
                                                                </div>
                                                                <div class="col-md-2">
                                                                    <label class="form-label">Trạng thái</label>
                                                                    <select class="form-select" name="status"
                                                                        id="filterStatus">
                                                                        <option value="">Tất cả</option>
                                                                        <option value="Draft" ${param.status=='Draft'
                                                                            ? 'selected' : '' }>Draft</option>
                                                                        <option value="Pending"
                                                                            ${param.status=='Pending' ? 'selected' : ''
                                                                            }>Pending</option>
                                                                        <option value="Approved"
                                                                            ${param.status=='Approved' ? 'selected' : ''
                                                                            }>Approved</option>
                                                                        <option value="Active" ${param.status=='Active'
                                                                            ? 'selected' : '' }>Active</option>
                                                                        <option value="Finished"
                                                                            ${param.status=='Finished' ? 'selected' : ''
                                                                            }>Finished</option>
                                                                        <option value="Rejected"
                                                                            ${param.status=='Rejected' ? 'selected' : ''
                                                                            }>Rejected</option>
                                                                    </select>
                                                                </div>
                                                                <div class="col-md-2">
                                                                    <label class="form-label">Từ ngày</label>
                                                                    <input type="date" class="form-control"
                                                                        name="startDate" id="filterStartDate"
                                                                        value="${param.startDate}">
                                                                </div>
                                                                <div class="col-md-2">
                                                                    <label class="form-label">Đến ngày</label>
                                                                    <input type="date" class="form-control"
                                                                        name="endDate" id="filterEndDate"
                                                                        value="${param.endDate}">
                                                                </div>
                                                                <div class="col-md-3 d-flex align-items-end">
                                                                    <button type="submit"
                                                                        class="btn btn-primary w-100 me-2">
                                                                        <i class="fa fa-search me-1"></i>Tìm kiếm
                                                                    </button>
                                                                    <button type="button"
                                                                        class="btn btn-secondary w-100"
                                                                        onclick="resetFilters()">
                                                                        <i class="fa fa-redo me-1"></i>Đặt lại
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div>

                                                    <!-- Campaigns Table -->
                                                    <div class="row">
                                                        <div class="col-12">
                                                            <div class="bg-light rounded p-4">
                                                                <div class="table-responsive">
                                                                    <table class="table table-hover">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>ID</th>
                                                                                <th>Tên chiến dịch</th>
                                                                                <th>Ngân sách</th>
                                                                                <th>Thời gian</th>
                                                                                <th>Người phụ trách</th>
                                                                                <th>Trạng thái</th>
                                                                                <th class="table-actions">Thao tác</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody id="campaignTableBody">
                                                                            <c:choose>
                                                                                <c:when test="${empty campaigns}">
                                                                                    <tr>
                                                                                        <td colspan="7"
                                                                                            class="text-center text-muted">
                                                                                            <i
                                                                                                class="fa fa-inbox fa-3x mb-3 d-block"></i>
                                                                                            Chưa có chiến dịch nào
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <c:forEach var="campaign"
                                                                                        items="${campaigns}">
                                                                                        <tr
                                                                                            id="campaign-row-${campaign.id}">
                                                                                            <td>${campaign.id}</td>
                                                                                            <td>
                                                                                                <strong>${campaign.name}</strong>
                                                                                                <c:if
                                                                                                    test="${not empty campaign.description}">
                                                                                                    <br><small
                                                                                                        class="text-muted">${campaign.description}</small>
                                                                                                </c:if>
                                                                                            </td>
                                                                                            <td>
                                                                                                <fmt:formatNumber
                                                                                                    value="${campaign.budget}"
                                                                                                    type="currency"
                                                                                                    currencySymbol="₫"
                                                                                                    groupingUsed="true" />
                                                                                            </td>
                                                                                            <td>
                                                                                                <fmt:formatDate
                                                                                                    value="${campaign.startDate}"
                                                                                                    pattern="dd/MM/yyyy" />
                                                                                                <br>
                                                                                                <small
                                                                                                    class="text-muted">đến</small>
                                                                                                <br>
                                                                                                <fmt:formatDate
                                                                                                    value="${campaign.endDate}"
                                                                                                    pattern="dd/MM/yyyy" />
                                                                                            </td>
                                                                                            <td>${campaign.managerName
                                                                                                != null ?
                                                                                                campaign.managerName :
                                                                                                '-'}</td>
                                                                                            <td>
                                                                                                <span
                                                                                                    class="badge badge-${campaign.status.toLowerCase()}">${campaign.status}</span>
                                                                                            </td>
                                                                                            <td class="table-actions">
                                                                                                <button
                                                                                                    class="btn btn-sm btn-info"
                                                                                                    onclick="editCampaign(${campaign.id})"
                                                                                                    title="Chỉnh sửa">
                                                                                                    <i
                                                                                                        class="fa fa-edit"></i>
                                                                                                </button>
                                                                                                <button
                                                                                                    class="btn btn-sm btn-danger"
                                                                                                    onclick="deleteCampaign(${campaign.id}, '${campaign.name}')"
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

                                    <!-- Back to Top -->
                                    <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                            class="bi bi-arrow-up"></i></a>
                        </div>

                        <!-- Campaign Modal -->
                        <div class="modal fade" id="campaignModal" tabindex="-1" aria-labelledby="campaignModalLabel"
                            aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="campaignModalLabel">Thêm chiến dịch mới</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form id="campaignForm">
                                            <input type="hidden" id="campaignId" name="id">

                                            <div class="mb-3">
                                                <label for="campaignName" class="form-label">Tên chiến dịch <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="campaignName" name="name"
                                                    required maxlength="255">
                                                <div class="invalid-feedback">Vui lòng nhập tên chiến dịch</div>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label for="campaignBudget" class="form-label">Ngân sách
                                                        (VNĐ)</label>
                                                    <input type="number" class="form-control" id="campaignBudget"
                                                        name="budget" min="0" step="1000" value="0">
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label for="campaignManager" class="form-label">Người phụ
                                                        trách</label>
                                                    <select class="form-select" id="campaignManager" name="managerId">
                                                        <option value="">-- Chọn Manager --</option>
                                                        <c:forEach var="manager" items="${managers}">
                                                            <option value="${manager.id}">${manager.fullName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label for="campaignStartDate" class="form-label">Ngày bắt đầu <span
                                                            class="text-danger">*</span></label>
                                                    <input type="date" class="form-control" id="campaignStartDate"
                                                        name="startDate" required>
                                                    <div class="invalid-feedback">Vui lòng chọn ngày bắt đầu</div>
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label for="campaignEndDate" class="form-label">Ngày kết thúc <span
                                                            class="text-danger">*</span></label>
                                                    <input type="date" class="form-control" id="campaignEndDate"
                                                        name="endDate" required>
                                                    <div class="invalid-feedback">Vui lòng chọn ngày kết thúc</div>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <label for="campaignDescription" class="form-label">Mô tả / Ghi
                                                    chú</label>
                                                <textarea class="form-control" id="campaignDescription"
                                                    name="description" rows="3"></textarea>
                                            </div>

                                            <div class="alert alert-danger d-none" id="formErrorAlert"></div>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <button type="button" class="btn btn-primary" onclick="saveCampaign()">
                                            <i class="fa fa-save me-2"></i>Lưu nháp
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Include Scripts --%>
                            <%@ include file="/includes/scripts.jsp" %>

                                <script>
                                    // Hide spinner when page loads
                                    document.addEventListener('DOMContentLoaded', function () {
                                        var spinner = document.getElementById('spinner');
                                        if (spinner) {
                                            spinner.classList.remove('show');
                                        }
                                    });

                                    let isEditMode = false;

                                    function openCreateModal() {
                                        isEditMode = false;
                                        document.getElementById('campaignModalLabel').textContent = 'Thêm chiến dịch mới';
                                        document.getElementById('campaignForm').reset();
                                        document.getElementById('campaignId').value = '';
                                        document.getElementById('formErrorAlert').classList.add('d-none');
                                        document.getElementById('campaignForm').classList.remove('was-validated');
                                    }

                                    function editCampaign(id) {
                                        isEditMode = true;
                                        document.getElementById('campaignModalLabel').textContent = 'Chỉnh sửa chiến dịch';
                                        document.getElementById('formErrorAlert').classList.add('d-none');

                                        // Fetch campaign data
                                        fetch('${pageContext.request.contextPath}/campaigns?action=get&id=' + id)
                                            .then(response => response.json())
                                            .then(result => {
                                                if (result.success && result.data) {
                                                    const campaign = result.data;
                                                    document.getElementById('campaignId').value = campaign.id;
                                                    document.getElementById('campaignName').value = campaign.name;
                                                    document.getElementById('campaignBudget').value = campaign.budget;
                                                    document.getElementById('campaignStartDate').value = formatDateForInput(campaign.startDate);
                                                    document.getElementById('campaignEndDate').value = formatDateForInput(campaign.endDate);
                                                    document.getElementById('campaignManager').value = campaign.managerId || '';
                                                    document.getElementById('campaignDescription').value = campaign.description || '';

                                                    // Show modal
                                                    new bootstrap.Modal(document.getElementById('campaignModal')).show();
                                                } else {
                                                    showAlert('danger', result.message || 'Không thể tải thông tin chiến dịch');
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error:', error);
                                                showAlert('danger', 'Lỗi khi tải thông tin chiến dịch');
                                            });
                                    }

                                    function saveCampaign() {
                                        const form = document.getElementById('campaignForm');

                                        // Validate form
                                        if (!form.checkValidity()) {
                                            form.classList.add('was-validated');
                                            return;
                                        }

                                        // Validate date range
                                        const startDate = new Date(document.getElementById('campaignStartDate').value);
                                        const endDate = new Date(document.getElementById('campaignEndDate').value);

                                        if (startDate >= endDate) {
                                            showFormError('Ngày bắt đầu phải trước ngày kết thúc');
                                            return;
                                        }

                                        // Prepare form data using URLSearchParams for application/x-www-form-urlencoded
                                        const params = new URLSearchParams();
                                        new FormData(form).forEach((value, key) => params.append(key, value));

                                        params.append('action', isEditMode ? 'update' : 'create');
                                        if (!params.has('status')) {
                                            params.append('status', 'Draft');
                                        }

                                        console.log('Saving campaign:', Object.fromEntries(params));

                                        // Send request
                                        fetch('${pageContext.request.contextPath}/campaigns', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                                            },
                                            body: params
                                        })
                                            .then(response => {
                                                if (!response.ok) throw new Error('Network response was not ok');
                                                return response.json();
                                            })
                                            .then(result => {
                                                if (result.success) {
                                                    // Close modal safely
                                                    const modalEl = document.getElementById('campaignModal');
                                                    const modal = bootstrap.Modal.getInstance(modalEl);
                                                    if (modal) modal.hide();

                                                    // Show success message and reload
                                                    showAlert('success', result.message);
                                                    setTimeout(() => {
                                                        window.location.reload();
                                                    }, 1000);
                                                } else {
                                                    showFormError(result.message);
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error saving campaign:', error);
                                                showFormError('Lỗi khi lưu chiến dịch: ' + error.message);
                                            });
                                    }

                                    function deleteCampaign(id, name) {
                                        if (!confirm('Bạn có chắc chắn muốn xóa chiến dịch "' + name + '"?')) {
                                            return;
                                        }

                                        const params = new URLSearchParams();
                                        params.append('action', 'delete');
                                        params.append('id', id);

                                        console.log('Deleting campaign:', id);

                                        fetch('${pageContext.request.contextPath}/campaigns', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                                            },
                                            body: params
                                        })
                                            .then(response => {
                                                if (!response.ok) throw new Error('Network response was not ok');
                                                return response.json();
                                            })
                                            .then(result => {
                                                if (result.success) {
                                                    // Remove row from table
                                                    const row = document.getElementById('campaign-row-' + id);
                                                    if (row) row.remove();
                                                    showAlert('success', result.message);
                                                } else {
                                                    showAlert('danger', result.message);
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error deleting campaign:', error);
                                                showAlert('danger', 'Lỗi khi xóa chiến dịch: ' + error.message);
                                            });
                                    }

                                    function resetFilters() {
                                        document.getElementById('filterName').value = '';
                                        document.getElementById('filterStatus').value = '';
                                        document.getElementById('filterStartDate').value = '';
                                        document.getElementById('filterEndDate').value = '';
                                        document.getElementById('filterForm').submit();
                                    }

                                    function showFormError(message) {
                                        const alert = document.getElementById('formErrorAlert');
                                        alert.textContent = message;
                                        alert.classList.remove('d-none');
                                    }

                                    function showAlert(type, message) {
                                        // Create alert element
                                        const alertDiv = document.createElement('div');
                                        alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3`;
                                        alertDiv.style.zIndex = '9999';
                                        alertDiv.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;

                                        document.body.appendChild(alertDiv);

                                        // Auto remove after 3 seconds
                                        setTimeout(() => {
                                            alertDiv.remove();
                                        }, 3000);
                                    }

                                    function formatDateForInput(dateString) {
                                        if (!dateString) return '';
                                        const date = new Date(dateString);
                                        const year = date.getFullYear();
                                        const month = String(date.getMonth() + 1).padStart(2, '0');
                                        const day = String(date.getDate()).padStart(2, '0');
                                        return `${year}-${month}-${day}`;
                                    }
                                </script>
                    </body>

                    </html>