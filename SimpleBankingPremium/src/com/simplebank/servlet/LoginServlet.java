package com.simplebank.servlet;

import com.simplebank.dao.UserDAO;
import com.simplebank.model.User;
import com.simplebank.util.PasswordUtil;
import com.simplebank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String loginType = request.getParameter("loginType");
        if (loginType == null || loginType.trim().isEmpty()) {
            loginType = "CUSTOMER";
        }

        if (ValidationUtil.isEmpty(email) || ValidationUtil.isEmpty(password)) {
            response.sendRedirect(request.getContextPath() + "/error.jsp?code=missing-login&type=" + loginType);
            return;
        }

        try {
            User user = userDAO.login(email.trim().toLowerCase(), PasswordUtil.hashPassword(password));
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/error.jsp?code=invalid-login&type=" + loginType);
                return;
            }

            boolean staffLogin = "STAFF".equalsIgnoreCase(loginType);
            boolean customerLogin = "CUSTOMER".equalsIgnoreCase(loginType);

            if (staffLogin && !("ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole()))) {
                response.sendRedirect(request.getContextPath() + "/error.jsp?code=wrong-portal&type=staff");
                return;
            }

            if (customerLogin && !"CUSTOMER".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/error.jsp?code=wrong-portal&type=customer");
                return;
            }

            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) oldSession.invalidate();

            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(20 * 60);

            if ("ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/dashboard");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/error.jsp?code=login-system&type=" + loginType);
        }
    }
}
