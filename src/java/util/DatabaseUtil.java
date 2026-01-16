package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

public class DatabaseUtil {
    
    private static DatabaseUtil instance;
    private BlockingQueue<Connection> connectionPool;
    private boolean initialized = false;
    
    private DatabaseUtil() {
    }
    
    public static synchronized DatabaseUtil getInstance() {
        if (instance == null) {
            instance = new DatabaseUtil();
        }
        return instance;
    }
    
    public synchronized void initialize() {
        if (initialized) {
            return;
        }
        
        try {
            Class.forName(Constants.DB_DRIVER);
            connectionPool = new ArrayBlockingQueue<>(Constants.DB_POOL_MAX_SIZE);
            
            for (int i = 0; i < Constants.DB_POOL_INITIAL_SIZE; i++) {
                connectionPool.offer(createNewConnection());
            }
            
            initialized = true;
            System.out.println("Database connection pool initialized with " + 
                    Constants.DB_POOL_INITIAL_SIZE + " connections");
            
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Database driver not found: " + e.getMessage(), e);
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize connection pool: " + e.getMessage(), e);
        }
    }
    
    public Connection getConnection() throws SQLException {
        if (!initialized) {
            initialize();
        }
        
        Connection conn = connectionPool.poll();
        
        if (conn == null || conn.isClosed()) {
            conn = createNewConnection();
        }
        
        return conn;
    }
    
    public void closeConnection(Connection conn) {
        if (conn == null) {
            return;
        }
        
        try {
            if (!conn.isClosed()) {
                conn.setAutoCommit(true);
                
                if (!connectionPool.offer(conn)) {
                    conn.close();
                }
            }
        } catch (SQLException e) {
            System.err.println("Error returning connection to pool: " + e.getMessage());
            try {
                conn.close();
            } catch (SQLException ex) {
            }
        }
    }
    
    private Connection createNewConnection() throws SQLException {
        return DriverManager.getConnection(
                Constants.DB_URL,
                Constants.DB_USERNAME,
                Constants.DB_PASSWORD
        );
    }
    
    public synchronized void shutdown() {
        if (!initialized) {
            return;
        }
        
        Connection conn;
        while ((conn = connectionPool.poll()) != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
        
        initialized = false;
        System.out.println("Database connection pool shutdown");
    }
    
    public boolean testConnection() {
        try {
            Connection conn = getConnection();
            boolean valid = conn != null && !conn.isClosed();
            closeConnection(conn);
            return valid;
        } catch (SQLException e) {
            System.err.println("Connection test failed: " + e.getMessage());
            return false;
        }
    }
    
    public int getPoolSize() {
        return connectionPool != null ? connectionPool.size() : 0;
    }
}
