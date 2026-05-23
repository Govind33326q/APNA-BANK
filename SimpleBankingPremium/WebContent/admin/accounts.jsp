<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.simplebank.model.Account,java.util.List" %>
<%@ include file="../includes/design.jspf" %>
<%
    List<Account> accounts = (List<Account>) request.getAttribute("accounts");
    String status = (String) request.getAttribute("status");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Accounts</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jspf" %>
    <main class="content">
        <div class="topbar compact-topbar">
            <div>
                <h1>Account Control Room</h1>
                <p>Approve, freeze, set account numbers and update account type without wasting screen space.</p>
            </div>
            <form method="get" action="accounts" class="inline-form filter-form">
                <select name="status">
                    <option value="ALL">All</option>
                    <option value="PENDING" <%= "PENDING".equals(status) ? "selected" : "" %>>Pending</option>
                    <option value="ACTIVE" <%= "ACTIVE".equals(status) ? "selected" : "" %>>Active</option>
                    <option value="FROZEN" <%= "FROZEN".equals(status) ? "selected" : "" %>>Frozen</option>
                    <option value="CLOSED" <%= "CLOSED".equals(status) ? "selected" : "" %>>Closed</option>
                    <option value="REJECTED" <%= "REJECTED".equals(status) ? "selected" : "" %>>Rejected</option>
                </select>
                <button class="btn primary">Filter</button>
            </form>
        </div>

        <% if (success != null) { %>
            <div class="alert success"><%= success.replace('_',' ') %></div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert error"><%= error.replace('_',' ') %></div>
        <% } %>

        <section class="panel compact-panel">
            <table class="compact-accounts-table">
                <thead>
                <tr>
                    <th>Customer</th>
                    <th>Email</th>
                    <th>Account Number</th>
                    <th>Type</th>
                    <th>Balance</th>
                    <th>Status</th>
                    <th>Admin Controls</th>
                </tr>
                </thead>
                <tbody>
                <% if (accounts != null && !accounts.isEmpty()) {
                    for (Account a : accounts) { %>
                    <tr>
                        <td class="name-cell"><strong><%= a.getCustomerName() %></strong></td>
                        <td><%= a.getCustomerEmail() %></td>
                        <td>
                            <form method="post" action="accounts" class="inline-form account-number-form">
                                <input type="hidden" name="accountId" value="<%= a.getAccountId() %>">
                                <input type="text" name="accountNumber" value="<%= a.getAccountNumber() %>" required>
                                <button name="action" value="updateNumber" class="mini blue-btn">Save</button>
                            </form>
                        </td>
                        <td>
                            <form method="post" action="accounts" class="inline-form type-form">
                                <input type="hidden" name="accountId" value="<%= a.getAccountId() %>">
                                <select name="accountType">
                                    <option value="SAVINGS" <%= "SAVINGS".equals(a.getAccountType()) ? "selected" : "" %>>Savings</option>
                                    <option value="CURRENT" <%= "CURRENT".equals(a.getAccountType()) ? "selected" : "" %>>Current</option>
                                </select>
                                <button name="action" value="updateType" class="mini grey-btn">Update</button>
                            </form>
                        </td>
                        <td>Rs. <%= a.getBalance() %></td>
                        <td><span class="badge <%= a.getStatus() %>"><%= a.getStatus() %></span></td>
                        <td>
                            <form method="post" action="accounts" class="inline-form action-form">
                                <input type="hidden" name="accountId" value="<%= a.getAccountId() %>">
                                <button name="action" value="activate" class="mini success-btn">Activate</button>
                                <button name="action" value="freeze" class="mini warning-btn">Freeze</button>
                                <button name="action" value="reject" class="mini danger-btn">Reject</button>
                                <button name="action" value="close" class="mini grey-btn">Close</button>
                            </form>
                        </td>
                    </tr>
                <% }} else { %>
                    <tr><td colspan="7">No accounts found.</td></tr>
                <% } %>
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>
