package dao;

import model.entity.Campaign;
import model.viewmodel.CampaignPerformanceVM;
import java.sql.Timestamp;
import java.util.List;

/**
 * Data Access Object interface for Campaign entity
 */
public interface CampaignDAO {
    
    /**
     * Find campaign by ID
     * @param id Campaign ID
     * @return Campaign object or null if not found
     */
    Campaign findById(Integer id);
    
    /**
     * Find all campaigns
     * @return List of all campaigns
     */
    List<Campaign> findAll();
    
    /**
     * Find campaigns by filters with pagination
     * @param name Campaign name (partial match, can be null)
     * @param status Campaign status (can be null)
     * @param startDate Filter by start date (can be null)
     * @param endDate Filter by end date (can be null)
     * @param managerId Filter by manager ID (can be null)
     * @param offset Number of records to skip
     * @param limit Maximum number of records to return
     * @return List of filtered campaigns
     */
    List<Campaign> findByFilters(String name, String status, Timestamp startDate, Timestamp endDate, Integer managerId, int offset, int limit);
    
    /**
     * Count campaigns matching filters
     * @param name Campaign name (partial match, can be null)
     * @param status Campaign status (can be null)
     * @param startDate Filter by start date (can be null)
     * @param endDate Filter by end date (can be null)
     * @param managerId Filter by manager ID (can be null)
     * @return Count of matching campaigns
     */
    int countByFilters(String name, String status, Timestamp startDate, Timestamp endDate, Integer managerId);
    
    /**
     * Create new campaign
     * @param campaign Campaign object to create
     * @return Created campaign with generated ID
     */
    Campaign create(Campaign campaign);
    
    /**
     * Update existing campaign
     * @param campaign Campaign object with updated data
     * @return true if update successful, false otherwise
     */
    boolean update(Campaign campaign);
    
    /**
     * Delete campaign by ID
     * @param id Campaign ID to delete
     * @return true if delete successful, false otherwise
     */
    boolean delete(Integer id);
    
    /**
     * Count total campaigns
     * @return Total number of campaigns
     */
    int countAll();
    
    /**
     * Count campaigns by status
     * @param status Campaign status
     * @return Number of campaigns with given status
     */
    int countByStatus(String status);

    /**
     * Get marketing performance stats for campaigns where the marketing user created landing pages.
     * @param marketingId ID of the marketing user
     * @return List of campaign performance stats
     */
    List<CampaignPerformanceVM> getMarketingPerformance(Integer marketingId);
}
