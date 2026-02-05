<%-- kanban.jsp - Trang Sales Pipeline --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%-- Đặt biến currentPage để highlight menu active --%>
            <% request.setAttribute("currentPage", "sales" ); %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>Sales Pipeline - CRM System</title>
                    <%@ include file="/includes/head.jsp" %>

                        <!-- Custom Kanban Styles -->
                        <style>
                            .kanban-board {
                                display: flex;
                                gap: 1rem;
                                overflow-x: auto;
                                padding-bottom: 1rem;
                            }

                            .kanban-column {
                                min-width: 300px;
                                max-width: 300px;
                                background: var(--light);
                                border-radius: 5px;
                            }

                            .kanban-header {
                                padding: 1rem;
                                border-bottom: 3px solid var(--primary);
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                            }

                            .kanban-header h6 {
                                margin: 0;
                                color: var(--dark);
                                font-weight: 600;
                            }

                            .kanban-count {
                                background: var(--primary);
                                color: white;
                                padding: 2px 10px;
                                border-radius: 20px;
                                font-size: 0.85rem;
                            }

                            .kanban-body {
                                padding: 1rem;
                                min-height: 400px;
                            }

                            .kanban-card {
                                background: white;
                                border-radius: 5px;
                                padding: 1rem;
                                margin-bottom: 0.75rem;
                                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                                cursor: grab;
                                transition: 0.3s;
                                border-left: 3px solid var(--primary);
                            }

                            .kanban-card:hover {
                                box-shadow: 0 4px 12px rgba(0, 156, 255, 0.2);
                                transform: translateY(-2px);
                            }

                            .kanban-card-title {
                                font-weight: 600;
                                color: var(--dark);
                                margin-bottom: 0.5rem;
                            }

                            .kanban-card-company {
                                color: #757575;
                                font-size: 0.9rem;
                                margin-bottom: 0.5rem;
                            }

                            .kanban-card-value {
                                font-weight: 700;
                                color: var(--primary);
                                font-size: 1.1rem;
                            }

                            .priority-high {
                                border-left-color: #dc3545;
                            }

                            .priority-medium {
                                border-left-color: #ffc107;
                            }

                            .priority-low {
                                border-left-color: #28a745;
                            }
                        </style>
                </head>

                <body>
                    <div class="container-xxl position-relative bg-white d-flex p-0">
                        <!-- Spinner -->
                        <div id="spinner"
                            class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                            <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                                <span class="sr-only">Loading...</span>
                            </div>
                        </div>

                        <%-- Include Sidebar --%>
                            <%@ include file="/includes/sidebar.jsp" %>

                                <!-- Content Start -->
                                <div class="content">
                                    <%-- Include Top Navbar --%>
                                        <%@ include file="/includes/topbar.jsp" %>

                                            <!-- ============================================== -->
                                            <!-- ========= NỘI DUNG RIÊNG: KANBAN ============= -->
                                            <!-- ============================================== -->

                                            <!-- Page Header -->
                                            <div class="container-fluid pt-4 px-4">
                                                <div
                                                    class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                                    <div>
                                                        <h4 class="mb-1"><i
                                                                class="fa fa-chart-line text-primary me-2"></i>Sales
                                                            Pipeline</h4>
                                                        <nav aria-label="breadcrumb">
                                                            <ol class="breadcrumb mb-0">
                                                                <li class="breadcrumb-item"><a
                                                                        href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                                                                </li>
                                                                <li class="breadcrumb-item"><a href="#">Sales</a></li>
                                                                <li class="breadcrumb-item active">Pipeline</li>
                                                            </ol>
                                                        </nav>
                                                    </div>
                                                    <div>
                                                        <button class="btn btn-primary me-2"><i
                                                                class="fa fa-plus me-2"></i>Tạo cơ hội mới</button>
                                                        <button class="btn btn-outline-primary"><i
                                                                class="fa fa-filter me-2"></i>Lọc</button>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Kanban Board -->
                                            <div class="container-fluid pt-4 px-4">
                                                <div class="kanban-board">

                                                    <!-- Stage 1: Đánh giá -->
                                                    <div class="kanban-column">
                                                        <div class="kanban-header">
                                                            <h6><i class="fa fa-search me-2"></i>Đánh giá</h6>
                                                            <span class="kanban-count">3</span>
                                                        </div>
                                                        <div class="kanban-body">
                                                            <%-- Dữ liệu có thể lấy từ database qua Servlet --%>
                                                                <div class="kanban-card priority-high">
                                                                    <div class="kanban-card-title">Hệ thống ERP</div>
                                                                    <div class="kanban-card-company"><i
                                                                            class="fa fa-building me-1"></i>Công ty ABC
                                                                    </div>
                                                                    <div class="kanban-card-value">350,000,000 ₫</div>
                                                                </div>
                                                                <div class="kanban-card priority-medium">
                                                                    <div class="kanban-card-title">Phần mềm CRM</div>
                                                                    <div class="kanban-card-company"><i
                                                                            class="fa fa-building me-1"></i>XYZ Corp
                                                                    </div>
                                                                    <div class="kanban-card-value">120,000,000 ₫</div>
                                                                </div>
                                                        </div>
                                                    </div>

                                                    <!-- Stage 2: Đề xuất -->
                                                    <div class="kanban-column">
                                                        <div class="kanban-header" style="border-color: #17a2b8;">
                                                            <h6><i class="fa fa-file-alt me-2"></i>Đề xuất</h6>
                                                            <span class="kanban-count">2</span>
                                                        </div>
                                                        <div class="kanban-body">
                                                            <div class="kanban-card priority-high">
                                                                <div class="kanban-card-title">Cloud Migration</div>
                                                                <div class="kanban-card-company"><i
                                                                        class="fa fa-building me-1"></i>Tech Solutions
                                                                </div>
                                                                <div class="kanban-card-value">500,000,000 ₫</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Stage 3: Đàm phán -->
                                                    <div class="kanban-column">
                                                        <div class="kanban-header" style="border-color: #ffc107;">
                                                            <h6><i class="fa fa-comments me-2"></i>Đàm phán</h6>
                                                            <span class="kanban-count">2</span>
                                                        </div>
                                                        <div class="kanban-body">
                                                            <div class="kanban-card priority-medium">
                                                                <div class="kanban-card-title">Data Analytics</div>
                                                                <div class="kanban-card-company"><i
                                                                        class="fa fa-building me-1"></i>DataCorp</div>
                                                                <div class="kanban-card-value">420,000,000 ₫</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Stage 4: Đã chốt -->
                                                    <div class="kanban-column">
                                                        <div class="kanban-header" style="border-color: #28a745;">
                                                            <h6><i class="fa fa-check-circle me-2"></i>Đã chốt</h6>
                                                            <span class="kanban-count">1</span>
                                                        </div>
                                                        <div class="kanban-body">
                                                            <div class="kanban-card"
                                                                style="border-left-color: #28a745;">
                                                                <div class="kanban-card-title">Enterprise License</div>
                                                                <div class="kanban-card-company"><i
                                                                        class="fa fa-building me-1"></i>MegaCorp</div>
                                                                <div class="kanban-card-value">800,000,000 ₫</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>

                                            <!-- ============================================== -->
                                            <!-- ======= KẾT THÚC NỘI DUNG RIÊNG ============== -->
                                            <!-- ============================================== -->

                                            <%-- Include Footer --%>
                                                <%@ include file="/includes/footer.jsp" %>
                                </div>
                                <!-- Content End -->

                                <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                        class="bi bi-arrow-up"></i></a>
                    </div>

                    <%-- Include Scripts --%>
                        <%@ include file="/includes/scripts.jsp" %>
                </body>

                </html>