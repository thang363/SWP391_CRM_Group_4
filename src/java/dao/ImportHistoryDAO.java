package dao;

import model.entity.ImportHistory;
import java.util.List;

public interface ImportHistoryDAO {
    
    /**
     * Check if a file with this checksum has already been imported.
     * @param checksum MD5 checksum of the file
     * @return true if exists
     */
    boolean existsChecksum(String checksum);

    /**
     * Count number of imports by user today.
     * @param userId User ID
     * @return count
     */
    int countImportToday(int userId);

    /**
     * Insert import history record.
     * @param history Record to insert
     * @return true if success
     */
    boolean insert(ImportHistory history);
}
