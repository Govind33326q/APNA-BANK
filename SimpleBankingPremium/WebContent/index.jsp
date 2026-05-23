<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Aurora Bank | Personal Banking</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@ include file="includes/design.jspf" %>

    <style>
        :root {
            --bank-blue: #0b4aa2;
            --bank-blue-dark: #062f68;
            --bank-cyan: #0ea5e9;
            --bank-green: #0f9f6e;
            --bank-gold: #d79a28;
            --ink: #0f172a;
            --muted: #64748b;
            --line: rgba(148, 163, 184, 0.22);
            --glass: rgba(255, 255, 255, 0.78);
            --shadow-soft: 0 18px 45px rgba(15, 23, 42, 0.08);
            --shadow-card: 0 22px 60px rgba(15, 23, 42, 0.12);
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body.real-bank-page {
            margin: 0;
            min-height: 100vh;
            font-family: Inter, Arial, sans-serif;
            color: var(--ink);
            background:
                radial-gradient(circle at 8% 4%, rgba(14, 165, 233, 0.08), transparent 23rem),
                radial-gradient(circle at 92% 12%, rgba(11, 74, 162, 0.08), transparent 24rem),
                linear-gradient(180deg, #f8fbff 0%, #eef5ff 48%, #ffffff 100%);
            overflow-x: hidden;
        }

        .bank-shell {
            width: min(1180px, calc(100% - 36px));
            margin: 0 auto;
        }

        .utility-bar {
            padding: 10px 0;
            font-size: 13px;
            color: #475569;
            border-bottom: 1px solid rgba(148, 163, 184, 0.16);
        }

        .utility-inner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
        }

        .utility-left,
        .utility-right {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .utility-right a {
            color: #334155;
            font-weight: 800;
            text-decoration: none;
        }

        .utility-right a:hover {
            color: var(--bank-blue);
        }

        .bank-nav {
            position: sticky;
            top: 12px;
            z-index: 50;
            margin-top: 12px;
            padding: 10px 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            border: 1px solid rgba(255, 255, 255, 0.72);
            border-radius: 26px;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.82), rgba(255, 255, 255, 0.58)),
                linear-gradient(120deg, rgba(14, 165, 233, 0.10), rgba(11, 74, 162, 0.06));
            backdrop-filter: blur(22px) saturate(170%);
            -webkit-backdrop-filter: blur(22px) saturate(170%);
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.10);
            overflow: hidden;
        }

        .bank-nav::before {
            content: "";
            position: absolute;
            inset: 0;
            pointer-events: none;
            background:
                linear-gradient(110deg, transparent 0%, rgba(255,255,255,0.44) 36%, transparent 62%);
            transform: translateX(-120%);
            animation: navLiquidShine 7s ease-in-out infinite;
        }

        @keyframes navLiquidShine {
            0%, 45% { transform: translateX(-120%); }
            70%, 100% { transform: translateX(120%); }
        }

        .bank-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 228px;
            color: var(--ink);
            text-decoration: none;
            position: relative;
            z-index: 2;
        }

        .brand-mark {
            width: 48px;
            height: 48px;
            border-radius: 16px;
            display: grid;
            place-items: center;
            color: #ffffff;
            font-weight: 900;
            letter-spacing: -0.04em;
            background: linear-gradient(135deg, var(--bank-blue), var(--bank-cyan));
            box-shadow: 0 14px 28px rgba(11, 74, 162, 0.24);
            overflow: hidden;
        }

        .brand-mark img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .brand-text strong {
            display: block;
            font-size: 18px;
            letter-spacing: -0.04em;
        }

        .brand-text span {
            display: block;
            margin-top: 2px;
            color: var(--muted);
            font-size: 12px;
            font-weight: 800;
        }

        .bank-links {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            padding: 6px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.46);
            border: 1px solid rgba(148, 163, 184, 0.13);
            position: relative;
            z-index: 2;
        }

        .bank-links a {
            position: relative;
            padding: 10px 13px;
            border-radius: 999px;
            color: #334155;
            font-size: 14px;
            font-weight: 900;
            text-decoration: none;
            transition: 0.22s ease;
        }

        .bank-links a::after {
            content: "";
            position: absolute;
            left: 22%;
            right: 22%;
            bottom: 4px;
            height: 3px;
            border-radius: 999px;
            background: linear-gradient(90deg, transparent, #38bdf8, #0b4aa2, transparent);
            opacity: 0;
            transform: translateY(6px) scaleX(0.55);
            filter: blur(0.1px);
            box-shadow: 0 0 14px rgba(14, 165, 233, 0.75);
            transition: 0.24s ease;
        }

        .bank-links a:hover,
        .bank-links a.is-active {
            color: var(--bank-blue);
            background: rgba(219, 234, 254, 0.54);
        }

        .bank-links a:hover::after,
        .bank-links a.is-active::after {
            opacity: 1;
            transform: translateY(0) scaleX(1);
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            position: relative;
            z-index: 2;
        }

        .bank-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 43px;
            padding: 11px 16px;
            border-radius: 999px;
            border: 0;
            text-decoration: none;
            font-size: 14px;
            font-weight: 900;
            transition: 0.22s ease;
            cursor: pointer;
        }

        .bank-btn:hover {
            transform: translateY(-2px);
        }

        .bank-btn.primary {
            color: #ffffff;
            background: linear-gradient(135deg, var(--bank-blue), var(--bank-cyan));
            box-shadow: 0 16px 32px rgba(11, 74, 162, 0.22);
        }

        .bank-btn.secondary {
            color: var(--bank-blue);
            background: rgba(239, 246, 255, 0.92);
            border: 1px solid rgba(11, 74, 162, 0.12);
        }

        .hero-area {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 26px;
            padding: 52px 0 28px;
            align-items: stretch;
        }

        .hero-main {
            min-height: 475px;
            border-radius: 36px;
            padding: 42px;
            position: relative;
            overflow: hidden;
            color: #ffffff;
            background:
                linear-gradient(135deg, rgba(6, 47, 104, 0.96), rgba(11, 74, 162, 0.92) 56%, rgba(14, 165, 233, 0.78)),
                radial-gradient(circle at 22% 18%, rgba(255, 255, 255, 0.16), transparent 16rem);
            box-shadow: 0 30px 80px rgba(11, 74, 162, 0.20);
        }

        .hero-main::before {
            content: "";
            position: absolute;
            right: -120px;
            top: -120px;
            width: 360px;
            height: 360px;
            border-radius: 50%;
            border: 42px solid rgba(255, 255, 255, 0.08);
        }

        .hero-main::after {
            content: "";
            position: absolute;
            right: 42px;
            bottom: 34px;
            width: 275px;
            height: 176px;
            border-radius: 28px;
            background:
                linear-gradient(135deg, rgba(255,255,255,0.22), rgba(255,255,255,0.08)),
                linear-gradient(135deg, rgba(15,23,42,0.40), rgba(6,182,212,0.10));
            border: 1px solid rgba(255,255,255,0.22);
            transform: rotate(-8deg);
            box-shadow: 0 28px 60px rgba(0,0,0,0.18);
        }

        .hero-content {
            position: relative;
            z-index: 2;
            max-width: 650px;
        }

        .hero-label {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.13);
            border: 1px solid rgba(255, 255, 255, 0.18);
            color: #dbeafe;
            font-size: 13px;
            font-weight: 900;
        }

        .hero-title {
            margin: 22px 0 16px;
            font-size: clamp(42px, 6vw, 72px);
            line-height: 0.96;
            letter-spacing: -0.07em;
        }

        .hero-text {
            max-width: 600px;
            margin: 0;
            color: #dbeafe;
            font-size: 17px;
            line-height: 1.75;
        }

        .hero-cta {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 28px;
        }

        .hero-note {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            max-width: 620px;
            margin-top: 34px;
        }

        .note-card {
            padding: 14px;
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.16);
        }

        .note-card strong {
            display: block;
            font-size: 24px;
            letter-spacing: -0.06em;
        }

        .note-card span {
            display: block;
            margin-top: 5px;
            color: #c7ddff;
            font-size: 12px;
            font-weight: 800;
        }

        .quick-panel {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .login-panel,
        .notice-panel {
            border-radius: 30px;
            padding: 24px;
            background: rgba(255, 255, 255, 0.84);
            border: 1px solid rgba(255, 255, 255, 0.88);
            box-shadow: var(--shadow-soft);
            backdrop-filter: blur(18px);
        }

        .login-panel h3,
        .notice-panel h3 {
            margin: 0 0 8px;
            letter-spacing: -0.04em;
            font-size: 24px;
        }

        .login-panel p,
        .notice-panel p {
            margin: 0 0 18px;
            color: var(--muted);
            line-height: 1.6;
        }

        .quick-list {
            display: grid;
            gap: 10px;
        }

        .quick-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            padding: 13px 14px;
            border-radius: 16px;
            color: #0f172a;
            text-decoration: none;
            background: #f8fafc;
            border: 1px solid rgba(148, 163, 184, 0.18);
            font-weight: 900;
            transition: 0.2s ease;
        }

        .quick-item:hover {
            transform: translateX(4px);
            color: var(--bank-blue);
            background: #eff6ff;
        }

        .section {
            padding: 34px 0;
        }

        .section-head {
            display: flex;
            align-items: end;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 18px;
        }

        .section-head h2 {
            margin: 0;
            font-size: clamp(28px, 4vw, 42px);
            letter-spacing: -0.06em;
        }

        .section-head p {
            margin: 0;
            max-width: 540px;
            color: var(--muted);
            line-height: 1.65;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }

        .product-card {
            min-height: 230px;
            padding: 22px;
            border-radius: 28px;
            background: rgba(255, 255, 255, 0.82);
            border: 1px solid rgba(255, 255, 255, 0.84);
            box-shadow: 0 18px 44px rgba(15, 23, 42, 0.07);
            backdrop-filter: blur(16px);
            transition: 0.22s ease;
        }

        .product-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 28px 64px rgba(11, 74, 162, 0.13);
        }

        .product-icon {
            width: 48px;
            height: 48px;
            display: grid;
            place-items: center;
            border-radius: 17px;
            color: #ffffff;
            font-size: 22px;
            background: linear-gradient(135deg, var(--bank-blue), var(--bank-cyan));
            box-shadow: 0 14px 28px rgba(11, 74, 162, 0.18);
        }

        .product-card h3 {
            margin: 18px 0 8px;
            letter-spacing: -0.04em;
        }

        .product-card p {
            margin: 0;
            color: var(--muted);
            line-height: 1.58;
            font-size: 14px;
        }

        .two-column-section {
            display: grid;
            grid-template-columns: 0.95fr 1.05fr;
            gap: 18px;
            align-items: stretch;
        }

        .bank-info-card {
            padding: 30px;
            border-radius: 34px;
            background: rgba(255, 255, 255, 0.82);
            border: 1px solid rgba(255, 255, 255, 0.9);
            box-shadow: var(--shadow-soft);
            backdrop-filter: blur(18px);
        }

        .bank-info-card.dark {
            color: #ffffff;
            background:
                radial-gradient(circle at 18% 16%, rgba(255,255,255,0.16), transparent 12rem),
                linear-gradient(135deg, #062f68, #0b4aa2 64%, #0ea5e9);
        }

        .bank-info-card h2 {
            margin: 0 0 12px;
            font-size: clamp(28px, 4vw, 42px);
            letter-spacing: -0.06em;
        }

        .bank-info-card p {
            margin: 0;
            color: #64748b;
            line-height: 1.72;
        }

        .bank-info-card.dark p {
            color: #dbeafe;
        }

        .feature-list {
            display: grid;
            gap: 12px;
            margin-top: 20px;
        }

        .feature-row {
            display: flex;
            gap: 12px;
            align-items: flex-start;
            padding: 14px;
            border-radius: 18px;
            background: rgba(248, 250, 252, 0.86);
            border: 1px solid rgba(148, 163, 184, 0.16);
        }

        .feature-row b {
            display: block;
            margin-bottom: 3px;
        }

        .feature-row span {
            color: var(--muted);
            font-size: 13px;
            line-height: 1.45;
        }

        .check-dot {
            width: 28px;
            height: 28px;
            flex: 0 0 auto;
            border-radius: 10px;
            display: grid;
            place-items: center;
            color: #ffffff;
            background: var(--bank-green);
            font-weight: 900;
        }

        .footer-cta {
            margin: 38px 0 0;
            padding: 34px;
            border-radius: 34px;
            color: #ffffff;
            background:
                radial-gradient(circle at 22% 20%, rgba(255,255,255,0.18), transparent 14rem),
                linear-gradient(135deg, #062f68, #0b4aa2 62%, #0ea5e9);
            box-shadow: 0 30px 76px rgba(11, 74, 162, 0.22);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .footer-cta h2 {
            margin: 0 0 8px;
            font-size: clamp(26px, 4vw, 40px);
            letter-spacing: -0.06em;
        }

        .footer-cta p {
            margin: 0;
            color: #dbeafe;
            line-height: 1.65;
        }

        .site-footer {
            padding: 28px 0 36px;
            color: #64748b;
            text-align: center;
            font-size: 14px;
            font-weight: 700;
        }

        @media (max-width: 1040px) {
            .bank-links {
                display: none;
            }

            .hero-area,
            .two-column-section {
                grid-template-columns: 1fr;
            }

            .quick-panel {
                display: grid;
                grid-template-columns: 1fr 1fr;
            }

            .product-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 680px) {
            .utility-inner,
            .footer-cta,
            .section-head,
            .bank-nav {
                align-items: flex-start;
                flex-direction: column;
            }

            .bank-brand {
                min-width: auto;
            }

            .nav-actions {
                width: 100%;
            }

            .nav-actions .bank-btn {
                flex: 1;
            }

            .hero-main {
                padding: 28px;
                min-height: auto;
            }

            .hero-main::after {
                display: none;
            }

            .hero-note,
            .quick-panel,
            .product-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body class="real-bank-page">
    <div class="utility-bar">
        <div class="bank-shell utility-inner">
            <div class="utility-left">
                <span>Customer Care: 1800-000-000</span>
                <span>Branch Hours: 10:00 AM - 4:00 PM</span>
            </div>
            <div class="utility-right">
                <a href="login.jsp">Net Banking</a>
                <a href="register.jsp">Open Account</a>
                <a href="#help">Support</a>
            </div>
        </div>
    </div>

    <header class="bank-shell bank-nav">
        <a href="index.jsp" class="bank-brand">
            <div class="brand-mark">
                <% if (logoUrl != null) { %>
                    <img src="<%= logoUrl %>" alt="Bank Logo">
                <% } else { %>
                    AB
                <% } %>
            </div>
            <div class="brand-text">
                <strong><%= bankName %></strong>
                <span>Personal & Digital Banking</span>
            </div>
        </a>

        <nav class="bank-links" id="bankNavLinks">
            <a class="is-active" href="#home">Home</a>
            <a href="#products">Accounts</a>
            <a href="#security">Security</a>
            <a href="#services">Services</a>
            <a href="#help">Contact</a>
        </nav>

        <div class="nav-actions">
            <a class="bank-btn secondary" href="login.jsp">Login</a>
            <a class="bank-btn primary" href="register.jsp">Create Account</a>
        </div>
    </header>

    <main class="bank-shell">
        <section id="home" class="hero-area">
            <div class="hero-main">
                <div class="hero-content">
                    <span class="hero-label">Secure Banking Management System</span>
                    <h1 class="hero-title">Your bank, your account, your control.</h1>
                    <p class="hero-text">
                        Manage customer accounts, approvals, deposits, withdrawals and transfers through
                        a secure Java Servlet, JSP, JDBC and PostgreSQL based banking portal.
                    </p>

                    <div class="hero-cta">
                        <a class="bank-btn primary" href="register.jsp">Open Savings Account</a>
                        <a class="bank-btn secondary" href="login.jsp">Login to Net Banking</a>
                    </div>

                    <div class="hero-note">
                        <div class="note-card">
                            <strong>24/7</strong>
                            <span>Online banking access</span>
                        </div>
                        <div class="note-card">
                            <strong>Admin</strong>
                            <span>Approval workflow</span>
                        </div>
                        <div class="note-card">
                            <strong>JDBC</strong>
                            <span>Secure database queries</span>
                        </div>
                    </div>
                </div>
            </div>

            <aside class="quick-panel">
                <div class="login-panel">
                    <h3>Internet Banking</h3>
                    <p>Access your dashboard, check balance, transfer funds and download statements.</p>
                    <div class="quick-list">
                        <a class="quick-item" href="login.jsp">
                            Customer Login <span>→</span>
                        </a>
                        <a class="quick-item" href="login.jsp">
                            Admin Login <span>→</span>
                        </a>
                        <a class="quick-item" href="register.jsp">
                            New Customer Registration <span>→</span>
                        </a>
                    </div>
                </div>

                <div class="notice-panel">
                    <h3>Service Notice</h3>
                    <p>
                        Newly created accounts require admin approval before deposit, withdrawal
                        and transfer operations are enabled.
                    </p>
                    <a class="bank-btn secondary" href="#security">View Security Features</a>
                </div>
            </aside>
        </section>

        <section id="products" class="section">
            <div class="section-head">
                <div>
                    <h2>Banking services</h2>
                    <p>
                        Simple services presented like a real banking portal, while keeping the
                        backend easy to explain during college viva.
                    </p>
                </div>
            </div>

            <div class="product-grid">
                <article class="product-card">
                    <div class="product-icon">🏦</div>
                    <h3>Savings Account</h3>
                    <p>Customer registration creates an account request which can be approved by admin.</p>
                </article>
                <article class="product-card">
                    <div class="product-icon">💼</div>
                    <h3>Current Account</h3>
                    <p>Account type can be selected during registration and updated from admin panel.</p>
                </article>
                <article class="product-card">
                    <div class="product-icon">⇄</div>
                    <h3>Fund Transfer</h3>
                    <p>Transfer funds between active accounts with balance checks and transaction records.</p>
                </article>
                <article class="product-card">
                    <div class="product-icon">📄</div>
                    <h3>Statement</h3>
                    <p>Customers can view transaction history and download account statements.</p>
                </article>
            </div>
        </section>

        <section id="security" class="section">
            <div class="two-column-section">
                <div class="bank-info-card dark">
                    <h2>Built for secure banking workflow.</h2>
                    <p>
                        Role-based access ensures customers and administrators access only their
                        permitted pages. Database operations use JDBC PreparedStatement and transaction logic.
                    </p>
                </div>

                <div class="bank-info-card">
                    <h2>Security controls</h2>
                    <p>
                        These features are practical, explainable and directly connected with the project code.
                    </p>

                    <div class="feature-list">
                        <div class="feature-row">
                            <div class="check-dot">✓</div>
                            <div>
                                <b>Role-based login</b>
                                <span>Admin and customer dashboards are protected separately.</span>
                            </div>
                        </div>
                        <div class="feature-row">
                            <div class="check-dot">✓</div>
                            <div>
                                <b>PreparedStatement queries</b>
                                <span>All important database operations are handled through DAO classes.</span>
                            </div>
                        </div>
                        <div class="feature-row">
                            <div class="check-dot">✓</div>
                            <div>
                                <b>Transaction rollback</b>
                                <span>Transfers use safe balance update logic to prevent incorrect records.</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section id="services" class="section">
            <div class="section-head">
                <div>
                    <h2>For customers and administrators</h2>
                    <p>
                        The portal separates customer self-service from administrative banking control.
                    </p>
                </div>
            </div>

            <div class="product-grid">
                <article class="product-card">
                    <div class="product-icon">👤</div>
                    <h3>Customer Dashboard</h3>
                    <p>View account details, balance, transactions and profile information.</p>
                </article>
                <article class="product-card">
                    <div class="product-icon">🛡</div>
                    <h3>Admin Control</h3>
                    <p>Approve accounts, update account numbers and control account status.</p>
                </article>
                <article class="product-card">
                    <div class="product-icon">💰</div>
                    <h3>Deposit & Withdraw</h3>
                    <p>Perform banking operations with active account validation and transaction entries.</p>
                </article>
                <article class="product-card">
                    <div class="product-icon">↩</div>
                    <h3>Transaction Revert</h3>
                    <p>Admin can reverse eligible transactions for correction and audit purposes.</p>
                </article>
            </div>
        </section>

        <section id="help" class="footer-cta">
            <div>
                <h2>Start banking with <%= bankName %>.</h2>
                <p>
                    Register as a customer, get account approval from admin, then access
                    deposits, withdrawals and transfers through the customer dashboard.
                </p>
            </div>
            <div class="hero-cta" style="margin-top:0;">
                <a class="bank-btn secondary" href="register.jsp">Create Account</a>
                <a class="bank-btn primary" href="login.jsp">Login</a>
            </div>
        </section>
    </main>

    <footer class="bank-shell site-footer">
        © 2026 <%= bankName %>. Banking Management System for academic project demonstration.
    </footer>

    <script>
        const navLinks = document.querySelectorAll('#bankNavLinks a');
        const sections = Array.from(navLinks).map(link => document.querySelector(link.getAttribute('href'))).filter(Boolean);

        function activateLink() {
            let currentId = 'home';
            sections.forEach(section => {
                const rect = section.getBoundingClientRect();
                if (rect.top <= 160) {
                    currentId = section.id;
                }
            });

            navLinks.forEach(link => {
                link.classList.toggle('is-active', link.getAttribute('href') === '#' + currentId);
            });
        }

        window.addEventListener('scroll', activateLink);
        activateLink();
    </script>
</body>
</html>
