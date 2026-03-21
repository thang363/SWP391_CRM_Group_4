<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

            <div class="container-fluid pt-4 px-4">
                <div class="row g-4 mb-4">
                    <h3 class="mb-0 text-dark fw-bold">Tổng quan công việc Quản lý</h3>
                </div>

                <!-- Hàng 1: Công việc (Tasks) -->
                <div class="row g-4 mb-4">
                    <!-- Card 1: Unassigned Hot Leads -->
                    <div class="col-sm-6 col-xl-4">
                        <div
                            class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-danger border-5">
                            <i class="fa fa-fire fa-3x text-danger"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2 text-muted small uppercase fw-bold">Lead nóng chưa giao</p>
                                <h2 class="mb-0 fw-bold">${stats.unassignedHotLeads}</h2>
                            </div>
                        </div>
                    </div>
                    <!-- Card 2: Opportunities -->
                    <div class="col-sm-6 col-xl-4">
                        <div
                            class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-warning border-5">
                            <i class="fa fa-handshake fa-3x text-warning"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2 text-muted small uppercase fw-bold">Cơ hội mới</p>
                                <h2 class="mb-0 fw-bold">${stats.totalOpportunities}</h2>
                            </div>
                        </div>
                    </div>
                    <!-- Card 3: Active Campaigns -->
                    <div class="col-sm-6 col-xl-4">
                        <div
                            class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-primary border-5">
                            <i class="fa fa-bullhorn fa-3x text-primary"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2 text-muted small uppercase fw-bold">Chiến dịch đang chạy</p>
                                <h2 class="mb-0 fw-bold">${stats.personalActiveCampaigns}</h2>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Hàng 2: Tiền nong (Financials) -->
                <div class="row g-4 mb-4">
                    <!-- Card 4: Total Budget -->
                    <div class="col-sm-6 col-xl-4">
                        <div
                            class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-info border-5">
                            <i class="fa fa-wallet fa-3x text-info"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2 text-muted small uppercase fw-bold">Tổng Ngân sách</p>
                                <h3 class="mb-0 fw-bold">
                                    <fmt:formatNumber value="${stats.totalBudget}" type="currency" currencySymbol="₫" />
                                </h3>
                            </div>
                        </div>
                    </div>
                    <!-- Card 5: Pipeline Value -->
                    <div class="col-sm-6 col-xl-4">
                        <div
                            class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-secondary border-5">
                            <i class="fa fa-chart-line fa-3x text-secondary"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2 text-muted small uppercase fw-bold">Giá trị dự kiến</p>
                                <h3 class="mb-0 fw-bold">
                                    <fmt:formatNumber value="${stats.personalPipelineValue}" type="currency"
                                        currencySymbol="₫" />
                                </h3>
                            </div>
                        </div>
                    </div>
                    <!-- Card 6: New Customers -->
                    <div class="col-sm-6 col-xl-4">
                        <div
                            class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm border-start border-success border-5">
                            <i class="fa fa-user-check fa-3x text-success"></i>
                            <div class="ms-3 text-end">
                                <p class="mb-2 text-muted small uppercase fw-bold">Khách hàng mới</p>
                                <h2 class="mb-0 fw-bold">${stats.totalCustomers}</h2>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="row g-4 justify-content-center mt-2">
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/marketing/monitor-leads"
                            class="btn btn-outline-primary btn-lg px-4 py-2 shadow-sm">
                            <i class="fa fa-users-cog me-2"></i> Phân bổ Leads
                        </a>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/campaigns"
                            class="btn btn-outline-info btn-lg px-4 py-2 shadow-sm">
                            <i class="fa fa-tasks me-2"></i> Quản lý Chiến dịch
                        </a>
                    </div>
                </div>
            </div>