package service.impl;

import dao.UserDAO;
import dao.impl.UserDAOImpl;
import model.entity.Role;
import model.entity.User;
import model.viewmodel.RegisterViewModel;
import model.viewmodel.UserViewModel;
import service.UserService;
import util.PasswordUtil;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class UserServiceImpl implements UserService {
    
    private final UserDAO userDAO;
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    
    public UserServiceImpl() {
        this.userDAO = new UserDAOImpl();
    }
    
    public UserServiceImpl(UserDAO userDAO) {
        this.userDAO = userDAO;
    }
    
    @Override
    public User register(RegisterViewModel registerViewModel) {
        if (!registerViewModel.validate()) {
            return null;
        }
        
        try {
            if (userDAO.usernameExists(registerViewModel.getUsername())) {
                registerViewModel.setErrorMessage("Tên đăng nhập đã tồn tại");
                return null;
            }
            
            if (userDAO.emailExists(registerViewModel.getEmail())) {
                registerViewModel.setErrorMessage("Email đã được sử dụng");
                return null;
            }
            
            String hashedPassword = PasswordUtil.hashPassword(registerViewModel.getPassword());
            
            User user = new User();
            user.setUsername(registerViewModel.getUsername());
            user.setPassword(hashedPassword);
            user.setEmail(registerViewModel.getEmail());
            user.setFullName(registerViewModel.getFullName());
            user.setPhone(registerViewModel.getPhone());
            user.setRole(Role.fromString(registerViewModel.getRole()));
            user.setStatus("Active");
            
            User createdUser = userDAO.create(user);
            
            System.out.println("User registered: " + createdUser.getUsername());
            return createdUser;
            
        } catch (SQLException e) {
            System.err.println("Database error during registration: " + e.getMessage());
            e.printStackTrace();
            registerViewModel.setErrorMessage("Lỗi hệ thống. Vui lòng thử lại sau.");
            return null;
        }
    }
    
    @Override
    public User getUserById(Long userId) {
        if (userId == null) {
            return null;
        }
        
        try {
            return userDAO.findById(userId);
        } catch (SQLException e) {
            System.err.println("Database error while fetching user: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    @Override
    public User getUserByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return null;
        }
        
        try {
            return userDAO.findByUsername(username);
        } catch (SQLException e) {
            System.err.println("Database error while fetching user by username: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    @Override
    public UserViewModel getUserViewModelById(Long userId) {
        User user = getUserById(userId);
        return user != null ? convertToViewModel(user) : null;
    }
    
    @Override
    public List<UserViewModel> getAllUsers() {
        try {
            List<User> users = userDAO.findAll();
            List<UserViewModel> viewModels = new ArrayList<>();
            
            for (User user : users) {
                viewModels.add(convertToViewModel(user));
            }
            
            return viewModels;
            
        } catch (SQLException e) {
            System.err.println("Database error while fetching all users: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    @Override
    public List<UserViewModel> getAllActiveUsers() {
        try {
            List<User> users = userDAO.findAllActive();
            List<UserViewModel> viewModels = new ArrayList<>();
            
            for (User user : users) {
                viewModels.add(convertToViewModel(user));
            }
            
            return viewModels;
            
        } catch (SQLException e) {
            System.err.println("Database error while fetching active users: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    @Override
    public List<User> getUsersByRole(Role role) {
        if (role == null) {
            return new ArrayList<>();
        }
        
        try {
            List<User> allUsers = userDAO.findAll();
            List<User> filteredUsers = new ArrayList<>();
            
            for (User user : allUsers) {
                if (user.getRole() == role && "Active".equals(user.getStatus())) {
                    filteredUsers.add(user);
                }
            }
            
            return filteredUsers;
            
        } catch (SQLException e) {
            System.err.println("Database error while fetching users by role: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    @Override
    public boolean updateUser(User user) {
        if (user == null || user.getId() == null) {
            return false;
        }
        
        try {
            return userDAO.update(user);
        } catch (SQLException e) {
            System.err.println("Database error while updating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean updateProfile(Long userId, String fullName, String email, String phone) {
        if (userId == null) {
            return false;
        }
        
        try {
            User user = userDAO.findById(userId);
            if (user == null) {
                return false;
            }
            
            User existingEmail = userDAO.findByEmail(email);
            if (existingEmail != null && !existingEmail.getId().equals(userId)) {
                return false;
            }
            
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            
            return userDAO.update(user);
            
        } catch (SQLException e) {
            System.err.println("Database error while updating profile: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        if (userId == null || oldPassword == null || newPassword == null) {
            return false;
        }
        
        try {
            User user = userDAO.findById(userId);
            if (user == null) {
                return false;
            }
            
            if (!PasswordUtil.verifyPassword(oldPassword, user.getPassword())) {
                return false;
            }
            
            String hashedPassword = PasswordUtil.hashPassword(newPassword);
            user.setPassword(hashedPassword);
            
            return userDAO.update(user);
            
        } catch (SQLException e) {
            System.err.println("Database error while changing password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean deleteUser(Long userId) {
        if (userId == null) {
            return false;
        }
        
        try {
            return userDAO.delete(userId);
        } catch (SQLException e) {
            System.err.println("Database error while deleting user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean setUserActiveStatus(Long userId, boolean isActive) {
        if (userId == null) {
            return false;
        }
        
        try {
            User user = userDAO.findById(userId);
            if (user == null) {
                return false;
            }
            
            user.setStatus(isActive ? "Active" : "Inactive");
            return userDAO.update(user);
            
        } catch (SQLException e) {
            System.err.println("Database error while setting user status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public UserViewModel convertToViewModel(User user) {
        if (user == null) {
            return null;
        }
        
        UserViewModel viewModel = new UserViewModel();
        viewModel.setId(user.getId());
        viewModel.setUsername(user.getUsername());
        viewModel.setEmail(user.getEmail());
        viewModel.setFullName(user.getFullName());
        viewModel.setPhone(user.getPhone());
        viewModel.setRole(user.getRole());
        viewModel.setStatus(user.getStatus());
        
        if (user.getCreatedAt() != null) {
            viewModel.setCreatedAt(dateFormat.format(user.getCreatedAt()));
        }
        
        return viewModel;
    }
    
    @Override
    public int getTotalUserCount() {
        try {
            return userDAO.countAll();
        } catch (SQLException e) {
            System.err.println("Database error while counting users: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    @Override
    public int getActiveUserCount() {
        try {
            return userDAO.countActive();
        } catch (SQLException e) {
            System.err.println("Database error while counting active users: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
}
