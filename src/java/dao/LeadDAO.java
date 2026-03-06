package dao;

import java.util.List;
import model.entity.Lead;

/**
 * Interface for Lead data access operations.
 */
public interface LeadDAO {
    
    /**
     * Get list of leads assigned to a specific sale staff.
     * @param saleId The ID of the sales staff
     * @return List of Leads
     */
    List<Lead> findBySaleId(long saleId);
    
    void updateLeadStatus(long leadId, String status);
    
    void markAsConverted(long leadId);

    /**
     * Check if a lead with the given email or phone already exists.
     * @param email Email to check
     * @param phone Phone to check
     * @param campaignId Campaign ID to check within
     * @return true if duplicate exists, false otherwise
     */
    boolean checkDuplicate(String email, String phone, Long campaignId);

    /**
     * Insert a new lead.
     * @param lead The Lead object to insert
     * @return true if insertion successful, false otherwise
     */
    boolean insert(Lead lead);

    /**
     * Find a lead by its ID.
     * @param id The ID of the lead
     * @return The Lead object if found, null otherwise
     */
    Lead findById(long id);

    /**

     * Update lead's basic info (name and phone).
     * @param id The ID of the lead
     * @param name New name
     * @param phone New phone
     */
    void updateLeadInfo(long id, String name, String phone);
    /*
     * Find leads by campaign ID that have email addresses.
     * @param campaignId The campaign ID
     * @return List of Leads with email
     */
    List<Lead> findByCampaignIdWithEmail(long campaignId);

    /**
     * Find all leads that have email addresses.
     * @return List of Leads with email
     */
    List<Lead> findAllWithEmail();


    /**
     * Search and filter leads.
     * @param saleId The ID of the sales staff
     * @param query Search query (name or email)
     * @param status Filter status
     * @return List of matched Leads
     */
    List<Lead> searchLeads(long saleId, String query, String status);

    /**
     * Records a lead interaction and updates the lead's score.
     * @param leadId ID of the lead
     * @param campaignId Optional campaign ID associated with the interaction
     * @param activityType Type of activity (e.g., 'Email Click')
     * @param details Additional details/notes
     * @param scoreChange Points to add/subtract
     * @return true if successful
     */
    boolean recordInteraction(long leadId, Integer campaignId, String activityType, String details, int scoreChange);

    /**
     * Update lead's total score.
     * @param leadId ID of the lead
     * @param newScore The new total score
     */
    void updateScore(long leadId, int newScore);
    
    /**
     * Get KPIs for monitor leads screen.
     * @param campaignId Campaign ID (null for all campaigns)
     * @return MonitorKPIsViewModel containing total, hot, unassigned leads and avg score
     */
    model.viewmodel.MonitorKPIsViewModel getMonitorKPIs(Long campaignId);
    
    /**
     * Get list of unassigned leads sorted by score descending (Hot leads first).
     * @param campaignId Campaign ID (null for all campaigns)
     * @param limit Maximum number of records to return
     * @return List of Hot Unassigned Leads
     */
    List<Lead> getHotUnassignedLeads(Long campaignId, int limit);
    
    /**
     * Get recent interactions for feed.
     * @param campaignId Campaign ID (null for all campaigns)
     * @param limit Maximum number of records to return
     * @return List of LeadInteractionViewModel
     */
    List<model.viewmodel.LeadInteractionViewModel> getRecentInteractions(Long campaignId, int limit);
    
    /**
     * Assign a lead to a sales staff.
     * @param leadId The ID of the lead
     * @param salesId The ID of the sales staff
     * @param managerId The ID of the manager assigning the lead
     * @return true if assignment is successful
     */
    boolean assignLeadToSales(long leadId, long salesId, long managerId);
}
