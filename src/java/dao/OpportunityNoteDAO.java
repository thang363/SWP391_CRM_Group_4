package dao;

import java.util.List;
import model.entity.OpportunityNote;

public interface OpportunityNoteDAO {
    boolean createNote(OpportunityNote note);
    List<OpportunityNote> getNotesByOpportunityId(int opportunityId);
}
