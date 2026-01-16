package model.viewmodel;

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
            errorMessage = "TÃªn Ä‘Äƒng nháº­p khÃ´ng Ä‘Æ°á»£c Ä‘á»ƒ trá»‘ng";
            return false;
        }
        
        if (password == null || password.trim().isEmpty()) {
            errorMessage = "Máº­t kháº©u khÃ´ng Ä‘Æ°á»£c Ä‘á»ƒ trá»‘ng";
            return false;
        }
        
        if (username.length() < 3) {
            errorMessage = "TÃªn Ä‘Äƒng nháº­p pháº£i cÃ³ Ã­t nháº¥t 3 kÃ½ tá»±";
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
