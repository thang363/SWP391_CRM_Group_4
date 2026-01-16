package controller;

import service.AuthService;
import service.impl.AuthServiceImpl;
import util.Constants;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {
    
    private final AuthService authService;
    
    public LogoutServlet() {
        this.authService = new AuthServiceImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }
    
    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            Long userId = (Long) session.getAttribute(Constants.SESSION_USER_ID);
            
            if (userId != null) {
                authService.logout(userId);
            }
            
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + Constants.SERVLET_LOGIN + "?logout=1");
    }
}
