package com.simplebank.servlet;

import com.simplebank.dao.AccountDAO;
import com.simplebank.dao.TransactionDAO;
import com.simplebank.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/customer/transfer")
public class TransferServlet extends HttpServlet {
    private final AccountDAO accountDAO = new AccountDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        loadAccount(request);
        request.getRequestDispatcher("/customer/transfer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = (Integer) request.getSession(false).getAttribute("userId");
        String receiverAccountNumber = request.getParameter("receiverAccountNumber");
        BigDecimal amount = ValidationUtil.parseAmount(request.getParameter("amount"));

        if (!ValidationUtil.isAccountNumber(receiverAccountNumber) || amount == null) {
            request.setAttribute("error", "Enter valid receiver account number and amount.");
        } else {
            try {
                transactionDAO.transfer(userId, receiverAccountNumber, amount);
                request.setAttribute("success", "Transfer completed successfully.");
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
            }
        }
        doGet(request, response);
    }

    private void loadAccount(HttpServletRequest request) {
        try {
            int userId = (Integer) request.getSession(false).getAttribute("userId");
            request.setAttribute("account", accountDAO.getAccountByUserId(userId));
        } catch (Exception ignored) { }
    }
}
