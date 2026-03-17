<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <title>403 Forbidden - CRM System</title>
        <%@ include file="/includes/head.jsp" %>
            <style>
                .error-container {
                    min-height: 70vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background-color: #f8f9fa;
                }

                .error-card {
                    max-width: 500px;
                    width: 90%;
                    padding: 40px;
                    text-align: center;
                    background: #fff;
                    border-radius: 15px;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                }

                .error-icon {
                    font-size: 80px;
                    color: #dc3545;
                    margin-bottom: 20px;
                }

                .error-code {
                    font-size: 48px;
                    font-weight: 800;
                    color: #343a40;
                    margin-bottom: 10px;
                }

                .error-message {
                    font-size: 18px;
                    color: #6c757d;
                    margin-bottom: 30px;
                }

                .btn-home {
                    padding: 12px 30px;
                    font-weight: 600;
                    border-radius: 30px;
                    transition: all 0.3s;
                }

                .btn-home:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 5px 15px rgba(0, 123, 255, 0.3);
                }
            </style>
    </head>

    <body>
        <div class="container-xxl position-relative bg-white d-flex p-0">
            <%-- Include Sidebar --%>
                <%@ include file="/includes/sidebar.jsp" %>

                    <!-- Content Start -->
                    <div class="content">
                        <%-- Include Top Navbar --%>
                            <%@ include file="/includes/topbar.jsp" %>

                                <div class="container-fluid pt-4 px-4">
                                    <div class="error-container rounded">
                                        <div class="error-card">
                                            <div class="error-icon">
                                                <i class="fa fa-lock"></i>
                                            </div>
                                            <div class="error-code">403</div>
                                            <div class="error-message text-uppercase font-weight-bold">Truy cập bị từ
                                                chối</div>
                                            <p class="error-message">Xin lỗi, bạn không có quyền truy cập vào trang này.
                                            </p>
                                            <a href="${pageContext.request.contextPath}/dashboard"
                                                class="btn btn-primary btn-home">
                                                <i class="fa fa-home me-2"></i>Quay lại Dashboard
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                <%-- Include Footer --%>
                                    <%@ include file="/includes/footer.jsp" %>
                    </div>
                    <!-- Content End -->
        </div>

        <%-- Include Scripts --%>
            <%@ include file="/includes/scripts.jsp" %>
    </body>

    </html>