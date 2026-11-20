package servlet;

import bus.KhachHangBUS;
import entity.KhachHang;
import entity.NhanVien;
import utils.SessionManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class KhachHangServlet extends HttpServlet {

    private void setupSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentNhanVien") != null) {
            NhanVien nv = (NhanVien) session.getAttribute("currentNhanVien");
            SessionManager.setCurrentUser(nv);
        }
    }

    private boolean checkLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentNhanVien") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        setupSession(request);
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "list";

        KhachHangBUS bus = new KhachHangBUS();

        try {
            switch (action) {
                case "list":
                default: {
                    String keyword = request.getParameter("keyword");
                    List<KhachHang> list;
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        list = bus.timKiemKhachHang(keyword.trim());
                    } else {
                        list = bus.getAllKhachHang();
                    }
                    request.setAttribute("list", list);
                    request.setAttribute("keyword", keyword);
                    request.setAttribute("currentPage", "khachhang");
                    request.getRequestDispatcher("/khachhang/index.jsp").forward(request, response);
                    break;
                }
                case "edit": {
                    String maKH = request.getParameter("maKH");
                    KhachHang kh = bus.getKhachHangById(maKH);
                    request.setAttribute("editKH", kh);
                    List<KhachHang> list = bus.getAllKhachHang();
                    request.setAttribute("list", list);
                    request.setAttribute("currentPage", "khachhang");
                    request.setAttribute("openModal", "edit");
                    request.getRequestDispatcher("/khachhang/index.jsp").forward(request, response);
                    break;
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            try {
                List<KhachHang> list = bus.getAllKhachHang();
                request.setAttribute("list", list);
            } catch (Exception ignored) {}
            request.setAttribute("currentPage", "khachhang");
            request.getRequestDispatcher("/khachhang/index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        setupSession(request);
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        KhachHangBUS bus = new KhachHangBUS();

        try {
            switch (action != null ? action : "") {
                case "add": {
                    KhachHang kh = new KhachHang();
                    kh.setHo(request.getParameter("ho"));
                    kh.setTen(request.getParameter("ten"));
                    kh.setSodienthoai(request.getParameter("sodienthoai"));
                    kh.setTendangnhap(request.getParameter("tendangnhap"));
                    kh.setMatkhau(request.getParameter("matkhau"));
                    String soduStr = request.getParameter("sodu");
                    kh.setSodu(soduStr != null && !soduStr.isEmpty() ? Double.parseDouble(soduStr) : 0);
                    bus.themKhachHang(kh);
                    request.getSession().setAttribute("successMsg", "Thêm khách hàng thành công!");
                    response.sendRedirect(request.getContextPath() + "/khachhang");
                    break;
                }
                case "edit": {
                    KhachHang kh = new KhachHang();
                    kh.setMakh(request.getParameter("maKH"));
                    kh.setHo(request.getParameter("ho"));
                    kh.setTen(request.getParameter("ten"));
                    kh.setSodienthoai(request.getParameter("sodienthoai"));
                    kh.setTendangnhap(request.getParameter("tendangnhap"));
                    kh.setMatkhau(request.getParameter("matkhau"));
                    String soduStr = request.getParameter("sodu");
                    kh.setSodu(soduStr != null && !soduStr.isEmpty() ? Double.parseDouble(soduStr) : 0);
                    kh.setTrangthai(request.getParameter("trangthai"));
                    bus.suaKhachHang(kh);
                    request.getSession().setAttribute("successMsg", "Cập nhật khách hàng thành công!");
                    response.sendRedirect(request.getContextPath() + "/khachhang");
                    break;
                }
                case "delete": {
                    String maKH = request.getParameter("maKH");
                    bus.xoaKhachHang(maKH);
                    request.getSession().setAttribute("successMsg", "Đã khóa khách hàng thành công!");
                    response.sendRedirect(request.getContextPath() + "/khachhang");
                    break;
                }
                case "restore": {
                    String maKH = request.getParameter("maKH");
                    bus.khoiPhucKhachHang(maKH);
                    request.getSession().setAttribute("successMsg", "Khôi phục khách hàng thành công!");
                    response.sendRedirect(request.getContextPath() + "/khachhang");
                    break;
                }
                default:
                    response.sendRedirect(request.getContextPath() + "/khachhang");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/khachhang");
        }
    }
}
