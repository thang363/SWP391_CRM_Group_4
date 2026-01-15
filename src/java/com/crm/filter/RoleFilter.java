package com.crm.filter;

import com.crm.model.entity.Role;
import com.crm.util.Constants;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@WebFilter(filterName = "RoleFilter", urlPatterns = {"/admin/*", "/users/*"})
public class RoleFilter implements Filter {
    
    private Map<String, Set<Role>> roleRequirements;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("RoleFilter initialized");
        
        roleRequirements = new HashMap<>();
        roleRequirements.put("/admin", Set.of(Role.ADMIN));
        roleRequirements.put("/users", Set.of(Role.ADMIN));
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        HttpSession session = httpRequest.getSession(false);
        
        if (session == null) {
            httpResponse.sendRedirect(contextPath + Constants.SERVLET_LOGIN);
            return;
        }
        
        Object roleObj = session.getAttribute(Constants.SESSION_ROLE);
        Role userRole = null;
        
        if (roleObj instanceof Role) {
            userRole = (Role) roleObj;
        } else if (roleObj instanceof String) {
            userRole = Role.fromString((String) roleObj);
        }
        
        Set<Role> requiredRoles = getRequiredRoles(path);
        
        if (requiredRoles == null || requiredRoles.isEmpty()) {
            chain.doFilter(request, response);
            return;
        }
        
        if (userRole != null && requiredRoles.contains(userRole)) {
            chain.doFilter(request, response);
        } else {
            String xRequestedWith = httpRequest.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(xRequestedWith)) {
                httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                httpResponse.setContentType("application/json");
                httpResponse.getWriter().write("{\"error\": \"Forbidden\", \"message\": \"" + Constants.ERROR_UNAUTHORIZED + "\"}");
                return;
            }
            
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, Constants.ERROR_UNAUTHORIZED);
            
            if (userRole == null) {
                httpResponse.sendRedirect(contextPath + Constants.SERVLET_LOGIN);
            } else {
                httpResponse.sendRedirect(contextPath + Constants.SERVLET_DASHBOARD);
            }
        }
    }
    
    private Set<Role> getRequiredRoles(String path) {
        for (Map.Entry<String, Set<Role>> entry : roleRequirements.entrySet()) {
            if (path.startsWith(entry.getKey())) {
                return entry.getValue();
            }
        }
        return null;
    }
    
    @Override
    public void destroy() {
        System.out.println("RoleFilter destroyed");
    }
}
