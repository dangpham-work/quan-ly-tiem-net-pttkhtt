<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("currentNhanVien") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập | Quản Lý Tiệm Net</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="login-root">
    <div class="login-card">

        <%-- Logo Area --%>
        <div class="login-logo-area">
            <div class="login-logo-circle">
                <i class="material-icons">computer</i>
            </div>
            <div class="login-app-name">TIỆM NET ONLINE</div>
            <div class="login-app-sub">Hệ thống quản lý tiệm Internet</div>
        </div>

        <div class="login-separator"></div>

        <%-- Tab chọn loại tài khoản --%>
        <div class="login-role-toggle" id="roleToggle">
            <button type="button" id="btnTabKhachHang"
                    class="login-role-btn active"
                    onclick="selectRole('khachhang')">
                <i class="material-icons">person</i>
                Khách hàng
            </button>
            <button type="button" id="btnTabNhanVien"
                    class="login-role-btn"
                    onclick="selectRole('nhanvien')">
                <i class="material-icons">badge</i>
                Nhân viên
            </button>
        </div>

        <%-- Form đăng nhập --%>
        <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
            <input type="hidden" id="roleInput" name="role" value="khachhang">

            <%-- Username --%>
            <div style="margin-bottom: 12px;">
                <div class="login-subtitle" id="usernameLabel">Tên đăng nhập</div>
                <div class="login-field-box">
                    <i class="material-icons login-field-icon" id="usernameIcon">person</i>
                    <input type="text" id="txtUsername" name="username"
                           class="login-text-field"
                           placeholder="Nhập tên đăng nhập"
                           required autofocus>
                </div>
            </div>

            <%-- Password --%>
            <div style="margin-bottom: 6px;">
                <div class="login-subtitle">Mật khẩu</div>
                <div class="login-field-box">
                    <i class="material-icons login-field-icon">lock</i>
                    <input type="password" id="txtPassword" name="password"
                           class="login-text-field"
                           placeholder="Mật khẩu"
                           required>
                </div>
            </div>

            <%-- Error --%>
            <% if (error != null) { %>
            <div class="login-error-label show">
                <i class="material-icons" style="font-size:15px;vertical-align:middle;">warning</i>
                <%= error %>
            </div>
            <% } %>

            <%-- Login Button --%>
            <button type="submit" class="login-btn" style="margin-top: 10px;">
                Đăng nhập
            </button>
        </form>

        <%-- Link đăng ký --%>
        <div style="text-align: center; display: flex; align-items: center; justify-content: center; gap: 6px;">
            <span class="login-app-sub">Chưa có tài khoản?</span>
            <button type="button" class="login-link-btn"
                    onclick="alert('Vui lòng liên hệ quản lý để được cấp tài khoản.')">
                Đăng ký ngay
            </button>
        </div>

        <div class="login-footer">© 2026 Quản Lý Tiệm Net v2.0</div>

    </div>
</div>

<script>
function selectRole(role) {
    const kh = document.getElementById('btnTabKhachHang');
    const nv = document.getElementById('btnTabNhanVien');
    const roleInput = document.getElementById('roleInput');
    const usernameIcon = document.getElementById('usernameIcon');

    if (role === 'khachhang') {
        kh.classList.add('active');
        nv.classList.remove('active');
        usernameIcon.textContent = 'person';
        roleInput.value = 'khachhang';
    } else {
        nv.classList.add('active');
        kh.classList.remove('active');
        usernameIcon.textContent = 'badge';
        roleInput.value = 'nhanvien';
    }
}
</script>
</body>
</html>
