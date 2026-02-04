<%-- transfer-inbox.jsp - Hộp thư Yêu cầu Chuyển giao --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <% request.setAttribute("currentPage", "transfers" ); %>

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <title>Yêu cầu Chuyển giao - CRM System</title>
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

                                                <!-- Transfer Inbox Content -->
                                                <div class="container-fluid pt-4 px-4">
                                                    <!-- Page Header -->
                                                    <div class="row mb-4">
                                                        <div class="col-12">
                                                            <div
                                                                class="d-flex justify-content-between align-items-center">
                                                                <h3 class="mb-0"><i
                                                                        class="fa fa-exchange-alt me-2"></i>Yêu cầu
                                                                    Chuyển giao</h3>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Tabs -->
                                                    <ul class="nav nav-tabs mb-3" id="transferTabs" role="tablist">
                                                        <li class="nav-item" role="presentation">
                                                            <button class="nav-link active" id="incoming-tab"
                                                                data-bs-toggle="tab" data-bs-target="#incoming"
                                                                type="button" role="tab">
                                                                <i class="fa fa-inbox me-2"></i>Yêu cầu đến
                                                                (${pendingIncoming != null ? pendingIncoming.size() :
                                                                0})
                                                            </button>
                                                        </li>
                                                        <li class="nav-item" role="presentation">
                                                            <button class="nav-link" id="outgoing-tab"
                                                                data-bs-toggle="tab" data-bs-target="#outgoing"
                                                                type="button" role="tab">
                                                                <i class="fa fa-paper-plane me-2"></i>Yêu cầu đi
                                                                (${pendingOutgoing != null ? pendingOutgoing.size() :
                                                                0})
                                                            </button>
                                                        </li>
                                                    </ul>

                                                    <div class="tab-content" id="transferTabsContent">
                                                        <!-- Incoming Requests Tab -->
                                                        <div class="tab-pane fade show active" id="incoming"
                                                            role="tabpanel">
                                                            <div class="bg-light rounded p-4">
                                                                <div class="table-responsive">
                                                                    <table class="table table-hover">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>Chiến dịch</th>
                                                                                <th>Từ Manager</th>
                                                                                <th>Ngân sách</th>
                                                                                <th>Ngày gửi yêu cầu</th>
                                                                                <th>Lý do</th>
                                                                                <th>Thao tác</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <c:choose>
                                                                                <c:when test="${empty pendingIncoming}">
                                                                                    <tr>
                                                                                        <td colspan="6"
                                                                                            class="text-center text-muted">
                                                                                            <i
                                                                                                class="fa fa-check-circle fa-2x mb-2 d-block text-success"></i>
                                                                                            Không có yêu cầu chuyển giao
                                                                                            nào
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <c:forEach var="transfer"
                                                                                        items="${pendingIncoming}">
                                                                                        <tr
                                                                                            id="transfer-row-${transfer.id}">
                                                                                            <td><strong>${transfer.campaignName}</strong>
                                                                                            </td>
                                                                                            <td>${transfer.fromManagerName}
                                                                                            </td>
                                                                                            <td>
                                                                                                <fmt:formatNumber
                                                                                                    value="${transfer.campaignBudget}"
                                                                                                    type="currency"
                                                                                                    currencySymbol="₫"
                                                                                                    groupingUsed="true" />
                                                                                            </td>
                                                                                            <td>
                                                                                                <fmt:formatDate
                                                                                                    value="${transfer.requestedAt}"
                                                                                                    pattern="dd/MM/yyyy HH:mm" />
                                                                                            </td>
                                                                                            <td>${transfer.transferReason}
                                                                                            </td>
                                                                                            <td>
                                                                                                <button
                                                                                                    class="btn btn-sm btn-success me-1"
                                                                                                    onclick="openReviewModal(${transfer.id}, '${transfer.campaignName}', '${transfer.fromManagerName}', '${transfer.transferReason}', true)">
                                                                                                    <i
                                                                                                        class="fa fa-check me-1"></i>Chấp
                                                                                                    nhận
                                                                                                </button>
                                                                                                <button
                                                                                                    class="btn btn-sm btn-danger"
                                                                                                    onclick="openReviewModal(${transfer.id}, '${transfer.campaignName}', '${transfer.fromManagerName}', '${transfer.transferReason}', false)">
                                                                                                    <i
                                                                                                        class="fa fa-times me-1"></i>Từ
                                                                                                    chối
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

                                                        <!-- Outgoing Requests Tab -->
                                                        <div class="tab-pane fade" id="outgoing" role="tabpanel">
                                                            <div class="bg-light rounded p-4">
                                                                <div class="table-responsive">
                                                                    <table class="table table-hover">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>Chiến dịch</th>
                                                                                <th>Đến Manager</th>
                                                                                <th>Ngày gửi yêu cầu</th>
                                                                                <th>Lý do</th>
                                                                                <th>Trạng thái</th>
                                                                                <th>Thao tác</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <c:choose>
                                                                                <c:when test="${empty pendingOutgoing}">
                                                                                    <tr>
                                                                                        <td colspan="6"
                                                                                            class="text-center text-muted">
                                                                                            Không có yêu cầu nào đang
                                                                                            chờ</td>
                                                                                    </tr>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <c:forEach var="transfer"
                                                                                        items="${pendingOutgoing}">
                                                                                        <tr
                                                                                            id="transfer-row-${transfer.id}">
                                                                                            <td><strong>${transfer.campaignName}</strong>
                                                                                            </td>
                                                                                            <td>${transfer.toManagerName}
                                                                                            </td>
                                                                                            <td>
                                                                                                <fmt:formatDate
                                                                                                    value="${transfer.requestedAt}"
                                                                                                    pattern="dd/MM/yyyy HH:mm" />
                                                                                            </td>
                                                                                            <td>${transfer.transferReason}
                                                                                            </td>
                                                                                            <td>
                                                                                                <span
                                                                                                    class="badge bg-warning text-dark">Pending</span>
                                                                                            </td>
                                                                                            <td>
                                                                                                <button
                                                                                                    class="btn btn-sm btn-secondary"
                                                                                                    onclick="cancelTransfer(${transfer.id}, '${transfer.campaignName}')">
                                                                                                    <i
                                                                                                        class="fa fa-times me-1"></i>Hủy
                                                                                                    bỏ
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

                        <!-- Review Modal for Incoming -->
                        <div class="modal fade" id="reviewModal" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="reviewModalTitle">Xử lý Yêu cầu</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p id="reviewReviewText"></p>
                                        <div class="mb-3">
                                            <label for="reviewNotes" class="form-label">Ghi chú (Tùy chọn)</label>
                                            <textarea class="form-control" id="reviewNotes" rows="3"></textarea>
                                        </div>
                                        <input type="hidden" id="reviewTransferId">
                                        <input type="hidden" id="reviewIsAccept">
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Đóng</button>
                                        <button type="button" class="btn" id="reviewConfirmBtn"
                                            onclick="submitReview()">Xác nhận</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Include Scripts --%>
                            <%@ include file="/includes/scripts.jsp" %>

                                <script>
                                    // Use standard JS/jQuery for interactivity
                                    function openReviewModal(id, campaignName, fromName, reason, isAccept) {
                                        document.getElementById('reviewTransferId').value = id;
                                        document.getElementById('reviewIsAccept').value = isAccept;
                                        document.getElementById('reviewNotes').value = '';

                                        const title = isAccept ? 'Chấp nhận Chuyển giao' : 'Từ chối Chuyển giao';
                                        const btnClass = isAccept ? 'btn-success' : 'btn-danger';
                                        const btnText = isAccept ? 'Chấp nhận' : 'Từ chối';

                                        document.getElementById('reviewModalTitle').textContent = title;
                                        const confirmBtn = document.getElementById('reviewConfirmBtn');
                                        confirmBtn.className = 'btn ' + btnClass;
                                        confirmBtn.textContent = btnText;

                                        document.getElementById('reviewReviewText').innerHTML =
                                            'Bạn có chắc chắn muốn <strong>' + (isAccept ? 'CHẤP NHẬN' : 'TỪ CHỐI') + '</strong> ' +
                                            'tiếp nhận chiến dịch: <strong>' + campaignName + '</strong>?<br>' +
                                            '<small class="text-muted">Từ: ' + fromName + '<br>Lý do: ' + reason + '</small>';

                                        new bootstrap.Modal(document.getElementById('reviewModal')).show();
                                    }

                                    function submitReview() {
                                        const id = document.getElementById('reviewTransferId').value;
                                        const isAccept = document.getElementById('reviewIsAccept').value === 'true';
                                        const notes = document.getElementById('reviewNotes').value;

                                        const action = isAccept ? 'accept' : 'reject';

                                        const params = new URLSearchParams();
                                        params.append('action', action);
                                        params.append('transferId', id);
                                        params.append('notes', notes);

                                        fetch('${pageContext.request.contextPath}/transfers', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                                            },
                                            body: params
                                        })
                                            .then(response => response.json())
                                            .then(result => {
                                                if (result.success) {
                                                    alert(result.message || 'Thành công');
                                                    window.location.reload();
                                                } else {
                                                    alert('Lỗi: ' + result.message);
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error:', error);
                                                alert('Có lỗi xảy ra');
                                            });
                                    }

                                    function cancelTransfer(id, campaignName) {
                                        if (!confirm('Bạn có chắc chắn muốn hủy yêu cầu chuyển giao chiến dịch "' + campaignName + '"?')) {
                                            return;
                                        }

                                        const params = new URLSearchParams();
                                        params.append('action', 'cancel');
                                        params.append('transferId', id);

                                        fetch('${pageContext.request.contextPath}/transfers', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                                            },
                                            body: params
                                        })
                                            .then(response => response.json())
                                            .then(result => {
                                                if (result.success) {
                                                    alert('Đã hủy yêu cầu chuyển giao.');
                                                    window.location.reload();
                                                } else {
                                                    alert('Lỗi: ' + result.message);
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error:', error);
                                                alert('Có lỗi xảy ra');
                                            });
                                    }

                                    // Hide spinner when page loads
                                    document.addEventListener('DOMContentLoaded', function () {
                                        var spinner = document.getElementById('spinner');
                                        if (spinner) {
                                            spinner.classList.remove('show');
                                        }
                                    });
                                </script>
                    </body>

                    </html>