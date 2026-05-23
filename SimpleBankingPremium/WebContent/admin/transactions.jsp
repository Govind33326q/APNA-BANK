<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.simplebank.model.Transaction,java.util.List" %>
<%@ include file="../includes/design.jspf" %>
<%
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Transactions</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jspf" %>
    <main class="content">
        <div class="topbar compact-topbar">
            <div>
                <h1>Transaction Monitor</h1>
                <p>Audit deposits, withdrawals, transfers and safely revert incorrect transactions.</p>
            </div>
        </div>

        <% if (success != null) { %>
            <div class="alert success"><%= success.replace('_', ' ') %></div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert error"><%= error.replace('_', ' ') %></div>
        <% } %>

        <section class="panel compact-panel">
            <table class="compact-transactions-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Type</th>
                    <th>Amount</th>
                    <th>From</th>
                    <th>To</th>
                    <th>Description</th>
                    <th>Date</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% if (transactions != null && !transactions.isEmpty()) {
                    for (Transaction t : transactions) { %>
                    <tr>
                        <td>#<%= t.getTransactionId() %></td>
                        <td><%= t.getCustomerName() == null ? "Bank" : t.getCustomerName() %></td>
                        <td><span class="badge <%= t.isReverted() ? "REJECTED" : "" %>"><%= t.getTransactionType() %></span></td>
                        <td>Rs. <%= t.getAmount() %></td>
                        <td><%= t.getFromAccountNumber() == null ? "Bank" : t.getFromAccountNumber() %></td>
                        <td><%= t.getToAccountNumber() == null ? "Cash" : t.getToAccountNumber() %></td>
                        <td><%= t.getDescription() %></td>
                        <td><%= t.getCreatedAt() %></td>
                        <td>
                            <% if (t.isReverted()) { %>
                                <span class="badge REJECTED">Reverted</span>
                            <% } else if (t.getReversedTransactionId() != null) { %>
                                <span class="badge FROZEN">Audit Entry</span>
                            <% } else { %>
                                <form method="post" action="transactions" class="inline-form">
                                    <input type="hidden" name="transactionId" value="<%= t.getTransactionId() %>">
                                    <button name="action" value="reverse" class="mini danger-btn" onclick="return confirmAction('Revert transaction #<%= t.getTransactionId() %>? This will adjust account balances.')">Revert</button>
                                </form>
                            <% } %>
                        </td>
                    </tr>
                <% }} else { %>
                    <tr><td colspan="9">No transactions found.</td></tr>
                <% } %>
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>
