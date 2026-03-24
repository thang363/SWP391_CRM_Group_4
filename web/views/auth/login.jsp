<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="utf-8">
            <title>Đăng nhập - CRM System</title>
            <meta content="width=device-width, initial-scale=1.0" name="viewport">
            <meta content="CRM, Login, Đăng nhập" name="keywords">
            <meta content="Đăng nhập vào hệ thống quản lý khách hàng CRM" name="description">

            <!-- Favicon -->
            <link href="${pageContext.request.contextPath}/img/favicon.ico" rel="icon">

            <!-- Google Web Fonts -->
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap"
                rel="stylesheet">

            <!-- Icon Font Stylesheet -->
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

            <!-- Libraries Stylesheet -->
            <link href="${pageContext.request.contextPath}/lib/owlcarousel/assets/owl.carousel.min.css"
                rel="stylesheet">
            <link href="${pageContext.request.contextPath}/lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css"
                rel="stylesheet" />

            <!-- Customized Bootstrap Stylesheet -->
            <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">

            <!-- Template Stylesheet -->
            <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">

            <style>
                .alert-floating {
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    z-index: 9999;
                    min-width: 300px;
                    animation: slideIn 0.3s ease-out;
                }

                @keyframes slideIn {
                    from {
                        transform: translateX(100%);
                        opacity: 0;
                    }

                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }
            </style>
        </head>

        <body>
            <div class="container-xxl position-relative bg-white d-flex p-0">
                <!-- Spinner Start -->
                <div id="spinner"
                    class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                    <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                        <span class="sr-only">Đang tải...</span>
                    </div>
                </div>
                <!-- Spinner End -->

                <!-- Alert Messages -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-floating alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-floating alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Sign In Start -->
                <div class="container-fluid">
                    <div class="row h-100 align-items-center justify-content-center" style="min-height: 100vh;">
                        <div class="col-12 col-sm-8 col-md-6 col-lg-5 col-xl-4">
                            <div class="bg-light rounded p-4 p-sm-5 my-4 mx-3">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <a href="${pageContext.request.contextPath}/">
                                        <h3 class="text-primary"><i class="fa fa-users me-2"></i>CRM</h3>
                                    </a>
                                    <h3>Đăng nhập</h3>
                                </div>

                                <form action="${pageContext.request.contextPath}/login" method="POST" id="loginForm">
                                    <div class="form-floating mb-3">
                                        <input type="text" class="form-control" id="username" name="username"
                                            placeholder="Tên đăng nhập" required value="${param.username}">
                                        <label for="username">Tên đăng nhập</label>
                                    </div>
                                    <div class="form-floating mb-4">
                                        <input type="password" class="form-control" id="password" name="password"
                                            placeholder="Mật khẩu" required>
                                        <label for="password">Mật khẩu</label>
                                    </div>
                                    <div class="d-flex align-items-center justify-content-between mb-4">
                                        
                                        <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu</a>
                                    </div>
                                    <button type="submit" class="btn btn-primary py-3 w-100 mb-4">Đăng nhập</button>
                                    
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Sign In End -->
            </div>

            <!-- JavaScript Libraries -->
            <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/lib/chart/chart.min.js"></script>
            <script src="${pageContext.request.contextPath}/lib/easing/easing.min.js"></script>
            <script src="${pageContext.request.contextPath}/lib/waypoints/waypoints.min.js"></script>
            <script src="${pageContext.request.contextPath}/lib/owlcarousel/owl.carousel.min.js"></script>
            <script src="${pageContext.request.contextPath}/lib/tempusdominus/js/moment.min.js"></script>
            <script src="${pageContext.request.contextPath}/lib/tempusdominus/js/moment-timezone.min.js"></script>
            <script
                src="${pageContext.request.contextPath}/lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

            <!-- Template Javascript -->
            <script src="${pageContext.request.contextPath}/js/main.js"></script>

            <script>
                // Auto-hide alerts after 5 seconds
                setTimeout(function () {
                    $('.alert-floating').fadeOut('slow');
                }, 5000);

                // Form validation
                $('#loginForm').on('submit', function (e) {
                    var username = $('#username').val().trim();
                    var password = $('#password').val().trim();

                    if (username.length < 3) {
                        e.preventDefault();
                        alert('Tên đăng nhập phải có ít nhất 3 ký tự');
                        $('#username').focus();
                        return false;
                    }

                    if (password.length < 1) {
                        e.preventDefault();
                        alert('Vui lòng nhập mật khẩu');
                        $('#password').focus();
                        return false;
                    }
                });
            </script>
        </body>

        </html>