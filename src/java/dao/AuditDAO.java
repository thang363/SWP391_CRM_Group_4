package dao;

/**
 * Interface for Audit Log Database Operations
 */
public interface AuditDAO {
    void log(Integer userId, String action, String entity, Integer entityId);
}
