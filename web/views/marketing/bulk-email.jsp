<%-- bulk-email.jsp - Email Marketing (Gửi Email Hàng Loạt) --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <% request.setAttribute("currentPage", "bulk-email" ); %>

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <title>Email Marketing - CRM System</title>
                        <%@ include file="/includes/head.jsp" %>
                            <style>
                                /* ===== Stat Cards ===== */
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

                                .stat-card-leads {
                                    background: linear-gradient(135deg, #6366f1, #818cf8);
                                }

                                .stat-card-selected {
                                    background: linear-gradient(135deg, #10b981, #34d399);
                                }

                                .stat-card-sent {
                                    background: linear-gradient(135deg, #f59e0b, #fbbf24);
                                }

                                /* ===== Filter Section ===== */
                                .filter-section {
                                    background-color: #f8f9fa;
                                    padding: 1.5rem;
                                    border-radius: 0.5rem;
                                    margin-bottom: 1.5rem;
                                }

                                /* ===== Email Compose ===== */
                                .compose-section {
                                    background: #fff;
                                    border: 1px solid #dee2e6;
                                    border-radius: 0.75rem;
                                    padding: 1.5rem;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
                                }

                                .compose-section .form-label {
                                    font-weight: 600;
                                    color: #495057;
                                }

                                /* ===== Lead Table ===== */
                                .lead-table-container {
                                    max-height: 400px;
                                    overflow-y: auto;
                                }

                                .lead-table-container::-webkit-scrollbar {
                                    width: 6px;
                                }

                                .lead-table-container::-webkit-scrollbar-thumb {
                                    background: #c0c0c0;
                                    border-radius: 3px;
                                }

                                .customer-info .customer-name {
                                    font-weight: 600;
                                }

                                .customer-info .customer-detail {
                                    font-size: 0.8rem;
                                    color: #6c757d;
                                }

                                /* ===== Template Variables ===== */
                                .template-hint {
                                    background: #e8f4fd;
                                    border-left: 4px solid #2196F3;
                                    padding: 0.75rem 1rem;
                                    border-radius: 0 0.5rem 0.5rem 0;
                                    font-size: 0.85rem;
                                    color: #1565c0;
                                }

                                .template-hint code {
                                    background: #bbdefb;
                                    padding: 0.15rem 0.4rem;
                                    border-radius: 3px;
                                    font-size: 0.8rem;
                                }

                                /* ===== Status badge ===== */
                                .status-new {
                                    background-color: #17a2b8;
                                }

                                .status-nurturing {
                                    background-color: #ffc107;
                                    color: #212529;
                                }

                                .status-qualified {
                                    background-color: #28a745;
                                }

                                .status-assigned {
                                    background-color: #6f42c1;
                                }

                                /* ===== Sending overlay ===== */
                                .sending-overlay {
                                    display: none;
                                    position: fixed;
                                    top: 0;
                                    left: 0;
                                    width: 100%;
                                    height: 100%;
                                    background: rgba(0, 0, 0, 0.5);
                                    z-index: 9999;
                                    justify-content: center;
                                    align-items: center;
                                }

                                .sending-overlay.active {
                                    display: flex;
                                }

                                .sending-card {
                                    background: #fff;
                                    border-radius: 1rem;
                                    padding: 2rem 3rem;
                                    text-align: center;
                                    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
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

                                                <!-- Bulk Email Content -->
                                                <div class="container-fluid pt-4 px-4">

                                                    <!-- Page Header -->
                                                    <div class="row mb-4">
                                                        <div class="col-12">
                                                            <div
                                                                class="d-flex justify-content-between align-items-center">
                                                                <h3 class="mb-0"><i
                                                                        class="fa fa-envelope me-2"></i>Email Marketing
                                                                </h3>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Stat Cards -->
                                                    <div class="row mb-4 g-3">
                                                        <div class="col-md-4">
                                                            <div class="stat-card stat-card-leads">
                                                                <div class="stat-label"><i
                                                                        class="fa fa-users me-1"></i>Tổng Lead có
                                                                    Email</div>
                                                                <div class="stat-number" id="statLeads">
                                                                    ${leads.size()}</div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="stat-card stat-card-selected">
                                                                <div class="stat-label"><i
                                                                        class="fa fa-check-square me-1"></i>Đã
                                                                    chọn</div>
                                                                <div class="stat-number" id="statSelected">0
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="stat-card stat-card-sent">
                                                                <div class="stat-label"><i
                                                                        class="fa fa-paper-plane me-1"></i>Đã gửi
                                                                    (phiên này)</div>
                                                                <div class="stat-number" id="statSent">0</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="row g-4">
                                                        <!-- Left Column: Lead Selection -->
                                                        <div class="col-lg-5">
                                                            <!-- Campaign Filter -->
                                                            <div class="filter-section mb-3">
                                                                <label class="form-label fw-bold">Lọc theo
                                                                    Chiến dịch</label>
                                                                <select class="form-select" id="campaignFilter"
                                                                    onchange="filterByCampaign()">
                                                                    <option value="">Tất cả chiến dịch</option>
                                                                    <c:forEach var="campaign" items="${campaigns}">
                                                                        <option value="${campaign.id}"
                                                                            ${selectedCampaignId==campaign.id
                                                                            ? 'selected' : '' }>
                                                                            ${campaign.name}
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>

                                                            <!-- Lead Table -->
                                                            <div class="bg-light rounded p-3">
                                                                <div
                                                                    class="d-flex justify-content-between align-items-center mb-3">
                                                                    <h6 class="mb-0"><i class="fa fa-list me-1"></i>Danh
                                                                        sách Lead</h6>
                                                                    <div class="form-check">
                                                                        <input class="form-check-input" type="checkbox"
                                                                            id="selectAll" onchange="toggleSelectAll()">
                                                                        <label class="form-check-label"
                                                                            for="selectAll">Chọn
                                                                            tất cả</label>
                                                                    </div>
                                                                </div>
                                                                <div class="lead-table-container">
                                                                    <table
                                                                        class="table table-hover table-sm align-middle"
                                                                        id="leadTable">
                                                                        <thead class="table-light">
                                                                            <tr>
                                                                                <th style="width:40px"></th>
                                                                                <th>Lead</th>
                                                                                <th>Trạng thái</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody id="leadTableBody">
                                                                            <c:choose>
                                                                                <c:when test="${empty leads}">
                                                                                    <tr>
                                                                                        <td colspan="3"
                                                                                            class="text-center text-muted py-4">
                                                                                            <i
                                                                                                class="fa fa-inbox fa-2x mb-2 d-block"></i>
                                                                                            Chưa có Lead nào có email
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <c:forEach var="lead"
                                                                                        items="${leads}">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <input
                                                                                                    class="form-check-input lead-checkbox"
                                                                                                    type="checkbox"
                                                                                                    value="${lead.id}"
                                                                                                    onchange="updateSelectedCount()">
                                                                                            </td>
                                                                                            <td>
                                                                                                <div
                                                                                                    class="customer-info">
                                                                                                    <div
                                                                                                        class="customer-name">
                                                                                                        ${lead.fullName}
                                                                                                    </div>
                                                                                                    <div
                                                                                                        class="customer-detail">
                                                                                                        <i
                                                                                                            class="fa fa-envelope me-1"></i>${lead.email}
                                                                                                    </div>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <span
                                                                                                    class="badge status-${lead.status != null ? lead.status.toLowerCase() : 'new'}">
                                                                                                    ${lead.status !=
                                                                                                    null ? lead.status :
                                                                                                    'New'}
                                                                                                </span>
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

                                                        <!-- Right Column: Email Compose -->
                                                        <div class="col-lg-7">
                                                            <div class="compose-section">
                                                                <h5 class="mb-3"><i
                                                                        class="fa fa-pen-fancy me-2"></i>Soạn Email</h5>

                                                                <div class="template-hint mb-3">
                                                                    <i class="fa fa-lightbulb me-1"></i>
                                                                    <strong>Mẹo:</strong> Dùng <code>{{name}}</code>,
                                                                    <code>{{email}}</code>, và <code>{{id}}</code> để
                                                                    chèn thông tin Lead vào nội dung.
                                                                </div>

                                                                <!-- Quick Templates -->
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold">🧙 Mẫu gợi ý
                                                                        (Click để áp dụng):</label>
                                                                    <div class="d-flex flex-wrap gap-2">
                                                                        <button type="button"
                                                                            class="btn btn-sm btn-outline-primary"
                                                                            onclick="loadTemplate('interest')">
                                                                            <i class="fa fa-star me-1"></i>Quan tâm sản
                                                                            phẩm
                                                                        </button>
                                                                        <button type="button"
                                                                            class="btn btn-sm btn-outline-secondary"
                                                                            onclick="loadTemplate('intro')">
                                                                            <i class="fa fa-info-circle me-1"></i>Giới
                                                                            thiệu dịch vụ
                                                                        </button>
                                                                        <button type="button"
                                                                            class="btn btn-sm btn-dark"
                                                                            onclick="insertTrackingLink()">
                                                                            <i class="fa fa-link me-1"></i>Chèn Link
                                                                            "Tôi Quan Tâm"
                                                                        </button>
                                                                    </div>
                                                                </div>

                                                                <div class="mb-3">
                                                                    <label class="form-label">Tiêu
                                                                        đề Email <span
                                                                            class="text-danger">*</span></label>
                                                                    <input type="text" class="form-control"
                                                                        id="emailSubject"
                                                                        placeholder="Ví dụ: Chương trình ưu đãi đặc biệt tháng 3">
                                                                </div>

                                                                <div class="mb-3">
                                                                    <label class="form-label">Nội dung Email (HTML)
                                                                        <span class="text-danger">*</span></label>
                                                                    <textarea class="form-control" id="emailContent"
                                                                        rows="12"
                                                                        placeholder="Nhập nội dung email HTML...&#10;&#10;Ví dụ:&#10;<h2>Xin chào {{name}},</h2>&#10;<p>Chúng tôi có chương trình ưu đãi dành riêng cho bạn...</p>"></textarea>
                                                                </div>

                                                                <!-- Preview Button -->
                                                                <div class="mb-3">
                                                                    <button class="btn btn-outline-info btn-sm"
                                                                        onclick="previewEmail()">
                                                                        <i class="fa fa-eye me-1"></i>Xem trước
                                                                    </button>
                                                                </div>

                                                                <!-- Send Button -->
                                                                <div class="d-flex justify-content-end gap-2">
                                                                    <button class="btn btn-secondary"
                                                                        onclick="clearForm()">
                                                                        <i class="fa fa-redo me-1"></i>Xóa nội dung
                                                                    </button>
                                                                    <button class="btn btn-primary btn-lg"
                                                                        onclick="sendBulkEmail()" id="btnSend">
                                                                        <i class="fa fa-paper-plane me-1"></i>Gửi Email
                                                                        (<span id="sendCount">0</span> người nhận)
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Preview Modal -->
                                                <div class="modal fade" id="previewModal" tabindex="-1"
                                                    aria-hidden="true">
                                                    <div class="modal-dialog modal-lg modal-dialog-centered">
                                                        <div class="modal-content">
                                                            <div class="modal-header bg-info text-white">
                                                                <h5 class="modal-title"><i
                                                                        class="fa fa-eye me-2"></i>Xem trước Email
                                                                </h5>
                                                                <button type="button" class="btn-close btn-close-white"
                                                                    data-bs-dismiss="modal" aria-label="Close"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <div class="mb-2">
                                                                    <strong>Tiêu đề:</strong> <span
                                                                        id="previewSubject"></span>
                                                                </div>
                                                                <hr>
                                                                <div id="previewBody"
                                                                    style="border:1px solid #dee2e6; padding:1rem; border-radius:0.5rem; min-height:200px;">
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary"
                                                                    data-bs-dismiss="modal">Đóng</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Sending Overlay -->
                                                <div class="sending-overlay" id="sendingOverlay">
                                                    <div class="sending-card">
                                                        <div class="spinner-border text-primary mb-3" role="status"
                                                            style="width:3rem;height:3rem;">
                                                            <span class="visually-hidden">Đang gửi...</span>
                                                        </div>
                                                        <h5>Đang gửi email...</h5>
                                                        <p class="text-muted mb-0">Vui lòng chờ, không đóng trang
                                                            này.</p>
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

                                    // ==================== Campaign Filter ====================
                                    function filterByCampaign() {
                                        var campaignId = document.getElementById('campaignFilter').value;
                                        var url = contextPath + '/marketing/bulk-email';
                                        if (campaignId) {
                                            url += '?campaignId=' + campaignId;
                                        }
                                        window.location.href = url;
                                    }

                                    // ==================== Select All ====================
                                    function toggleSelectAll() {
                                        var selectAll = document.getElementById('selectAll').checked;
                                        var checkboxes = document.querySelectorAll('.lead-checkbox');
                                        checkboxes.forEach(function (cb) {
                                            cb.checked = selectAll;
                                        });
                                        updateSelectedCount();
                                    }

                                    // ==================== Update Selected Count ====================
                                    function updateSelectedCount() {
                                        var checked = document.querySelectorAll('.lead-checkbox:checked').length;
                                        document.getElementById('statSelected').textContent = checked;
                                        document.getElementById('sendCount').textContent = checked;
                                    }

                                    // ==================== Preview Email ====================
                                    function previewEmail() {
                                        var subject = document.getElementById('emailSubject').value;
                                        var content = document.getElementById('emailContent').value;

                                        if (!subject.trim() && !content.trim()) {
                                            showToast('error', 'Vui lòng nhập tiêu đề và nội dung email');
                                            return;
                                        }

                                        // Replace template variables with sample data
                                        var previewContent = content
                                            .replace(/\{\{name\}\}/g, 'Nguyễn Văn A')
                                            .replace(/\{\{email\}\}/g, 'nguyenvana@example.com');

                                        document.getElementById('previewSubject').textContent = subject;
                                        document.getElementById('previewBody').innerHTML = previewContent;

                                        var modal = new bootstrap.Modal(document.getElementById('previewModal'));
                                        modal.show();
                                    }

                                    // ==================== Clear Form ====================
                                    function clearForm() {
                                        document.getElementById('emailSubject').value = '';
                                        document.getElementById('emailContent').value = '';
                                    }

                                    // ==================== Send Bulk Email ====================
                                    function sendBulkEmail() {
                                        var subject = document.getElementById('emailSubject').value.trim();
                                        var content = document.getElementById('emailContent').value.trim();
                                        var checkedBoxes = document.querySelectorAll('.lead-checkbox:checked');

                                        // Validate
                                        if (!subject) {
                                            showToast('error', 'Vui lòng nhập tiêu đề email');
                                            return;
                                        }
                                        if (!content) {
                                            showToast('error', 'Vui lòng nhập nội dung email');
                                            return;
                                        }
                                        if (checkedBoxes.length === 0) {
                                            showToast('error', 'Vui lòng chọn ít nhất một lead');
                                            return;
                                        }

                                        showConfirmDialog(
                                            'Bạn có chắc chắn muốn gửi email đến <strong>' + checkedBoxes.length + '</strong> người nhận?',
                                            function () {
                                                // Build form data
                                                var formData = new URLSearchParams();
                                                formData.append('action', 'send');
                                                formData.append('subject', subject);
                                                formData.append('content', content);
                                                checkedBoxes.forEach(function (cb) {
                                                    formData.append('leadIds[]', cb.value);
                                                });

                                                // Show overlay
                                                document.getElementById('sendingOverlay').classList.add('active');
                                                document.getElementById('btnSend').disabled = true;

                                                fetch(contextPath + '/marketing/bulk-email', {
                                                    method: 'POST',
                                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                                    body: formData.toString()
                                                })
                                                    .then(function (res) { return res.json(); })
                                                    .then(function (data) {
                                                        document.getElementById('sendingOverlay').classList.remove('active');
                                                        document.getElementById('btnSend').disabled = false;

                                                        if (data.success) {
                                                            showToast('success', data.message);
                                                            var currentSent = parseInt(document.getElementById('statSent').textContent) || 0;
                                                            if (data.data && data.data.successCount) {
                                                                document.getElementById('statSent').textContent = currentSent + data.data.successCount;
                                                            }
                                                        } else {
                                                            showToast('error', data.message);
                                                        }
                                                    })
                                                    .catch(function (err) {
                                                        document.getElementById('sendingOverlay').classList.remove('active');
                                                        document.getElementById('btnSend').disabled = false;
                                                        showToast('error', 'Lỗi kết nối server');
                                                        console.error(err);
                                                    });
                                            },
                                            { title: 'Gửi email hàng loạt', confirmText: 'Gửi', confirmClass: 'btn-primary' }
                                        );
                                    }

                                    // ==================== Template Support ====================
                                    function getCampaignId() {
                                        const campaignFilter = document.getElementById('campaignFilter');
                                        return campaignFilter ? campaignFilter.value : '';
                                    }

                                    function loadTemplate(type) {
                                        const subjectEl = document.getElementById('emailSubject');
                                        const contentEl = document.getElementById('emailContent');
                                        const cId = getCampaignId();
                                        const campaignParam = cId ? '&campaignId=' + cId : '';

                                        if (type === 'interest') {
                                            subjectEl.value = 'Bạn có quan tâm đến giải pháp của chúng tôi không?';
                                            contentEl.value = '<h2>Chào {{name}},</h2>\n' +
                                                '<p>Chúng tôi nhận thấy bạn đã tìm hiểu về sản phẩm trước đây. Không biết bạn còn quan tâm không?</p>\n' +
                                                '<p>Nếu có, hãy nhấn vào link dưới đây để chúng tôi sắp xếp tư vấn viên hỗ trợ ngay:</p>\n' +
                                                '<p><a href=\"' + window.location.origin + window.location.pathname.split('/').slice(0, -2).join('/') + '/marketing/track-click?leadId={{id}}' + campaignParam + '\" style=\"background:#4f46e5;color:white;padding:12px 24px;text-decoration:none;border-radius:8px;display:inline-block;\">Tôi rất quan tâm!</a></p>\n' +
                                                '<p>Trân trọng,<br>Đội ngũ CRM</p>';
                                        } else if (type === 'intro') {
                                            subjectEl.value = 'Giới thiệu dịch vụ nâng cao dành cho doanh nghiệp';
                                            contentEl.value = '<h2>Xin chào {{name}},</h2>\n' +
                                                '<p>Đây là các dịch vụ mới nhất mà chúng tôi vừa cập nhật.</p>\n' +
                                                '<p>Bạn có thể nhấn vào liên kết sau để nhận tài liệu chi tiết:</p>\n' +
                                                '<p><a href=\"' + window.location.origin + window.location.pathname.split('/').slice(0, -2).join('/') + '/marketing/track-click?leadId={{id}}' + campaignParam + '\">Xem tài liệu chi tiết tại đây &raquo;</a></p>\n' +
                                                '<p>Email này được gửi đến: {{email}}</p>';
                                        }
                                        showToast('success', 'Đã áp dụng mẫu email');
                                    }

                                    function insertTrackingLink() {
                                        const contentEl = document.getElementById('emailContent');
                                        const cId = getCampaignId();
                                        const campaignParam = cId ? '&campaignId=' + cId : '';
                                        const trackingUrl = window.location.origin + window.location.pathname.split('/').slice(0, -2).join('/') + '/marketing/track-click?leadId={{id}}' + campaignParam;
                                        const linkHtml = '<a href=\"' + trackingUrl + '\">Bấm vào đây nếu bạn quan tâm</a>';

                                        const startPos = contentEl.selectionStart;
                                        const endPos = contentEl.selectionEnd;
                                        contentEl.value = contentEl.value.substring(0, startPos) + linkHtml + contentEl.value.substring(endPos);
                                        showToast('success', 'Đã chèn link tracking vào cursor (kèm Campaign ID)');
                                    }

                                    // ==================== Toast Notification ====================
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
                                        }, 4000);
                                    }
                                </script>
                    </body>

                    </html>