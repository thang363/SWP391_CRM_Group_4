package filter;

import model.entity.Role;
import util.Constants;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@WebFilter(filterName = "RoleFilter", urlPatterns = {"/admin/*", "/users/*", "/campaigns/*", "/marketing/*","/transfers/*"})
public class RoleFilter implements Filter {

    private static final String[] EXCLUDED_URLS = {"/marketing/track-click"};

    private Map<String, Set<Role>> roleRequirements;
    private List<Map.Entry<String, Set<Role>>> sortedRequirements;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("RoleFilter initialized");

        roleRequirements = new HashMap<>();
        roleRequirements.put("/admin", Set.of(Role.MANAGER));
        roleRequirements.put("/users", Set.of(Role.MANAGER));
        roleRequirements.put("/campaigns", Set.of(Role.MANAGER));
        roleRequirements.put("/marketing/monitor-leads", Set.of(Role.MANAGER));
        roleRequirements.put("/marketing/submissions", Set.of(Role.MARKETING));
        roleRequirements.put("/transfers", Set.of(Role.MANAGER));
        roleRequirements.put("/marketing", Set.of(Role.MARKETING, Role.MANAGER));
        sortedRequirements = roleRequirements.entrySet().stream()
                .sorted((e1, e2) -> Integer.compare(e2.getKey().length(), e1.getKey().length()))
                .collect(Collectors.toList());
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
                httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                httpRequest.getRequestDispatcher("/views/error/403.jsp").forward(httpRequest, httpResponse);
            }
        }
    }

    private Set<Role> getRequiredRoles(String path) {

        for (Map.Entry<String, Set<Role>> entry : sortedRequirements) {
            if (path.startsWith(entry.getKey())) {
                return entry.getValue();
            }
        }
        return null;
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
        System.out.println("RoleFilter destroyed");
    }
}
