<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
            <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
                <%-- Set currentPage for sidebar highlight --%>
                    <% request.setAttribute("currentPage", "sales-customers" ); %>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <title>Danh sách Khách hàng - Hệ thống CRM</title>
                            <%@ include file="/includes/head.jsp" %>
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

                                                    <!-- Page Header & Filter Section -->
                                                    <div class="container-fluid pt-4 px-4">
                                                        <div class="bg-light rounded p-4 mb-4">
                                                            <div
                                                                class="d-flex justify-content-between align-items-center mb-4">
                                                                <h3 class="mb-0"><i class="fa fa-users me-2"></i>Danh
                                                                    sách Khách hàng</h3>
                                                            </div>

                                                            <!-- Search and Filter Form -->
                                                            <form
                                                                action="${pageContext.request.contextPath}/sales/customers"
                                                                method="get" class="row g-3 align-items-center">
                                                                <div class="col-md-4">
                                                                    <div class="input-group">
                                                                        <span
                                                                            class="input-group-text bg-transparent border-end-0"><i
                                                                                class="fa fa-search text-muted"></i></span>
                                                                        <input type="text"
                                                                            class="form-control border-start-0"
                                                                            name="search" value="${searchQuery}"
                                                                            placeholder="Tìm kiếm Công ty, Email hoặc Số điện thoại...">
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-3">
                                                                    <select class="form-select" name="tier">
                                                                        <option value="">Tất cả hạng</option>
                                                                        <option value="Standard"
                                                                            ${tierFilter=='Standard' ? 'selected' : ''
                                                                            }>Standard</option>
                                                                        <option value="VIP" ${tierFilter=='VIP'
                                                                            ? 'selected' : '' }>VIP</option>
                                                                        <option value="VVIP" ${tierFilter=='VVIP'
                                                                            ? 'selected' : '' }>VVIP</option>
                                                                    </select>
                                                                </div>
                                                                <div class="col-md-3">
                                                                    <select class="form-select" name="status">
                                                                        <option value="">Tất cả trạng thái</option>
                                                                        <option value="Active" ${statusFilter=='Active'
                                                                            ? 'selected' : '' }>Active</option>
                                                                        <option value="Inactive"
                                                                            ${statusFilter=='Inactive' ? 'selected' : ''
                                                                            }>Inactive</option>
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

                                                    <!-- Customer Table Section -->
                                                    <div class="container-fluid px-4">
                                                        <div class="row g-4">
                                                            <div class="col-12">
                                                                <div class="bg-light rounded p-4">
                                                                    <div class="table-responsive">
                                                                        <table class="table table-hover">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th>ID</th>
                                                                                    <th>Tên Công ty</th>
                                                                                    <th>Thông tin liên hệ</th>
                                                                                    <th>Hạng</th>
                                                                                    <th>Trạng thái</th>
                                                                                    <th>Tương tác cuối</th>
                                                                                    <th>Thao tác</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${empty customerList}">
                                                                                        <tr>
                                                                                            <td colspan="7"
                                                                                                class="text-center py-4 text-muted">
                                                                                                <i
                                                                                                    class="fa fa-info-circle me-2"></i>Không
                                                                                                tìm thấy khách hàng nào.
                                                                                            </td>
                                                                                        </tr>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <c:forEach var="customer"
                                                                                            items="${customerList}">
                                                                                            <tr>
                                                                                                <td>${customer.id}</td>
                                                                                                <td><strong>${customer.companyName}</strong>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <div class="small">
                                                                                                        <i
                                                                                                            class="fa fa-envelope me-2 text-primary"></i>${customer.email}
                                                                                                    </div>
                                                                                                    <div class="small">
                                                                                                        <i
                                                                                                            class="fa fa-phone me-2 text-primary"></i>${customer.phone}
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <span
                                                                                                        class="badge ${customer.tier == 'VIP' ? 'bg-warning text-dark' : (customer.tier == 'VVIP' ? 'bg-danger' : 'bg-primary')}">
                                                                                                        ${customer.tier}
                                                                                                    </span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <span
                                                                                                        class="badge ${customer.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
                                                                                                        ${customer.status}
                                                                                                    </span>
                                                                                                </td>
                                                                                                <td
                                                                                                    class="small text-muted">
                                                                                                    <c:if
                                                                                                        test="${not empty customer.lastCareDate}">
                                                                                                        <fmt:formatDate
                                                                                                            value="${customer.lastCareDate}"
                                                                                                            pattern="yyyy-MM-dd HH:mm" />
                                                                                                    </c:if>
                                                                                                    <c:if
                                                                                                        test="${empty customer.lastCareDate}">
                                                                                                        -</c:if>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <div
                                                                                                        class="d-flex gap-2">
                                                                                                        <button
                                                                                                            type="button"
                                                                                                            class="btn btn-sm btn-outline-success"
                                                                                                            title="Tạo Cơ hội mới"
                                                                                                            data-bs-toggle="modal"
                                                                                                            data-bs-target="#createOppModal"
                                                                                                            data-id="${customer.id}"
                                                                                                            data-name="${fn:escapeXml(customer.companyName)}">
                                                                                                            <i
                                                                                                                class="fa fa-plus-circle"></i>
                                                                                                        </button>
                                                                                                        <button
                                                                                                            type="button"
                                                                                                            class="btn btn-sm btn-outline-primary btn-view-customer"
                                                                                                            title="Xem chi tiết"
                                                                                                            data-id="${customer.id}"
                                                                                                            data-bs-toggle="modal"
                                                                                                            data-bs-target="#viewCustomerModal">
                                                                                                            <i
                                                                                                                class="fa fa-eye"></i>
                                                                                                        </button>
                                                                                                        <button
                                                                                                            type="button"
                                                                                                            class="btn btn-sm btn-outline-warning btn-view-history"
                                                                                                            title="Lịch sử tương tác"
                                                                                                            data-id="${customer.id}"
                                                                                                            data-name="${fn:escapeXml(customer.companyName)}"
                                                                                                            data-bs-toggle="modal"
                                                                                                            data-bs-target="#interactionLogModal">
                                                                                                            <i
                                                                                                                class="fa fa-history"></i>
                                                                                                        </button>
                                                                                                    </div>
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
                                                                            <ul
                                                                                class="pagination justify-content-center">
                                                                                <c:forEach begin="1" end="${totalPages}"
                                                                                    var="i">
                                                                                    <li
                                                                                        class="page-item ${i == pageNumber ? 'active' : ''}">
                                                                                        <a class="page-link"
                                                                                            href="${pageContext.request.contextPath}/sales/customers?page=${i}&search=${searchQuery}&tier=${tierFilter}&status=${statusFilter}">${i}</a>
                                                                                    </li>
                                                                                </c:forEach>
                                                                            </ul>
                                                                        </nav>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <%@ include file="/includes/footer.jsp" %>
                                        </div>
                                        <!-- Content End -->

                                        <!-- Create Opportunity Modal -->
                                        <div class="modal fade" id="createOppModal" tabindex="-1"
                                            aria-labelledby="createOppModalLabel" aria-hidden="true">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <form action="${pageContext.request.contextPath}/sales/customers"
                                                        method="get">
                                                        <input type="hidden" name="action" value="createOpportunity">
                                                        <input type="hidden" name="customerId" id="modalCustomerId">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="createOppModalLabel">Tạo Cơ hội
                                                                mới</h5>
                                                            <button type="button" class="btn-close"
                                                                data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="mb-3">
                                                                <label for="modalCompanyName" class="form-label">Tên Cơ
                                                                    hội / Đơn hàng</label>
                                                                <input type="text" class="form-control"
                                                                    name="companyName" id="modalCompanyName" required>
                                                                <div class="form-text">Nhập tên để phân biệt cơ hội bán
                                                                    hàng này.</div>
                                                            </div>
                                                            <p>Bạn có chắc chắn muốn tạo một cơ hội bán hàng mới cho
                                                                khách hàng này không?</p>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">Hủy</button>
                                                            <button type="submit" class="btn btn-success">Xác nhận
                                                                tạo</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Modal: Xem chi tiết khách hàng -->
                                        <div class="modal fade" id="viewCustomerModal" tabindex="-1"
                                            aria-labelledby="viewCustomerModalLabel" aria-hidden="true">
                                            <div class="modal-dialog modal-lg">
                                                <div class="modal-content">
                                                    <div class="modal-header bg-primary text-white">
                                                        <h5 class="modal-title" id="viewCustomerModalLabel">
                                                            <i class="fa fa-user me-2"></i>Chi tiết Khách hàng
                                                        </h5>
                                                        <button type="button" class="btn-close btn-close-white"
                                                            data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body" id="viewCustomerModalBody">
                                                        <div class="text-center py-4">
                                                            <div class="spinner-border text-primary" role="status">
                                                            </div>
                                                            <p class="mt-2 text-muted">Đang tải...</p>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                            data-bs-dismiss="modal">Đóng</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Modal: Lịch sử tương tác -->
                                        <div class="modal fade" id="interactionLogModal" tabindex="-1"
                                            aria-labelledby="interactionLogModalLabel" aria-hidden="true">
                                            <div class="modal-dialog modal-xl">
                                                <div class="modal-content">
                                                    <div class="modal-header bg-warning text-dark">
                                                        <h5 class="modal-title" id="interactionLogModalLabel">
                                                            <i class="fa fa-history me-2"></i>Lịch sử tương tác — <span
                                                                id="interactionLogCompanyName"></span>
                                                        </h5>
                                                        <button type="button" class="btn-close"
                                                            data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body" id="interactionLogModalBody">
                                                        <div class="text-center py-4">
                                                            <div class="spinner-border text-warning" role="status">
                                                            </div>
                                                            <p class="mt-2 text-muted">Đang tải lịch sử...</p>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                            data-bs-dismiss="modal">Đóng</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Back to Top -->
                                        <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                                class="bi bi-arrow-up"></i></a>
                            </div>

                            <%-- Include Scripts --%>
                                <%@ include file="/includes/scripts.jsp" %>
                                    <script>
                                        document.addEventListener('DOMContentLoaded', function () {
                                            var spinner = document.getElementById('spinner');
                                            if (spinner) spinner.classList.remove('show');

                                            // ── Create Opportunity Modal ──────────────────────────────
                                            var createOppModal = document.getElementById('createOppModal');
                                            if (createOppModal) {
                                                createOppModal.addEventListener('show.bs.modal', function (event) {
                                                    var btn = event.relatedTarget;
                                                    createOppModal.querySelector('#modalCustomerId').value = btn.getAttribute('data-id');
                                                    createOppModal.querySelector('#modalCompanyName').value = 'Đơn hàng - ' + btn.getAttribute('data-name');
                                                });
                                            }

                                            // ── View Customer Modal (AJAX → /customer-info) ───────────
                                            var viewModal = document.getElementById('viewCustomerModal');
                                            if (viewModal) {
                                                viewModal.addEventListener('show.bs.modal', function (event) {
                                                    var customerId = event.relatedTarget.getAttribute('data-id');
                                                    var body = document.getElementById('viewCustomerModalBody');
                                                    body.innerHTML = '<div class="text-center py-4"><div class="spinner-border text-primary" role="status"></div><p class="mt-2 text-muted">Đang tải...</p></div>';
                                                    fetch('${pageContext.request.contextPath}/customer-info?id=' + customerId)
                                                        .then(function (r) { return r.json(); })
                                                        .then(function (c) {
                                                            body.innerHTML =
                                                                '<div class="row g-3">'
                                                                + '<div class="col-md-6"><div class="card h-100 border-0 shadow-sm"><div class="card-body">'
                                                                + '<h6 class="text-primary fw-bold mb-3"><i class="fa fa-building me-2"></i>Thông tin công ty</h6>'
                                                                + '<table class="table table-sm table-borderless mb-0">'
                                                                + '<tr><td class="text-muted" style="width:45%">Tên công ty</td><td><strong>' + (c.companyName || '-') + '</strong></td></tr>'
                                                                + '<tr><td class="text-muted">Ngành</td><td>' + (c.industry || '-') + '</td></tr>'
                                                                + '<tr><td class="text-muted">Hạng</td><td><span class="badge ' + (c.tier === 'VIP' ? 'bg-warning text-dark' : c.tier === 'VVIP' ? 'bg-danger' : 'bg-primary') + '">' + (c.tier || '-') + '</span></td></tr>'
                                                                + '<tr><td class="text-muted">Website</td><td>' + (c.website ? '<a href="' + c.website + '" target="_blank">' + c.website + '</a>' : '-') + '</td></tr>'
                                                                + '</table></div></div></div>'
                                                                + '<div class="col-md-6"><div class="card h-100 border-0 shadow-sm"><div class="card-body">'
                                                                + '<h6 class="text-success fw-bold mb-3"><i class="fa fa-address-book me-2"></i>Liên hệ</h6>'
                                                                + '<table class="table table-sm table-borderless mb-0">'
                                                                + '<tr><td class="text-muted" style="width:45%">Email</td><td>' + (c.email || '-') + '</td></tr>'
                                                                + '<tr><td class="text-muted">Điện thoại</td><td>' + (c.phone || '-') + '</td></tr>'
                                                                + '<tr><td class="text-muted">Thành phố</td><td>' + (c.city || '-') + '</td></tr>'
                                                                + '<tr><td class="text-muted">Quốc gia</td><td>' + (c.country || '-') + '</td></tr>'
                                                                + '<tr><td class="text-muted">Chăm sóc cuối</td><td>' + (c.lastCareDate || '-') + '</td></tr>'
                                                                + '</table></div></div></div>'
                                                                + '</div>';
                                                        })
                                                        .catch(function () {
                                                            body.innerHTML = '<div class="alert alert-danger">Không thể tải thông tin khách hàng.</div>';
                                                        });
                                                });
                                            }

                                            // ── Interaction Log Modal (AJAX → /customers?action=history) ─
                                            var historyModal = document.getElementById('interactionLogModal');
                                            if (historyModal) {
                                                historyModal.addEventListener('show.bs.modal', function (event) {
                                                    var btn = event.relatedTarget;
                                                    var customerId = btn.getAttribute('data-id');
                                                    var companyName = btn.getAttribute('data-name');
                                                    document.getElementById('interactionLogCompanyName').textContent = companyName;
                                                    var body = document.getElementById('interactionLogModalBody');
                                                    body.innerHTML = '<div class="text-center py-4"><div class="spinner-border text-warning" role="status"></div><p class="mt-2 text-muted">Đang tải lịch sử...</p></div>';
                                                    fetch('${pageContext.request.contextPath}/customers?action=history&id=' + customerId + '&fragment=true')
                                                        .then(function (r) { return r.text(); })
                                                        .then(function (html) {
                                                            body.innerHTML = html;
                                                        })
                                                        .catch(function () {
                                                            body.innerHTML = '<div class="alert alert-danger">Không thể tải lịch sử tương tác.</div>';
                                                        });
                                                });
                                                // Clear body khi đóng để không cache dữ liệu cũ
                                                historyModal.addEventListener('hidden.bs.modal', function () {
                                                    document.getElementById('interactionLogModalBody').innerHTML = '';
                                                    document.getElementById('viewCustomerModalBody').innerHTML = '';
                                                });
                                            }
                                        });
                                    </script>
                        </body>

                        </html>