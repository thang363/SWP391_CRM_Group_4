<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <title>Quản lý Leads - CRM</title>
                <meta content="width=device-width, initial-scale=1.0" name="viewport">

                <jsp:include page="/includes/header.jsp" />
            </head>

            <body>
                <div class="container-xxl position-relative bg-white d-flex p-0">

                    <jsp:include page="/includes/sidebar.jsp" />

                    <!-- Content Start -->
                    <div class="content">

                        <jsp:include page="/includes/navbar.jsp" />

                        <!-- Leads Management Area -->
                        <div class="container-fluid pt-4 px-4">
                            <div class="bg-light text-center rounded p-4">
                                <div class="d-flex align-items-center justify-content-between mb-4">
                                    <h6 class="mb-0">Danh sách Leads </h6>
                                    <!-- Có thể để nút Add Lead sau này ở đây -->
                                    <a href="#" class="btn btn-sm btn-primary">Add Lead (Comming Soon)</a>
                                </div>

                                <%-- Display success/error messages --%>
                                    <c:if test="${not empty sessionScope.successMsg}">
                                        <div class="alert alert-success alert-dismissible fade show text-start"
                                            role="alert">
                                            ${sessionScope.successMsg}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                aria-label="Close"></button>
                                        </div>
                                        <c:remove var="successMsg" scope="session" />
                                    </c:if>
                                    <c:if test="${not empty sessionScope.errorMsg}">
                                        <div class="alert alert-danger alert-dismissible fade show text-start"
                                            role="alert">
                                            ${sessionScope.errorMsg}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                aria-label="Close"></button>
                                        </div>
                                        <c:remove var="errorMsg" scope="session" />
                                    </c:if>

                                    <div class="table-responsive">
                                        <table class="table text-start align-middle table-bordered table-hover mb-0">
                                            <thead>
                                                <tr class="text-dark">
                                                    <th scope="col">ID</th>
                                                    <th scope="col">Họ Tên</th>
                                                    <th scope="col">Email</th>
                                                    <th scope="col">SĐT</th>
                                                    <th scope="col">Trạng Thái</th>
                                                    <th scope="col">Điểm</th>
                                                    <th scope="col">Hành Động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty leads}">
                                                        <tr>
                                                            <td colspan="7" class="text-center">Không có dữ liệu</td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="lead" items="${leads}">
                                                            <tr>
                                                                <td>${lead.id}</td>
                                                                <td>${lead.fullName}</td>
                                                                <td>${lead.email}</td>
                                                                <td>${lead.phone}</td>
                                                                <td>
                                                                    <span class="badge bg-primary">${lead.status}</span>
                                                                </td>
                                                                <td>${lead.currentScore}</td>
                                                                <td>
                                                                    <a href="#" class="btn btn-sm btn-info disabled"
                                                                        title="Chi tiết">
                                                                        <i class="fa fa-eye"></i>
                                                                    </a>
                                                                    <button class="btn btn-sm btn-danger"
                                                                        onclick="confirmDelete(${lead.id})" title="Xoá">
                                                                        <i class="fa fa-trash"></i>
                                                                    </button>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                            </div>
                        </div>
                        <!-- Leads Management End -->

                        <jsp:include page="/includes/footer.jsp" />

                    </div>
                    <!-- Content End -->

                    <!-- Back to Top -->
                    <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                            class="bi bi-arrow-up"></i></a>
                </div>

                <!-- Scripts -->
                <jsp:include page="/includes/scripts.jsp" />

                <script>
                    function confirmDelete(id) {
                        if (confirm("Thao tác này sẽ xóa toàn bộ dữ liệu liên quan (lịch sử, tương tác...). Bạn có chắc chắn muốn xoá Lead ID = " + id + " không?")) {
                            window.location.href = "${pageContext.request.contextPath}/sales/leads?action=delete&id=" + id;
                        }
                    }
                </script>
            </body>

            </html>