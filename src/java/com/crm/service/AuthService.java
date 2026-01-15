package com.crm.service;

import com.crm.model.entity.User;
import com.crm.model.viewmodel.LoginViewModel;

public interface AuthService {
    
    User login(LoginViewModel loginViewModel);
    
    User validateSession(Long userId);
    
    void logout(Long userId);
    
    boolean isAccountActive(Long userId);
}
