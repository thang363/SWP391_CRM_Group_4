package dao;

import model.entity.User;
import java.sql.SQLException;
import java.util.List;

public interface UserDAO {
    
    User findByUsername(String username) throws SQLException;
    
    User findById(Integer id) throws SQLException;
    
    User findByEmail(String email) throws SQLException;
    
    List<User> findAll() throws SQLException;
    
    List<User> findAllActive() throws SQLException;
    
    User create(User user) throws SQLException;
    
    boolean update(User user) throws SQLException;
    
    boolean delete(Integer id) throws SQLException;
    
    boolean hardDelete(Integer id) throws SQLException;
    
    boolean usernameExists(String username) throws SQLException;
    
    boolean emailExists(String email) throws SQLException;
    
    int countAll() throws SQLException;
    
    int countActive() throws SQLException;
    
    List<User> findByRole(model.entity.Role role) throws SQLException;
    
    List<User> searchUsers(String query, String roleStr, String status) throws SQLException;
}
