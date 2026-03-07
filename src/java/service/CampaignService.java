package service;

import model.entity.Campaign;
import java.sql.Timestamp;
import java.util.List;

/**
 * Service interface for Campaign business logic
 */
public interface CampaignService {
    
    /**
     * Get campaign by ID
     * @param id Campaign ID
     * @return Campaign object or null if not found
     */
    Campaign getCampaignById(Integer id);
    
    /**
     * Get all campaigns
     * @return List of all campaigns
     */
    List<Campaign> getAllCampaigns();
    
    /**
     * Search campaigns with filters and pagination
     * @param name Campaign name (partial match)
     * @param status Campaign status
     * @param startDate Filter by start date
     * @param endDate Filter by end date
     * @param managerId Filter by manager ID (null = no filter)
     * @param offset Number of records to skip
     * @param limit Maximum number of records to return
     * @return List of filtered campaigns
     */
    List<Campaign> searchCampaigns(String name, String status, Timestamp startDate, Timestamp endDate, Integer managerId, int offset, int limit);
    
    /**
     * Count campaigns with filters
     * @param name Campaign name (partial match)
     * @param status Campaign status
     * @param startDate Filter by start date
     * @param endDate Filter by end date
     * @param managerId Filter by manager ID (null = no filter)
     * @return Count of matching campaigns
     */
    int countCampaigns(String name, String status, Timestamp startDate, Timestamp endDate, Integer managerId);
    
    /**
     * Create new campaign
     * @param campaign Campaign to create
     * @return Created campaign with ID or null if validation fails
     */
    Campaign createCampaign(Campaign campaign);
    
    /**
     * Update existing campaign
     * @param campaign Campaign with updated data
     * @return true if update successful, false otherwise
     */
    boolean updateCampaign(Campaign campaign);
    
    /**
     * Delete campaign
     * @param id Campaign ID to delete
     * @return true if delete successful, false otherwise
     */
    boolean deleteCampaign(Integer id);
    
    /**
     * Validate campaign data
     * @param campaign Campaign to validate
     * @return Validation error message or null if valid
     */
    String validateCampaign(Campaign campaign);
    
    /**
     * Get total campaign count
     * @return Total number of campaigns
     */
    int getTotalCount();
    
    /**
     * Get campaign count by status
     * @param status Campaign status
     * @return Number of campaigns with given status
     */
    int getCountByStatus(String status);
}
