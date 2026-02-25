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
    
    void updateLeadStatus(int leadId, String status);
    
    void markAsConverted(int leadId);

    /**
     * Check if a lead with the given email or phone already exists.
     * @param email Email to check
     * @param phone Phone to check
     * @return true if duplicate exists, false otherwise
     */
    boolean checkDuplicate(String email, String phone);

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
    void updateLeadInfo(int id, String name, String phone);
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

}
