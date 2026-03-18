<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
                <% request.setAttribute("currentPage", "sales-pipeline" ); %>

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <title>Sales Pipeline - CRM System</title>
                        <%@ include file="/includes/head.jsp" %>
                            <style>
                                .pipeline-column {
                                    max-height: 75vh;
                                    overflow-y: auto;
                                    background: #f1f3f5;
                                    border-radius: 10px;
                                    padding: 15px;
                                    scrollbar-width: thin;
                                    scrollbar-color: #dee2e6 transparent;
                                }

                                .pipeline-column::-webkit-scrollbar {
                                    width: 6px;
                                }

                                .pipeline-column::-webkit-scrollbar-thumb {
                                    background-color: #dee2e6;
                                    border-radius: 10px;
                                }

                                .pipeline-header {
                                    font-weight: 600;
                                    padding: 12px 15px;
                                    border-radius: 8px;
                                    margin-bottom: 15px;
                                    color: white;
                                    position: sticky;
                                    top: 0;
                                    z-index: 10;
                                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                                }

                                .pipeline-header.prospecting {
                                    background: linear-gradient(135deg, #6c757d, #495057);
                                }

                                .pipeline-header.qualified {
                                    background: linear-gradient(135deg, #0d6efd, #0a58ca);
                                }

                                .pipeline-header.proposal {
                                    background: linear-gradient(135deg, #fd7e14, #dc6a12);
                                }

                                .pipeline-header.negotiation {
                                    background: linear-gradient(135deg, #6f42c1, #5a32a3);
                                }

                                .pipeline-header.closed {
                                    background: linear-gradient(135deg, #198754, #157347);
                                }

                                .deal-card {
                                    background: white;
                                    border-radius: 8px;
                                    padding: 15px;
                                    margin-bottom: 10px;
                                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                                    cursor: grab;
                                    transition: transform 0.2s;
                                }

                                .deal-card:hover {
                                    transform: translateY(-2px);
                                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                                }

                                .deal-value {
                                    font-size: 1.1rem;
                                    font-weight: 600;
                                    color: #198754;
                                }

                                .deal-company {
                                    font-weight: 500;
                                    color: #333;
                                }

                                .deal-contact {
                                    font-size: 0.85rem;
                                    color: #666;
                                }

                                .deal-date {
                                    font-size: 0.8rem;
                                    color: #999;
                                }

                                .stage-total {
                                    font-size: 0.85rem;
                                    opacity: 0.9;
                                }
                            </style>
                    </head>

                    <body>
                        <div class="container-xxl position-relative bg-white d-flex p-0">
                            <div id="spinner"
                                class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                                <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;"
                                    role="status">
                                    <span class="sr-only">Loading...</span>
                                </div>
                            </div>

                            <%@ include file="/includes/sidebar.jsp" %>

                                <div class="content">
                                    <%@ include file="/includes/topbar.jsp" %>

                                        <div class="container-fluid pt-4 px-4">
                                            <div class="d-flex justify-content-between align-items-center mb-4">
                                                <h3 class="mb-0"><i class="fa fa-funnel-dollar me-2"></i>Sales Pipeline
                                                </h3>
                                                <button class="btn btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#addDealModal">
                                                    <i class="fa fa-plus me-2"></i>Thêm Deal
                                                </button>
                                            </div>
                                        </div>

                                        <div class="container-fluid px-4">
                                            <div class="row g-3 flex-nowrap overflow-auto pb-3"
                                                style="min-height: 80vh;">
                                                <c:forEach var="stage"
                                                    items="${fn:split('Prospecting,Proposal,Negotiation,Won', ',')}">
                                                    <div class="col-12 col-lg">
                                                        <div class="pipeline-column" data-stage="${stage}">
                                                            <div
                                                                class="pipeline-header ${stage == 'Prospecting' ? 'prospecting' : (stage == 'Won' ? 'closed' : stage.toLowerCase())} d-flex flex-column">
                                                                <div
                                                                    class="d-flex justify-content-between align-items-center">
                                                                    <span><i
                                                                            class="fa ${stage == 'Won' ? 'fa-trophy' : 'fa-tag'} me-2"></i>${stage}</span>
                                                                </div>
                                                                <span class="stage-total mt-1" id="total-${stage}">0
                                                                    deals -
                                                                    $0</span>
                                                            </div>

                                                            <c:forEach var="deal" items="${opportunities}">
                                                                <c:if test="${deal.stage == stage}">
                                                                    <div class="deal-card" draggable="true"
                                                                        data-deal-id="${deal.id}"
                                                                        data-value="${deal.expectedValue != null ? deal.expectedValue : 0}">
                                                                        <div class="deal-company">${deal.name}</div>
                                                                        <div class="deal-contact"><i
                                                                                class="fa fa-user me-1"></i>Sale
                                                                            Assigned
                                                                        </div>
                                                                        <div class="deal-value mt-2">
                                                                            <fmt:formatNumber
                                                                                value="${deal.expectedValue != null ? deal.expectedValue : 0}"
                                                                                type="currency" currencySymbol="$" />
                                                                        </div>
                                                                        <span
                                                                            class="badge ${deal.stage == 'Won' ? 'bg-success' : 'bg-primary'}">${deal.stage}</span>
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <!-- Global Stats -->
                                        <div class="container-fluid pt-4 px-4">
                                            <div class="row g-4">
                                                <div class="col-sm-6 col-xl-3">
                                                    <div
                                                        class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm">
                                                        <i class="fa fa-funnel-dollar fa-3x text-primary"></i>
                                                        <div class="ms-3 text-end">
                                                            <p class="mb-2">Tổng Pipeline</p>
                                                            <h6 class="mb-0" id="totalPipelineValue">$0</h6>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-6 col-xl-3">
                                                    <div
                                                        class="bg-light rounded d-flex align-items-center justify-content-between p-4 shadow-sm text-success font-weight-bold">
                                                        <i class="fa fa-trophy fa-3x"></i>
                                                        <div class="ms-3 text-end">
                                                            <p class="mb-2">Đã chốt (Won)</p>
                                                            <h6 class="mb-0" id="closedWonValue">$0</h6>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <%@ include file="/includes/footer.jsp" %>
                                </div>
                                <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                        class="bi bi-arrow-up"></i></a>
                        </div>

                        <!-- Confirmation Modal for Closed Won -->
                        <div class="modal fade" id="confirmWonModal" tabindex="-1">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header bg-success text-white">
                                        <h5 class="modal-title"><i class="fa fa-trophy me-2"></i>Xác nhận Chốt Thắng
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white"
                                            data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body text-center py-4">
                                        <h4>Chúc mừng!</h4>
                                        <p>Bạn có chắc chắn muốn chuyển Deal sang <strong>Closed Won</strong> không?</p>
                                    </div>
                                    <div class="modal-footer justify-content-center">
                                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal"
                                            id="cancelWonBtn">Hủy</button>
                                        <button type="button" class="btn btn-success px-4" id="confirmWonBtn">Xác
                                            nhận</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%@ include file="/includes/scripts.jsp" %>
                            <script>
                                document.addEventListener('DOMContentLoaded', function () {
                                    var spinner = document.getElementById('spinner');
                                    if (spinner) spinner.classList.remove('show');

                                    const cards = document.querySelectorAll('.deal-card');
                                    const columns = document.querySelectorAll('.pipeline-column');
                                    let draggedCard = null;
                                    let sourceColumn = null;

                                    updateColumnStats();

                                    cards.forEach(card => {
                                        card.addEventListener('dragstart', function (e) {
                                            draggedCard = this;
                                            sourceColumn = this.parentElement;
                                            this.classList.add('opacity-50');
                                        });
                                        card.addEventListener('dragend', function () { this.classList.remove('opacity-50'); });
                                    });

                                    columns.forEach(column => {
                                        column.addEventListener('dragover', e => e.preventDefault());
                                        column.addEventListener('drop', function (e) {
                                            e.preventDefault();
                                            const targetColumn = this;
                                            const stage = this.getAttribute('data-stage');
                                            const dealId = draggedCard.getAttribute('data-deal-id');

                                            if (stage === 'Won') {
                                                const wonModal = new bootstrap.Modal(document.getElementById('confirmWonModal'));
                                                wonModal.show();
                                                document.getElementById('confirmWonBtn').onclick = () => {
                                                    updateDealStage(dealId, stage, targetColumn, draggedCard);
                                                    wonModal.hide();
                                                };
                                            } else {
                                                updateDealStage(dealId, stage, targetColumn, draggedCard);
                                            }
                                        });
                                    });

                                    function updateDealStage(dealId, stage, targetColumn, card) {
                                        fetch('${pageContext.request.contextPath}/sales-pipeline', {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                            body: `dealId=${dealId}&stage=${stage}`
                                        })
                                            .then(res => res.json())
                                            .then(data => {
                                                if (data.success) {
                                                    targetColumn.appendChild(card);
                                                    updateColumnStats();
                                                    showToast('Thành công', 'Đã cập nhật giai đoạn sang ' + stage);
                                                } else {
                                                    showToast('Lỗi', data.message || 'Không thể cập nhật', 'danger');
                                                }
                                            })
                                            .catch(err => showToast('Lỗi', 'Lỗi kết nối server', 'danger'));
                                    }

                                    function updateColumnStats() {
                                        let pipelineTotal = 0;
                                        let wonTotal = 0;
                                        columns.forEach(col => {
                                            let colMoney = 0;
                                            const cardsInCol = col.querySelectorAll('.deal-card');
                                            cardsInCol.forEach(c => {
                                                const val = parseFloat(c.getAttribute('data-value')) || 0;
                                                colMoney += val;
                                                pipelineTotal += val;
                                                if (col.getAttribute('data-stage') === 'Won') wonTotal += val;
                                            });
                                            const stage = col.getAttribute('data-stage');
                                            document.getElementById('total-' + stage).innerText = `${cardsInCol.length} deals - $${colMoney.toLocaleString()}`;
                                        });
                                        document.getElementById('totalPipelineValue').innerText = '$' + pipelineTotal.toLocaleString();
                                        document.getElementById('closedWonValue').innerText = '$' + wonTotal.toLocaleString();
                                    }

                                    function showToast(title, message, type = 'success') {
                                        const toast = document.createElement('div');
                                        toast.className = `alert alert-${type} position-fixed top-0 end-0 m-3 shadow`;
                                        toast.style.zIndex = '9999';
                                        toast.innerHTML = `<strong>${title}:</strong> ${message}`;
                                        document.body.appendChild(toast);
                                        setTimeout(() => toast.remove(), 3000);
                                    }
                                });
                            </script>
                    </body>

                    </html>