package com.crm.service.impl;

import com.crm.dao.UserDAO;
import com.crm.dao.impl.InMemoryUserDAO;
import com.crm.model.entity.User;
import com.crm.model.viewmodel.LoginViewModel;
import com.crm.service.AuthService;
import com.crm.util.PasswordUtil;

import java.sql.SQLException;

public class AuthServiceImpl implements AuthService {
    
    private final UserDAO userDAO;
    
    public AuthServiceImpl() {
        this.userDAO = new InMemoryUserDAO();
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
            
            if (user.getIsActive() == null || !user.getIsActive()) {
                loginViewModel.setErrorMessage("Tài khoản đã bị vô hiệu hóa");
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
    public User validateSession(Long userId) {
        if (userId == null) {
            return null;
        }
        
        try {
            User user = userDAO.findById(userId);
            
            if (user != null && user.getIsActive() != null && user.getIsActive()) {
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
    public void logout(Long userId) {
        if (userId != null) {
            System.out.println("User logged out: ID=" + userId);
        }
    }
    
    @Override
    public boolean isAccountActive(Long userId) {
        if (userId == null) {
            return false;
        }
        
        try {
            User user = userDAO.findById(userId);
            return user != null && user.getIsActive() != null && user.getIsActive();
            
        } catch (SQLException e) {
            System.err.println("Database error while checking account status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
