package com.simplebank.servlet;

import com.simplebank.dao.TransactionDAO;
import com.simplebank.model.Transaction;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/customer/statement")
public class StatementServlet extends HttpServlet {
    private final TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = (Integer) request.getSession(false).getAttribute("userId");
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=bank_statement.csv");
        try (PrintWriter out = response.getWriter()) {
            out.println("ID,Type,Amount,From,To,Description,Date");
            List<Transaction> transactions = transactionDAO.getTransactionsByUserId(userId);
            for (Transaction t : transactions) {
                out.println(t.getTransactionId() + "," + t.getTransactionType() + "," + t.getAmount() + "," +
                        clean(t.getFromAccountNumber()) + "," + clean(t.getToAccountNumber()) + "," +
                        clean(t.getDescription()) + "," + clean(String.valueOf(t.getCreatedAt())));
            }
        } catch (Exception e) {
            response.getWriter().println("Error," + e.getMessage());
        }
    }

    private String clean(String value) {
        return value == null ? "" : value.replace(",", " ").replace("\n", " ");
    }
}
