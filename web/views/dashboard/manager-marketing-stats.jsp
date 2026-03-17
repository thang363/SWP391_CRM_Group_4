<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<style>
    .card-personal {
        border-left: 5px solid #009cff !important;
    }
    .funnel-step {
        padding: 15px;
        margin-bottom: 10px;
        border-radius: 5px;
        color: white;
        text-align: center;
        font-weight: bold;
    }
    .step-leads { background-color: #009cff; }
    .step-opps { background-color: #198754; opacity: 0.8; }
    .step-custs { background-color: #198754; }
    
    .conversion-rate {
        font-size: 1.2rem;
        color: #198754;
        font-weight: bold;
    }
</style>

<div class="container-fluid pt-4 px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="mb-0"><i class="fa fa-bullhorn me-2 text-primary"></i>Marketing Overview</h3>
        <div class="text-muted">Manager: <strong>${sessionScope.user_name}</strong></div>
    </div>

    <!-- Campaign Overview Row -->
    <div class="row g-4 mb-4">
        <div class="col-sm-6 col-xl-3">
            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4 card-personal">
                <i class="fa fa-bullhorn fa-3x text-primary"></i>
                <div class="ms-3">
                    <p class="mb-2">Chiến dịch của tôi</p>
                    <h4 class="mb-0">${stats.personalTotalCampaigns}</h4>
                    <small class="text-muted">/${stats.globalTotalCampaigns} toàn hệ thống</small>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                <i class="fa fa-play-circle fa-3x text-success"></i>
                <div class="ms-3">
                    <p class="mb-2">Đang chạy (Active)</p>
                    <h4 class="mb-0">${stats.personalActiveCampaigns}</h4>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                <i class="fa fa-file-code fa-3x text-warning"></i>
                <div class="ms-3">
                    <p class="mb-2">LP Chờ duyệt</p>
                    <h4 class="mb-0">${stats.pendingLandingPages}</h4>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                <i class="fa fa-wallet fa-3x text-info"></i>
                <div class="ms-3">
                    <p class="mb-2">Tổng Ngân sách</p>
                    <h4 class="mb-0">
                        <fmt:formatNumber value="${stats.totalBudget}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </h4>
                </div>
            </div>
        </div>
    </div>

    <!-- Marketing Funnel & Charts -->
    <div class="row g-4 mb-4">
        <!-- Conversion Funnel -->
        <div class="col-sm-12 col-xl-4">
            <div class="bg-light rounded p-4 h-100">
                <h6 class="mb-4">Phễu Chuyển đổi (ROI)</h6>
                <div class="funnel-container px-3">
                    <div class="funnel-step step-leads">
                        LEADS: ${stats.totalLeads}
                    </div>
                    <div class="text-center my-1"><i class="fa fa-arrow-down text-muted"></i></div>
                    <div class="funnel-step step-opps" style="width: 85%; margin-left: 7.5%;">
                        OPPORTUNITIES: ${stats.totalOpportunities}
                    </div>
                    <div class="text-center my-1"><i class="fa fa-arrow-down text-muted"></i></div>
                    <div class="funnel-step step-custs" style="width: 70%; margin-left: 15%;">
                        CUSTOMERS: ${stats.totalCustomers}
                    </div>
                </div>
                <div class="mt-4 text-center border-top pt-3">
                    <div class="row">
                        <div class="col-6 border-end">
                            <div class="small text-muted">Tỷ lệ Cơ hội</div>
                            <div class="conversion-rate"><fmt:formatNumber value="${stats.leadToOpportunityRate}" maxFractionDigits="1"/>%</div>
                        </div>
                        <div class="col-6">
                            <div class="small text-muted">Tỷ lệ Chốt</div>
                            <div class="conversion-rate"><fmt:formatNumber value="${stats.leadToCustomerRate}" maxFractionDigits="1"/>%</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Campaign Distribution -->
        <div class="col-sm-12 col-xl-4">
            <div class="bg-light text-center rounded p-4 h-100">
                <h6 class="mb-4">Trạng thái Chiến dịch cá nhân</h6>
                <canvas id="campaign-status-chart"></canvas>
            </div>
        </div>

        <!-- Lead Engagement -->
        <div class="col-sm-12 col-xl-4">
            <div class="bg-light rounded p-4 h-100">
                <h6 class="mb-4">Chỉ số Lead</h6>
                <ul class="list-group list-group-flush bg-transparent">
                    <li class="list-group-item bg-transparent d-flex justify-content-between align-items-center">
                        <span><i class="fa fa-fire text-danger me-2"></i>Lead Tiềm năng (Hot)</span>
                        <span class="badge bg-danger rounded-pill">${stats.hotLeads}</span>
                    </li>
                    <li class="list-group-item bg-transparent d-flex justify-content-between align-items-center">
                        <span><i class="fa fa-user-tag text-primary me-2"></i>Đã phân bổ Sales</span>
                        <span class="badge bg-primary rounded-pill">${stats.assignedLeads}</span>
                    </li>
                    <li class="list-group-item bg-transparent d-flex justify-content-between align-items-center">
                        <span><i class="fa fa-user-clock text-warning me-2"></i>Chưa phân bổ</span>
                        <span class="badge bg-warning rounded-pill text-dark">${stats.hotLeads - stats.assignedLeads}</span>
                    </li>
                    <li class="list-group-item bg-transparent d-flex justify-content-between align-items-center">
                        <span><i class="fa fa-check-double text-success me-2"></i>Landing Page đã duyệt</span>
                        <span class="badge bg-success rounded-pill">${stats.approvedLandingPages}</span>
                    </li>
                </ul>
                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/campaigns" class="btn btn-primary w-100">
                        <i class="fa fa-list me-2"></i>Quản lý Chiến dịch
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var ctxMapping = document.getElementById("campaign-status-chart");
        if (ctxMapping) {
            var ctx = ctxMapping.getContext("2d");
            
            var activeVal = Number('${not empty stats.personalActiveCampaigns ? stats.personalActiveCampaigns : 0}');
            var pausedVal = Number('${not empty stats.personalPausedCampaigns ? stats.personalPausedCampaigns : 0}');
            var finishedVal = Number('${not empty stats.personalFinishedCampaigns ? stats.personalFinishedCampaigns : 0}');
            var draftVal = Number('${not empty stats.personalDraftCampaigns ? stats.personalDraftCampaigns : 0}');

            new Chart(ctx, {
                type: "doughnut",
                data: {
                    labels: ["Đang chạy", "Tạm dừng", "Đã kết thúc", "Nháp"],
                    datasets: [{
                        backgroundColor: [
                            "rgba(40, 167, 69, .7)",
                            "rgba(253, 126, 20, .7)",
                            "rgba(0, 123, 255, .7)",
                            "rgba(108, 117, 125, .7)"
                        ],
                        data: [activeVal, pausedVal, finishedVal, draftVal]
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }
    });
</script>
