<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%-- toast.jsp - Hệ thống thông báo Toast dùng chung --%>

        <!-- Toast Container -->
        <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1080;">
            <div id="projectToast" class="toast align-items-center border-0" role="alert" aria-live="assertive"
                aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body" id="projectToastMessage">
                        Thông báo.
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                        aria-label="Close"></button>
                </div>
            </div>
        </div>

        <script>
            /**
             * Hiển thị thông báo Toast.
             * @param {string} message - Nội dung thông báo.
             * @param {string} [type='success'] - Loại thông báo: success, danger, warning, info.
             */
            function showToast(message, type = 'success') {
                const toastEl = document.getElementById('projectToast');
                const messageEl = document.getElementById('projectToastMessage');

                if (!toastEl || !messageEl) return;

                // Cập nhật nội dung
                messageEl.textContent = message;

                // Reset class màu nền
                toastEl.classList.remove('bg-success', 'bg-danger', 'bg-warning', 'bg-info', 'text-white', 'text-dark');

                // Thêm class dựa trên type
                if (type === 'success') {
                    toastEl.classList.add('bg-success', 'text-white');
                } else if (type === 'danger') {
                    toastEl.classList.add('bg-danger', 'text-white');
                } else if (type === 'warning') {
                    toastEl.classList.add('bg-warning', 'text-dark');
                } else if (type === 'info') {
                    toastEl.classList.add('bg-info', 'text-white');
                }

                // Khởi tạo và hiển thị
                const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
                toast.show();
            }
        </script>