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
                                                    <div class="col-sm-12 col-xl-8 mx-auto">
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
                                                                </c:if>

                                                                <div class="row mb-3">
                                                                    <label class="col-sm-3 col-form-label">Tên Công Ty /
                                                                        Cá Nhân <span
                                                                            class="text-danger">*</span></label>
                                                                    <div class="col-sm-9">
                                                                        <input type="text" class="form-control"
                                                                            name="companyName"
                                                                            value="${customer.companyName}" required>
                                                                    </div>
                                                                </div>

                                                                <div class="row mb-3">
                                                                    <label class="col-sm-3 col-form-label">Mã Số
                                                                        Thuế</label>
                                                                    <div class="col-sm-9">
                                                                        <input type="text" class="form-control"
                                                                            name="taxCode" value="${customer.taxCode}">
                                                                    </div>
                                                                </div>

                                                                <div class="row mb-3">
                                                                    <label class="col-sm-3 col-form-label">Email</label>
                                                                    <div class="col-sm-9">
                                                                        <input type="email" class="form-control"
                                                                            name="email" value="${customer.email}">
                                                                    </div>
                                                                </div>

                                                                <div class="row mb-3">
                                                                    <label class="col-sm-3 col-form-label">Số Điện
                                                                        Thoại</label>
                                                                    <div class="col-sm-9">
                                                                        <input type="text" class="form-control"
                                                                            name="phone" value="${customer.phone}">
                                                                    </div>
                                                                </div>

                                                                <div class="row mb-3">
                                                                    <label
                                                                        class="col-sm-3 col-form-label">Website</label>
                                                                    <div class="col-sm-9">
                                                                        <input type="text" class="form-control"
                                                                            name="website" value="${customer.website}">
                                                                    </div>
                                                                </div>

                                                                <div class="row mb-3">
                                                                    <label class="col-sm-3 col-form-label">Ngành
                                                                        Nghề</label>
                                                                    <div class="col-sm-9">
                                                                        <input type="text" class="form-control"
                                                                            name="industry"
                                                                            value="${customer.industry}">
                                                                    </div>
                                                                </div>

                                                                <div class="row mb-3">
                                                                    <label class="col-sm-3 col-form-label">Nhân Sự (Số
                                                                        lượng)</label>
                                                                    <div class="col-sm-9">
                                                                        <input type="number" class="form-control"
                                                                            name="numberOfEmployees"
                                                                            value="${customer.numberOfEmployees}">
                                                                    </div>
                                                                </div>

                                                                <div class="row mb-3">
                                                                    <label class="col-sm-3 col-form-label">Thành
                                                                        Phố</label>
                                                                    <div class="col-sm-9">
                                                                        <input type="text" class="form-control"
                                                                            name="city" value="${customer.city}">
                                                                    </div>
                                                                </div>

                                                                <div class="row mb-3">
                                                                    <label class="col-sm-3 col-form-label">Quốc
                                                                        Gia</label>
                                                                    <div class="col-sm-9">
                                                                        <input type="text" class="form-control"
                                                                            name="country"
                                                                            value="${customer.country != null ? customer.country : 'Vietnam'}">
                                                                    </div>
                                                                </div>

                                                                <div class="row mb-3">
                                                                    <label class="col-sm-3 col-form-label">Địa Chỉ Hóa
                                                                        Đơn</label>
                                                                    <div class="col-sm-9">
                                                                        <textarea class="form-control"
                                                                            name="billingAddress"
                                                                            rows="2">${customer.billingAddress}</textarea>
                                                                    </div>
                                                                </div>

                                                                <div class="row mb-3">
                                                                    <label class="col-sm-3 col-form-label">Tier</label>
                                                                    <div class="col-sm-9">
                                                                        <select name="tier" class="form-select">
                                                                            <option value="Standard"
                                                                                ${customer.tier=='Standard' ? 'selected'
                                                                                : '' }>Standard</option>
                                                                            <option value="VIP" ${customer.tier=='VIP'
                                                                                ? 'selected' : '' }>VIP</option>
                                                                            <option value="VVIP" ${customer.tier=='VVIP'
                                                                                ? 'selected' : '' }>VVIP</option>
                                                                        </select>
                                                                    </div>
                                                                </div>

                                                                <div class="row mb-3">
                                                                    <label class="col-sm-3 col-form-label">Trạng
                                                                        Thái</label>
                                                                    <div class="col-sm-9">
                                                                        <select name="status" class="form-select">
                                                                            <option value="Active"
                                                                                ${customer.status=='Active' ? 'selected'
                                                                                : '' }>Active</option>
                                                                            <option value="Inactive"
                                                                                ${customer.status=='Inactive'
                                                                                ? 'selected' : '' }>Inactive</option>
                                                                            <option value="Churned"
                                                                                ${customer.status=='Churned'
                                                                                ? 'selected' : '' }>Churned</option>
                                                                        </select>
                                                                    </div>
                                                                </div>

                                                                <div class="text-center mt-4">
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