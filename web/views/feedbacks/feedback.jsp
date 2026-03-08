<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đánh Giá Chất Lượng Dịch Vụ</title>
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
            }

            .stars i {
                font-size: 2.5rem;
                color: #dee2e6;
                cursor: pointer;
                transition: color 0.2s;
                margin: 0 4px;
            }

            .stars i.active,
            .stars i.hover {
                color: #ffc107;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <div class="card rating-card p-4">
                <div class="text-center">
                    <i class="fa fa-gem text-primary" style="font-size: 3rem; margin-bottom: 15px;"></i>
                    <h4 class="fw-bold mb-1">Cảm ơn bạn đã đồng hành!</h4>
                    <p class="text-muted small">Xin hãy dành 1 phút để đánh giá trải nghiệm của bạn</p>
                </div>

                <form action="${pageContext.request.contextPath}/feedback" method="POST" id="feedbackForm">
                    <input type="hidden" name="token" value="${token}">
                    <input type="hidden" id="serviceRatingInput" name="serviceRating" required>
                    <input type="hidden" id="staffRatingInput" name="staffRating" required>

                    <div class="mb-4 mt-4 text-center">
                        <label class="form-label fw-semibold" style="font-size: 1.1rem;">Bạn đánh giá chất lượng dịch vụ
                            chung thế nào?</label><br>
                        <div class="stars" id="serviceStars" data-target="serviceRatingInput">
                            <i class="fa fa-star" data-value="1"></i>
                            <i class="fa fa-star" data-value="2"></i>
                            <i class="fa fa-star" data-value="3"></i>
                            <i class="fa fa-star" data-value="4"></i>
                            <i class="fa fa-star" data-value="5"></i>
                        </div>
                        <div class="text-danger small d-none mt-1" id="serviceError">Vui lòng chọn số sao.</div>
                    </div>

                    <div class="mb-4 text-center">
                        <label class="form-label fw-semibold" style="font-size: 1.1rem;">Thái độ hỗ trợ của Nhân
                            viên?</label><br>
                        <div class="stars" id="staffStars" data-target="staffRatingInput">
                            <i class="fa fa-star" data-value="1"></i>
                            <i class="fa fa-star" data-value="2"></i>
                            <i class="fa fa-star" data-value="3"></i>
                            <i class="fa fa-star" data-value="4"></i>
                            <i class="fa fa-star" data-value="5"></i>
                        </div>
                        <div class="text-danger small d-none mt-1" id="staffError">Vui lòng chọn số sao.</div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Góp ý thêm (Tùy chọn)</label>
                        <textarea class="form-control" name="comment" rows="3"
                            placeholder="Chia sẻ chi tiết hơn về trải nghiệm của bạn..."></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-3 fw-bold" onclick="return validateForm()">GỬI
                        ĐÁNH GIÁ</button>
                </form>
            </div>
        </div>

        <script>
            document.querySelectorAll('.stars').forEach(container => {
                const stars = container.querySelectorAll('i');
                const hiddenInput = document.getElementById(container.dataset.target);

                stars.forEach(star => {
                    star.addEventListener('mouseover', function () {
                        const val = this.dataset.value;
                        stars.forEach(s => {
                            if (s.dataset.value <= val) s.classList.add('hover');
                            else s.classList.remove('hover');
                        });
                    });

                    star.addEventListener('mouseout', function () {
                        stars.forEach(s => s.classList.remove('hover'));
                    });

                    star.addEventListener('click', function () {
                        const val = this.dataset.value;
                        hiddenInput.value = val;
                        stars.forEach(s => {
                            if (s.dataset.value <= val) s.classList.add('active');
                            else s.classList.remove('active');
                        });
                    });
                });
            });

            function validateForm() {
                let valid = true;
                if (!document.getElementById('serviceRatingInput').value) {
                    document.getElementById('serviceError').classList.remove('d-none');
                    valid = false;
                } else {
                    document.getElementById('serviceError').classList.add('d-none');
                }
                if (!document.getElementById('staffRatingInput').value) {
                    document.getElementById('staffError').classList.remove('d-none');
                    valid = false;
                } else {
                    document.getElementById('staffError').classList.add('d-none');
                }
                return valid;
            }
        </script>
    </body>

    </html>