<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%-- confirm-modal.jsp - Reusable Confirm Dialog Component --%>

        <!-- Confirm Modal -->
        <div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmModalTitle">Xác nhận</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p id="confirmModalBody" class="mb-0"></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                            id="confirmModalCancelBtn">Hủy</button>
                        <button type="button" class="btn btn-primary" id="confirmModalOkBtn">Xác nhận</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            /**
             * Show a Bootstrap confirm dialog to replace native confirm().
             * @param {string} message - The message to display
             * @param {function} onConfirm - Callback when user clicks OK
             * @param {object} [options] - Optional settings
             * @param {string} [options.title] - Modal title (default: 'Xác nhận')
             * @param {string} [options.confirmText] - OK button text (default: 'Xác nhận')
             * @param {string} [options.cancelText] - Cancel button text (default: 'Hủy')
             * @param {string} [options.confirmClass] - OK button class (default: 'btn-primary')
             */
            function showConfirmDialog(message, onConfirm, options) {
                options = options || {};

                var title = options.title || 'Xác nhận';
                var confirmText = options.confirmText || 'Xác nhận';
                var cancelText = options.cancelText || 'Hủy';
                var confirmClass = options.confirmClass || 'btn-primary';

                document.getElementById('confirmModalTitle').textContent = title;
                document.getElementById('confirmModalBody').innerHTML = message;
                document.getElementById('confirmModalCancelBtn').textContent = cancelText;

                var okBtn = document.getElementById('confirmModalOkBtn');
                okBtn.className = 'btn ' + confirmClass;
                okBtn.textContent = confirmText;

                // Remove old listeners by cloning
                var newOkBtn = okBtn.cloneNode(true);
                okBtn.parentNode.replaceChild(newOkBtn, okBtn);

                newOkBtn.addEventListener('click', function () {
                    var modal = bootstrap.Modal.getInstance(document.getElementById('confirmModal'));
                    if (modal) modal.hide();
                    if (typeof onConfirm === 'function') onConfirm();
                });

                var modal = new bootstrap.Modal(document.getElementById('confirmModal'));
                modal.show();
            }
        </script>