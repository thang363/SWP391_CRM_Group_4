package com.crm.model.viewmodel;

public class RegisterViewModel {
    private String username;
    private String password;
    private String confirmPassword;
    private String email;
    private String fullName;
    private String phone;
    private String errorMessage;
    
    public RegisterViewModel() {
    }
    
    public RegisterViewModel(String username, String password, String confirmPassword, 
                             String email, String fullName, String phone) {
        this.username = username;
        this.password = password;
        this.confirmPassword = confirmPassword;
        this.email = email;
        this.fullName = fullName;
        this.phone = phone;
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
    
    public String getConfirmPassword() {
        return confirmPassword;
    }
    
    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
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
        
        if (username.length() < 3 || username.length() > 50) {
            errorMessage = "Tên đăng nhập phải từ 3 đến 50 ký tự";
            return false;
        }
        
        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            errorMessage = "Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới";
            return false;
        }
        
        if (fullName == null || fullName.trim().isEmpty()) {
            errorMessage = "Họ và tên không được để trống";
            return false;
        }
        
        if (password == null || password.trim().isEmpty()) {
            errorMessage = "Mật khẩu không được để trống";
            return false;
        }
        
        if (password.length() < 6) {
            errorMessage = "Mật khẩu phải có ít nhất 6 ký tự";
            return false;
        }
        
        if (confirmPassword == null || !confirmPassword.equals(password)) {
            errorMessage = "Mật khẩu xác nhận không khớp";
            return false;
        }
        
        if (email == null || email.trim().isEmpty()) {
            errorMessage = "Email không được để trống";
            return false;
        }
        
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            errorMessage = "Email không đúng định dạng";
            return false;
        }
        
        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.matches("^[0-9]{10,11}$")) {
                errorMessage = "Số điện thoại phải có 10-11 chữ số";
                return false;
            }
        }
        
        return true;
    }
    
    @Override
    public String toString() {
        return "RegisterViewModel{" +
                "username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", phone='" + phone + '\'' +
                ", errorMessage='" + errorMessage + '\'' +
                '}';
    }
}
