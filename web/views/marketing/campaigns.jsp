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

                                .badge-paused {
                                    background-color: #fd7e14;
                                    /* Orange */
                                    color: white;
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
                                                            <input type="hidden" name="page" id="pageInput" value="1">
                                                            <input type="hidden" name="ownerFilter" id="ownerFilterInput" value="${ownerFilter}">
                                                            
                                                            <!-- Toggle All / Mine -->
                                                            <div class="row mb-3">
                                                                <div class="col-12">
                                                                    <div class="btn-group" role="group">
                                                                        <button type="button" class="btn btn-outline-primary ${ownerFilter == 'all' ? 'active' : ''}" 
                                                                                onclick="setOwnerFilter('all')">Tất cả</button>
                                                                        <button type="button" class="btn btn-outline-primary ${ownerFilter == 'mine' ? 'active' : ''}" 
                                                                                onclick="setOwnerFilter('mine')">Của tôi</button>
                                                                    </div>
                                                                </div>
                                                            </div>
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
                                                                        <option value="Active" ${param.status=='Active'
                                                                            ? 'selected' : '' }>Active
                                                                        </option>
                                                                        <option value="Paused" ${param.status=='Paused'
                                                                            ? 'selected' : '' }>Paused
                                                                        </option>
                                                                        <option value="Finished"
                                                                            ${param.status=='Finished' ? 'selected' : ''
                                                                            }>Finished</option>
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
                                                                <div class="col-md-3 d-flex align-items-end gap-2">
                                                                    <button type="submit"
                                                                        class="btn btn-primary flex-grow-1">
                                                                        <i class="fa fa-search me-1"></i>Tìm kiếm
                                                                    </button>
                                                                    <button type="button"
                                                                        class="btn btn-secondary flex-grow-1"
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
                                                                                                <c:if test="${campaign.isOwner}">
                                                                                                    <span class="badge bg-primary ms-1" style="font-size: 0.7rem;">Của tôi</span>
                                                                                                </c:if>
                                                                                                <c:if
                                                                                                    test="${not empty campaign.description}">
                                                                                                    <br><small
                                                                                                        class="text-muted">${campaign.description}</small>
                                                                                                </c:if>
                                                                                            </td>
                                                                                            <td>
                                                                                                ${campaign.formattedBudget}
                                                                                            </td>
                                                                                            <td>
                                                                                                ${campaign.formattedStartDate}
                                                                                                <br>
                                                                                                <small
                                                                                                    class="text-muted">đến</small>
                                                                                                <br>
                                                                                                ${campaign.formattedEndDate}
                                                                                            </td>
                                                                                            <td>${campaign.managerName
                                                                                                != null ?
                                                                                                campaign.managerName :
                                                                                                '-'}</td>
                                                                                            <td>
                                                                                                <span
                                                                                                    class="badge bg-${campaign.statusBadgeClass}">${campaign.statusDisplayName}</span>
                                                                                            </td>
                                                                                            <td class="table-actions">
                                                                                                <c:choose>
                                                                                                    <c:when
                                                                                                        test="${campaign.hasPendingTransfer}">
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-secondary"
                                                                                                            disabled
                                                                                                            title="Đang chuyển giao - không thể chỉnh sửa">
                                                                                                            <i
                                                                                                                class="fa fa-lock"></i>
                                                                                                        </button>
                                                                                                    </c:when>
                                                                                                    <c:when
                                                                                                        test="${campaign.status == 'Finished'}">
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-secondary"
                                                                                                            disabled
                                                                                                            title="Chiến dịch đã kết thúc - không thể chỉnh sửa">
                                                                                                            <i
                                                                                                                class="fa fa-edit"></i>
                                                                                                        </button>
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-info"
                                                                                                            onclick="editCampaign(${campaign.id})"
                                                                                                            title="Chỉnh sửa">
                                                                                                            <i
                                                                                                                class="fa fa-edit"></i>
                                                                                                        </button>
                                                                                                    </c:otherwise>
                                                                                                </c:choose>
                                                                                                <c:choose>
                                                                                                    <c:when
                                                                                                        test="${campaign.hasPendingTransfer}">
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-secondary"
                                                                                                            disabled
                                                                                                            title="Đang chuyển giao - không thể xóa">
                                                                                                            <i
                                                                                                                class="fa fa-lock"></i>
                                                                                                        </button>
                                                                                                    </c:when>
                                                                                                    <c:when
                                                                                                        test="${campaign.status != 'Draft'}">
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-secondary"
                                                                                                            disabled
                                                                                                            title="Chỉ có thể xóa chiến dịch Nháp (Draft)">
                                                                                                            <i
                                                                                                                class="fa fa-trash"></i>
                                                                                                        </button>
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-danger"
                                                                                                            onclick="deleteCampaign(${campaign.id}, '${campaign.name}')"
                                                                                                            title="Xóa">
                                                                                                            <i
                                                                                                                class="fa fa-trash"></i>
                                                                                                        </button>
                                                                                                    </c:otherwise>
                                                                                                </c:choose>
                                                                                                <c:choose>
                                                                                                    <c:when
                                                                                                        test="${campaign.hasPendingTransfer}">
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-secondary"
                                                                                                            disabled
                                                                                                            title="Đã có yêu cầu chuyển giao đang chờ xử lý">
                                                                                                            <i
                                                                                                                class="fa fa-exchange-alt"></i>
                                                                                                        </button>
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-warning"
                                                                                                            onclick="openTransferModal(${campaign.id}, '${campaign.name}')"
                                                                                                            title="Chuyển giao (Handover)">
                                                                                                            <i
                                                                                                                class="fa fa-exchange-alt"></i>
                                                                                                        </button>
                                                                                                    </c:otherwise>
                                                                                                </c:choose>
                                                                                                <a href="${pageContext.request.contextPath}/landing-pages?campaignId=${campaign.id}"
                                                                                                    class="btn btn-sm btn-dark"
                                                                                                    title="Xem Landing Pages">
                                                                                                    <i
                                                                                                        class="fa fa-file-code"></i>
                                                                                                </a>
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
                                                <div class="col-md-12 mb-3">
                                                    <label for="campaignBudget" class="form-label">Ngân sách
                                                        (VNĐ)</label>
                                                    <input type="number" class="form-control" id="campaignBudget"
                                                        name="budget" min="0" step="1000" value="0">
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

                                            <div class="mb-3" id="statusContainer">
                                                <label for="campaignStatus" class="form-label">Trạng thái</label>
                                                <select class="form-select" id="campaignStatus" name="status">
                                                    <option value="Draft">Draft</option>
                                                    <option value="Active">Active</option>
                                                    <option value="Paused">Paused</option>
                                                    <option value="Finished">Finished</option>
                                                </select>
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
                                            <i class="fa fa-save me-2"></i>Lưu
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Transfer Modal -->
                        <div class="modal fade" id="transferModal" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Chuyển giao Chiến dịch</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form id="transferForm">
                                            <input type="hidden" id="transferCampaignId" name="campaignId">
                                            <div class="mb-3">
                                                <label class="form-label">Chiến dịch đang chọn:</label>
                                                <input type="text" class="form-control" id="transferCampaignName"
                                                    readonly>
                                            </div>
                                            <div class="mb-3">
                                                <label for="transferToManager" class="form-label">Người nhận (Manager)
                                                    <span class="text-danger">*</span></label>
                                                <select class="form-select" id="transferToManager" name="toManagerId"
                                                    required>
                                                    <option value="">-- Chọn Manager --</option>
                                                    <c:forEach var="manager" items="${managers}">
                                                        <option value="${manager.id}">${manager.fullName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="transferReason" class="form-label">Lý do chuyển giao <span
                                                        class="text-danger">*</span></label>
                                                <textarea class="form-control" id="transferReason" name="reason"
                                                    rows="3" required></textarea>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <button type="button" class="btn btn-warning" onclick="submitTransfer()">Gửi yêu
                                            cầu</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- LP Assignment Modal (REMOVED - Moved to /landing-pages) -->

                        <%-- Include Scripts --%>
                            <%@ include file="/includes/scripts.jsp" %>

                                <%-- Campaign Management JavaScript --%>
                                    <script src="${pageContext.request.contextPath}/js/campaigns.js"></script>
                                    <script>
                                        // Initialize campaigns.js with context path
                                        initCampaignsJS('${pageContext.request.contextPath}');
                                        
                                        function setOwnerFilter(value) {
                                            document.getElementById('ownerFilterInput').value = value;
                                            document.getElementById('pageInput').value = 1; // Reset to page 1
                                            document.getElementById('filterForm').submit();
                                        }
                                    </script>

                    </body>

                    </html>