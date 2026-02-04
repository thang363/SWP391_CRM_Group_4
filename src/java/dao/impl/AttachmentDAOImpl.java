package dao.impl;

import dao.AttachmentDAO;
import model.entity.Attachment;
import util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

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
}
