<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.simplebank.model.User,java.util.List" %>
<%@ include file="../includes/design.jspf" %>

<%
    List<User> customers = (List<User>) request.getAttribute("customers");
    String keyword = (String) request.getAttribute("keyword");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String currentRole = (String) session.getAttribute("role");
    boolean isAdmin = "ADMIN".equals(currentRole);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Directory</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        .customer-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .customer-actions form {
            margin: 0;
        }

        .mini.promote-btn {
            background: linear-gradient(135deg, #2563eb, #06b6d4);
        }

        .mini.remove-btn {
            background: linear-gradient(135deg, #ef4444, #b91c1c);
        }

        .address-cell {
            max-width: 260px;
            white-space: normal;
            color: #64748b;
            line-height: 1.45;
        }

        .staff-note {
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
        }
    </style>
</head>

<body>
<div class="layout">
    <%@ include file="sidebar.jspf" %>

    <main class="content">
        <div class="topbar">
            <div>
                <h1>Customer Directory</h1>

                <% if (isAdmin) { %>
                    <p>Search customers, promote selected customers to staff, or remove inactive customer records.</p>
                <% } else { %>
                    <p>Search and verify customer records. Staff cannot promote or remove customers.</p>
                <% } %>
            </div>

            <form method="get" action="customers" class="inline-form">
                <input name="keyword"
                       value="<%= keyword == null ? "" : keyword %>"
                       placeholder="Search customer">
                <button class="btn primary">Search</button>
            </form>
        </div>

        <% if (success != null) { %>
            <div class="alert success"><%= success.replace('_', ' ') %></div>
        <% } %>

        <% if (error != null) { %>
            <div class="alert error"><%= error.replace('_', ' ') %></div>
        <% } %>

        <section class="panel">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Address</th>
                    <th>Created</th>
                    <% if (isAdmin) { %>
                        <th>Admin Action</th>
                    <% } else { %>
                        <th>Access</th>
                    <% } %>
                </tr>
                </thead>

                <tbody>
                <% if (customers != null && !customers.isEmpty()) {
                    for (User u : customers) { %>

                    <tr>
                        <td>#<%= u.getUserId() %></td>
                        <td><strong><%= u.getFullName() %></strong></td>
                        <td><%= u.getEmail() %></td>
                        <td><%= u.getPhone() == null ? "-" : u.getPhone() %></td>
                        <td class="address-cell"><%= u.getAddress() == null ? "-" : u.getAddress() %></td>
                        <td><%= u.getCreatedAt() %></td>

                        <td>
                            <% if (isAdmin) { %>
                                <div class="customer-actions">
                                    <form method="post" action="customers">
                                        <input type="hidden" name="userId" value="<%= u.getUserId() %>">

                                        <button class="mini promote-btn"
                                                name="action"
                                                value="promoteStaff"
                                                onclick="return confirm('Promote this customer to staff? Customer login access will stop.')">
                                            Make Staff
                                        </button>
                                    </form>

                                    <form method="post" action="customers">
                                        <input type="hidden" name="userId" value="<%= u.getUserId() %>">

                                        <button class="mini remove-btn"
                                                name="action"
                                                value="removeCustomer"
                                                onclick="return confirm('Remove this customer from customer section?')">
                                            Remove
                                        </button>
                                    </form>
                                </div>
                            <% } else { %>
                                <span class="staff-note">View only</span>
                            <% } %>
                        </td>
                    </tr>

                <%  }
                } else { %>
                    <tr>
                        <td colspan="7">No customers found.</td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>
