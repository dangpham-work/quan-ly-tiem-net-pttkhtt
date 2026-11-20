package servlet;

import bus.GoiDichVuBUS;
import entity.GoiDichVu;
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

public class GoiDichVuServlet extends HttpServlet {

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
        GoiDichVuBUS bus = new GoiDichVuBUS();

        try {
            List<GoiDichVu> list = bus.getAll();
            String keyword = request.getParameter("keyword");
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = keyword.trim().toLowerCase();
                list = list.stream()
                    .filter(g -> (g.getTengoi() != null && g.getTengoi().toLowerCase().contains(kw))
                            || (g.getMagoi() != null && g.getMagoi().toLowerCase().contains(kw))
                            || (g.getLoaigoi() != null && g.getLoaigoi().toLowerCase().contains(kw)))
                    .collect(Collectors.toList());
            }

            if ("edit".equals(action)) {
                String maGoi = request.getParameter("maGoi");
                GoiDichVu gdv = bus.getAll().stream()
                        .filter(g -> g.getMagoi().equals(maGoi)).findFirst().orElse(null);
                request.setAttribute("editGDV", gdv);
                request.setAttribute("openModal", "edit");
            }

            request.setAttribute("list", list);
            request.setAttribute("keyword", keyword);
            request.setAttribute("currentPage", "goidichvu");
            request.getRequestDispatcher("/goidichvu/index.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("currentPage", "goidichvu");
            request.getRequestDispatcher("/goidichvu/index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        setupSession(request);
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        GoiDichVuBUS bus = new GoiDichVuBUS();

        try {
            switch (action != null ? action : "") {
                case "add": {
                    GoiDichVu g = buildFromRequest(request);
                    bus.themGoiDichVu(g);
                    request.getSession().setAttribute("successMsg", "Thêm gói dịch vụ thành công!");
                    response.sendRedirect(request.getContextPath() + "/goidichvu");
                    break;
                }
                case "edit": {
                    GoiDichVu g = buildFromRequest(request);
                    g.setMagoi(request.getParameter("maGoi"));
                    bus.suaGoiDichVu(g);
                    request.getSession().setAttribute("successMsg", "Cập nhật gói dịch vụ thành công!");
                    response.sendRedirect(request.getContextPath() + "/goidichvu");
                    break;
                }
                case "delete": {
                    bus.xoaGoiDichVu(request.getParameter("maGoi"));
                    request.getSession().setAttribute("successMsg", "Ngưng gói dịch vụ thành công!");
                    response.sendRedirect(request.getContextPath() + "/goidichvu");
                    break;
                }
                case "restore": {
                    bus.khoiPhucGDV(request.getParameter("maGoi"));
                    request.getSession().setAttribute("successMsg", "Khôi phục gói dịch vụ thành công!");
                    response.sendRedirect(request.getContextPath() + "/goidichvu");
                    break;
                }
                default:
                    response.sendRedirect(request.getContextPath() + "/goidichvu");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/goidichvu");
        }
    }

    private GoiDichVu buildFromRequest(HttpServletRequest req) {
        GoiDichVu g = new GoiDichVu();
        g.setTengoi(req.getParameter("tengoi"));
        g.setLoaigoi(req.getParameter("loaigoi"));
        String sogio = req.getParameter("sogio");
        g.setSogio(sogio != null && !sogio.isEmpty() ? Double.parseDouble(sogio) : 0);
        String songay = req.getParameter("songayhieuluc");
        g.setSongayhieuluc(songay != null && !songay.isEmpty() ? Integer.parseInt(songay) : 0);
        String giagoc = req.getParameter("giagoc");
        g.setGiagoc(giagoc != null && !giagoc.isEmpty() ? Double.parseDouble(giagoc) : 0);
        String giagoi = req.getParameter("giagoi");
        g.setGiagoi(giagoi != null && !giagoi.isEmpty() ? Double.parseDouble(giagoi) : 0);
        g.setApdungchokhu(req.getParameter("apdungchokhu"));
        String tt = req.getParameter("trangthai");
        g.setTrangthai(tt != null ? tt : "HOATDONG");
        return g;
    }
}
