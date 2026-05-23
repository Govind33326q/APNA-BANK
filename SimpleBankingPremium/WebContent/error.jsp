<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String code = request.getParameter("code");
    String type = request.getParameter("type");
    String title = (String) request.getAttribute("errorTitle");
    String message = (String) request.getAttribute("errorMessage");
    String detail = (String) request.getAttribute("errorDetail");

    if (code == null) code = "general";
    if (type == null || type.trim().isEmpty()) type = "customer";

    String primaryLink = "login.jsp?type=customer";
    String primaryText = "Back to Customer Login";

    if ("staff".equalsIgnoreCase(type) || "wrong-portal".equals(code) || "admin-only".equals(code)) {
        primaryLink = "login.jsp?type=staff";
        primaryText = "Back to Staff Login";
    }

    if (title == null) {
        if ("invalid-login".equals(code)) {
            title = "Invalid login details";
            message = "The email or password entered is incorrect. Please check your details and try again.";
        } else if ("missing-login".equals(code)) {
            title = "Login details required";
            message = "Please enter both email address and password before continuing.";
        } else if ("wrong-portal".equals(code)) {
            title = "Wrong login portal";
            if ("staff".equalsIgnoreCase(type)) {
                message = "This account is not registered as bank staff. Please use the customer login option.";
                primaryLink = "login.jsp?type=customer";
                primaryText = "Go to Customer Login";
            } else {
                message = "This account belongs to staff/admin. Please use the staff login option.";
                primaryLink = "login.jsp?type=staff";
                primaryText = "Go to Staff Login";
            }
        } else if ("unauthorized".equals(code)) {
            title = "Access restricted";
            message = "You need to login with the correct role before opening this page.";
        } else if ("admin-only".equals(code)) {
            title = "Admin access only";
            message = "This page can be opened only by the main admin. Staff members do not have permission for this setting.";
        } else if ("login-system".equals(code)) {
            title = "Login service unavailable";
            message = "The login service is temporarily unavailable. Please try again after a few moments or contact the administrator.";
        } else if ("server-error".equals(code)) {
            title = title == null ? "Unexpected system error" : title;
            message = message == null ? "The request could not be completed right now. Please try again later." : message;
        } else {
            title = "Something went wrong";
            message = "The page could not be opened. Please go back and try again.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= title %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, Helvetica, sans-serif;
            color: #0f172a;
            background:
                radial-gradient(circle at 14% 18%, rgba(37,99,235,.13), transparent 25rem),
                radial-gradient(circle at 86% 16%, rgba(6,182,212,.12), transparent 23rem),
                linear-gradient(135deg, #f8fbff, #edf5ff 55%, #ffffff);
            display: grid;
            place-items: center;
            padding: 24px;
        }
        .error-card {
            width: min(720px, 100%);
            border-radius: 34px;
            padding: 34px;
            background: rgba(255,255,255,.78);
            border: 1px solid rgba(255,255,255,.86);
            box-shadow: 0 28px 90px rgba(15,23,42,.13);
            backdrop-filter: blur(22px);
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .error-card::before {
            content: "";
            position: absolute;
            inset: -60px -80px auto auto;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(37,99,235,.24), rgba(6,182,212,.18));
            filter: blur(3px);
        }
        .error-icon {
            width: 84px;
            height: 84px;
            margin: 0 auto 18px;
            border-radius: 28px;
            display: grid;
            place-items: center;
            color: #1d4ed8;
            font-size: 42px;
            font-weight: 900;
            background: rgba(219,234,254,.8);
            box-shadow: 0 18px 45px rgba(37,99,235,.16);
            position: relative;
        }
        h1 {
            margin: 0 0 12px;
            font-size: clamp(28px, 4vw, 44px);
            letter-spacing: -0.06em;
        }
        p {
            margin: 0 auto;
            max-width: 560px;
            color: #64748b;
            line-height: 1.75;
            font-size: 16px;
        }
        .error-detail {
            margin: 20px auto 0;
            display: inline-block;
            padding: 8px 12px;
            border-radius: 999px;
            color: #475569;
            background: #f8fafc;
            border: 1px solid rgba(148,163,184,.18);
            font-size: 12px;
            font-weight: 800;
        }
        .actions {
            margin-top: 28px;
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 170px;
            border-radius: 16px;
            padding: 13px 18px;
            font-weight: 900;
            text-decoration: none;
            transition: .2s ease;
        }
        .btn:hover { transform: translateY(-2px); }
        .primary {
            color: white;
            background: linear-gradient(135deg, #2563eb, #06b6d4);
            box-shadow: 0 18px 36px rgba(37,99,235,.18);
        }
        .secondary {
            color: #1d4ed8;
            background: rgba(219,234,254,.74);
            border: 1px solid rgba(37,99,235,.14);
        }
    </style>
</head>
<body>
    <main class="error-card">
        <div class="error-icon">!</div>
        <h1><%= title %></h1>
        <p><%= message %></p>
        <% if (detail != null) { %>
            <div class="error-detail">Technical detail: <%= detail %></div>
        <% } %>
        <div class="actions">
            <a class="btn primary" href="<%= primaryLink %>"><%= primaryText %></a>
            <a class="btn secondary" href="index.jsp">Go to Home</a>
        </div>
    </main>
</body>
</html>
