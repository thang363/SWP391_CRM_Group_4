<%-- opportunity-list.jsp - Trang Danh sách Cơ hội --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% request.setAttribute("currentPage", "opportunities" ); %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <title>Opportunity List - CRM System</title>
        <%@ include file="/includes/head.jsp" %>
        <style>
            /* Pagination Styles */
            .pagination-container {
                display: flex;
                justify-content: center;
                margin-top: 20px;
                gap: 5px;
            }

            .pagination-link {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 38px;
                padding: 0 16px;
                height: 42px;
                min-width: 42px;
                background: #fff;
                color: #0093ff;
                text-decoration: none;
                border: 1px solid #dee2e6;
                border-right: none;
                transition: all 0.2s;
                font-family: inherit;
                font-size: 1.1rem;
            }

            .pagination-link:first-child {
                border-top-left-radius: 8px;
                border-bottom-left-radius: 8px;
                color: #6c757d;
                /* Xám cho nút "Trước" */
            }

            .pagination-link:last-child {
                border-top-right-radius: 8px;
                border-bottom-right-radius: 8px;
                border-right: 1px solid #dee2e6;
            }

            .pagination-link:hover {
                background-color: #f8f9fa;
                z-index: 1;
            }

            .pagination-link.active {
                background-color: #0093ff;
                color: #fff !important;
                border-color: #0093ff;
                z-index: 2;
            }
        </style>
    </head>

    <body>
        <div class="container-xxl position-relative bg-white d-flex p-0">

            <!-- Spinner -->
            <div id="spinner"
                 class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                <div class="spinner-border text-primary" style="width:3rem;height:3rem;"
                     role="status">
                    <span class="sr-only">Loading...</span>
                </div>
            </div>

            <%@ include file="/includes/sidebar.jsp" %>

            <!-- Content Start -->
            <div class="content">
                <%@ include file="/includes/topbar.jsp" %>

                <!-- Page Header & Filter -->
                <div class="container-fluid pt-4 px-4">
                    <div class="bg-light rounded p-4 mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4 class="mb-0"><i class="fa fa-handshake me-2"></i>Danh sách
                                Cơ hội</h4>
                        </div>

                        <!-- Filter Form -->
                        <form
                            action="${pageContext.request.contextPath}/sales/opportunities"
                            method="get" class="row g-3 align-items-center">
                            <div class="col-md-5">
                                <div class="input-group">
                                    <span
                                        class="input-group-text bg-transparent border-end-0">
                                        <i class="fa fa-search text-muted"></i>
                                    </span>
                                    <input type="text" class="form-control border-start-0"
                                           name="search" value="${fn:escapeXml(searchQuery)}"
                                           placeholder="Tìm tên cơ hội...">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <select class="form-select" name="stage">
                                    <option value="" ${empty stageFilter ? 'selected' : ''
                                            }>All stage</option>
                                    <option value="Prospecting" ${stageFilter=='Prospecting'
                                                                  ? 'selected' : '' }>Prospecting</option>
                                    <option value="Qualification"
                                            ${stageFilter=='Qualification' ? 'selected' : '' }>
                                        Qualification</option>
                                    <option value="Proposal" ${stageFilter=='Proposal'
                                                               ? 'selected' : '' }>Proposal</option>


                                    <option value="Negotiation" ${stageFilter=='Negotiation'
                                                                  ? 'selected' : '' }>Negotiation</option>
                                    <option value="Won" ${stageFilter=='Won' ? 'selected'
                                                          : '' }>Won</option>
                                    <option value="Lost" ${stageFilter=='Lost' ? 'selected'
                                                           : '' }>Lost</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fa fa-filter me-2"></i>Lọc
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Opportunity Table -->
                <div class="container-fluid px-4 pb-4">
                    <div class="bg-light rounded p-4">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width:50px">#</th>
                                        <th>Tên Cơ hội</th>
                                        <th>Giá trị (VND)</th>
                                        <th style="width:170px">Giai đoạn</th>
                                        <th style="width:80px" class="text-center">Báo giá
                                        </th>
                                        <th style="width:130px">Xác suất</th>
                                        <th style="width:130px">Ngày tạo</th>
                                        <th style="width:120px" class="text-center">Thao tác
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty opportunityList}">
                                        <tr>
                                            <td colspan="8"
                                                class="text-center text-muted py-5">
                                                <i
                                                    class="fa fa-box-open fa-3x mb-3 d-block"></i>
                                                Không tìm thấy cơ hội nào.
                                            </td>
                                        </tr>
                                    </c:if>

                                    <c:forEach var="opp" items="${NewOpportunityList}">
                                        <tr>
                                            <td class="text-muted">${opp.id}</td>

                                            <td><strong>${fn:escapeXml(opp.name)}</strong>
                                            </td>

                                            <td class="text-success fw-bold">
                                                <fmt:formatNumber
                                                    value="${opp.expectedValue}"
                                                    type="currency" currencySymbol="₫" />
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${opp.stage=='Won'}">
                                                        <span
                                                            class="badge bg-success">${opp.stage}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form id="stageForm_${opp.id}"
                                                              action="${pageContext.request.contextPath}/sales/opportunities"
                                                              method="post">
                                                            <input type="hidden"
                                                                   name="opportunityId"
                                                                   value="${opp.id}" />
                                                            <input type="hidden"
                                                                   id="stageInput_${opp.id}"
                                                                   name="stage" value="" />
                                                            <div
                                                                class="input-group input-group-sm">
                                                                <select
                                                                    class="form-select form-select-sm"
                                                                    id="stageSelect_${opp.id}"
                                                                    onchange="showListStageModal(${opp.id}, '${opp.stage}')">
                                                                    <option
                                                                        value="Prospecting"
                                                                        ${opp.stage=='Prospecting'
                                                                          ?'selected':''}>
                                                                        Prospecting
                                                                    </option>
                                                                    <option
                                                                        value="Qualification"
                                                                        ${opp.stage=='Qualification'
                                                                          ?'selected':''}>
                                                                        Qualification
                                                                    </option>
                                                                    <option value="Proposal"
                                                                            ${opp.stage=='Proposal'
                                                                              ?'selected':''}>
                                                                        Proposal
                                                                    </option>
                                                                    <option
                                                                        value="Negotiation"
                                                                        ${opp.stage=='Negotiation'
                                                                          ?'selected':''}>
                                                                        Negotiation
                                                                    </option>
                                                                    <option value="Lost"
                                                                            ${opp.stage=='Lost'
                                                                              ?'selected':''}>
                                                                        Lost
                                                                    </option>
                                                                </select>
                                                            </div>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/sales/opportunity-detail?id=${opp.id}&tab=quotes"
                                                   class="badge text-decoration-none fs-6 ${opp.quoteCount > 0 ? 'bg-primary' : 'bg-secondary'}"
                                                   title="Xem báo giá">
                                                    <i
                                                        class="fa fa-file-invoice me-1"></i>${opp.quoteCount}
                                                </a>
                                            </td>

                                            <td>
                                                <div
                                                    class="d-flex align-items-center gap-2">
                                                    <div class="progress flex-grow-1"
                                                         style="height:8px;">
                                                        <div class="progress-bar"
                                                             style="width:${opp.probability}%">
                                                        </div>
                                                    </div>
                                                    <small
                                                        class="text-muted">${opp.probability}%</small>
                                                </div>
                                            </td>

                                            <td class="text-muted small">${opp.createdAt}
                                            </td>

                                            <td class="text-center">
                                                <div
                                                    class="d-flex gap-1 justify-content-center">
                                                    <a href="${pageContext.request.contextPath}/sales/opportunity-detail?id=${opp.id}"
                                                       class="btn btn-sm btn-outline-info"
                                                       title="Xem chi tiết">
                                                        <i class="fa fa-eye"></i>
                                                    </a>
                                                    <button type="button"
                                                            class="btn btn-sm btn-outline-primary"
                                                            title="Chỉnh sửa"
                                                            data-id="${opp.id}"
                                                            data-name="${fn:escapeXml(opp.name)}"
                                                            onclick="showEditOpportunityModal(this)">
                                                        <i class="fa fa-edit"></i>
                                                    </button>
                                                    <c:if
                                                        test="${opp.stage != 'Won' && opp.stage != 'Lost'}">
                                                        <a href="${pageContext.request.contextPath}/sales/opportunity-detail?id=${opp.id}&tab=quotes"
                                                           class="btn btn-sm btn-outline-success"
                                                           title="Tạo báo giá">
                                                            <i class="fa fa-plus"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                </tbody>
                            </table>
                            <div class="pagination-container">
                                <c:if test="${page > 1}">
                                    <a href="${pageContext.request.contextPath}/sales/opportunities?page=${page - 1}&search=${fn:escapeXml(searchQuery)}&status=${statusFilter}"
                                       class="pagination-link">
                                        Trước
                                    </a>
                                </c:if>

                                <c:forEach var="i" begin="1"
                                           end="${totalPage}">
                                    <a href="${pageContext.request.contextPath}/sales/opportunities?page=${i}&search=${fn:escapeXml(searchQuery)}&status=${statusFilter}"
                                       class="pagination-link ${page == i ? 'active' : ''}">
                                        ${i}
                                    </a>
                                </c:forEach>

                                <c:if test="${page < totalPage}">
                                    <a href="${pageContext.request.contextPath}/sales/opportunities?page=${page + 1}&search=${fn:escapeXml(searchQuery)}&status=${statusFilter}"
                                       class="pagination-link">
                                        Sau
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Edit Modal -->
                <div class="modal fade" id="opportunityEditModal" tabindex="-1"
                     aria-labelledby="opportunityEditModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form
                                action="${pageContext.request.contextPath}/EditLeadbySaleServlet"
                                method="post">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="opportunityEditModalLabel">
                                        Chỉnh sửa Cơ hội</h5>
                                    <button type="button" class="btn-close"
                                            data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <input type="hidden" name="opportunityId"
                                           id="opportunityId">
                                    <div class="mb-3">
                                        <label for="editName" class="form-label">Tên cơ
                                            hội</label>
                                        <input type="text" class="form-control"
                                               id="editName" name="name" required>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary">Lưu thay
                                        đổi</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <%-- Stage Change Modal for List --%>
                <div class="modal fade" id="listChangeStageModal" tabindex="-1"
                     aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow">
                            <div class="modal-header bg-primary text-white border-0">
                                <h5 class="modal-title">Ghi chú Chuyển Giai đoạn</h5>
                                <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body p-4">
                                <p class="mb-3">Bạn đang chuyển sang giai đoạn: <strong
                                        id="listModalStageDisplay"
                                        class="text-primary"></strong>
                                </p>
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Lý do / Ghi chú
                                        <span class="text-danger">*</span></label>
                                    <textarea id="listStageNotes" class="form-control"
                                              rows="3"
                                              placeholder="Ví dụ: Khách hàng hồi đáp tích cực, sẵn sàng..."
                                              required></textarea>
                                    <div class="invalid-feedback">Vui lòng nhập ghi chú
                                        trước khi
                                        chuyển.</div>
                                </div>
                            </div>
                            <div
                                class="modal-footer border-0 justify-content-center pb-4">
                                <button type="button" class="btn btn-light px-4"
                                        data-bs-dismiss="modal">Hủy</button>
                                <button type="button" id="listStageSubmitBtn"
                                        class="btn btn-primary px-4">Lưu & Chuyển</button>
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
            var _listStageOppId = null;
            var _listStageOldValue = null;
            var _listStageSubmitted = false;

            document.addEventListener('DOMContentLoaded', function () {
                var spinner = document.getElementById('spinner');
                if (spinner)
                    spinner.classList.remove('show');

                var submitBtn = document.getElementById('listStageSubmitBtn');
                if (submitBtn) {
                    submitBtn.addEventListener('click', function () {
                        if (!_listStageOppId)
                            return;
                        var notes = document.getElementById('listStageNotes').value.trim();
                        if (!notes) {
                            document.getElementById('listStageNotes').classList.add('is-invalid');
                            return;
                        }
                        _listStageSubmitted = true;
                        var select = document.getElementById('stageSelect_' + _listStageOppId);
                        document.getElementById('stageInput_' + _listStageOppId).value = select.value;
                        // inject notes into form as hidden field
                        var form = document.getElementById('stageForm_' + _listStageOppId);
                        var notesInput = document.createElement('input');
                        notesInput.type = 'hidden';
                        notesInput.name = 'notes';
                        notesInput.value = notes;
                        form.appendChild(notesInput);
                        form.submit();
                    });
                }

                // Revert stage select if modal is closed without submitting
                var stageModalEl = document.getElementById('listChangeStageModal');
                if (stageModalEl) {
                    stageModalEl.addEventListener('hide.bs.modal', function () {
                        if (!_listStageSubmitted && _listStageOppId && _listStageOldValue) {
                            document.getElementById('stageSelect_' + _listStageOppId).value = _listStageOldValue;
                        }
                    });
                }
            });

            function showListStageModal(oppId, currentStage) {
                var select = document.getElementById('stageSelect_' + oppId);
                var newStage = select.value;
                if (newStage === currentStage)
                    return;
                _listStageOppId = oppId;
                _listStageOldValue = currentStage;
                _listStageSubmitted = false;
                document.getElementById('listModalStageDisplay').innerText = newStage;
                // reset notes
                document.getElementById('listStageNotes').value = '';
                document.getElementById('listStageNotes').classList.remove('is-invalid');
                new bootstrap.Modal(document.getElementById('listChangeStageModal')).show();
            }

            function showEditOpportunityModal(button) {
                document.getElementById('opportunityId').value = button.dataset.id;
                document.getElementById('editName').value = button.dataset.name;
                new bootstrap.Modal(document.getElementById('opportunityEditModal')).show();
            }
        </script>

    </body>

</html>