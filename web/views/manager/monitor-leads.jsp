<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <title>Monitor Leads - CRM</title>
                <meta content="width=device-width, initial-scale=1.0" name="viewport">
                <%@ include file="/includes/head.jsp" %>
                    <style>
                        .timeline-item {
                            position: relative;
                            padding-left: 20px;
                            margin-bottom: 20px;
                        }

                        .timeline-item::before {
                            content: '';
                            position: absolute;
                            left: 0;
                            top: 5px;
                            bottom: -25px;
                            width: 2px;
                            background-color: #e9ecef;
                        }

                        .timeline-item:last-child::before {
                            display: none;
                        }

                        .timeline-icon {
                            position: absolute;
                            left: -8px;
                            top: 3px;
                            width: 18px;
                            height: 18px;
                            border-radius: 50%;
                            background-color: #009CFF;
                            border: 3px solid #fff;
                        }

                        .score-badge {
                            font-size: 0.9em;
                            padding: 5px 10px;
                        }
                    </style>
            </head>

            <body>
                <div class="container-xxl position-relative bg-white d-flex p-0">
                    <%@ include file="/includes/sidebar.jsp" %>

                        <!-- Content Start -->
                        <div class="content">
                            <%@ include file="/includes/topbar.jsp" %>

                                <!-- Monitor Leads Area -->
                                <div class="container-fluid pt-4 px-4">

                                    <div class="d-flex align-items-center justify-content-between mb-4">
                                        <h4 class="mb-0 text-primary"><i class="fa fa-chart-pie me-2"></i>Giao Lead mới
                                            cho Sale
                                        </h4>
                                        <form method="get"
                                            action="${pageContext.request.contextPath}/marketing/monitor-leads"
                                            class="d-flex gap-2" id="filterForm">

                                            <!-- Date Filter -->
                                            <select name="dateFilter" class="form-select border-primary"
                                                style="width: 150px;">
                                                <option value="all" ${dateFilter=='all' || empty dateFilter ? 'selected'
                                                    : '' }>Mọi lúc</option>
                                                <option value="today" ${dateFilter=='today' ? 'selected' : '' }>Hôm nay
                                                </option>
                                                <option value="this_week" ${dateFilter=='this_week' ? 'selected' : '' }>
                                                    Tuần này</option>
                                                <option value="this_month" ${dateFilter=='this_month' ? 'selected' : ''
                                                    }>Tháng này</option>
                                            </select>

                                            <!-- Campaign Filter -->
                                            <select name="campaignId" class="form-select border-primary"
                                                style="width: 200px;">
                                                <option value="">Tất cả Chiến dịch</option>
                                                <c:forEach var="camp" items="${campaigns}">
                                                    <option value="${camp.id}" ${selectedCampaignId==camp.id
                                                        ? 'selected' : '' }>
                                                        ${camp.name}
                                                    </option>
                                                </c:forEach>
                                            </select>

                                            <!-- Search Box -->
                                            <div class="input-group" style="width: 250px;">
                                                <input type="text" name="searchQuery"
                                                    class="form-control border-primary" placeholder="Tên, SDT, Email..."
                                                    value="${searchQuery}">
                                                <button type="submit" class="btn btn-outline-primary"><i
                                                        class="fa fa-search"></i></button>
                                            </div>
                                        </form>
                                    </div>

                                    <%-- Display success/error messages --%>
                                        <c:if test="${not empty sessionScope.successMsg}">
                                            <div class="alert alert-success alert-dismissible fade show text-start"
                                                role="alert">
                                                ${sessionScope.successMsg}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                            <c:remove var="successMsg" scope="session" />
                                        </c:if>
                                        <c:if test="${not empty sessionScope.errorMsg}">
                                            <div class="alert alert-danger alert-dismissible fade show text-start"
                                                role="alert">
                                                ${sessionScope.errorMsg}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                            <c:remove var="errorMsg" scope="session" />
                                        </c:if>

                                        <!-- 1. KPI Cards -->
                                        <div class="row g-4 mb-4">
                                            <div class="col-sm-6 col-xl-4">
                                                <div
                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-danger border-4">
                                                    <i class="fa fa-fire fa-3x text-danger"></i>
                                                    <div class="ms-3 text-end">
                                                        <p class="mb-2 text-muted fw-bold">Hot Leads 🔥</p>
                                                        <h4 class="mb-0">${kpis.hotLeads}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-sm-6 col-xl-4">
                                                <div
                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-warning border-4">
                                                    <i class="fa fa-user-plus fa-3x text-warning"></i>
                                                    <div class="ms-3 text-end">
                                                        <p class="mb-2 text-muted fw-bold">Unassigned</p>
                                                        <h4 class="mb-0">${kpis.unassignedLeads}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-sm-6 col-xl-4">
                                                <div
                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-success border-4">
                                                    <i class="fa fa-chart-line fa-3x text-success"></i>
                                                    <div class="ms-3 text-end">
                                                        <p class="mb-2 text-muted fw-bold">Conversion Rate</p>
                                                        <h4 class="mb-0">
                                                            <fmt:formatNumber type="percent" maxFractionDigits="1"
                                                                value="${kpis.hotLeads > 0 ? kpis.hotLeads / kpis.hotLeads : 1}" />
                                                        </h4>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row g-4 mb-4">
                                            <!-- 2. Bảng phân công Hot Leads -->
                                            <div class="col-sm-12 col-xl-12">
                                                <div class="bg-white text-center rounded p-4 h-100 shadow-sm">
                                                    <div class="d-flex align-items-center justify-content-between mb-4">
                                                        <h6 class="mb-0 fw-bold text-dark"><i
                                                                class="fa fa-fire text-danger me-2"></i>Lead mới cần
                                                            được giao</h6>
                                                        <span class="text-muted"><small>Ưu tiên xử lý từ trên xuống
                                                                dưới</small></span>
                                                    </div>

                                                    <!-- Mass Action Panel (Hidden by default) -->
                                                    <div id="massActionPanel"
                                                        class="bg-light p-3 rounded mb-3 border border-primary text-start"
                                                        style="display: none;">
                                                        <div class="d-flex align-items-center justify-content-between">
                                                            <div>
                                                                <span class="fw-bold text-primary">Đã chọn: <span
                                                                        id="selectedCount">0</span> leads</span>
                                                            </div>
                                                            <div class="d-flex align-items-center">
                                                                <label class="me-2 fw-bold mb-0">Phân công cho:</label>
                                                                <select name="massSalesId" form="massAssignForm"
                                                                    class="form-select form-select-sm w-auto me-2"
                                                                    required>
                                                                    <option value="">-- Chọn Sales --</option>
                                                                    <c:forEach var="sale" items="${salesUsers}">
                                                                        <option value="${sale.id}">${sale.fullName}
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                                <button type="submit" form="massAssignForm"
                                                                    class="btn btn-sm btn-primary">
                                                                    <i class="fa fa-users me-1"></i> Phân công hàng loạt
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="table-responsive">
                                                        <table class="table text-start align-middle table-hover mb-0">
                                                            <thead class="table-light">
                                                                <tr class="text-dark text-nowrap">
                                                                    <th scope="col" style="width: 30px;">
                                                                        <div class="form-check">
                                                                            <input class="form-check-input"
                                                                                type="checkbox" id="selectAll"
                                                                                onchange="toggleSelectAll()">
                                                                        </div>
                                                                    </th>
                                                                    <th scope="col" style="min-width: 180px;">Lead
                                                                    </th>
                                                                    <th scope="col">Chiến dịch</th>
                                                                    <th scope="col" class="text-center">Tiềm năng</th>
                                                                    <th scope="col">Phone</th>
                                                                    <th scope="col" style="min-width: 130px;">Phân công
                                                                    </th>
                                                                    <th scope="col" class="text-center"><i
                                                                            class="fa fa-cog"></i></th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:choose>
                                                                    <c:when test="${empty hotLeads}">
                                                                        <tr>
                                                                            <td colspan="7" class="text-center py-4">Tất
                                                                                cả Hot Leads đã được phân công! Hoặc
                                                                                không có dữ liệu.</td>
                                                                        </tr>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/marketing/monitor-leads"
                                                                            method="post" id="massAssignForm">
                                                                            <input type="hidden" name="action"
                                                                                value="massAssign">
                                                                            <input type="hidden" name="listCampaignId"
                                                                                value="${selectedCampaignId}">
                                                                            <input type="hidden" name="searchQuery"
                                                                                value="${searchQuery}">
                                                                            <input type="hidden" name="dateFilter"
                                                                                value="${dateFilter}">

                                                                            <c:forEach var="lead" items="${hotLeads}">
                                                                                <tr class="align-middle">
                                                                                    <td>
                                                                                        <div class="form-check">
                                                                                            <input
                                                                                                class="form-check-input lead-checkbox"
                                                                                                type="checkbox"
                                                                                                name="selectedLeadIds"
                                                                                                value="${lead.id}"
                                                                                                onchange="updateAssignButton()">
                                                                                        </div>
                                                                                    </td>
                                                                                    <td>
                                                                                        <strong>${lead.fullName}</strong><br>
                                                                                        <small
                                                                                            class="text-muted">${lead.email}</small>
                                                                                    </td>
                                                                                    <td>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${not empty lead.campaign}">
                                                                                                <span
                                                                                                    class="badge bg-info text-dark">${lead.campaign.name}</span>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span
                                                                                                    class="text-muted fst-italic">Không
                                                                                                    có</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td class="text-center">
                                                                                        <span
                                                                                            class="badge bg-danger rounded-pill px-3 py-2 shadow-sm">
                                                                                            <i
                                                                                                class="fa fa-fire me-1"></i>
                                                                                            HOT 🔥
                                                                                        </span>
                                                                                    </td>
                                                                                    <td class="text-nowrap">${lead.phone
                                                                                        != null && !lead.phone.isEmpty()
                                                                                        ? lead.phone : '-'}</td>
                                                                                    <td class="pe-3">
                                                                                        <!-- Single assign now handled via JS or separate form if needed, but keeping simple UI for now -->
                                                                                        <select
                                                                                            name="singleSalesId_${lead.id}"
                                                                                            class="form-select form-select-sm"
                                                                                            onchange="quickAssign(${lead.id}, this.value)">
                                                                                            <option value="">-- Chọn --
                                                                                            </option>
                                                                                            <c:forEach var="sale"
                                                                                                items="${salesUsers}">
                                                                                                <option
                                                                                                    value="${sale.id}">
                                                                                                    ${sale.fullName}
                                                                                                </option>
                                                                                            </c:forEach>
                                                                                        </select>
                                                                                    </td>
                                                                                    <td class="text-center pe-2">
                                                                                        <button type="button"
                                                                                            class="btn btn-sm btn-outline-danger p-1 px-2 ms-1"
                                                                                            onclick="handleDeleteLead(${lead.id})"
                                                                                            title="Xóa Lead">
                                                                                            <i class="fa fa-trash"></i>
                                                                                        </button>
                                                                                    </td>
                                                                                </tr>
                                                                            </c:forEach>
                                                                        </form>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                </div>
                                <!-- Monitor Leads End -->
                                <%@ include file="/includes/confirm-modal.jsp" %>
                                    <%@ include file="/includes/footer.jsp" %>

                        </div>
                        <!-- Content End -->

                        <!-- Back to Top -->
                        <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                class="bi bi-arrow-up"></i></a>
                </div>

                <!-- Scripts -->
                <%@ include file="/includes/scripts.jsp" %>
                    <script>
                        function toggleSelectAll() {
                            const selectAllCheckbox = document.getElementById('selectAll');
                            const leadCheckboxes = document.querySelectorAll('.lead-checkbox');
                            leadCheckboxes.forEach(cb => cb.checked = selectAllCheckbox.checked);
                            updateAssignButton();
                        }

                        function updateAssignButton() {
                            const leadCheckboxes = document.querySelectorAll('.lead-checkbox');
                            const checkedCount = Array.from(leadCheckboxes).filter(cb => cb.checked).length;
                            const massActionPanel = document.getElementById('massActionPanel');
                            const selectedCountSpan = document.getElementById('selectedCount');

                            // Select All sync
                            const selectAllCheckbox = document.getElementById('selectAll');
                            selectAllCheckbox.checked = (checkedCount > 0 && checkedCount === leadCheckboxes.length);

                            if (checkedCount > 0) {
                                selectedCountSpan.textContent = checkedCount;
                                massActionPanel.style.display = 'block';
                            } else {
                                massActionPanel.style.display = 'none';
                            }
                        }

                        function quickAssign(leadId, salesId) {
                            if (!salesId) return;

                            // Create a hidden form to submit the single assignment
                            const form = document.createElement('form');
                            form.method = 'post';
                            form.action = '${pageContext.request.contextPath}/marketing/monitor-leads';

                            const actionInput = document.createElement('input');
                            actionInput.type = 'hidden';
                            actionInput.name = 'action';
                            actionInput.value = 'assign';
                            form.appendChild(actionInput);

                            const leadInput = document.createElement('input');
                            leadInput.type = 'hidden';
                            leadInput.name = 'leadId';
                            leadInput.value = leadId;
                            form.appendChild(leadInput);

                            const salesInput = document.createElement('input');
                            salesInput.type = 'hidden';
                            salesInput.name = 'salesId';
                            salesInput.value = salesId;
                            form.appendChild(salesInput);

                            const campaignInput = document.createElement('input');
                            campaignInput.type = 'hidden';
                            campaignInput.name = 'listCampaignId';
                            campaignInput.value = '${selectedCampaignId}';
                            form.appendChild(campaignInput);

                            const searchInput = document.createElement('input');
                            searchInput.type = 'hidden';
                            searchInput.name = 'searchQuery';
                            searchInput.value = '${searchQuery}';
                            form.appendChild(searchInput);

                            const dateInput = document.createElement('input');
                            dateInput.type = 'hidden';
                            dateInput.name = 'dateFilter';
                            dateInput.value = '${dateFilter}';
                            form.appendChild(dateInput);

                            document.body.appendChild(form);
                            form.submit();
                        }

                        function handleDeleteLead(leadId) {
                            showConfirmDialog(
                                'Bạn có chắc chắn muốn xóa Lead #<strong>' + leadId + '</strong>? Hành động này không thể hoàn tác.',
                                function () {
                                    const form = document.createElement('form');
                                    form.method = 'post';
                                    form.action = '${pageContext.request.contextPath}/marketing/monitor-leads';

                                    const actionInput = document.createElement('input');
                                    actionInput.type = 'hidden';
                                    actionInput.name = 'action';
                                    actionInput.value = 'delete';
                                    form.appendChild(actionInput);

                                    const leadInput = document.createElement('input');
                                    leadInput.type = 'hidden';
                                    leadInput.name = 'leadId';
                                    leadInput.value = leadId;
                                    form.appendChild(leadInput);

                                    const campaignInput = document.createElement('input');
                                    campaignInput.type = 'hidden';
                                    campaignInput.name = 'listCampaignId';
                                    campaignInput.value = '${selectedCampaignId}';
                                    form.appendChild(campaignInput);

                                    const searchInput = document.createElement('input');
                                    searchInput.type = 'hidden';
                                    searchInput.name = 'searchQuery';
                                    searchInput.value = '${searchQuery}';
                                    form.appendChild(searchInput);

                                    const dateInput = document.createElement('input');
                                    dateInput.type = 'hidden';
                                    dateInput.name = 'dateFilter';
                                    dateInput.value = '${dateFilter}';
                                    form.appendChild(dateInput);

                                    document.body.appendChild(form);
                                    form.submit();
                                },
                                {
                                    title: 'Xóa Lead',
                                    confirmText: 'Xóa',
                                    confirmClass: 'btn-danger'
                                }
                            );
                        }
                    </script>
            </body>

            </html>