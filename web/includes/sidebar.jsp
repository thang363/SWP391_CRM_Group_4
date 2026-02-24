<%-- sidebar.jsp - Sidebar dùng chung --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>

            <!-- Sidebar Start -->
            <div class="sidebar pe-4 pb-3">
                <nav class="navbar bg-light navbar-light">
                    <a href="${pageContext.request.contextPath}/dashboard" class="navbar-brand mx-4 mb-3">
                        <h3 class="text-primary"><i class="fa fa-hashtag me-2"></i>CRM</h3>
                    </a>
                    <div class="d-flex align-items-center ms-4 mb-4">
                        <div class="position-relative">
                            <img class="rounded-circle" src="${pageContext.request.contextPath}/img/user.jpg" alt=""
                                style="width: 40px; height: 40px;">
                            <div
                                class="bg-success rounded-circle border border-2 border-white position-absolute end-0 bottom-0 p-1">
                            </div>
                        </div>
                        <div class="ms-3">
                            <%-- Hiển thị tên user từ session --%>
                                <h6 class="mb-0">${sessionScope.fullName != null ? sessionScope.fullName : 'Guest'}</h6>
                                <span>${sessionScope.userRole != null ? sessionScope.userRole : 'User'}</span>
                        </div>
                    </div>
                    <div class="navbar-nav w-100">
                        <%-- Dashboard --%>
                            <a href="${pageContext.request.contextPath}/dashboard"
                                class="nav-item nav-link ${currentPage == 'dashboard' ? 'active' : ''}">
                                <i class="fa fa-tachometer-alt me-2"></i>Dashboard
                            </a>

                            <%-- CRM Sales Module --%>
                                <c:if test="${sessionScope.userRole == 'MANAGER' || sessionScope.userRole == 'SALE'}">
                                    <div class="nav-item dropdown">
                                        <a href="#"
                                            class="nav-link dropdown-toggle ${currentPage == 'sales' || currentPage == 'sales-pipeline' ? 'active' : ''}"
                                            data-bs-toggle="dropdown">
                                            <i class="fa fa-chart-line me-2"></i>CRM Sales
                                        </a>
                                        <div class="dropdown-menu bg-transparent border-0">
                                            <a href="${pageContext.request.contextPath}/sales-pipeline"
                                                class="dropdown-item">Sales Pipeline</a>
                                            <a href="${pageContext.request.contextPath}/leads"
                                                class="dropdown-item">Leads</a>
                                            <a href="${pageContext.request.contextPath}/quotes"
                                                class="dropdown-item">Báo
                                                giá</a>
                                        </div>
                                    </div>
                                </c:if>

                                <%-- Marketing Module --%>
                                    <c:if
                                        test="${sessionScope.userRole == 'MANAGER' || sessionScope.userRole == 'MARKETING'}">
                                        <div class="nav-item dropdown">
                                            <a href="#"
                                                class="nav-link dropdown-toggle ${currentPage == 'marketing' || currentPage == 'campaigns' || currentPage == 'transfers' || currentPage == 'landing-pages' || currentPage == 'submissions' || currentPage == 'import-leads' || currentPage == 'bulk-email' ? 'active' : ''}"
                                                data-bs-toggle="dropdown">
                                                <i class="fa fa-bullhorn me-2"></i>Marketing
                                            </a>
                                            <div class="dropdown-menu bg-transparent border-0">
                                                <c:if test="${sessionScope.userRole == 'MANAGER'}">
                                                    <a href="${pageContext.request.contextPath}/campaigns"
                                                        class="dropdown-item ${currentPage == 'campaigns' ? 'active' : ''}">Campaigns
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/transfers"
                                                        class="dropdown-item ${currentPage == 'transfers' ? 'active' : ''}">Handover
                                                        Campaigns</a>
                                                </c:if>
                                                <c:if test="${sessionScope.userRole == 'MARKETING'}">
                                                    <a href="${pageContext.request.contextPath}/marketing/bulk-email"
                                                        class="dropdown-item ${currentPage == 'bulk-email' ? 'active' : ''}">
                                                        <i class="fa fa-envelope me-1"></i>Email Marketing</a>
                                                    <a href="${pageContext.request.contextPath}/lead-sources"
                                                        class="dropdown-item">Lead Sources</a>
                                                    <a href="${pageContext.request.contextPath}/marketing/submissions"
                                                        class="dropdown-item ${currentPage == 'submissions' ? 'active' : ''}">
                                                        <i class="fa fa-clipboard-list me-1"></i>List Submission</a>
                                                    <a href="${pageContext.request.contextPath}/marketing/import-leads"
                                                        class="dropdown-item ${currentPage == 'import-leads' ? 'active' : ''}">
                                                        <i class="fa fa-file-import me-1"></i>Import Submission</a>
                                                </c:if>
                                                <%-- Chung --%>
                                                    <a href="${pageContext.request.contextPath}/landing-pages"
                                                        class="dropdown-item ${currentPage == 'landing-pages' ? 'active' : ''}">
                                                        <i class="fa fa-file-code me-1"></i>Landing Pages</a>
                                            </div>
                                        </div>
                                    </c:if>

                                    <%-- Customers Module --%>
                                        <c:if
                                            test="${sessionScope.userRole == 'MANAGER' || sessionScope.userRole == 'SALE'}">
                                            <div class="nav-item dropdown">
                                                <a href="#"
                                                    class="nav-link dropdown-toggle ${currentPage == 'customers' ? 'active' : ''}"
                                                    data-bs-toggle="dropdown">
                                                    <i class="fa fa-users me-2"></i>Customers
                                                </a>
                                                <div class="dropdown-menu bg-transparent border-0">
                                                    <a href="${pageContext.request.contextPath}/customers"
                                                        class="dropdown-item">Danh sách KH</a>
                                                    <a href="${pageContext.request.contextPath}/customers-vip"
                                                        class="dropdown-item">Phân loại VIP</a>
                                                    <a href="${pageContext.request.contextPath}/contracts"
                                                        class="dropdown-item">Hợp đồng</a>
                                                </div>
                                            </div>
                                        </c:if>

                                        <%-- Activities --%>
                                            <c:if
                                                test="${sessionScope.userRole == 'MANAGER' || sessionScope.userRole == 'SALE'}">
                                                <a href="${pageContext.request.contextPath}/activities"
                                                    class="nav-item nav-link ${currentPage == 'activities' ? 'active' : ''}">
                                                    <i class="fa fa-tasks me-2"></i>Activities
                                                </a>
                                            </c:if>

                                            <%-- Support Module --%>
                                                <c:if
                                                    test="${sessionScope.userRole == 'MANAGER' || sessionScope.userRole == 'SUPPORT'}">
                                                    <div class="nav-item dropdown">
                                                        <a href="#"
                                                            class="nav-link dropdown-toggle ${currentPage == 'support' ? 'active' : ''}"
                                                            data-bs-toggle="dropdown">
                                                            <i class="fa fa-headset me-2"></i>Support
                                                        </a>
                                                        <div class="dropdown-menu bg-transparent border-0">
                                                            <a href="${pageContext.request.contextPath}/tickets"
                                                                class="dropdown-item">Tickets</a>
                                                            <a href="${pageContext.request.contextPath}/surveys"
                                                                class="dropdown-item">Khảo sát</a>
                                                        </div>
                                                    </div>
                                                </c:if>

                                                <%-- Reports --%>
                                                    <c:if test="${sessionScope.userRole == 'MANAGER'}">
                                                        <a href="${pageContext.request.contextPath}/reports"
                                                            class="nav-item nav-link ${currentPage == 'reports' ? 'active' : ''}">
                                                            <i class="fa fa-chart-bar me-2"></i>Reports
                                                        </a>
                                                    </c:if>

                                                    <hr class="my-2">

                                                    <%-- Profile --%>
                                                        <a href="${pageContext.request.contextPath}/profile"
                                                            class="nav-item nav-link ${currentPage == 'profile' ? 'active' : ''}">
                                                            <i class="fa fa-user-circle me-2"></i>Hồ sơ cá nhân
                                                        </a>
                    </div>
                </nav>
            </div>
            <!-- Sidebar End -->