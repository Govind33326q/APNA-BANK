package com.simplebank.servlet;

import com.simplebank.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/customers")
public class AdminCustomersServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");

            request.setAttribute("customers", userDAO.getCustomers(keyword));
            request.setAttribute("keyword", keyword == null ? "" : keyword);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        request.getRequestDispatcher("/admin/customers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = session == null ? null : (String) session.getAttribute("role");

        if (!"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath()
                    + "/error.jsp?code=admin-only&type=staff");
            return;
        }

        String action = request.getParameter("action");
        String userIdText = request.getParameter("userId");

        try {
            int userId = Integer.parseInt(userIdText);

            if ("promoteStaff".equals(action)) {
                boolean updated = userDAO.promoteCustomerToStaff(userId);

                response.sendRedirect(request.getContextPath()
                        + "/admin/customers?success="
                        + (updated ? "Customer_promoted_to_staff" : "Customer_not_found"));
                return;
            }

            if ("removeCustomer".equals(action)) {
                boolean updated = userDAO.removeCustomer(userId);

                response.sendRedirect(request.getContextPath()
                        + "/admin/customers?success="
                        + (updated ? "Customer_removed_from_customer_section" : "Customer_not_found"));
                return;
            }

            response.sendRedirect(request.getContextPath()
                    + "/admin/customers?error=Invalid_action");

        } catch (Exception e) {
            String message = e.getMessage() == null
                    ? "Action_failed"
                    : e.getMessage().replace(' ', '_');

            response.sendRedirect(request.getContextPath()
                    + "/admin/customers?error=" + message);
        }
    }
}
