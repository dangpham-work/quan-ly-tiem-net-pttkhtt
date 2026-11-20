<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.DichVu, java.util.List" %>
<%
    if (session.getAttribute("currentNhanVien") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<DichVu> list = (List<DichVu>) request.getAttribute("list");
    DichVu editDV     = (DichVu) request.getAttribute("editDV");
    String error      = (String) request.getAttribute("error");
    String keyword    = (String) request.getAttribute("keyword");
    String openModal  = (String) request.getAttribute("openModal");
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    session.removeAttribute("successMsg"); session.removeAttribute("errorMsg");
    String role = (String) session.getAttribute("loaiTaiKhoan");
    boolean isQuanLy = "QUANLY".equals(role);
    String cp = request.getContextPath();
    if (list == null) list = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Dịch Vụ | Tiệm Net Pro</title>
    <link rel="stylesheet" href="<%= cp %>/css/style.css">
</head>
<body>
<div class="layout">
    <% request.setAttribute("currentPage","dichvu"); %>
    <jsp:include page="/WEB-INF/sidebar.jsp"/>

    <main class="main-content">
        <div class="top-bar">
            <h1>
                <span class="material-icons top-bar-icon">restaurant_menu</span>
                Quản Lý Dịch Vụ
            </h1>
            <div class="top-bar-actions">
                <% if (isQuanLy) { %><button class="btn btn-primary" onclick="openAddModal()"><span class="material-icons">add</span> Thêm Dịch Vụ</button><% } %>
            </div>
        </div>

        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success"><i class="material-icons" style="font-size:16px;">check_circle</i> <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"><i class="material-icons" style="font-size:16px;">warning</i> <%= errorMsg %></div><% } %>
            <% if (error      != null) { %><div class="alert alert-danger"><i class="material-icons" style="font-size:16px;">warning</i> <%= error %></div><% } %>

            <div class="toolbar">
                <form method="get" action="<%= cp %>/dichvu" style="display:flex;gap:10px;align-items:center;flex:1;">
                    <div class="search-box" style="flex:1;max-width:400px;">
                        <span class="material-icons search-icon">search</span>
                        <input type="text" name="keyword" placeholder="Tìm theo tên dịch vụ, mã, loại..."
                               value="<%= keyword != null ? keyword : "" %>">
                    </div>
                    <button type="submit" class="btn btn-secondary">Tìm</button>
                    <% if (keyword != null && !keyword.isEmpty()) { %><a href="<%= cp %>/dichvu" class="btn btn-secondary"><i class="material-icons">close</i> Xóa</a><% } %>
                </form>
                <% if (isQuanLy) { %><button class="btn btn-primary" onclick="openAddModal()"><i class="material-icons">add</i> Thêm Dịch Vụ</button><% } %>
            </div>

            <div class="table-wrapper">
                <% if (list.isEmpty()) { %>
                <div class="empty-state">
                    <span class="material-icons empty-icon">restaurant_menu</span>
                    <h3><%= keyword != null && !keyword.isEmpty() ? "Không tìm thấy kết quả" : "Chưa có dịch vụ" %></h3>
                    <p>Nhấn 'Thêm Dịch Vụ' để bắt đầu</p>
                </div>
                <% } else { %>
                <table class="data-table">
                    <thead><tr>
                        <th>Mã DV</th><th>Tên Dịch Vụ</th><th>Loại</th>
                        <th>Đơn Giá</th><th>ĐVT</th><th>Tồn Kho</th><th>Trạng Thái</th><th>Thao Tác</th>
                    </tr></thead>
                    <tbody>
                    <% for (DichVu d : list) {
                        boolean isNgung = "NGUNG".equalsIgnoreCase(d.getTrangthai());
                    %>
                    <tr>
                        <td><span style="font-family:monospace;color:var(--accent)"><%= d.getMadv() %></span></td>
                        <td><strong><%= d.getTendv() %></strong></td>
                        <td>
                            <% if ("DOUONG".equals(d.getLoaidv())) { %><span class="badge badge-info">Đồ Uống</span>
                            <% } else if ("THUCPHAM".equals(d.getLoaidv())) { %><span class="badge badge-success">Thực Phẩm</span>
                            <% } else { %><span class="badge badge-warning">Khác</span><% } %>
                        </td>
                        <td><strong style="color:var(--success)"><%= String.format("%,.0f", d.getDongia()) %>đ</strong></td>
                        <td><%= d.getDonvitinh() != null ? d.getDonvitinh() : "—" %></td>
                        <td>
                            <% if (d.getSoluongton() <= 0) { %>
                            <span style="color:var(--danger);font-weight:600;">Hết hàng</span>
                            <% } else { %>
                            <span style="color:var(--text-primary)"><%= d.getSoluongton() %></span>
                            <% } %>
                        </td>
                        <td>
                            <% if (isNgung) { %><span class="badge badge-inactive">Ngưng Bán</span>
                            <% } else { %><span class="badge badge-active">Đang Bán</span><% } %>
                        </td>
                        <td><div class="actions">
                            <% if (isQuanLy) { %>
                            <button class="btn btn-secondary btn-sm"
                                onclick="openEditModal('<%= d.getMadv() %>','<%= esc(d.getTendv()) %>','<%= d.getLoaidv() %>','<%= d.getDongia() %>','<%= d.getDonvitinh() != null ? esc(d.getDonvitinh()) : "" %>','<%= d.getSoluongton() %>','<%= d.getTrangthai() %>')">
                                <span class="material-icons">edit</span> Sửa
                            </button>
                            <% if (!isNgung) { %>
                            <form method="post" action="<%= cp %>/dichvu" style="display:inline;"
                                  onsubmit="return confirm('Ngưng bán dịch vụ này?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="maDV" value="<%= d.getMadv() %>">
                                <button type="submit" class="btn btn-danger btn-sm"><span class="material-icons">block</span> Ngưng</button>
                            </form>
                            <% } else { %>
                            <form method="post" action="<%= cp %>/dichvu" style="display:inline;">
                                <input type="hidden" name="action" value="restore">
                                <input type="hidden" name="maDV" value="<%= d.getMadv() %>">
                                <button type="submit" class="btn btn-warning btn-sm"><span class="material-icons">restore</span> Khôi Phục</button>
                            </form>
                            <% } %>
                            <% } %>
                        </div></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <div class="table-meta"><%= list.size() %> dịch vụ<% if (keyword != null && !keyword.isEmpty()) { %> | Từ khóa: "<%= keyword %>"<% } %></div>
                <% } %>
            </div>
        </div>
    </main>
</div>

<%-- MODAL THÊM --%>
<div id="modalAdd" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3><span class="material-icons">add_circle</span> Thêm Dịch Vụ</h3>
            <button class="modal-close" onclick="closeModal('modalAdd')">×</button>
        </div>
        <form method="post" action="<%= cp %>/dichvu">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label>Tên Dịch Vụ *</label>
                        <input type="text" name="tendv" class="form-control" placeholder="vd: Coca Cola" required>
                    </div>
                    <div class="form-group">
                        <label>Loại *</label>
                        <select name="loaidv" class="form-control" required>
                            <option value="DOUONG">Đồ Uống</option>
                            <option value="THUCPHAM">Thực Phẩm</option>
                            <option value="KHAC">Khác</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Đơn Giá (đ) *</label>
                        <input type="number" name="dongia" class="form-control" placeholder="15000" min="1" required>
                    </div>
                    <div class="form-group">
                        <label>Đơn Vị Tính</label>
                        <input type="text" name="donvitinh" class="form-control" placeholder="vd: Lon, Hộp, Cái">
                    </div>
                    <div class="form-group">
                        <label>Tồn Kho</label>
                        <input type="number" name="soluongton" class="form-control" placeholder="100" min="0" value="0">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('modalAdd')">Hủy</button>
                <button type="submit" class="btn btn-primary"><i class="material-icons">save</i> Thêm Dịch Vụ</button>
            </div>
        </form>
    </div>
</div>

<%-- MODAL SỬA --%>
<div id="modalEdit" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3><span class="material-icons">edit</span> Sửa Dịch Vụ</h3>
            <button class="modal-close" onclick="closeModal('modalEdit')">×</button>
        </div>
        <form method="post" action="<%= cp %>/dichvu">
            <input type="hidden" name="action" value="edit">
            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label>Mã Dịch Vụ</label>
                        <input type="text" id="eMaDV" name="maDV" class="form-control" readonly style="opacity:.6;cursor:not-allowed;">
                    </div>
                    <div class="form-group full-width">
                        <label>Tên Dịch Vụ *</label>
                        <input type="text" id="eTenDV" name="tendv" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Loại *</label>
                        <select id="eLoai" name="loaidv" class="form-control">
                            <option value="DOUONG">Đồ Uống</option>
                            <option value="THUCPHAM">Thực Phẩm</option>
                            <option value="KHAC">Khác</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Đơn Giá (đ) *</label>
                        <input type="number" id="eDonGia" name="dongia" class="form-control" min="1" required>
                    </div>
                    <div class="form-group">
                        <label>Đơn Vị Tính</label>
                        <input type="text" id="eDVT" name="donvitinh" class="form-control">
                    </div>
                    <div class="form-group">
                        <label>Tồn Kho</label>
                        <input type="number" id="eSLT" name="soluongton" class="form-control" min="0">
                    </div>
                    <div class="form-group full-width">
                        <label>Trạng Thái</label>
                        <select id="eTrangThai" name="trangthai" class="form-control">
                            <option value="HOATDONG">Đang Bán</option>
                            <option value="NGUNG">Ngưng Bán</option>
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
function openAddModal() { document.getElementById('modalAdd').classList.add('active'); }
function openEditModal(maDV, tenDV, loai, donGia, dvt, slt, trangThai) {
    document.getElementById('eMaDV').value    = maDV;
    document.getElementById('eTenDV').value   = tenDV;
    document.getElementById('eLoai').value    = loai;
    document.getElementById('eDonGia').value  = donGia;
    document.getElementById('eDVT').value     = dvt;
    document.getElementById('eSLT').value     = slt;
    document.getElementById('eTrangThai').value = trangThai;
    document.getElementById('modalEdit').classList.add('active');
}
function closeModal(id) { document.getElementById(id).classList.remove('active'); }
document.querySelectorAll('.modal-overlay').forEach(m => {
    m.addEventListener('click', e => { if (e.target === m) closeModal(m.id); });
});
<% if ("edit".equals(openModal) && editDV != null) { %>
openEditModal('<%= editDV.getMadv() %>','<%= esc(editDV.getTendv()) %>','<%= editDV.getLoaidv() %>',
    '<%= editDV.getDongia() %>','<%= editDV.getDonvitinh() != null ? esc(editDV.getDonvitinh()) : "" %>',
    '<%= editDV.getSoluongton() %>','<%= editDV.getTrangthai() %>');
<% } %>
</script>
<%! private String esc(String s){ if(s==null)return""; return s.replace("\\","\\\\").replace("'","\\'").replace("\"","\\\""); } %>
</body>
</html>
