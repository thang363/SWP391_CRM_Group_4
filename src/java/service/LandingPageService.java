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
    boolean submitForApproval(Integer lpId);
    boolean approveLandingPage(Integer lpId, Integer managerId, String comment);
    boolean rejectLandingPage(Integer lpId, String managerId, String reason);
    
    // Public Facing
    String getRenderedHtml(Integer lpId);
}
