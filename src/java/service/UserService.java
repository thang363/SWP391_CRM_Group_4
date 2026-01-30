package service;

import model.entity.User;
import model.viewmodel.RegisterViewModel;
import model.viewmodel.UserViewModel;

import java.util.List;
import model.entity.Role;

public interface UserService {
    
    User register(RegisterViewModel registerViewModel);
    
    User getUserById(Long userId);
    
    User getUserByUsername(String username);
    
    UserViewModel getUserViewModelById(Long userId);
    
    List<UserViewModel> getAllUsers();
    
    List<UserViewModel> getAllActiveUsers();
    
    List<User> getUsersByRole(Role role);
    
    boolean updateUser(User user);
    
    boolean updateProfile(Long userId, String fullName, String email, String phone);
    
    boolean changePassword(Long userId, String oldPassword, String newPassword);
    
    boolean deleteUser(Long userId);
    
    boolean setUserActiveStatus(Long userId, boolean isActive);
    
    UserViewModel convertToViewModel(User user);
    
    int getTotalUserCount();
    
    int getActiveUserCount();
}
