package servlet;

import bus.DichVuBUS;
import entity.DichVu;
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

public class DichVuServlet extends HttpServlet {

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
        DichVuBUS bus = new DichVuBUS();

        try {
            List<DichVu> list = bus.getAll();
            String keyword = request.getParameter("keyword");
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = keyword.trim().toLowerCase();
                list = list.stream()
                    .filter(d -> (d.getTendv() != null && d.getTendv().toLowerCase().contains(kw))
                            || (d.getMadv() != null && d.getMadv().toLowerCase().contains(kw))
                            || (d.getLoaidv() != null && d.getLoaidv().toLowerCase().contains(kw)))
                    .collect(Collectors.toList());
            }

            if ("edit".equals(action)) {
                String maDV = request.getParameter("maDV");
                DichVu dv = bus.getAll().stream()
                        .filter(d -> d.getMadv().equals(maDV)).findFirst().orElse(null);
                request.setAttribute("editDV", dv);
                request.setAttribute("openModal", "edit");
            }

            request.setAttribute("list", list);
            request.setAttribute("keyword", keyword);
            request.setAttribute("currentPage", "dichvu");
            request.getRequestDispatcher("/dichvu/index.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("currentPage", "dichvu");
            request.getRequestDispatcher("/dichvu/index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkLogin(request, response)) return;
        setupSession(request);
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        DichVuBUS bus = new DichVuBUS();

        try {
            switch (action != null ? action : "") {
                case "add": {
                    DichVu dv = new DichVu();
                    dv.setTendv(request.getParameter("tendv"));
                    dv.setLoaidv(request.getParameter("loaidv"));
                    String gia = request.getParameter("dongia");
                    dv.setDongia(gia != null && !gia.isEmpty() ? Double.parseDouble(gia) : 0);
                    dv.setDonvitinh(request.getParameter("donvitinh"));
                    String sl = request.getParameter("soluongton");
                    dv.setSoluongton(sl != null && !sl.isEmpty() ? Integer.parseInt(sl) : 0);
                    dv.setTrangthai("HOATDONG");
                    bus.themDichVu(dv);
                    request.getSession().setAttribute("successMsg", "Thêm dịch vụ thành công!");
                    response.sendRedirect(request.getContextPath() + "/dichvu");
                    break;
                }
                case "edit": {
                    DichVu dv = new DichVu();
                    dv.setMadv(request.getParameter("maDV"));
                    dv.setTendv(request.getParameter("tendv"));
                    dv.setLoaidv(request.getParameter("loaidv"));
                    String gia = request.getParameter("dongia");
                    dv.setDongia(gia != null && !gia.isEmpty() ? Double.parseDouble(gia) : 0);
                    dv.setDonvitinh(request.getParameter("donvitinh"));
                    String sl = request.getParameter("soluongton");
                    dv.setSoluongton(sl != null && !sl.isEmpty() ? Integer.parseInt(sl) : 0);
                    dv.setTrangthai(request.getParameter("trangthai"));
                    bus.suaDichVu(dv);
                    request.getSession().setAttribute("successMsg", "Cập nhật dịch vụ thành công!");
                    response.sendRedirect(request.getContextPath() + "/dichvu");
                    break;
                }
                case "delete": {
                    bus.xoaDichVu(request.getParameter("maDV"));
                    request.getSession().setAttribute("successMsg", "Ngưng bán dịch vụ thành công!");
                    response.sendRedirect(request.getContextPath() + "/dichvu");
                    break;
                }
                case "restore": {
                    bus.khoiPhucLaiDichVu(request.getParameter("maDV"));
                    request.getSession().setAttribute("successMsg", "Khôi phục dịch vụ thành công!");
                    response.sendRedirect(request.getContextPath() + "/dichvu");
                    break;
                }
                default:
                    response.sendRedirect(request.getContextPath() + "/dichvu");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/dichvu");
        }
    }
}
