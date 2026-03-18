<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="container-fluid pt-4 px-4">
    <div class="row g-4 mb-4">
        <h3 class="mb-0 text-dark fw-bold">Tổng quan công việc Marketing</h3>
    </div>

    <div class="row g-4 mb-4">
        <!-- Card 1: Submissions Today -->
        <div class="col-sm-6 col-xl-3">
            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-success border-5">
                <i class="fa fa-calendar-check fa-3x text-success"></i>
                <div class="ms-3 text-end">
                    <p class="mb-2 text-muted small uppercase fw-bold">Submissions hôm nay</p>
                    <h2 class="mb-0 fw-bold">${stats.submissionsToday}</h2>
                </div>
            </div>
        </div>
        <!-- Card 2: Pending Submissions -->
        <div class="col-sm-6 col-xl-3">
            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-warning border-5">
                <i class="fa fa-clock fa-3x text-warning"></i>
                <div class="ms-3 text-end">
                    <p class="mb-2 text-muted small uppercase fw-bold">Đang chờ xử lý</p>
                    <h2 class="mb-0 fw-bold">${stats.pendingSubmissions}</h2>
                </div>
            </div>
        </div>
        <!-- Card 3: Hot Leads -->
        <div class="col-sm-6 col-xl-3">
            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-danger border-5">
                <i class="fa fa-fire fa-3x text-danger"></i>
                <div class="ms-3 text-end">
                    <p class="mb-2 text-muted small uppercase fw-bold">Hot Leads của tôi</p>
                    <h2 class="mb-0 fw-bold">${stats.hotLeads}</h2>
                </div>
            </div>
        </div>
        <!-- Card 4: Active Landing Pages -->
        <div class="col-sm-6 col-xl-3">
            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-primary border-5">
                <i class="fa fa-file-code fa-3x text-primary"></i>
                <div class="ms-3 text-end">
                    <p class="mb-2 text-muted small uppercase fw-bold">LP đang hoạt động</p>
                    <h2 class="mb-0 fw-bold">${stats.approvedLandingPages}</h2>
                </div>
            </div>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="row g-4 justify-content-center mt-2">
        <div class="col-auto">
            <a href="${pageContext.request.contextPath}/marketing/submissions" class="btn btn-outline-success btn-lg px-4 py-2 shadow-sm">
                <i class="fa fa-list-ul me-2"></i> Xem Submissions
            </a>
        </div>
        <div class="col-auto">
            <a href="${pageContext.request.contextPath}/landing-pages" class="btn btn-outline-primary btn-lg px-4 py-2 shadow-sm">
                <i class="fa fa-laptop-code me-2"></i> Quản lý Landing Pages
            </a>
        </div>
    </div>
</div>
