<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
      <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%-- Fragment: chỉ trả về nội dung, không có layout (dùng cho AJAX modal) --%>

                <c:choose>
                    <c:when test="${not empty customer}">
                        <div class="row g-3">

                            <!-- Thông tin cơ bản -->
                            <div class="col-12">
                                <div class="card border-0 shadow-sm">
                                    <div class="card-body">
                                        <h6 class="text-primary fw-bold mb-3">
                                            <i class="fa fa-user-circle me-2"></i>Thông tin khách hàng
                                        </h6>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <table class="table table-sm table-borderless mb-0">
                                                    <tr>
                                                        <td class="text-muted" style="width:45%">Tên công ty</td>
                                                        <td><strong>${customer.companyName}</strong></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-muted">Email</td>
                                                        <td>${customer.email}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-muted">Điện thoại</td>
                                                        <td>${customer.phone}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-muted">Ngành</td>
                                                        <td>${customer.industry}</td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div class="col-md-6">
                                                <table class="table table-sm table-borderless mb-0">
                                                    <tr>
                                                        <td class="text-muted" style="width:45%">Hạng</td>
                                                        <td><span
                                                                class="badge ${customer.tier == 'VIP' ? 'bg-warning text-dark' : customer.tier == 'VVIP' ? 'bg-danger' : 'bg-primary'}">${customer.tier}</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-muted">Trạng thái</td>
                                                        <td><span
                                                                class="badge ${customer.status == 'Active' ? 'bg-success' : 'bg-secondary'}">${customer.status}</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-muted">Thành phố</td>
                                                        <td>${customer.city}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-muted">Quốc gia</td>
                                                        <td>${customer.country}</td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Lần chăm sóc cuối -->
                            <div class="col-12">
                                <div class="bg-light rounded p-3 d-flex align-items-center gap-3">
                                    <i class="fa fa-clock text-warning fa-lg"></i>
                                    <div>
                                        <div class="small text-muted">Lần chăm sóc cuối</div>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty customer.lastCareDate}">
                                                    <fmt:formatDate value="${customer.lastCareDate}"
                                                        pattern="dd/MM/yyyy HH:mm" />
                                                </c:when>
                                                <c:otherwise>Chưa có dữ liệu</c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>
                                    <c:if test="${not empty customer.website}">
                                        <div class="ms-auto">
                                            <a href="${customer.website}" target="_blank"
                                                class="btn btn-sm btn-outline-primary">
                                                <i class="fa fa-globe me-1"></i>Website
                                            </a>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Gợi ý hành động -->
                            <div class="col-12">
                                <div class="alert alert-info border-0 mb-0">
                                    <i class="fa fa-info-circle me-2"></i>
                                    Để xem lịch sử Tickets và Cơ hội đầy đủ, vui lòng truy cập
                                    <a href="${pageContext.request.contextPath}/customers?action=history&id=${customer.id}"
                                        target="_blank">
                                        trang lịch sử chi tiết
                                    </a>.
                                </div>
                            </div>

                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-danger mb-0">
                            <i class="fa fa-exclamation-circle me-2"></i>Không tìm thấy thông tin khách hàng.
                        </div>
                    </c:otherwise>
                </c:choose>