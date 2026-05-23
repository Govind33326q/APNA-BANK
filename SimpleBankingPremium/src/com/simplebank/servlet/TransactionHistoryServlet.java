package com.simplebank.servlet;

import com.simplebank.dao.TransactionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/customer/transactions")
public class TransactionHistoryServlet extends HttpServlet {
    private final TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = (Integer) request.getSession(false).getAttribute("userId");
        try {
            request.setAttribute("transactions", transactionDAO.getTransactionsByUserId(userId));
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }
        request.getRequestDispatcher("/customer/transactions.jsp").forward(request, response);
    }
}
