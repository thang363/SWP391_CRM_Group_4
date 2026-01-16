<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="utf-8">
            <title>Đăng ký - CRM System</title>
            <meta content="width=device-width, initial-scale=1.0" name="viewport">
            <meta content="CRM, Register, Đăng ký" name="keywords">
            <meta content="Đăng ký tài khoản hệ thống quản lý khách hàng CRM" name="description">

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

                .password-strength {
                    height: 5px;
                    margin-top: 5px;
                    border-radius: 3px;
                    transition: all 0.3s ease;
                }

                .password-strength.weak {
                    background: #dc3545;
                    width: 33%;
                }

                .password-strength.medium {
                    background: #ffc107;
                    width: 66%;
                }

                .password-strength.strong {
                    background: #28a745;
                    width: 100%;
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

                <!-- Sign Up Start -->
                <div class="container-fluid">
                    <div class="row h-100 align-items-center justify-content-center" style="min-height: 100vh;">
                        <div class="col-12 col-sm-8 col-md-6 col-lg-5 col-xl-4">
                            <div class="bg-light rounded p-4 p-sm-5 my-4 mx-3">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <a href="${pageContext.request.contextPath}/">
                                        <h3 class="text-primary"><i class="fa fa-users me-2"></i>CRM</h3>
                                    </a>
                                    <h3>Đăng ký</h3>
                                </div>

                                <form action="${pageContext.request.contextPath}/register" method="POST"
                                    id="registerForm">
                                    <div class="form-floating mb-3">
                                        <input type="text" class="form-control" id="username" name="username"
                                            placeholder="Tên đăng nhập" required minlength="3" maxlength="50"
                                            pattern="^[a-zA-Z0-9_]+$" value="${param.username}">
                                        <label for="username">Tên đăng nhập</label>
                                    </div>
                                    <div class="form-floating mb-3">
                                        <input type="text" class="form-control" id="fullName" name="fullName"
                                            placeholder="Họ và tên" required value="${param.fullName}">
                                        <label for="fullName">Họ và tên</label>
                                    </div>
                                    <div class="form-floating mb-3">
                                        <input type="email" class="form-control" id="email" name="email"
                                            placeholder="Email" required value="${param.email}">
                                        <label for="email">Email</label>
                                    </div>
                                    <div class="form-floating mb-3">
                                        <input type="tel" class="form-control" id="phone" name="phone"
                                            placeholder="Số điện thoại" pattern="[0-9]{10,11}" value="${param.phone}">
                                        <label for="phone">Số điện thoại (không bắt buộc)</label>
                                    </div>
                                    <div class="form-floating mb-3">
                                        <input type="password" class="form-control" id="password" name="password"
                                            placeholder="Mật khẩu" required minlength="6">
                                        <label for="password">Mật khẩu</label>
                                        <div class="password-strength" id="passwordStrength"></div>
                                    </div>
                                    <div class="form-floating mb-4">
                                        <input type="password" class="form-control" id="confirmPassword"
                                            name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
                                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                                        <div id="passwordMatch" class="small mt-1"></div>
                                    </div>
                                    <div class="d-flex align-items-center justify-content-between mb-4">
                                        <div class="form-check">
                                            <input type="checkbox" class="form-check-input" id="agreeTerms"
                                                name="agreeTerms" required>
                                            <label class="form-check-label" for="agreeTerms">
                                                Tôi đồng ý với <a href="#" data-bs-toggle="modal"
                                                    data-bs-target="#termsModal">điều khoản</a>
                                            </label>
                                        </div>
                                    </div>
                                    <button type="submit" class="btn btn-primary py-3 w-100 mb-4">Đăng ký</button>
                                    <p class="text-center mb-0">
                                        Đã có tài khoản?
                                        <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                                    </p>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Sign Up End -->
            </div>

            <!-- Terms Modal -->
            <div class="modal fade" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="termsModalLabel">Điều khoản sử dụng</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <h6>1. Điều khoản chung</h6>
                            <p>Bằng việc sử dụng hệ thống CRM này, bạn đồng ý tuân thủ các điều khoản và điều kiện được
                                nêu trong tài liệu này.</p>

                            <h6>2. Bảo mật thông tin</h6>
                            <p>Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn theo quy định của pháp luật.</p>

                            <h6>3. Quyền và trách nhiệm</h6>
                            <p>Người dùng có trách nhiệm bảo mật thông tin tài khoản của mình.</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Đã hiểu</button>
                        </div>
                    </div>
                </div>
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

                // Password strength checker
                $('#password').on('input', function () {
                    var password = $(this).val();
                    var strength = '';

                    if (password.length >= 6) {
                        var hasLetter = /[a-zA-Z]/.test(password);
                        var hasNumber = /[0-9]/.test(password);
                        var hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);

                        if (password.length >= 8 && hasLetter && hasNumber && hasSpecial) {
                            strength = 'strong';
                        } else if (password.length >= 6 && hasLetter && hasNumber) {
                            strength = 'medium';
                        } else {
                            strength = 'weak';
                        }
                    }

                    $('#passwordStrength').removeClass('weak medium strong').addClass(strength);
                });

                // Password match checker
                $('#confirmPassword').on('input', function () {
                    var password = $('#password').val();
                    var confirmPassword = $(this).val();

                    if (confirmPassword.length > 0) {
                        if (password === confirmPassword) {
                            $('#passwordMatch').html('<span class="text-success"><i class="fas fa-check"></i> Mật khẩu khớp</span>');
                        } else {
                            $('#passwordMatch').html('<span class="text-danger"><i class="fas fa-times"></i> Mật khẩu không khớp</span>');
                        }
                    } else {
                        $('#passwordMatch').html('');
                    }
                });

                // Form validation
                $('#registerForm').on('submit', function (e) {
                    var password = $('#password').val();
                    var confirmPassword = $('#confirmPassword').val();
                    var username = $('#username').val().trim();

                    // Check username pattern
                    if (!/^[a-zA-Z0-9_]+$/.test(username)) {
                        e.preventDefault();
                        alert('Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới');
                        $('#username').focus();
                        return false;
                    }

                    // Check password match
                    if (password !== confirmPassword) {
                        e.preventDefault();
                        alert('Mật khẩu xác nhận không khớp');
                        $('#confirmPassword').focus();
                        return false;
                    }

                    // Check password length
                    if (password.length < 6) {
                        e.preventDefault();
                        alert('Mật khẩu phải có ít nhất 6 ký tự');
                        $('#password').focus();
                        return false;
                    }
                });
            </script>
        </body>

        </html>