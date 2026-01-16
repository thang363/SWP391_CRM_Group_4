package controller;

import model.entity.User;
import model.viewmodel.RegisterViewModel;
import service.UserService;
import service.impl.UserServiceImpl;
import util.Constants;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    
    private final UserService userService;
    
    public RegisterServlet() {
        this.userService = new UserServiceImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute(Constants.SESSION_USER_ID) != null) {
            response.sendRedirect(request.getContextPath() + Constants.SERVLET_DASHBOARD);
            return;
        }
        
        request.getRequestDispatcher(Constants.PAGE_REGISTER).forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String agreeTerms = request.getParameter("agreeTerms");
        
        if (agreeTerms == null) {
            request.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Báº¡n pháº£i Ä‘á»“ng Ã½ vá»›i Ä‘iá»u khoáº£n sá»­ dá»¥ng");
            forwardWithData(request, response, username, fullName, email, phone);
            return;
        }
        
        RegisterViewModel registerViewModel = new RegisterViewModel(
                username, password, confirmPassword, email, fullName, phone);
        
        User user = userService.register(registerViewModel);
        
        if (user != null) {
            response.sendRedirect(request.getContextPath() + Constants.SERVLET_LOGIN + "?success=1");
        } else {
            request.setAttribute(Constants.ATTR_ERROR_MESSAGE, registerViewModel.getErrorMessage());
            forwardWithData(request, response, username, fullName, email, phone);
        }
    }
    
    private void forwardWithData(HttpServletRequest request, HttpServletResponse response,
                                  String username, String fullName, String email, String phone)
            throws ServletException, IOException {
        
        request.setAttribute("username", username);
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.getRequestDispatcher(Constants.PAGE_REGISTER).forward(request, response);
    }
}
