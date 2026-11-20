<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.NhanVien, java.util.List" %>
<%
    if (session.getAttribute("currentNhanVien") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<NhanVien> listDang = (List<NhanVien>) request.getAttribute("listDang");
    List<NhanVien> listNghi = (List<NhanVien>) request.getAttribute("listNghi");
    NhanVien editNV = (NhanVien) request.getAttribute("editNV");
    String error = (String) request.getAttribute("error");
    String keyword = (String) request.getAttribute("keyword");
    String openModal = (String) request.getAttribute("openModal");
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    session.removeAttribute("successMsg"); session.removeAttribute("errorMsg");
    String role = (String) session.getAttribute("loaiTaiKhoan");
    boolean isQuanLy = "QUANLY".equals(role);
    String cp = request.getContextPath();
    if (listDang == null) listDang = new java.util.ArrayList<>();
    if (listNghi == null) listNghi = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nhân Viên | Tiệm Net Pro</title>
    <link rel="stylesheet" href="<%= cp %>/css/style.css">
</head>
<body>
<div class="layout">
    <% request.setAttribute("currentPage","nhanvien"); %>
    <jsp:include page="/WEB-INF/sidebar.jsp"/>

    <main class="main-content">
        <div class="top-bar">
            <h1>
                <span class="material-icons top-bar-icon">badge</span>
                Quản Lý Nhân Viên
            </h1>
            <div class="top-bar-actions">
                <% if (isQuanLy) { %>
                <button class="btn btn-primary" onclick="openAddModal()">
                    <span class="material-icons">person_add</span> Thêm Nhân Viên
                </button>
                <% } %>
            </div>
        </div>

        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success"><i class="material-icons" style="font-size:16px;">check_circle</i> <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"><i class="material-icons" style="font-size:16px;">warning</i> <%= errorMsg %></div><% } %>
            <% if (error      != null) { %><div class="alert alert-danger"><i class="material-icons" style="font-size:16px;">warning</i> <%= error %></div><% } %>

            <%-- Toolbar --%>
            <div class="toolbar">
                <form method="get" action="<%= cp %>/nhanvien" style="display:flex;gap:10px;align-items:center;flex:1;">
                    <div class="search-box" style="flex:1;max-width:400px;">
                        <span class="material-icons search-icon">search</span>
                        <input type="text" name="keyword" placeholder="Tìm theo tên, tên đăng nhập, mã NV..."
                               value="<%= keyword != null ? keyword : "" %>">
                    </div>
                    <button type="submit" class="btn btn-secondary"><span class="material-icons">search</span> Tìm</button>
                    <% if (keyword != null && !keyword.isEmpty()) { %><a href="<%= cp %>/nhanvien" class="btn btn-secondary"><span class="material-icons">close</span> Xóa</a><% } %>
                </form>
                <% if (isQuanLy) { %><button class="btn btn-primary" onclick="openAddModal()"><span class="material-icons">person_add</span> Thêm Nhân Viên</button><% } %>
            </div>

            <%-- Bảng đang làm việc --%>
            <h3 style="margin-bottom:10px; color:var(--text-secondary); font-size:14px; font-weight:600; display:flex; align-items:center; gap:6px;">
                <span class="material-icons" style="color:var(--success);font-size:16px;">radio_button_checked</span> Nhân viên đang làm việc (<%= listDang.size() %>)
            </h3>
            <div class="table-wrapper" style="margin-bottom:24px;">
                <% if (listDang.isEmpty()) { %>
                <div class="empty-state" style="padding:30px;">
                    <p>Không có nhân viên đang làm việc</p>
                </div>
                <% } else { %>
                <table class="data-table">
                    <thead><tr>
                        <th>Mã NV</th><th>Họ Tên</th><th>Chức Vụ</th><th>Tên Đăng Nhập</th><th>Trạng Thái</th><th>Thao Tác</th>
                    </tr></thead>
                    <tbody>
                    <% for (NhanVien nv : listDang) { %>
                    <tr>
                        <td><span style="font-family:monospace;color:var(--accent)"><%= nv.getManv() %></span></td>
                        <td><strong><%= nv.getHo() %> <%= nv.getTen() %></strong></td>
                        <td>
                            <% if ("QUANLY".equals(nv.getChucvu())) { %>
                            <span class="badge badge-purple">Quản Lý</span>
                            <% } else if ("THUNGAN".equals(nv.getChucvu())) { %>
                            <span class="badge badge-info">Thu Ngân</span>
                            <% } else { %>
                            <span class="badge badge-active">Nhân Viên</span>
                            <% } %>
                        </td>
                        <td><%= nv.getTendangnhap() %></td>
                        <td><span class="badge badge-active">Đang Làm</span></td>
                        <td><div class="actions">
                            <% if (isQuanLy) { %>
                            <button class="btn btn-secondary btn-sm"
                                onclick="openEditModal('<%= nv.getManv() %>','<%= esc(nv.getHo()) %>','<%= esc(nv.getTen()) %>','<%= nv.getChucvu() %>','<%= esc(nv.getTendangnhap()) %>','<%= nv.getTrangthai() %>')">
                                <span class="material-icons">edit</span> Sửa
                            </button>
                            <form method="post" action="<%= cp %>/nhanvien" style="display:inline;"
                                  onsubmit="return confirm('Xóa nhân viên <%= nv.getHo() %> <%= nv.getTen() %>?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="maNV" value="<%= nv.getManv() %>">
                                <button type="submit" class="btn btn-danger btn-sm"><span class="material-icons">delete</span> Xóa</button>
                            </form>
                            <% } %>
                        </div></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <div class="table-meta"><%= listDang.size() %> nhân viên đang làm việc</div>
                <% } %>
            </div>

            <%-- Bảng đã nghỉ việc (chỉ hiện khi có dữ liệu và không tìm kiếm) --%>
            <% if ((keyword == null || keyword.isEmpty()) && !listNghi.isEmpty()) { %>
            <h3 style="margin-bottom:10px; color:var(--text-secondary); font-size:14px; font-weight:600; display:flex; align-items:center; gap:6px;">
                <span class="material-icons" style="color:var(--danger);font-size:16px;">radio_button_checked</span> Nhân viên đã nghỉ việc (<%= listNghi.size() %>)
            </h3>
            <div class="table-wrapper">
                <table class="data-table">
                    <thead><tr>
                        <th>Mã NV</th><th>Họ Tên</th><th>Chức Vụ</th><th>Tên Đăng Nhập</th><th>Trạng Thái</th><th>Thao Tác</th>
                    </tr></thead>
                    <tbody>
                    <% for (NhanVien nv : listNghi) { %>
                    <tr style="opacity:0.7;">
                        <td><span style="font-family:monospace;color:var(--text-muted)"><%= nv.getManv() %></span></td>
                        <td><%= nv.getHo() %> <%= nv.getTen() %></td>
                        <td><span class="badge badge-warning"><%= nv.getChucvu() %></span></td>
                        <td><%= nv.getTendangnhap() %></td>
                        <td><span class="badge badge-inactive">Nghỉ Việc</span></td>
                        <td><div class="actions">
                            <% if (isQuanLy) { %>
                            <form method="post" action="<%= cp %>/nhanvien" style="display:inline;">
                                <input type="hidden" name="action" value="restore">
                                <input type="hidden" name="maNV" value="<%= nv.getManv() %>">
                                <button type="submit" class="btn btn-warning btn-sm"><span class="material-icons">restore</span> Khôi Phục</button>
                            </form>
                            <% } %>
                        </div></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <div class="table-meta"><%= listNghi.size() %> nhân viên đã nghỉ việc</div>
            </div>
            <% } %>
        </div>
    </main>
</div>

<%-- MODAL THÊM --%>
<div id="modalAdd" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3><span class="material-icons">person_add</span> Thêm Nhân Viên</h3>
            <button class="modal-close" onclick="closeModal('modalAdd')">×</button>
        </div>
        <form method="post" action="<%= cp %>/nhanvien">
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
                        <input type="text" name="tendangnhap" class="form-control" placeholder="vd: nv_vana" required>
                    </div>
                    <div class="form-group">
                        <label>Mật Khẩu *</label>
                        <input type="password" name="matkhau" class="form-control" placeholder="Tối thiểu 6 ký tự" required>
                    </div>
                    <div class="form-group full-width">
                        <label>Chức Vụ *</label>
                        <select name="chucvu" class="form-control" required>
                            <option value="NHANVIEN">Nhân Viên</option>
                            <option value="QUANLY">Quản Lý</option>
                            <option value="THUNGAN">Thu Ngân</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('modalAdd')"><span class="material-icons">close</span> Hủy</button>
                <button type="submit" class="btn btn-primary"><span class="material-icons">save</span> Thêm Nhân Viên</button>
            </div>
        </form>
    </div>
</div>

<%-- MODAL SỬA --%>
<div id="modalEdit" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3><span class="material-icons">edit</span> Sửa Nhân Viên</h3>
            <button class="modal-close" onclick="closeModal('modalEdit')">×</button>
        </div>
        <form method="post" action="<%= cp %>/nhanvien">
            <input type="hidden" name="action" value="edit">
            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label>Mã Nhân Viên</label>
                        <input type="text" id="eMaNV" name="maNV" class="form-control" readonly style="opacity:.6;cursor:not-allowed;">
                    </div>
                    <div class="form-group">
                        <label>Họ *</label>
                        <input type="text" id="eHo" name="ho" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Tên *</label>
                        <input type="text" id="eTen" name="ten" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Tên Đăng Nhập</label>
                        <input type="text" id="eTenDN" name="tendangnhap" class="form-control" readonly style="opacity:.6;cursor:not-allowed;">
                    </div>
                    <div class="form-group">
                        <label>Mật Khẩu Mới (để trống = giữ nguyên)</label>
                        <input type="password" name="matkhau" class="form-control" placeholder="Để trống nếu không đổi">
                    </div>
                    <div class="form-group">
                        <label>Chức Vụ *</label>
                        <select id="eChucVu" name="chucvu" class="form-control" required>
                            <option value="NHANVIEN">Nhân Viên</option>
                            <option value="QUANLY">Quản Lý</option>
                            <option value="THUNGAN">Thu Ngân</option>
                        </select>
                    </div>
                    <div class="form-group full-width">
                        <label>Trạng Thái</label>
                        <select id="eTrangThai" name="trangthai" class="form-control">
                            <option value="DANGLAMVIEC">Đang Làm Việc</option>
                            <option value="NGHIVIEC">Nghỉ Việc</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('modalEdit')"><span class="material-icons">close</span> Hủy</button>
                <button type="submit" class="btn btn-primary"><span class="material-icons">save</span> Lưu Thay Đổi</button>
            </div>
        </form>
    </div>
</div>

<script>
function openAddModal() { document.getElementById('modalAdd').classList.add('active'); }
function openEditModal(maNV, ho, ten, chucVu, tenDN, trangThai) {
    document.getElementById('eMaNV').value = maNV;
    document.getElementById('eHo').value = ho;
    document.getElementById('eTen').value = ten;
    document.getElementById('eTenDN').value = tenDN;
    document.getElementById('eChucVu').value = chucVu;
    document.getElementById('eTrangThai').value = trangThai;
    document.getElementById('modalEdit').classList.add('active');
}
function closeModal(id) { document.getElementById(id).classList.remove('active'); }
document.querySelectorAll('.modal-overlay').forEach(m => {
    m.addEventListener('click', e => { if (e.target === m) closeModal(m.id); });
});
<% if ("edit".equals(openModal) && editNV != null) { %>
openEditModal('<%= editNV.getManv() %>','<%= esc(editNV.getHo()) %>','<%= esc(editNV.getTen()) %>',
    '<%= editNV.getChucvu() %>','<%= esc(editNV.getTendangnhap()) %>','<%= editNV.getTrangthai() %>');
<% } %>
</script>
<%! private String esc(String s){ if(s==null)return""; return s.replace("\\","\\\\").replace("'","\\'").replace("\"","\\\""); } %>
</body>
</html>
