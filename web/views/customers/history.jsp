<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <% request.setAttribute("currentPage", "customers" ); %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>Lịch Sử Khách Hàng - CRM System</title>
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
                                                    <h4 class="mb-0">Lịch sử tương tác: ${customer.companyName}</h4>
                                                    <a href="${pageContext.request.contextPath}/customers?action=details&id=${customer.id}"
                                                        class="btn btn-secondary"><i
                                                            class="fa fa-arrow-left me-2"></i>Trở lại Chi tiết</a>
                                                </div>

                                                <div class="row g-4">
                                                    <!-- Tickets History -->
                                                    <div class="col-sm-12 col-xl-6">
                                                        <div class="bg-light rounded h-100 p-4">
                                                            <h6 class="mb-4">Hỗ trợ (Tickets)</h6>
                                                            <div class="alert alert-info border-0 rounded">
                                                                <i class="fa fa-info-circle me-2"></i>Chưa có dữ liệu
                                                                Tickets cho khách hàng này.
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Opportunities History -->
                                                    <div class="col-sm-12 col-xl-6">
                                                        <div class="bg-light rounded h-100 p-4">
                                                            <h6 class="mb-4">Cơ hội (Opportunities)</h6>
                                                            <div class="alert alert-warning border-0 rounded">
                                                                <i class="fa fa-info-circle me-2"></i>Chưa có dữ liệu Cơ
                                                                hội cho khách hàng này.
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Contracts / Quotes -->
                                                    <div class="col-sm-12">
                                                        <div class="bg-light rounded h-100 p-4">
                                                            <h6 class="mb-4">Hợp đồng & Báo giá</h6>
                                                            <div class="alert alert-success border-0 rounded">
                                                                <i class="fa fa-info-circle me-2"></i>Chưa có dữ liệu
                                                                Hợp đồng/Báo giá cho khách hàng này.
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
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