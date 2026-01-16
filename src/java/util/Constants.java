package util;

public class Constants {
    
    public static final String SESSION_USER = "currentUser";
    public static final String SESSION_USER_ID = "userId";
    public static final String SESSION_USERNAME = "username";
    public static final String SESSION_ROLE = "userRole";
    public static final String SESSION_FULL_NAME = "fullName";
    public static final String SESSION_REDIRECT_URL = "redirectUrl";
    
    public static final String ATTR_ERROR_MESSAGE = "errorMessage";
    public static final String ATTR_SUCCESS_MESSAGE = "successMessage";
    public static final String ATTR_USER = "user";
    public static final String ATTR_USERS = "users";
    public static final String ATTR_PAGE_TITLE = "pageTitle";
    
    public static final String DB_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    public static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=CRM_DB;encrypt=true;trustServerCertificate=true";
    public static final String DB_USERNAME = "sa";
    public static final String DB_PASSWORD = "123";
    
    public static final int DB_POOL_INITIAL_SIZE = 5;
    public static final int DB_POOL_MAX_SIZE = 20;
    
    public static final String ERROR_LOGIN_FAILED = "TÃªn Ä‘Äƒng nháº­p hoáº·c máº­t kháº©u khÃ´ng chÃ­nh xÃ¡c";
    public static final String ERROR_REGISTRATION_FAILED = "ÄÄƒng kÃ½ tháº¥t báº¡i. Vui lÃ²ng thá»­ láº¡i.";
    public static final String ERROR_USERNAME_EXISTS = "TÃªn Ä‘Äƒng nháº­p Ä‘Ã£ tá»“n táº¡i";
    public static final String ERROR_EMAIL_EXISTS = "Email Ä‘Ã£ Ä‘Æ°á»£c sá»­ dá»¥ng";
    public static final String ERROR_UNAUTHORIZED = "Báº¡n khÃ´ng cÃ³ quyá»n truy cáº­p trang nÃ y";
    public static final String ERROR_SESSION_EXPIRED = "PhiÃªn lÃ m viá»‡c Ä‘Ã£ háº¿t háº¡n. Vui lÃ²ng Ä‘Äƒng nháº­p láº¡i.";
    public static final String ERROR_DATABASE = "Lá»—i cÆ¡ sá»Ÿ dá»¯ liá»‡u. Vui lÃ²ng thá»­ láº¡i sau.";
    public static final String ERROR_ACCOUNT_DISABLED = "TÃ i khoáº£n Ä‘Ã£ bá»‹ vÃ´ hiá»‡u hÃ³a";
    public static final String ERROR_INVALID_INPUT = "Dá»¯ liá»‡u nháº­p khÃ´ng há»£p lá»‡";
    public static final String ERROR_PASSWORD_MISMATCH = "Máº­t kháº©u khÃ´ng khá»›p";
    public static final String ERROR_PASSWORD_INCORRECT = "Máº­t kháº©u hiá»‡n táº¡i khÃ´ng Ä‘Ãºng";
    
    public static final String SUCCESS_REGISTRATION = "ÄÄƒng kÃ½ thÃ nh cÃ´ng! Vui lÃ²ng Ä‘Äƒng nháº­p.";
    public static final String SUCCESS_LOGIN = "ChÃ o má»«ng báº¡n trá»Ÿ láº¡i!";
    public static final String SUCCESS_LOGOUT = "Báº¡n Ä‘Ã£ Ä‘Äƒng xuáº¥t thÃ nh cÃ´ng.";
    public static final String SUCCESS_PROFILE_UPDATED = "Cáº­p nháº­t thÃ´ng tin thÃ nh cÃ´ng.";
    public static final String SUCCESS_PASSWORD_CHANGED = "Äá»•i máº­t kháº©u thÃ nh cÃ´ng.";
    public static final String SUCCESS_USER_CREATED = "Táº¡o ngÆ°á»i dÃ¹ng thÃ nh cÃ´ng.";
    public static final String SUCCESS_USER_UPDATED = "Cáº­p nháº­t ngÆ°á»i dÃ¹ng thÃ nh cÃ´ng.";
    public static final String SUCCESS_USER_DELETED = "XÃ³a ngÆ°á»i dÃ¹ng thÃ nh cÃ´ng.";
    
    public static final String PAGE_LOGIN = "/views/login.jsp";
    public static final String PAGE_REGISTER = "/views/register.jsp";
    public static final String PAGE_DASHBOARD = "/views/dashboard.jsp";
    public static final String PAGE_PROFILE = "/views/profile.jsp";
    public static final String PAGE_SALES_PIPELINE = "/views/sales-pipeline.jsp";
    public static final String PAGE_CUSTOMERS = "/views/customers.jsp";
    public static final String PAGE_USERS = "/views/users.jsp";
    public static final String PAGE_ERROR = "/views/error.jsp";
    public static final String PAGE_403 = "/views/403.jsp";
    public static final String PAGE_404 = "/views/404.jsp";
    
    public static final String SERVLET_LOGIN = "/login";
    public static final String SERVLET_LOGOUT = "/logout";
    public static final String SERVLET_REGISTER = "/register";
    public static final String SERVLET_DASHBOARD = "/dashboard";
    public static final String SERVLET_PROFILE = "/profile";
    public static final String SERVLET_SALES_PIPELINE = "/sales-pipeline";
    public static final String SERVLET_CUSTOMERS = "/customers";
    public static final String SERVLET_USERS = "/users";
    
    public static final int DEFAULT_PAGE_SIZE = 10;
    public static final int MAX_PAGE_SIZE = 100;
    
    public static final long MAX_FILE_SIZE = 5 * 1024 * 1024;
    public static final String UPLOAD_DIRECTORY = "uploads";
    
    private Constants() {
        throw new AssertionError();
    }
}
