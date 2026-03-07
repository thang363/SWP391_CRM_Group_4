package dao.impl;

import dao.CampaignTransferDAO;
import model.entity.CampaignTransfer;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of CampaignTransferDAO
 */
public class CampaignTransferDAOImpl implements CampaignTransferDAO {

    private final DatabaseUtil dbUtil;

    public CampaignTransferDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public Integer insert(CampaignTransfer transfer) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "INSERT INTO CampaignTransfers (campaign_id, from_manager_id, to_manager_id, " +
                    "transfer_status, transfer_reason, notes, requested_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, transfer.getCampaignId());
            stmt.setInt(2, transfer.getFromManagerId());
            stmt.setInt(3, transfer.getToManagerId());
            stmt.setString(4, transfer.getTransferStatus());
            stmt.setString(5, transfer.getTransferReason());
            stmt.setString(6, transfer.getNotes());
            stmt.setTimestamp(7, transfer.getRequestedAt());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    Integer id = rs.getInt(1);
                    transfer.setId(id);
                    return id;
                }
            }
            return null;

        } catch (SQLException e) {
            System.err.println("Error inserting campaign transfer: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    @Override
    public void update(CampaignTransfer transfer) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "UPDATE CampaignTransfers SET transfer_status = ?, responded_at = ?, " +
                    "response_notes = ?, notes = ? WHERE id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, transfer.getTransferStatus());
            stmt.setTimestamp(2, transfer.getRespondedAt());
            stmt.setString(3, transfer.getResponseNotes());
            stmt.setString(4, transfer.getNotes());
            stmt.setInt(5, transfer.getId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error updating campaign transfer: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    @Override
    public CampaignTransfer findById(Integer id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT ct.*, " +
                    "c.name as campaign_name, c.budget as campaign_budget, " +
                    "u_from.full_name as from_manager_name, " +
                    "u_to.full_name as to_manager_name " +
                    "FROM CampaignTransfers ct " +
                    "JOIN Campaigns c ON ct.campaign_id = c.id " +
                    "JOIN Users u_from ON ct.from_manager_id = u_from.id " +
                    "JOIN Users u_to ON ct.to_manager_id = u_to.id " +
                    "WHERE ct.id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToTransfer(rs);
            }
            return null;

        } catch (SQLException e) {
            System.err.println("Error finding transfer by ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    @Override
    public boolean hasPendingTransfer(Integer campaignId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM CampaignTransfers " +
                    "WHERE campaign_id = ? AND transfer_status = 'Pending'";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, campaignId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;

        } catch (SQLException e) {
            System.err.println("Error checking pending transfer: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    @Override
    public CampaignTransfer findPendingByCampaignId(Integer campaignId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT ct.*, " +
                    "c.name as campaign_name, c.budget as campaign_budget, " +
                    "u_from.full_name as from_manager_name, " +
                    "u_to.full_name as to_manager_name " +
                    "FROM CampaignTransfers ct " +
                    "JOIN Campaigns c ON ct.campaign_id = c.id " +
                    "JOIN Users u_from ON ct.from_manager_id = u_from.id " +
                    "JOIN Users u_to ON ct.to_manager_id = u_to.id " +
                    "WHERE ct.campaign_id = ? AND ct.transfer_status = 'Pending'";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, campaignId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToTransfer(rs);
            }
            return null;

        } catch (SQLException e) {
            System.err.println("Error finding pending transfer by campaign ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<CampaignTransfer> findPendingTransfersByRecipient(Integer managerId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<CampaignTransfer> transfers = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT ct.*, " +
                    "c.name as campaign_name, c.budget as campaign_budget, " +
                    "u_from.full_name as from_manager_name, " +
                    "u_to.full_name as to_manager_name " +
                    "FROM CampaignTransfers ct " +
                    "JOIN Campaigns c ON ct.campaign_id = c.id " +
                    "JOIN Users u_from ON ct.from_manager_id = u_from.id " +
                    "JOIN Users u_to ON ct.to_manager_id = u_to.id " +
                    "WHERE ct.to_manager_id = ? AND ct.transfer_status = 'Pending' " +
                    "ORDER BY ct.requested_at DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, managerId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                transfers.add(mapResultSetToTransfer(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error finding pending transfers by recipient: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return transfers;
    }

    @Override
    public List<CampaignTransfer> findPendingTransfersBySender(Integer managerId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<CampaignTransfer> transfers = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT ct.*, " +
                    "c.name as campaign_name, c.budget as campaign_budget, " +
                    "u_from.full_name as from_manager_name, " +
                    "u_to.full_name as to_manager_name " +
                    "FROM CampaignTransfers ct " +
                    "JOIN Campaigns c ON ct.campaign_id = c.id " +
                    "JOIN Users u_from ON ct.from_manager_id = u_from.id " +
                    "JOIN Users u_to ON ct.to_manager_id = u_to.id " +
                    "WHERE ct.from_manager_id = ? AND ct.transfer_status = 'Pending' " +
                    "ORDER BY ct.requested_at DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, managerId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                transfers.add(mapResultSetToTransfer(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error finding pending transfers by sender: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return transfers;
    }

    @Override
    public List<CampaignTransfer> findRecentTransfersBySender(Integer managerId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<CampaignTransfer> transfers = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT ct.*, " +
                    "c.name as campaign_name, c.budget as campaign_budget, " +
                    "u_from.full_name as from_manager_name, " +
                    "u_to.full_name as to_manager_name " +
                    "FROM CampaignTransfers ct " +
                    "JOIN Campaigns c ON ct.campaign_id = c.id " +
                    "JOIN Users u_from ON ct.from_manager_id = u_from.id " +
                    "JOIN Users u_to ON ct.to_manager_id = u_to.id " +
                    "WHERE ct.from_manager_id = ? AND (ct.transfer_status = 'Pending' OR ct.transfer_status = 'Rejected') " +
                    "ORDER BY ct.requested_at DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, managerId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                transfers.add(mapResultSetToTransfer(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error finding recent transfers by sender: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return transfers;
    }

    @Override
    public List<CampaignTransfer> findHistoryByCampaign(Integer campaignId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<CampaignTransfer> transfers = new ArrayList<>();

        try {
            conn = dbUtil.getConnection();
            String sql = "SELECT ct.*, " +
                    "c.name as campaign_name, c.budget as campaign_budget, " +
                    "u_from.full_name as from_manager_name, " +
                    "u_to.full_name as to_manager_name " +
                    "FROM CampaignTransfers ct " +
                    "JOIN Campaigns c ON ct.campaign_id = c.id " +
                    "JOIN Users u_from ON ct.from_manager_id = u_from.id " +
                    "JOIN Users u_to ON ct.to_manager_id = u_to.id " +
                    "WHERE ct.campaign_id = ? " +
                    "ORDER BY ct.requested_at DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, campaignId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                transfers.add(mapResultSetToTransfer(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error finding transfer history: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return transfers;
    }

    private CampaignTransfer mapResultSetToTransfer(ResultSet rs) throws SQLException {
        CampaignTransfer transfer = new CampaignTransfer();
        transfer.setId(rs.getInt("id"));
        transfer.setCampaignId(rs.getInt("campaign_id"));
        transfer.setFromManagerId(rs.getInt("from_manager_id"));
        transfer.setToManagerId(rs.getInt("to_manager_id"));
        transfer.setTransferStatus(rs.getString("transfer_status"));
        transfer.setTransferReason(rs.getString("transfer_reason"));
        transfer.setNotes(rs.getString("notes"));
        transfer.setRequestedAt(rs.getTimestamp("requested_at"));
        transfer.setRespondedAt(rs.getTimestamp("responded_at"));
        transfer.setResponseNotes(rs.getString("response_notes"));

        // Map auxiliary fields
        transfer.setCampaignName(rs.getString("campaign_name"));
        transfer.setFromManagerName(rs.getString("from_manager_name"));
        transfer.setToManagerName(rs.getString("to_manager_name"));
        transfer.setCampaignBudget(rs.getBigDecimal("campaign_budget"));

        return transfer;
    }

    /**
     * Close database resources
     */
    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("Error closing ResultSet: " + e.getMessage());
            }
        }

        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }

        if (conn != null) {
            dbUtil.closeConnection(conn);
        }
    }
}
