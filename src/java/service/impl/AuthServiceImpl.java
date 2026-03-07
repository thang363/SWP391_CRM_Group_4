package service.impl;

import dao.UserDAO;
import dao.impl.UserDAOImpl;
import model.entity.User;
import model.viewmodel.LoginViewModel;
import service.AuthService;
import util.PasswordUtil;

import java.sql.SQLException;

public class AuthServiceImpl implements AuthService {
    
    private final UserDAO userDAO;
    
    public AuthServiceImpl() {
        this.userDAO = new UserDAOImpl();
    }
    
    public AuthServiceImpl(UserDAO userDAO) {
        this.userDAO = userDAO;
    }
    
    @Override
    public User login(LoginViewModel loginViewModel) {
        if (!loginViewModel.validate()) {
            return null;
        }
        
        try {
            User user = userDAO.findByUsername(loginViewModel.getUsername());
            
            if (user == null) {
                loginViewModel.setErrorMessage("Tên đăng nhập không tồn tại");
                return null;
            }
            
            if (!"Active".equalsIgnoreCase(user.getStatus())) {
                loginViewModel.setErrorMessage("Tài khoản đã bị vô hiệu hóa hoặc bị khóa");
                return null;
            }
            
            if (!PasswordUtil.verifyPassword(loginViewModel.getPassword(), user.getPassword())) {
                loginViewModel.setErrorMessage("Mật khẩu không chính xác");
                return null;
            }
            
            System.out.println("User logged in: " + user.getUsername() + " [" + user.getRole() + "]");
            return user;
            
        } catch (SQLException e) {
            System.err.println("Database error during login: " + e.getMessage());
            e.printStackTrace();
            loginViewModel.setErrorMessage("Lỗi hệ thống. Vui lòng thử lại sau.");
            return null;
        }
    }
    
    @Override
    public User validateSession(Integer userId) {
        if (userId == null) {
            return null;
        }
        
        try {
            User user = userDAO.findById(userId);
            
            if (user != null && "Active".equalsIgnoreCase(user.getStatus())) {
                return user;
            }
            
            return null;
            
        } catch (SQLException e) {
            System.err.println("Database error while validating session: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    @Override
    public void logout(Integer userId) {
        if (userId != null) {
            System.out.println("User logged out: ID=" + userId);
        }
    }
    
    @Override
    public boolean isAccountActive(Integer userId) {
        if (userId == null) {
            return false;
        }
        
        try {
            User user = userDAO.findById(userId);
            return user != null && "Active".equalsIgnoreCase(user.getStatus());
            
        } catch (SQLException e) {
            System.err.println("Database error while checking account status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
