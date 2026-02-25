package dao;

import model.entity.LeadSubmission;
import java.util.List;

/**
 * Data Access Object interface for Landing Page Submission entity
 */
public interface LeadSubmissionDAO {
    
    /**
     * Create new submission
     * @param submission Submission object to create
     * @return Created submission with generated ID
     */
    LeadSubmission create(LeadSubmission submission);
    
    /**
     * Find submission by ID
     * @param id Submission ID
     * @return LeadSubmission object or null if not found
     */
    LeadSubmission findById(Integer id);
    
    /**
     * Find all submissions for a specific landing page
     * @param landingPageId Landing Page ID
     * @return List of submissions for the landing page
     */
    List<LeadSubmission> findByLandingPageId(Integer landingPageId);

    /**
     * Find submissions with filters (for Management Screen)
     * @param keyword Search keyword (Name, Email, Phone)
     * @param campaignId Filter by Campaign
     * @param source Filter by Source (Landing Page or Import)
     * @param status Filter by Status
     * @param fromDate Filter by Date range
     * @param toDate Filter by Date range
     * @param offset Pagination offset
     * @param limit Pagination limit
     * @return List of submissions
     */
    List<LeadSubmission> findAll(String keyword, Integer campaignId, String source, String status, java.sql.Date fromDate, java.sql.Date toDate, int offset, int limit);
    
    /**
     * Count submissions for pagination
     */
    int count(String keyword, Integer campaignId, String source, String status, java.sql.Date fromDate, java.sql.Date toDate);

    /**
     * Delete submission by ID (Hard delete)
     * @param id Submission ID
     */
    void delete(Integer id);
    
    /**
     * Mark submission as processed
     * @param id Submission ID
     * @return true if update successful, false otherwise
     */
    boolean markAsProcessed(Integer id);

    /**
     * Count pending (unprocessed) submissions
     * @return Number of submissions with is_processed = 0
     */
    int countPending();

    /**
     * Count submissions submitted today
     * @return Number of submissions from today
     */
    int countToday();
    
    /**
     * Check if submission exists by email or phone.
     * @param email
     * @param phone
     * @return true if exists
     */
    boolean exists(String email, String phone);
}
