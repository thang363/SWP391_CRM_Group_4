package service;

import model.entity.User;
import model.viewmodel.LoginViewModel;

public interface AuthService {
    
    User login(LoginViewModel loginViewModel);
    
    User validateSession(Integer userId);
    
    void logout(Integer userId);
    
    boolean isAccountActive(Integer userId);
}
