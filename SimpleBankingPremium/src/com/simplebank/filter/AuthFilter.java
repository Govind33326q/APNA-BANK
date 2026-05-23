package com.simplebank.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/customer/*"})
public class AuthFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) { }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        String role = session == null ? null : (String) session.getAttribute("role");

        if (path.startsWith("/admin/") && !("ADMIN".equals(role) || "STAFF".equals(role))) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/error.jsp?code=unauthorized&type=staff");
            return;
        }

        if ((path.startsWith("/admin/staff") || path.startsWith("/admin/settings")) && !"ADMIN".equals(role)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/error.jsp?code=admin-only&type=staff");
            return;
        }

        if (path.startsWith("/customer/") && !"CUSTOMER".equals(role)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/error.jsp?code=unauthorized&type=customer");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() { }
}
