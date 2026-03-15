<%-- manager-quote-list.jsp - Trang Duyệt Báo giá của Manager --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <% request.setAttribute("currentPage", "quotes" ); %>
            <%@ taglib uri="jakarta.tags.core" prefix="c" %>
                <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
                    <%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <title>Duyệt Báo giá (Manager) - CRM System</title>
                            <%@ include file="/includes/head.jsp" %>
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
                                                                        class="fa fa-clipboard-check me-2 text-primary"></i>Phê
                                                                    duyệt Báo giá (Manager)</h3>
                                                            </div>

                                                            <!-- Search and Filter Form -->
                                                            <form class="row g-3 align-items-center"
                                                                action="${pageContext.request.contextPath}/manager/quotes"
                                                                method="get">
                                                                <div class="col-md-4">
                                                                    <select class="form-select" name="status"
                                                                        onchange="this.form.submit()">
                                                                        <option value="All" ${statusFilter=='All'
                                                                            ? 'selected' : '' }>-- Tất cả các trạng thái
                                                                            --
                                                                        </option>
                                                                        <option value="Pending Approval"
                                                                            ${statusFilter=='Pending Approval'
                                                                            ? 'selected' : '' }>Mới chờ duyệt (Pending
                                                                            Approval)</option>
                                                                        <option value="Approved"
                                                                            ${statusFilter=='Approved' ? 'selected' : ''
                                                                            }>Đã duyệt (Approved)
                                                                        </option>
                                                                        <option value="Sent" ${statusFilter=='Sent'
                                                                            ? 'selected' : '' }>Đã gửi khách (Sent)
                                                                        </option>
                                                                        <option value="Accepted"
                                                                            ${statusFilter=='Accepted' ? 'selected' : ''
                                                                            }>Đã chốt (Accepted)</option>
                                                                        <option value="Rejected"
                                                                            ${statusFilter=='Rejected' ? 'selected' : ''
                                                                            }>Bị từ chối (Rejected)
                                                                        </option>
                                                                    </select>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>

                                                    <!-- Quotes Table -->
                                                    <div class="container-fluid px-4">
                                                        <div class="row g-4">
                                                            <div class="col-12">
                                                                <div class="bg-light rounded p-4">
                                                                    <div class="table-responsive">
                                                                        <table class="table table-hover align-middle">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th>Số Báo giá</th>
                                                                                    <th>Cơ hội</th>
                                                                                    <th>Người tạo (Sale)</th>
                                                                                    <th>Chủ đề</th>
                                                                                    <th>Tổng tiền (VND)</th>
                                                                                    <th>Trạng thái</th>
                                                                                    <th>Hiệu lực đến</th>
                                                                                    <th>Ngày tạo</th>
                                                                                    <th>Thao tác</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <c:if test="${empty quoteList}">
                                                                                    <tr>
                                                                                        <td colspan="9"
                                                                                            class="text-center text-muted py-5">
                                                                                            <i
                                                                                                class="fa fa-file-invoice fa-3x mb-3 d-block"></i>
                                                                                            Không tìm thấy báo giá nào
                                                                                            thuộc
                                                                                            trạng thái này.
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:if>
                                                                                <c:forEach var="quote"
                                                                                    items="${quoteList}">
                                                                                    <tr>
                                                                                        <td><strong>${quote.quoteNumber}</strong>
                                                                                        </td>
                                                                                        <td>
                                                                                            <a href="${pageContext.request.contextPath}/sales/opportunity-detail?id=${quote.opportunityId}&tab=quotes"
                                                                                                class="text-decoration-none"
                                                                                                target="_blank">
                                                                                                <i
                                                                                                    class="fa fa-handshake me-1 text-muted"></i>
                                                                                                ${empty
                                                                                                quote.opportunityName ?
                                                                                                '#'.concat(quote.opportunityId)
                                                                                                : quote.opportunityName}
                                                                                            </a>
                                                                                        </td>
                                                                                        <td>${quote.creatorName}</td>
                                                                                        <td>${quote.subject}</td>
                                                                                        <td
                                                                                            class="text-primary fw-bold">
                                                                                            <fmt:formatNumber
                                                                                                value="${quote.grandTotal}"
                                                                                                type="currency"
                                                                                                currencySymbol="₫" />
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${quote.status == 'Draft'}">
                                                                                                    <span
                                                                                                        class="badge bg-secondary">Bản
                                                                                                        nháp</span>
                                                                                                </c:when>
                                                                                                <c:when
                                                                                                    test="${quote.status == 'Pending Approval'}">
                                                                                                    <span
                                                                                                        class="badge bg-warning text-dark">Chờ
                                                                                                        duyệt</span>
                                                                                                </c:when>
                                                                                                <c:when
                                                                                                    test="${quote.status == 'Approved'}">
                                                                                                    <span
                                                                                                        class="badge bg-success">Đã
                                                                                                        duyệt</span>
                                                                                                </c:when>
                                                                                                <c:when
                                                                                                    test="${quote.status == 'Sent'}">
                                                                                                    <span
                                                                                                        class="badge bg-info text-dark">Đã
                                                                                                        gửi khách</span>
                                                                                                </c:when>
                                                                                                <c:when
                                                                                                    test="${quote.status == 'Accepted'}">
                                                                                                    <span
                                                                                                        class="badge bg-success">Chấp
                                                                                                        nhận</span>
                                                                                                </c:when>
                                                                                                <c:when
                                                                                                    test="${quote.status == 'Rejected'}">
                                                                                                    <span
                                                                                                        class="badge bg-danger">Từ
                                                                                                        chối</span>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="badge bg-light text-dark">${quote.status}</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>${quote.validUntil}</td>
                                                                                        <td>${quote.createdAt}</td>
                                                                                        <td>
                                                                                            <button type="button"
                                                                                                class="btn btn-sm btn-outline-info"
                                                                                                title="Xem chi tiết Báo giá"
                                                                                                data-bs-toggle="modal"
                                                                                                data-bs-target="#quoteDetailModal-${quote.id}">
                                                                                                <i
                                                                                                    class="fa fa-eye"></i>
                                                                                                Xem & Duyệt
                                                                                            </button>

                                                                                            <c:if
                                                                                                test="${quote.status == 'Pending Approval'}">
                                                                                                <button type="button"
                                                                                                    class="btn btn-sm btn-success ms-1"
                                                                                                    title="Duyệt Nhanh"
                                                                                                    onclick="showQuoteConfirmModal('approve', '${quote.id}', '${fn:escapeXml(quote.quoteNumber)}', '${quote.opportunityId != null ? quote.opportunityId : 0}')">
                                                                                                    <i
                                                                                                        class="fa fa-check"></i>
                                                                                                </button>
                                                                                                <button type="button"
                                                                                                    class="btn btn-sm btn-danger ms-1"
                                                                                                    title="Từ chối Nhanh"
                                                                                                    onclick="showQuoteConfirmModal('reject', '${quote.id}', '${fn:escapeXml(quote.quoteNumber)}', '${quote.opportunityId != null ? quote.opportunityId : 0}')">
                                                                                                    <i
                                                                                                        class="fa fa-times"></i>
                                                                                                </button>
                                                                                            </c:if>
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
                                                    <!-- Bỏ đóng div content quá sớm ở đây -->

                                                    <!-- Modals Chi tiết Báo giá cho từng Quote -->
                                                    <c:forEach var="q" items="${quoteList}">
                                                        <div class="modal fade" id="quoteDetailModal-${q.id}"
                                                            tabindex="-1" aria-hidden="true">
                                                            <div class="modal-dialog modal-lg modal-dialog-centered">
                                                                <div class="modal-content">
                                                                    <div class="modal-header bg-light">
                                                                        <h5 class="modal-title"><i
                                                                                class="fa fa-file-invoice text-primary me-2"></i>Chi
                                                                            tiết Báo giá: ${q.quoteNumber}</h5>
                                                                        <button type="button" class="btn-close"
                                                                            data-bs-dismiss="modal"
                                                                            aria-label="Close"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <div class="row mb-3">
                                                                            <div class="col-md-6">
                                                                                <p class="mb-1"><strong>Chủ đề:</strong>
                                                                                    ${q.subject}
                                                                                </p>
                                                                                <p class="mb-1"><strong>Cơ hội:</strong>
                                                                                    ${q.opportunityName}</p>
                                                                                <p class="mb-1"><strong>Nhân viên kinh
                                                                                        doanh:</strong>
                                                                                    ${q.creatorName}</p>
                                                                            </div>
                                                                            <div class="col-md-6 text-md-end">
                                                                                <p class="mb-1"><strong>Trạng
                                                                                        thái:</strong>
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${q.status == 'Pending Approval'}">
                                                                                            <span
                                                                                                class="badge bg-warning text-dark">Chờ
                                                                                                duyệt</span>
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${q.status == 'Approved'}">
                                                                                            <span
                                                                                                class="badge bg-success">Đã
                                                                                                duyệt</span>
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${q.status == 'Sent'}">
                                                                                            <span
                                                                                                class="badge bg-info text-dark">Đã
                                                                                                gửi khách</span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span
                                                                                                class="badge bg-secondary">${q.status}</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </p>
                                                                                <c:if
                                                                                    test="${q.status == 'Rejected' && not empty q.rejectionReason}">
                                                                                    <div
                                                                                        class="alert alert-danger py-2 mt-2 text-start">
                                                                                        <strong>Lí do từ chối:</strong>
                                                                                        ${fn:escapeXml(q.rejectionReason)}
                                                                                    </div>
                                                                                </c:if>
                                                                                <p class="mb-1"><strong>Ngày
                                                                                        tạo:</strong>
                                                                                    ${q.createdAt}</p>
                                                                                <p class="mb-1"><strong>Hiệu lực
                                                                                        đến:</strong>
                                                                                    ${q.validUntil}</p>
                                                                            </div>
                                                                        </div>
                                                                        <h6 class="border-bottom pb-2">Danh sách Sản
                                                                            phẩm
                                                                        </h6>
                                                                        <div class="table-responsive">
                                                                            <table
                                                                                class="table table-sm table-bordered">
                                                                                <thead class="table-light">
                                                                                    <tr>
                                                                                        <th>Sản phẩm</th>
                                                                                        <th class="text-end">Đơn giá
                                                                                        </th>
                                                                                        <th class="text-center">SL</th>
                                                                                        <th class="text-end">Chiết khấu
                                                                                        </th>
                                                                                        <th class="text-end">Thành tiền
                                                                                        </th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody>
                                                                                    <c:if test="${empty q.details}">
                                                                                        <tr>
                                                                                            <td colspan="5"
                                                                                                class="text-center text-muted">
                                                                                                Không có
                                                                                                sản phẩm nào.</td>
                                                                                        </tr>
                                                                                    </c:if>
                                                                                    <c:forEach var="detail"
                                                                                        items="${q.details}">
                                                                                        <tr>
                                                                                            <td>
                                                                                                ${empty
                                                                                                detail.productName ?
                                                                                                '#'.concat(detail.productId)
                                                                                                :
                                                                                                detail.productName}
                                                                                                ${empty
                                                                                                detail.productName ?
                                                                                                ' (Sản phẩm
                                                                                                trống)' : ''}
                                                                                            </td>
                                                                                            <td class="text-end">
                                                                                                <fmt:formatNumber
                                                                                                    value="${detail.unitPrice}"
                                                                                                    type="currency"
                                                                                                    currencySymbol="₫" />
                                                                                            </td>
                                                                                            <td class="text-center">
                                                                                                ${detail.quantity}
                                                                                            </td>
                                                                                            <td class="text-end">
                                                                                                <fmt:formatNumber
                                                                                                    value="${detail.discount}"
                                                                                                    type="currency"
                                                                                                    currencySymbol="₫" />
                                                                                            </td>
                                                                                            <td
                                                                                                class="text-end fw-bold">
                                                                                                <fmt:formatNumber
                                                                                                    value="${(detail.unitPrice * detail.quantity) - detail.discount}"
                                                                                                    type="currency"
                                                                                                    currencySymbol="₫" />
                                                                                            </td>
                                                                                        </tr>
                                                                                    </c:forEach>
                                                                                </tbody>
                                                                                <tfoot class="table-light fw-bold">
                                                                                    <tr>
                                                                                        <td colspan="4"
                                                                                            class="text-end">
                                                                                            Tổng cộng:</td>
                                                                                        <td
                                                                                            class="text-end text-primary fs-5">
                                                                                            <fmt:formatNumber
                                                                                                value="${q.grandTotal}"
                                                                                                type="currency"
                                                                                                currencySymbol="₫" />
                                                                                        </td>
                                                                                    </tr>
                                                                                </tfoot>
                                                                            </table>
                                                                        </div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-secondary"
                                                                            data-bs-dismiss="modal">Đóng</button>
                                                                        <c:if test="${q.status == 'Pending Approval'}">
                                                                            <button type="button"
                                                                                class="btn btn-success"
                                                                                onclick="showQuoteConfirmModal('approve', '${q.id}', '${fn:escapeXml(q.quoteNumber)}', '${q.opportunityId != null ? q.opportunityId : 0}')">
                                                                                <i class="fa fa-check-circle me-1"></i>
                                                                                Phê duyệt
                                                                                ngay
                                                                            </button>
                                                                            <button type="button"
                                                                                class="btn btn-danger ms-2"
                                                                                onclick="showQuoteConfirmModal('reject', ${q.id}, '${fn:escapeXml(q.quoteNumber)}', ${q.opportunityId != null ? q.opportunityId : 0})">
                                                                                <i class="fa fa-times-circle me-1"></i>
                                                                                Từ chối
                                                                            </button>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>

                                                    <%-- Quote Confirmation Modal --%>
                                                        <div class="modal fade" id="quoteConfirmModal" tabindex="-1"
                                                            aria-hidden="true">
                                                            <div class="modal-dialog modal-dialog-centered">
                                                                <div class="modal-content border-0 shadow">
                                                                    <div
                                                                        class="modal-header bg-primary text-white border-0">
                                                                        <h5 class="modal-title" id="confirmTitle">Xác
                                                                            nhận
                                                                        </h5>
                                                                        <button type="button"
                                                                            class="btn-close btn-close-white"
                                                                            data-bs-dismiss="modal"
                                                                            aria-label="Close"></button>
                                                                    </div>
                                                                    <form id="confirmActionForm"
                                                                        action="${pageContext.request.contextPath}/sales/quote"
                                                                        method="post">
                                                                        <div class="modal-body p-4 text-center">
                                                                            <div id="confirmIcon" class="mb-3">
                                                                                <i
                                                                                    class="fa fa-question-circle fa-4x text-primary"></i>
                                                                            </div>
                                                                            <h5 id="confirmSubject" class="mb-2"></h5>
                                                                            <p id="confirmMessage"
                                                                                class="text-muted mb-3">
                                                                            </p>
                                                                            <div id="rejectionReasonWrapper"
                                                                                style="display: none;">
                                                                                <label
                                                                                    class="form-label fw-bold d-block text-start">Lí
                                                                                    do từ chối <span
                                                                                        class="text-danger">*</span></label>
                                                                                <textarea name="reason"
                                                                                    id="rejectionReason"
                                                                                    class="form-control" rows="3"
                                                                                    placeholder="Nhập lí do từ chối..."></textarea>
                                                                            </div>
                                                                        </div>
                                                                        <div
                                                                            class="modal-footer border-0 justify-content-center pb-4">
                                                                            <input type="hidden" name="action"
                                                                                id="confirmAction">
                                                                            <input type="hidden" name="quoteId"
                                                                                id="confirmQuoteId">
                                                                            <input type="hidden" name="opportunityId"
                                                                                id="confirmOppId">
                                                                            <input type="hidden" name="source"
                                                                                value="manager-list">
                                                                            <button type="button"
                                                                                class="btn btn-light px-4"
                                                                                data-bs-dismiss="modal">Hủy</button>
                                                                            <button type="submit" id="confirmBtn"
                                                                                class="btn btn-primary px-4">Đồng
                                                                                ý</button>
                                                                        </div>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <%@ include file="/includes/footer.jsp" %>
                                        </div>
                                        <!-- Content End -->
                                        <!-- Back to Top -->
                                        <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                                class="bi bi-arrow-up"></i></a>
                            </div>
                            <%@ include file="/includes/scripts.jsp" %>
                                <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        var spinner = document.getElementById('spinner');
                                        if (spinner) {
                                            spinner.classList.remove('show');
                                        }
                                    });
                                    function showQuoteConfirmModal(action, quoteId, quoteNumber, oppId) {
                                        const title = document.getElementById('confirmTitle');
                                        const subject = document.getElementById('confirmSubject');
                                        const message = document.getElementById('confirmMessage');
                                        const icon = document.getElementById('confirmIcon');
                                        const btn = document.getElementById('confirmBtn');
                                        const actionInput = document.getElementById('confirmAction');
                                        const quoteIdInput = document.getElementById('confirmQuoteId');
                                        const oppIdInput = document.getElementById('confirmOppId');
                                        actionInput.value = action;
                                        quoteIdInput.value = quoteId;
                                        oppIdInput.value = oppId;
                                        subject.innerText = "Báo giá: " + quoteNumber;
                                        btn.className = "btn px-4 ";
                                        icon.innerHTML = "";

                                        // Reset rejection field
                                        const reasonWrapper = document.getElementById('rejectionReasonWrapper');
                                        const reasonInput = document.getElementById('rejectionReason');
                                        reasonWrapper.style.display = "none";
                                        reasonInput.required = false;
                                        reasonInput.value = "";
                                        if (action === 'approve') {
                                            title.innerText = "Duyệt báo giá";
                                            message.innerText = "Duyệt báo giá này? Trạng thái sẽ chuyển thành Đã duyệt (Approved) để Sales có thể gửi cho khách hàng.";
                                            btn.classList.add("btn-success");
                                            icon.innerHTML = '<i class="fa fa-check-circle fa-4x text-success"></i>';
                                            btn.innerText = "Duyệt Báo giá";
                                        } else if (action === 'reject') {
                                            title.innerText = "Từ chối báo giá";
                                            message.innerText = "Đánh dấu báo giá này là bị từ chối?";
                                            btn.classList.add("btn-danger");
                                            icon.innerHTML = '<i class="fa fa-times-circle fa-4x text-danger"></i>';
                                            btn.innerText = "Từ chối";

                                            // Show reason field
                                            reasonWrapper.style.display = "block";
                                            reasonInput.required = true;
                                        }
                                        // Ẩn modal detail nếu đang hiển thị
                                        var detailModalEl = document.getElementById('quoteDetailModal-' + quoteId);
                                        if (detailModalEl) {
                                            var detailModal = bootstrap.Modal.getInstance(detailModalEl);
                                            if (detailModal) detailModal.hide();
                                        }
                                        var confirmModal = new bootstrap.Modal(document.getElementById('quoteConfirmModal'));
                                        confirmModal.show();
                                    }
                                </script>
                        </body>

                        </html>