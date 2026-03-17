<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <div class="container-fluid pt-4 px-4">
                <div class="row g-4">
                    <!-- Revenue Today -->
                    <div class="col-sm-6 col-xl-3">
                        <div
                            class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-primary border-4">
                            <i class="fa fa-chart-line fa-3x text-primary"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2">Doanh số hôm nay</p>
                                <h4 class="mb-0">
                                    <fmt:formatNumber value="${salesStats.revenueToday}" type="currency"
                                        currencySymbol="$" />
                                </h4>
                            </div>
                        </div>
                    </div>
                    <!-- Total Revenue -->
                    <div class="col-sm-6 col-xl-3">
                        <div
                            class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-success border-4">
                            <i class="fa fa-chart-bar fa-3x text-success"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2">Tổng doanh số</p>
                                <h4 class="mb-0">
                                    <fmt:formatNumber value="${salesStats.totalRevenue}" type="currency"
                                        currencySymbol="$" />
                                </h4>
                            </div>
                        </div>
                    </div>
                    <!-- New Customers -->
                    <div class="col-sm-6 col-xl-3">
                        <div
                            class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-info border-4">
                            <i class="fa fa-users fa-3x text-info"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2">Khách hàng mới (Tháng này)</p>
                                <h4 class="mb-0">${salesStats.newCustomersCount}</h4>
                            </div>
                        </div>
                    </div>
                    <!-- Open Deals -->
                    <div class="col-sm-6 col-xl-3">
                        <div
                            class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-warning border-4">
                            <i class="fa fa-handshake fa-3x text-warning"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2">Deals đang mở</p>
                                <h4 class="mb-0">${salesStats.openDealsCount}</h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="container-fluid pt-4 px-4">
                <div class="row g-4">
                    <div class="col-sm-12 col-xl-6">
                        <div class="bg-light text-center rounded p-4 shadow-sm">
                            <div class="d-flex align-items-center justify-content-between mb-4">
                                <h6 class="mb-0">Doanh số 6 tháng gần nhất</h6>
                                <a href="${pageContext.request.contextPath}/sales/opportunities">Chi tiết</a>
                            </div>
                            <canvas id="sales-chart-canvas"></canvas>
                        </div>
                    </div>
                    <div class="col-sm-12 col-xl-6">
                        <div class="bg-light text-center rounded p-4 shadow-sm">
                            <div class="d-flex align-items-center justify-content-between mb-4">
                                <h6 class="mb-0">Cơ cấu nguồn Lead</h6>
                                <a href="${pageContext.request.contextPath}/sales/leads">Quản lý Lead</a>
                            </div>
                            <canvas id="leads-source-canvas"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Opportunities Table -->
            <div class="container-fluid pt-4 px-4">
                <div class="bg-light text-center rounded p-4 shadow-sm">
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <h6 class="mb-0">Các cơ hội mới nhất (Recent Opportunities)</h6>
                        <a href="${pageContext.request.contextPath}/sales-pipeline">Xem tất cả Pipeline</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table text-start align-middle table-bordered table-hover mb-0">
                            <thead>
                                <tr class="text-dark">
                                    <th scope="col">Tên Cơ hội</th>
                                    <th scope="col">Giai đoạn</th>
                                    <th scope="col">Giá trị Dự kiến</th>
                                    <th scope="col">Ngày tạo</th>
                                    <th scope="col">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="op" items="${salesStats.recentOpportunities}">
                                    <tr>
                                        <td>${op.name}</td>
                                        <td>
                                            <span
                                                class="badge ${op.stage == 'Won' ? 'bg-success' : (op.stage == 'Lost' ? 'bg-danger' : 'bg-primary')}">
                                                ${op.stage}
                                            </span>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${op.expectedValue}" type="currency"
                                                currencySymbol="$" />
                                        </td>
                                        <td>${op.createdAt}</td>
                                        <td><a class="btn btn-sm btn-primary"
                                                href="${pageContext.request.contextPath}/sales-pipeline">Xem</a></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty salesStats.recentOpportunities}">
                                    <tr>
                                        <td colspan="5" class="text-center">Chưa có cơ hội nào gần đây.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Script để vẽ biểu đồ -->
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    // Dữ liệu doanh số tháng
                    const monthlyLabels = [];
                    const monthlyData = [];
                    <c:forEach var="entry" items="${salesStats.monthlySales}">
                        monthlyLabels.push("${entry.key}");
                        monthlyData.push(${entry.value});
                    </c:forEach>

                    // Dữ liệu nguồn Lead
                    const sourceLabels = [];
                    const sourceData = [];
                    <c:forEach var="entry" items="${salesStats.leadsBySource}">
                        sourceLabels.push("${entry.key}");
                        sourceData.push(${entry.value});
                    </c:forEach>

                    // Vẽ biểu đồ Doanh số (Bar Chart)
                    new Chart(document.getElementById("sales-chart-canvas"), {
                        type: 'bar',
                        data: {
                            labels: monthlyLabels.length ? monthlyLabels : ['No Data'],
                            datasets: [{
                                label: "Doanh số ($)",
                                data: monthlyData.length ? monthlyData : [0],
                                backgroundColor: "rgba(0, 156, 255, .7)"
                            }]
                        },
                        options: { responsive: true }
                    });

                    // Vẽ biểu đồ Nguồn Lead (Pie/Doughnut Chart)
                    new Chart(document.getElementById("leads-source-canvas"), {
                        type: 'doughnut',
                        data: {
                            labels: sourceLabels.length ? sourceLabels : ['No Leads'],
                            datasets: [{
                                backgroundColor: [
                                    "rgba(0, 156, 255, .7)",
                                    "rgba(0, 156, 255, .6)",
                                    "rgba(0, 156, 255, .5)",
                                    "rgba(0, 156, 255, .4)",
                                    "rgba(0, 156, 255, .3)"
                                ],
                                data: sourceData.length ? sourceData : [0]
                            }]
                        },
                        options: { responsive: true }
                    });
                });
            </script>