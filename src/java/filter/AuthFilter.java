package filter;

import util.Constants;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/dashboard/*", "/profile/*", "/sales-pipeline/*", "/customers/*", "/users/*", "/api/*"})
public class AuthFilter implements Filter {
    
    private static final String[] EXCLUDED_URLS = {
        "/login", "/register", "/logout", "/css/", "/js/", "/img/", "/lib/", "/favicon.ico"
    };
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AuthFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        if (isExcluded(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        HttpSession session = httpRequest.getSession(false);
        
        boolean isLoggedIn = (session != null && session.getAttribute(Constants.SESSION_USER_ID) != null);
        
        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            String targetUrl = httpRequest.getRequestURI();
            if (httpRequest.getQueryString() != null) {
                targetUrl += "?" + httpRequest.getQueryString();
            }
            
            HttpSession newSession = httpRequest.getSession(true);
            newSession.setAttribute(Constants.SESSION_REDIRECT_URL, targetUrl);
            
            String xRequestedWith = httpRequest.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(xRequestedWith)) {
                httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                httpResponse.getWriter().write("{\"error\": \"Unauthorized\", \"message\": \"Session expired\"}");
                return;
            }
            
            httpResponse.sendRedirect(contextPath + Constants.SERVLET_LOGIN);
        }
    }
    
    private boolean isExcluded(String path) {
        for (String excluded : EXCLUDED_URLS) {
            if (path.startsWith(excluded)) {
                return true;
            }
        }
        return false;
    }
    
    @Override
    public void destroy() {
        System.out.println("AuthFilter destroyed");
    }
}
