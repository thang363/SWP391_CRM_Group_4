package dao;

/**
 * Interface for Audit Log Database Operations
 */
public interface AuditDAO {
    void log(Long userId, String action, String entity, Long entityId);
}
