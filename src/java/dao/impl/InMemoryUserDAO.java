/*
 * ============================================================================
 * DEPRECATED: This in-memory implementation is no longer used.
 * The application now uses UserDAOImpl which connects to a real database.
 * Database: testCRM
 * 
 * This file is kept for reference purposes only.
 * ============================================================================
 */

/*
package dao.impl;

import dao.UserDAO;
import model.entity.Role;
import model.entity.User;

import util.PasswordUtil;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

public class InMemoryUserDAO implements UserDAO {
    
    private static final Map<Long, User> users = new ConcurrentHashMap<>();
    private static final AtomicLong idGenerator = new AtomicLong(1);
    private static boolean initialized = false;
    
    public InMemoryUserDAO() {
        initializeDefaultUsers();
    }
    
    private static synchronized void initializeDefaultUsers() {
        if (initialized) {
            return;
        }
        
        User admin = new User();
        admin.setId(idGenerator.getAndIncrement());
        admin.setUsername("admin");
        admin.setPassword(PasswordUtil.hashPassword("admin123"));
        admin.setEmail("admin@crm.com");
        admin.setFullName("Quản trị viên");
        admin.setRole(Role.ADMIN);
        admin.setIsActive(true);
        admin.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        admin.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        users.put(admin.getId(), admin);
        
        User testUser = new User();
        testUser.setId(idGenerator.getAndIncrement());
        testUser.setUsername("user");
        testUser.setPassword(PasswordUtil.hashPassword("user123"));
        testUser.setEmail("user@crm.com");
        testUser.setFullName("Người dùng test");
        testUser.setPhone("0123456789");
        testUser.setRole(Role.USER);
        testUser.setIsActive(true);
        testUser.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        testUser.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        users.put(testUser.getId(), testUser);
        
        initialized = true;
        System.out.println("InMemoryUserDAO initialized with " + users.size() + " users");
        System.out.println("  - admin / admin123 (ADMIN)");
        System.out.println("  - user / user123 (USER)");
    }
    
    @Override
    public User findByUsername(String username) throws SQLException {
        return users.values().stream()
                .filter(u -> u.getUsername().equalsIgnoreCase(username))
                .findFirst()
                .orElse(null);
    }
    
    @Override
    public User findById(Long id) throws SQLException {
        return users.get(id);
    }
    
    @Override
    public User findByEmail(String email) throws SQLException {
        return users.values().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email))
                .findFirst()
                .orElse(null);
    }
    
    @Override
    public List<User> findAll() throws SQLException {
        return new ArrayList<>(users.values()).stream()
                .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
                .collect(Collectors.toList());
    }
    
    @Override
    public List<User> findAllActive() throws SQLException {
        return users.values().stream()
                .filter(u -> u.getIsActive() != null && u.getIsActive())
                .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
                .collect(Collectors.toList());
    }
    
    @Override
    public User create(User user) throws SQLException {
        user.setId(idGenerator.getAndIncrement());
        user.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        user.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        if (user.getIsActive() == null) {
            user.setIsActive(true);
        }
        users.put(user.getId(), user);
        System.out.println("User created: " + user.getUsername() + " (ID: " + user.getId() + ")");
        return user;
    }
    
    @Override
    public boolean update(User user) throws SQLException {
        if (user.getId() == null || !users.containsKey(user.getId())) {
            return false;
        }
        user.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        users.put(user.getId(), user);
        System.out.println("User updated: " + user.getUsername() + " (ID: " + user.getId() + ")");
        return true;
    }
    
    @Override
    public boolean delete(Long id) throws SQLException {
        User user = users.get(id);
        if (user != null) {
            user.setIsActive(false);
            user.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
            System.out.println("User soft deleted: " + user.getUsername() + " (ID: " + id + ")");
            return true;
        }
        return false;
    }
    
    @Override
    public boolean hardDelete(Long id) throws SQLException {
        User removed = users.remove(id);
        if (removed != null) {
            System.out.println("User hard deleted: " + removed.getUsername() + " (ID: " + id + ")");
            return true;
        }
        return false;
    }
    
    @Override
    public boolean usernameExists(String username) throws SQLException {
        return users.values().stream()
                .anyMatch(u -> u.getUsername().equalsIgnoreCase(username));
    }
    
    @Override
    public boolean emailExists(String email) throws SQLException {
        return users.values().stream()
                .anyMatch(u -> u.getEmail().equalsIgnoreCase(email));
    }
    
    @Override
    public int countAll() throws SQLException {
        return users.size();
    }
    
    @Override
    public int countActive() throws SQLException {
        return (int) users.values().stream()
                .filter(u -> u.getIsActive() != null && u.getIsActive())
                .count();
    }
    
    public static void clear() {
        users.clear();
        idGenerator.set(1);
    }
    
    public static Map<Long, User> getAllUsers() {
        return users;
    }
}
*/
