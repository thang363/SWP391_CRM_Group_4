<%-- sales-pipeline.jsp - Trang Sales Pipeline --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%-- Đặt biến currentPage để highlight menu active --%>
            <% request.setAttribute("currentPage", "sales-pipeline" ); %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>Sales Pipeline - CRM System</title>
                    <%@ include file="/includes/head.jsp" %>
                        <style>
                            .pipeline-column {
                                min-height: 500px;
                                background: #f8f9fa;
                                border-radius: 10px;
                                padding: 15px;
                            }

                            .pipeline-header {
                                font-weight: 600;
                                padding: 10px 15px;
                                border-radius: 8px;
                                margin-bottom: 15px;
                                color: white;
                            }

                            .pipeline-header.lead {
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
                                transition: transform 0.2s, box-shadow 0.2s;
                            }

                            .deal-card:hover {
                                transform: translateY(-2px);
                                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                            }

                            .deal-card:active {
                                cursor: grabbing;
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
                                font-size: 0.9rem;
                                opacity: 0.9;
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

                                            <!-- Page Header -->
                                            <div class="container-fluid pt-4 px-4">
                                                <div class="row g-4">
                                                    <div class="col-12">
                                                        <div
                                                            class="d-flex justify-content-between align-items-center mb-4">
                                                            <h3 class="mb-0"><i
                                                                    class="fa fa-funnel-dollar me-2"></i>Sales Pipeline
                                                            </h3>
                                                            <button class="btn btn-primary" data-bs-toggle="modal"
                                                                data-bs-target="#addDealModal">
                                                                <i class="fa fa-plus me-2"></i>Thêm Deal
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Pipeline Board -->
                                            <div class="container-fluid px-4">
                                                <div class="row g-3">
                                                    <!-- Lead Column -->
                                                    <div class="col-12 col-lg">
                                                        <div class="pipeline-column">
                                                            <div
                                                                class="pipeline-header lead d-flex justify-content-between align-items-center">
                                                                <span><i class="fa fa-user-plus me-2"></i>Lead</span>
                                                                <span class="stage-total">3 deals - $45,000</span>
                                                            </div>

                                                            <div class="deal-card" draggable="true" data-deal-id="1">
                                                                <div class="deal-company">Công ty ABC</div>
                                                                <div class="deal-contact"><i
                                                                        class="fa fa-user me-1"></i>Nguyễn Văn A</div>
                                                                <div class="deal-value mt-2">$15,000</div>
                                                                <div class="deal-date"><i
                                                                        class="fa fa-calendar me-1"></i>12/01/2026</div>
                                                            </div>

                                                            <div class="deal-card" draggable="true" data-deal-id="2">
                                                                <div class="deal-company">Công ty XYZ</div>
                                                                <div class="deal-contact"><i
                                                                        class="fa fa-user me-1"></i>Trần Thị B</div>
                                                                <div class="deal-value mt-2">$20,000</div>
                                                                <div class="deal-date"><i
                                                                        class="fa fa-calendar me-1"></i>10/01/2026</div>
                                                            </div>

                                                            <div class="deal-card" draggable="true" data-deal-id="3">
                                                                <div class="deal-company">Startup Tech</div>
                                                                <div class="deal-contact"><i
                                                                        class="fa fa-user me-1"></i>Lê Văn C</div>
                                                                <div class="deal-value mt-2">$10,000</div>
                                                                <div class="deal-date"><i
                                                                        class="fa fa-calendar me-1"></i>08/01/2026</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Qualified Column -->
                                                    <div class="col-12 col-lg">
                                                        <div class="pipeline-column">
                                                            <div
                                                                class="pipeline-header qualified d-flex justify-content-between align-items-center">
                                                                <span><i
                                                                        class="fa fa-check-circle me-2"></i>Qualified</span>
                                                                <span class="stage-total">2 deals - $55,000</span>
                                                            </div>

                                                            <div class="deal-card" draggable="true" data-deal-id="4">
                                                                <div class="deal-company">Global Corp</div>
                                                                <div class="deal-contact"><i
                                                                        class="fa fa-user me-1"></i>Phạm Thị D</div>
                                                                <div class="deal-value mt-2">$30,000</div>
                                                                <div class="deal-date"><i
                                                                        class="fa fa-calendar me-1"></i>05/01/2026</div>
                                                            </div>

                                                            <div class="deal-card" draggable="true" data-deal-id="5">
                                                                <div class="deal-company">Local Shop</div>
                                                                <div class="deal-contact"><i
                                                                        class="fa fa-user me-1"></i>Hoàng Văn E</div>
                                                                <div class="deal-value mt-2">$25,000</div>
                                                                <div class="deal-date"><i
                                                                        class="fa fa-calendar me-1"></i>03/01/2026</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Proposal Column -->
                                                    <div class="col-12 col-lg">
                                                        <div class="pipeline-column">
                                                            <div
                                                                class="pipeline-header proposal d-flex justify-content-between align-items-center">
                                                                <span><i
                                                                        class="fa fa-file-invoice me-2"></i>Proposal</span>
                                                                <span class="stage-total">2 deals - $80,000</span>
                                                            </div>

                                                            <div class="deal-card" draggable="true" data-deal-id="6">
                                                                <div class="deal-company">Enterprise Inc</div>
                                                                <div class="deal-contact"><i
                                                                        class="fa fa-user me-1"></i>Vũ Thị F</div>
                                                                <div class="deal-value mt-2">$50,000</div>
                                                                <div class="deal-date"><i
                                                                        class="fa fa-calendar me-1"></i>28/12/2025</div>
                                                            </div>

                                                            <div class="deal-card" draggable="true" data-deal-id="7">
                                                                <div class="deal-company">SME Solutions</div>
                                                                <div class="deal-contact"><i
                                                                        class="fa fa-user me-1"></i>Đỗ Văn G</div>
                                                                <div class="deal-value mt-2">$30,000</div>
                                                                <div class="deal-date"><i
                                                                        class="fa fa-calendar me-1"></i>25/12/2025</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Negotiation Column -->
                                                    <div class="col-12 col-lg">
                                                        <div class="pipeline-column">
                                                            <div
                                                                class="pipeline-header negotiation d-flex justify-content-between align-items-center">
                                                                <span><i
                                                                        class="fa fa-handshake me-2"></i>Negotiation</span>
                                                                <span class="stage-total">1 deal - $100,000</span>
                                                            </div>

                                                            <div class="deal-card" draggable="true" data-deal-id="8">
                                                                <div class="deal-company">Big Enterprise</div>
                                                                <div class="deal-contact"><i
                                                                        class="fa fa-user me-1"></i>Ngô Thị H</div>
                                                                <div class="deal-value mt-2">$100,000</div>
                                                                <div class="deal-date"><i
                                                                        class="fa fa-calendar me-1"></i>20/12/2025</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Closed Won Column -->
                                                    <div class="col-12 col-lg">
                                                        <div class="pipeline-column">
                                                            <div
                                                                class="pipeline-header closed d-flex justify-content-between align-items-center">
                                                                <span><i class="fa fa-trophy me-2"></i>Closed Won</span>
                                                                <span class="stage-total">2 deals - $75,000</span>
                                                            </div>

                                                            <div class="deal-card" draggable="true" data-deal-id="9">
                                                                <div class="deal-company">Success Corp</div>
                                                                <div class="deal-contact"><i
                                                                        class="fa fa-user me-1"></i>Bùi Văn I</div>
                                                                <div class="deal-value mt-2">$45,000</div>
                                                                <div class="deal-date"><i
                                                                        class="fa fa-calendar me-1"></i>15/12/2025</div>
                                                            </div>

                                                            <div class="deal-card" draggable="true" data-deal-id="10">
                                                                <div class="deal-company">Winner LLC</div>
                                                                <div class="deal-contact"><i
                                                                        class="fa fa-user me-1"></i>Mai Thị K</div>
                                                                <div class="deal-value mt-2">$30,000</div>
                                                                <div class="deal-date"><i
                                                                        class="fa fa-calendar me-1"></i>10/12/2025</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Summary Stats -->
                                            <div class="container-fluid pt-4 px-4">
                                                <div class="row g-4">
                                                    <div class="col-sm-6 col-xl-3">
                                                        <div
                                                            class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                            <i class="fa fa-funnel-dollar fa-3x text-primary"></i>
                                                            <div class="ms-3 text-end">
                                                                <p class="mb-2">Tổng Pipeline</p>
                                                                <h6 class="mb-0">$355,000</h6>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-6 col-xl-3">
                                                        <div
                                                            class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                            <i class="fa fa-chart-pie fa-3x text-success"></i>
                                                            <div class="ms-3 text-end">
                                                                <p class="mb-2">Đã chốt</p>
                                                                <h6 class="mb-0">$75,000</h6>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-6 col-xl-3">
                                                        <div
                                                            class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                            <i class="fa fa-percentage fa-3x text-warning"></i>
                                                            <div class="ms-3 text-end">
                                                                <p class="mb-2">Tỷ lệ chốt</p>
                                                                <h6 class="mb-0">21.1%</h6>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-6 col-xl-3">
                                                        <div
                                                            class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                            <i class="fa fa-list-ol fa-3x text-info"></i>
                                                            <div class="ms-3 text-end">
                                                                <p class="mb-2">Tổng Deals</p>
                                                                <h6 class="mb-0">10 deals</h6>
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

                    <!-- Add Deal Modal -->
                    <div class="modal fade" id="addDealModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title"><i class="fa fa-plus me-2"></i>Thêm Deal Mới</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="addDealForm">
                                        <div class="mb-3">
                                            <label class="form-label">Tên công ty</label>
                                            <input type="text" class="form-control" name="company" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Người liên hệ</label>
                                            <input type="text" class="form-control" name="contact" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Giá trị ($)</label>
                                            <input type="number" class="form-control" name="value" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Giai đoạn</label>
                                            <select class="form-select" name="stage">
                                                <option value="lead">Lead</option>
                                                <option value="qualified">Qualified</option>
                                                <option value="proposal">Proposal</option>
                                                <option value="negotiation">Negotiation</option>
                                            </select>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="button" class="btn btn-primary">Lưu Deal</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- Include Scripts --%>
                        <%@ include file="/includes/scripts.jsp" %>

                            <!-- Inline script để đảm bảo ẩn spinner -->
                            <script>
                                document.addEventListener('DOMContentLoaded', function () {
                                    var spinner = document.getElementById('spinner');
                                    if (spinner) {
                                        spinner.classList.remove('show');
                                    }
                                });
                            </script>
                </body>

                </html>