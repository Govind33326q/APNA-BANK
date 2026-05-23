<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../includes/design.jspf" %>
<%
    Integer totalCustomers = (Integer) request.getAttribute("totalCustomers");
    Integer totalAccounts = (Integer) request.getAttribute("totalAccounts");
    Integer activeAccounts = (Integer) request.getAttribute("activeAccounts");
    Integer pendingAccounts = (Integer) request.getAttribute("pendingAccounts");
    Integer totalTransactions = (Integer) request.getAttribute("totalTransactions");
    Integer totalStaff = (Integer) request.getAttribute("totalStaff");
%>
<!DOCTYPE html>
<html>
<head><title>Staff Dashboard</title><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body>
<div class="layout">
    <%@ include file="sidebar.jspf" %>
    <main class="content">
        <section class="hero-grid">
            <div class="hero-card">
                <h1>Staff Operations Center</h1>
                <p>Approve accounts, manage customer records, monitor transactions and handle daily banking operations.</p>
                <a class="btn secondary" href="accounts">Open Account Control</a>
            </div>
            <div class="bank-card-3d">
                <div class="chip"></div>
                <div class="card-number">STAFF CORE</div>
                <div class="card-meta"><span>Secure</span><span>Operations</span></div>
            </div>
        </section>
        <section class="cards">
            <a class="stat-card clickable-card" href="customers"><span>Customers</span><h3><%= totalCustomers == null ? 0 : totalCustomers %></h3><small>Open directory</small></a>
            <a class="stat-card clickable-card" href="accounts"><span>Accounts</span><h3><%= totalAccounts == null ? 0 : totalAccounts %></h3><small>Manage accounts</small></a>
            <a class="stat-card clickable-card" href="accounts?status=ACTIVE"><span>Active</span><h3><%= activeAccounts == null ? 0 : activeAccounts %></h3><small>View active</small></a>
            <a class="stat-card clickable-card" href="accounts?status=PENDING"><span>Pending</span><h3><%= pendingAccounts == null ? 0 : pendingAccounts %></h3><small>Approve now</small></a>
            <a class="stat-card clickable-card" href="transactions"><span>Transactions</span><h3><%= totalTransactions == null ? 0 : totalTransactions %></h3><small>Audit trail</small></a>
            <% if ("ADMIN".equals(session.getAttribute("role"))) { %>
                <a class="stat-card clickable-card" href="staff"><span>Staff Members</span><h3><%= totalStaff == null ? 0 : totalStaff %></h3><small>Manage team</small></a>
            <% } %>
        </section>
    </main>
</div>
</body>
</html>
