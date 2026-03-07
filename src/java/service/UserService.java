package service;

import model.entity.User;
import model.viewmodel.RegisterViewModel;
import model.viewmodel.UserViewModel;

import java.util.List;
import model.entity.Role;

public interface UserService {
    
    User register(RegisterViewModel registerViewModel);
    
    User getUserById(Integer userId);
    
    User getUserByUsername(String username);
    
    UserViewModel getUserViewModelById(Integer userId);
    
    List<UserViewModel> getAllUsers();
    
    List<UserViewModel> getAllActiveUsers();
    
    List<User> getUsersByRole(Role role);
    
    boolean updateUser(User user);
    
    boolean updateProfile(Integer userId, String fullName, String email, String phone);
    
    boolean changePassword(Integer userId, String oldPassword, String newPassword);
    
    boolean deleteUser(Integer userId);
    
    boolean setUserActiveStatus(Integer userId, boolean isActive);
    
    UserViewModel convertToViewModel(User user);
    
    int getTotalUserCount();
    
    int getActiveUserCount();
}
