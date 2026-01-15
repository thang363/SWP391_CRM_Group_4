package com.crm.model.viewmodel;

public class LoginViewModel {
    private String username;
    private String password;
    private boolean rememberMe;
    private String errorMessage;
    
    public LoginViewModel() {
    }
    
    public LoginViewModel(String username, String password) {
        this.username = username;
        this.password = password;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public boolean isRememberMe() {
        return rememberMe;
    }
    
    public void setRememberMe(boolean rememberMe) {
        this.rememberMe = rememberMe;
    }
    
    public String getErrorMessage() {
        return errorMessage;
    }
    
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    
    public boolean validate() {
        if (username == null || username.trim().isEmpty()) {
            errorMessage = "Tên đăng nhập không được để trống";
            return false;
        }
        
        if (password == null || password.trim().isEmpty()) {
            errorMessage = "Mật khẩu không được để trống";
            return false;
        }
        
        if (username.length() < 3) {
            errorMessage = "Tên đăng nhập phải có ít nhất 3 ký tự";
            return false;
        }
        
        return true;
    }
    
    @Override
    public String toString() {
        return "LoginViewModel{" +
                "username='" + username + '\'' +
                ", rememberMe=" + rememberMe +
                ", errorMessage='" + errorMessage + '\'' +
                '}';
    }
}
