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
                                                    <!-- Sales Overview for Manager -->
                                                    <jsp:include page="/views/dashboard/sale_dashboard.jsp" />
                                                </c:when>

                                                <c:when test="${sessionScope.userRole == 'MARKETING'}">
                                                    <!-- Dedicated Dashboard for Marketing -->
                                                    <jsp:include page="/views/dashboard/marketing-dashboard.jsp" />
                                                </c:when>

                                                <c:when test="${sessionScope.userRole == 'SALE'}">
                                                    <!-- Dedicated Dashboard for Sale -->
                                                    <jsp:include page="/views/dashboard/sale_dashboard.jsp" />
                                                </c:when>

                                                <c:otherwise>
                                                    <div class="container-fluid pt-4 px-4 text-center">
                                                        <div class="alert alert-info">
                                                            Chào mừng bạn, <strong>${sessionScope.fullName}</strong>.
                                                            Vui lòng chọn một chức năng từ menu bên trái để bắt đầu.
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