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
    public static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=CRM;encrypt=true;trustServerCertificate=true";
    public static final String DB_USERNAME = "sa";
    public static final String DB_PASSWORD = "123";
    
    public static final int DB_POOL_INITIAL_SIZE = 5;
    public static final int DB_POOL_MAX_SIZE = 20;
    
    public static final String ERROR_LOGIN_FAILED = "Tên đăng nhập hoặc mật khẩu không chính xác";
    public static final String ERROR_REGISTRATION_FAILED = "Đăng ký thất bại. Vui lòng thử lại.";
    public static final String ERROR_USERNAME_EXISTS = "Tên đăng nhập đã tồn tại";
    public static final String ERROR_EMAIL_EXISTS = "Email đã được sử dụng";
    public static final String ERROR_UNAUTHORIZED = "Bạn không có quyền truy cập trang này";
    public static final String ERROR_SESSION_EXPIRED = "Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.";
    public static final String ERROR_DATABASE = "Lỗi cơ sở dữ liệu. Vui lòng thử lại sau.";
    public static final String ERROR_ACCOUNT_DISABLED = "Tài khoản đã bị vô hiệu hóa";
    public static final String ERROR_INVALID_INPUT = "Dữ liệu nhập không hợp lệ";
    public static final String ERROR_PASSWORD_MISMATCH = "Mật khẩu không khớp";
    public static final String ERROR_PASSWORD_INCORRECT = "Mật khẩu hiện tại không đúng";
    
    public static final String SUCCESS_REGISTRATION = "Đăng ký thành công! Vui lòng đăng nhập.";
    public static final String SUCCESS_LOGIN = "Chào mừng bạn trở lại!";
    public static final String SUCCESS_LOGOUT = "Bạn đã đăng xuất thành công.";
    public static final String SUCCESS_PROFILE_UPDATED = "Cập nhật thông tin thành công.";
    public static final String SUCCESS_PASSWORD_CHANGED = "Đổi mật khẩu thành công.";
    public static final String SUCCESS_USER_CREATED = "Tạo người dùng thành công.";
    public static final String SUCCESS_USER_UPDATED = "Cập nhật người dùng thành công.";
    public static final String SUCCESS_USER_DELETED = "Xóa người dùng thành công.";
    
    public static final String PAGE_LOGIN = "/views/auth/login.jsp";
    public static final String PAGE_REGISTER = "/views/auth/register.jsp";
    public static final String PAGE_DASHBOARD = "/views/common/dashboard.jsp";
    public static final String PAGE_PROFILE = "/views/common/profile.jsp";
    public static final String PAGE_SALES_PIPELINE = "/views/sales/pipeline.jsp";
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
    public static final String SERVLET_CAMPAIGNS = "/campaigns";
    
    // Campaign constants
    public static final String PAGE_CAMPAIGNS = "/views/marketing/campaigns.jsp";
    public static final String PAGE_TRANSFER_INBOX = "/views/common/transfer-inbox.jsp";
    
    public static final String SERVLET_TRANSFERS = "/transfers";
    
    // Submissions constants
    public static final String PAGE_SUBMISSIONS = "/views/marketing/submissions.jsp";
    public static final String SERVLET_SUBMISSIONS = "/marketing/submissions";
    
    // Bulk Email constants
    public static final String PAGE_BULK_EMAIL = "/views/marketing/bulk-email.jsp";
    public static final String SERVLET_BULK_EMAIL = "/marketing/bulk-email";
    
    public static final String SUCCESS_CAMPAIGN_CREATED = "Tạo chiến dịch thành công.";
    public static final String SUCCESS_CAMPAIGN_UPDATED = "Cập nhật chiến dịch thành công.";
    public static final String SUCCESS_CAMPAIGN_DELETED = "Xóa chiến dịch thành công.";
    public static final String ERROR_CAMPAIGN_NOT_FOUND = "Không tìm thấy chiến dịch.";
    public static final String ERROR_INVALID_DATE_RANGE = "Ngày bắt đầu phải trước ngày kết thúc.";
    public static final String ERROR_CAMPAIGN_VALIDATION = "Dữ liệu chiến dịch không hợp lệ.";
    
    public static final int DEFAULT_PAGE_SIZE = 3;
    public static final int MAX_PAGE_SIZE = 100;
    
    public static final long MAX_FILE_SIZE = 5 * 1024 * 1024;
    public static final String UPLOAD_DIRECTORY = "uploads";
    
    private Constants() {
        throw new AssertionError();
    }
}
