package dao.impl;

import dao.AttachmentDAO;
import model.entity.Attachment;
import util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AttachmentDAOImpl implements AttachmentDAO {

    private final DatabaseUtil dbUtil;

    public AttachmentDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public boolean saveAttachment(Attachment attachment) {
        String sql = "INSERT INTO Attachments (file_name, file_path, file_size, uploaded_by, related_to_entity, related_record_id, created_at) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, attachment.getFileName());
            stmt.setString(2, attachment.getFilePath());
            stmt.setLong(3, attachment.getFileSize());
            if (attachment.getUploadedBy() != null) {
                stmt.setInt(4, attachment.getUploadedBy());
            } else {
                stmt.setNull(4, java.sql.Types.INTEGER);
            }
            stmt.setString(5, attachment.getRelatedToEntity());
            stmt.setInt(6, attachment.getRelatedRecordId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (stmt != null)
                try {
                    stmt.close();
                } catch (SQLException e) {
                }
            if (conn != null)
                dbUtil.closeConnection(conn);
        }
    }

    @Override
    public List<Attachment> getByEntityAndRecordId(String entity, int recordId) {
        String sql = "SELECT id, file_name, file_path, file_size, uploaded_by, related_to_entity, related_record_id, created_at "
                +
                "FROM Attachments WHERE related_to_entity = ? AND related_record_id = ? ORDER BY created_at DESC";

        List<Attachment> attachments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, entity);
            stmt.setInt(2, recordId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Attachment att = new Attachment();
                att.setId(rs.getInt("id"));
                att.setFileName(rs.getString("file_name"));
                att.setFilePath(rs.getString("file_path"));
                att.setFileSize(rs.getLong("file_size"));
                int uploadedBy = rs.getInt("uploaded_by");
                if (!rs.wasNull()) {
                    att.setUploadedBy(uploadedBy);
                }
                att.setRelatedToEntity(rs.getString("related_to_entity"));
                att.setRelatedRecordId(rs.getInt("related_record_id"));
                att.setCreatedAt(rs.getTimestamp("created_at"));
                attachments.add(att);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
            } catch (SQLException e) {
            }
            try {
                if (stmt != null)
                    stmt.close();
            } catch (SQLException e) {
            }
            if (conn != null)
                dbUtil.closeConnection(conn);
        }

        return attachments;
    }
}
