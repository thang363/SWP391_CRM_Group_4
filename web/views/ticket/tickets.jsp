<%-- tickets.jsp - Quản lý Hỗ trợ/Tickets --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>Quản lý Hỗ trợ - CRM System</title>
                    <%@ include file="/includes/head.jsp" %>
                        <style>
                            .badge-new {
                                background-color: #17a2b8;
                                color: white;
                            }

                            .badge-in-progress {
                                background-color: #ffc107;
                                color: black;
                            }

                            .badge-resolved {
                                background-color: #28a745;
                                color: white;
                            }

                            .badge-closed {
                                background-color: #6c757d;
                                color: white;
                            }

                            .priority-high {
                                color: #dc3545;
                                font-weight: bold;
                            }

                            .priority-medium {
                                color: #ffc107;
                                font-weight: bold;
                            }

                            .priority-low {
                                color: #28a745;
                                font-weight: bold;
                            }

                            .filter-section {
                                background-color: #f8f9fa;
                                padding: 1.5rem;
                                border-radius: 0.5rem;
                                margin-bottom: 1.5rem;
                            }

                            .nav-tabs .nav-link {
                                color: #495057;
                                cursor: pointer;
                            }

                            .nav-tabs .nav-link.active {
                                color: #0d6efd;
                                font-weight: bold;
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

                        <%-- Include Sidebar --%>
                            <%@ include file="/includes/sidebar.jsp" %>

                                <!-- Content Start -->
                                <div class="content">
                                    <%-- Include Top Navbar --%>
                                        <%@ include file="/includes/topbar.jsp" %>

                                            <!-- Ticket List Content -->
                                            <div class="container-fluid pt-4 px-4">

                                                <!-- Page Header -->
                                                <div class="row mb-4">
                                                    <div class="col-12">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <h3 class="mb-0"><i class="fa fa-ticket-alt me-2"></i>Danh
                                                                sách Hỗ trợ</h3>
                                                            <button type="button" class="btn btn-primary"
                                                                onclick="openCreateModal()">
                                                                <i class="fa fa-plus me-2"></i>Tạo Ticket mới
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Quick Filters (Tabs) -->
                                                <div class="row mb-3">
                                                    <div class="col-12">
                                                        <ul class="nav nav-tabs">
                                                            <li class="nav-item">
                                                                <a class="nav-link ${empty param.view || param.view == 'all' ? 'active' : ''}"
                                                                    href="${pageContext.request.contextPath}/tickets?view=all">
                                                                    Tất cả
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link ${param.view == 'my' ? 'active' : ''}"
                                                                    href="${pageContext.request.contextPath}/tickets?view=my">
                                                                    Tickets của tôi
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link ${param.view == 'unassigned' ? 'active' : ''}"
                                                                    href="${pageContext.request.contextPath}/tickets?view=unassigned">
                                                                    Chưa được chỉ định
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>

                                                <!-- Filter Section -->
                                                <div class="filter-section">
                                                    <form id="filterForm" method="get"
                                                        action="${pageContext.request.contextPath}/tickets">
                                                        <input type="hidden" name="view" value="${param.view}">
                                                        <div class="row g-3">
                                                            <div class="col-md-4">
                                                                <label class="form-label">Tìm kiếm</label>
                                                                <input type="text" class="form-control" name="keyword"
                                                                    placeholder="Tên công ty, ID ticket..."
                                                                    value="${param.keyword}">
                                                            </div>
                                                            <div class="col-md-2">
                                                                <label class="form-label">Trạng thái</label>
                                                                <select class="form-select" name="status">
                                                                    <option value="">Tất cả</option>
                                                                    <option value="Open" ${param.status=='Open'
                                                                        ? 'selected' : '' }>Open</option>
                                                                    <option value="In Progress"
                                                                        ${param.status=='In Progress' ? 'selected' : ''
                                                                        }>In Progress</option>
                                                                    <option value="Resolved" ${param.status=='Resolved'
                                                                        ? 'selected' : '' }>Resolved</option>
                                                                    <option value="Closed" ${param.status=='Closed'
                                                                        ? 'selected' : '' }>Closed</option>
                                                                </select>
                                                            </div>
                                                            <div class="col-md-2">
                                                                <label class="form-label">Độ ưu tiên</label>
                                                                <select class="form-select" name="priority">
                                                                    <option value="">Tất cả</option>
                                                                    <option value="Low" ${param.priority=='Low'
                                                                        ? 'selected' : '' }>Low</option>
                                                                    <option value="Medium" ${param.priority=='Medium'
                                                                        ? 'selected' : '' }>Medium</option>
                                                                    <option value="High" ${param.priority=='High'
                                                                        ? 'selected' : '' }>High</option>
                                                                    <option value="Critical"
                                                                        ${param.priority=='Critical' ? 'selected' : ''
                                                                        }>Critical</option>
                                                                </select>
                                                            </div>
                                                            <div class="col-md-4 d-flex align-items-end">
                                                                <button type="submit"
                                                                    class="btn btn-primary w-100 me-2">
                                                                    <i class="fa fa-search me-1"></i> Tìm kiếm
                                                                </button>
                                                                <a href="${pageContext.request.contextPath}/tickets"
                                                                    class="btn btn-secondary w-100">
                                                                    <i class="fa fa-redo me-1"></i>Đặt lại
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>

                                                <!-- Ticket Table -->
                                                <div class="row">
                                                    <div class="col-12">
                                                        <div class="bg-light rounded p-4">
                                                            <div class="table-responsive">
                                                                <table class="table table-hover align-middle">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>ID</th>
                                                                            <th>Tiêu đề</th>
                                                                            <th>Khách hàng</th>
                                                                            <th>Trạng thái</th>
                                                                            <th>Độ ưu tiên</th>
                                                                            <th>Người xử lý</th>
                                                                            <th>Ngày tạo</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:choose>
                                                                            <c:when test="${empty tickets}">
                                                                                <tr>
                                                                                    <td colspan="7"
                                                                                        class="text-center text-muted py-5">
                                                                                        <i
                                                                                            class="fa fa-inbox fa-3x mb-3 d-block"></i>
                                                                                        Không tìm thấy ticket nào
                                                                                    </td>
                                                                                </tr>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:forEach var="ticket"
                                                                                    items="${tickets}">
                                                                                    <tr style="cursor: pointer;"
                                                                                        onclick="window.location='${pageContext.request.contextPath}/tickets?action=detail&id=${ticket.id}'">
                                                                                        <td><strong>#${ticket.id}</strong>
                                                                                        </td>
                                                                                        <td>${ticket.title}</td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${not empty ticket.customerName}">
                                                                                                    <i
                                                                                                        class="fa fa-building text-muted me-1"></i>${ticket.customerName}
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="text-muted fst-italic">Unknown</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <span
                                                                                                class="badge badge-${ticket.status.toLowerCase().replace(' ', '-')}">
                                                                                                ${ticket.status}
                                                                                            </span>
                                                                                        </td>
                                                                                        <td>
                                                                                            <span
                                                                                                class="priority-${ticket.priority.toLowerCase()}">
                                                                                                ${ticket.priority}
                                                                                            </span>
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${not empty ticket.assignedToName}">
                                                                                                    <img class="rounded-circle me-1"
                                                                                                        src="${pageContext.request.contextPath}/img/user.jpg"
                                                                                                        alt=""
                                                                                                        style="width: 25px; height: 25px;">
                                                                                                    ${ticket.assignedToName}
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="badge bg-secondary">Unassigned</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <fmt:formatDate
                                                                                                value="${ticket.createdAt}"
                                                                                                pattern="dd/MM/yyyy HH:mm" />
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
                                // Spinner logic
                                document.addEventListener('DOMContentLoaded', function () {
                                    var spinner = document.getElementById('spinner');
                                    if (spinner) {
                                        spinner.classList.remove('show');
                                    }
                                });

                                // Modal & Form Logic
                                function openCreateModal() {
                                    const modal = new bootstrap.Modal(document.getElementById('ticketModal'));
                                    document.getElementById('ticketForm').reset();
                                    document.getElementById('customerId').value = '';
                                    document.getElementById('customerNameDisplay').textContent = '';
                                    document.getElementById('selectedCustomer').style.display = 'none';
                                    document.getElementById('searchResults').style.display = 'none';
                                    modal.show();
                                }

                                function saveTicket() {
                                    const form = document.getElementById('ticketForm');
                                    if (!form.checkValidity()) {
                                        form.reportValidity();
                                        return;
                                    }

                                    if (!document.getElementById('customerId').value) {
                                        showToast('Vui lòng chọn khách hàng!', 'warning');
                                        return;
                                    }

                                    const formData = new FormData(form);
                                    formData.append('action', 'create');

                                    fetch('${pageContext.request.contextPath}/tickets', {
                                        method: 'POST',
                                        body: formData
                                    })
                                        .then(response => response.json())
                                        .then(data => {
                                            if (data.success) {
                                                showToast(data.message, 'success');
                                                setTimeout(() => location.reload(), 1500);
                                            } else {
                                                showToast(data.message, 'danger');
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            showToast('Có lỗi xảy ra!', 'danger');
                                        });
                                }

                                // Customer Search Logic
                                $(document).ready(function () {
                                    let searchTimeout;
                                    const $searchInput = $('#customerSearch');
                                    const $resultsList = $('#searchResults');
                                    const $hiddenInput = $('#customerId');

                                    $searchInput.on('input', function () {
                                        const query = $(this).val();
                                        clearTimeout(searchTimeout);

                                        if (query.length < 2) {
                                            $resultsList.hide();
                                            return;
                                        }

                                        searchTimeout = setTimeout(function () {
                                            $.ajax({
                                                url: '${pageContext.request.contextPath}/tickets',
                                                data: { action: 'search-customers', q: query },
                                                success: function (data) {
                                                    $resultsList.empty();
                                                    if (data.length > 0) {
                                                        data.forEach(function (item) {
                                                            $resultsList.append(`<li data-id="\${item.id}" data-text="\${item.text}" class="p-2 border-bottom" style="cursor:pointer;">\${item.text}</li>`);
                                                        });
                                                        $resultsList.show();
                                                    } else {
                                                        $resultsList.append('<li class="p-2 text-muted">Không tìm thấy</li>');
                                                        $resultsList.show();
                                                    }
                                                }
                                            });
                                        }, 300);
                                    });

                                    $resultsList.on('click', 'li', function () {
                                        const id = $(this).data('id');
                                        const text = $(this).data('text');
                                        if (id) {
                                            $hiddenInput.val(id);
                                            $('#customerNameDisplay').text(text);
                                            $('#selectedCustomer').show();
                                            $searchInput.val('');
                                            $resultsList.hide();
                                        }
                                    });

                                    // Close search when clicking outside
                                    $(document).on('click', function (e) {
                                        if (!$(e.target).closest('.position-relative').length) {
                                            $resultsList.hide();
                                        }
                                    });
                                });
                            </script>
                </body>

                <!-- Create Ticket Modal -->
                <div class="modal fade" id="ticketModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Tạo Ticket Mới</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form id="ticketForm">
                                    <div class="row g-3">
                                        <div class="col-md-12 position-relative">
                                            <label class="form-label">Khách hàng <span
                                                    class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="fa fa-search"></i></span>
                                                <input type="text" class="form-control" id="customerSearch"
                                                    placeholder="Nhập tên/SĐT..." autocomplete="off">
                                                <input type="hidden" name="customerId" id="customerId">
                                            </div>
                                            <ul id="searchResults"
                                                class="position-absolute bg-white border w-100 shadow"
                                                style="display:none; list-style:none; padding:0; z-index:1050; max-height:200px; overflow-y:auto; top: 100%;">
                                            </ul>
                                            <div id="selectedCustomer" class="form-text text-primary mt-1"
                                                style="display:none;">
                                                <i class="fa fa-check-circle me-1"></i> Đã chọn: <span
                                                    id="customerNameDisplay"></span>
                                            </div>
                                        </div>

                                        <div class="col-md-12">
                                            <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" name="subject" required>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label">Phân loại</label>
                                            <select class="form-select" name="category">
                                                <option value="">-- Chọn loại --</option>
                                                <option value="Lỗi kỹ thuật">Lỗi kỹ thuật</option>
                                                <option value="Khiếu nại">Khiếu nại</option>
                                                <option value="Hỏi đáp">Hỏi đáp</option>
                                                <option value="Yêu cầu dịch vụ">Yêu cầu dịch vụ</option>
                                                <option value="Khác">Khác</option>
                                            </select>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label">Độ ưu tiên</label>
                                            <select class="form-select" name="priority">
                                                <option value="Low">Low</option>
                                                <option value="Medium" selected>Medium</option>
                                                <option value="High">High</option>
                                                <option value="Critical">Critical</option>
                                            </select>
                                        </div>

                                        <div class="col-12">
                                            <label class="form-label">Mô tả</label>
                                            <textarea class="form-control" name="description" rows="4"></textarea>
                                        </div>

                                        <div class="col-12">
                                            <label class="form-label">Đính kèm</label>
                                            <input class="form-control" type="file" name="attachment">
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="button" class="btn btn-primary" onclick="saveTicket()">
                                    <i class="fa fa-save me-2"></i>Lưu Ticket
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                </html>