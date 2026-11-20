package servlet;

import bus.KhuMayBUS;
import bus.MayTinhBUS;
import entity.KhuMay;
import entity.MayTinh;
import entity.NhanVien;
import utils.SessionManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

public class MayTinhServlet extends HttpServlet {

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
        MayTinhBUS bus = new MayTinhBUS();
        KhuMayBUS khuBus = new KhuMayBUS();

        try {
            List<MayTinh> list = bus.getAllMayTinh();
            String keyword = request.getParameter("keyword");
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = keyword.trim().toLowerCase();
                list = list.stream()
                    .filter(m -> (m.getTenmay() != null && m.getTenmay().toLowerCase().contains(kw))
                            || (m.getMamay() != null && m.getMamay().toLowerCase().contains(kw))
                            || (m.getMakhu() != null && m.getMakhu().toLowerCase().contains(kw))
                            || (m.getTrangthai() != null && m.getTrangthai().toLowerCase().contains(kw)))
                    .collect(Collectors.toList());
            }

            List<KhuMay> listKhu = khuBus.getAllKhuMay();

            if ("edit".equals(action)) {
                String maMay = request.getParameter("maMay");
                MayTinh may = bus.getAllMayTinh().stream()
                        .filter(m -> m.getMamay().equals(maMay))
                        .findFirst().orElse(null);
                request.setAttribute("editMay", may);
                request.setAttribute("openModal", "edit");
            }

            request.setAttribute("list", list);
            request.setAttribute("listKhu", listKhu);
            request.setAttribute("keyword", keyword);
            request.setAttribute("currentPage", "maytinh");
            request.getRequestDispatcher("/maytinh/index.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("currentPage", "maytinh");
            request.getRequestDispatcher("/maytinh/index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        setupSession(request);
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        MayTinhBUS bus = new MayTinhBUS();

        try {
            switch (action != null ? action : "") {
                case "add": {
                    MayTinh may = new MayTinh();
                    may.setTenmay(request.getParameter("tenmay"));
                    may.setMakhu(request.getParameter("makhu"));
                    may.setCauhinh(request.getParameter("cauhinh"));
                    String gia = request.getParameter("giamoigio");
                    may.setGiamoigio(gia != null && !gia.isEmpty() ? Double.parseDouble(gia) : 0.0);
                    bus.themMayTinh(may);
                    request.getSession().setAttribute("successMsg", "Thêm máy tính thành công!");
                    response.sendRedirect(request.getContextPath() + "/maytinh");
                    break;
                }
                case "edit": {
                    MayTinh may = new MayTinh();
                    may.setMamay(request.getParameter("maMay"));
                    may.setTenmay(request.getParameter("tenmay"));
                    may.setMakhu(request.getParameter("makhu"));
                    may.setCauhinh(request.getParameter("cauhinh"));
                    String gia = request.getParameter("giamoigio");
                    may.setGiamoigio(gia != null && !gia.isEmpty() ? Double.parseDouble(gia) : 0.0);
                    bus.suaMayTinh(may);
                    request.getSession().setAttribute("successMsg", "Cập nhật máy tính thành công!");
                    response.sendRedirect(request.getContextPath() + "/maytinh");
                    break;
                }
                case "delete": {
                    bus.xoaMayTinh(request.getParameter("maMay"));
                    request.getSession().setAttribute("successMsg", "Ngưng hoạt động máy tính thành công!");
                    response.sendRedirect(request.getContextPath() + "/maytinh");
                    break;
                }
                case "baotri": {
                    bus.chuyenTrangThai(request.getParameter("maMay"), "BAOTRI");
                    request.getSession().setAttribute("successMsg", "Đã chuyển máy sang bảo trì!");
                    response.sendRedirect(request.getContextPath() + "/maytinh");
                    break;
                }
                case "hoantatbaotri": {
                    bus.chuyenTrangThai(request.getParameter("maMay"), "TRONG");
                    request.getSession().setAttribute("successMsg", "Đã hoàn tất bảo trì máy tính!");
                    response.sendRedirect(request.getContextPath() + "/maytinh");
                    break;
                }
                default:
                    response.sendRedirect(request.getContextPath() + "/maytinh");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/maytinh");
        }
    }
}
