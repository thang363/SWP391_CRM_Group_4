package dao;

import model.entity.LeadSource;
import java.util.List;

public interface LeadSourceDAO {
    /**
     * Get all sources.
     * @return List of sources
     */
    List<LeadSource> findAll();
    /**
     * Get LeadSource ID by name.
     * @param name Source name
     * @return ID or null if not found
     */
    Integer getIdByName(String name);

    /**
     * Insert new LeadSource.
     * @param name Source name
     * @return New ID or null if failed
     */
    Integer insert(String name);
}
