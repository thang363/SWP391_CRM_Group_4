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
                                                                        <table class="table table-hover">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th>Số Báo giá</th>
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
                                                                                        <td colspan="7"
                                                                                            class="text-center text-muted py-5">
                                                                                            <i
                                                                                                class="fa fa-file-invoice fa-3x mb-3 d-block"></i>
                                                                                            Không tìm thấy báo giá nào.
                                                                                            <br>
                                                                                            <small>(Dữ liệu mẫu sẽ hiển
                                                                                                thị ở đây sau khi kết
                                                                                                nối backend)</small>
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:if>
                                                                                <c:forEach var="quote"
                                                                                    items="${quoteList}">
                                                                                    <tr>
                                                                                        <td><strong>${quote.quoteNumber}</strong>
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
                                                                                                    test="${quote.status == 'Accepted'}">
                                                                                                    <span
                                                                                                        class="badge bg-success">Đã
                                                                                                        chấp nhận</span>
                                                                                                </c:when>
                                                                                                <c:when
                                                                                                    test="${quote.status == 'Rejected'}">
                                                                                                    <span
                                                                                                        class="badge bg-danger">Từ
                                                                                                        chối</span>
                                                                                                </c:when>
                                                                                                <c:when
                                                                                                    test="${quote.status == 'Sent'}">
                                                                                                    <span
                                                                                                        class="badge bg-info text-dark">Đã
                                                                                                        gửi</span>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="badge bg-secondary">${quote.status}</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>${quote.validUntil}</td>
                                                                                        <td>${quote.createdAt}</td>
                                                                                        <td>
                                                                                            <div class="d-flex gap-2">
                                                                                                <button type="button"
                                                                                                    class="btn btn-sm btn-outline-info"
                                                                                                    title="Xem chi tiết">
                                                                                                    <i
                                                                                                        class="fa fa-eye"></i>
                                                                                                </button>
                                                                                                <button type="button"
                                                                                                    class="btn btn-sm btn-outline-primary"
                                                                                                    title="In/Xuất PDF">
                                                                                                    <i
                                                                                                        class="fa fa-file-pdf"></i>
                                                                                                </button>
                                                                                            </div>
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:forEach>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

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