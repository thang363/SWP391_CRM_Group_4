<%-- sales-pipeline.jsp - Trang Sales Pipeline --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%-- Đặt biến currentPage để highlight menu active --%>
            <% request.setAttribute("currentPage", "sales-pipeline" ); %>
                <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <title>Sales Pipeline - CRM System</title>
                        <%@ include file="/includes/head.jsp" %>
                            <style>
                                .pipeline-column {
                                    min-height: 500px;
                                    background: #f8f9fa;
                                    border-radius: 10px;
                                    padding: 15px;
                                }

                                .pipeline-header {
                                    font-weight: 600;
                                    padding: 10px 15px;
                                    border-radius: 8px;
                                    margin-bottom: 15px;
                                    color: white;
                                }

                                .pipeline-header.lead {
                                    background: linear-gradient(135deg, #6c757d, #495057);
                                }

                                .pipeline-header.qualified {
                                    background: linear-gradient(135deg, #0d6efd, #0a58ca);
                                }

                                .pipeline-header.proposal {
                                    background: linear-gradient(135deg, #fd7e14, #dc6a12);
                                }

                                .pipeline-header.negotiation {
                                    background: linear-gradient(135deg, #6f42c1, #5a32a3);
                                }

                                .pipeline-header.closed {
                                    background: linear-gradient(135deg, #198754, #157347);
                                }

                                .deal-card {
                                    background: white;
                                    border-radius: 8px;
                                    padding: 15px;
                                    margin-bottom: 10px;
                                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                                    cursor: grab;
                                    transition: transform 0.2s, box-shadow 0.2s;
                                }

                                .deal-card:hover {
                                    transform: translateY(-2px);
                                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                                }

                                .deal-card:active {
                                    cursor: grabbing;
                                }

                                .deal-value {
                                    font-size: 1.1rem;
                                    font-weight: 600;
                                    color: #198754;
                                }

                                .deal-company {
                                    font-weight: 500;
                                    color: #333;
                                }

                                .deal-contact {
                                    font-size: 0.85rem;
                                    color: #666;
                                }

                                .deal-date {
                                    font-size: 0.8rem;
                                    color: #999;
                                }

                                .stage-total {
                                    font-size: 0.9rem;
                                    opacity: 0.9;
                                }
                            </style>
                    </head>

                    <body>
                        <div class="container-xxl position-relative bg-white d-flex p-0">
                            <!-- Spinner Start -->
                            <div id="spinner"
                                class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                                <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;"
                                    role="status">
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

                                                <!-- Page Header & Filter Section -->
                                                <div class="container-fluid pt-4 px-4">
                                                    <div class="bg-light rounded p-4 mb-4">
                                                        <div
                                                            class="d-flex justify-content-between align-items-center mb-4">
                                                            <h3 class="mb-0"><i
                                                                    class="fa fa-funnel-dollar me-2"></i>Lead List</h3>
                                                        </div>

                                                        <!-- Search and Filter Form -->
                                                        <form class="row g-3 align-items-center">
                                                            <div class="col-md-4">
                                                                <div class="input-group">
                                                                    <span
                                                                        class="input-group-text bg-transparent border-end-0"><i
                                                                            class="fa fa-search text-muted"></i></span>
                                                                    <input type="text"
                                                                        class="form-control border-start-0"
                                                                        name="search"
                                                                        placeholder="Search Name or Email...">
                                                                </div>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <select class="form-select" name="status">
                                                                    <option value="" selected>All Statuses</option>
                                                                    <option value="New">New</option>
                                                                    <option value="Contacted">Contacted</option>
                                                                    <option value="Qualified">Qualified</option>
                                                                    <option value="Nurturing">Nurturing</option>
                                                                </select>
                                                            </div>
                                                            <div class="col-md-2">
                                                                <button type="button" class="btn btn-primary w-100"
                                                                    onclick="alert('Feature in development!')">
                                                                    <i class="fa fa-filter me-2"></i>Filter
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                                <div class="container-fluid px-4">
                                                    <div class="row g-4">
                                                        <div class="col-12">
                                                            <div class="bg-light rounded p-4">
                                                                <div class="table-responsive">
                                                                    <table class="table table-hover">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>ID</th>
                                                                                <th>Full Name</th>
                                                                                <th>Email</th>
                                                                                <th>Phone</th>
                                                                                <th>Status</th>
                                                                                <th>IsConverted</th>
                                                                                <th>Created At</th>
                                                                                <th>Actions</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <c:if test="${empty leadList}">
                                                                                <tr>
                                                                                    <td colspan="7"
                                                                                        class="text-center text-muted">
                                                                                        <i
                                                                                            class="fa fa-inbox fa-3x mb-3 d-block"></i>
                                                                                        No leads found
                                                                                    </td>
                                                                                </tr>
                                                                            </c:if>
                                                                            <c:forEach var="lead" items="${leadList}">
                                                                                <tr>
                                                                                    <td>${lead.id}</td>
                                                                                    <td><strong>${lead.fullName}</strong>
                                                                                    </td>
                                                                                    <td><a href="mailto:${lead.email}"
                                                                                            class="text-secondary"><i
                                                                                                class="fa fa-envelope me-2 text-primary small"></i>${lead.email}</a>
                                                                                    </td>
                                                                                    <td><a href="tel:${lead.phone}"
                                                                                            class="text-secondary"><i
                                                                                                class="fa fa-phone me-2 text-primary small"></i>${lead.phone}</a>
                                                                                    </td>
                                                                                    <td>
                                                                                        <span
                                                                                            class="badge bg-primary">${lead.status}</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${lead.isConverted}">
                                                                                                <span
                                                                                                    class="badge bg-success">Yes</span>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span
                                                                                                    class="badge bg-secondary">No</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td>${lead.createdAt}</td>
                                                                                    <td>
                                                                                        <div class="d-flex gap-2">
                                                                                            <button type="button"
                                                                                                class="btn btn-sm btn-outline-info"
                                                                                                title="View Details"
                                                                                                onclick="showLeadDetails(${lead.id}, '${lead.fullName}', '${lead.email}', '${lead.phone}', '${lead.status}', ${lead.isConverted})">
                                                                                                <i
                                                                                                    class="fa fa-eye"></i>
                                                                                            </button>
                                                                                            <button type="button"
                                                                                                class="btn btn-sm btn-outline-primary"
                                                                                                title="Edit Lead"
                                                                                                onclick="alert('Edit Lead logic coming soon')">
                                                                                                <i
                                                                                                    class="fa fa-edit"></i>
                                                                                            </button>
                                                                                            <button type="button"
                                                                                                class="btn btn-sm btn-outline-warning"
                                                                                                title="Log Interaction"
                                                                                                onclick="alert('Log interaction logic coming soon')">
                                                                                                <i
                                                                                                    class="fa fa-history"></i>
                                                                                            </button>
                                                                                            <c:if
                                                                                                test="${!lead.isConverted}">
                                                                                                <button type="button"
                                                                                                    class="btn btn-sm btn-outline-success"
                                                                                                    title="Convert to Opportunity"
                                                                                                    onclick="alert('Conversion logic coming soon')">
                                                                                                    <i
                                                                                                        class="fa fa-exchange-alt"></i>
                                                                                                </button>
                                                                                            </c:if>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </c:forEach>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <%@ include file="/includes/footer.jsp" %>

                                                    <!-- Lead View Modal -->
                                                    <div class="modal fade" id="leadViewModal" tabindex="-1"
                                                        aria-labelledby="leadViewModalLabel" aria-hidden="true">
                                                        <div class="modal-dialog modal-lg">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="leadViewModalLabel">Chi
                                                                        tiết Lead</h5>
                                                                    <button type="button" class="btn-close"
                                                                        data-bs-dismiss="modal"
                                                                        aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body p-4">
                                                                    <div class="row g-4">
                                                                        <!-- Left Column: Info -->
                                                                        <div class="col-md-5 border-end">
                                                                            <h6 class="text-primary mb-3"><i
                                                                                    class="fa fa-info-circle me-2"></i>Thông
                                                                                tin cơ bản</h6>
                                                                            <div class="mb-2">
                                                                                <label
                                                                                    class="small text-muted d-block">Họ
                                                                                    và Tên</label>
                                                                                <span id="modalFullName"
                                                                                    class="fw-bold"></span>
                                                                            </div>
                                                                            <div class="mb-2">
                                                                                <label
                                                                                    class="small text-muted d-block">Email</label>
                                                                                <a id="modalEmailLink" href="#"
                                                                                    class="text-secondary"><span
                                                                                        id="modalEmail"></span></a>
                                                                            </div>
                                                                            <div class="mb-2">
                                                                                <label
                                                                                    class="small text-muted d-block">Số
                                                                                    điện thoại</label>
                                                                                <a id="modalPhoneLink" href="#"
                                                                                    class="text-secondary"><span
                                                                                        id="modalPhone"></span></a>
                                                                            </div>
                                                                            <div class="mb-3">
                                                                                <label
                                                                                    class="small text-muted d-block">Trạng
                                                                                    thái</label>
                                                                                <span id="modalStatusBadge"
                                                                                    class="badge bg-primary"></span>
                                                                                <span id="modalConvertedBadge"
                                                                                    class="badge bg-success d-none">Converted</span>
                                                                            </div>

                                                                            <!-- Modal Actions -->
                                                                            <div class="d-grid gap-2 mt-4">
                                                                                <button type="button"
                                                                                    class="btn btn-primary"
                                                                                    onclick="alert('Edit logic coming soon')">
                                                                                    <i class="fa fa-edit me-2"></i>Edit
                                                                                    Information
                                                                                </button>
                                                                                <button id="modalConvertBtn"
                                                                                    type="button"
                                                                                    class="btn btn-success"
                                                                                    onclick="alert('Conversion logic coming soon')">
                                                                                    <i
                                                                                        class="fa fa-exchange-alt me-2"></i>Convert
                                                                                    to Opportunity
                                                                                </button>
                                                                            </div>
                                                                        </div>
                                                                        <!-- Right Column: Timeline -->
                                                                        <div class="col-md-7">
                                                                            <h6 class="text-primary mb-3"><i
                                                                                    class="fa fa-history me-2"></i>Lịch
                                                                                sử giao tiếp</h6>
                                                                            <div class="timeline-small">
                                                                                <div
                                                                                    class="p-2 border-start border-primary border-3 bg-white mb-2 small">
                                                                                    <span class="text-muted d-block"
                                                                                        style="font-size: 0.75rem;">15/02/2026</span>
                                                                                    Đã gọi điện tư vấn - Khách đang cân
                                                                                    nhắc về giá.
                                                                                </div>
                                                                                <div
                                                                                    class="p-2 border-start border-info border-3 bg-white mb-2 small">
                                                                                    <span class="text-muted d-block"
                                                                                        style="font-size: 0.75rem;">16/02/2026</span>
                                                                                    Đã gửi Email báo giá chi tiết.
                                                                                </div>
                                                                                <div class="text-center mt-3">
                                                                                    <button
                                                                                        class="btn btn-sm btn-outline-secondary px-3">
                                                                                        <i
                                                                                            class="fa fa-plus me-1"></i>Thêm
                                                                                        ghi chú
                                                                                    </button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                    </div>
                                    <!-- Content End -->

                                    <!-- Back to Top -->
                                    <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                            class="bi bi-arrow-up"></i></a>
                        </div>
                        <!-- Add Deal Modal -->



                        <%-- Include Scripts --%>
                            <%@ include file="/includes/scripts.jsp" %>

                                <!-- Inline script để đảm bảo ẩn spinner -->
                                <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        var spinner = document.getElementById('spinner');
                                        if (spinner) {
                                            spinner.classList.remove('show');
                                        }
                                    });

                                    function showLeadDetails(id, name, email, phone, status, isConverted) {
                                        document.getElementById('modalFullName').innerText = name;
                                        document.getElementById('modalEmail').innerText = email;
                                        document.getElementById('modalEmailLink').href = "mailto:" + email;
                                        document.getElementById('modalPhone').innerText = phone;
                                        document.getElementById('modalPhoneLink').href = "tel:" + phone;

                                        const statusBadge = document.getElementById('modalStatusBadge');
                                        statusBadge.innerText = status;

                                        const convertedBadge = document.getElementById('modalConvertedBadge');
                                        const convertBtn = document.getElementById('modalConvertBtn');

                                        if (isConverted) {
                                            convertedBadge.classList.remove('d-none');
                                            convertBtn.disabled = true;
                                            convertBtn.title = "This lead is already converted";
                                        } else {
                                            convertedBadge.classList.add('d-none');
                                            convertBtn.disabled = false;
                                        }

                                        var myModal = new bootstrap.Modal(document.getElementById('leadViewModal'));
                                        myModal.show();
                                    }
                                </script>
                    </body>

                    </html>