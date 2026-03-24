<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <% request.setAttribute("currentPage", "customers" ); %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>Danh sách Khách hàng - CRM System</title>
                    <%@ include file="/includes/head.jsp" %>
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

                                            <!-- Main Content Start -->
                                            <div class="container-fluid pt-4 px-4">
                                                <div class="d-flex justify-content-between align-items-center mb-4">
                                                    <h4 class="mb-0">Danh sách Khách hàng</h4>
                                                    <div>
                                                        <a href="${pageContext.request.contextPath}/customers?action=merge"
                                                            class="btn btn-warning"><i
                                                                class="fa fa-compress-alt me-2"></i>Gộp hồ sơ
                                                            (Merge)</a>
                                                        <a href="${pageContext.request.contextPath}/customers?action=export"
                                                            class="btn btn-success"><i
                                                                class="fa fa-file-excel me-2"></i>Xuất CSV</a>
                                                        <a href="${pageContext.request.contextPath}/customers?action=create"
                                                            class="btn btn-primary"><i class="fa fa-plus me-2"></i>Thêm
                                                            Mới</a>
                                                    </div>
                                                </div>

                                                <c:if test="${param.success == 'delete'}">
                                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                                        <i class="fa fa-check-circle me-2"></i>Đã xóa khách hàng thành công!
                                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                                    </div>
                                                </c:if>

                                                <c:if test="${param.error == 'delete_constraint'}">
                                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                        <i class="fa fa-exclamation-triangle me-2"></i><strong>Lỗi:</strong> Không thể xóa khách hàng này vì tài khoản đã có dữ liệu liên kết (như Cơ hội, Thông tin liên hệ, Vé hỗ trợ, Đánh giá...). Hãy dùng tính năng <strong>Gộp hồ sơ</strong> hoặc đổi Trạng thái thành <strong>Inactive</strong>.
                                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                                    </div>
                                                </c:if>

                                                <c:if test="${param.success == 'merge'}">
                                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                                        <i class="fa fa-check-circle me-2"></i>Đã gộp hồ sơ khách hàng thành công!
                                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                                    </div>
                                                </c:if>

                                                <div class="bg-light rounded p-4 mb-4">
                                                    <!-- Search/Filter -->
                                                    <form action="${pageContext.request.contextPath}/customers"
                                                        method="GET" class="row g-3">
                                                        <input type="hidden" name="action" value="list">
                                                        <div class="col-md-4">
                                                            <input type="text" name="search" class="form-control"
                                                                placeholder="Tên công ty, Email, SĐT..."
                                                                value="${search}">
                                                        </div>
                                                        <div class="col-md-3">
                                                            <select name="tier" class="form-select">
                                                                <option value="" ${tier=='' ? 'selected' : '' }>Tất cả
                                                                    mức độ (Tier)</option>
                                                                <option value="Standard" ${tier=='Standard' ? 'selected'
                                                                    : '' }>Standard</option>
                                                                <option value="Silver" ${tier=='Silver' ? 'selected'
                                                                    : '' }>Silver</option>
                                                                <option value="Gold" ${tier=='Gold' ? 'selected'
                                                                    : '' }>Gold</option>
                                                                <option value="Platinum" ${tier=='Platinum' ? 'selected'
                                                                    : '' }>Platinum</option>
                                                                <option value="VIP" ${tier=='VIP' ? 'selected' : '' }>
                                                                    VIP</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <select name="status" class="form-select">
                                                                <option value="" ${status=='' ? 'selected' : '' }>Tất cả
                                                                    trạng thái</option>
                                                                <option value="Active" ${status=='Active' ? 'selected'
                                                                    : '' }>Active</option>
                                                                <option value="Inactive" ${status=='Inactive'
                                                                    ? 'selected' : '' }>Inactive</option>
                                                                <option value="Churned" ${status=='Churned'
                                                                    ? 'selected' : '' }>Churned</option>
                                                                <option value="Blacklisted" ${status=='Blacklisted'
                                                                    ? 'selected' : '' }>Blacklisted</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-2">
                                                            <button type="submit" class="btn btn-primary w-100"><i
                                                                    class="fa fa-search me-2"></i>Lọc</button>
                                                        </div>
                                                    </form>
                                                </div>

                                                <div class="bg-light rounded h-100 p-4">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover align-middle">
                                                            <thead>
                                                                <tr>
                                                                    <th scope="col">STT</th>
                                                                    <th scope="col">Tên Khách Hàng</th>
                                                                    <th scope="col">SĐT</th>
                                                                    <th scope="col">Email</th>
                                                                    <th scope="col">Tier</th>
                                                                    <th scope="col">Trạng thái</th>
                                                                    <th scope="col">Hành động</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="customer" items="${customers}"
                                                                    varStatus="loop">
                                                                    <tr>
                                                                        <td>${loop.index + 1 + (pageNumber - 1) * 10}
                                                                        </td>
                                                                        <td class="text-start">${customer.companyName}
                                                                        </td>
                                                                        <td>${customer.phone}</td>
                                                                        <td>${customer.email}</td>
                                                                        <td>
                                                                            <span
                                                                                class="badge ${customer.tier == 'VIP' ? 'bg-warning' : (customer.tier == 'VVIP' ? 'bg-danger' : 'bg-primary')}">
                                                                                ${customer.tier}
                                                                            </span>
                                                                        </td>
                                                                        <td>
                                                                            <span
                                                                                class="badge ${customer.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
                                                                                ${customer.status}
                                                                            </span>
                                                                        </td>
                                                                        <td>
                                                                            <a href="${pageContext.request.contextPath}/customers?action=details&id=${customer.id}"
                                                                                class="btn btn-sm btn-info"
                                                                                title="Chi tiết"><i
                                                                                    class="fa fa-eye"></i></a>
                                                                            <a href="${pageContext.request.contextPath}/customers?action=edit&id=${customer.id}"
                                                                                class="btn btn-sm btn-warning"
                                                                                title="Sửa"><i
                                                                                    class="fa fa-edit"></i></a>
                                                                            <form
                                                                                action="${pageContext.request.contextPath}/customers?action=delete"
                                                                                method="POST" style="display:inline;"
                                                                                onsubmit="return confirm('Bạn có chắc chắn muốn xóa khách hàng này?');">
                                                                                <input type="hidden" name="id"
                                                                                    value="${customer.id}">
                                                                                <button type="submit"
                                                                                    class="btn btn-sm btn-danger"
                                                                                    title="Xóa"><i
                                                                                        class="fa fa-trash"></i></button>
                                                                            </form>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                                <c:if test="${empty customers}">
                                                                    <tr>
                                                                        <td colspan="7" class="text-center">Không tìm
                                                                            thấy khách hàng nào.</td>
                                                                    </tr>
                                                                </c:if>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>

                                                <!-- Pagination -->
                                                <c:if test="${totalPages > 1}">
                                                    <nav aria-label="Page navigation" class="mt-4">
                                                        <ul class="pagination justify-content-center">
                                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                                <li
                                                                    class="page-item ${i == pageNumber ? 'active' : ''}">
                                                                    <a class="page-link"
                                                                        href="${pageContext.request.contextPath}/customers?action=list&page=${i}&search=${search}&tier=${tier}&status=${status}">${i}</a>
                                                                </li>
                                                            </c:forEach>
                                                        </ul>
                                                    </nav>
                                                </c:if>

                                            </div>
                                            <!-- Main Content End -->

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
                                document.addEventListener('DOMContentLoaded', function () {
                                    var spinner = document.getElementById('spinner');
                                    if (spinner) {
                                        spinner.classList.remove('show');
                                    }
                                });
                            </script>
                </body>

                </html>