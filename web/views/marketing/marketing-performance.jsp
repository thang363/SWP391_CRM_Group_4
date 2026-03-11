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
                                font-size: 2rem;
                                font-weight: 700;
                            }

                            .stat-card .stat-label {
                                font-size: 0.85rem;
                                opacity: 0.9;
                            }

                            .stat-card-campaigns {
                                background: linear-gradient(135deg, #6366f1, #818cf8);
                            }

                            .stat-card-leads {
                                background: linear-gradient(135deg, #3b82f6, #60a5fa);
                            }

                            .stat-card-opportunities {
                                background: linear-gradient(135deg, #f59e0b, #fbbf24);
                            }

                            .stat-card-customers {
                                background: linear-gradient(135deg, #10b981, #34d399);
                            }

                            .funnel-bar {
                                height: 8px;
                                border-radius: 4px;
                                background-color: #e9ecef;
                                overflow: hidden;
                            }

                            .funnel-bar .fill {
                                height: 100%;
                                border-radius: 4px;
                                transition: width 0.6s ease;
                            }

                            .fill-opportunity {
                                background: linear-gradient(90deg, #f59e0b, #fbbf24);
                            }

                            .fill-customer {
                                background: linear-gradient(90deg, #10b981, #34d399);
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

                            .rate-badge {
                                font-size: 0.75rem;
                                padding: 0.2rem 0.5rem;
                                border-radius: 0.25rem;
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
                                                            <h3 class="mb-0"><i class="fa fa-chart-pie me-2"></i>Thành
                                                                quả
                                                                Chiến dịch</h3>
                                                            <button class="export-btn" onclick="exportCSV()">
                                                                <i class="fa fa-file-export me-1"></i>Export CSV
                                                            </button>
                                                        </div>
                                                        <p class="text-muted mt-1 mb-0">Báo cáo phễu chuyển đổi của
                                                            các chiến dịch bạn tham gia</p>
                                                    </div>
                                                </div>

                                                <!-- Stat Cards -->
                                                <div class="row mb-4 g-3">
                                                    <div class="col-md-3">
                                                        <div class="stat-card stat-card-campaigns">
                                                            <div class="stat-label"><i
                                                                    class="fa fa-bullhorn me-1"></i>Chiến dịch
                                                            </div>
                                                            <div class="stat-number">${campaignCount}</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="stat-card stat-card-leads">
                                                            <div class="stat-label"><i
                                                                    class="fa fa-user-plus me-1"></i>Tổng Leads
                                                            </div>
                                                            <div class="stat-number">${totalLeads}</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="stat-card stat-card-opportunities">
                                                            <div class="stat-label"><i
                                                                    class="fa fa-handshake me-1"></i>Opportunity
                                                            </div>
                                                            <div class="stat-number">${totalOpportunities}</div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="stat-card stat-card-customers">
                                                            <div class="stat-label"><i
                                                                    class="fa fa-user-check me-1"></i>Customer
                                                            </div>
                                                            <div class="stat-number">${totalCustomers}</div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Performance Table -->
                                                <div class="row">
                                                    <div class="col-12">
                                                        <div class="bg-light rounded p-4">
                                                            <div class="table-responsive">
                                                                <table class="table table-hover align-middle"
                                                                    id="performanceTable">
                                                                    <thead>
                                                                        <tr>
                                                                            <th style="width:60px">ID</th>
                                                                            <th>Chiến dịch</th>
                                                                            <th>Trạng thái</th>
                                                                            <th class="text-center">Leads</th>
                                                                            <th class="text-center">Opportunity
                                                                            </th>
                                                                            <th class="text-center">Customer</th>
                                                                            <th>Tỉ lệ chuyển đổi</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:choose>
                                                                            <c:when test="${empty performanceList}">
                                                                                <tr>
                                                                                    <td colspan="7"
                                                                                        class="text-center text-muted py-5">
                                                                                        <i
                                                                                            class="fa fa-chart-pie fa-3x mb-3 d-block"></i>
                                                                                        Chưa có dữ liệu. Hãy tạo
                                                                                        Landing Page cho chiến dịch
                                                                                        để xem thành quả.
                                                                                    </td>
                                                                                </tr>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:forEach var="perf"
                                                                                    items="${performanceList}">
                                                                                    <tr>
                                                                                        <td>
                                                                                            <strong>#${perf.campaignId}</strong>
                                                                                        </td>
                                                                                        <td>
                                                                                            <span
                                                                                                class="fw-bold">${perf.campaignName}</span>
                                                                                        </td>
                                                                                        <td>
                                                                                            <span
                                                                                                class="badge bg-${perf.statusBadgeClass}">${perf.statusDisplayName}</span>
                                                                                        </td>
                                                                                        <td class="text-center">
                                                                                            <span
                                                                                                class="fw-bold text-primary">${perf.totalLeads}</span>
                                                                                        </td>
                                                                                        <td class="text-center">
                                                                                            <span
                                                                                                class="fw-bold text-warning">${perf.convertedToOpportunity}</span>
                                                                                            <c:if
                                                                                                test="${perf.totalLeads > 0}">
                                                                                                <br>
                                                                                                <span
                                                                                                    class="rate-badge bg-warning bg-opacity-10 text-warning">
                                                                                                    <fmt:formatNumber
                                                                                                        value="${perf.leadToOpportunityRate}"
                                                                                                        maxFractionDigits="1" />
                                                                                                    %
                                                                                                </span>
                                                                                            </c:if>
                                                                                        </td>
                                                                                        <td class="text-center">
                                                                                            <span
                                                                                                class="fw-bold text-success">${perf.convertedToCustomer}</span>
                                                                                            <c:if
                                                                                                test="${perf.totalLeads > 0}">
                                                                                                <br>
                                                                                                <span
                                                                                                    class="rate-badge bg-success bg-opacity-10 text-success">
                                                                                                    <fmt:formatNumber
                                                                                                        value="${perf.leadToCustomerRate}"
                                                                                                        maxFractionDigits="1" />
                                                                                                    %
                                                                                                </span>
                                                                                            </c:if>
                                                                                        </td>
                                                                                        <td style="min-width:150px">
                                                                                            <div class="mb-1">
                                                                                                <small
                                                                                                    class="text-muted">Lead
                                                                                                    →
                                                                                                    Opportunity</small>
                                                                                                <div class="funnel-bar">
                                                                                                    <c:set var="oppRate"
                                                                                                        value="${perf.leadToOpportunityRate}" />
                                                                                                    <div class="fill fill-opportunity"
                                                                                                        style="width: ${oppRate}%">
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div>
                                                                                                <small
                                                                                                    class="text-muted">Lead
                                                                                                    →
                                                                                                    Customer</small>
                                                                                                <div class="funnel-bar">
                                                                                                    <c:set
                                                                                                        var="custRate"
                                                                                                        value="${perf.leadToCustomerRate}" />
                                                                                                    <div class="fill fill-customer"
                                                                                                        style="width: ${custRate}%">
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:forEach>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

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
                                function exportCSV() {
                                    var table = document.getElementById('performanceTable');
                                    if (!table) return;

                                    var rows = table.querySelectorAll('tr');
                                    var csvContent = '\uFEFF'; // BOM for UTF-8

                                    // Header
                                    csvContent += 'ID,Chiến dịch,Trạng thái,Leads,Opportunity,Customer,Tỉ lệ Lead→Opp (%),Tỉ lệ Lead→Cust (%)\n';

                                    // Data rows (skip header row)
                                    for (var i = 1; i < rows.length; i++) {
                                        var cells = rows[i].querySelectorAll('td');
                                        if (cells.length < 7) continue; // Skip empty row

                                        var id = cells[0].textContent.trim().replace('#', '');
                                        var name = '"' + cells[1].textContent.trim().replace(/"/g, '""') + '"';
                                        var status = cells[2].textContent.trim();
                                        var leads = cells[3].textContent.trim();
                                        var opps = cells[4].textContent.trim().split('\n')[0].trim();
                                        var custs = cells[5].textContent.trim().split('\n')[0].trim();

                                        var leadsNum = parseInt(leads) || 0;
                                        var oppsNum = parseInt(opps) || 0;
                                        var custsNum = parseInt(custs) || 0;
                                        var oppRate = leadsNum > 0 ? (oppsNum * 100.0 / leadsNum).toFixed(1) : '0.0';
                                        var custRate = leadsNum > 0 ? (custsNum * 100.0 / leadsNum).toFixed(1) : '0.0';

                                        csvContent += id + ',' + name + ',' + status + ',' + leads + ',' + oppsNum + ',' + custsNum + ',' + oppRate + ',' + custRate + '\n';
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