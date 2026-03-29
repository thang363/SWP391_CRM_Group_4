<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <title>Import Leads - CRM</title>
            <meta content="width=device-width, initial-scale=1.0" name="viewport">
            <meta content="" name="keywords">
            <meta content="" name="description">

            <!-- Favicon -->
            <link href="img/favicon.ico" rel="icon">

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

                <!-- Sidebar Start -->
                <div class="sidebar pe-4 pb-3">
                    <nav class="navbar bg-light navbar-light">
                        <a href="index.html" class="navbar-brand mx-4 mb-3">
                            <h3 class="text-primary"><i class="fa fa-hashtag me-2"></i>DASHMIN</h3>
                        </a>
                        <div class="d-flex align-items-center ms-4 mb-4">
                            <div class="position-relative">
                                <img class="rounded-circle" src="${pageContext.request.contextPath}/img/user.jpg" alt=""
                                    style="width: 40px; height: 40px;">
                                <div
                                    class="bg-success rounded-circle border border-2 border-white position-absolute end-0 bottom-0 p-1">
                                </div>
                            </div>
                            <div class="ms-3">
                                <h6 class="mb-0">Jhon Doe</h6>
                                <span>Admin</span>
                            </div>
                        </div>
                        <div class="navbar-nav w-100">
                            <jsp:include page="../../includes/sidebar.jsp" />
                        </div>
                    </nav>
                </div>
                <!-- Sidebar End -->

                <!-- Content Start -->
                <div class="content">
                    <!-- Navbar Start -->
                    <nav class="navbar navbar-expand bg-light navbar-light sticky-top px-4 py-0">
                        <a href="index.html" class="navbar-brand d-flex d-lg-none me-4">
                            <h2 class="text-primary mb-0"><i class="fa fa-hashtag"></i></h2>
                        </a>
                        <a href="#" class="sidebar-toggler flex-shrink-0">
                            <i class="fa fa-bars"></i>
                        </a>

                        <div class="navbar-nav align-items-center ms-auto">
                            <jsp:include page="../../includes/topbar.jsp" />
                        </div>
                    </nav>
                    <!-- Navbar End -->

                    <!-- Import Start -->
                    <div class="container-fluid pt-4 px-4">
                        <div class="row g-4 justify-content-center">
                            <div class="col-sm-12 col-xl-8">
                                <div class="bg-light rounded h-100 p-4">
                                    <h4 class="mb-4">Nhập lead thô từ excel</h4>

                                    <c:if test="${not empty message}">
                                        <div class="alert alert-${messageType} alert-dismissible fade show"
                                            role="alert">
                                            <i class="fa fa-exclamation-circle me-2"></i>${message}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                aria-label="Close"></button>
                                        </div>
                                    </c:if>

                                    <form action="import-leads" method="post" enctype="multipart/form-data"
                                        id="importForm">
                                        <div class="mb-3">
                                            <label for="importFile" class="form-label">Chọn File CSV / Excel
                                                (.csv)</label>
                                            <input class="form-control" type="file" id="importFile" name="file"
                                                accept=".csv" required>
                                            <div class="form-text">
                                                Định dạng file: <strong>Họ tên, Email, SĐT</strong>. (Dòng đầu tiên có
                                                thể là tiêu đề).
                                                <br>
                                                <a href="#" onclick="downloadTemplate(event)">Tải file mẫu</a>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="campaignSelect" class="form-label">Chiến dịch (Campaign) <span
                                                    class="text-danger">*</span></label>
                                            <select class="form-select" id="campaignSelect" name="campaignId" required>
                                                <option value="">-- Chọn Chiến dịch --</option>
                                                <c:forEach var="campaign" items="${campaigns}">
                                                    <option value="${campaign.id}">${campaign.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label for="sourceInput" class="form-label">Nguồn dữ liệu</label>
                                            <input type="text" class="form-control" id="sourceInput" name="source"
                                                list="sourceOptions" placeholder="VD: Hội thảo Blockchain 2026...">
                                            <datalist id="sourceOptions">
                                                <c:forEach var="src" items="${sources}">
                                                    <option value="${src.name}">
                                                </c:forEach>
                                            </datalist>
                                            <div class="form-text">Nhập tên nguồn mới hoặc chọn từ danh sách. Nếu để
                                                trống sẽ lấy theo tên file.</div>
                                        </div>

                                        <button type="submit" class="btn btn-primary" id="btnUpload">
                                            <i class="fa fa-upload me-2"></i>Upload & Import
                                        </button>
                                        <a href="submissions" class="btn btn-outline-secondary ms-2">Hủy bỏ</a>
                                    </form>

                                    <!-- Loading Overlay (Initial Hidden) -->
                                    <div id="loadingOverlay" style="display:none; margin-top: 20px;">
                                        <div class="progress">
                                            <div class="progress-bar progress-bar-striped progress-bar-animated"
                                                role="progressbar" style="width: 100%">Processing...</div>
                                        </div>
                                        <p class="text-center mt-2">Đang xử lý file, vui lòng không tắt trình duyệt...
                                        </p>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Import End -->

                    <!-- Footer Start -->
                    <div class="container-fluid pt-4 px-4">
                        <div class="bg-light rounded-top p-4">
                            <div class="row">
                                <div class="col-12 col-sm-6 text-center text-sm-start">
                                    &copy; <a href="#">Your Site Name</a>, All Right Reserved.
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Footer End -->
                </div>
                <!-- Content End -->

                <!-- Back to Top -->
                <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>
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
                document.getElementById('importForm').addEventListener('submit', function () {
                    // Show loading
                    document.getElementById('btnUpload').disabled = true;
                    document.getElementById('loadingOverlay').style.display = 'block';
                });

                function downloadTemplate(e) {
                    e.preventDefault();
                    const csvContent = "data:text/csv;charset=utf-8," +
                        "Full Name,Email,Phone\n" +
                        "Nguyen Van A,nguyenvana@example.com,0987654321\n" +
                        "Tran Thi B,tranthib@example.com,0912345678";
                    const encodedUri = encodeURI(csvContent);
                    const link = document.createElement("a");
                    link.setAttribute("href", encodedUri);
                    link.setAttribute("download", "template_leads.csv");
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                }
            </script>
        </body>

        </html>