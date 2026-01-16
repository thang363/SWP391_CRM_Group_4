package dao;

import model.entity.User;
import java.sql.SQLException;
import java.util.List;

public interface UserDAO {
    
    User findByUsername(String username) throws SQLException;
    
    User findById(Long id) throws SQLException;
    
    User findByEmail(String email) throws SQLException;
    
    List<User> findAll() throws SQLException;
    
    List<User> findAllActive() throws SQLException;
    
    User create(User user) throws SQLException;
    
    boolean update(User user) throws SQLException;
    
    boolean delete(Long id) throws SQLException;
    
    boolean hardDelete(Long id) throws SQLException;
    
    boolean usernameExists(String username) throws SQLException;
    
    boolean emailExists(String email) throws SQLException;
    
    int countAll() throws SQLException;
    
    int countActive() throws SQLException;
}
