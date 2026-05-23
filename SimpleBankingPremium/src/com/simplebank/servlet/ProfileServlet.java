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

@WebServlet("/customer/profile")
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = (Integer) request.getSession(false).getAttribute("userId");
        try {
            request.setAttribute("user", userDAO.getUserById(userId));
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }
        request.getRequestDispatcher("/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = (Integer) request.getSession(false).getAttribute("userId");
        String action = request.getParameter("action");
        try {
            if ("password".equals(action)) {
                changePassword(request, userId);
            } else {
                updateProfile(request, userId);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }
        doGet(request, response);
    }

    private void updateProfile(HttpServletRequest request, int userId) throws Exception {
        String fullName = request.getParameter("fullName");
        if (ValidationUtil.isEmpty(fullName)) throw new Exception("Full name is required");
        User user = new User();
        user.setUserId(userId);
        user.setFullName(fullName.trim());
        user.setPhone(request.getParameter("phone"));
        user.setAddress(buildAddress(request));
        userDAO.updateProfile(user);
        HttpSession session = request.getSession(false);
        session.setAttribute("fullName", fullName.trim());
        request.setAttribute("success", "Profile updated successfully.");
    }

    private String buildAddress(HttpServletRequest request) {
        String state = request.getParameter("state");
        String city = request.getParameter("city");
        String addressLine = request.getParameter("addressLine");
        String existingAddress = request.getParameter("address");
        if ((state == null || state.trim().isEmpty()) && (city == null || city.trim().isEmpty())) {
            return existingAddress;
        }
        StringBuilder builder = new StringBuilder();
        if (addressLine != null && !addressLine.trim().isEmpty()) builder.append(addressLine.trim());
        if (city != null && !city.trim().isEmpty()) {
            if (builder.length() > 0) builder.append(", ");
            builder.append(city.trim());
        }
        if (state != null && !state.trim().isEmpty()) {
            if (builder.length() > 0) builder.append(", ");
            builder.append(state.trim());
        }
        return builder.toString();
    }

    private void changePassword(HttpServletRequest request, int userId) throws Exception {
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        if (ValidationUtil.isEmpty(oldPassword) || ValidationUtil.isEmpty(newPassword)) {
            throw new Exception("Old and new password are required");
        }
        User user = userDAO.getUserById(userId);
        if (user == null || !PasswordUtil.hashPassword(oldPassword).equals(user.getPassword())) {
            throw new Exception("Old password is incorrect");
        }
        userDAO.changePassword(userId, PasswordUtil.hashPassword(newPassword));
        request.setAttribute("success", "Password changed successfully.");
    }
}
