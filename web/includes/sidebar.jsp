<%-- sidebar.jsp - Sidebar dùng chung --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
                            <h6 class="mb-0">${sessionScope.userName != null ? sessionScope.userName : 'Guest'}</h6>
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
                            <div class="nav-item dropdown">
                                <a href="#"
                                    class="nav-link dropdown-toggle ${currentPage == 'sales' || currentPage == 'sales-pipeline' ? 'active' : ''}"
                                    data-bs-toggle="dropdown">
                                    <i class="fa fa-chart-line me-2"></i>CRM Sales
                                </a>
                                <div class="dropdown-menu bg-transparent border-0">
                                    <a href="${pageContext.request.contextPath}/sales-pipeline"
                                        class="dropdown-item">Sales Pipeline</a>
                                    <a href="${pageContext.request.contextPath}/leads" class="dropdown-item">Leads</a>
                                    <a href="${pageContext.request.contextPath}/quotes" class="dropdown-item">Báo
                                        giá</a>
                                </div>
                            </div>

                            <%-- Marketing Module --%>
                                <div class="nav-item dropdown">
                                    <a href="#"
                                        class="nav-link dropdown-toggle ${currentPage == 'marketing' ? 'active' : ''}"
                                        data-bs-toggle="dropdown">
                                        <i class="fa fa-bullhorn me-2"></i>Marketing
                                    </a>
                                    <div class="dropdown-menu bg-transparent border-0">
                                        <a href="${pageContext.request.contextPath}/campaigns"
                                            class="dropdown-item ${currentPage == 'campaigns' ? 'active' : ''}">Chiến
                                            dịch</a>
                                        <a href="${pageContext.request.contextPath}/email-marketing"
                                            class="dropdown-item">Email Marketing</a>
                                        <a href="${pageContext.request.contextPath}/lead-sources"
                                            class="dropdown-item">Lead Sources</a>
                                        <a href="${pageContext.request.contextPath}/transfers"
                                            class="dropdown-item ${currentPage == 'transfers' ? 'active' : ''}">Chuyển
                                            giao (Handover)</a>
                                        <a href="${pageContext.request.contextPath}/landing-pages"
                                            class="dropdown-item ${currentPage == 'landing-pages' ? 'active' : ''}">
                                            <i class="fa fa-file-code me-1"></i>Landing Pages</a>
                                    </div>
                                </div>

                                <%-- Customers Module --%>
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

                                    <%-- Activities --%>
                                        <a href="${pageContext.request.contextPath}/activities"
                                            class="nav-item nav-link ${currentPage == 'activities' ? 'active' : ''}">
                                            <i class="fa fa-tasks me-2"></i>Activities
                                        </a>

                                        <%-- Support Module --%>
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

                                            <%-- Reports --%>
                                                <a href="${pageContext.request.contextPath}/reports"
                                                    class="nav-item nav-link ${currentPage == 'reports' ? 'active' : ''}">
                                                    <i class="fa fa-chart-bar me-2"></i>Reports
                                                </a>

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