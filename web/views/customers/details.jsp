<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <% request.setAttribute("currentPage", "customers" ); %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>Chi tiết Khách hàng - CRM System</title>
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
                                                <div class="d-flex justify-content-between align-items-center mb-4">
                                                    <h4 class="mb-0">Chi tiết Khách hàng: ${customer.companyName}</h4>
                                                    <div class="d-flex gap-2">
                                                        <!-- Modal Trigger Button -->
                                                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#confirmFeedbackModal">
                                                            <i class="fa fa-envelope me-2"></i>Gửi Email Đánh Giá
                                                        </button>

                                                        <!-- Confirmation Modal -->
                                                        <div class="modal fade" id="confirmFeedbackModal" tabindex="-1" aria-labelledby="confirmFeedbackModalLabel" aria-hidden="true">
                                                            <div class="modal-dialog">
                                                                <div class="modal-content text-start">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title" id="confirmFeedbackModalLabel">Xác nhận gửi Email</h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <p>Bạn có chắc chắn muốn gửi Email yêu cầu đánh giá cho khách hàng này không?</p>
                                                                        <p class="mb-0"><strong>Email nhận:</strong> <span class="text-primary">${customer.email != null && !customer.email.isEmpty() ? customer.email : 'Khách hàng chưa cập nhật email (Không thể gửi)'}</span></p>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <form action="${pageContext.request.contextPath}/customers" method="post" class="m-0">
                                                                            <input type="hidden" name="action" value="sendFeedbackRequest">
                                                                            <input type="hidden" name="id" value="${customer.id}">
                                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                                            <button type="submit" class="btn btn-primary" ${empty customer.email ? 'disabled' : ''}>Xác nhận gửi</button>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <a href="${pageContext.request.contextPath}/customers?action=history&id=${customer.id}"
                                                            class="btn btn-info text-white"><i
                                                                class="fa fa-history me-2"></i>Lịch sử Tương tác</a>
                                                        <a href="${pageContext.request.contextPath}/customers?action=edit&id=${customer.id}"
                                                            class="btn btn-warning"><i
                                                                class="fa fa-edit me-2"></i>Sửa</a>
                                                        <a href="${pageContext.request.contextPath}/customers"
                                                            class="btn btn-secondary"><i
                                                                class="fa fa-arrow-left me-2"></i>Trở lại</a>
                                                    </div>
                                                </div>

                                                <c:if test="${param.success == 'feedback_sent'}">
                                                    <div class="alert alert-success alert-dismissible fade show"
                                                        role="alert">
                                                        Gửi email yêu cầu đánh giá thành công!
                                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                            aria-label="Close"></button>
                                                    </div>
                                                </c:if>

                                                <div class="row g-4">
                                                    <div class="col-sm-12 col-xl-6">
                                                        <div class="bg-light rounded h-100 p-4">
                                                            <h6 class="mb-4">Thông Tin Cơ Bản</h6>
                                                            <table class="table table-borderless">
                                                                <tbody>
                                                                    <tr>
                                                                        <th scope="row" style="width: 40%;">Tên Khách
                                                                            Hàng</th>
                                                                        <td>${customer.companyName}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th scope="row">Mã Số Thuế</th>
                                                                        <td>${customer.taxCode != null ?
                                                                            customer.taxCode : '-'}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th scope="row">Trạng Thái</th>
                                                                        <td>
                                                                            <span
                                                                                class="badge ${customer.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
                                                                                ${customer.status}
                                                                            </span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th scope="row">Tier</th>
                                                                        <td>
                                                                            <span
                                                                                class="badge ${customer.tier == 'VIP' ? 'bg-warning' : (customer.tier == 'VVIP' ? 'bg-danger' : 'bg-primary')}">
                                                                                ${customer.tier}
                                                                            </span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th scope="row">Ngành Nghề</th>
                                                                        <td>${customer.industry != null ?
                                                                            customer.industry : '-'}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th scope="row">Quy Mô Nhân Sự</th>
                                                                        <td>${customer.numberOfEmployees != null ?
                                                                            customer.numberOfEmployees : '-'}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th scope="row">Ngày Thành Lập</th>
                                                                        <td>${customer.foundedDate != null ?
                                                                            customer.foundedDate : '-'}</td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>

                                                    <div class="col-sm-12 col-xl-6">
                                                        <div class="bg-light rounded h-100 p-4">
                                                            <h6 class="mb-4">Thông Tin Liên Hệ</h6>
                                                            <table class="table table-borderless">
                                                                <tbody>
                                                                    <tr>
                                                                        <th scope="row" style="width: 40%;">Email</th>
                                                                        <td>${customer.email != null ? customer.email :
                                                                            '-'}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th scope="row">Số Điện Thoại</th>
                                                                        <td>${customer.phone != null ? customer.phone :
                                                                            '-'}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th scope="row">Website</th>
                                                                        <td>
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${customer.website != null}">
                                                                                    <a href="${customer.website}"
                                                                                        target="_blank">${customer.website}</a>
                                                                                </c:when>
                                                                                <c:otherwise>-</c:otherwise>
                                                                            </c:choose>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th scope="row">Địa Chỉ Hóa Đơn</th>
                                                                        <td>${customer.billingAddress != null ?
                                                                            customer.billingAddress : '-'}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th scope="row">Địa Chỉ Giao Hàng</th>
                                                                        <td>${customer.shippingAddress != null ?
                                                                            customer.shippingAddress : '-'}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th scope="row">Thành Phố / Tỉnh</th>
                                                                        <td>${customer.city != null ? customer.city :
                                                                            '-'}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th scope="row">Quốc Gia</th>
                                                                        <td>${customer.country != null ?
                                                                            customer.country : '-'}</td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row g-4 mt-1">
                                                    <div class="col-sm-12">
                                                        <div class="bg-light rounded h-100 p-4">
                                                            <h6 class="mb-4">Phản Hồi Từ Khách Hàng (Feedback)</h6>
                                                            <c:choose>
                                                                <c:when test="${not empty reviews}">
                                                                    <div class="table-responsive">
                                                                        <table class="table table-hover align-middle">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th>Ngày Gửi Link</th>
                                                                                    <th>Ngày Phản Hồi</th>
                                                                                    <th>Trạng Thái</th>
                                                                                    <th>Điểm Dịch Vụ</th>
                                                                                    <th>Điểm Nhân Viên</th>
                                                                                    <th>Góp Ý</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <c:forEach var="r" items="${reviews}">
                                                                                    <tr>
                                                                                        <td>
                                                                                            <fmt:formatDate
                                                                                                value="${r.sentAt}"
                                                                                                pattern="dd/MM/yyyy HH:mm" />
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:if
                                                                                                test="${r.submittedAt != null}">
                                                                                                <fmt:formatDate
                                                                                                    value="${r.submittedAt}"
                                                                                                    pattern="dd/MM/yyyy HH:mm" />
                                                                                            </c:if>
                                                                                            <c:if
                                                                                                test="${r.submittedAt == null}">
                                                                                                -
                                                                                            </c:if>
                                                                                        </td>
                                                                                        <td>
                                                                                            <span
                                                                                                class="badge ${r.used ? 'bg-success' : 'bg-warning'}">${r.used
                                                                                                ? 'Đã phản hồi' : 'Chờ
                                                                                                phản hồi'}</span>
                                                                                        </td>
                                                                                        <td>${r.serviceRating != null ?
                                                                                            r.serviceRating.toString().concat('
                                                                                            Sao') : '-'}</td>
                                                                                        <td>${r.staffRating != null ?
                                                                                            r.staffRating.toString().concat('
                                                                                            Sao') : '-'}</td>
                                                                                        <td class="text-wrap text-break"
                                                                                            style="max-width: 300px;">
                                                                                            ${r.comment != null ?
                                                                                            r.comment : '-'}</td>
                                                                                    </tr>
                                                                                </c:forEach>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <p>Chưa có dữ liệu đánh giá nào.</p>
                                                                </c:otherwise>
                                                            </c:choose>
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