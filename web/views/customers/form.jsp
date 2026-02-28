<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <% request.setAttribute("currentPage", "customers" ); %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>${customer != null ? 'Sửa' : 'Thêm mới'} Khách hàng - CRM</title>
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
                                                    <div class="col-sm-12 col-xl-12 mx-auto">
                                                        <div class="bg-light rounded h-100 p-4">
                                                            <div
                                                                class="d-flex justify-content-between align-items-center mb-4">
                                                                <h4 class="mb-0">${customer != null ? 'Sửa thông tin
                                                                    Khách hàng' : 'Thêm Khách hàng mới'}</h4>
                                                                <a href="${pageContext.request.contextPath}/customers"
                                                                    class="btn btn-secondary"><i
                                                                        class="fa fa-arrow-left me-2"></i>Trở lại</a>
                                                            </div>

                                                            <form action="${pageContext.request.contextPath}/customers"
                                                                method="POST">
                                                                <input type="hidden" name="action"
                                                                    value="${customer != null ? 'edit' : 'create'}">
                                                                <c:if test="${customer != null}">
                                                                    <input type="hidden" name="id"
                                                                        value="${customer.id}">

                                                                    <!-- Keep existing values for fields not in form -->
                                                                    <input type="hidden" name="shippingAddress"
                                                                        value="${customer.shippingAddress}">
                                                                    <input type="hidden" name="foundedDate"
                                                                        value="${customer.foundedDate}">
                                                                </c:if>

                                                                <div class="row">
                                                                    <!-- Cột Trái -->
                                                                    <div class="col-md-6">
                                                                        <div class="row mb-3">
                                                                            <label
                                                                                class="col-sm-4 col-form-label text-nowrap">Tên
                                                                                Khách Hàng <span
                                                                                    class="text-danger">*</span></label>
                                                                            <div class="col-sm-8">
                                                                                <input type="text" class="form-control"
                                                                                    name="companyName"
                                                                                    value="${customer.companyName}"
                                                                                    required>
                                                                            </div>
                                                                        </div>

                                                                        <div class="row mb-3">
                                                                            <label
                                                                                class="col-sm-4 col-form-label text-nowrap">Mã
                                                                                Số
                                                                                Thuế</label>
                                                                            <div class="col-sm-8">
                                                                                <input type="text" class="form-control"
                                                                                    name="taxCode"
                                                                                    value="${customer.taxCode}">
                                                                            </div>
                                                                        </div>

                                                                        <div class="row mb-3">
                                                                            <label
                                                                                class="col-sm-4 col-form-label text-nowrap">Email
                                                                                <span
                                                                                    class="text-danger">*</span></label>
                                                                            <div class="col-sm-8">
                                                                                <input type="email" class="form-control"
                                                                                    name="email"
                                                                                    value="${customer.email}" required>
                                                                            </div>
                                                                        </div>

                                                                        <div class="row mb-3">
                                                                            <label
                                                                                class="col-sm-4 col-form-label text-nowrap">Số
                                                                                Điện Thoại <span
                                                                                    class="text-danger">*</span></label>
                                                                            <div class="col-sm-8">
                                                                                <input type="text" class="form-control"
                                                                                    name="phone"
                                                                                    value="${customer.phone}" required>
                                                                            </div>
                                                                        </div>

                                                                        <div class="row mb-3">
                                                                            <label
                                                                                class="col-sm-4 col-form-label text-nowrap">Website</label>
                                                                            <div class="col-sm-8">
                                                                                <input type="text" class="form-control"
                                                                                    name="website"
                                                                                    value="${customer.website}">
                                                                            </div>
                                                                        </div>

                                                                        <div class="row mb-3">
                                                                            <label
                                                                                class="col-sm-4 col-form-label text-nowrap">Ngành
                                                                                Nghề</label>
                                                                            <div class="col-sm-8">
                                                                                <input type="text" class="form-control"
                                                                                    name="industry"
                                                                                    value="${customer.industry}">
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                    <!-- Cột Phải -->
                                                                    <div class="col-md-6">
                                                                        <div class="row mb-3">
                                                                            <label
                                                                                class="col-sm-4 col-form-label text-nowrap">Nhân
                                                                                Sự</label>
                                                                            <div class="col-sm-8">
                                                                                <input type="number"
                                                                                    class="form-control"
                                                                                    name="numberOfEmployees"
                                                                                    value="${customer.numberOfEmployees}">
                                                                            </div>
                                                                        </div>

                                                                        <div class="row mb-3">
                                                                            <label
                                                                                class="col-sm-4 col-form-label text-nowrap">Thành
                                                                                Phố <span
                                                                                    class="text-danger">*</span></label>
                                                                            <div class="col-sm-8">
                                                                                <input type="text" class="form-control"
                                                                                    name="city" value="${customer.city}"
                                                                                    required>
                                                                            </div>
                                                                        </div>

                                                                        <div class="row mb-3">
                                                                            <label
                                                                                class="col-sm-4 col-form-label text-nowrap">Quốc
                                                                                Gia <span
                                                                                    class="text-danger">*</span></label>
                                                                            <div class="col-sm-8">
                                                                                <input type="text" class="form-control"
                                                                                    name="country"
                                                                                    value="${customer.country != null ? customer.country : 'Vietnam'}"
                                                                                    required>
                                                                            </div>
                                                                        </div>

                                                                        <div class="row mb-3">
                                                                            <label
                                                                                class="col-sm-4 col-form-label text-nowrap">Địa
                                                                                Chỉ Hóa Đơn <span
                                                                                    class="text-danger">*</span></label>
                                                                            <div class="col-sm-8">
                                                                                <textarea class="form-control"
                                                                                    name="billingAddress" rows="1"
                                                                                    required>${customer.billingAddress}</textarea>
                                                                            </div>
                                                                        </div>

                                                                        <div class="row mb-3">
                                                                            <label
                                                                                class="col-sm-4 col-form-label text-nowrap">Tier
                                                                                <span
                                                                                    class="text-danger">*</span></label>
                                                                            <div class="col-sm-8">
                                                                                <select name="tier" class="form-select"
                                                                                    required>
                                                                                    <option value="Standard"
                                                                                        ${customer.tier=='Standard'
                                                                                        ? 'selected' : '' }>Standard
                                                                                    </option>
                                                                                    <option value="VIP"
                                                                                        ${customer.tier=='VIP'
                                                                                        ? 'selected' : '' }>VIP</option>
                                                                                </select>
                                                                            </div>
                                                                        </div>

                                                                        <div class="row mb-3">
                                                                            <label
                                                                                class="col-sm-4 col-form-label text-nowrap">Trạng
                                                                                Thái <span
                                                                                    class="text-danger">*</span></label>
                                                                            <div class="col-sm-8">
                                                                                <select name="status"
                                                                                    class="form-select" required>
                                                                                    <option value="Active"
                                                                                        ${customer.status=='Active'
                                                                                        ? 'selected' : '' }>Active
                                                                                    </option>
                                                                                    <option value="Inactive"
                                                                                        ${customer.status=='Inactive'
                                                                                        ? 'selected' : '' }>Inactive
                                                                                    </option>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <div class="text-center mt-4 border-top pt-4">
                                                                    <button type="submit"
                                                                        class="btn btn-primary px-5"><i
                                                                            class="fa fa-save me-2"></i>Lưu Lại</button>
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
                            </script>
                </body>

                </html>