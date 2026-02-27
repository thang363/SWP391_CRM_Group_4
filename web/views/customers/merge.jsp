<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <% request.setAttribute("currentPage", "customers" ); %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>Gộp Hồ Sơ Khách Hàng - CRM System</title>
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

                        <%-- Include Sidebar --%>
                            <%@ include file="/includes/sidebar.jsp" %>

                                <!-- Content Start -->
                                <div class="content">
                                    <%-- Include Top Navbar --%>
                                        <%@ include file="/includes/topbar.jsp" %>

                                            <!-- Main Content Start -->
                                            <div class="container-fluid pt-4 px-4">
                                                <div class="row g-4">
                                                    <div class="col-sm-12 col-xl-8 mx-auto">
                                                        <div class="bg-light rounded h-100 p-4">
                                                            <div
                                                                class="d-flex justify-content-between align-items-center mb-4">
                                                                <h4 class="mb-0">Gộp Hồ Sơ Khách Hàng</h4>
                                                                <a href="${pageContext.request.contextPath}/customers"
                                                                    class="btn btn-secondary"><i
                                                                        class="fa fa-arrow-left me-2"></i>Trở lại</a>
                                                            </div>

                                                            <div class="alert alert-warning">
                                                                <i class="fa fa-exclamation-triangle me-2"></i>
                                                                <strong>Cảnh báo:</strong> Việc gộp hồ sơ sẽ chuyển toàn
                                                                bộ dữ liệu (cơ hội, liên hệ, vé hỗ trợ) từ <em>Hồ sơ bị
                                                                    gộp (Duplicate)</em> sang <em>Hồ sơ chính
                                                                    (Primary)</em> và <strong>XÓA</strong> vĩnh viễn hồ
                                                                sơ bị gộp. Thao tác này không thể hoàn tác.
                                                            </div>

                                                            <form
                                                                action="${pageContext.request.contextPath}/customers?action=merge"
                                                                method="POST" onsubmit="return validateMerge()">
                                                                <div class="row mb-4">
                                                                    <div class="col-md-6 border-end">
                                                                        <h6 class="text-primary mb-3">Hồ Sơ Chính
                                                                            (Primary)</h6>
                                                                        <p class="text-muted small">Hồ sơ sẽ được giữ
                                                                            lại.</p>
                                                                        <select id="primaryCustomer" name="primaryId"
                                                                            class="form-select" required>
                                                                            <option value="">-- Chọn khách hàng chính --
                                                                            </option>
                                                                            <c:forEach var="cust"
                                                                                items="${allCustomers}">
                                                                                <option value="${cust.id}">[ID:
                                                                                    ${cust.id}] ${cust.companyName} -
                                                                                    ${cust.phone} - ${cust.email}
                                                                                </option>
                                                                            </c:forEach>
                                                                        </select>
                                                                    </div>
                                                                    <div class="col-md-6">
                                                                        <h6 class="text-danger mb-3">Hồ Sơ Cần Gộp
                                                                            (Duplicate)</h6>
                                                                        <p class="text-muted small">Hồ sơ này sẽ bị xóa
                                                                            khỏi hệ thống.</p>
                                                                        <select id="duplicateCustomer"
                                                                            name="duplicateId" class="form-select"
                                                                            required>
                                                                            <option value="">-- Chọn khách hàng bị xoá
                                                                                --</option>
                                                                            <c:forEach var="cust"
                                                                                items="${allCustomers}">
                                                                                <option value="${cust.id}">[ID:
                                                                                    ${cust.id}] ${cust.companyName} -
                                                                                    ${cust.phone} - ${cust.email}
                                                                                </option>
                                                                            </c:forEach>
                                                                        </select>
                                                                    </div>
                                                                </div>
                                                                <div class="text-center mt-4">
                                                                    <button type="submit" class="btn btn-danger px-5"><i
                                                                            class="fa fa-compress-alt me-2"></i>Tiến
                                                                        Hành Gộp</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Main Content End -->

                                            <%-- Include Footer --%>
                                                <%@ include file="/includes/footer.jsp" %>
                                </div>
                                <!-- Content End -->

                                <!-- Back to Top -->
                                <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                        class="bi bi-arrow-up"></i></a>
                    </div>

                    <%-- Include Scripts --%>
                        <%@ include file="/includes/scripts.jsp" %>
                            <script>
                                document.addEventListener('DOMContentLoaded', function () {
                                    var spinner = document.getElementById('spinner');
                                    if (spinner) {
                                        spinner.classList.remove('show');
                                    }
                                });

                                function validateMerge() {
                                    var primary = document.getElementById('primaryCustomer').value;
                                    var duplicate = document.getElementById('duplicateCustomer').value;

                                    if (primary === duplicate) {
                                        alert('Không thể gộp cùng một hồ sơ! Vui lòng chọn hai hồ sơ khách hàng khác nhau.');
                                        return false;
                                    }
                                    return confirm('Bạn có TỰ TIN MƯỜI MƯƠI là muốn gộp hai hồ sơ này không? Hành động CỰC KỲ NGUY HIỂM và KHÔNG THỂ HOÀN TÁC!');
                                }
                            </script>
                </body>

                </html>