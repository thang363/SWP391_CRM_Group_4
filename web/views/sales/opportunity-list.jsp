<%-- opportunity-list.jsp - Trang Danh sách Cơ hội --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib uri="jakarta.tags.core" prefix="c" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                    <% request.setAttribute("currentPage", "opportunities" ); %>
                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <title>Opportunity List - CRM System</title>
                            <%@ include file="/includes/head.jsp" %>
                        </head>

                        <body>
                            <div class="container-xxl position-relative bg-white d-flex p-0">

                                <!-- Spinner -->
                                <div id="spinner"
                                    class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                                    <div class="spinner-border text-primary" style="width:3rem;height:3rem;"
                                        role="status">
                                        <span class="sr-only">Loading...</span>
                                    </div>
                                </div>

                                <%@ include file="/includes/sidebar.jsp" %>

                                    <!-- Content Start -->
                                    <div class="content">
                                        <%@ include file="/includes/topbar.jsp" %>

                                            <!-- Page Header & Filter -->
                                            <div class="container-fluid pt-4 px-4">
                                                <div class="bg-light rounded p-4 mb-4">
                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <h4 class="mb-0"><i class="fa fa-handshake me-2"></i>Danh sách
                                                            Cơ hội</h4>
                                                    </div>

                                                    <!-- Filter Form -->
                                                    <form
                                                        action="${pageContext.request.contextPath}/sales/opportunities"
                                                        method="get" class="row g-3 align-items-center">
                                                        <div class="col-md-5">
                                                            <div class="input-group">
                                                                <span
                                                                    class="input-group-text bg-transparent border-end-0">
                                                                    <i class="fa fa-search text-muted"></i>
                                                                </span>
                                                                <input type="text" class="form-control border-start-0"
                                                                    name="search" value="${fn:escapeXml(searchQuery)}"
                                                                    placeholder="Tìm tên cơ hội...">
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <select class="form-select" name="stage">
                                                                <option value="" ${empty stageFilter ? 'selected' : ''
                                                                    }>Tất cả giai đoạn</option>
                                                                <option value="Prospecting" ${stageFilter=='Prospecting'
                                                                    ? 'selected' : '' }>Tìm kiếm</option>
                                                                <option value="Qualification"
                                                                    ${stageFilter=='Qualification' ? 'selected' : '' }>
                                                                    Đánh giá</option>
                                                                <option value="Proposal" ${stageFilter=='Proposal'
                                                                    ? 'selected' : '' }>Đề xuất</option>
                                                                <option value="Negotiation" ${stageFilter=='Negotiation'
                                                                    ? 'selected' : '' }>Thương lượng</option>
                                                                <option value="Won" ${stageFilter=='Won' ? 'selected'
                                                                    : '' }>Thành công</option>
                                                                <option value="Lost" ${stageFilter=='Lost' ? 'selected'
                                                                    : '' }>Thất bại</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-2">
                                                            <button type="submit" class="btn btn-primary w-100">
                                                                <i class="fa fa-filter me-2"></i>Lọc
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>

                                            <!-- Opportunity Table -->
                                            <div class="container-fluid px-4 pb-4">
                                                <div class="bg-light rounded p-4">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover align-middle mb-0">
                                                            <thead class="table-light">
                                                                <tr>
                                                                    <th style="width:50px">#</th>
                                                                    <th>Tên Cơ hội</th>
                                                                    <th>Giá trị (VND)</th>
                                                                    <th style="width:170px">Giai đoạn</th>
                                                                    <th style="width:80px" class="text-center">Báo giá
                                                                    </th>
                                                                    <th style="width:130px">Xác suất</th>
                                                                    <th style="width:130px">Ngày tạo</th>
                                                                    <th style="width:120px" class="text-center">Thao tác
                                                                    </th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:if test="${empty opportunityList}">
                                                                    <tr>
                                                                        <td colspan="8"
                                                                            class="text-center text-muted py-5">
                                                                            <i
                                                                                class="fa fa-box-open fa-3x mb-3 d-block"></i>
                                                                            Không tìm thấy cơ hội nào.
                                                                        </td>
                                                                    </tr>
                                                                </c:if>

                                                                <c:forEach var="opp" items="${opportunityList}">
                                                                    <tr>
                                                                        <td class="text-muted">${opp.id}</td>

                                                                        <td><strong>${fn:escapeXml(opp.name)}</strong>
                                                                        </td>

                                                                        <td class="text-success fw-bold">
                                                                            <fmt:formatNumber
                                                                                value="${opp.expectedValue}"
                                                                                type="currency" currencySymbol="₫" />
                                                                        </td>

                                                                        <td>
                                                                            <form
                                                                                action="${pageContext.request.contextPath}/sales/opportunities"
                                                                                method="post">
                                                                                <input type="hidden"
                                                                                    name="opportunityId"
                                                                                    value="${opp.id}" />
                                                                                <select
                                                                                    class="form-select form-select-sm"
                                                                                    name="stage" ${(opp.stage=='Won' ||
                                                                                    opp.stage=='Lost' ) ? 'disabled'
                                                                                    : '' }
                                                                                    onchange="this.form.submit()">
                                                                                    <option value="Prospecting"
                                                                                        ${opp.stage=='Prospecting'
                                                                                        ?'selected':''}>Tìm kiếm
                                                                                    </option>
                                                                                    <option value="Qualification"
                                                                                        ${opp.stage=='Qualification'
                                                                                        ?'selected':''}>Đánh giá
                                                                                    </option>
                                                                                    <option value="Proposal"
                                                                                        ${opp.stage=='Proposal'
                                                                                        ?'selected':''}>Đề xuất</option>
                                                                                    <option value="Negotiation"
                                                                                        ${opp.stage=='Negotiation'
                                                                                        ?'selected':''}>Thương lượng
                                                                                    </option>
                                                                                    <option value="Lost"
                                                                                        ${opp.stage=='Lost'
                                                                                        ?'selected':''}>❌ Thất bại
                                                                                    </option>
                                                                                </select>
                                                                            </form>
                                                                        </td>

                                                                        <td class="text-center">
                                                                            <a href="${pageContext.request.contextPath}/sales/opportunity-detail?id=${opp.id}&tab=quotes"
                                                                                class="badge text-decoration-none fs-6 ${opp.quoteCount > 0 ? 'bg-primary' : 'bg-secondary'}"
                                                                                title="Xem báo giá">
                                                                                <i
                                                                                    class="fa fa-file-invoice me-1"></i>${opp.quoteCount}
                                                                            </a>
                                                                        </td>

                                                                        <td>
                                                                            <div
                                                                                class="d-flex align-items-center gap-2">
                                                                                <div class="progress flex-grow-1"
                                                                                    style="height:8px;">
                                                                                    <div class="progress-bar"
                                                                                        style="width:${opp.probability}%">
                                                                                    </div>
                                                                                </div>
                                                                                <small
                                                                                    class="text-muted">${opp.probability}%</small>
                                                                            </div>
                                                                        </td>

                                                                        <td class="text-muted small">${opp.createdAt}
                                                                        </td>

                                                                        <td class="text-center">
                                                                            <div
                                                                                class="d-flex gap-1 justify-content-center">
                                                                                <a href="${pageContext.request.contextPath}/sales/opportunity-detail?id=${opp.id}"
                                                                                    class="btn btn-sm btn-outline-info"
                                                                                    title="Xem chi tiết">
                                                                                    <i class="fa fa-eye"></i>
                                                                                </a>
                                                                                <button type="button"
                                                                                    class="btn btn-sm btn-outline-primary"
                                                                                    title="Chỉnh sửa"
                                                                                    data-id="${opp.id}"
                                                                                    data-name="${fn:escapeXml(opp.name)}"
                                                                                    onclick="showEditOpportunityModal(this)">
                                                                                    <i class="fa fa-edit"></i>
                                                                                </button>
                                                                                <c:if
                                                                                    test="${opp.stage != 'Won' && opp.stage != 'Lost'}">
                                                                                    <a href="${pageContext.request.contextPath}/sales/opportunity-detail?id=${opp.id}&tab=quotes"
                                                                                        class="btn btn-sm btn-outline-success"
                                                                                        title="Tạo báo giá">
                                                                                        <i class="fa fa-plus"></i>
                                                                                    </a>
                                                                                </c:if>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Edit Modal -->
                                            <div class="modal fade" id="opportunityEditModal" tabindex="-1"
                                                aria-labelledby="opportunityEditModalLabel" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <form
                                                            action="${pageContext.request.contextPath}/EditLeadbySaleServlet"
                                                            method="post">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title" id="opportunityEditModalLabel">
                                                                    Chỉnh sửa Cơ hội</h5>
                                                                <button type="button" class="btn-close"
                                                                    data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <input type="hidden" name="opportunityId"
                                                                    id="opportunityId">
                                                                <div class="mb-3">
                                                                    <label for="editName" class="form-label">Tên cơ
                                                                        hội</label>
                                                                    <input type="text" class="form-control"
                                                                        id="editName" name="name" required>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary"
                                                                    data-bs-dismiss="modal">Hủy</button>
                                                                <button type="submit" class="btn btn-primary">Lưu thay
                                                                    đổi</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>

                                            <%@ include file="/includes/footer.jsp" %>
                                    </div>
                                    <!-- Content End -->

                                    <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                            class="bi bi-arrow-up"></i></a>
                            </div>

                            <%@ include file="/includes/scripts.jsp" %>
                                <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        var spinner = document.getElementById('spinner');
                                        if (spinner) spinner.classList.remove('show');
                                    });

                                    function showEditOpportunityModal(button) {
                                        document.getElementById('opportunityId').value = button.dataset.id;
                                        document.getElementById('editName').value = button.dataset.name;
                                        new bootstrap.Modal(document.getElementById('opportunityEditModal')).show();
                                    }
                                </script>
                        </body>

                        </html>