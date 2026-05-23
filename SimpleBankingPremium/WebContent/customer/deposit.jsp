<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.simplebank.model.Account" %>
<%@ include file="../includes/design.jspf" %>
<% Account account = (Account) request.getAttribute("account"); String success = (String) request.getAttribute("success"); String error = (String) request.getAttribute("error"); %>
<!DOCTYPE html>
<html><head><title>Deposit</title><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body><div class="layout"><%@ include file="sidebar.jspf" %><main class="content">
<div class="topbar"><div><h1>Deposit Money</h1><p>Add money to your active account.</p></div></div>
<% if (success != null) { %><div class="alert success"><%= success %></div><% } %><% if (error != null) { %><div class="alert error"><%= error %></div><% } %>
<section class="panel grid-2"><div class="bank-card-3d"><div class="chip"></div><div class="card-number"><%= account == null ? "ACCOUNT" : account.getAccountNumber() %></div><div class="card-meta"><span>Balance</span><span>Rs. <%= account == null ? "0" : account.getBalance() %></span></div></div><form method="post" action="deposit" class="form"><label>Amount</label><input type="number" name="amount" min="1" step="0.01" required><button class="btn primary">Deposit</button></form></section>
</main></div></body></html>
