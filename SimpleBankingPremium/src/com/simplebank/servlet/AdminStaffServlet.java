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

@WebServlet("/admin/staff")
public class AdminStaffServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath()
                    + "/error.jsp?code=admin-only&type=staff");
            return;
        }

        try {
            request.setAttribute("staffMembers", userDAO.getStaffMembers());
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        request.getRequestDispatcher("/admin/staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath()
                    + "/error.jsp?code=admin-only&type=staff");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                createStaff(request);

                response.sendRedirect(request.getContextPath()
                        + "/admin/staff?success=Staff_member_created");
                return;
            }

            if ("remove".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));

                userDAO.removeStaff(userId);

                response.sendRedirect(request.getContextPath()
                        + "/admin/staff?success=Staff_member_removed");
                return;
            }

            response.sendRedirect(request.getContextPath()
                    + "/admin/staff?error=Invalid_action");

        } catch (Exception e) {
            String message = e.getMessage() == null
                    ? "Unable_to_update_staff"
                    : e.getMessage().replace(' ', '_');

            response.sendRedirect(request.getContextPath()
                    + "/admin/staff?error=" + message);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        String role = session == null ? null : (String) session.getAttribute("role");

        return "ADMIN".equals(role);
    }

    private void createStaff(HttpServletRequest request) throws Exception {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        if (ValidationUtil.isEmpty(fullName)
                || ValidationUtil.isEmpty(email)
                || ValidationUtil.isEmpty(password)) {
            throw new Exception("Name email and password are required");
        }

        if (password.length() < 6) {
            throw new Exception("Password must be at least 6 characters");
        }

        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setRole("STAFF");
        user.setPhone(phone);
        user.setAddress("Staff Member");

        userDAO.createStaff(user);
    }
}
