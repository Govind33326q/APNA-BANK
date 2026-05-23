<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.simplebank.model.Transaction,java.util.List" %>
<%@ include file="../includes/design.jspf" %>
<% List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions"); %>
<!DOCTYPE html>
<html><head><title>Transactions</title><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body><div class="layout"><%@ include file="sidebar.jspf" %><main class="content">
<div class="topbar"><div><h1>Transaction History</h1><p>All deposits, withdrawals and transfers.</p></div><a class="btn secondary" href="statement">Download CSV</a></div>
<section class="panel"><table><thead><tr><th>ID</th><th>Type</th><th>Amount</th><th>From</th><th>To</th><th>Description</th><th>Date</th></tr></thead><tbody>
<% if (transactions != null && !transactions.isEmpty()) { for (Transaction t : transactions) { %>
<tr><td>#<%= t.getTransactionId() %></td><td><span class="badge"><%= t.getTransactionType() %></span></td><td>Rs. <%= t.getAmount() %></td><td><%= t.getFromAccountNumber() == null ? "Bank" : t.getFromAccountNumber() %></td><td><%= t.getToAccountNumber() == null ? "Cash" : t.getToAccountNumber() %></td><td><%= t.getDescription() %></td><td><%= t.getCreatedAt() %></td></tr>
<% }} else { %><tr><td colspan="7">No transactions found.</td></tr><% } %>
</tbody></table></section></main></div></body></html>
