package com.simplebank.servlet;

import com.simplebank.dao.TransactionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/transactions")
public class AdminTransactionsServlet extends HttpServlet {
    private final TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("transactions", transactionDAO.getAllTransactions());
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }
        request.getRequestDispatcher("/admin/transactions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("reverse".equals(action)) {
                int transactionId = Integer.parseInt(request.getParameter("transactionId"));
                transactionDAO.reverseTransaction(transactionId);
                response.sendRedirect(request.getContextPath() + "/admin/transactions?success=Transaction_reverted_successfully");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin/transactions?error=Invalid_action");
        } catch (Exception e) {
            String message = e.getMessage() == null ? "Unable_to_revert_transaction" : e.getMessage().replace(' ', '_');
            response.sendRedirect(request.getContextPath() + "/admin/transactions?error=" + message);
        }
    }
}
