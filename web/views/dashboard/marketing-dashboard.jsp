<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid pt-4 px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="mb-0"><i class="fa fa-rocket me-2 text-primary"></i>Marketing Dashboard</h3>
        <div class="text-muted">Nhân viên Marketing: <strong>${sessionScope.fullName}</strong></div>
    </div>

    <!-- KPI Row -->
    <div class="row g-4 mb-4">
        <div class="col-sm-6 col-xl-3">
            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-primary border-4">
                <i class="fa fa-calendar-check fa-3x text-primary"></i>
                <div class="ms-3 text-end">
                    <p class="mb-2">Submissions Hôm nay</p>
                    <h4 class="mb-0">${stats.submissionsToday}</h4>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-warning border-4">
                <i class="fa fa-clock fa-3x text-warning"></i>
                <div class="ms-3 text-end">
                    <p class="mb-2">Đang chờ xử lý</p>
                    <h4 class="mb-0">${stats.pendingSubmissions}</h4>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-success border-4">
                <i class="fa fa-file-code fa-3x text-success"></i>
                <div class="ms-3 text-end">
                    <p class="mb-2">LP Đang chạy</p>
                    <h4 class="mb-0">${stats.approvedLandingPages}</h4>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-danger border-4">
                <i class="fa fa-fire fa-3x text-danger"></i>
                <div class="ms-3 text-end">
                    <p class="mb-2">HOT Leads đã tạo</p>
                    <h4 class="mb-0">${stats.hotLeads}</h4>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Recent Submissions Table -->
        <div class="col-sm-12 col-xl-8">
            <div class="bg-light rounded p-4 h-100 shadow-sm">
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <h6 class="mb-0"><i class="fa fa-list-ul me-2"></i>Submissions mới nhất cần xử lý</h6>
                    <a href="${pageContext.request.contextPath}/marketing/submissions" class="btn btn-sm btn-outline-primary">Xem tất cả</a>
                </div>
                <div class="table-responsive">
                    <table class="table text-start align-middle table-bordered table-hover mb-0">
                        <thead>
                            <tr class="text-dark">
                                <th scope="col">Ngày đăng ký</th>
                                <th scope="col">Khách hàng</th>
                                <th scope="col">Landing Page</th>
                                <th scope="col">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="sub" items="${stats.recentSubmissions}">
                                <tr>
                                    <td><fmt:formatDate value="${sub.submittedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>
                                        <div class="fw-bold">${sub.fullName}</div>
                                        <small class="text-muted"><i class="fa fa-phone me-1"></i>${sub.phone}</small>
                                    </td>
                                    <td><span class="badge bg-info text-dark">${sub.landingPageName}</span></td>
                                    <td>
                                        <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/marketing/submissions?id=${sub.id}">
                                            <i class="fa fa-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty stats.recentSubmissions}">
                                <tr>
                                    <td colspan="4" class="text-center py-4 text-muted italic">Không có submission nào đang chờ xử lý.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Conversion Funnel & Quick Links -->
        <div class="col-sm-12 col-xl-4">
            <div class="bg-light rounded p-4 h-100 shadow-sm">
                <h6 class="mb-4 text-center"><i class="fa fa-filter me-2"></i>Phễu chuyển đổi (ROI)</h6>
                <div class="funnel-container d-flex flex-column align-items-center">
                    <div class="funnel-step bg-primary text-white p-3 mb-2 rounded text-center w-100 shadow-sm" style="clip-path: polygon(0 0, 100% 0, 85% 100%, 15% 100%);">
                        <div class="small">SUBMISSIONS</div>
                        <div class="h5 mb-0">${stats.totalLeads}</div>
                    </div>
                    <div class="text-muted my-1"><i class="fa fa-chevron-down"></i></div>
                    <div class="funnel-step bg-danger text-white p-3 mb-2 rounded text-center w-75 shadow-sm" style="clip-path: polygon(0 0, 100% 0, 80% 100%, 20% 100%);">
                        <div class="small">HOT LEADS</div>
                        <div class="h5 mb-0">${stats.hotLeads}</div>
                    </div>
                    <div class="text-muted my-1"><i class="fa fa-chevron-down"></i></div>
                    <div class="funnel-step bg-info text-white p-3 mb-2 rounded text-center w-50 shadow-sm" style="clip-path: polygon(0 0, 100% 0, 75% 100%, 25% 100%);">
                        <div class="small">CONVERTED</div>
                        <div class="h5 mb-0">${stats.totalCustomers}</div>
                    </div>
                </div>

                
            </div>
        </div>
    </div>
</div>

<style>
    .funnel-step {
        transition: transform 0.2s;
        cursor: default;
    }
    .funnel-step:hover {
        transform: scale(1.02);
    }
</style>
