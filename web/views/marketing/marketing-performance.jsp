<%-- marketing-performance.jsp - Thành quả Chiến dịch Marketing --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <title>Thành quả Chiến dịch - CRM System</title>
    <%@ include file="/includes/head.jsp" %>
    <style>
        .stat-card {
            border-radius: 0.75rem;
            padding: 1.25rem;
            color: #fff;
            transition: transform 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-3px);
        }

        .stat-card .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
        }

        .stat-card .stat-label {
            font-size: 1rem;
            opacity: 0.9;
        }

        .stat-card-campaigns {
            background: linear-gradient(135deg, #6366f1, #818cf8);
        }

        .stat-card-leads {
            background: linear-gradient(135deg, #3b82f6, #60a5fa);
        }

        .export-btn {
            background: linear-gradient(135deg, #059669, #10b981);
            border: none;
            color: white;
            padding: 0.5rem 1.25rem;
            border-radius: 0.5rem;
            font-weight: 600;
            transition: all 0.2s;
        }

        .export-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
            color: white;
        }
    </style>
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

            <!-- Marketing Performance Content -->
            <div class="container-fluid pt-4 px-4">

                <!-- Page Header -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center">
                            <h3 class="mb-0"><i class="fa fa-chart-pie me-2"></i>Thành quả Chiến dịch</h3>
                            <button class="export-btn" onclick="exportCSV()">
                                <i class="fa fa-file-export me-1"></i>Export CSV
                            </button>
                        </div>
                        <p class="text-muted mt-1 mb-0">Báo cáo phễu chuyển đổi của các chiến dịch bạn tham gia</p>
                    </div>
                </div>

                <!-- Stat Cards -->
                <div class="row mb-4 g-4">
                    <div class="col-md-6">
                        <div class="stat-card stat-card-campaigns">
                            <div class="stat-label"><i class="fa fa-bullhorn me-1"></i>Tổng Chiến dịch</div>
                            <div class="stat-number">${campaignCount}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="stat-card stat-card-leads">
                            <div class="stat-label"><i class="fa fa-user-plus me-1"></i>Tổng Leads</div>
                            <div class="stat-number">${totalLeads}</div>
                        </div>
                    </div>
                </div>

                <!-- Performance Table -->
                <div class="row">
                    <div class="col-12">
                        <div class="bg-light rounded p-4">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle" id="performanceTable">
                                    <thead>
                                        <tr>
                                            <th style="width:100px">ID</th>
                                            <th>Chiến dịch</th>
                                            <th>Trạng thái</th>
                                            <th class="text-center">Số lượng Leads</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty performanceList}">
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted py-5">
                                                        <i class="fa fa-chart-pie fa-3x mb-3 d-block"></i>
                                                        Chưa có dữ liệu chiến dịch.
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="perf" items="${performanceList}">
                                                    <tr>
                                                        <td><strong>#${perf.campaignId}</strong></td>
                                                        <td><span class="fw-bold">${perf.campaignName}</span></td>
                                                        <td><span class="badge bg-${perf.statusBadgeClass}">${perf.statusDisplayName}</span></td>
                                                        <td class="text-center"><span class="fw-bold text-primary">${perf.totalLeads}</span></td>
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
                                    <ul class="pagination justify-content-center mb-0">
                                        <li class="page-item ${currentPageNum == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPageNum - 1}" tabindex="-1">
                                                <i class="fa fa-angle-left"></i>
                                            </a>
                                        </li>
                                        <c:forEach var="i" begin="1" end="${totalPages}">
                                            <c:choose>
                                                <c:when test="${i <= 3 || i > totalPages - 2 || (i >= currentPageNum - 1 && i <= currentPageNum + 1)}">
                                                    <li class="page-item ${currentPageNum == i ? 'active' : ''}">
                                                        <a class="page-link" href="?page=${i}">${i}</a>
                                                    </li>
                                                </c:when>
                                                <c:when test="${i == 4 || i == totalPages - 2}">
                                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                        <li class="page-item ${currentPageNum == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPageNum + 1}">
                                                <i class="fa fa-angle-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                                <div class="text-center mt-2">
                                    <small class="text-muted">Trang ${currentPageNum} / ${totalPages} (Tổng số ${totalRecords} chiến dịch)</small>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Hidden table for Exporting all data -->
                <div style="display:none">
                    <table id="fullPerformanceTable">
                        <tbody>
                            <c:forEach var="perf" items="${performanceList}">
                                <tr>
                                    <td>${perf.campaignId}</td>
                                    <td>${perf.campaignName}</td>
                                    <td>${perf.statusDisplayName}</td>
                                    <td>${perf.totalLeads}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- Include Footer --%>
            <%@ include file="/includes/footer.jsp" %>
        </div>
        <!-- Content End -->

        <!-- Back to Top -->
        <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>
    </div>

    <%-- Include Scripts --%>
    <%@ include file="/includes/scripts.jsp" %>

    <script>
        function exportCSV() {
            var table = document.getElementById('fullPerformanceTable');
            if (!table) return;

            var rows = table.querySelectorAll('tr');
            var csvContent = '\uFEFF'; // BOM for UTF-8

            // Header
            csvContent += 'ID,Chiến dịch,Trạng thái,Leads\n';

            // Data rows
            for (var i = 0; i < rows.length; i++) {
                var cells = rows[i].querySelectorAll('td');
                if (cells.length < 4) continue;
                
                var id = cells[0].textContent.trim();
                var name = '"' + cells[1].textContent.trim().replace(/"/g, '""') + '"';
                var status = cells[2].textContent.trim();
                var leads = cells[3].textContent.trim();

                csvContent += id + ',' + name + ',' + status + ',' + leads + '\n';
            }

            // Create download
            var blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            var link = document.createElement('a');
            var url = URL.createObjectURL(blob);
            link.setAttribute('href', url);
            link.setAttribute('download', 'campaign_performance_' + new Date().toISOString().slice(0, 10) + '.csv');
            link.style.display = 'none';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            URL.revokeObjectURL(url);
        }
    </script>
</body>

</html>