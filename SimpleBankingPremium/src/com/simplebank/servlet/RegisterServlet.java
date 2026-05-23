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

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = buildAddress(request);
        String accountType = request.getParameter("accountType");

        if (ValidationUtil.isEmpty(fullName) || !ValidationUtil.isValidEmail(email) || ValidationUtil.isEmpty(password)) {
            request.setAttribute("error", "Enter valid name, email and password.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        accountType = "CURRENT".equalsIgnoreCase(accountType) ? "CURRENT" : "SAVINGS";

        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setPhone(phone);
        user.setAddress(address);

        try {
            userDAO.registerCustomer(user, accountType);
            response.sendRedirect(request.getContextPath() + "/login.jsp?success=Registration_submitted_wait_for_admin_approval");
        } catch (Exception e) {
            request.setAttribute("error", "Registration failed. Email may already exist.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private String buildAddress(HttpServletRequest request) {
        String state = request.getParameter("state");
        String city = request.getParameter("city");
        String addressLine = request.getParameter("addressLine");
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
}
