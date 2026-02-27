<%-- quote-list.jsp - Trang Danh sách Báo giá --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%-- Đặt biến currentPage để highlight menu active --%>
            <% request.setAttribute("currentPage", "quotes" ); %>
                <%@ taglib uri="jakarta.tags.core" prefix="c" %>
                    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <title>Danh sách Báo giá - CRM System</title>
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
                                                                <h3 class="mb-0"><i
                                                                        class="fa fa-file-invoice-dollar me-2"></i>Danh
                                                                    sách Báo giá</h3>
                                                                <button class="btn btn-primary"><i
                                                                        class="fa fa-plus me-2"></i>Thành lập Báo
                                                                    giá</button>
                                                            </div>

                                                            <!-- Search and Filter Form -->
                                                            <form class="row g-3 align-items-center">
                                                                <div class="col-md-4">
                                                                    <div class="input-group">
                                                                        <span
                                                                            class="input-group-text bg-transparent border-end-0"><i
                                                                                class="fa fa-search text-muted"></i></span>
                                                                        <input type="text"
                                                                            class="form-control border-start-0"
                                                                            name="search"
                                                                            placeholder="Tìm số báo giá hoặc chủ đề...">
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-3">
                                                                    <select class="form-select" name="status">
                                                                        <option value="" selected>Tất cả trạng thái
                                                                        </option>
                                                                        <option value="Draft">Bản nháp</option>
                                                                        <option value="Sent">Đã gửi</option>
                                                                        <option value="Accepted">Đã chấp nhận</option>
                                                                        <option value="Rejected">Từ chối</option>
                                                                        <option value="Expired">Hết hạn</option>
                                                                    </select>
                                                                </div>
                                                                <div class="col-md-2">
                                                                    <button type="button" class="btn btn-primary w-100">
                                                                        <i class="fa fa-filter me-2"></i>Lọc
                                                                    </button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>

                                                    <!-- Quotes Table -->
                                                    <div class="container-fluid px-4">
                                                        <div class="row g-4">
                                                            <div class="col-12">
                                                                <div class="bg-light rounded p-4">
                                                                    <div class="table-responsive">
                                                                        <div class="table-responsive">
                                                                            <table
                                                                                class="table table-hover align-middle">
                                                                                <thead>
                                                                                    <tr>
                                                                                        <th>Số Báo giá</th>
                                                                                        <th>Cơ hội</th>
                                                                                        <th>Chủ đề</th>
                                                                                        <th>Tổng tiền (VND)</th>
                                                                                        <th>Trạng thái</th>
                                                                                        <th>Hiệu lực đến</th>
                                                                                        <th>Ngày tạo</th>
                                                                                        <th>Thao tác</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody>
                                                                                    <c:if test="${empty quoteList}">
                                                                                        <tr>
                                                                                            <td colspan="8"
                                                                                                class="text-center text-muted py-5">
                                                                                                <i
                                                                                                    class="fa fa-file-invoice fa-3x mb-3 d-block"></i>
                                                                                                Không tìm thấy báo giá
                                                                                                nào.
                                                                                            </td>
                                                                                        </tr>
                                                                                    </c:if>
                                                                                    <c:forEach var="quote"
                                                                                        items="${quoteList}">
                                                                                        <tr>
                                                                                            <td><strong>${quote.quoteNumber}</strong>
                                                                                            </td>
                                                                                            <td>
                                                                                                <a href="${pageContext.request.contextPath}/sales/opportunity-detail?id=${quote.opportunityId}&tab=quotes"
                                                                                                    class="text-decoration-none">
                                                                                                    <i
                                                                                                        class="fa fa-handshake me-1 text-muted"></i>
                                                                                                    ${empty
                                                                                                    quote.opportunityName
                                                                                                    ?
                                                                                                    '#'.concat(quote.opportunityId)
                                                                                                    :
                                                                                                    quote.opportunityName}
                                                                                                </a>
                                                                                            </td>
                                                                                            <td>${quote.subject}</td>
                                                                                            <td
                                                                                                class="text-primary fw-bold">
                                                                                                <fmt:formatNumber
                                                                                                    value="${quote.grandTotal}"
                                                                                                    type="currency"
                                                                                                    currencySymbol="₫" />
                                                                                            </td>
                                                                                            <td>
                                                                                                <c:choose>
                                                                                                    <c:when
                                                                                                        test="${quote.status == 'Draft'}">
                                                                                                        <span
                                                                                                            class="badge bg-secondary">Bản
                                                                                                            nháp</span>
                                                                                                    </c:when>
                                                                                                    <c:when
                                                                                                        test="${quote.status == 'Sent'}">
                                                                                                        <span
                                                                                                            class="badge bg-info text-dark">Đã
                                                                                                            gửi</span>
                                                                                                    </c:when>
                                                                                                    <c:when
                                                                                                        test="${quote.status == 'Accepted'}">
                                                                                                        <span
                                                                                                            class="badge bg-success">Chấp
                                                                                                            nhận</span>
                                                                                                    </c:when>
                                                                                                    <c:when
                                                                                                        test="${quote.status == 'Rejected'}">
                                                                                                        <span
                                                                                                            class="badge bg-danger">Từ
                                                                                                            chối</span>
                                                                                                    </c:when>
                                                                                                    <c:when
                                                                                                        test="${quote.status == 'Expired'}">
                                                                                                        <span
                                                                                                            class="badge bg-warning text-dark">Hết
                                                                                                            hạn</span>
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                        <span
                                                                                                            class="badge bg-light text-dark">${quote.status}</span>
                                                                                                    </c:otherwise>
                                                                                                </c:choose>
                                                                                            </td>
                                                                                            <td>${quote.validUntil}</td>
                                                                                            <td>${quote.createdAt}</td>
                                                                                            <td>
                                                                                                <a href="${pageContext.request.contextPath}/sales/opportunity-detail?id=${quote.opportunityId}&tab=quotes"
                                                                                                    class="btn btn-sm btn-outline-info"
                                                                                                    title="Xem chi tiết">
                                                                                                    <i
                                                                                                        class="fa fa-eye"></i>
                                                                                                </a>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </c:forEach>
                                                                                </tbody>
                                                                            </table>
                                                                        </div>

                                                                        <%@ include file="/includes/footer.jsp" %>
                                                                    </div>
                                                                    <!-- Content End -->

                                                                    <!-- Back to Top -->
                                                                    <a href="#"
                                                                        class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                                                            class="bi bi-arrow-up"></i></a>
                                                                </div>

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