<%-- dashboard.jsp - Trang Dashboard --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%-- Đặt biến currentPage để highlight menu active --%>
            <% request.setAttribute("currentPage", "dashboard" ); %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>Dashboard - CRM System</title>
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

                                            <!-- ============================================== -->
                                            <!-- ========= SUPPORT =========== -->
                                            <!-- ============================================== -->

                                            <c:choose>
                                                <c:when test="${sessionScope.userRole == 'SUPPORT'}">
                                                    <!-- Support Dashboard Start -->
                                                    <div class="container-fluid pt-4 px-4">
                                                        <h5 class="mb-4">Tổng quan công việc Hỗ trợ</h5>
                                                        <div class="row g-4">
                                                            <div class="col-sm-6 col-xl-3">
                                                                <div
                                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                                    <i class="fa fa-tasks fa-3x text-warning"></i>
                                                                    <div class="ms-3 text-end">
                                                                        <p class="mb-2">Tasks đang chờ</p>
                                                                        <h6 class="mb-0">${supportPendingTasks != null ?
                                                                            supportPendingTasks : 0}</h6>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6 col-xl-3">
                                                                <div
                                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                                    <i
                                                                        class="fa fa-exclamation-circle fa-3x text-danger"></i>
                                                                    <div class="ms-3 text-end">
                                                                        <p class="mb-2">Tasks quá hạn</p>
                                                                        <h6 class="mb-0">${supportOverdueTasks != null ?
                                                                            supportOverdueTasks : 0}</h6>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6 col-xl-3">
                                                                <div
                                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                                    <i class="fa fa-envelope-open fa-3x text-info"></i>
                                                                    <div class="ms-3 text-end">
                                                                        <p class="mb-2">Tickets cần xử lý</p>
                                                                        <h6 class="mb-0">${supportOpenTickets != null ?
                                                                            supportOpenTickets : 0}</h6>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6 col-xl-3">
                                                                <div
                                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                                    <i
                                                                        class="fa fa-check-circle fa-3x text-success"></i>
                                                                    <div class="ms-3 text-end">
                                                                        <p class="mb-2">Tickets đã đóng</p>
                                                                        <h6 class="mb-0">${supportResolvedTickets !=
                                                                            null ? supportResolvedTickets : 0}</h6>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row g-4 mt-2">
                                                            <div class="col-12 text-center">
                                                                <a href="${pageContext.request.contextPath}/my-tasks"
                                                                    class="btn btn-outline-primary m-2"><i
                                                                        class="fa fa-tasks me-2"></i>Xem My Tasks</a>
                                                                <a href="${pageContext.request.contextPath}/tickets"
                                                                    class="btn btn-outline-info m-2"><i
                                                                        class="fa fa-ticket-alt me-2"></i>Xem
                                                                    Tickets</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- Support Dashboard End -->
                                                </c:when>
                                                
                                                <c:when test="${sessionScope.userRole == 'MANAGER'}">
                                                    <!-- Marketing Overview for Manager -->
                                                    <jsp:include page="/views/dashboard/manager-marketing-stats.jsp" />
                                                </c:when>

                                                <c:when test="${sessionScope.userRole == 'MARKETING'}">
                                                    <!-- Dedicated Dashboard for Marketing -->
                                                    <jsp:include page="/views/dashboard/marketing-dashboard.jsp" />
                                                </c:when>

                                                <c:otherwise>
                                                    <!-- Sale & Revenue Start -->
                                                    <div class="container-fluid pt-4 px-4">
                                                        <div class="row g-4">
                                                            <div class="col-sm-6 col-xl-3">
                                                                <div
                                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                                    <i class="fa fa-chart-line fa-3x text-primary"></i>
                                                                    <div class="ms-3">
                                                                        <p class="mb-2">Doanh số hôm nay</p>
                                                                        <h6 class="mb-0">$1234</h6>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6 col-xl-3">
                                                                <div
                                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                                    <i class="fa fa-chart-bar fa-3x text-primary"></i>
                                                                    <div class="ms-3">
                                                                        <p class="mb-2">Tổng doanh số</p>
                                                                        <h6 class="mb-0">$1234</h6>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6 col-xl-3">
                                                                <div
                                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                                    <i class="fa fa-users fa-3x text-primary"></i>
                                                                    <div class="ms-3">
                                                                        <p class="mb-2">Khách hàng mới</p>
                                                                        <h6 class="mb-0">45</h6>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6 col-xl-3">
                                                                <div
                                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                                    <i class="fa fa-handshake fa-3x text-primary"></i>
                                                                    <div class="ms-3">
                                                                        <p class="mb-2">Deals đang mở</p>
                                                                        <h6 class="mb-0">12</h6>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- Sale & Revenue End -->

                                                    <!-- Charts Section -->
                                                    <div class="container-fluid pt-4 px-4">
                                                        <div class="row g-4">
                                                            <div class="col-sm-12 col-xl-6">
                                                                <div class="bg-light text-center rounded p-4">
                                                                    <div
                                                                        class="d-flex align-items-center justify-content-between mb-4">
                                                                        <h6 class="mb-0">Doanh số theo tháng</h6>
                                                                        <a href="">Xem tất cả</a>
                                                                    </div>
                                                                    <canvas id="worldwide-sales"></canvas>
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-12 col-xl-6">
                                                                <div class="bg-light text-center rounded p-4">
                                                                    <div
                                                                        class="d-flex align-items-center justify-content-between mb-4">
                                                                        <h6 class="mb-0">Leads theo nguồn</h6>
                                                                        <a href="">Xem tất cả</a>
                                                                    </div>
                                                                    <canvas id="salse-revenue"></canvas>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- ============================================== -->
                                            <!-- ======= KẾT THÚC NỘI DUNG RIÊNG ============== -->
                                            <!-- ============================================== -->

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

                            <!-- Inline script để đảm bảo ẩn spinner -->
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