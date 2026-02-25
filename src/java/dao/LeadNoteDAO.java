package dao;

import java.util.List;
import model.entity.LeadNote;

/**
 * Data Access Object for LeadNote operations.
 */
public interface LeadNoteDAO {
    
    /**
     * Finds all interaction notes for a specific lead.
     * @param leadId The ID of the lead
     * @return List of LeadNote objects
     */
    List<LeadNote> findByLeadId(int leadId);
    
    /**
     * Inserts a new interaction note.
     * @param note The LeadNote object to insert
     * @return true if successful, false otherwise
     */
    boolean insert(LeadNote note);
}
