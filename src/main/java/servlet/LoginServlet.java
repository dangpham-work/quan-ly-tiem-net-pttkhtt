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

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã login thì redirect
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentNhanVien") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            // Reset SessionManager trước khi gọi BUS
            SessionManager.clearSession();

            NhanVienBUS nhanVienBUS = new NhanVienBUS();
            NhanVien nv = nhanVienBUS.dangNhap(username, password);

            // Lưu vào HttpSession
            HttpSession session = request.getSession(true);
            session.setAttribute("currentNhanVien", nv);
            session.setAttribute("loaiTaiKhoan", nv.getChucvu());
            session.setAttribute("userName", nv.getHo() + " " + nv.getTen());

            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
