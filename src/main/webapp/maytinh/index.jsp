<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.MayTinh, entity.KhuMay, java.util.List" %>
<%
    if (session.getAttribute("currentNhanVien") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<MayTinh> list   = (List<MayTinh>) request.getAttribute("list");
    List<KhuMay>  listKhu = (List<KhuMay>)  request.getAttribute("listKhu");
    MayTinh editMay      = (MayTinh) request.getAttribute("editMay");
    String error         = (String) request.getAttribute("error");
    String keyword       = (String) request.getAttribute("keyword");
    String openModal     = (String) request.getAttribute("openModal");
    String successMsg    = (String) session.getAttribute("successMsg");
    String errorMsg      = (String) session.getAttribute("errorMsg");
    session.removeAttribute("successMsg"); session.removeAttribute("errorMsg");
    String role = (String) session.getAttribute("loaiTaiKhoan");
    boolean isQuanLy = "QUANLY".equals(role);
    String cp = request.getContextPath();
    if (list == null) list = new java.util.ArrayList<>();
    if (listKhu == null) listKhu = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Máy Tính | Tiệm Net Pro</title>
    <link rel="stylesheet" href="<%= cp %>/css/style.css">
</head>
<body>
<div class="layout">
    <% request.setAttribute("currentPage","maytinh"); %>
    <jsp:include page="/WEB-INF/sidebar.jsp"/>

    <main class="main-content">
        <div class="top-bar">
            <h1>
                <span class="material-icons top-bar-icon">computer</span>
                Quản Lý Máy Tính
            </h1>
            <div class="top-bar-actions">
                <% if (isQuanLy) { %>
                <button class="btn btn-primary" onclick="openAddModal()">
                    <span class="material-icons">add</span> Thêm Máy
                </button>
                <% } %>
            </div>
        </div>

        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success"><i class="material-icons" style="font-size:16px;">check_circle</i> <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"><i class="material-icons" style="font-size:16px;">warning</i> <%= errorMsg %></div><% } %>
            <% if (error      != null) { %><div class="alert alert-danger"><i class="material-icons" style="font-size:16px;">warning</i> <%= error %></div><% } %>

            <div class="toolbar">
                <form method="get" action="<%= cp %>/maytinh" style="display:flex;gap:10px;align-items:center;flex:1;">
                    <div class="search-box" style="flex:1;max-width:400px;">
                        <span class="material-icons search-icon">search</span>
                        <input type="text" name="keyword" placeholder="Tìm theo tên máy, mã máy, khu..."
                               value="<%= keyword != null ? keyword : "" %>">
                    </div>
                    <button type="submit" class="btn btn-secondary">
                        <span class="material-icons">search</span> Tìm
                    </button>
                    <% if (keyword != null && !keyword.isEmpty()) { %>
                    <a href="<%= cp %>/maytinh" class="btn btn-secondary">
                        <span class="material-icons">close</span> Xóa
                    </a>
                    <% } %>
                </form>
                <% if (isQuanLy) { %>
                <button class="btn btn-primary" onclick="openAddModal()">
                    <span class="material-icons">add</span> Thêm Máy
                </button>
                <% } %>
            </div>

            <div class="table-wrapper">
                <% if (list.isEmpty()) { %>
                <div class="empty-state">
                    <span class="material-icons empty-icon">computer</span>
                    <h3><%= keyword != null && !keyword.isEmpty() ? "Không tìm thấy kết quả" : "Chưa có máy tính" %></h3>
                    <p>Nhấn 'Thêm Máy' để thêm mới</p>
                </div>
                <% } else { %>
                <table class="data-table">
                    <thead><tr>
                        <th>Mã Máy</th><th>Tên Máy</th><th>Khu</th><th>Cấu Hình</th>
                        <th>Giá/Giờ</th><th>Trạng Thái</th><th>Thao Tác</th>
                    </tr></thead>
                    <tbody>
                    <% for (MayTinh m : list) { %>
                    <tr>
                        <td><span style="font-family:monospace;color:var(--accent)"><%= m.getMamay() %></span></td>
                        <td><strong><%= m.getTenmay() %></strong></td>
                        <td><%= m.getMakhu() != null ? m.getMakhu() : "—" %></td>
                        <td style="font-size:12px;color:var(--text-secondary)"><%= m.getCauhinh() != null ? m.getCauhinh() : "—" %></td>
                        <td><strong style="color:var(--success)"><%= m.getGiamoigio() != null ? String.format("%,.0f", m.getGiamoigio()) + "đ" : "—" %></strong></td>
                        <td>
                            <% String tt = m.getTrangthai() != null ? m.getTrangthai() : "";
                               if ("TRONG".equals(tt)) { %><span class="badge badge-active">Trống</span>
                            <% } else if ("DANGDUNG".equals(tt)) { %><span class="badge badge-info">Đang Dùng</span>
                            <% } else if ("BAOTRI".equals(tt)) { %><span class="badge badge-maintain">Bảo Trì</span>
                            <% } else if ("NGUNG".equals(tt)) { %><span class="badge badge-inactive">Ngưng</span>
                            <% } else { %><span class="badge badge-warning"><%= tt %></span>
                            <% } %>
                        </td>
                        <td><div class="actions">
                            <% if (isQuanLy && !"DANGDUNG".equals(m.getTrangthai()) && !"NGUNG".equals(m.getTrangthai())) { %>
                            <button class="btn btn-secondary btn-sm"
                                onclick="openEditModal('<%= m.getMamay() %>','<%= esc(m.getTenmay()) %>','<%= m.getMakhu() != null ? m.getMakhu() : "" %>','<%= esc(m.getCauhinh() != null ? m.getCauhinh() : "") %>','<%= m.getGiamoigio() != null ? m.getGiamoigio() : 0 %>')">
                                <span class="material-icons">edit</span> Sửa
                            </button>
                            <% } %>
                            <% if (isQuanLy && "TRONG".equals(m.getTrangthai())) { %>
                            <form method="post" action="<%= cp %>/maytinh" style="display:inline;"
                                  onsubmit="return confirm('Chuyển máy <%= esc(m.getTenmay()) %> sang bảo trì?')">
                                <input type="hidden" name="action" value="baotri">
                                <input type="hidden" name="maMay" value="<%= m.getMamay() %>">
                                <button type="submit" class="btn btn-warning btn-sm"><span class="material-icons">build</span> Bảo Trì</button>
                            </form>
                            <form method="post" action="<%= cp %>/maytinh" style="display:inline;"
                                  onsubmit="return confirm('Ngưng hoạt động máy <%= esc(m.getTenmay()) %>?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="maMay" value="<%= m.getMamay() %>">
                                <button type="submit" class="btn btn-danger btn-sm"><span class="material-icons">block</span> Ngưng</button>
                            </form>
                            <% } %>
                            <% if (isQuanLy && "BAOTRI".equals(m.getTrangthai())) { %>
                            <form method="post" action="<%= cp %>/maytinh" style="display:inline;">
                                <input type="hidden" name="action" value="hoantatbaotri">
                                <input type="hidden" name="maMay" value="<%= m.getMamay() %>">
                                <button type="submit" class="btn btn-success btn-sm"><span class="material-icons">check_circle</span> Xong BT</button>
                            </form>
                            <% } %>
                        </div></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <div class="table-meta"><span class="material-icons">info</span> <%= list.size() %> máy tính<% if (keyword != null && !keyword.isEmpty()) { %> &nbsp;·&nbsp; Từ khóa: "<%= keyword %>"<% } %></div>
                <% } %>
            </div>
        </div>
    </main>
</div>

<%-- MODAL THÊM --%>
<div id="modalAdd" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3><span class="material-icons">add_circle</span> Thêm Máy Tính</h3>
            <button class="modal-close" onclick="closeModal('modalAdd')">×</button>
        </div>
        <form method="post" action="<%= cp %>/maytinh">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label>Tên Máy *</label>
                        <input type="text" name="tenmay" class="form-control" placeholder="vd: PC-01" required>
                    </div>
                    <div class="form-group">
                        <label>Khu Máy</label>
                        <select name="makhu" class="form-control">
                            <option value="">-- Chọn khu --</option>
                            <% for (KhuMay k : listKhu) { %>
                            <option value="<%= k.getMakhu() %>"><%= k.getTenkhu() %> (<%= k.getMakhu() %>)</option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Giá/Giờ (đ) *</label>
                        <input type="number" name="giamoigio" class="form-control" placeholder="5000" min="0" step="500" required>
                    </div>
                    <div class="form-group full-width">
                        <label>Cấu Hình</label>
                        <input type="text" name="cauhinh" class="form-control" placeholder="vd: i5-12400, 16GB RAM, RTX 3060">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('modalAdd')"><span class="material-icons">close</span> Hủy</button>
                <button type="submit" class="btn btn-primary"><span class="material-icons">save</span> Thêm Máy</button>
            </div>
        </form>
    </div>
</div>

<%-- MODAL SỬA --%>
<div id="modalEdit" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3><span class="material-icons">edit</span> Sửa Máy Tính</h3>
            <button class="modal-close" onclick="closeModal('modalEdit')">×</button>
        </div>
        <form method="post" action="<%= cp %>/maytinh">
            <input type="hidden" name="action" value="edit">
            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label>Mã Máy</label>
                        <input type="text" id="eMaMay" name="maMay" class="form-control" readonly style="opacity:.6;cursor:not-allowed;">
                    </div>
                    <div class="form-group full-width">
                        <label>Tên Máy *</label>
                        <input type="text" id="eTenMay" name="tenmay" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Khu Máy</label>
                        <select id="eMaKhu" name="makhu" class="form-control">
                            <option value="">-- Không có khu --</option>
                            <% for (KhuMay k : listKhu) { %>
                            <option value="<%= k.getMakhu() %>"><%= k.getTenkhu() %> (<%= k.getMakhu() %>)</option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Giá/Giờ (đ) *</label>
                        <input type="number" id="eGia" name="giamoigio" class="form-control" min="0" step="500" required>
                    </div>
                    <div class="form-group full-width">
                        <label>Cấu Hình</label>
                        <input type="text" id="eCauHinh" name="cauhinh" class="form-control">
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
function openEditModal(maMay, tenMay, maKhu, cauHinh, gia) {
    document.getElementById('eMaMay').value = maMay;
    document.getElementById('eTenMay').value = tenMay;
    document.getElementById('eMaKhu').value = maKhu;
    document.getElementById('eCauHinh').value = cauHinh;
    document.getElementById('eGia').value = gia;
    document.getElementById('modalEdit').classList.add('active');
}
function closeModal(id) { document.getElementById(id).classList.remove('active'); }
document.querySelectorAll('.modal-overlay').forEach(m => {
    m.addEventListener('click', e => { if (e.target === m) closeModal(m.id); });
});
<% if ("edit".equals(openModal) && editMay != null) { %>
openEditModal('<%= editMay.getMamay() %>','<%= esc(editMay.getTenmay()) %>',
    '<%= editMay.getMakhu() != null ? editMay.getMakhu() : "" %>',
    '<%= esc(editMay.getCauhinh() != null ? editMay.getCauhinh() : "") %>',
    '<%= editMay.getGiamoigio() != null ? editMay.getGiamoigio() : 0 %>');
<% } %>
</script>
<%! private String esc(String s){ if(s==null)return""; return s.replace("\\","\\\\").replace("'","\\'").replace("\"","\\\""); } %>
</body>
</html>
