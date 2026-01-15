package com.crm.model.viewmodel;

import com.crm.model.entity.Role;

public class UserViewModel {
    private Long id;
    private String username;
    private String email;
    private String fullName;
    private String phone;
    private Role role;
    private Boolean isActive;
    private String createdAt;
    private String updatedAt;
    
    public UserViewModel() {
    }
    
    public UserViewModel(Long id, String username, String email, String fullName, 
                         String phone, Role role, Boolean isActive) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.fullName = fullName;
        this.phone = phone;
        this.role = role;
        this.isActive = isActive;
    }
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
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
    
    public Boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
    
    public String getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public String getDisplayName() {
        return (fullName != null && !fullName.isEmpty()) ? fullName : username;
    }
    
    public String getRoleDisplayName() {
        if (role == null) return "";
        switch (role) {
            case ADMIN: return "Quản trị viên";
            case MANAGER: return "Quản lý";
            case SALES: return "Nhân viên kinh doanh";
            case USER: return "Người dùng";
            default: return role.getValue();
        }
    }
    
    public String getStatusDisplayName() {
        return (isActive != null && isActive) ? "Đang hoạt động" : "Ngừng hoạt động";
    }
    
    @Override
    public String toString() {
        return "UserViewModel{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", role=" + role +
                ", isActive=" + isActive +
                '}';
    }
}
