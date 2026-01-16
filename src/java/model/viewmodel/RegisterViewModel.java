package model.viewmodel;

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
            errorMessage = "TÃªn Ä‘Äƒng nháº­p khÃ´ng Ä‘Æ°á»£c Ä‘á»ƒ trá»‘ng";
            return false;
        }
        
        if (username.length() < 3 || username.length() > 50) {
            errorMessage = "TÃªn Ä‘Äƒng nháº­p pháº£i tá»« 3 Ä‘áº¿n 50 kÃ½ tá»±";
            return false;
        }
        
        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            errorMessage = "TÃªn Ä‘Äƒng nháº­p chá»‰ Ä‘Æ°á»£c chá»©a chá»¯ cÃ¡i, sá»‘ vÃ  dáº¥u gáº¡ch dÆ°á»›i";
            return false;
        }
        
        if (fullName == null || fullName.trim().isEmpty()) {
            errorMessage = "Há» vÃ  tÃªn khÃ´ng Ä‘Æ°á»£c Ä‘á»ƒ trá»‘ng";
            return false;
        }
        
        if (password == null || password.trim().isEmpty()) {
            errorMessage = "Máº­t kháº©u khÃ´ng Ä‘Æ°á»£c Ä‘á»ƒ trá»‘ng";
            return false;
        }
        
        if (password.length() < 6) {
            errorMessage = "Máº­t kháº©u pháº£i cÃ³ Ã­t nháº¥t 6 kÃ½ tá»±";
            return false;
        }
        
        if (confirmPassword == null || !confirmPassword.equals(password)) {
            errorMessage = "Máº­t kháº©u xÃ¡c nháº­n khÃ´ng khá»›p";
            return false;
        }
        
        if (email == null || email.trim().isEmpty()) {
            errorMessage = "Email khÃ´ng Ä‘Æ°á»£c Ä‘á»ƒ trá»‘ng";
            return false;
        }
        
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            errorMessage = "Email khÃ´ng Ä‘Ãºng Ä‘á»‹nh dáº¡ng";
            return false;
        }
        
        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.matches("^[0-9]{10,11}$")) {
                errorMessage = "Sá»‘ Ä‘iá»‡n thoáº¡i pháº£i cÃ³ 10-11 chá»¯ sá»‘";
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
