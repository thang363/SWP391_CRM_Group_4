// Utility Function
function showAlert(type, message) {
    // Remove existing alerts to avoid clutter
    const existingAlerts = document.querySelectorAll('.alert.lp-alert');
    existingAlerts.forEach(alert => alert.remove());

    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show lp-alert`;
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

// Copy Public Link
function copyPublicLink(id) {
    // Construct the public URL: http://host:port/CRM/lp/{id}
    // We use window.location.origin to get scheme + host + port
    // contextPath usually starts with / (e.g. /CRM)
    const publicUrl = window.location.origin + contextPath + '/lp/' + id;

    navigator.clipboard.writeText(publicUrl).then(function () {
        showAlert('success', 'Đã copy link public: ' + publicUrl);
    }, function (err) {
        console.error('Could not copy text: ', err);
        // Fallback for older browsers or if permission denied?
        prompt("Copy link bên dưới:", publicUrl);
    });
}

// Edit LP Functions
function openEditModal(id) {
    fetch(contextPath + '/landing-pages?action=detail&id=' + id, {
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                const data = result.data;
                document.getElementById('editLpId').value = data.id;
                document.getElementById('editLpName').value = data.name;
                document.getElementById('editLpBrief').value = data.brief || '';
                document.getElementById('editLpStatus').value = data.status;

                // Populate Content Fields
                document.getElementById('editHeroTitle').value = data.heroTitle || '';
                document.getElementById('editHeroDesc').value = data.heroDesc || '';

                document.getElementById('editAboutTitle').value = data.aboutTitle || '';
                document.getElementById('editAboutDesc').value = data.aboutDesc || '';

                document.getElementById('editFeatureTitle1').value = data.featureTitle1 || '';
                document.getElementById('editFeatureDesc1').value = data.featureDesc1 || '';
                document.getElementById('editFeatureTitle2').value = data.featureTitle2 || '';
                document.getElementById('editFeatureDesc2').value = data.featureDesc2 || '';
                document.getElementById('editFeatureTitle3').value = data.featureTitle3 || '';
                document.getElementById('editFeatureDesc3').value = data.featureDesc3 || '';

                // Show/Hide Warning based on status
                const warningDiv = document.getElementById('editWarning');
                if (warningDiv) {
                    if (data.status === 'Public') {
                        warningDiv.classList.remove('d-none');
                    } else {
                        warningDiv.classList.add('d-none');
                    }
                }

                const modalEl = document.getElementById('editLPModal');
                if (modalEl) {
                    const modal = new bootstrap.Modal(modalEl);
                    modal.show();
                }
            } else {
                showAlert('danger', result.message || 'Không thể lấy dữ liệu');
            }
        })
        .catch(err => {
            console.error('Error:', err);
            showAlert('danger', 'Lỗi kết nối');
        });
}

// Update Status Function
function updateLsStatus(id, newStatus) {
    let actionName = "";
    if (newStatus === 'Public') actionName = "Công khai Landing Page";
    else if (newStatus === 'Draft') actionName = "Hủy công khai Landing Page";

    showConfirmDialog(
        'Bạn có chắc chắn muốn <strong>' + actionName + '</strong>?',
        function () {
            const params = new URLSearchParams();
            params.append('id', id);
            params.append('status', newStatus);

            fetch(contextPath + '/landing-pages?action=change-status', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: params
            })
                .then(res => res.json())
                .then(result => {
                    if (result.success) {
                        showAlert('success', result.message);
                        setTimeout(() => window.location.reload(), 1000);
                    } else {
                        showAlert('danger', result.message || 'Có lỗi xảy ra');
                    }
                })
                .catch(err => {
                    console.error('Error:', err);
                    showAlert('danger', 'Lỗi kết nối');
                });
        },
        { title: actionName, confirmText: 'Đồng ý', confirmClass: newStatus === 'Rejected' ? 'btn-danger' : 'btn-success' }
    );
}

function submitEditForm() {
    const id = document.getElementById('editLpId').value;
    const name = document.getElementById('editLpName').value;
    const brief = document.getElementById('editLpBrief').value;
    const status = document.getElementById('editLpStatus').value;


    doSubmitEditForm();
}

function doSubmitEditForm() {
    const id = document.getElementById('editLpId').value;
    const name = document.getElementById('editLpName').value;
    const brief = document.getElementById('editLpBrief').value;

    const params = new URLSearchParams();
    params.append('action', 'update');
    params.append('id', id);
    params.append('name', name);
    params.append('brief', brief);

    // Append Content fields
    params.append('heroTitle', document.getElementById('editHeroTitle').value);
    params.append('heroDesc', document.getElementById('editHeroDesc').value);

    params.append('aboutTitle', document.getElementById('editAboutTitle').value);
    params.append('aboutDesc', document.getElementById('editAboutDesc').value);

    params.append('featureTitle1', document.getElementById('editFeatureTitle1').value);
    params.append('featureDesc1', document.getElementById('editFeatureDesc1').value);
    params.append('featureTitle2', document.getElementById('editFeatureTitle2').value);
    params.append('featureDesc2', document.getElementById('editFeatureDesc2').value);
    params.append('featureTitle3', document.getElementById('editFeatureTitle3').value);
    params.append('featureDesc3', document.getElementById('editFeatureDesc3').value);

    fetch(contextPath + '/landing-pages', {
        method: 'POST',
        headers: { 
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: params
    })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                const modalEl = document.getElementById('editLPModal');
                const modal = bootstrap.Modal.getInstance(modalEl);
                if (modal) modal.hide();

                showAlert('success', 'Cập nhật thành công!');
                setTimeout(() => window.location.reload(), 1000);
            } else {
                showAlert('danger', result.message || 'Lỗi cập nhật');
            }
        })
        .catch(err => {
            console.error('Error:', err);
            showAlert('danger', 'Lỗi kết nối');
        });
}

function submitCreateLP() {
    const campaignId = document.getElementById('campaignSelect').value;
    const marketingId = document.getElementById('marketingSelect').value;
    const brief = document.getElementById('briefInput').value;

    if (!campaignId || !marketingId) {
        showAlert('warning', 'Vui lòng chọn Chiến dịch và Nhân viên phụ trách');
        return;
    }

    const params = new URLSearchParams();
    params.append('action', 'create');
    params.append('campaignId', campaignId);
    params.append('marketingId', marketingId);
    params.append('brief', brief);

    fetch(contextPath + '/landing-pages', {
        method: 'POST',
        headers: { 
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: params
    })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                const modalEl = document.getElementById('createLPModal');
                const modal = bootstrap.Modal.getInstance(modalEl);
                if (modal) modal.hide();

                showAlert('success', 'Tạo Landing Page thành công!');
                setTimeout(() => window.location.reload(), 1000);
            } else {
                showAlert('danger', result.message || 'Lỗi khi tạo Landing Page');
            }
        })
        .catch(err => {
            console.error('Error:', err);
            showAlert('danger', 'Có lỗi xảy ra: ' + err.message);
        });
}

function confirmDelete(id, name) {
    showConfirmDialog(
        'Bạn có chắc muốn xóa Landing Page "<strong>' + name + '</strong>"?',
        function () {
            const params = new URLSearchParams();
            params.append('action', 'delete');
            params.append('id', id);

            fetch(contextPath + '/landing-pages', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: params
            })
                .then(res => res.json())
                .then(result => {
                    if (result.success) {
                        showAlert('success', 'Xóa thành công!');
                        setTimeout(() => window.location.reload(), 1000);
                    } else {
                        showAlert('danger', result.message || 'Lỗi khi xóa');
                    }
                })
                .catch(err => {
                    console.error('Error:', err);
                    showAlert('danger', 'Có lỗi xảy ra: ' + err.message);
                });
        },
        { title: 'Xóa Landing Page', confirmText: 'Xóa', confirmClass: 'btn-danger' }
    );
}

// Hide spinner
document.addEventListener('DOMContentLoaded', function () {
    const spinner = document.getElementById('spinner');
    if (spinner) spinner.classList.remove('show');
});
