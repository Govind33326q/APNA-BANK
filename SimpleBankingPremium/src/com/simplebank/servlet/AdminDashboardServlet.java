package com.simplebank.servlet;

import com.simplebank.dao.AccountDAO;
import com.simplebank.dao.TransactionDAO;
import com.simplebank.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final AccountDAO accountDAO = new AccountDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("totalCustomers", userDAO.countCustomers());
            request.setAttribute("totalAccounts", accountDAO.countAllAccounts());
            request.setAttribute("activeAccounts", accountDAO.countByStatus("ACTIVE"));
            request.setAttribute("pendingAccounts", accountDAO.countByStatus("PENDING"));
            request.setAttribute("totalTransactions", transactionDAO.countTransactions());
            request.setAttribute("totalStaff", userDAO.countStaff());
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
