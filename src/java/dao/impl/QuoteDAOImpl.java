package dao.impl;

import dao.QuoteDAO;
import model.entity.Quote;
import util.DatabaseUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class QuoteDAOImpl implements QuoteDAO {

    private final DatabaseUtil dbUtil;

    public QuoteDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public List<Quote> getByOpportunityId(int opportunityId) {
        List<Quote> list = new ArrayList<>();
        String sql = "SELECT * FROM Quotes WHERE opportunity_id = ? ORDER BY created_at DESC";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, opportunityId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Quote getById(int id) {
        String sql = "SELECT q.*, o.name AS opportunity_name FROM Quotes q " +
                     "JOIN Opportunities o ON q.opportunity_id = o.id WHERE q.id = ?";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Quote q = mapRow(rs);
                    q.setOpportunityName(rs.getString("opportunity_name"));
                    return q;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int create(int opportunityId, String subject, BigDecimal grandTotal, LocalDate validUntil, int createdBy) {
        // Tạo quote_number tự động: Q-{oppId}-{timestamp}
        String quoteNumber = "Q-" + opportunityId + "-" + System.currentTimeMillis();
        String sql = "INSERT INTO Quotes (opportunity_id, quote_number, subject, subtotal, discount_amount, tax_amount, grand_total, status, valid_until, created_by, created_at) " +
                     "VALUES (?, ?, ?, ?, 0, 0, ?, 'Draft', ?, ?, GETDATE()); SELECT SCOPE_IDENTITY();";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, opportunityId);
            ps.setString(2, quoteNumber);
            ps.setString(3, subject);
            ps.setBigDecimal(4, grandTotal);
            ps.setBigDecimal(5, grandTotal);
            if (validUntil != null) {
                ps.setDate(6, Date.valueOf(validUntil));
            } else {
                ps.setNull(6, Types.DATE);
            }
            ps.setInt(7, createdBy);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    @Override
    public void send(int quoteId) {
        String sql = "UPDATE Quotes SET status = 'Sent' WHERE id = ? AND status = 'Draft'";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quoteId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void accept(int quoteId, int opportunityId) {
        // Thực hiện trong 1 transaction: Quote=Accepted, Opportunity=Won + Update Value
        Connection conn = null;
        try {
            conn = dbUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Lấy giá trị Quote để cập nhật cho Opportunity
            BigDecimal grandTotal = BigDecimal.ZERO;
            try (PreparedStatement ps = conn.prepareStatement("SELECT grand_total FROM Quotes WHERE id = ?")) {
                ps.setInt(1, quoteId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        grandTotal = rs.getBigDecimal("grand_total");
                    }
                }
            }

            // 2. Chấp nhận quote
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE Quotes SET status = 'Accepted' WHERE id = ? AND status = 'Sent'")) {
                ps.setInt(1, quoteId);
                ps.executeUpdate();
            }

            // 3. Set Opportunity = Won và cập nhật giá trị
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE Opportunities SET stage = 'Won', probability = 100, expected_value = ? WHERE id = ?")) {
                ps.setBigDecimal(1, grandTotal);
                ps.setInt(2, opportunityId);
                ps.executeUpdate();
            }

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
                dbUtil.closeConnection(conn);
            }
        }
    }

    @Override
    public void reject(int quoteId) {
        String sql = "UPDATE Quotes SET status = 'Rejected' WHERE id = ? AND status = 'Sent'";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quoteId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int quoteId) {
        String sql = "DELETE FROM Quotes WHERE id = ? AND status = 'Draft'";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quoteId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean hasActiveSent(int opportunityId) {
        String sql = "SELECT COUNT(*) FROM Quotes WHERE opportunity_id = ? AND status = 'Sent'";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, opportunityId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Quote mapRow(ResultSet rs) throws SQLException {
        Quote q = new Quote();
        q.setId(rs.getInt("id"));
        q.setOpportunityId(rs.getInt("opportunity_id"));
        q.setQuoteNumber(rs.getString("quote_number"));
        q.setSubject(rs.getString("subject"));
        q.setSubtotal(rs.getBigDecimal("subtotal"));
        q.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        q.setTaxAmount(rs.getBigDecimal("tax_amount"));
        q.setGrandTotal(rs.getBigDecimal("grand_total"));
        q.setStatus(rs.getString("status"));

        Date validUntil = rs.getDate("valid_until");
        if (validUntil != null) q.setValidUntil(validUntil.toLocalDate());

        Integer createdBy = rs.getObject("created_by", Integer.class);
        if (createdBy != null) q.setCreatedBy(createdBy);

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) q.setCreatedAt(createdAt.toLocalDateTime());

        return q;
    }
}
