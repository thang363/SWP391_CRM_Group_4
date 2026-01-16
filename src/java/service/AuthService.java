package service;

import model.entity.User;
import model.viewmodel.LoginViewModel;

public interface AuthService {
    
    User login(LoginViewModel loginViewModel);
    
    User validateSession(Long userId);
    
    void logout(Long userId);
    
    boolean isAccountActive(Long userId);
}
