<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userName = (String) session.getAttribute("userName");
    String role = (String) session.getAttribute("loaiTaiKhoan");
    String roleLabel = "QUANLY".equals(role) ? "Quản Lý" : "Nhân Viên";
    String avatarChar = (userName != null && !userName.isEmpty())
        ? String.valueOf(userName.charAt(0)).toUpperCase() : "U";
    String cp = request.getContextPath();
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "";
%>
<%-- Load Google Material Icons (CDN chính thức, không dùng Symbols) --%>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<aside class="sidebar">

    <%-- ===== LOGO ===== --%>
    <div class="sidebar-logo-area">
        <div class="sidebar-logo-row">
            <i class="material-icons sidebar-logo-icon">computer</i>
            <div>
                <div class="sidebar-logo-text">TIỆM NET</div>
                <div class="sidebar-logo-sub">Quản lý hệ thống</div>
            </div>
        </div>
    </div>

    <%-- ===== USER STRIP ===== --%>
    <div class="sidebar-user-strip">
        <div class="sidebar-avatar"><%= avatarChar %></div>
        <div>
            <div class="sidebar-user-name"><%= userName != null ? userName : "Người dùng" %></div>
            <span class="sidebar-user-role"><%= roleLabel %></span>
        </div>
    </div>

    <%-- ===== NAV ===== --%>
    <nav class="sidebar-nav">

        <div class="nav-section-title">Tổng quan</div>
        <a href="<%= cp %>/dashboard.jsp"
           class="nav-item <%= "dashboard".equals(currentPage) ? "active" : "" %>">
            <i class="material-icons nav-icon">dashboard</i>
            <span>Dashboard</span>
        </a>

        <div class="nav-section-title">Dịch vụ</div>
        <a href="<%= cp %>/dichvu"
           class="nav-item <%= "dichvu".equals(currentPage) ? "active" : "" %>">
            <i class="material-icons nav-icon">restaurant_menu</i>
            <span>Dịch vụ</span>
        </a>
        <a href="<%= cp %>/goidichvu"
           class="nav-item <%= "goidichvu".equals(currentPage) ? "active" : "" %>">
            <i class="material-icons nav-icon">card_membership</i>
            <span>Gói dịch vụ</span>
        </a>

        <div class="nav-section-title">Quản lý</div>
        <a href="<%= cp %>/khachhang"
           class="nav-item <%= "khachhang".equals(currentPage) ? "active" : "" %>">
            <i class="material-icons nav-icon">group</i>
            <span>Khách hàng</span>
        </a>
        <a href="<%= cp %>/nhanvien"
           class="nav-item <%= "nhanvien".equals(currentPage) ? "active" : "" %>">
            <i class="material-icons nav-icon">badge</i>
            <span>Nhân viên</span>
        </a>
        <a href="<%= cp %>/maytinh"
           class="nav-item <%= "maytinh".equals(currentPage) ? "active" : "" %>">
            <i class="material-icons nav-icon">computer</i>
            <span>Máy tính</span>
        </a>

    </nav>

    <%-- ===== LOGOUT ===== --%>
    <div class="sidebar-logout-area">
        <a href="<%= cp %>/logout" class="btn-logout">
            <i class="material-icons">logout</i>
            <span>Đăng xuất</span>
        </a>
    </div>

</aside>
