<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.simplebank.model.Account,com.simplebank.model.Transaction,java.util.List" %>
<%@ include file="../includes/design.jspf" %>
<%
    Account account = (Account) request.getAttribute("account");
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
    String fullName = (String) session.getAttribute("fullName");
%>
<!DOCTYPE html>
<html>
<head><title>Customer Dashboard</title><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body>
<div class="layout">
    <%@ include file="sidebar.jspf" %>
    <main class="content">
        <section class="hero-grid">
            <div class="hero-card">
                <h1>Hello, <%= fullName == null ? "Customer" : fullName %></h1>
                <p>View balance, make transfers, download statement and manage your profile.</p>
                <a class="btn secondary" href="transfer">Transfer Money</a>
            </div>
            <div class="bank-card-3d">
                <div class="chip"></div>
                <div class="card-number"><%= account == null ? "PENDING" : account.getAccountNumber() %></div>
                <div class="card-meta"><span><%= account == null ? "ACCOUNT" : account.getAccountType() %></span><span><%= account == null ? "STATUS" : account.getStatus() %></span></div>
            </div>
        </section>
        <% if (account != null && !"ACTIVE".equals(account.getStatus())) { %>
            <div class="alert warning">Your account status is <%= account.getStatus() %>. Transactions work after admin approval.</div>
        <% } %>
        <section class="cards">
            <div class="stat-card"><span>Account Number</span><h3><%= account == null ? "-" : account.getAccountNumber() %></h3></div>
            <div class="stat-card"><span>Balance</span><h3>Rs. <%= account == null ? "0.00" : account.getBalance() %></h3></div>
            <div class="stat-card"><span>Type</span><h3><%= account == null ? "-" : account.getAccountType() %></h3></div>
            <div class="stat-card"><span>Status</span><h3><%= account == null ? "-" : account.getStatus() %></h3></div>
        </section>
        <section class="panel">
            <div class="topbar" style="box-shadow:none;margin-bottom:10px;"><div><h2>Recent Transactions</h2><p>Latest banking activity.</p></div><a class="btn secondary" href="transactions">View All</a></div>
            <table>
                <thead><tr><th>ID</th><th>Type</th><th>Amount</th><th>From</th><th>To</th><th>Date</th></tr></thead>
                <tbody>
                <% if (transactions != null && !transactions.isEmpty()) { int count = 0; for (Transaction t : transactions) { if (count++ == 5) break; %>
                    <tr><td>#<%= t.getTransactionId() %></td><td><span class="badge"><%= t.getTransactionType() %></span></td><td>Rs. <%= t.getAmount() %></td><td><%= t.getFromAccountNumber() == null ? "Bank" : t.getFromAccountNumber() %></td><td><%= t.getToAccountNumber() == null ? "Cash" : t.getToAccountNumber() %></td><td><%= t.getCreatedAt() %></td></tr>
                <% }} else { %><tr><td colspan="6">No transactions yet.</td></tr><% } %>
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>
