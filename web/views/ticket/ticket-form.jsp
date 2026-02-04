<%-- ticket-form.jsp - Tạo Ticket Mới --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <title>${pageTitle} - CRM System</title>
                <%@ include file="/includes/head.jsp" %>
                    <style>
                        .search-results {
                            position: absolute;
                            z-index: 1000;
                            background: white;
                            border: 1px solid #ced4da;
                            border-radius: 0.25rem;
                            width: 100%;
                            max-height: 200px;
                            overflow-y: auto;
                            display: none;
                            list-style: none;
                            padding: 0;
                            margin: 0;
                        }

                        .search-results li {
                            padding: 0.5rem 1rem;
                            cursor: pointer;
                            border-bottom: 1px solid #f0f0f0;
                        }

                        .search-results li:hover {
                            background-color: #f8f9fa;
                        }
                    </style>
            </head>

            <body>
                <div class="container-xxl position-relative bg-white d-flex p-0">
                    <!-- Sidebar -->
                    <%@ include file="/includes/sidebar.jsp" %>

                        <!-- Content -->
                        <div class="content">
                            <%@ include file="/includes/topbar.jsp" %>

                                <div class="container-fluid pt-4 px-4">
                                    <div class="row mb-4">
                                        <div class="col-12">
                                            <div class="bg-light rounded h-100 p-4">
                                                <h4 class="mb-4">Tạo Yêu cầu Hỗ trợ Mới</h4>

                                                <c:if test="${not empty error}">
                                                    <div class="alert alert-danger alert-dismissible fade show"
                                                        role="alert">
                                                        <i class="fa fa-exclamation-circle me-2"></i>${error}
                                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                            aria-label="Close"></button>
                                                    </div>
                                                </c:if>

                                                <form action="${pageContext.request.contextPath}/tickets?action=create"
                                                    method="post" enctype="multipart/form-data" id="createTicketForm">
                                                    <div class="row g-3">
                                                        <!-- Khách hàng (Search) -->
                                                        <div class="col-md-6 position-relative">
                                                            <label for="customerSearch" class="form-label">Khách hàng
                                                                <span class="text-danger">*</span></label>
                                                            <div class="input-group">
                                                                <span class="input-group-text"><i
                                                                        class="fa fa-search"></i></span>
                                                                <input type="text" class="form-control"
                                                                    id="customerSearch"
                                                                    placeholder="Nhập tên hoặc SĐT để tìm..."
                                                                    autocomplete="off" required>
                                                                <input type="hidden" name="customerId" id="customerId">
                                                            </div>
                                                            <ul id="searchResults" class="search-results shadow"></ul>
                                                            <div id="selectedCustomer"
                                                                class="form-text text-primary mt-1"
                                                                style="display:none;">
                                                                <i class="fa fa-check-circle me-1"></i> Đã chọn: <span
                                                                    id="customerNameDisplay"></span>
                                                            </div>
                                                        </div>

                                                        <!-- Tiêu đề -->
                                                        <div class="col-md-6">
                                                            <label for="subject" class="form-label">Tiêu đề <span
                                                                    class="text-danger">*</span></label>
                                                            <input type="text" class="form-control" id="subject"
                                                                name="subject" required>
                                                        </div>

                                                        <!-- Phân loại -->
                                                        <div class="col-md-6">
                                                            <label for="category" class="form-label">Phân loại</label>
                                                            <select class="form-select" id="category" name="category">
                                                                <option value="">-- Chọn loại yêu cầu --</option>
                                                                <option value="Lỗi kỹ thuật">Lỗi kỹ thuật</option>
                                                                <option value="Khiếu nại">Khiếu nại</option>
                                                                <option value="Hỏi đáp">Hỏi đáp</option>
                                                                <option value="Yêu cầu dịch vụ">Yêu cầu dịch vụ</option>
                                                                <option value="Khác">Khác</option>
                                                            </select>
                                                        </div>

                                                        <!-- Độ ưu tiên -->
                                                        <div class="col-md-6">
                                                            <label for="priority" class="form-label">Độ ưu tiên</label>
                                                            <select class="form-select" id="priority" name="priority">
                                                                <option value="Low">Low (Thấp)</option>
                                                                <option value="Medium" selected>Medium (Trung bình)
                                                                </option>
                                                                <option value="High">High (Cao)</option>
                                                            </select>
                                                        </div>

                                                        <!-- Mô tả -->
                                                        <div class="col-12">
                                                            <label for="description" class="form-label">Mô tả chi
                                                                tiết</label>
                                                            <textarea class="form-control" id="description"
                                                                name="description" rows="5"></textarea>
                                                        </div>

                                                        <!-- File đính kèm -->
                                                        <div class="col-12">
                                                            <label for="attachment" class="form-label">Đính kèm tệp
                                                                (Ảnh/Tài liệu)</label>
                                                            <input class="form-control" type="file" id="attachment"
                                                                name="attachment">
                                                        </div>

                                                        <!-- Buttons -->
                                                        <div class="col-12 mt-4 d-flex justify-content-end gap-2">
                                                            <a href="${pageContext.request.contextPath}/tickets"
                                                                class="btn btn-secondary">Hủy bỏ</a>
                                                            <button type="submit" class="btn btn-primary" id="btnSave">
                                                                <i class="fa fa-save me-2"></i>Lưu Ticket
                                                            </button>
                                                        </div>
                                                    </div>
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
                        $(document).ready(function () {
                            let searchTimeout;
                            const $searchInput = $('#customerSearch');
                            const $resultsList = $('#searchResults');
                            const $hiddenInput = $('#customerId');
                            const $displayArea = $('#selectedCustomer');
                            const $displayName = $('#customerNameDisplay');

                            // Search logic
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
                                                    $resultsList.append(`<li data-id="\${item.id}" data-text="\${item.text}">\${item.text}</li>`);
                                                });
                                                $resultsList.show();
                                            } else {
                                                $resultsList.append('<li class="text-muted fst-italic">Không tìm thấy khách hàng</li>');
                                                $resultsList.show();
                                            }
                                        }
                                    });
                                }, 300);
                            });

                            // Select item
                            $resultsList.on('click', 'li', function () {
                                const id = $(this).data('id');
                                const text = $(this).data('text');

                                if (id) {
                                    $hiddenInput.val(id);
                                    $displayName.text(text);
                                    $displayArea.show();
                                    $searchInput.val(''); // Clear search to show "Selected" state clearly or keep text?
                                    // User might want to change it. Let's keep it clean.
                                    $resultsList.hide();
                                    $searchInput.val(text.split(' - ')[0]); // Put name in box
                                }
                            });

                            // Click outside to close
                            $(document).on('click', function (e) {
                                if (!$(e.target).closest('.position-relative').length) {
                                    $resultsList.hide();
                                }
                            });

                            // Form Validation
                            $('#createTicketForm').on('submit', function (e) {
                                if (!$hiddenInput.val()) {
                                    e.preventDefault();
                                    alert('Vui lòng chọn khách hàng từ danh sách gợi ý!');
                                    $searchInput.focus();
                                }
                            });
                        });
                    </script>
            </body>

            </html>