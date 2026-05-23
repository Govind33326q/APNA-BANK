<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.simplebank.model.BankSettings" %>
<%@ include file="../includes/design.jspf" %>
<%
    BankSettings settings = (BankSettings) request.getAttribute("settings");
    if (settings == null) {
        settings = bankSettings;
    }
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Bank Logo Settings</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jspf" %>

    <main class="content">
        <div class="topbar">
            <div>
                <h1>Bank Branding</h1>
                <p>Upload logo and update the display name shown across login, admin and customer panels.</p>
            </div>
        </div>

        <% if (success != null) { %>
            <div class="alert success"><%= success.replace('_', ' ') %></div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert error"><%= error.replace('_', ' ') %></div>
        <% } %>

        <section class="panel settings-preview">
            <div>
                <h2>Current Branding</h2>
                <div class="brand" style="margin-top: 18px;">
                    <div class="brand-logo" style="width: 76px; height: 76px; border-radius: 24px;">
                        <% if (logoUrl != null) { %>
                            <img src="<%= logoUrl %>" alt="Bank Logo">
                        <% } else { %>
                            PB
                        <% } %>
                    </div>
                    <div>
                        <h2><%= settings.getBankName() == null ? bankName : settings.getBankName() %></h2>
                        <span>Visible across the whole banking portal</span>
                    </div>
                </div>
            </div>

            <form method="post" action="settings" enctype="multipart/form-data" class="form">
                <label>Bank Name</label>
                <input type="text" name="bankName" value="<%= settings.getBankName() == null ? bankName : settings.getBankName() %>" required>

                <label>Upload Logo</label>
                <input type="file" name="logo" accept="image/*">

                <button type="submit" class="btn primary">Save Branding</button>
            </form>
        </section>
    </main>
</div>
</body>
</html>
