<%-- system-job-logs.jsp - System Job Logs (Manager Only, Read-Only) --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>System Job Logs - CRM System</title>
                    <%@ include file="/includes/head.jsp" %>
                        <style>
                            .badge-success-custom {
                                background-color: #28a745;
                                color: white;
                            }

                            .badge-failed-custom {
                                background-color: #dc3545;
                                color: white;
                            }

                            .table td,
                            .table th {
                                vertical-align: middle;
                            }

                            .error-cell {
                                max-width: 250px;
                                white-space: nowrap;
                                overflow: hidden;
                                text-overflow: ellipsis;
                                cursor: pointer;
                            }

                            .error-cell:hover {
                                white-space: normal;
                                overflow: visible;
                            }
                        </style>
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

                            <!-- Content Start -->
                            <div class="content">
                                <%@ include file="/includes/topbar.jsp" %>

                                    <div class="container-fluid pt-4 px-4">

                                        <!-- Page Header -->
                                        <div class="row mb-4">
                                            <div class="col-12">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <h3 class="mb-0"><i class="fa fa-history me-2"></i>System Job Logs
                                                    </h3>
                                                    <div>
                                                        <span class="text-muted me-3">Nhật ký hoạt động hệ thống</span>
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/system-job-logs"
                                                            style="display:inline">
                                                            <input type="hidden" name="action" value="runNow">
                                                            <button type="submit" class="btn btn-warning"
                                                                onclick="return confirm('Chạy tất cả Automation Rules ngay bây giờ?')">
                                                                <i class="fa fa-play me-1"></i>Chạy ngay
                                                            </button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Logs Table -->
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="bg-light rounded p-4">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover align-middle">
                                                            <thead>
                                                                <tr>
                                                                    <th style="width:5%">#</th>
                                                                    <th style="width:20%">Thời gian chạy</th>
                                                                    <th style="width:25%">Tên kịch bản</th>
                                                                    <th style="width:10%">Kết quả</th>
                                                                    <th style="width:12%">Số lượng tạo</th>
                                                                    <th style="width:28%">Chi tiết lỗi</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:choose>
                                                                    <c:when test="${empty logs}">
                                                                        <tr>
                                                                            <td colspan="6"
                                                                                class="text-center text-muted py-5">
                                                                                <i
                                                                                    class="fa fa-inbox fa-3x mb-3 d-block"></i>
                                                                                Chưa có log nào. Hệ thống sẽ ghi log khi
                                                                                chạy tự động.
                                                                            </td>
                                                                        </tr>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:forEach var="log" items="${logs}"
                                                                            varStatus="loop">
                                                                            <tr>
                                                                                <td><strong>${loop.index + 1}</strong>
                                                                                </td>
                                                                                <td>
                                                                                    <i
                                                                                        class="fa fa-clock text-muted me-1"></i>
                                                                                    <fmt:formatDate
                                                                                        value="${log.executionTime}"
                                                                                        pattern="dd/MM/yyyy HH:mm:ss" />
                                                                                </td>
                                                                                <td>
                                                                                    <strong>${log.ruleName}</strong>
                                                                                </td>
                                                                                <td>
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${log.status == 'Success'}">
                                                                                            <span
                                                                                                class="badge badge-success-custom">
                                                                                                <i
                                                                                                    class="fa fa-check-circle me-1"></i>Success
                                                                                            </span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span
                                                                                                class="badge badge-failed-custom">
                                                                                                <i
                                                                                                    class="fa fa-times-circle me-1"></i>Failed
                                                                                            </span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </td>
                                                                                <td>
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${log.recordsCreated > 0}">
                                                                                            <span
                                                                                                class="text-success fw-bold">
                                                                                                <i
                                                                                                    class="fa fa-plus-circle me-1"></i>${log.recordsCreated}
                                                                                                Tasks
                                                                                            </span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span
                                                                                                class="text-muted">0</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </td>
                                                                                <td>
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${not empty log.errorMessage}">
                                                                                            <span
                                                                                                class="error-cell text-danger"
                                                                                                title="${log.errorMessage}">
                                                                                                <i
                                                                                                    class="fa fa-exclamation-triangle me-1"></i>${log.errorMessage}
                                                                                            </span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span
                                                                                                class="text-muted fst-italic">—</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
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
                                        </div>
                                    </div>

                                    <%@ include file="/includes/footer.jsp" %>
                            </div>
                            <!-- Content End -->

                            <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                    class="bi bi-arrow-up"></i></a>
                    </div>

                    <%@ include file="/includes/scripts.jsp" %>

                        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                var spinner = document.getElementById('spinner');
                                if (spinner) spinner.classList.remove('show');
                            });
                        </script>
                </body>

                </html>