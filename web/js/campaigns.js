/**
 * Campaign Management - JavaScript Module
 * Handles all client-side logic for campaign CRUD and transfer operations
 */

// Global state
let isEditMode = false;
let contextPath = ''; // Will be set from JSP

// Initialize context path (must be called from JSP)
function initCampaignsJS(ctxPath) {
    contextPath = ctxPath;
}

// ============================================
// UTILITY FUNCTIONS
// ============================================

/**
 * Show Bootstrap alert at top of page
 */
function showAlert(type, message) {
    // Remove existing alerts to avoid clutter
    const existingAlerts = document.querySelectorAll('.alert.campaign-alert');
    existingAlerts.forEach(alert => alert.remove());

    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show campaign-alert`;
    alertDiv.setAttribute('role', 'alert');
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;

    // Insert at top of content area
    const contentArea = document.querySelector('.container-fluid.pt-4');
    if (contentArea) {
        contentArea.insertBefore(alertDiv, contentArea.firstChild);

        // Auto-dismiss after 5 seconds
        setTimeout(() => {
            alertDiv.classList.remove('show');
            setTimeout(() => alertDiv.remove(), 150);
        }, 5000);
    } else {
        alert(message); // Fallback
    }
}

/**
 * Show inline form error
 */
function showFormError(message) {
    const errorAlert = document.getElementById('formErrorAlert');
    if (errorAlert) {
        errorAlert.textContent = message;
        errorAlert.classList.remove('d-none');
    } else {
        alert(message);
    }
}

/**
 * Format date for input field (yyyy-MM-dd)
 */
function formatDateForInput(dateString) {
    if (!dateString) return '';

    // If format is "yyyy-MM-dd HH:mm:ss", extract date part
    if (typeof dateString === 'string' && dateString.includes(' ')) {
        return dateString.split(' ')[0];
    }

    // Fallback for other formats
    const date = new Date(dateString);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// ============================================
// CAMPAIGN CRUD OPERATIONS
// ============================================

/**
 * Open modal for creating new campaign
 */
function openCreateModal() {
    isEditMode = false;
    document.getElementById('campaignModalLabel').textContent = 'Thêm chiến dịch mới';
    document.getElementById('campaignForm').reset();
    document.getElementById('campaignId').value = '';

    // Reset status to Draft
    const statusSelect = document.getElementById('campaignStatus');
    if (statusSelect) {
        statusSelect.value = 'Draft';
    }

    document.getElementById('formErrorAlert').classList.add('d-none');
    document.getElementById('campaignForm').classList.remove('was-validated');
}

/**
 * Load and open modal for editing campaign
 */
function editCampaign(id) {
    isEditMode = true;
    document.getElementById('campaignModalLabel').textContent = 'Chỉnh sửa chiến dịch';
    document.getElementById('formErrorAlert').classList.add('d-none');

    // Fetch campaign data
    fetch(`${contextPath}/campaigns?action=get&id=${id}`)
        .then(response => response.json())
        .then(result => {
            if (result.success && result.data) {
                const campaign = result.data;
                document.getElementById('campaignId').value = campaign.id;
                document.getElementById('campaignName').value = campaign.name;
                document.getElementById('campaignBudget').value = campaign.budget;
                document.getElementById('campaignStartDate').value = formatDateForInput(campaign.startDate);
                document.getElementById('campaignEndDate').value = formatDateForInput(campaign.endDate);
                document.getElementById('campaignDescription').value = campaign.description || '';

                // Set status if field exists
                const statusSelect = document.getElementById('campaignStatus');
                if (statusSelect && campaign.status) {
                    // Try exact match
                    let statusToSet = campaign.status.trim();

                    // Check if option exists, if not, might need case conversion or it's an invalid status
                    let optionExists = [...statusSelect.options].some(o => o.value === statusToSet);
                    if (!optionExists) {
                        console.warn('Status from DB not in dropdown:', statusToSet);
                        // Fallback or keep as is (which usually defaults to first option)
                    }

                    statusSelect.value = statusToSet;
                    console.log("Set campaign status to:", statusToSet);
                }

                // Show modal
                new bootstrap.Modal(document.getElementById('campaignModal')).show();
            } else {
                showAlert('danger', result.message || 'Không thể tải thông tin chiến dịch');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showAlert('danger', 'Lỗi khi tải thông tin chiến dịch');
        });
}

/**
 * Save campaign (create or update)
 */
function saveCampaign() {
    const form = document.getElementById('campaignForm');

    // Validate form
    if (!form.checkValidity()) {
        form.classList.add('was-validated');
        return;
    }

    // Validate date range
    const startDate = new Date(document.getElementById('campaignStartDate').value);
    const endDate = new Date(document.getElementById('campaignEndDate').value);

    if (startDate >= endDate) {
        showFormError('Ngày bắt đầu phải trước ngày kết thúc');
        return;
    }

    // Prepare form data
    const params = new URLSearchParams();
    new FormData(form).forEach((value, key) => params.append(key, value));

    params.append('action', isEditMode ? 'update' : 'create');
    if (!params.has('status')) {
        params.append('status', 'Draft');
    }

    console.log('Saving campaign:', Object.fromEntries(params));

    // Send request
    fetch(`${contextPath}/campaigns`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        },
        body: params
    })
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.json();
        })
        .then(result => {
            if (result.success) {
                // Close modal safely
                const modalEl = document.getElementById('campaignModal');
                const modal = bootstrap.Modal.getInstance(modalEl);
                if (modal) modal.hide();

                // Show success message and reload
                showAlert('success', result.message);
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            } else {
                showFormError(result.message);
            }
        })
        .catch(error => {
            console.error('Error saving campaign:', error);
            showFormError('Lỗi khi lưu chiến dịch: ' + error.message);
        });
}

/**
 * Delete campaign
 */
function deleteCampaign(id, name) {
    if (!confirm(`Bạn có chắc chắn muốn xóa chiến dịch "${name}"?`)) {
        return;
    }

    const params = new URLSearchParams();
    params.append('action', 'delete');
    params.append('id', id);

    console.log('Deleting campaign:', id);

    fetch(`${contextPath}/campaigns`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        },
        body: params
    })
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.json();
        })
        .then(result => {
            if (result.success) {
                // Remove row from table
                const row = document.getElementById('campaign-row-' + id);
                if (row) row.remove();
                showAlert('success', result.message);
            } else {
                showAlert('danger', result.message);
            }
        })
        .catch(error => {
            console.error('Error deleting campaign:', error);
            showAlert('danger', 'Lỗi khi xóa chiến dịch: ' + error.message);
        });
}

// ============================================
// CAMPAIGN TRANSFER OPERATIONS
// ============================================

/**
 * Open transfer modal
 */
function openTransferModal(id, name) {
    document.getElementById('transferCampaignId').value = id;
    document.getElementById('transferCampaignName').value = name;
    document.getElementById('transferReason').value = '';
    document.getElementById('transferToManager').value = '';
    new bootstrap.Modal(document.getElementById('transferModal')).show();
}

/**
 * Submit transfer request
 */
function submitTransfer() {
    const campaignId = document.getElementById('transferCampaignId').value;
    const toManagerId = document.getElementById('transferToManager').value;
    const reason = document.getElementById('transferReason').value;

    if (!toManagerId || !reason) {
        showAlert('warning', 'Vui lòng chọn người nhận và nhập lý do');
        return;
    }

    const params = new URLSearchParams();
    params.append('action', 'request');
    params.append('campaignId', campaignId);
    params.append('toManagerId', toManagerId);
    params.append('reason', reason);

    fetch(`${contextPath}/transfers`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        },
        body: params
    })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => {
                    throw new Error(text || 'Network response was not ok')
                });
            }
            return response.json();
        })
        .then(result => {
            if (result.success) {
                const modalEl = document.getElementById('transferModal');
                const modal = bootstrap.Modal.getInstance(modalEl);
                if (modal) {
                    modal.hide();
                }
                showAlert('success', 'Yêu cầu chuyển giao đã được gửi đi');
            } else {
                showAlert('danger', result.message || 'Lỗi khi gửi yêu cầu');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showAlert('danger', 'Có lỗi xảy ra: ' + error.message);
        });
}

// ============================================
// LANDING PAGE ASSIGNMENT OPERATIONS
// (REMOVED - Moved to /landing-pages)
// ============================================
// ============================================
// PAGINATION & FILTERING
// ============================================

/**
 * Navigate to specific page
 */
function goToPage(page) {
    if (page < 1) return;
    document.getElementById('pageInput').value = page;
    document.getElementById('filterForm').submit();
}

/**
 * Reset all filters
 */
function resetFilters() {
    document.getElementById('filterName').value = '';
    document.getElementById('filterStatus').value = '';
    document.getElementById('filterStartDate').value = '';
    document.getElementById('filterEndDate').value = '';
    document.getElementById('pageInput').value = '1';
    document.getElementById('filterForm').submit();
}

// ============================================
// INITIALIZATION
// ============================================

document.addEventListener('DOMContentLoaded', function () {
    // Hide spinner when page loads
    const spinner = document.getElementById('spinner');
    if (spinner) {
        spinner.classList.remove('show');
    }
});
