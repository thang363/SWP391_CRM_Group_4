<%-- sales-pipeline.jsp - Trang Sales Pipeline --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Đặt biến currentPage để highlight menu active --%>
<% request.setAttribute("currentPage", "sales-pipeline" ); %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

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
                                    class="fa fa-funnel-dollar me-2"></i>Lead
                                List
                            </h3>
                        </div>

                        <!-- Search and Filter Form -->
                        <form
                            action="${pageContext.request.contextPath}/sales/leads"
                            method="get" class="row g-3 align-items-center">
                            <div class="col-md-4">
                                <div class="input-group">
                                    <span
                                        class="input-group-text bg-transparent border-end-0"><i
                                            class="fa fa-search text-muted"></i></span>
                                    <input type="text"
                                           class="form-control border-start-0"
                                           name="search"
                                           value="${fn:escapeXml(searchQuery)}"
                                           placeholder="Search Name or Email...">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" name="status">
                                    <option value="" ${empty statusFilter
                                                       ? 'selected' : '' }>All Statuses
                                    </option>
                                    <option value="New" ${statusFilter=='New'
                                                          ? 'selected' : '' }>New</option>
                                    <option value="Contacted"
                                            ${statusFilter=='Contacted' ? 'selected'
                                              : '' }>Contacted</option>
                                    <option value="Qualified"
                                            ${statusFilter=='Qualified' ? 'selected'
                                              : '' }>Qualified</option>
                                    <option value="Nurturing"
                                            ${statusFilter=='Nurturing' ? 'selected'
                                              : '' }>Nurturing</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit"
                                        class="btn btn-primary w-100">
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
                                                <th>Actions</th>
                                                <th>Last Interaction</th>
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
                                            <c:forEach var="lead"
                                                       items="${leadList}">
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
                                                        <form
                                                            action="${pageContext.request.contextPath}/sales/leads"
                                                            method="post"
                                                            style="display:inline;">

                                                            <input type="hidden"
                                                                   name="leadId"
                                                                   value="${lead.id}" />

                                                            <select
                                                                name="status"
                                                                class="form-select form-select-sm ${lead.isConverted ? 'text-muted' : ''}"
                                                                onchange="this.form.submit()"
                                                                ${lead.isConverted
                                                                  ? 'disabled'
                                                                  : '' }
                                                                title="${lead.isConverted ? 'Lead đã được convert, không thể thay đổi status' : ''}">
                                                                <option
                                                                    value="Assigned"
                                                                    ${lead.status=='Assigned'
                                                                      ? 'selected'
                                                                      : '' }>
                                                                    Assigned
                                                                </option>
                                                                <option
                                                                    value="Contacted"
                                                                    ${lead.status=='Contacted'
                                                                      ? 'selected'
                                                                      : '' }>
                                                                    Contacted
                                                                </option>

                                                                <option
                                                                    value="Nurturing"
                                                                    ${lead.status=='Nurturing'
                                                                      ? 'selected'
                                                                      : '' }>
                                                                    Nurturing
                                                                </option>

                                                                <option
                                                                    value="Qualified"
                                                                    ${lead.status=='Qualified'
                                                                      ? 'selected'
                                                                      : '' }>
                                                                    Qualified
                                                                </option>

                                                            </select>

                                                        </form>
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
                                                    <td>
                                                        <div
                                                            class="d-flex gap-2">
                                                            <button
                                                                type="button"
                                                                class="btn btn-sm btn-outline-primary"
                                                                title="Edit Lead"
                                                                data-id="${lead.id}"
                                                                data-name="${fn:escapeXml(lead.fullName)}"
                                                                data-phone="${fn:escapeXml(lead.phone)}"
                                                                onclick="showEditLeadModal(this)">
                                                                <i
                                                                    class="fa fa-edit"></i>
                                                            </button>
                                                            <button
                                                                type="button"
                                                                class="btn btn-sm btn-outline-warning"
                                                                title="Log Interaction"
                                                                data-id="${lead.id}"
                                                                data-name="${fn:escapeXml(lead.fullName)}"
                                                                onclick="showInteractionModal(this)">
                                                                <i
                                                                    class="fa fa-history"></i>
                                                            </button>
                                                            <button
                                                                class="btn btn-sm btn-outline-success"
                                                                ${lead.status
                                                                  !='Qualified' or
                                                                  lead.isConverted
                                                                  ? 'disabled'
                                                                  : '' }
                                                                onclick="location.href = '${pageContext.request.contextPath}/convertLead?leadId=${lead.id}'">
                                                                <i
                                                                    class="fa fa-exchange-alt"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when
                                                                test="${lead.leadnote != null}">
                                                                <span
                                                                    title="${fn:escapeXml(lead.leadnote.noteContent)}">
                                                                    ${fn:length(lead.leadnote.noteContent)
                                                                      > 30 ?
                                                                      fn:substring(lead.leadnote.noteContent,
                                                                      0, 30) +=
                                                                      '...' :
                                                                      lead.leadnote.noteContent}
                                                                </span>
                                                                <br />
                                                                <small
                                                                    class="text-muted">
                                                                    <fmt:parseDate
                                                                        value="${lead.leadnote.createdAt}"
                                                                        pattern="yyyy-MM-dd'T'HH:mm"
                                                                        var="parsedDate"
                                                                        type="both" />
                                                                    <fmt:formatDate
                                                                        value="${parsedDate}"
                                                                        pattern="dd/MM/yyyy HH:mm" />
                                                                </small>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    class="text-muted small">No
                                                                    interaction</span>
                                                                </c:otherwise>
                                                            </c:choose>
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


                <!-- Lead Edit Modal -->
                <div class="modal fade" id="leadEditModal" tabindex="-1"
                     aria-labelledby="leadEditModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form
                                action="${pageContext.request.contextPath}/EditLeadbySaleServlet"
                                method="get">
                                <div class="modal-header">
                                    <h5 class="modal-title"
                                        id="leadEditModalLabel">Chỉnh sửa
                                        Lead
                                    </h5>
                                    <button type="button" class="btn-close"
                                            data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <input type="hidden" name="leadId"
                                           id="editLeadId">
                                    <div class="mb-3">
                                        <label for="editFullName"
                                               class="form-label">Họ và
                                            Tên</label>
                                        <input type="text"
                                               class="form-control"
                                               id="editFullName" name="name"
                                               required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="editPhone"
                                               class="form-label">Số điện
                                            thoại</label>
                                        <input type="text"
                                               class="form-control"
                                               id="editPhone" name="phone"
                                               required>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button"
                                            class="btn btn-secondary"
                                            data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit"
                                            class="btn btn-primary">Lưu thay
                                        đổi</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Lead Interaction Modal -->
                <div class="modal fade" id="leadInteractionModal"
                     tabindex="-1"
                     aria-labelledby="leadInteractionModalLabel"
                     aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form
                                action="${pageContext.request.contextPath}/addLeadNote"
                                method="post">
                                <div class="modal-header">
                                    <h5 class="modal-title"
                                        id="leadInteractionModalLabel">Ghi
                                        chú tương tác: <span
                                            id="interactionLeadName"></span>
                                    </h5>
                                    <button type="button" class="btn-close"
                                            data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <input type="hidden" name="leadId"
                                           id="interactionLeadId">

                                    <!-- Timeline in Interaction Modal -->
                                    <h6 class="small fw-bold mb-2">Lịch sử
                                        gần đây:</h6>
                                    <div id="interactionLeadNotesTimeline"
                                         class="interaction-timeline mb-3"
                                         style="max-height: 200px; overflow-y: auto;">
                                        <div class="text-muted small">Đang
                                            tải...</div>
                                    </div>
                                    <hr>

                                    <div class="mb-3">
                                        <label for="interactionContent"
                                               class="form-label">Nội dung trao
                                            đổi mới</label>
                                        <textarea class="form-control"
                                                  id="interactionContent"
                                                  name="content" rows="3"
                                                  placeholder="Nhập tóm tắt buổi làm việc, cuộc gọi..."
                                                  required></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button"
                                            class="btn btn-secondary"
                                            data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit"
                                            class="btn btn-primary">Lưu ghi
                                        chú</button>
                                </div>
                            </form>
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

            function showEditLeadModal(button) {
                const id = button.dataset.id;
                const name = button.dataset.name;
                const phone = button.dataset.phone;

                document.getElementById('editLeadId').value = id;
                document.getElementById('editFullName').value = name;
                document.getElementById('editPhone').value = phone;

                var editModal = new bootstrap.Modal(document.getElementById('leadEditModal'));
                editModal.show();
            }

            function showInteractionModal(button) {
                const id = button.dataset.id;
                const name = button.dataset.name;

                document.getElementById('interactionLeadId').value = id;
                document.getElementById('interactionLeadName').innerText = name;
                document.getElementById('interactionContent').value = '';

                var interactionModal = new bootstrap.Modal(document.getElementById('leadInteractionModal'));
                interactionModal.show();

                // Load notes via AJAX
                loadLeadNotes(id, 'interactionLeadNotesTimeline');
            }

            function loadLeadNotes(leadId, containerId) {
                const container = document.getElementById(containerId);
                if (!container)
                    return;

                // Clear previous content and show loading message
                container.innerHTML = '<div class="text-muted small">Đang tải lịch sử...</div>';
                fetch('${pageContext.request.contextPath}/getLeadNotes?leadId=' + leadId)
                        .then(response => response.json())
                        .then(data => {
                            if (data.error) {
                                container.innerHTML = `<div class="text-danger small">Lỗi: ${data.error}</div>`;
                                return;
                            }
                            const notes = data;
                            if (notes.length === 0) {
                                container.innerHTML = '<div class="text-muted small">Chưa có lịch sử giao tiếp.</div>';
                                return;
                            }
                            let html = '';
                            notes.forEach(note => {
                                html += '<div class="p-2 border-start border-primary border-3 bg-white mb-2 small shadow-sm">'
                                        + '<span class="text-muted d-block" style="font-size: 0.7rem;">'
                                        + '<i class="fa fa-calendar-alt me-1"></i>' + (note.createdAt || 'N/A')
                                        + '<span class="badge bg-light text-dark ms-2">' + (note.noteType || 'General') + '</span>'
                                        + '</span>'
                                        + '<div class="mt-1">' + note.noteContent + '</div>'
                                        + '</div>';
                            });
                            container.innerHTML = html;
                        })
                        .catch(error => {
                            console.error('Error loading notes:', error);
                            container.innerHTML = '<div class="text-danger small">Lỗi kết nối máy chủ.</div>';
                        });
            }
        </script>
    </body>

</html>