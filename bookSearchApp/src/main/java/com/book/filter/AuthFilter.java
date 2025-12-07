package com.book.filter;

import java.io.IOException;
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

@WebFilter(urlPatterns = {"/mypage.jsp", "/admin.jsp", "/addToLibrary", "/addReview"})
public class AuthFilter implements Filter {

    public void init(FilterConfig fConfig) throws ServletException {}

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        boolean hasSession = (session != null);
        boolean hasUser = (hasSession && session.getAttribute("user") != null);

        if (hasUser) {
            chain.doFilter(request, response);
        } else {
            String requestedWith = req.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                res.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
            } else {
                res.sendRedirect(req.getContextPath() + "/login.jsp");
            }
        }
    }

    public void destroy() {}
}
