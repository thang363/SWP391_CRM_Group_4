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
                                                <c:if test="${isManager}">
                                                    <button class="btn btn-primary" data-bs-toggle="modal"
                                                        data-bs-target="#createLPModal">
                                                        <i class="fa fa-plus me-2"></i>Tạo LP mới
                                                    </button>
                                                </c:if>
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
                                                                            <c:url value="/campaigns" var="campaignUrl">
                                                                                <c:param name="id"
                                                                                    value="${lp.campaignId}" />
                                                                            </c:url>
                                                                            <a href="${campaignUrl}"
                                                                                class="text-decoration-none"
                                                                                title="Xem chi tiết chiến dịch">
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
                                                                                <a href="${pageContext.request.contextPath}/landing-pages?action=preview&id=${lp.id}"
                                                                                    class="btn btn-outline-primary"
                                                                                    title="Xem trước" target="_blank">
                                                                                    <i class="fa fa-eye"></i>
                                                                                </a>

                                                                                <button type="button"
                                                                                    class="btn btn-outline-secondary"
                                                                                    onclick="copyPublicLink(${lp.id})"
                                                                                    title="Copy Public Link">
                                                                                    <i class="fa fa-link"></i>
                                                                                </button>

                                                                                <%-- Edit Button: Marketing (Always visible if NOT Manager) --%>
                                                                                <c:if test="${!isManager}">
                                                                                    <button type="button"
                                                                                        class="btn btn-outline-warning"
                                                                                        onclick="openEditModal(${lp.id})"
                                                                                        title="Chỉnh sửa">
                                                                                        <i class="fa fa-edit"></i>
                                                                                    </button>
                                                                                </c:if>

                                                                                <c:if test="${isManager}">
                                                                                    <button type="button"
                                                                                        class="btn btn-outline-danger"
                                                                                        onclick="confirmDelete(${lp.id}, '${lp.name}')"
                                                                                        title="Xóa">
                                                                                        <i class="fa fa-trash"></i>
                                                                                    </button>
                                                                                </c:if>

                                                                                <%-- Request Review: Marketing
                                                                                    (Draft/Rejected) --%>
                                                                                    <%-- Publish: Marketing (Draft) --%>
                                                                                    <c:if test="${!isManager and lp.status != 'Public'}">
                                                                                        <button type="button"
                                                                                            class="btn btn-outline-success"
                                                                                            onclick="updateLsStatus(${lp.id}, 'Public')"
                                                                                            title="Công khai (Publish) - Đưa trang lên chạy thực tế">
                                                                                            <i class="fa fa-globe"></i>
                                                                                        </button>
                                                                                    </c:if>

                                                                                    <%-- Unpublish: Marketing (Public) --%>
                                                                                    <c:if test="${!isManager and lp.status == 'Public'}">
                                                                                        <button type="button"
                                                                                            class="btn btn-outline-secondary"
                                                                                            onclick="updateLsStatus(${lp.id}, 'Draft')"
                                                                                            title="Hủy công khai (Unpublish) - Đưa trang về bản nháp">
                                                                                            <i class="fa fa-eye-slash"></i>
                                                                                        </button>
                                                                                    </c:if>

                                                                                    <%-- Manager Buttons Removed --%>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </tbody>
                                                </table>
                                            </div>
                                            
                                            <!-- Pagination Start -->
                                            <c:if test="${totalPages > 1}">
                                                <div class="row mt-3">
                                                    <div class="col-sm-12 col-md-5 d-flex align-items-center justify-content-center justify-content-md-start">
                                                        <div class="dataTables_info">
                                                            Hiển thị trang ${currentPageNum} / ${totalPages} (Tổng cộng ${totalItems} Landing Pages)
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-12 col-md-7 d-flex align-items-center justify-content-center justify-content-md-end">
                                                        <ul class="pagination mb-0">
                                                            <li class="page-item ${currentPageNum == 1 ? 'disabled' : ''}">
                                                                <a class="page-link" href="?page=${currentPageNum - 1}${not empty campaignIdFilter ? '&campaignId='.concat(campaignIdFilter) : ''}">Trước</a>
                                                            </li>
                                                            
                                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                                <li class="page-item ${currentPageNum == i ? 'active' : ''}">
                                                                    <a class="page-link" href="?page=${i}${not empty campaignIdFilter ? '&campaignId='.concat(campaignIdFilter) : ''}">${i}</a>
                                                                </li>
                                                            </c:forEach>

                                                            <li class="page-item ${currentPageNum == totalPages ? 'disabled' : ''}">
                                                                <a class="page-link" href="?page=${currentPageNum + 1}${not empty campaignIdFilter ? '&campaignId='.concat(campaignIdFilter) : ''}">Sau</a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </c:if>
                                            <!-- Pagination End -->
                                            
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

            <!-- Edit LP Modal -->
            <div class="modal fade" id="editLPModal" tabindex="-1" aria-hidden="true">
                <!-- Edit LP Modal -->
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Chỉnh sửa Landing Page</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <form id="editLPForm">
                            <input type="hidden" id="editLpId" name="id">
                            <input type="hidden" id="editLpStatus" name="status">
                            <div class="modal-body">
                                <!-- Warning / Comments -->
                                <div class="mb-3 d-none" id="managerCommentDiv">
                                    <label class="form-label text-danger fw-bold">Lý do từ chối / Góp ý:</label>
                                    <textarea class="form-control is-invalid bg-light" id="editManagerComment" rows="3"
                                        readonly></textarea>
                                </div>
                                <div id="editWarning" class="alert alert-warning d-none">
                                    <i class="fa fa-exclamation-triangle"></i> Lưu ý: Nội dung sẽ được cập nhật trực tiếp lên Landing Page đang hoạt động.
                                </div>

                                <!-- Tabs -->
                                <ul class="nav nav-tabs" id="editLPTabs" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="hero-tab" data-bs-toggle="tab"
                                            data-bs-target="#tab-hero" type="button" role="tab">Hero Section</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="about-tab" data-bs-toggle="tab"
                                            data-bs-target="#tab-about" type="button" role="tab">About Section</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="features-tab" data-bs-toggle="tab"
                                            data-bs-target="#tab-features" type="button" role="tab">Features</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="settings-tab" data-bs-toggle="tab"
                                            data-bs-target="#tab-settings" type="button" role="tab">Thông tin </button>
                                    </li>
                                </ul>

                                <div class="tab-content pt-3" id="editLPTabsContent">
                                    <!-- Hero Tab -->
                                    <div class="tab-pane fade show active" id="tab-hero" role="tabpanel">
                                        <div class="mb-3">
                                            <label class="form-label">Tiêu đề chính (Hero Title)</label>
                                            <input type="text" class="form-control" id="editHeroTitle" name="heroTitle"
                                                required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Mô tả chính (Hero Description)</label>
                                            <textarea class="form-control" id="editHeroDesc" name="heroDesc"
                                                rows="3"></textarea>
                                        </div>
                                    </div>

                                    <!-- About Tab -->
                                    <div class="tab-pane fade" id="tab-about" role="tabpanel">
                                        <div class="mb-3">
                                            <label class="form-label">Tiêu đề Giới thiệu (About Title)</label>
                                            <input type="text" class="form-control" id="editAboutTitle"
                                                name="aboutTitle">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Nội dung Giới thiệu (About Description)</label>
                                            <textarea class="form-control" id="editAboutDesc" name="aboutDesc"
                                                rows="5"></textarea>
                                        </div>
                                    </div>

                                    <!-- Features Tab -->
                                    <div class="tab-pane fade" id="tab-features" role="tabpanel">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <h6 class="text-primary">Feature 1</h6>
                                                <div class="mb-2">
                                                    <input type="text" class="form-control form-control-sm mb-1"
                                                        id="editFeatureTitle1" placeholder="Title 1">
                                                    <textarea class="form-control form-control-sm" id="editFeatureDesc1"
                                                        rows="3" placeholder="Description 1"></textarea>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <h6 class="text-primary">Feature 2</h6>
                                                <div class="mb-2">
                                                    <input type="text" class="form-control form-control-sm mb-1"
                                                        id="editFeatureTitle2" placeholder="Title 2">
                                                    <textarea class="form-control form-control-sm" id="editFeatureDesc2"
                                                        rows="3" placeholder="Description 2"></textarea>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <h6 class="text-primary">Feature 3</h6>
                                                <div class="mb-2">
                                                    <input type="text" class="form-control form-control-sm mb-1"
                                                        id="editFeatureTitle3" placeholder="Title 3">
                                                    <textarea class="form-control form-control-sm" id="editFeatureDesc3"
                                                        rows="3" placeholder="Description 3"></textarea>
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                    <!-- Settings Tab -->
                                    <div class="tab-pane fade" id="tab-settings" role="tabpanel">
                                        <div class="mb-3">
                                            <label class="form-label">Tên Landing Page (Nội bộ)</label>
                                            <input type="text" class="form-control" id="editLpName" name="name" required
                                                ${isManager ? '' : 'readonly' }>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Mô tả</label>
                                            <textarea class="form-control" id="editLpBrief" name="brief" rows="2"
                                                ${isManager ? '' : 'readonly' }></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                <button type="button" class="btn btn-primary" onclick="submitEditForm()">Lưu thay
                                    đổi</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <%@ include file="/includes/scripts.jsp" %>

                <script>
                    const contextPath = '${pageContext.request.contextPath}';

                    // Copy Public Link
                    function copyPublicLink(id) {
                        // Construct the public URL: http://host:port/CRM/lp/{id}
                        // We use window.location.origin to get scheme + host + port
                        // contextPath usually starts with / (e.g. /CRM)
                        const publicUrl = window.location.origin + contextPath + '/lp/' + id;

                        navigator.clipboard.writeText(publicUrl).then(function () {
                            alert('Đã copy link public: ' + publicUrl);
                        }, function (err) {
                            console.error('Could not copy text: ', err);
                            // Fallback for older browsers or if permission denied?
                            prompt("Copy link bên dưới:", publicUrl);
                        });
                    }

                    // Edit LP Functions
                    function openEditModal(id) {
                        fetch(contextPath + '/landing-pages?action=detail&id=' + id)
                            .then(res => res.json())
                            .then(result => {
                                if (result.success) {
                                    const data = result.data;
                                    document.getElementById('editLpId').value = data.id;
                                    document.getElementById('editLpName').value = data.name;
                                    document.getElementById('editLpBrief').value = data.brief || '';
                                    document.getElementById('editLpStatus').value = data.status;

                                    // Populate Content Fields
                                    document.getElementById('editHeroTitle').value = data.heroTitle || '';
                                    document.getElementById('editHeroDesc').value = data.heroDesc || '';

                                    document.getElementById('editAboutTitle').value = data.aboutTitle || '';
                                    document.getElementById('editAboutDesc').value = data.aboutDesc || '';

                                    document.getElementById('editFeatureTitle1').value = data.featureTitle1 || '';
                                    document.getElementById('editFeatureDesc1').value = data.featureDesc1 || '';
                                    document.getElementById('editFeatureTitle2').value = data.featureTitle2 || '';
                                    document.getElementById('editFeatureDesc2').value = data.featureDesc2 || '';
                                    document.getElementById('editFeatureTitle3').value = data.featureTitle3 || '';
                                    document.getElementById('editFeatureDesc3').value = data.featureDesc3 || '';

                                    // Show/Hide Warning based on status
                                    const warningDiv = document.getElementById('editWarning');
                                    if (data.status === 'Public') {
                                        warningDiv.classList.remove('d-none');
                                    } else {
                                        warningDiv.classList.add('d-none');
                                    }

                                    // Show/Hide Comment
                                    const commentDiv = document.getElementById('managerCommentDiv');
                                    if (data.managerComment && data.managerComment.trim() !== '') {
                                        document.getElementById('editManagerComment').value = data.managerComment;
                                        commentDiv.classList.remove('d-none');
                                    } else {
                                        commentDiv.classList.add('d-none');
                                    }

                                    const modal = new bootstrap.Modal(document.getElementById('editLPModal'));
                                    modal.show();
                                } else {
                                    alert(result.message || 'Không thể lấy dữ liệu');
                                }
                            })
                            .catch(err => {
                                console.error('Error:', err);
                                alert('Lỗi kết nối');
                            });
                    }

                    // Update Status Function
                    function updateLsStatus(id, newStatus) {
                        let actionName = "";
                        if (newStatus === 'Public') actionName = "Công khai Landing Page";
                        else if (newStatus === 'Draft') actionName = "Hủy công khai Landing Page";

                        showConfirmDialog(
                            'Bạn có chắc chắn muốn <strong>' + actionName + '</strong>?',
                            function () {
                                const params = new URLSearchParams();
                                params.append('id', id);
                                params.append('status', newStatus);

                                fetch(contextPath + '/landing-pages?action=change-status', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                    },
                                    body: params
                                })
                                    .then(res => res.json())
                                    .then(result => {
                                        if (result.success) {
                                            alert(result.message);
                                            window.location.reload();
                                        } else {
                                            alert(result.message || 'Có lỗi xảy ra');
                                        }
                                    })
                                    .catch(err => {
                                        console.error('Error:', err);
                                        alert('Lỗi kết nối');
                                    });
                            },
                            { title: actionName, confirmText: 'Đồng ý', confirmClass: newStatus === 'Rejected' ? 'btn-danger' : 'btn-success' }
                        );
                    }

                    function submitEditForm() {
                        const id = document.getElementById('editLpId').value;
                        const name = document.getElementById('editLpName').value;
                        const brief = document.getElementById('editLpBrief').value;
                        const status = document.getElementById('editLpStatus').value;

                        // Extra confirmation for Approved status
                        /* - REMOVED FOR SIMPLIFIED FLOW
                        if (status === 'Approved') {
                            showConfirmDialog(
                                '<strong>LƯU Ý:</strong> Landing Page đang Approved. Việc lưu sẽ chuyển trạng thái về <strong>DRAFT</strong> (gỡ public). Tiếp tục?',
                                function () { doSubmitEditForm(); },
                                { title: 'Cảnh báo', confirmText: 'Tiếp tục lưu', confirmClass: 'btn-warning' }
                            );
                            return;
                        }
                        */

                        doSubmitEditForm();
                    }

                    function doSubmitEditForm() {
                        const id = document.getElementById('editLpId').value;
                        const name = document.getElementById('editLpName').value;
                        const brief = document.getElementById('editLpBrief').value;

                        const params = new URLSearchParams();
                        params.append('action', 'update');
                        params.append('id', id);
                        params.append('name', name);
                        params.append('brief', brief);

                        // Append Content fields
                        params.append('heroTitle', document.getElementById('editHeroTitle').value);
                        params.append('heroDesc', document.getElementById('editHeroDesc').value);

                        params.append('aboutTitle', document.getElementById('editAboutTitle').value);
                        params.append('aboutDesc', document.getElementById('editAboutDesc').value);

                        params.append('featureTitle1', document.getElementById('editFeatureTitle1').value);
                        params.append('featureDesc1', document.getElementById('editFeatureDesc1').value);
                        params.append('featureTitle2', document.getElementById('editFeatureTitle2').value);
                        params.append('featureDesc2', document.getElementById('editFeatureDesc2').value);
                        params.append('featureTitle3', document.getElementById('editFeatureTitle3').value);
                        params.append('featureDesc3', document.getElementById('editFeatureDesc3').value);

                        fetch(contextPath + '/landing-pages', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                            body: params
                        })
                            .then(res => res.json())
                            .then(result => {
                                if (result.success) {
                                    alert('Cập nhật thành công!');
                                    window.location.reload();
                                } else {
                                    alert(result.message || 'Lỗi cập nhật');
                                }
                            })
                            .catch(err => {
                                console.error('Error:', err);
                                alert('Lỗi kết nối');
                            });
                    }

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
                        showConfirmDialog(
                            'Bạn có chắc muốn xóa Landing Page "<strong>' + name + '</strong>"?',
                            function () {
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
                            },
                            { title: 'Xóa Landing Page', confirmText: 'Xóa', confirmClass: 'btn-danger' }
                        );
                    }

                    // Hide spinner
                    document.addEventListener('DOMContentLoaded', function () {
                        const spinner = document.getElementById('spinner');
                        if (spinner) spinner.classList.remove('show');
                    });
                </script>

        </body>

        </html>