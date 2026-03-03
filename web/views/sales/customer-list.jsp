<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
            <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
                <%-- Set currentPage for sidebar highlight --%>
                    <% request.setAttribute("currentPage", "sales-customers" ); %>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <title>Customer List - CRM System</title>
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
                                                                        class="fa fa-users me-2"></i>Customer List</h3>
                                                            </div>

                                                            <!-- Search and Filter Form -->
                                                            <form action="#" method="get"
                                                                class="row g-3 align-items-center">
                                                                <div class="col-md-4">
                                                                    <div class="input-group">
                                                                        <span
                                                                            class="input-group-text bg-transparent border-end-0"><i
                                                                                class="fa fa-search text-muted"></i></span>
                                                                        <input type="text"
                                                                            class="form-control border-start-0"
                                                                            name="search"
                                                                            placeholder="Search Company, Email or Phone...">
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-3">
                                                                    <select class="form-select" name="tier">
                                                                        <option value="">All Tiers</option>
                                                                        <option value="Standard">Standard</option>
                                                                        <option value="VIP">VIP</option>
                                                                        <option value="VVIP">VVIP</option>
                                                                    </select>
                                                                </div>
                                                                <div class="col-md-3">
                                                                    <select class="form-select" name="status">
                                                                        <option value="">All Statuses</option>
                                                                        <option value="Active">Active</option>
                                                                        <option value="Inactive">Inactive</option>
                                                                    </select>
                                                                </div>
                                                                <div class="col-md-2">
                                                                    <button type="submit" class="btn btn-primary w-100">
                                                                        <i class="fa fa-filter me-2"></i>Filter
                                                                    </button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>

                                                    <!-- Customer Table Section -->
                                                    <div class="container-fluid px-4">
                                                        <div class="row g-4">
                                                            <div class="col-12">
                                                                <div class="bg-light rounded p-4">
                                                                    <div class="table-responsive">
                                                                        <table class="table table-hover">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th>ID</th>
                                                                                    <th>Company Name</th>
                                                                                    <th>Contact Info</th>
                                                                                    <th>Tier</th>
                                                                                    <th>Status</th>
                                                                                    <th>Last Interacted</th>
                                                                                    <th>Actions</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <%-- Mock Data for demonstration --%>
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${empty customerList}">
                                                                                            <tr>
                                                                                                <td>101</td>
                                                                                                <td><strong>Antigravity
                                                                                                        Tech</strong>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <div class="small">
                                                                                                        <i
                                                                                                            class="fa fa-envelope me-1 text-primary"></i>contact@antigravity.io
                                                                                                    </div>
                                                                                                    <div class="small">
                                                                                                        <i
                                                                                                            class="fa fa-phone me-1 text-primary"></i>+84
                                                                                                        123 456 789
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td><span
                                                                                                        class="badge bg-warning text-dark">VIP</span>
                                                                                                </td>
                                                                                                <td><span
                                                                                                        class="badge bg-success">Active</span>
                                                                                                </td>
                                                                                                <td class="small">
                                                                                                    2026-03-01 14:30
                                                                                                </td>
                                                                                                <td>
                                                                                                    <div
                                                                                                        class="d-flex gap-2">
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-outline-primary"
                                                                                                            title="Details"><i
                                                                                                                class="fa fa-eye"></i></button>
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-outline-warning"
                                                                                                            title="Interaction"><i
                                                                                                                class="fa fa-history"></i></button>
                                                                                                    </div>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>102</td>
                                                                                                <td><strong>Global
                                                                                                        Solutions</strong>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <div class="small">
                                                                                                        <i
                                                                                                            class="fa fa-envelope me-1 text-primary"></i>info@globalsol.com
                                                                                                    </div>
                                                                                                    <div class="small">
                                                                                                        <i
                                                                                                            class="fa fa-phone me-1 text-primary"></i>+84
                                                                                                        987 654 321
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td><span
                                                                                                        class="badge bg-primary">Standard</span>
                                                                                                </td>
                                                                                                <td><span
                                                                                                        class="badge bg-success">Active</span>
                                                                                                </td>
                                                                                                <td class="small">
                                                                                                    2026-02-25 09:15
                                                                                                </td>
                                                                                                <td>
                                                                                                    <div
                                                                                                        class="d-flex gap-2">
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-outline-primary"
                                                                                                            title="Details"><i
                                                                                                                class="fa fa-eye"></i></button>
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-outline-warning"
                                                                                                            title="Interaction"><i
                                                                                                                class="fa fa-history"></i></button>
                                                                                                    </div>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <%-- Actual dynamic
                                                                                                rendering when backend
                                                                                                is ready --%>
                                                                                                <c:forEach
                                                                                                    var="customer"
                                                                                                    items="${customerList}">
                                                                                                    <tr>
                                                                                                        <td>${customer.id}
                                                                                                        </td>
                                                                                                        <td><strong>${customer.companyName}</strong>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <div
                                                                                                                class="small">
                                                                                                                <i
                                                                                                                    class="fa fa-envelope me-2 text-primary"></i>${customer.email}
                                                                                                            </div>
                                                                                                            <div
                                                                                                                class="small">
                                                                                                                <i
                                                                                                                    class="fa fa-phone me-2 text-primary"></i>${customer.phone}
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <span
                                                                                                                class="badge ${customer.tier == 'VIP' ? 'bg-warning text-dark' : (customer.tier == 'VVIP' ? 'bg-danger' : 'bg-primary')}">
                                                                                                                ${customer.tier}
                                                                                                            </span>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <span
                                                                                                                class="badge ${customer.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
                                                                                                                ${customer.status}
                                                                                                            </span>
                                                                                                        </td>
                                                                                                        <td
                                                                                                            class="small">
                                                                                                            ${customer.lastCareDate}
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <div
                                                                                                                class="d-flex gap-2">
                                                                                                                <a href="${pageContext.request.contextPath}/customers?action=details&id=${customer.id}"
                                                                                                                    class="btn btn-sm btn-outline-primary"
                                                                                                                    title="Details"><i
                                                                                                                        class="fa fa-eye"></i></a>
                                                                                                                <button
                                                                                                                    class="btn btn-sm btn-outline-warning"
                                                                                                                    title="Log Interaction"><i
                                                                                                                        class="fa fa-history"></i></button>
                                                                                                            </div>
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

                                                    <%@ include file="/includes/footer.jsp" %>
                                        </div>
                                        <!-- Content End -->

                                        <!-- Back to Top -->
                                        <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i
                                                class="bi bi-arrow-up"></i></a>
                            </div>

                            <%-- Include Scripts --%>
                                <%@ include file="/includes/scripts.jsp" %>
                                    <script>
                                        document.addEventListener('DOMContentLoaded', function () {
                                            var spinner = document.getElementById('spinner');
                                            if (spinner) {
                                                spinner.classList.remove('show');
                                            }
                                        });
                                    </script>
                        </body>

                        </html>