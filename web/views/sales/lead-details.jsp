<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <title>${pageTitle} - CRM System</title>
                <%@ include file="/includes/head.jsp" %>
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

                    <%@ include file="/includes/sidebar.jsp" %>

                        <div class="content">
                            <%@ include file="/includes/topbar.jsp" %>

                                <div class="container-fluid pt-4 px-4">
                                    <div class="row g-4">
                                        <!-- Left Column: Lead Info -->
                                        <div class="col-sm-12 col-xl-4">
                                            <div class="bg-light rounded h-100 p-4">
                                                <h4 class="mb-4">Thông tin Lead</h4>
                                                <div class="mb-3">
                                                    <label class="form-label fw-bold">Họ và Tên:</label>
                                                    <p class="form-control-plaintext">${lead.fullName}</p>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label fw-bold">Email:</label>
                                                    <p class="form-control-plaintext">${lead.email}</p>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label fw-bold">Số điện thoại:</label>
                                                    <p class="form-control-plaintext">${lead.phone}</p>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label fw-bold">Trạng thái:</label>
                                                    <p>
                                                        <span
                                                            class="badge ${lead.status == 'New' ? 'bg-info' : 'bg-primary'}">${lead.status}</span>
                                                        <c:if test="${lead.isConverted}">
                                                            <span class="badge bg-success">Converted</span>
                                                        </c:if>
                                                    </p>
                                                </div>
                                                <div class="d-grid gap-2">
                                                    <c:if test="${!lead.isConverted}">
                                                        <button class="btn btn-success" type="button"
                                                            onclick="convertLead(${lead.id})">
                                                            <i class="fa fa-arrow-right me-2"></i>Convert to Opportunity
                                                        </button>
                                                    </c:if>
                                                    <button class="btn btn-outline-primary" type="button">Edit
                                                        Info</button>
                                                    <button class="btn btn-outline-danger" type="button">Delete</button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Right Column: Timeline & Activities -->
                                        <div class="col-sm-12 col-xl-8">
                                            <div class="bg-light rounded h-100 p-4">
                                                <div class="d-flex justify-content-between align-items-center mb-4">
                                                    <h4 class="mb-0">Lịch sử tương tác</h4>
                                                    <button class="btn btn-sm btn-primary"><i
                                                            class="fa fa-plus me-2"></i>Thêm Ghi chú</button>
                                                </div>

                                                <div class="timeline">
                                                    <c:forEach items="${timeline}" var="item">
                                                        <div class="alert alert-light border-start border-3 border-primary"
                                                            role="alert">
                                                            <i class="fa fa-history me-2 text-primary"></i> ${item}
                                                        </div>
                                                    </c:forEach>
                                                    <div class="alert alert-secondary border-start border-3 border-secondary"
                                                        role="alert">
                                                        <i class="fa fa-user-plus me-2"></i> Lead created on
                                                        <fmt:parseDate value="${lead.createdAt}"
                                                            pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate"
                                                            type="both" />
                                                        <fmt:formatDate pattern="dd/MM/yyyy HH:mm"
                                                            value="${parsedDate}" />
                                                    </div>
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

                <%@ include file="/includes/scripts.jsp" %>
                    <script>
                        function convertLead(id) {
                            showConfirmDialog(
                                'Bạn có chắc chắn muốn chuyển đổi Lead này thành Opportunity không?',
                                function () {
                                    // TODO: Call API to convert
                                    alert('Tính năng đang phát triển!');
                                },
                                { title: 'Chuyển đổi Lead', confirmText: 'Chuyển đổi', confirmClass: 'btn-success' }
                            );
                        }
                    </script>
            </body>

            </html>