package com.crm.controller;

import com.crm.model.entity.User;
import com.crm.model.viewmodel.LoginViewModel;
import com.crm.service.AuthService;
import com.crm.service.impl.AuthServiceImpl;
import com.crm.util.Constants;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    
    private final AuthService authService;
    
    public LoginServlet() {
        this.authService = new AuthServiceImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute(Constants.SESSION_USER_ID) != null) {
            response.sendRedirect(request.getContextPath() + Constants.SERVLET_DASHBOARD);
            return;
        }
        
        String successMessage = request.getParameter("success");
        if (successMessage != null && !successMessage.isEmpty()) {
            request.setAttribute(Constants.ATTR_SUCCESS_MESSAGE, Constants.SUCCESS_REGISTRATION);
        }
        
        String logoutMessage = request.getParameter("logout");
        if (logoutMessage != null) {
            request.setAttribute(Constants.ATTR_SUCCESS_MESSAGE, Constants.SUCCESS_LOGOUT);
        }
        
        request.getRequestDispatcher(Constants.PAGE_LOGIN).forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean rememberMe = "on".equals(request.getParameter("rememberMe"));
        
        LoginViewModel loginViewModel = new LoginViewModel(username, password);
        loginViewModel.setRememberMe(rememberMe);
        
        User user = authService.login(loginViewModel);
        
        if (user != null) {
            HttpSession session = request.getSession(true);
            
            session.setAttribute(Constants.SESSION_USER_ID, user.getId());
            session.setAttribute(Constants.SESSION_USERNAME, user.getUsername());
            session.setAttribute(Constants.SESSION_ROLE, user.getRole());
            session.setAttribute(Constants.SESSION_FULL_NAME, 
                    user.getFullName() != null ? user.getFullName() : user.getUsername());
            session.setAttribute(Constants.SESSION_USER, user);
            
            if (rememberMe) {
                session.setMaxInactiveInterval(7 * 24 * 60 * 60);
            } else {
                session.setMaxInactiveInterval(30 * 60);
            }
            
            String redirectUrl = (String) session.getAttribute(Constants.SESSION_REDIRECT_URL);
            session.removeAttribute(Constants.SESSION_REDIRECT_URL);
            
            if (redirectUrl != null && !redirectUrl.isEmpty() && !redirectUrl.contains("/login")) {
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + Constants.SERVLET_DASHBOARD);
            }
            
        } else {
            request.setAttribute(Constants.ATTR_ERROR_MESSAGE, loginViewModel.getErrorMessage());
            request.setAttribute("username", username);
            request.getRequestDispatcher(Constants.PAGE_LOGIN).forward(request, response);
        }
    }
}
