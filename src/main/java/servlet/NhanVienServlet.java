package servlet;

import bus.NhanVienBUS;
import entity.NhanVien;
import utils.SessionManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class NhanVienServlet extends HttpServlet {

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
        NhanVienBUS bus = new NhanVienBUS();

        try {
            String keyword = request.getParameter("keyword");
            List<NhanVien> listDang;
            List<NhanVien> listNghi;

            if (keyword != null && !keyword.trim().isEmpty()) {
                listDang = bus.timKiemNhanVien(keyword.trim());
                listNghi = new ArrayList<>();
            } else {
                listDang = bus.getAllNhanVienDangLamViec();
                listNghi = bus.getAllNhanVienDaNghiViec();
            }

            if ("edit".equals(action)) {
                String maNV = request.getParameter("maNV");
                NhanVien nv = bus.getNhanVienById(maNV);
                request.setAttribute("editNV", nv);
                request.setAttribute("openModal", "edit");
            }

            request.setAttribute("listDang", listDang);
            request.setAttribute("listNghi", listNghi);
            request.setAttribute("keyword", keyword);
            request.setAttribute("currentPage", "nhanvien");
            request.getRequestDispatcher("/nhanvien/index.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            try {
                request.setAttribute("listDang", bus.getAllNhanVienDangLamViec());
                request.setAttribute("listNghi", bus.getAllNhanVienDaNghiViec());
            } catch (Exception ignored) {}
            request.setAttribute("currentPage", "nhanvien");
            request.getRequestDispatcher("/nhanvien/index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        setupSession(request);
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        NhanVienBUS bus = new NhanVienBUS();

        try {
            switch (action != null ? action : "") {
                case "add": {
                    NhanVien nv = new NhanVien();
                    nv.setHo(request.getParameter("ho"));
                    nv.setTen(request.getParameter("ten"));
                    nv.setChucvu(request.getParameter("chucvu"));
                    nv.setTendangnhap(request.getParameter("tendangnhap"));
                    nv.setMatkhau(request.getParameter("matkhau"));
                    nv.setTrangthai("DANGLAMVIEC");
                    bus.themNhanVien(nv);
                    request.getSession().setAttribute("successMsg", "Thêm nhân viên thành công!");
                    response.sendRedirect(request.getContextPath() + "/nhanvien");
                    break;
                }
                case "edit": {
                    NhanVien nv = new NhanVien();
                    nv.setManv(request.getParameter("maNV"));
                    nv.setHo(request.getParameter("ho"));
                    nv.setTen(request.getParameter("ten"));
                    nv.setChucvu(request.getParameter("chucvu"));
                    nv.setTendangnhap(request.getParameter("tendangnhap"));
                    nv.setMatkhau(request.getParameter("matkhau"));
                    nv.setTrangthai(request.getParameter("trangthai"));
                    bus.suaNhanVien(nv);
                    request.getSession().setAttribute("successMsg", "Cập nhật nhân viên thành công!");
                    response.sendRedirect(request.getContextPath() + "/nhanvien");
                    break;
                }
                case "delete": {
                    bus.xoaNhanVien(request.getParameter("maNV"));
                    request.getSession().setAttribute("successMsg", "Xóa nhân viên thành công!");
                    response.sendRedirect(request.getContextPath() + "/nhanvien");
                    break;
                }
                case "restore": {
                    bus.khoiPhucNhanVien(request.getParameter("maNV"));
                    request.getSession().setAttribute("successMsg", "Khôi phục nhân viên thành công!");
                    response.sendRedirect(request.getContextPath() + "/nhanvien");
                    break;
                }
                default:
                    response.sendRedirect(request.getContextPath() + "/nhanvien");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/nhanvien");
        }
    }
}
