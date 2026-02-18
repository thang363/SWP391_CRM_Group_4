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
}
