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
                                                                                                        <a href="${pageContext.request.contextPath}/customers?action=details&id=${customer.id}"
                                                                                                            class="btn btn-sm btn-outline-primary"
                                                                                                            title="Chi tiết"><i
                                                                                                                class="fa fa-eye"></i></a>
                                                                                                        <a href="${pageContext.request.contextPath}/customers?action=history&id=${customer.id}"
                                                                                                            class="btn btn-sm btn-outline-warning"
                                                                                                            title="Lịch sử tương tác"><i
                                                                                                                class="fa fa-history"></i></a>
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

                                        <!-- Back to Top -->
                                        <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                                class="bi bi-arrow-up"></i></a>
                            </div>

                            <%-- Include Scripts --%>
                                <%@ include file="/includes/scripts.jsp" %>
                                    <script>
                                        document.addEventListener('DOMContentLoaded', function () {
                                            var spinner = document.getElementById('spinner');
                                            if (spinner) {
                                                spinner.classList.remove('show');
                                            }

                                            // Handle Create Opportunity Modal
                                            var createOppModal = document.getElementById('createOppModal');
                                            if (createOppModal) {
                                                createOppModal.addEventListener('show.bs.modal', function (event) {
                                                    var button = event.relatedTarget;
                                                    var customerId = button.getAttribute('data-id');
                                                    var companyName = button.getAttribute('data-name');

                                                    var modalCustomerId = createOppModal.querySelector('#modalCustomerId');
                                                    var modalCompanyName = createOppModal.querySelector('#modalCompanyName');

                                                    modalCustomerId.value = customerId;
                                                    modalCompanyName.value = "Đơn hàng - " + companyName;
                                                });
                                            }
                                        });
                                    </script>
                        </body>

                        </html>