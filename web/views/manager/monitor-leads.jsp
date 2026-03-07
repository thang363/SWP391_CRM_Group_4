<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <title>Monitor Leads - CRM</title>
                <meta content="width=device-width, initial-scale=1.0" name="viewport">
                <%@ include file="/includes/head.jsp" %>
                    <style>
                        .timeline-item {
                            position: relative;
                            padding-left: 20px;
                            margin-bottom: 20px;
                        }

                        .timeline-item::before {
                            content: '';
                            position: absolute;
                            left: 0;
                            top: 5px;
                            bottom: -25px;
                            width: 2px;
                            background-color: #e9ecef;
                        }

                        .timeline-item:last-child::before {
                            display: none;
                        }

                        .timeline-icon {
                            position: absolute;
                            left: -8px;
                            top: 3px;
                            width: 18px;
                            height: 18px;
                            border-radius: 50%;
                            background-color: #009CFF;
                            border: 3px solid #fff;
                        }

                        .score-badge {
                            font-size: 0.9em;
                            padding: 5px 10px;
                        }
                    </style>
            </head>

            <body>
                <div class="container-xxl position-relative bg-white d-flex p-0">
                    <%@ include file="/includes/sidebar.jsp" %>

                        <!-- Content Start -->
                        <div class="content">
                            <%@ include file="/includes/topbar.jsp" %>

                                <!-- Monitor Leads Area -->
                                <div class="container-fluid pt-4 px-4">

                                    <div class="d-flex align-items-center justify-content-between mb-4">
                                        <h4 class="mb-0 text-primary"><i class="fa fa-chart-pie me-2"></i>Monitor Leads
                                        </h4>
                                        <form method="get"
                                            action="${pageContext.request.contextPath}/marketing/monitor-leads"
                                            class="d-flex" id="filterForm">
                                            <select name="campaignId" class="form-select border-primary"
                                                onchange="document.getElementById('filterForm').submit()">
                                                <option value="">Tất cả Chiến dịch</option>
                                                <c:forEach var="camp" items="${campaigns}">
                                                    <option value="${camp.id}" ${selectedCampaignId==camp.id
                                                        ? 'selected' : '' }>
                                                        ${camp.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </form>
                                    </div>

                                    <%-- Display success/error messages --%>
                                        <c:if test="${not empty sessionScope.successMsg}">
                                            <div class="alert alert-success alert-dismissible fade show text-start"
                                                role="alert">
                                                ${sessionScope.successMsg}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                            <c:remove var="successMsg" scope="session" />
                                        </c:if>
                                        <c:if test="${not empty sessionScope.errorMsg}">
                                            <div class="alert alert-danger alert-dismissible fade show text-start"
                                                role="alert">
                                                ${sessionScope.errorMsg}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                            <c:remove var="errorMsg" scope="session" />
                                        </c:if>

                                        <!-- 1. KPI Cards -->
                                        <div class="row g-4 mb-4">
                                            <div class="col-sm-6 col-xl-3">
                                                <div
                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-primary border-4">
                                                    <i class="fa fa-users fa-3x text-primary"></i>
                                                    <div class="ms-3 text-end">
                                                        <p class="mb-2 text-muted fw-bold">Tổng Leads</p>
                                                        <h4 class="mb-0">${kpis.totalLeads}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-sm-6 col-xl-3">
                                                <div
                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-danger border-4">
                                                    <i class="fa fa-fire fa-3x text-danger"></i>
                                                    <div class="ms-3 text-end">
                                                        <p class="mb-2 text-muted fw-bold">Hot Leads 🔥</p>
                                                        <h4 class="mb-0">${kpis.hotLeads}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-sm-6 col-xl-3">
                                                <div
                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-warning border-4">
                                                    <i class="fa fa-user-plus fa-3x text-warning"></i>
                                                    <div class="ms-3 text-end">
                                                        <p class="mb-2 text-muted fw-bold">Unassigned</p>
                                                        <h4 class="mb-0">${kpis.unassignedLeads}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-sm-6 col-xl-3">
                                                <div
                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-success border-4">
                                                    <i class="fa fa-chart-line fa-3x text-success"></i>
                                                    <div class="ms-3 text-end">
                                                        <p class="mb-2 text-muted fw-bold">Avg. Score</p>
                                                        <h4 class="mb-0">
                                                            <fmt:formatNumber type="number" maxFractionDigits="1"
                                                                value="${kpis.avgScore}" />
                                                        </h4>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row g-4 mb-4">
                                            <!-- 2. Bảng phân công Hot Leads -->
                                            <div class="col-sm-12 col-xl-8">
                                                <div class="bg-white text-center rounded p-4 h-100 shadow-sm">
                                                    <div class="d-flex align-items-center justify-content-between mb-4">
                                                        <h6 class="mb-0 fw-bold text-dark"><i
                                                                class="fa fa-fire text-danger me-2"></i>Hot Leads Need
                                                            Assignment</h6>
                                                        <span class="text-muted"><small>Ưu tiên xử lý từ trên xuống
                                                                dưới</small></span>
                                                    </div>
                                                    <div class="table-responsive">
                                                        <table class="table text-start align-middle table-hover mb-0">
                                                            <thead class="table-light">
                                                                <tr class="text-dark">
                                                                    <th scope="col">Khách hàng</th>
                                                                    <th scope="col" class="text-center">Điểm (Score)
                                                                    </th>
                                                                    <th scope="col">Phone</th>
                                                                    <th scope="col" style="min-width: 180px;">Giao cho
                                                                        (Sales)
                                                                    </th>
                                                                    <th scope="col">Hành động</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:choose>
                                                                    <c:when test="${empty hotLeads}">
                                                                        <tr>
                                                                            <td colspan="5" class="text-center py-4">Tất
                                                                                cả Hot
                                                                                Leads đã được phân công! Hoặc không có
                                                                                dữ liệu.
                                                                            </td>
                                                                        </tr>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:forEach var="lead" items="${hotLeads}">
                                                                            <tr>
                                                                                <td>
                                                                                    <strong>${lead.fullName}</strong><br>
                                                                                    <small
                                                                                        class="text-muted">${lead.email}</small>
                                                                                </td>
                                                                                <td class="text-center">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${lead.currentScore >= 50}">
                                                                                            <span
                                                                                                class="badge bg-danger rounded-pill score-badge px-3 py-2"><i
                                                                                                    class="fa fa-fire me-1"></i>
                                                                                                ${lead.currentScore}
                                                                                                đ</span>
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${lead.currentScore >= 20}">
                                                                                            <span
                                                                                                class="badge bg-warning text-dark rounded-pill score-badge px-3 py-2">${lead.currentScore}
                                                                                                đ</span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span
                                                                                                class="badge bg-secondary rounded-pill score-badge px-3 py-2">${lead.currentScore}
                                                                                                đ</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </td>
                                                                                <td>${lead.phone != null &&
                                                                                    !lead.phone.isEmpty() ? lead.phone :
                                                                                    '-'}
                                                                                </td>

                                                                                <td class="pe-3">
                                                                                    <form
                                                                                        action="${pageContext.request.contextPath}/marketing/monitor-leads"
                                                                                        method="post"
                                                                                        class="d-flex w-100 m-0">
                                                                                        <input type="hidden"
                                                                                            name="action"
                                                                                            value="assign">
                                                                                        <input type="hidden"
                                                                                            name="leadId"
                                                                                            value="${lead.id}">
                                                                                        <input type="hidden"
                                                                                            name="listCampaignId"
                                                                                            value="${selectedCampaignId}">

                                                                                        <div
                                                                                            class="input-group input-group-sm w-100">
                                                                                            <select name="salesId"
                                                                                                class="form-select"
                                                                                                required>
                                                                                                <option value="">-- Chọn
                                                                                                    Sales
                                                                                                    --</option>
                                                                                                <c:forEach var="sale"
                                                                                                    items="${salesUsers}">
                                                                                                    <option
                                                                                                        value="${sale.id}">
                                                                                                        ${sale.fullName}
                                                                                                    </option>
                                                                                                </c:forEach>
                                                                                            </select>
                                                                                            <button type="submit"
                                                                                                class="btn btn-primary"
                                                                                                title="Assign này">
                                                                                                <i
                                                                                                    class="fa fa-user-plus"></i>
                                                                                            </button>
                                                                                        </div>
                                                                                    </form>
                                                                                </td>
                                                                                <td>
                                                                                    <button
                                                                                        class="btn btn-sm btn-outline-info disabled"
                                                                                        title="Chi tiết lịch sử">
                                                                                        <i class="fa fa-eye"></i>
                                                                                    </button>
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

                                            <!-- 3. Luồng hoạt động (Activity Feed) -->
                                            <div class="col-sm-12 col-xl-4">
                                                <div class="bg-white rounded p-4 h-100 shadow-sm">
                                                    <div
                                                        class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                                                        <h6 class="mb-0 fw-bold text-dark"><i
                                                                class="fa fa-bolt text-warning me-2"></i>Tương tác gần
                                                            đây</h6>
                                                    </div>

                                                    <div class="timeline ps-2 pe-1"
                                                        style="max-height: 500px; overflow-y: auto;">
                                                        <c:choose>
                                                            <c:when test="${empty interactions}">
                                                                <p class="text-center text-muted">Chưa có tương tác nào
                                                                    được ghi
                                                                    nhận.</p>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach var="ix" items="${interactions}">
                                                                    <div class="timeline-item">
                                                                        <div class="timeline-icon"></div>
                                                                        <div
                                                                            class="d-flex w-100 justify-content-between mb-1">
                                                                            <h6 class="mb-0 text-dark fw-bold"
                                                                                style="font-size: 0.95rem;">
                                                                                ${ix.leadName}</h6>
                                                                            <small class="text-muted"
                                                                                style="font-size: 0.8rem;">
                                                                                <fmt:formatDate value="${ix.createdAt}"
                                                                                    pattern="dd/MM HH:mm" />
                                                                            </small>
                                                                        </div>
                                                                        <div class="mb-1">
                                                                            <c:choose>
                                                                                <c:when test="${ix.scoreChange > 0}">
                                                                                    <span
                                                                                        class="text-success fw-bold me-2">+${ix.scoreChange}đ</span>
                                                                                </c:when>
                                                                                <c:when test="${ix.scoreChange < 0}">
                                                                                    <span
                                                                                        class="text-danger fw-bold me-2">${ix.scoreChange}đ</span>
                                                                                </c:when>
                                                                            </c:choose>
                                                                            <span class="text-primary fw-bold"
                                                                                style="font-size: 0.85rem;">[${ix.activityName}]</span>
                                                                        </div>
                                                                        <p class="mb-0 text-muted"
                                                                            style="font-size: 0.85rem; line-height: 1.3;">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${ix.activityName == 'Email Click'}">
                                                                                    Đã nhấp vào liên kết theo dõi trong
                                                                                    email.
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    Hành động: ${ix.details}
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </p>
                                                                    </div>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>

                                </div>
                                <!-- Monitor Leads End -->
                                <%@ include file="/includes/footer.jsp" %>

                        </div>
                        <!-- Content End -->

                        <!-- Back to Top -->
                        <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                class="bi bi-arrow-up"></i></a>
                </div>

                <!-- Scripts -->
                <%@ include file="/includes/scripts.jsp" %>

            </body>

            </html>