package com.crm.dao.impl;

import com.crm.dao.UserDAO;
import com.crm.model.entity.Role;
import com.crm.model.entity.User;
import com.crm.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {
    
    private final DatabaseUtil dbUtil;
    
    public UserDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }
    
    @Override
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT id, username, password, email, full_name, phone, role, is_active, created_at, updated_at FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;
            
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public User findById(Long id) throws SQLException {
        String sql = "SELECT id, username, password, email, full_name, phone, role, is_active, created_at, updated_at FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;
            
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT id, username, password, email, full_name, phone, role, is_active, created_at, updated_at FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;
            
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public List<User> findAll() throws SQLException {
        String sql = "SELECT id, username, password, email, full_name, phone, role, is_active, created_at, updated_at FROM users ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<User> users = new ArrayList<>();
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            return users;
            
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public List<User> findAllActive() throws SQLException {
        String sql = "SELECT id, username, password, email, full_name, phone, role, is_active, created_at, updated_at FROM users WHERE is_active = 1 ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<User> users = new ArrayList<>();
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            return users;
            
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public User create(User user) throws SQLException {
        String sql = "INSERT INTO users (username, password, email, full_name, phone, role, is_active, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getFullName());
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getRole().getValue());
            stmt.setBoolean(7, user.getIsActive() != null ? user.getIsActive() : true);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }
            
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                user.setId(rs.getLong(1));
            }
            
            return user;
            
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public boolean update(User user) throws SQLException {
        String sql = "UPDATE users SET username = ?, password = ?, email = ?, full_name = ?, phone = ?, role = ?, is_active = ?, updated_at = GETDATE() WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getFullName());
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getRole().getValue());
            stmt.setBoolean(7, user.getIsActive() != null ? user.getIsActive() : true);
            stmt.setLong(8, user.getId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    @Override
    public boolean delete(Long id) throws SQLException {
        String sql = "UPDATE users SET is_active = 0, updated_at = GETDATE() WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, id);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    @Override
    public boolean hardDelete(Long id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, id);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    @Override
    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
            
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
            
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
            
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    @Override
    public int countActive() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE is_active = 1";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
            
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));
        user.setRole(Role.fromString(rs.getString("role")));
        user.setIsActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }
    
    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            System.err.println("Error closing ResultSet: " + e.getMessage());
        }
        
        try {
            if (stmt != null) stmt.close();
        } catch (SQLException e) {
            System.err.println("Error closing Statement: " + e.getMessage());
        }
        
        if (conn != null) {
            dbUtil.closeConnection(conn);
        }
    }
}
