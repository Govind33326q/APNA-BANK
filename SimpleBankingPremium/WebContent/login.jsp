<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
    if (error == null) {
        error = request.getParameter("error");
    }
    String success = request.getParameter("success");
    String selectedType = "staff".equalsIgnoreCase(request.getParameter("type")) ? "STAFF" : "CUSTOMER";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Secure Login - Premium Bank</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@ include file="includes/design.jspf" %>
    <style>
        .login-type-switch {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-bottom: 10px;
        }
        .login-type-btn {
            border: 1px solid rgba(148, 163, 184, 0.28);
            background: rgba(255,255,255,0.72);
            border-radius: 18px;
            padding: 12px;
            text-align: left;
            cursor: pointer;
            font-weight: 900;
            color: #334155;
            box-shadow: 0 12px 28px rgba(15,23,42,0.06);
            transition: 0.22s ease;
        }
        .login-type-btn span {
            display: block;
            margin-top: 4px;
            color: #64748b;
            font-size: 11px;
            font-weight: 700;
        }
        .login-type-btn.active {
            color: #1d4ed8;
            border-color: rgba(37, 99, 235, 0.45);
            background: rgba(219, 234, 254, 0.85);
            box-shadow: 0 0 0 4px rgba(37,99,235,0.10), 0 18px 36px rgba(37,99,235,0.14);
        }
        @media (max-width: 640px) {
            .login-type-switch { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body class="cinematic-auth-body">
    <main class="cinematic-login-shell">
        <section class="cinematic-scene-card">
            <div class="glass-orb orb-a"></div>
            <div class="glass-orb orb-b"></div>

            <div class="scene-copy">
                <div class="scene-kicker">Secure Digital Banking</div>
                <h1>Welcome to <%= bankName %></h1>
                <p>
                    A secure banking portal for customers and authorized staff members with account controls and transaction monitoring.
                </p>
            </div>

            <div class="office-stage" aria-hidden="true">
                <div class="stage-floor"></div>
                <div class="door-light"></div>

                <svg class="employee-svg" viewBox="0 0 230 310" role="img" aria-label="Animated bank employee">
                    <defs>
                        <linearGradient id="suitGrad" x1="0" x2="1" y1="0" y2="1">
                            <stop offset="0%" stop-color="#1e3a8a" />
                            <stop offset="100%" stop-color="#0f172a" />
                        </linearGradient>
                        <linearGradient id="skinGrad" x1="0" x2="1" y1="0" y2="1">
                            <stop offset="0%" stop-color="#ffd8b5" />
                            <stop offset="100%" stop-color="#f2a66f" />
                        </linearGradient>
                        <filter id="softShadow" x="-30%" y="-30%" width="160%" height="160%">
                            <feDropShadow dx="0" dy="12" stdDeviation="9" flood-color="#0f172a" flood-opacity="0.25" />
                        </filter>
                    </defs>

                    <ellipse class="employee-shadow" cx="116" cy="292" rx="74" ry="13" fill="#0f172a" opacity="0.18" />

                    <g class="employee-body" filter="url(#softShadow)">
                        <path class="leg leg-left" d="M93 190 C83 220 80 247 78 280 L98 280 C100 247 108 220 119 194 Z" fill="#172554" />
                        <path class="leg leg-right" d="M128 190 C138 221 144 248 148 280 L168 280 C165 247 157 219 144 192 Z" fill="#1e3a8a" />
                        <path d="M72 280 L105 280 C108 289 101 296 88 296 L62 296 C58 288 63 282 72 280 Z" fill="#111827" />
                        <path d="M142 280 L175 280 C181 289 174 296 160 296 L135 296 C130 288 134 282 142 280 Z" fill="#111827" />

                        <path d="M68 106 C82 86 148 86 162 106 C173 136 166 169 146 204 L85 204 C65 169 58 136 68 106 Z" fill="url(#suitGrad)" />
                        <path d="M94 102 L118 160 L142 102 C128 94 109 94 94 102 Z" fill="#ffffff" opacity="0.95" />
                        <path d="M113 113 L124 113 L129 166 L119 182 L109 166 Z" fill="#ef4444" />
                        <path d="M72 118 C44 137 41 165 58 184 L71 174 C60 158 62 143 80 132 Z" fill="#1e3a8a" />
                        <path class="arm-right" d="M158 119 C181 136 188 162 173 184 L160 175 C170 158 166 144 150 132 Z" fill="#1e3a8a" />
                        <circle cx="57" cy="185" r="10" fill="url(#skinGrad)" />
                        <circle class="briefcase-hand" cx="173" cy="185" r="10" fill="url(#skinGrad)" />

                        <circle cx="115" cy="62" r="36" fill="url(#skinGrad)" />
                        <path d="M78 59 C82 31 103 17 130 25 C151 31 161 48 153 70 C139 56 113 57 93 62 C88 72 82 72 78 59 Z" fill="#20202a" />
                        <circle cx="102" cy="62" r="3.4" fill="#111827" />
                        <circle cx="129" cy="62" r="3.4" fill="#111827" />
                        <path d="M105 78 C113 85 124 85 133 78" fill="none" stroke="#8a3f1e" stroke-width="4" stroke-linecap="round" />
                        <path d="M86 52 C96 46 114 43 144 49" fill="none" stroke="#111827" stroke-width="8" stroke-linecap="round" opacity="0.32" />
                    </g>
                </svg>

                <div class="briefcase-3d">
                    <div class="case-handle"></div>
                    <div class="case-lid">
                        <span class="case-metal left"></span>
                        <span class="case-metal right"></span>
                    </div>
                    <div class="case-base">
                        <span class="case-lock"></span>
                    </div>
                    <div class="case-light"></div>
                </div>
            </div>

            <section class="cinematic-login-card">
                <div class="brand login-brand">
                    <div class="brand-logo">
                        <% if (logoUrl != null) { %>
                            <img src="<%= logoUrl %>" alt="Bank Logo">
                        <% } else { %>
                            PB
                        <% } %>
                    </div>
                    <div>
                        <h2><%= bankName %></h2>
                        <span>Staff and customer access</span>
                    </div>
                </div>

                <h2>Choose login type</h2>
                <p class="muted-text">Staff login is available only for admin-created staff members. Customers should use customer login.</p>

                <% if (error != null) { %>
                    <div class="alert error"><%= error.replace('_', ' ') %></div>
                <% } %>
                <% if (success != null) { %>
                    <div class="alert success"><%= success.replace('_', ' ') %></div>
                <% } %>

                <form action="login" method="post" class="premium-form">
                    <input type="hidden" id="loginType" name="loginType" value="<%= selectedType %>">

                    <div class="login-type-switch">
                        <button type="button" class="login-type-btn <%= "STAFF".equals(selectedType) ? "active" : "" %>" onclick="setLoginType('STAFF', this)">
                            Staff Login
                            <span>Admin + authorized staff</span>
                        </button>
                        <button type="button" class="login-type-btn <%= "CUSTOMER".equals(selectedType) ? "active" : "" %>" onclick="setLoginType('CUSTOMER', this)">
                            Customer Login
                            <span>Registered customers only</span>
                        </button>
                    </div>

                    <label>Email Address</label>
                    <input type="email" name="email" placeholder="email@bank.com" required>

                    <label>Password</label>
                    <input type="password" name="password" placeholder="Enter password" required>

                    <button type="submit" class="premium-submit">Login Securely</button>
                </form>

                <div class="login-footer-link">
                    New customer? <a href="register.jsp">Create account</a>
                </div>

                <div class="login-demo-strip">
                    <strong>Demo:</strong> Staff: admin@bank.com / admin123 &nbsp; | &nbsp; Customer: customer@bank.com / customer123
                </div>
            </section>
        </section>
    </main>
<script>
    function setLoginType(type, button) {
        document.getElementById('loginType').value = type;
        document.querySelectorAll('.login-type-btn').forEach(function(btn) {
            btn.classList.remove('active');
        });
        button.classList.add('active');
    }
</script>
</body>
</html>
