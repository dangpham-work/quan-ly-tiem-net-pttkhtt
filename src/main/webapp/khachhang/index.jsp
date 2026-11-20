<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.KhachHang, java.util.List" %>
<%
    if (session.getAttribute("currentNhanVien") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<KhachHang> list = (List<KhachHang>) request.getAttribute("list");
    KhachHang editKH = (KhachHang) request.getAttribute("editKH");
    String error = (String) request.getAttribute("error");
    String keyword = (String) request.getAttribute("keyword");
    String openModal = (String) request.getAttribute("openModal");
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");
    session.removeAttribute("successMsg");
    session.removeAttribute("errorMsg");
    String role = (String) session.getAttribute("loaiTaiKhoan");
    boolean isQuanLy = "QUANLY".equals(role);
    String cp = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Khách Hàng | Tiệm Net Pro</title>
    <link rel="stylesheet" href="<%= cp %>/css/style.css">
</head>
<body>
<div class="layout">
    <%-- Sidebar --%>
    <% request.setAttribute("currentPage", "khachhang"); %>
    <jsp:include page="/WEB-INF/sidebar.jsp"/>

    <main class="main-content">
        <div class="top-bar">
            <h1>
                <span class="material-icons top-bar-icon">group</span>
                Quản Lý Khách Hàng
            </h1>
            <div class="top-bar-actions">
                <% if (isQuanLy) { %>
                <button class="btn btn-primary" onclick="openAddModal()">
                    <span class="material-icons">person_add</span> Thêm Khách Hàng
                </button>
                <% } %>
            </div>
        </div>

        <div class="page-content">
            <%-- Thông báo --%>
            <% if (successMsg != null) { %><div class="alert alert-success"><i class="material-icons" style="font-size:16px;">check_circle</i> <%= successMsg %></div><% } %>
            <% if (errorMsg != null) { %><div class="alert alert-danger"><i class="material-icons" style="font-size:16px;">warning</i> <%= errorMsg %></div><% } %>
            <% if (error != null) { %><div class="alert alert-danger"><i class="material-icons" style="font-size:16px;">warning</i> <%= error %></div><% } %>

            <%-- Toolbar --%>
            <div class="toolbar">
                <form method="get" action="<%= cp %>/khachhang" style="display:flex; gap:10px; align-items:center; flex:1;">
                    <div class="search-box" style="flex:1; max-width:400px;">
                        <span class="material-icons search-icon">search</span>
                        <input type="text" name="keyword" placeholder="Tìm theo tên, SĐT, tên đăng nhập, mã KH..."
                               value="<%= keyword != null ? keyword : "" %>">
                    </div>
                    <button type="submit" class="btn btn-secondary">Tìm</button>
                    <% if (keyword != null && !keyword.isEmpty()) { %>
                    <a href="<%= cp %>/khachhang" class="btn btn-secondary"><i class="material-icons">close</i> Xóa bộ lọc</a>
                    <% } %>
                </form>
                <% if (isQuanLy) { %>
                <button class="btn btn-primary" onclick="openAddModal()"><i class="material-icons">person_add</i> Thêm Khách Hàng</button>
                <% } %>
            </div>

            <%-- Bảng dữ liệu --%>
            <div class="table-wrapper">
                <% if (list == null || list.isEmpty()) { %>
                <div class="empty-state">
                    <span class="material-icons empty-icon">group</span>
                    <h3><%= keyword != null && !keyword.isEmpty() ? "Không tìm thấy kết quả" : "Chưa có khách hàng" %></h3>
                    <p><%= keyword != null && !keyword.isEmpty() ? "Thử tìm kiếm với từ khóa khác" : "Nhấn 'Thêm Khách Hàng' để bắt đầu" %></p>
                </div>
                <% } else { %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Mã KH</th>
                            <th>Họ Tên</th>
                            <th>Tên ĐN</th>
                            <th>SĐT</th>
                            <th>Số Dư</th>
                            <th>Trạng Thái</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (KhachHang kh : list) {
                            boolean isNgung = kh.isNgung();
                        %>
                        <tr>
                            <td><span style="font-family:monospace; color: var(--accent)"><%= kh.getMakh() %></span></td>
                            <td><strong><%= kh.getHo() %> <%= kh.getTen() %></strong></td>
                            <td><%= kh.getTendangnhap() != null ? kh.getTendangnhap() : "—" %></td>
                            <td><%= kh.getSodienthoai() != null ? kh.getSodienthoai() : "—" %></td>
                            <td><strong style="color: var(--success)"><%= String.format("%,.0f", kh.getSodu()) %>đ</strong></td>
                            <td>
                                <% if (isNgung) { %>
                                <span class="badge badge-inactive">Đã Khóa</span>
                                <% } else { %>
                                <span class="badge badge-active">Hoạt Động</span>
                                <% } %>
                            </td>
                            <td>
                                <div class="actions">
                                    <% if (isQuanLy) { %>
                                    <button class="btn btn-secondary btn-sm"
                                        onclick="openEditModal('<%= kh.getMakh() %>','<%= escapeJs(kh.getHo()) %>','<%= escapeJs(kh.getTen()) %>','<%= kh.getSodienthoai() != null ? kh.getSodienthoai() : "" %>','<%= escapeJs(kh.getTendangnhap()) %>','<%= kh.getTrangthai() %>','<%= kh.getSodu() %>')">
                                        <span class="material-icons">edit</span> Sửa
                                    </button>
                                    <% if (!isNgung) { %>
                                    <form method="post" action="<%= cp %>/khachhang" style="display:inline;"
                                          onsubmit="return confirm('Khóa khách hàng <%= kh.getHo() %> <%= kh.getTen() %>?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="maKH" value="<%= kh.getMakh() %>">
                                        <button type="submit" class="btn btn-danger btn-sm"><span class="material-icons">lock</span> Khóa</button>
                                    </form>
                                    <% } else { %>
                                    <form method="post" action="<%= cp %>/khachhang" style="display:inline;">
                                        <input type="hidden" name="action" value="restore">
                                        <input type="hidden" name="maKH" value="<%= kh.getMakh() %>">
                                        <button type="submit" class="btn btn-warning btn-sm"><span class="material-icons">lock_open</span> Mở Khóa</button>
                                    </form>
                                    <% } %>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <div class="table-meta">Hiển thị <%= list.size() %> khách hàng<% if (keyword != null && !keyword.isEmpty()) { %> | Từ khóa: "<%= keyword %>"<% } %></div>
                <% } %>
            </div>
        </div>
    </main>
</div>

<%-- ===== MODAL THÊM ===== --%>
<div id="modalAdd" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3><span class="material-icons">person_add</span> Thêm Khách Hàng</h3>
            <button class="modal-close" onclick="closeModal('modalAdd')">×</button>
        </div>
        <form method="post" action="<%= cp %>/khachhang" onsubmit="return validateForm(this)">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Họ *</label>
                        <input type="text" name="ho" class="form-control" placeholder="Nguyễn" required>
                    </div>
                    <div class="form-group">
                        <label>Tên *</label>
                        <input type="text" name="ten" class="form-control" placeholder="Văn A" required>
                    </div>
                    <div class="form-group">
                        <label>Tên Đăng Nhập *</label>
                        <input type="text" name="tendangnhap" class="form-control" placeholder="vd: nguyenvana" required>
                    </div>
                    <div class="form-group">
                        <label>Mật Khẩu *</label>
                        <input type="password" name="matkhau" class="form-control" placeholder="Tối thiểu 6 ký tự" required>
                    </div>
                    <div class="form-group">
                        <label>Số Điện Thoại</label>
                        <input type="text" name="sodienthoai" class="form-control" placeholder="0xxxxxxxxx">
                    </div>
                    <div class="form-group">
                        <label>Số Dư Ban Đầu (đ)</label>
                        <input type="number" name="sodu" class="form-control" placeholder="0" min="0" step="1000" value="0">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('modalAdd')">Hủy</button>
                <button type="submit" class="btn btn-primary"><i class="material-icons">save</i> Thêm Khách Hàng</button>
            </div>
        </form>
    </div>
</div>

<%-- ===== MODAL SỬA ===== --%>
<div id="modalEdit" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3><span class="material-icons">edit</span> Sửa Khách Hàng</h3>
            <button class="modal-close" onclick="closeModal('modalEdit')">×</button>
        </div>
        <form method="post" action="<%= cp %>/khachhang">
            <input type="hidden" name="action" value="edit">
            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label>Mã Khách Hàng</label>
                        <input type="text" id="editMaKH" name="maKH" class="form-control" readonly
                               style="opacity:0.6; cursor:not-allowed;">
                    </div>
                    <div class="form-group">
                        <label>Họ *</label>
                        <input type="text" id="editHo" name="ho" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Tên *</label>
                        <input type="text" id="editTen" name="ten" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Tên Đăng Nhập</label>
                        <input type="text" id="editTenDN" name="tendangnhap" class="form-control" readonly style="opacity:0.6; cursor:not-allowed;">
                    </div>
                    <div class="form-group">
                        <label>Mật Khẩu Mới (để trống = giữ nguyên)</label>
                        <input type="password" name="matkhau" class="form-control" placeholder="Để trống nếu không đổi">
                    </div>
                    <div class="form-group">
                        <label>Số Điện Thoại</label>
                        <input type="text" id="editSdt" name="sodienthoai" class="form-control">
                    </div>
                    <div class="form-group">
                        <label>Số Dư (đ)</label>
                        <input type="number" id="editSodu" name="sodu" class="form-control" min="0" step="1000">
                    </div>
                    <div class="form-group full-width">
                        <label>Trạng Thái</label>
                        <select id="editTrangThai" name="trangthai" class="form-control">
                            <option value="HOATDONG">Hoạt Động</option>
                            <option value="NGUNG">Ngưng</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('modalEdit')">Hủy</button>
                <button type="submit" class="btn btn-primary"><i class="material-icons">save</i> Lưu Thay Đổi</button>
            </div>
        </form>
    </div>
</div>

<script>
function openAddModal() {
    document.getElementById('modalAdd').classList.add('active');
}
function openEditModal(maKH, ho, ten, sdt, tenDN, trangThai, sodu) {
    document.getElementById('editMaKH').value = maKH;
    document.getElementById('editHo').value = ho;
    document.getElementById('editTen').value = ten;
    document.getElementById('editSdt').value = sdt;
    document.getElementById('editTenDN').value = tenDN;
    document.getElementById('editSodu').value = sodu;
    document.getElementById('editTrangThai').value = trangThai;
    document.getElementById('modalEdit').classList.add('active');
}
function closeModal(id) {
    document.getElementById(id).classList.remove('active');
}
document.querySelectorAll('.modal-overlay').forEach(m => {
    m.addEventListener('click', function(e) {
        if (e.target === this) closeModal(this.id);
    });
});
function validateForm(form) {
    const mk = form.querySelector('[name="matkhau"]');
    if (mk && mk.value.length > 0 && mk.value.length < 6) {
        alert('Mật khẩu phải có ít nhất 6 ký tự!');
        return false;
    }
    return true;
}
// Auto-open edit modal nếu có từ server
<% if ("edit".equals(openModal) && editKH != null) { %>
openEditModal('<%= editKH.getMakh() %>','<%= escapeJs(editKH.getHo()) %>','<%= escapeJs(editKH.getTen()) %>',
    '<%= editKH.getSodienthoai() != null ? editKH.getSodienthoai() : "" %>',
    '<%= escapeJs(editKH.getTendangnhap()) %>','<%= editKH.getTrangthai() %>','<%= editKH.getSodu() %>');
<% } %>
</script>
<%!
private String escapeJs(String s) {
    if (s == null) return "";
    return s.replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
}
%>
</body>
</html>
