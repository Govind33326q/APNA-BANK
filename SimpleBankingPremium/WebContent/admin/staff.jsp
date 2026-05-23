<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.simplebank.model.User,java.util.List" %>
<%@ include file="../includes/design.jspf" %>
<%
    List<User> staffMembers = (List<User>) request.getAttribute("staffMembers");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Members</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jspf" %>
    <main class="content">
        <div class="topbar">
            <div>
                <h1>Staff Members</h1>
                <p>Admin can create authorized staff accounts. Staff login works only for these users.</p>
            </div>
        </div>

        <% if (success != null) { %>
            <div class="alert success"><%= success.replace('_', ' ') %></div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert error"><%= error.replace('_', ' ') %></div>
        <% } %>

        <section class="panel" style="margin-bottom:18px;">
            <h2>Add Staff Member</h2>
            <form method="post" action="staff" class="inline-form" style="align-items:flex-end;">
                <input type="hidden" name="action" value="create">
                <div>
                    <label>Full Name</label>
                    <input type="text" name="fullName" placeholder="Staff name" required>
                </div>
                <div>
                    <label>Email</label>
                    <input type="email" name="email" placeholder="staff@bank.com" required>
                </div>
                <div>
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Minimum 6 characters" minlength="6" required>
                </div>
                <div>
                    <label>Phone</label>
                    <input type="text" name="phone" placeholder="Phone number">
                </div>
                <button class="btn primary" type="submit">Create Staff</button>
            </form>
        </section>

        <section class="panel">
            <h2>Authorized Staff List</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Phone</th>
                        <th>Created</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <% if (staffMembers != null && !staffMembers.isEmpty()) { for (User u : staffMembers) { %>
                    <tr>
                        <td>#<%= u.getUserId() %></td>
                        <td><%= u.getFullName() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><span class="badge"><%= u.getRole() %></span></td>
                        <td><%= u.getPhone() == null ? "-" : u.getPhone() %></td>
                        <td><%= u.getCreatedAt() %></td>
                        <td>
                            <% if ("STAFF".equals(u.getRole())) { %>
                                <form method="post" action="staff" class="inline-form" onsubmit="return confirm('Remove this staff member?');">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <button class="mini danger-btn" type="submit">Remove</button>
                                </form>
                            <% } else { %>
                                <span class="badge">Main Admin</span>
                            <% } %>
                        </td>
                    </tr>
                <% }} else { %>
                    <tr><td colspan="7">No staff members found.</td></tr>
                <% } %>
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>
