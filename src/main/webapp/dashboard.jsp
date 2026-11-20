<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("currentNhanVien") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String userName  = (String) session.getAttribute("userName");
    String role      = (String) session.getAttribute("loaiTaiKhoan");
    String roleLabel = "QUANLY".equals(role) ? "Quản Lý" : "Nhân Viên";
    String cp        = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Quản Lý Tiệm Net</title>
    <link rel="stylesheet" href="<%= cp %>/css/style.css">
</head>
<body>
<div class="layout">
    <% request.setAttribute("currentPage","dashboard"); %>
    <jsp:include page="/WEB-INF/sidebar.jsp"/>

    <main class="main-content">
        <div class="top-bar">
            <h1>
                <i class="material-icons top-bar-icon">dashboard</i>
                Dashboard
            </h1>
            <div class="top-bar-actions">
                <span style="color:#888888; font-size:13px;">
                    Xin chào, <strong style="color:#212121"><%= userName != null ? userName : "Người dùng" %></strong>
                    &nbsp;·&nbsp; <span style="color:#1565C0"><%= roleLabel %></span>
                </span>
            </div>
        </div>

        <div class="page-content">

            <%-- Stat Cards --%>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon purple">
                        <i class="material-icons">group</i>
                    </div>
                    <div class="stat-value">—</div>
                    <div class="stat-label">Khách Hàng</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green">
                        <i class="material-icons">badge</i>
                    </div>
                    <div class="stat-value">—</div>
                    <div class="stat-label">Nhân Viên</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue">
                        <i class="material-icons">computer</i>
                    </div>
                    <div class="stat-value">—</div>
                    <div class="stat-label">Máy Tính</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange">
                        <i class="material-icons">restaurant_menu</i>
                    </div>
                    <div class="stat-value">—</div>
                    <div class="stat-label">Dịch Vụ</div>
                </div>
            </div>

            <%-- Welcome Card --%>
            <div class="welcome-card">
                <i class="material-icons w-icon">computer</i>
                <h2>Chào mừng đến với Tiệm Net Pro</h2>
                <p>Sử dụng menu bên trái để quản lý khách hàng, nhân viên,
                   máy tính, dịch vụ và gói dịch vụ.</p>
                <div class="actions">
                    <a href="<%= cp %>/khachhang" class="btn btn-primary">
                        <i class="material-icons">group</i> Khách Hàng
                    </a>
                    <a href="<%= cp %>/maytinh" class="btn btn-secondary">
                        <i class="material-icons">computer</i> Máy Tính
                    </a>
                    <a href="<%= cp %>/dichvu" class="btn btn-secondary">
                        <i class="material-icons">restaurant_menu</i> Dịch Vụ
                    </a>
                    <a href="<%= cp %>/goidichvu" class="btn btn-secondary">
                        <i class="material-icons">card_membership</i> Gói DV
                    </a>
                </div>
            </div>

        </div>
    </main>
</div>
</body>
</html>
