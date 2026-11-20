<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.GoiDichVu, java.util.List" %>
<%
    if (session.getAttribute("currentNhanVien") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<GoiDichVu> list = (List<GoiDichVu>) request.getAttribute("list");
    GoiDichVu editGDV    = (GoiDichVu) request.getAttribute("editGDV");
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
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Gói Dịch Vụ | Tiệm Net Pro</title>
    <link rel="stylesheet" href="<%= cp %>/css/style.css">
</head>
<body>
<div class="layout">
    <% request.setAttribute("currentPage","goidichvu"); %>
    <jsp:include page="/WEB-INF/sidebar.jsp"/>

    <main class="main-content">
        <div class="top-bar">
            <h1>
                <span class="material-icons top-bar-icon">card_membership</span>
                Quản Lý Gói Dịch Vụ
            </h1>
            <div class="top-bar-actions">
                <% if (isQuanLy) { %><button class="btn btn-primary" onclick="openAddModal()"><span class="material-icons">add</span> Thêm Gói</button><% } %>
            </div>
        </div>

        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success"><i class="material-icons" style="font-size:16px;">check_circle</i> <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"><i class="material-icons" style="font-size:16px;">warning</i> <%= errorMsg %></div><% } %>
            <% if (error      != null) { %><div class="alert alert-danger"><i class="material-icons" style="font-size:16px;">warning</i> <%= error %></div><% } %>

            <div class="toolbar">
                <form method="get" action="<%= cp %>/goidichvu" style="display:flex;gap:10px;align-items:center;flex:1;">
                    <div class="search-box" style="flex:1;max-width:400px;">
                        <span class="material-icons search-icon">search</span>
                        <input type="text" name="keyword" placeholder="Tìm theo tên gói, mã gói, loại gói..."
                               value="<%= keyword != null ? keyword : "" %>">
                    </div>
                    <button type="submit" class="btn btn-secondary">Tìm</button>
                    <% if (keyword != null && !keyword.isEmpty()) { %><a href="<%= cp %>/goidichvu" class="btn btn-secondary"><i class="material-icons">close</i> Xóa</a><% } %>
                </form>
                <% if (isQuanLy) { %><button class="btn btn-primary" onclick="openAddModal()"><i class="material-icons">add</i> Thêm Gói</button><% } %>
            </div>

            <div class="table-wrapper">
                <% if (list.isEmpty()) { %>
                <div class="empty-state">
                    <span class="material-icons empty-icon">card_membership</span>
                    <h3><%= keyword != null && !keyword.isEmpty() ? "Không tìm thấy kết quả" : "Chưa có gói dịch vụ" %></h3>
                    <p>Nhấn 'Thêm Gói' để bắt đầu</p>
                </div>
                <% } else { %>
                <table class="data-table">
                    <thead><tr>
                        <th>Mã Gói</th><th>Tên Gói</th><th>Loại</th>
                        <th>Số Giờ</th><th>Hiệu Lực</th><th>Giá Gốc</th><th>Giá Gói</th>
                        <th>Khu Áp Dụng</th><th>Trạng Thái</th><th>Thao Tác</th>
                    </tr></thead>
                    <tbody>
                    <% for (GoiDichVu g : list) {
                        boolean isNgung = "NGUNG".equalsIgnoreCase(g.getTrangthai());
                    %>
                    <tr>
                        <td><span style="font-family:monospace;color:var(--accent)"><%= g.getMagoi() %></span></td>
                        <td><strong><%= g.getTengoi() %></strong></td>
                        <td>
                            <% String loai = g.getLoaigoi() != null ? g.getLoaigoi() : "";
                               if ("THEOGIO".equals(loai)) { %><span class="badge badge-info">Theo Giờ</span>
                            <% } else if ("THEONGAY".equals(loai)) { %><span class="badge badge-warning">Theo Ngày</span>
                            <% } else if ("THEOTUAN".equals(loai)) { %><span class="badge badge-purple">Theo Tuần</span>
                            <% } else if ("THEOTHANG".equals(loai)) { %><span class="badge badge-success">Theo Tháng</span>
                            <% } else { %><span class="badge badge-warning"><%= loai %></span><% } %>
                        </td>
                        <td><%= g.getSogio() %> giờ</td>
                        <td><%= g.getSongayhieuluc() %> ngày</td>
                        <td style="text-decoration:line-through;color:var(--text-muted)">
                            <%= String.format("%,.0f", g.getGiagoc()) %>đ
                        </td>
                        <td><strong style="color:var(--success)"><%= String.format("%,.0f", g.getGiagoi()) %>đ</strong>
                            <% double pct = g.getGiagoc() > 0 ? (1 - g.getGiagoi()/g.getGiagoc()) * 100 : 0;
                               if (pct > 0) { %>
                            <span style="font-size:11px;color:var(--danger);margin-left:4px;">-<%= String.format("%.0f", pct) %>%</span>
                            <% } %>
                        </td>
                        <td><%= g.getApdungchokhu() != null && !g.getApdungchokhu().isEmpty() ? g.getApdungchokhu() : "Tất cả" %></td>
                        <td>
                            <% if (isNgung) { %><span class="badge badge-inactive">Ngưng</span>
                            <% } else { %><span class="badge badge-active">Hoạt Động</span><% } %>
                        </td>
                        <td><div class="actions">
                            <% if (isQuanLy) { %>
                            <button class="btn btn-secondary btn-sm"
                                onclick="openEditModal('<%= g.getMagoi() %>','<%= esc(g.getTengoi()) %>','<%= g.getLoaigoi() %>','<%= g.getSogio() %>','<%= g.getSongayhieuluc() %>','<%= g.getGiagoc() %>','<%= g.getGiagoi() %>','<%= g.getApdungchokhu() != null ? esc(g.getApdungchokhu()) : "" %>','<%= g.getTrangthai() %>')">
                                <i class="material-icons">edit</i> Sửa
                            </button>
                            <% if (!isNgung) { %>
                            <form method="post" action="<%= cp %>/goidichvu" style="display:inline;"
                                  onsubmit="return confirm('Ngưng gói dịch vụ này?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="maGoi" value="<%= g.getMagoi() %>">
                                <button type="submit" class="btn btn-danger btn-sm"><i class="material-icons" style="font-size:14px;">block</i> Ngưng</button>
                            </form>
                            <% } else { %>
                            <form method="post" action="<%= cp %>/goidichvu" style="display:inline;">
                                <input type="hidden" name="action" value="restore">
                                <input type="hidden" name="maGoi" value="<%= g.getMagoi() %>">
                                <button type="submit" class="btn btn-warning btn-sm"><i class="material-icons">restore</i> Khôi Phục</button>
                            </form>
                            <% } %>
                            <% } %>
                        </div></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <div class="table-meta"><%= list.size() %> gói dịch vụ<% if (keyword != null && !keyword.isEmpty()) { %> | Từ khóa: "<%= keyword %>"<% } %></div>
                <% } %>
            </div>
        </div>
    </main>
</div>

<%-- MODAL THÊM --%>
<div id="modalAdd" class="modal-overlay">
    <div class="modal" style="max-width:580px;">
        <div class="modal-header">
            <h3><span class="material-icons">add_circle</span> Thêm Gói Dịch Vụ</h3>
            <button class="modal-close" onclick="closeModal('modalAdd')">×</button>
        </div>
        <form method="post" action="<%= cp %>/goidichvu">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label>Tên Gói *</label>
                        <input type="text" name="tengoi" class="form-control" placeholder="vd: Gói Gaming Cuối Tuần" required>
                    </div>
                    <div class="form-group">
                        <label>Loại Gói *</label>
                        <select name="loaigoi" class="form-control" required>
                            <option value="THEOGIO">Theo Giờ</option>
                            <option value="THEONGAY">Theo Ngày</option>
                            <option value="THEOTUAN">Theo Tuần</option>
                            <option value="THEOTHANG">Theo Tháng</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Số Giờ *</label>
                        <input type="number" name="sogio" class="form-control" placeholder="10" min="0.5" step="0.5" required>
                    </div>
                    <div class="form-group">
                        <label>Số Ngày Hiệu Lực *</label>
                        <input type="number" name="songayhieuluc" class="form-control" placeholder="30" min="1" required>
                    </div>
                    <div class="form-group">
                        <label>Giá Gốc (đ) *</label>
                        <input type="number" name="giagoc" class="form-control" placeholder="500000" min="1" id="aGiaGoc" required oninput="calcDiscount('a')">
                    </div>
                    <div class="form-group">
                        <label>Giá Gói (đ) * <small style="color:var(--text-muted)">(≤ giá gốc)</small></label>
                        <input type="number" name="giagoi" class="form-control" placeholder="400000" min="1" id="aGiaGoi" required oninput="calcDiscount('a')">
                    </div>
                    <div class="form-group full-width">
                        <label style="display:flex;justify-content:space-between;">
                            Khu Áp Dụng <span id="aDiscount" style="color:var(--success);font-size:12px;"></span>
                        </label>
                        <input type="text" name="apdungchokhu" class="form-control" placeholder="Để trống = áp dụng tất cả khu">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('modalAdd')">Hủy</button>
                <button type="submit" class="btn btn-primary"><i class="material-icons">save</i> Thêm Gói</button>
            </div>
        </form>
    </div>
</div>

<%-- MODAL SỬA --%>
<div id="modalEdit" class="modal-overlay">
    <div class="modal" style="max-width:580px;">
        <div class="modal-header">
            <h3><span class="material-icons">edit</span> Sửa Gói Dịch Vụ</h3>
            <button class="modal-close" onclick="closeModal('modalEdit')">×</button>
        </div>
        <form method="post" action="<%= cp %>/goidichvu">
            <input type="hidden" name="action" value="edit">
            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label>Mã Gói</label>
                        <input type="text" id="eMaGoi" name="maGoi" class="form-control" readonly style="opacity:.6;cursor:not-allowed;">
                    </div>
                    <div class="form-group full-width">
                        <label>Tên Gói *</label>
                        <input type="text" id="eTenGoi" name="tengoi" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Loại Gói *</label>
                        <select id="eLoaiGoi" name="loaigoi" class="form-control" required>
                            <option value="THEOGIO">Theo Giờ</option>
                            <option value="THEONGAY">Theo Ngày</option>
                            <option value="THEOTUAN">Theo Tuần</option>
                            <option value="THEOTHANG">Theo Tháng</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Số Giờ *</label>
                        <input type="number" id="eSoGio" name="sogio" class="form-control" min="0.5" step="0.5" required>
                    </div>
                    <div class="form-group">
                        <label>Số Ngày Hiệu Lực *</label>
                        <input type="number" id="eSoNgay" name="songayhieuluc" class="form-control" min="1" required>
                    </div>
                    <div class="form-group">
                        <label>Giá Gốc (đ) *</label>
                        <input type="number" id="eGiaGoc" name="giagoc" class="form-control" min="1" required oninput="calcDiscount('e')">
                    </div>
                    <div class="form-group">
                        <label style="display:flex;justify-content:space-between;">
                            Giá Gói (đ) * <span id="eDiscount" style="color:var(--success);font-size:12px;"></span>
                        </label>
                        <input type="number" id="eGiaGoi" name="giagoi" class="form-control" min="1" required oninput="calcDiscount('e')">
                    </div>
                    <div class="form-group">
                        <label>Khu Áp Dụng</label>
                        <input type="text" id="eKhu" name="apdungchokhu" class="form-control" placeholder="Để trống = tất cả khu">
                    </div>
                    <div class="form-group">
                        <label>Trạng Thái</label>
                        <select id="eTrangThai" name="trangthai" class="form-control">
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
function openAddModal() { document.getElementById('modalAdd').classList.add('active'); }
function openEditModal(maGoi, tenGoi, loaiGoi, soGio, soNgay, giaGoc, giaGoi, khu, trangThai) {
    document.getElementById('eMaGoi').value    = maGoi;
    document.getElementById('eTenGoi').value   = tenGoi;
    document.getElementById('eLoaiGoi').value  = loaiGoi;
    document.getElementById('eSoGio').value    = soGio;
    document.getElementById('eSoNgay').value   = soNgay;
    document.getElementById('eGiaGoc').value   = giaGoc;
    document.getElementById('eGiaGoi').value   = giaGoi;
    document.getElementById('eKhu').value      = khu;
    document.getElementById('eTrangThai').value = trangThai;
    calcDiscount('e');
    document.getElementById('modalEdit').classList.add('active');
}
function closeModal(id) { document.getElementById(id).classList.remove('active'); }
document.querySelectorAll('.modal-overlay').forEach(m => {
    m.addEventListener('click', e => { if (e.target === m) closeModal(m.id); });
});
function calcDiscount(prefix) {
    const goc  = parseFloat(document.getElementById(prefix + 'GiaGoc')?.value) || 0;
    const goi  = parseFloat(document.getElementById(prefix + 'GiaGoi' )?.value) || 0;
    const span = document.getElementById(prefix + 'Discount');
    if (span && goc > 0 && goi > 0) {
        const pct = ((1 - goi/goc) * 100).toFixed(1);
        span.textContent = pct > 0 ? `Giảm ${pct}%` : '';
    }
}
<% if ("edit".equals(openModal) && editGDV != null) { %>
openEditModal('<%= editGDV.getMagoi() %>','<%= esc(editGDV.getTengoi()) %>','<%= editGDV.getLoaigoi() %>',
    '<%= editGDV.getSogio() %>','<%= editGDV.getSongayhieuluc() %>',
    '<%= editGDV.getGiagoc() %>','<%= editGDV.getGiagoi() %>',
    '<%= editGDV.getApdungchokhu() != null ? esc(editGDV.getApdungchokhu()) : "" %>',
    '<%= editGDV.getTrangthai() %>');
<% } %>
</script>
<%! private String esc(String s){ if(s==null)return""; return s.replace("\\","\\\\").replace("'","\\'").replace("\"","\\\""); } %>
</body>
</html>
