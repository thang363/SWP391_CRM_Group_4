<%-- opportunity-list.jsp - Trang Danh sách Cơ hội --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%-- Đặt biến currentPage để highlight menu active --%>
            <% request.setAttribute("currentPage", "opportunities" ); %>
                <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <title>Opportunity list - CRM System</title>
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
                                                                        class="fa fa-handshake me-2"></i>Danh sách Cơ
                                                                    hội</h3>
                                                                <button class="btn btn-primary"><i
                                                                        class="fa fa-plus me-2"></i>Thêm Cơ hội
                                                                    mới</button>
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
                                                                            placeholder="Tìm tên cơ hội hoặc khách hàng...">
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-3">
                                                                    <select class="form-select" name="stage">
                                                                        <option value="" selected>Tất cả giai đoạn
                                                                        </option>
                                                                        <option value="Prospecting">Tìm kiếm</option>
                                                                        <option value="Qualification">Đánh giá</option>
                                                                        <option value="Proposal">Đề xuất</option>
                                                                        <option value="Negotiation">Thương lượng
                                                                        </option>
                                                                        <option value="Closed Won">Thành công</option>
                                                                        <option value="Closed Lost">Thất bại</option>
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

                                                    <!-- Opportunity Table -->
                                                    <div class="container-fluid px-4">
                                                        <div class="row g-4">
                                                            <div class="col-12">
                                                                <div class="bg-light rounded p-4">
                                                                    <div class="table-responsive">
                                                                        <table class="table table-hover">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th>ID</th>
                                                                                    <th>Tên Cơ hội</th>
                                                                                    <th>Giá trị (VND)</th>
                                                                                    <th>Giai đoạn</th>
                                                                                    <th>Xác suất</th>
                                                                                    <th>Ngày tạo</th>
                                                                                    <th>Thao tác</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <c:if test="${empty opportunityList}">
                                                                                    <tr>
                                                                                        <td colspan="7"
                                                                                            class="text-center text-muted py-5">
                                                                                            <i
                                                                                                class="fa fa-box-open fa-3x mb-3 d-block"></i>
                                                                                            Không tìm thấy cơ hội nào.
                                                                                            <br>
                                                                                            <small>(Dữ liệu mẫu sẽ hiển
                                                                                                thị ở đây sau khi kết
                                                                                                nối backend)</small>
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:if>
                                                                                <c:forEach var="opp"
                                                                                    items="${opportunityList}">
                                                                                    <tr>
                                                                                        <td>${opp.id}</td>
                                                                                        <td><strong>${opp.name}</strong>
                                                                                        </td>
                                                                                        <td
                                                                                            class="text-success fw-bold">
                                                                                            <fmt:formatNumber
                                                                                                value="${opp.expectedValue}"
                                                                                                type="currency"
                                                                                                currencySymbol="₫" />
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${opp.stage == 'Closed Won'}">
                                                                                                    <span
                                                                                                        class="badge bg-success">Thành
                                                                                                        công</span>
                                                                                                </c:when>
                                                                                                <c:when
                                                                                                    test="${opp.stage == 'Closed Lost'}">
                                                                                                    <span
                                                                                                        class="badge bg-danger">Thất
                                                                                                        bại</span>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="badge bg-info text-dark">${opp.stage}</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <div class="progress"
                                                                                                style="height: 10px; width: 100px;">
                                                                                                <div class="progress-bar"
                                                                                                    role="progressbar"
                                                                                                    style="width: ${opp.probability}%"
                                                                                                    aria-valuenow="${opp.probability}"
                                                                                                    aria-valuemin="0"
                                                                                                    aria-valuemax="100">
                                                                                                </div>
                                                                                            </div>
                                                                                            <small>${opp.probability}%</small>
                                                                                        </td>
                                                                                        <td>${opp.createdAt}</td>
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
                                                                                                    title="Chỉnh sửa">
                                                                                                    <i
                                                                                                        class="fa fa-edit"></i>
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