<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <% request.setAttribute("currentPage", "opportunities" ); %>
                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <title>${fn:escapeXml(opp.name)} - Chi tiết Cơ hội</title>
                        <%@ include file="/includes/head.jsp" %>
                            <style>
                                .stage-badge {
                                    font-size: 0.85rem;
                                    padding: 5px 12px;
                                    border-radius: 20px;
                                    font-weight: 600;
                                }

                                .stage-Prospecting {
                                    background: #e9ecef;
                                    color: #495057;
                                }

                                .stage-Qualification {
                                    background: #cfe2ff;
                                    color: #084298;
                                }

                                .stage-Proposal {
                                    background: #e0cffc;
                                    color: #3d0a91;
                                }

                                .stage-Negotiation {
                                    background: #fff3cd;
                                    color: #856404;
                                }

                                .stage-Won {
                                    background: #d1e7dd;
                                    color: #0a3622;
                                }

                                .stage-Lost {
                                    background: #f8d7da;
                                    color: #58151c;
                                }

                                .quote-status-badge {
                                    font-size: 0.78rem;
                                    padding: 4px 10px;
                                    border-radius: 12px;
                                    font-weight: 600;
                                }

                                .nav-tabs .nav-link {
                                    font-weight: 500;
                                }

                                .locked-banner {
                                    border-left: 4px solid;
                                    padding: 10px 16px;
                                    border-radius: 6px;
                                }
                            </style>
                    </head>

                    <body>
                        <div class="container-xxl position-relative bg-white d-flex p-0">
                            <div id="spinner"
                                class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                                <div class="spinner-border text-primary" style="width:3rem;height:3rem;" role="status">
                                    <span class="sr-only">Loading...</span>
                                </div>
                            </div>

                            <%@ include file="/includes/sidebar.jsp" %>

                                <div class="content">
                                    <%@ include file="/includes/topbar.jsp" %>

                                        <div class="container-fluid pt-4 px-4">

                                            <%-- Header --%>
                                                <div class="d-flex align-items-center gap-3 mb-3">
                                                    <a href="${pageContext.request.contextPath}/sales/opportunities"
                                                        class="btn btn-outline-secondary btn-sm">
                                                        <i class="fa fa-arrow-left me-1"></i>Quay lại
                                                    </a>
                                                    <h4 class="mb-0"><i
                                                            class="fa fa-handshake me-2 text-primary"></i>${fn:escapeXml(opp.name)}
                                                    </h4>
                                                    <span class="stage-badge stage-${opp.stage}">${opp.stage}</span>
                                                </div>

                                                <%-- Lock banner --%>
                                                    <c:if test="${opp.stage == 'Won' || opp.stage == 'Lost'}">
                                                        <div class="alert ${opp.stage == 'Won' ? 'alert-success' : 'alert-danger'} locked-banner mb-3"
                                                            role="alert">
                                                            <i
                                                                class="fa ${opp.stage == 'Won' ? 'fa-trophy' : 'fa-times-circle'} me-2"></i>
                                                            <strong>Cơ hội này đã ${opp.stage == 'Won' ? 'thành công
                                                                (Won)' : 'thất bại (Lost)'}.</strong>
                                                            Không thể tạo thêm báo giá hoặc thay đổi trạng thái.
                                                        </div>
                                                    </c:if>

                                                    <%-- Error message from session --%>
                                                        <c:if test="${not empty sessionScope.quoteError}">
                                                            <div class="alert alert-warning alert-dismissible fade show"
                                                                role="alert">
                                                                <i
                                                                    class="fa fa-exclamation-triangle me-2"></i>${sessionScope.quoteError}
                                                                <button type="button" class="btn-close"
                                                                    data-bs-dismiss="alert"></button>
                                                            </div>
                                                            <% session.removeAttribute("quoteError"); %>
                                                        </c:if>

                                                        <%-- Tabs --%>
                                                            <ul class="nav nav-tabs mb-3" id="oppTabs">
                                                                <li class="nav-item">
                                                                    <a class="nav-link ${activeTab == 'overview' ? 'active' : ''}"
                                                                        href="${pageContext.request.contextPath}/sales/opportunity-detail?id=${opp.id}&tab=overview">
                                                                        <i class="fa fa-info-circle me-1"></i>Tổng quan
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a class="nav-link ${activeTab == 'quotes' ? 'active' : ''}"
                                                                        href="${pageContext.request.contextPath}/sales/opportunity-detail?id=${opp.id}&tab=quotes">
                                                                        <i class="fa fa-file-invoice me-1"></i>Báo giá
                                                                        <c:if test="${not empty quotes}">
                                                                            <span
                                                                                class="badge bg-primary ms-1">${fn:length(quotes)}</span>
                                                                        </c:if>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a class="nav-link ${activeTab == 'activity' ? 'active' : ''}"
                                                                        href="${pageContext.request.contextPath}/sales/opportunity-detail?id=${opp.id}&tab=activity">
                                                                        <i class="fa fa-history me-1"></i>Hoạt động
                                                                    </a>
                                                                </li>
                                                            </ul>

                                                            <%--====================TAB:
                                                                OVERVIEW====================--%>
                                                                <c:if test="${activeTab == 'overview'}">
                                                                    <div class="row g-4">
                                                                        <div class="col-md-7">
                                                                            <div class="bg-light rounded p-4">
                                                                                <h6
                                                                                    class="text-muted text-uppercase fw-bold mb-3">
                                                                                    Thông tin Cơ hội</h6>
                                                                                <table
                                                                                    class="table table-borderless mb-0">
                                                                                    <tr>
                                                                                        <td class="text-muted"
                                                                                            style="width:40%">Tên cơ hội
                                                                                        </td>
                                                                                        <td><strong>${fn:escapeXml(opp.name)}</strong>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td class="text-muted">Giai đoạn
                                                                                        </td>
                                                                                        <td><span
                                                                                                class="stage-badge stage-${opp.stage}">${opp.stage}</span>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td class="text-muted">Xác suất
                                                                                        </td>
                                                                                        <td>
                                                                                            <div class="progress"
                                                                                                style="height:8px;width:120px;display:inline-block;vertical-align:middle;">
                                                                                                <div class="progress-bar"
                                                                                                    style="width:${opp.probability}%">
                                                                                                </div>
                                                                                            </div>
                                                                                            <small
                                                                                                class="ms-2">${opp.probability}%</small>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td class="text-muted">Giá trị
                                                                                            dự kiến</td>
                                                                                        <td
                                                                                            class="text-success fw-bold">
                                                                                            <fmt:formatNumber
                                                                                                value="${opp.expectedValue}"
                                                                                                type="currency"
                                                                                                currencySymbol="₫" />
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td class="text-muted">Số báo
                                                                                            giá</td>
                                                                                        <td><span
                                                                                                class="badge bg-info">${opp.quoteCount}</span>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td class="text-muted">Ngày tạo
                                                                                        </td>
                                                                                        <td>${opp.createdAt}</td>
                                                                                    </tr>
                                                                                </table>
                                                                            </div>
                                                                        </div>
                                                                        <div class="col-md-5">
                                                                            <div class="bg-light rounded p-4 h-100">
                                                                                <h6
                                                                                    class="text-muted text-uppercase fw-bold mb-3">
                                                                                    Hành động nhanh</h6>
                                                                                <c:if
                                                                                    test="${opp.stage != 'Won' && opp.stage != 'Lost'}">
                                                                                    <button type="button"
                                                                                        class="btn btn-success w-100 mb-2"
                                                                                        data-bs-toggle="modal"
                                                                                        data-bs-target="#createQuoteModal">
                                                                                        <i
                                                                                            class="fa fa-plus me-2"></i>Tạo
                                                                                        Báo giá mới
                                                                                    </button>
                                                                                </c:if>
                                                                                <c:if
                                                                                    test="${opp.stage != 'Won' && opp.stage != 'Lost'}">
                                                                                    <form
                                                                                        action="${pageContext.request.contextPath}/sales/opportunities"
                                                                                        method="post" class="mb-2">
                                                                                        <input type="hidden"
                                                                                            name="opportunityId"
                                                                                            value="${opp.id}">
                                                                                        <div class="input-group">
                                                                                            <select name="stage"
                                                                                                class="form-select form-select-sm"
                                                                                                onchange="this.form.submit()">
                                                                                                <option
                                                                                                    value="Prospecting"
                                                                                                    ${opp.stage=='Prospecting'
                                                                                                    ?'selected':''}>Tìm
                                                                                                    kiếm</option>
                                                                                                <option
                                                                                                    value="Qualification"
                                                                                                    ${opp.stage=='Qualification'
                                                                                                    ?'selected':''}>Đánh
                                                                                                    giá</option>
                                                                                                <option value="Proposal"
                                                                                                    ${opp.stage=='Proposal'
                                                                                                    ?'selected':''}>Đề
                                                                                                    xuất</option>
                                                                                                <option
                                                                                                    value="Negotiation"
                                                                                                    ${opp.stage=='Negotiation'
                                                                                                    ?'selected':''}>
                                                                                                    Thương lượng
                                                                                                </option>
                                                                                                <option value="Won"
                                                                                                    ${opp.stage=='Won'
                                                                                                    ?'selected':''}>✅
                                                                                                    Thành công</option>
                                                                                                <option value="Lost"
                                                                                                    ${opp.stage=='Lost'
                                                                                                    ?'selected':''}>❌
                                                                                                    Thất bại</option>
                                                                                            </select>
                                                                                            <button type="submit"
                                                                                                class="btn btn-outline-secondary btn-sm">Đổi</button>
                                                                                        </div>
                                                                                    </form>
                                                                                </c:if>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </c:if>

                                                                <%--====================TAB:
                                                                    QUOTES====================--%>
                                                                    <c:if test="${activeTab == 'quotes'}">
                                                                        <div class="bg-light rounded p-4">
                                                                            <div
                                                                                class="d-flex justify-content-between align-items-center mb-3">
                                                                                <h6
                                                                                    class="mb-0 text-muted text-uppercase fw-bold">
                                                                                    Danh sách Báo giá</h6>
                                                                                <c:if
                                                                                    test="${opp.stage != 'Won' && opp.stage != 'Lost'}">
                                                                                    <button
                                                                                        class="btn btn-success btn-sm"
                                                                                        data-bs-toggle="modal"
                                                                                        data-bs-target="#createQuoteModal">
                                                                                        <i
                                                                                            class="fa fa-plus me-1"></i>Tạo
                                                                                        Báo giá
                                                                                    </button>
                                                                                </c:if>
                                                                            </div>

                                                                            <c:if test="${hasActiveSent}">
                                                                                <div class="alert alert-info py-2 mb-3">
                                                                                    <i
                                                                                        class="fa fa-info-circle me-2"></i>
                                                                                    Hiện có 1 báo giá đang được gửi. Chờ
                                                                                    phản hồi trước khi gửi báo giá khác.
                                                                                </div>
                                                                            </c:if>

                                                                            <c:choose>
                                                                                <c:when test="${empty quotes}">
                                                                                    <div
                                                                                        class="text-center text-muted py-5">
                                                                                        <i
                                                                                            class="fa fa-file-invoice fa-3x mb-3 d-block"></i>
                                                                                        Chưa có báo giá nào.<br>
                                                                                        <small>Tạo báo giá đầu tiên để
                                                                                            bắt đầu.</small>
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <div class="table-responsive">
                                                                                        <table
                                                                                            class="table table-hover align-middle">
                                                                                            <thead>
                                                                                                <tr>
                                                                                                    <th>Số BG</th>
                                                                                                    <th>Chủ đề</th>
                                                                                                    <th>Tổng tiền</th>
                                                                                                    <th>Trạng thái</th>
                                                                                                    <th>Hết hạn</th>
                                                                                                    <th>Ngày tạo</th>
                                                                                                    <th>Thao tác</th>
                                                                                                </tr>
                                                                                            </thead>
                                                                                            <tbody>
                                                                                                <c:forEach var="q"
                                                                                                    items="${quotes}">
                                                                                                    <tr>
                                                                                                        <td><strong>${fn:escapeXml(q.quoteNumber)}</strong>
                                                                                                        </td>
                                                                                                        <td>${fn:escapeXml(q.subject)}
                                                                                                        </td>
                                                                                                        <td
                                                                                                            class="text-primary fw-bold">
                                                                                                            <fmt:formatNumber
                                                                                                                value="${q.grandTotal}"
                                                                                                                type="currency"
                                                                                                                currencySymbol="₫" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <c:choose>
                                                                                                                <c:when
                                                                                                                    test="${q.status == 'Draft'}">
                                                                                                                    <span
                                                                                                                        class="quote-status-badge bg-secondary text-white">Bản
                                                                                                                        nháp</span>
                                                                                                                </c:when>
                                                                                                                <c:when
                                                                                                                    test="${q.status == 'Sent'}">
                                                                                                                    <span
                                                                                                                        class="quote-status-badge bg-info text-dark">Đã
                                                                                                                        gửi</span>
                                                                                                                </c:when>
                                                                                                                <c:when
                                                                                                                    test="${q.status == 'Accepted'}">
                                                                                                                    <span
                                                                                                                        class="quote-status-badge bg-success text-white">Chấp
                                                                                                                        nhận</span>
                                                                                                                </c:when>
                                                                                                                <c:when
                                                                                                                    test="${q.status == 'Rejected'}">
                                                                                                                    <span
                                                                                                                        class="quote-status-badge bg-danger text-white">Từ
                                                                                                                        chối</span>
                                                                                                                </c:when>
                                                                                                                <c:when
                                                                                                                    test="${q.status == 'Expired'}">
                                                                                                                    <span
                                                                                                                        class="quote-status-badge bg-warning text-dark">Hết
                                                                                                                        hạn</span>
                                                                                                                </c:when>
                                                                                                                <c:otherwise>
                                                                                                                    <span
                                                                                                                        class="quote-status-badge bg-light text-dark">${q.status}</span>
                                                                                                                </c:otherwise>
                                                                                                            </c:choose>
                                                                                                        </td>
                                                                                                        <td>${q.validUntil}
                                                                                                        </td>
                                                                                                        <td>${q.createdAt}
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <div
                                                                                                                class="d-flex gap-1">
                                                                                                                <%-- Gửi
                                                                                                                    (chỉ
                                                                                                                    Draft,
                                                                                                                    không
                                                                                                                    có
                                                                                                                    Sent
                                                                                                                    khác)
                                                                                                                    --%>
                                                                                                                    <c:if
                                                                                                                        test="${q.status == 'Draft' && !hasActiveSent && opp.stage != 'Won' && opp.stage != 'Lost'}">
                                                                                                                        <button
                                                                                                                            type="button"
                                                                                                                            class="btn btn-sm btn-outline-info"
                                                                                                                            title="Gửi báo giá"
                                                                                                                            onclick="showQuoteConfirmModal('send', ${q.id}, '${q.quoteNumber}')">
                                                                                                                            <i
                                                                                                                                class="fa fa-paper-plane"></i>
                                                                                                                        </button>
                                                                                                                    </c:if>
                                                                                                                    <%-- Chấp
                                                                                                                        nhận
                                                                                                                        /
                                                                                                                        Từ
                                                                                                                        chối
                                                                                                                        (chỉ
                                                                                                                        Sent)
                                                                                                                        --%>
                                                                                                                        <c:if
                                                                                                                            test="${q.status == 'Sent'}">
                                                                                                                            <button
                                                                                                                                type="button"
                                                                                                                                class="btn btn-sm btn-success"
                                                                                                                                title="Chấp nhận"
                                                                                                                                onclick="showQuoteConfirmModal('accept', ${q.id}, '${q.quoteNumber}')">
                                                                                                                                <i
                                                                                                                                    class="fa fa-check"></i>
                                                                                                                            </button>
                                                                                                                            <button
                                                                                                                                type="button"
                                                                                                                                class="btn btn-sm btn-outline-danger"
                                                                                                                                title="Từ chối"
                                                                                                                                onclick="showQuoteConfirmModal('reject', ${q.id}, '${q.quoteNumber}')">
                                                                                                                                <i
                                                                                                                                    class="fa fa-times"></i>
                                                                                                                            </button>
                                                                                                                        </c:if>
                                                                                                                        <%-- Xóa
                                                                                                                            (chỉ
                                                                                                                            Draft)
                                                                                                                            --%>
                                                                                                                            <c:if
                                                                                                                                test="${q.status == 'Draft' && opp.stage != 'Won' && opp.stage != 'Lost'}">
                                                                                                                                <button
                                                                                                                                    type="button"
                                                                                                                                    class="btn btn-sm btn-outline-secondary"
                                                                                                                                    title="Xóa bản nháp"
                                                                                                                                    onclick="showQuoteConfirmModal('delete', ${q.id}, '${q.quoteNumber}')">
                                                                                                                                    <i
                                                                                                                                        class="fa fa-trash"></i>
                                                                                                                                </button>
                                                                                                                            </c:if>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </c:forEach>
                                                                                            </tbody>
                                                                                        </table>
                                                                                    </div>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </c:if>

                                                                    <%--====================TAB:
                                                                        ACTIVITY====================--%>
                                                                        <c:if test="${activeTab == 'activity'}">
                                                                            <div class="bg-light rounded p-4">
                                                                                <h6
                                                                                    class="text-muted text-uppercase fw-bold mb-3">
                                                                                    Lịch sử Hoạt động</h6>
                                                                                <div
                                                                                    class="text-center text-muted py-5">
                                                                                    <i
                                                                                        class="fa fa-history fa-3x mb-3 d-block"></i>
                                                                                    <p>Lịch sử tương tác sẽ hiển thị ở
                                                                                        đây.</p>
                                                                                    <small class="text-muted">(Ghi log
                                                                                        call, email, meeting từ
                                                                                        Interactions)</small>
                                                                                </div>
                                                                            </div>
                                                                        </c:if>

                                        </div><%-- /container-fluid --%>


                                            <%-- Create Quote Modal --%>
                                                <div class="modal fade" id="createQuoteModal" tabindex="-1"
                                                    aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content border-0 shadow">
                                                            <div class="modal-header bg-success text-white border-0">
                                                                <h5 class="modal-title"><i
                                                                        class="fa fa-file-invoice me-2"></i>Tạo Báo giá
                                                                    mới</h5>
                                                                <button type="button" class="btn-close btn-close-white"
                                                                    data-bs-dismiss="modal" aria-label="Close"></button>
                                                            </div>
                                                            <form
                                                                action="${pageContext.request.contextPath}/sales/quote"
                                                                method="post">
                                                                <input type="hidden" name="action" value="create">
                                                                <input type="hidden" name="opportunityId"
                                                                    value="${opp.id}">
                                                                <div class="modal-body p-4">
                                                                    <div class="mb-3">
                                                                        <label class="form-label fw-bold">Chủ đề <span
                                                                                class="text-danger">*</span></label>
                                                                        <input type="text" name="subject"
                                                                            class="form-control"
                                                                            placeholder="Ví dụ: Báo giá gói phần mềm CRM"
                                                                            required>
                                                                    </div>
                                                                    <div class="mb-3">
                                                                        <label class="form-label fw-bold">Tổng tiền
                                                                            (VNĐ) <span
                                                                                class="text-danger">*</span></label>
                                                                        <input type="number" name="grandTotal"
                                                                            class="form-control" placeholder="0"
                                                                            required min="0">
                                                                    </div>
                                                                    <div class="mb-0">
                                                                        <label class="form-label fw-bold">Có hiệu lực
                                                                            đến</label>
                                                                        <input type="date" name="validUntil"
                                                                            class="form-control">
                                                                    </div>
                                                                </div>
                                                                <div
                                                                    class="modal-footer border-0 pt-0 pb-4 justify-content-center">
                                                                    <button type="button" class="btn btn-light px-4"
                                                                        data-bs-dismiss="modal">Hủy</button>
                                                                    <button type="submit"
                                                                        class="btn btn-success px-4">Tạo bản
                                                                        nháp</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>

                                                <%-- Quote Confirmation Modal --%>
                                                    <div class="modal fade" id="quoteConfirmModal" tabindex="-1"
                                                        aria-hidden="true">
                                                        <div class="modal-dialog modal-dialog-centered">
                                                            <div class="modal-content border-0 shadow">
                                                                <div
                                                                    class="modal-header bg-primary text-white border-0">
                                                                    <h5 class="modal-title" id="confirmTitle">Xác nhận
                                                                    </h5>
                                                                    <button type="button"
                                                                        class="btn-close btn-close-white"
                                                                        data-bs-dismiss="modal"
                                                                        aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body p-4 text-center">
                                                                    <div id="confirmIcon" class="mb-3">
                                                                        <i
                                                                            class="fa fa-question-circle fa-4x text-primary"></i>
                                                                    </div>
                                                                    <h5 id="confirmSubject" class="mb-2"></h5>
                                                                    <p id="confirmMessage" class="text-muted mb-0"></p>
                                                                </div>
                                                                <div
                                                                    class="modal-footer border-0 justify-content-center pb-4">
                                                                    <form id="confirmActionForm"
                                                                        action="${pageContext.request.contextPath}/sales/quote"
                                                                        method="post">
                                                                        <input type="hidden" name="action"
                                                                            id="confirmAction">
                                                                        <input type="hidden" name="quoteId"
                                                                            id="confirmQuoteId">
                                                                        <input type="hidden" name="opportunityId"
                                                                            value="${opp.id}">
                                                                        <button type="button" class="btn btn-light px-4"
                                                                            data-bs-dismiss="modal">Hủy</button>
                                                                        <button type="submit" id="confirmBtn"
                                                                            class="btn btn-primary px-4">Đồng ý</button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <%@ include file="/includes/footer.jsp" %>
                                </div>
                        </div>
                        <%@ include file="/includes/scripts.jsp" %>
                            <script>
                                document.addEventListener('DOMContentLoaded', function () {
                                    var spinner = document.getElementById('spinner');
                                    if (spinner) {
                                        spinner.classList.remove('show');
                                    }
                                });
                                function showQuoteConfirmModal(action, quoteId, quoteNumber) {
                                    const title = document.getElementById('confirmTitle');
                                    const subject = document.getElementById('confirmSubject');
                                    const message = document.getElementById('confirmMessage');
                                    const icon = document.getElementById('confirmIcon');
                                    const btn = document.getElementById('confirmBtn');
                                    const actionInput = document.getElementById('confirmAction');
                                    const quoteIdInput = document.getElementById('confirmQuoteId');
                                    actionInput.value = action;
                                    quoteIdInput.value = quoteId;
                                    subject.innerText = "Báo giá: " + quoteNumber;
                                    btn.className = "btn px-4 ";
                                    icon.innerHTML = "";
                                    if (action === 'send') {
                                        title.innerText = "Gửi báo giá";
                                        message.innerText = "Bạn có chắc chắn muốn gửi báo giá này cho khách hàng?";
                                        btn.classList.add("btn-info", "text-white");
                                        icon.innerHTML = '<i class="fa fa-paper-plane fa-4x text-info"></i>';
                                        btn.innerText = "Gửi ngay";
                                    } else if (action === 'accept') {
                                        title.innerText = "Chấp nhận báo giá";
                                        message.innerText = "Cơ hội sẽ chuyển sang Won và tự động tạo thông tin khách hàng. Không thể hoàn tác.";
                                        btn.classList.add("btn-success");
                                        icon.innerHTML = '<i class="fa fa-check-circle fa-4x text-success"></i>';
                                        btn.innerText = "Chấp nhận & Tạo khách hàng";
                                    } else if (action === 'reject') {
                                        title.innerText = "Từ chối báo giá";
                                        message.innerText = "Đánh dấu báo giá này là bị từ chối?";
                                        btn.classList.add("btn-danger");
                                        icon.innerHTML = '<i class="fa fa-times-circle fa-4x text-danger"></i>';
                                        btn.innerText = "Từ chối";
                                    } else if (action === 'delete') {
                                        title.innerText = "Xóa báo giá";
                                        message.innerText = "Bạn có chắc chắn muốn xóa bản nháp báo giá này?";
                                        btn.classList.add("btn-secondary");
                                        icon.innerHTML = '<i class="fa fa-trash fa-4x text-secondary"></i>';
                                        btn.innerText = "Xóa ngay";
                                    }
                                    var confirmModal = new bootstrap.Modal(document.getElementById('quoteConfirmModal'));
                                    confirmModal.show();
                                }
                            </script>
                    </body>

                    </html>