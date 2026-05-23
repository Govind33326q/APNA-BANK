package com.simplebank.servlet;

import com.simplebank.dao.AccountDAO;
import com.simplebank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/accounts")
public class AdminAccountsServlet extends HttpServlet {
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String status = request.getParameter("status");
        status = status == null || status.trim().isEmpty() ? "ALL" : status;
        try {
            request.setAttribute("accounts", accountDAO.getAllAccounts(status));
            request.setAttribute("status", status);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }
        request.getRequestDispatcher("/admin/accounts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int accountId = Integer.parseInt(request.getParameter("accountId"));
            String action = request.getParameter("action");

            if ("updateNumber".equals(action)) {
                String accountNumber = request.getParameter("accountNumber");
                if (!ValidationUtil.isAccountNumber(accountNumber)) {
                    throw new Exception("Account number must contain 6 to 18 digits only");
                }
                accountDAO.updateAccountNumber(accountId, accountNumber);
                response.sendRedirect(request.getContextPath() + "/admin/accounts?success=Account_number_updated");
                return;
            }

            if ("updateType".equals(action)) {
                String accountType = request.getParameter("accountType");
                if (!"SAVINGS".equalsIgnoreCase(accountType) && !"CURRENT".equalsIgnoreCase(accountType)) {
                    throw new Exception("Invalid account type");
                }
                accountDAO.updateAccountType(accountId, accountType);
                response.sendRedirect(request.getContextPath() + "/admin/accounts?success=Account_type_updated");
                return;
            }

            String status = "ACTIVE";
            if ("reject".equals(action)) status = "REJECTED";
            if ("freeze".equals(action)) status = "FROZEN";
            if ("close".equals(action)) status = "CLOSED";
            if ("activate".equals(action)) status = "ACTIVE";

            accountDAO.updateStatus(accountId, status);
            response.sendRedirect(request.getContextPath() + "/admin/accounts?success=Account_status_updated");
        } catch (Exception e) {
            String message = e.getMessage() == null ? "Unable_to_update_account" : e.getMessage().replace(' ', '_');
            response.sendRedirect(request.getContextPath() + "/admin/accounts?error=" + message);
        }
    }
}
