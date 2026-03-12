package service;

import model.entity.LandingPage;
import java.util.List;

/**
 * Interface for Landing Page Service.
 * Handles business logic for Landing Page workflow.
 */
public interface LandingPageService {
    
    // Basic CRUD
    LandingPage getLandingPageById(Integer id);
    LandingPage getLandingPageByCampaignId(Integer campaignId);
    
    // Workflow Actions
    LandingPage createDraft(Integer campaignId, Integer createdBy);
    boolean assignMarketing(Integer campaignId, Integer marketingId, String brief);
    
    boolean saveContent(Integer lpId, String dataConfig);
    
    // Public Facing
    /**
     * Update landing page content.
     */
    boolean updateLandingPage(Integer id, String name, String brief, java.util.Map<String, String> contentFields, boolean isManager);
    
    boolean updateStatus(Integer id, String status);
    
    /**
     * Update status with manager comment
     * @param id LP ID
     * @param status New Status
     * @param comment Manager's comment
     * @return true if success
     */
    boolean updateStatus(Integer id, String status, String comment);

    String getRenderedHtml(Integer lpId);
}
