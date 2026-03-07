<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
            <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
                <%-- Set currentPage for sidebar highlight --%>
                    <% request.setAttribute("currentPage", "sales-dashboard" ); %>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <title>Sales Dashboard - CRM System</title>
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

                                                    <!-- Sale & Revenue Start -->
                                                    <div class="container-fluid pt-4 px-4">
                                                        <div
                                                            class="d-flex justify-content-between align-items-center mb-4">
                                                            <h3 class="mb-0"><i
                                                                    class="fa fa-tachometer-alt me-2"></i>Sales
                                                                Dashboard</h3>
                                                            <div>
                                                                <button class="btn btn-sm btn-outline-primary"><i
                                                                        class="fa fa-download me-2"></i>Export
                                                                    Report</button>
                                                            </div>
                                                        </div>

                                                        <div class="row g-4">
                                                            <div class="col-sm-6 col-xl-3">
                                                                <div
                                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                                    <i class="fa fa-users fa-3x text-primary"></i>
                                                                    <div class="ms-3">
                                                                        <p class="mb-2">New Leads</p>
                                                                        <h6 class="mb-0">124</h6>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6 col-xl-3">
                                                                <div
                                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                                    <i class="fa fa-handshake fa-3x text-primary"></i>
                                                                    <div class="ms-3">
                                                                        <p class="mb-2">Open Deals</p>
                                                                        <h6 class="mb-0">45</h6>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6 col-xl-3">
                                                                <div
                                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                                    <i class="fa fa-chart-line fa-3x text-primary"></i>
                                                                    <div class="ms-3">
                                                                        <p class="mb-2">Win Rate</p>
                                                                        <h6 class="mb-0">68%</h6>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6 col-xl-3">
                                                                <div
                                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                                    <i class="fa fa-dollar-sign fa-3x text-primary"></i>
                                                                    <div class="ms-3">
                                                                        <p class="mb-2">Revenue (MTD)</p>
                                                                        <h6 class="mb-0">$12,340</h6>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- Sale & Revenue End -->

                                                    <!-- Sales Chart Start -->
                                                    <div class="container-fluid pt-4 px-4">
                                                        <div class="row g-4">
                                                            <div class="col-sm-12 col-xl-8">
                                                                <div class="bg-light text-center rounded p-4 h-100">
                                                                    <div
                                                                        class="d-flex align-items-center justify-content-between mb-4">
                                                                        <h6 class="mb-0">Sales Revenue</h6>
                                                                        <a href="">Show All</a>
                                                                    </div>
                                                                    <!-- Mocking a chart visual with CSS since actual chart.js might need config -->
                                                                    <canvas id="sales-revenue-chart"
                                                                        style="min-height: 250px;"></canvas>
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-12 col-xl-4">
                                                                <div class="bg-light text-center rounded p-4 h-100">
                                                                    <div
                                                                        class="d-flex align-items-center justify-content-between mb-4">
                                                                        <h6 class="mb-0">Pipeline Funnel</h6>
                                                                        <a href="">Details</a>
                                                                    </div>
                                                                    <canvas id="pipeline-funnel-chart"
                                                                        style="min-height: 250px;"></canvas>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- Sales Chart End -->

                                                    <!-- Recent Activities Table -->
                                                    <div class="container-fluid pt-4 px-4">
                                                        <div class="bg-light text-center rounded p-4">
                                                            <div
                                                                class="d-flex align-items-center justify-content-between mb-4">
                                                                <h6 class="mb-0">Recent Deals Closed</h6>
                                                                <a
                                                                    href="${pageContext.request.contextPath}/opportunity-list">View
                                                                    All Deals</a>
                                                            </div>
                                                            <div class="table-responsive">
                                                                <table
                                                                    class="table text-start align-middle table-bordered table-hover mb-0">
                                                                    <thead>
                                                                        <tr class="text-dark">
                                                                            <th scope="col">Date</th>
                                                                            <th scope="col">Deal Name</th>
                                                                            <th scope="col">Customer</th>
                                                                            <th scope="col">Amount</th>
                                                                            <th scope="col">Status</th>
                                                                            <th scope="col">Action</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <tr>
                                                                            <td>06 Mar 2026</td>
                                                                            <td>Nâng cấp gói Enterprise</td>
                                                                            <td>FPT Software</td>
                                                                            <td>$5,200</td>
                                                                            <td><span class="badge bg-success">Closed
                                                                                    Won</span></td>
                                                                            <td><a class="btn btn-sm btn-primary"
                                                                                    href="">Detail</a></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>05 Mar 2026</td>
                                                                            <td>Gia hạn gói Standard 1 năm</td>
                                                                            <td>Viettel Media</td>
                                                                            <td>$1,200</td>
                                                                            <td><span class="badge bg-success">Closed
                                                                                    Won</span></td>
                                                                            <td><a class="btn btn-sm btn-primary"
                                                                                    href="">Detail</a></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>04 Mar 2026</td>
                                                                            <td>Thiết kế Web Ecom mới</td>
                                                                            <td>Tiki Corp</td>
                                                                            <td>$8,500</td>
                                                                            <td><span class="badge bg-danger">Closed
                                                                                    Lost</span></td>
                                                                            <td><a class="btn btn-sm btn-primary"
                                                                                    href="">Detail</a></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>02 Mar 2026</td>
                                                                            <td>Mua thêm 50 user license</td>
                                                                            <td>Vingroup</td>
                                                                            <td>$2,500</td>
                                                                            <td><span class="badge bg-success">Closed
                                                                                    Won</span></td>
                                                                            <td><a class="btn btn-sm btn-primary"
                                                                                    href="">Detail</a></td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- Recent Activities End -->

                                                    <!-- To Do List Start -->
                                                    <div class="container-fluid pt-4 px-4 pb-4">
                                                        <div class="row g-4">
                                                            <div class="col-sm-12 col-md-6 col-xl-6">
                                                                <div class="h-100 bg-light rounded p-4">
                                                                    <div
                                                                        class="d-flex align-items-center justify-content-between mb-4">
                                                                        <h6 class="mb-0">Upcoming Tasks</h6>
                                                                        <a href="">View All</a>
                                                                    </div>
                                                                    <div class="d-flex mb-2">
                                                                        <input class="form-control bg-transparent"
                                                                            type="text" placeholder="Enter task">
                                                                        <button type="button"
                                                                            class="btn btn-primary ms-2">Add</button>
                                                                    </div>
                                                                    <div
                                                                        class="d-flex align-items-center border-bottom py-2">
                                                                        <input class="form-check-input m-0"
                                                                            type="checkbox">
                                                                        <div class="w-100 ms-3">
                                                                            <div
                                                                                class="d-flex w-100 align-items-center justify-content-between">
                                                                                <span>Gửi báo giá cho ZaloPay</span>
                                                                                <button class="btn btn-sm"><i
                                                                                        class="fa fa-times"></i></button>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div
                                                                        class="d-flex align-items-center border-bottom py-2">
                                                                        <input class="form-check-input m-0"
                                                                            type="checkbox" checked>
                                                                        <div class="w-100 ms-3">
                                                                            <div
                                                                                class="d-flex w-100 align-items-center justify-content-between">
                                                                                <span><del>Gọi điện chăm sóc KH cũ
                                                                                        Viettel</del></span>
                                                                                <button class="btn btn-sm"><i
                                                                                        class="fa fa-times"></i></button>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div
                                                                        class="d-flex align-items-center border-bottom py-2">
                                                                        <input class="form-check-input m-0"
                                                                            type="checkbox">
                                                                        <div class="w-100 ms-3">
                                                                            <div
                                                                                class="d-flex w-100 align-items-center justify-content-between">
                                                                                <span>Chuẩn bị tài liệu thuyết
                                                                                    trình</span>
                                                                                <button class="btn btn-sm"><i
                                                                                        class="fa fa-times"></i></button>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- To Do List End -->

                                                    <%@ include file="/includes/footer.jsp" %>
                                        </div>
                                        <!-- Content End -->

                                        <!-- Back to Top -->
                                        <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                                class="bi bi-arrow-up"></i></a>
                            </div>

                            <%-- Include Scripts --%>
                                <%@ include file="/includes/scripts.jsp" %>

                                    <%-- Mocking Chart initialization --%>
                                        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                                        <script>
                                            document.addEventListener('DOMContentLoaded', function () {
                                                var spinner = document.getElementById('spinner');
                                                if (spinner) {
                                                    spinner.classList.remove('show');
                                                }

                                                // Sales Revenue Chart
                                                var ctx1 = document.getElementById("sales-revenue-chart").getContext("2d");
                                                if (ctx1) {
                                                    new Chart(ctx1, {
                                                        type: "bar",
                                                        data: {
                                                            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"],
                                                            datasets: [{
                                                                label: "Revenue ($)",
                                                                data: [12000, 19000, 15000, 22000, 18000, 25000, 30000],
                                                                backgroundColor: "rgba(0, 156, 255, .7)"
                                                            }]
                                                        },
                                                        options: {
                                                            responsive: true
                                                        }
                                                    });
                                                }

                                                // Pipeline Funnel Chart (using Doughnut as mock)
                                                var ctx2 = document.getElementById("pipeline-funnel-chart").getContext("2d");
                                                if (ctx2) {
                                                    new Chart(ctx2, {
                                                        type: "doughnut",
                                                        data: {
                                                            labels: ["New/Qualify", "Proposal", "Negotiation", "Closed Won"],
                                                            datasets: [{
                                                                backgroundColor: [
                                                                    "rgba(0, 156, 255, .7)",
                                                                    "rgba(0, 156, 255, .5)",
                                                                    "rgba(0, 156, 255, .3)",
                                                                    "rgba(25, 135, 84, .7)"
                                                                ],
                                                                data: [45, 20, 10, 25]
                                                            }]
                                                        },
                                                        options: {
                                                            responsive: true
                                                        }
                                                    });
                                                }
                                            });
                                        </script>
                        </body>

                        </html>