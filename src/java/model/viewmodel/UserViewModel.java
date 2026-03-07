package model.viewmodel;

import model.entity.Role;

public class UserViewModel {
    private Integer id;
    private String username;
    private String email;
    private String fullName;
    private String phone;
    private Role role;
    private String status;
    private String createdAt;
    
    public UserViewModel() {
    }
    
    public UserViewModel(Integer id, String username, String email, String fullName, String phone, 
                         Role role, String status) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.fullName = fullName;
        this.phone = phone;
        this.role = role;
        this.status = status;
    }
    
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
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
    
    public Role getRole() {
        return role;
    }
    
    public void setRole(Role role) {
        this.role = role;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getDisplayName() {
        return (fullName != null && !fullName.isEmpty()) ? fullName : username;
    }
    
    public String getRoleDisplayName() {
        if (role == null) return "";
        switch (role) {
            case MANAGER: return "Quản lý";
            case MARKETING: return "Tiếp thị";
            case SALE: return "Kinh doanh";
            case SUPPORT: return "Hỗ trợ";
            default: return role.getValue();
        }
    }
    
    public String getStatusDisplayName() {
        if (status == null) return "Không xác định";
        if (status.equalsIgnoreCase("Active")) return "Đang hoạt động";
        if (status.equalsIgnoreCase("Inactive")) return "Ngừng hoạt động";
        if (status.equalsIgnoreCase("Locked")) return "Đã khóa";
        return status;
    }
    
    @Override
    public String toString() {
        return "UserViewModel{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", role=" + role +
                ", status='" + status + '\'' +
                '}';
    }
}
