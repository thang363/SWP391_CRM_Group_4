package dao.impl;

import dao.LeadNoteDAO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.entity.LeadNote;
import util.DatabaseUtil;

public class LeadNoteDAOImpl implements LeadNoteDAO {

    private final DatabaseUtil dbUtil;

    public LeadNoteDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public List<LeadNote> findByLeadId(int leadId) {
        String sql = "SELECT * FROM LeadNotes WHERE lead_id = ? ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<LeadNote> list = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, leadId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToNote(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error finding notes for lead ID " + leadId + ": " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        return list;
    }

    @Override
    public boolean insert(LeadNote note) {
        String sql = "INSERT INTO LeadNotes (lead_id, sales_id, note_content, note_type, is_important, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, note.getLeadId());
            stmt.setInt(2, note.getSalesId());
            stmt.setString(3, note.getNoteContent());
            stmt.setString(4, note.getNoteType());
            stmt.setBoolean(5, note.getIsImportant() != null ? note.getIsImportant() : false);
            stmt.setTimestamp(6, Timestamp.valueOf(note.getCreatedAt()));

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error inserting lead note: " + e.getMessage());
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    private LeadNote mapResultSetToNote(ResultSet rs) throws SQLException {
        LeadNote note = new LeadNote();
        note.setId(rs.getInt("id"));
        note.setLeadId(rs.getInt("lead_id"));
        note.setSalesId(rs.getInt("sales_id"));
        note.setNoteContent(rs.getString("note_content"));
        note.setNoteType(rs.getString("note_type"));
        note.setIsImportant(rs.getBoolean("is_important"));
        
        try {
            Timestamp ts = rs.getTimestamp("created_at");
            if (ts != null) note.setCreatedAt(ts.toLocalDateTime());
        } catch (Exception ignored) {}
        
        try {
            Timestamp ts = rs.getTimestamp("updated_at");
            if (ts != null) note.setUpdatedAt(ts.toLocalDateTime());
        } catch (Exception ignored) {}
        
        return note;
    }

    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {}
        try {
            if (stmt != null) stmt.close();
        } catch (SQLException e) {}
        dbUtil.closeConnection(conn);
    }
    
    //new update here
}
