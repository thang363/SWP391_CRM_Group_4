package dao;

import model.entity.LandingPage;
import java.util.List;

/**
 * Interface for Landing Page Data Access Object.
 * Handles database operations for LandingPages table.
 */
public interface LandingPageDAO {
    LandingPage findById(Integer id);
    LandingPage findByCampaignId(Integer campaignId);
    List<LandingPage> findAll();
    List<LandingPage> findByStatus(String status);
    
    LandingPage create(LandingPage landingPage);
    boolean update(LandingPage landingPage);
    boolean delete(Integer id);
    
    // Specific operations
    boolean updateStatus(Integer id, String status);
    boolean updateContent(Integer id, String dataConfig);
    
    // Multi-assignment support
    List<LandingPage> findAllByCampaignId(Integer campaignId);
}
