package dao.impl;

import dao.OpportunityNoteDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.entity.OpportunityNote;
import util.DatabaseUtil;

public class OpportunityNoteDAOImpl implements OpportunityNoteDAO {
    private final DatabaseUtil dbUtil ;

    public OpportunityNoteDAOImpl(DatabaseUtil dbUtil) {
        this.dbUtil = dbUtil;
    }
    
    

    @Override
    public boolean createNote(OpportunityNote note) {
        String sql = "INSERT INTO OpportunityNotes (opportunity_id, sales_id, note_content, note_type, is_important, old_stage, new_stage) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, note.getOpportunityId());
            ps.setInt(2, note.getSalesId());
            ps.setString(3, note.getNoteContent());
            ps.setString(4, note.getNoteType());
            ps.setBoolean(5, note.getIsImportant() != null ? note.getIsImportant() : false);
            ps.setString(6, note.getOldStage());
            ps.setString(7, note.getNewStage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<OpportunityNote> getNotesByOpportunityId(int opportunityId) {
        List<OpportunityNote> notes = new ArrayList<>();
        String sql = "SELECT n.*, u.full_name AS sales_name " +
                     "FROM OpportunityNotes n " +
                     "JOIN Users u ON n.sales_id = u.id " +
                     "WHERE n.opportunity_id = ? " +
                     "ORDER BY n.created_at DESC";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, opportunityId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OpportunityNote note = new OpportunityNote();
                    note.setId(rs.getInt("id"));
                    note.setOpportunityId(rs.getInt("opportunity_id"));
                    note.setSalesId(rs.getInt("sales_id"));
                    note.setNoteContent(rs.getString("note_content"));
                    note.setNoteType(rs.getString("note_type"));
                    note.setIsImportant(rs.getBoolean("is_important"));
                    note.setOldStage(rs.getString("old_stage"));
                    note.setNewStage(rs.getString("new_stage"));
                    
                    if (rs.getTimestamp("created_at") != null) {
                        note.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    if (rs.getTimestamp("updated_at") != null) {
                        note.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    }
                    note.setSalesName(rs.getString("sales_name"));
                    notes.add(note);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notes;
    }
}
