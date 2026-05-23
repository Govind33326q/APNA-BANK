package com.simplebank.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class GlobalErrorFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = httpRequest.getRequestURI();

        try {
            chain.doFilter(request, response);
        } catch (Throwable error) {
            if (path.contains("/error.jsp")) {
                throw error instanceof ServletException ? (ServletException) error : new ServletException(error);
            }
            httpRequest.setAttribute("errorTitle", "Something went wrong");
            httpRequest.setAttribute("errorMessage", "The system could not complete your request. Please try again or contact the bank administrator.");
            httpRequest.setAttribute("errorDetail", error.getClass().getSimpleName());
            httpRequest.getRequestDispatcher("/error.jsp?code=server-error").forward(httpRequest, httpResponse);
        }
    }
}
