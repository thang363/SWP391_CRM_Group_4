<%-- topbar.jsp - Top navbar dùng chung --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>

        <!-- Navbar Start -->
        <nav class="navbar navbar-expand bg-light navbar-light sticky-top px-4 py-0">
            <a href="${pageContext.request.contextPath}/dashboard" class="navbar-brand d-flex d-lg-none me-4">
                <h2 class="text-primary mb-0"><i class="fa fa-hashtag"></i></h2>
            </a>
            <a href="#" class="sidebar-toggler flex-shrink-0">
                <i class="fa fa-bars"></i>
            </a>
            <form class="d-none d-md-flex ms-4" action="${pageContext.request.contextPath}/search" method="GET">
                <input class="form-control border-0" type="search" name="q" placeholder="Tìm kiếm...">
            </form>
            <div class="navbar-nav align-items-center ms-auto">
                <%-- Messages Dropdown --%>
                    <div class="nav-item dropdown">
                        <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                            <i class="fa fa-envelope me-lg-2"></i>
                            <span class="d-none d-lg-inline-flex">Tin nhắn</span>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end bg-light border-0 rounded-0 rounded-bottom m-0">
                            <a href="#" class="dropdown-item">
                                <div class="d-flex align-items-center">
                                    <img class="rounded-circle" src="${pageContext.request.contextPath}/img/user.jpg"
                                        alt="" style="width: 40px; height: 40px;">
                                    <div class="ms-2">
                                        <h6 class="fw-normal mb-0">Tin nhắn mới</h6>
                                        <small>5 phút trước</small>
                                    </div>
                                </div>
                            </a>
                            <hr class="dropdown-divider">
                            <a href="${pageContext.request.contextPath}/messages" class="dropdown-item text-center">Xem
                                tất cả</a>
                        </div>
                    </div>

                    <%-- Notifications Dropdown --%>
                        <div class="nav-item dropdown">
                            <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                                <i class="fa fa-bell me-lg-2"></i>
                                <span class="d-none d-lg-inline-flex">Thông báo</span>
                            </a>
                            <div class="dropdown-menu dropdown-menu-end bg-light border-0 rounded-0 rounded-bottom m-0">
                                <a href="#" class="dropdown-item">
                                    <h6 class="fw-normal mb-0">Deal mới được tạo</h6>
                                    <small>10 phút trước</small>
                                </a>
                                <hr class="dropdown-divider">
                                <a href="${pageContext.request.contextPath}/notifications"
                                    class="dropdown-item text-center">Xem tất cả</a>
                            </div>
                        </div>

                        <%-- User Profile Dropdown --%>
                            <div class="nav-item dropdown">
                                <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                                    <img class="rounded-circle me-lg-2"
                                        src="${pageContext.request.contextPath}/img/user.jpg" alt=""
                                        style="width: 40px; height: 40px;">
                                    <span class="d-none d-lg-inline-flex">${sessionScope.userName != null ?
                                        sessionScope.userName : 'Guest'}</span>
                                </a>
                                <div
                                    class="dropdown-menu dropdown-menu-end bg-light border-0 rounded-0 rounded-bottom m-0">
                                    <a href="${pageContext.request.contextPath}/profile" class="dropdown-item">Hồ sơ</a>
                                    <a href="${pageContext.request.contextPath}/settings" class="dropdown-item">Cài
                                        đặt</a>
                                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">Đăng
                                        xuất</a>
                                </div>
                            </div>
            </div>
        </nav>
        <!-- Navbar End -->