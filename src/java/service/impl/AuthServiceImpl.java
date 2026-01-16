package service.impl;

import dao.UserDAO;
import dao.impl.InMemoryUserDAO;
import model.entity.User;
import model.viewmodel.LoginViewModel;
import service.AuthService;
import util.PasswordUtil;

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
                loginViewModel.setErrorMessage("TÃªn Ä‘Äƒng nháº­p khÃ´ng tá»“n táº¡i");
                return null;
            }
            
            if (user.getIsActive() == null || !user.getIsActive()) {
                loginViewModel.setErrorMessage("TÃ i khoáº£n Ä‘Ã£ bá»‹ vÃ´ hiá»‡u hÃ³a");
                return null;
            }
            
            if (!PasswordUtil.verifyPassword(loginViewModel.getPassword(), user.getPassword())) {
                loginViewModel.setErrorMessage("Máº­t kháº©u khÃ´ng chÃ­nh xÃ¡c");
                return null;
            }
            
            System.out.println("User logged in: " + user.getUsername() + " [" + user.getRole() + "]");
            return user;
            
        } catch (SQLException e) {
            System.err.println("Database error during login: " + e.getMessage());
            e.printStackTrace();
            loginViewModel.setErrorMessage("Lá»—i há»‡ thá»‘ng. Vui lÃ²ng thá»­ láº¡i sau.");
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
