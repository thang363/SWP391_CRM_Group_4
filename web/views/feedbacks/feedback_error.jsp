<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Lỗi Yêu Cầu Đánh Giá</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <style>
                body {
                    background-color: #f8f9fa;
                }

                .rating-card {
                    max-width: 500px;
                    margin: 50px auto;
                    border-radius: 12px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                    border: none;
                    text-align: center;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="card rating-card p-5">
                    <i class="fa fa-exclamation-triangle text-warning mb-3" style="font-size: 5rem;"></i>
                    <h3 class="fw-bold mb-3">Rất Tiếc!</h3>
                    <p class="text-muted mb-4" style="font-size: 1.1rem;">
                        ${error != null ? error : 'Đường dẫn đánh giá không hợp lệ hoặc đã hết hạn truy cập.'}
                    </p>
                </div>
            </div>
        </body>

        </html>