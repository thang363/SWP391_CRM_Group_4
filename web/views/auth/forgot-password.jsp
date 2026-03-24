<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <title>Quên mật khẩu - CRM System</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="CRM, Forgot Password, Quên mật khẩu" name="keywords">
    <meta content="Lấy lại mật khẩu hệ thống CRM" name="description">

    <!-- Favicon -->
    <link href="${pageContext.request.contextPath}/img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">

    <style>
        .step-container {
            display: none;
        }
        .step-active {
            display: block;
            animation: fadeIn 0.5s;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
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

        <!-- Sign In Start -->
        <div class="container-fluid">
            <div class="row h-100 align-items-center justify-content-center" style="min-height: 100vh;">
                <div class="col-12 col-sm-8 col-md-6 col-lg-5 col-xl-4">
                    <div class="bg-light rounded p-4 p-sm-5 my-4 mx-3">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <a href="${pageContext.request.contextPath}/">
                                <h3 class="text-primary"><i class="fa fa-users me-2"></i>CRM</h3>
                            </a>
                            <h3>Quên mật khẩu</h3>
                        </div>

                        <!-- Error/Success Alerts -->
                        <div id="alertMessage" class="alert d-none" role="alert"></div>

                        <!-- Step 1: Input Email -->
                        <div id="step-email" class="step-container step-active">
                            <p class="mb-4">Vui lòng nhập địa chỉ email đã đăng ký tài khoản của bạn. Chúng tôi sẽ gửi mã OTP đến email này.</p>
                            <form id="formEmail" onsubmit="event.preventDefault(); sendOtp();">
                                <div class="form-floating mb-3">
                                    <input type="email" class="form-control" id="email" required placeholder="name@example.com">
                                    <label for="email">Địa chỉ Email</label>
                                </div>
                                <button type="submit" id="btnSendOtp" class="btn btn-primary py-3 w-100 mb-4">Gửi mã OTP</button>
                                <p class="text-center mb-0">
                                    <a href="${pageContext.request.contextPath}/login"><i class="fa fa-arrow-left me-2"></i>Quay lại đăng nhập</a>
                                </p>
                            </form>
                        </div>

                        <!-- Step 2: Input OTP -->
                        <div id="step-otp" class="step-container">
                            <p class="mb-4 text-success" id="otpSentMsg">Mã OTP đã được gửi. Vui lòng kiểm tra hộp thư của bạn.</p>
                            <form id="formOtp" onsubmit="event.preventDefault(); verifyOtp();">
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control" id="otp" required placeholder="Nhập mã 6 chữ số" maxlength="6">
                                    <label for="otp">Mã OTP</label>
                                </div>
                                <button type="submit" id="btnVerifyOtp" class="btn btn-primary py-3 w-100 mb-4">Xác nhận OTP</button>
                                <p class="text-center mb-0">
                                    Chưa nhận được mã? <a href="#" onclick="event.preventDefault(); sendOtp();">Gửi lại</a>
                                </p>
                            </form>
                        </div>

                        <!-- Step 3: Input New Password -->
                        <div id="step-password" class="step-container">
                            <p class="mb-4">Xác thực thành công. Vui lòng tạo mật khẩu mới cho tài khoản của bạn.</p>
                            <form id="formPassword" onsubmit="event.preventDefault(); resetPassword();">
                                <div class="form-floating mb-3">
                                    <input type="password" class="form-control" id="newPassword" required placeholder="Mật khẩu mới">
                                    <label for="newPassword">Mật khẩu mới</label>
                                </div>
                                <div class="form-floating mb-4">
                                    <input type="password" class="form-control" id="confirmNewPassword" required placeholder="Xác nhận mật khẩu">
                                    <label for="confirmNewPassword">Xác nhận mật khẩu</label>
                                </div>
                                <button type="submit" id="btnResetPassword" class="btn btn-primary py-3 w-100 mb-4">Đổi mật khẩu</button>
                            </form>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <!-- Sign In End -->
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Template Javascript -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>

    <script>
        const API_URL = '${pageContext.request.contextPath}/forgot-password';

        function showAlert(msg, isSuccess) {
            const alertBox = $('#alertMessage');
            alertBox.removeClass('d-none alert-success alert-danger');
            alertBox.addClass(isSuccess ? 'alert-success' : 'alert-danger');
            alertBox.html(msg);
        }

        function switchStep(stepId) {
            $('.step-container').removeClass('step-active');
            $('#' + stepId).addClass('step-active');
            $('#alertMessage').addClass('d-none');
        }

        function disableBtn(btnId, loadingText) {
            const btn = $('#' + btnId);
            btn.data('original-text', btn.html());
            btn.prop('disabled', true);
            btn.html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> ' + loadingText);
        }

        function enableBtn(btnId) {
            const btn = $('#' + btnId);
            btn.prop('disabled', false);
            btn.html(btn.data('original-text'));
        }

        function sendOtp() {
            const email = $('#email').val().trim();
            if(!email) return;

            disableBtn('btnSendOtp', 'Đang gửi...');
            
            $.post(API_URL, { action: 'send-otp', email: email }, function(response) {
                enableBtn('btnSendOtp');
                if (response.success) {
                    showAlert(response.message, true);
                    switchStep('step-otp');
                } else {
                    showAlert(response.message, false);
                }
            }).fail(function() {
                enableBtn('btnSendOtp');
                showAlert('Lỗi kết nối đến máy chủ. Vui lòng thử lại.', false);
            });
        }

        function verifyOtp() {
            const otp = $('#otp').val().trim();
            if(!otp) return;

            disableBtn('btnVerifyOtp', 'Đang xác thực...');
            
            $.post(API_URL, { action: 'verify-otp', otp: otp }, function(response) {
                enableBtn('btnVerifyOtp');
                if (response.success) {
                    showAlert(response.message, true);
                    switchStep('step-password');
                } else {
                    showAlert(response.message, false);
                }
            }).fail(function() {
                enableBtn('btnVerifyOtp');
                showAlert('Lỗi kết nối đến máy chủ. Vui lòng thử lại.', false);
            });
        }

        function resetPassword() {
            const newPassword = $('#newPassword').val();
            const confirmNewPassword = $('#confirmNewPassword').val();

            if (newPassword !== confirmNewPassword) {
                showAlert('Mật khẩu xác nhận không khớp.', false);
                return;
            }

            disableBtn('btnResetPassword', 'Đang xử lý...');

            $.post(API_URL, { action: 'reset-password', newPassword: newPassword }, function(response) {
                enableBtn('btnResetPassword');
                if (response.success) {
                    $('#step-password').html(
                        '<div class="text-center"><i class="fa fa-spinner fa-spin fa-4x text-primary mb-3"></i><p class="mb-4 text-success">' + response.message + '</p></div>'
                    );
                    $('#alertMessage').addClass('d-none');
                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/dashboard';
                    }, 1500);
                } else {
                    showAlert(response.message, false);
                }
            }).fail(function() {
                enableBtn('btnResetPassword');
                showAlert('Lỗi kết nối đến máy chủ. Vui lòng thử lại.', false);
            });
        }
    </script>
</body>
</html>
