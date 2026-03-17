/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.impl;

import dao.OpportunityDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.entity.Lead;
import model.entity.LeadNote;
import model.entity.Opportunity;
import util.DatabaseUtil;

/**
 *
 * @author ADMIN
 */
public class OpportunitiesDaoImpl implements OpportunityDAO {

    private final DatabaseUtil dbUtil;

    public OpportunitiesDaoImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public void createFromLead(int leadID, String leadName, int saleID) {

        String sql = """
        INSERT INTO Opportunities 
        (lead_id, name, stage, expected_value, sales_id,created_at)
        VALUES (?, ?, ?, ?, ?, GETDATE())
    """;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, leadID);

            // Tên cơ hội
            ps.setString(2, "Opportunity - " + leadName);

            // Stage mặc định
            ps.setString(3, "Prospecting");

            // Amount mặc định
            ps.setDouble(4, 0);

            // Gán cho sale giống lead
            ps.setInt(5, saleID);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
    }

    @Override
    public void createFromCustomer(int customerID, String companyName, int saleID) {
        String sql = """
            INSERT INTO Opportunities 
            (customer_id, name, stage, expected_value, sales_id, created_at)
            VALUES (?, ?, ?, ?, ?, GETDATE())
        """;
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = dbUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerID);
            ps.setString(2, "Đơn hàng - " + companyName);
            ps.setString(3, "Prospecting");
            ps.setDouble(4, 0);
            ps.setInt(5, saleID);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    @Override
    public List<Opportunity> getOpportunitiesBySalesId(int salesId) {
        List<Opportunity> list = new ArrayList<>();
        String sql = "SELECT * FROM Opportunities WHERE sales_id = ? ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, salesId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToOpportunity(rs));

            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return list;
    }

    @Override
    public List<Opportunity> getOpportunitiesWithQuoteCount(int salesId) {
        List<Opportunity> list = new ArrayList<>();
        String sql = """
            SELECT o.*, COUNT(q.id) AS quote_count
            FROM Opportunities o
            LEFT JOIN Quotes q ON q.opportunity_id = o.id
            WHERE o.sales_id = ?
            GROUP BY o.id, o.name, o.lead_id, o.customer_id, o.type,
                     o.expected_value, o.stage, o.probability, o.sales_id, o.created_at
            ORDER BY o.created_at DESC
        """;
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, salesId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Opportunity opp = mapResultSetToOpportunity(rs);
                    opp.setQuoteCount(rs.getInt("quote_count"));
                    list.add(opp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Opportunity getById(int id) {
        String sql = "SELECT * FROM Opportunities WHERE id = ?";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToOpportunity(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    
    @Override
    public void updateStage(int id, String stage, int probability) {

    String sql = """
        UPDATE Opportunities
        SET stage = ?, probability = ?
        WHERE id = ?
    """;

    try (Connection conn = dbUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, stage);
        ps.setInt(2, probability);
        ps.setInt(3, id);

        ps.executeUpdate();

    } catch (Exception e) {
        e.printStackTrace();
    }
}
    @Override
    public void updateOpportunityInfo(int id, String name) {
        String sql = "UPDATE Opportunities SET name = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = dbUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, ps, conn);
        }
    }

    private Opportunity mapResultSetToOpportunity(ResultSet rs) throws SQLException {

        Opportunity opp = new Opportunity();

        opp.setId(rs.getInt("id"));
        opp.setName(rs.getString("name"));

        opp.setLeadId(rs.getInt("lead_id"));

        // customer_id có thể NULL → dùng getObject
        Integer customerId = rs.getObject("customer_id", Integer.class);
        opp.setCustomerId(customerId);

        opp.setType(rs.getString("type"));

        // expected_value dùng BigDecimal
        opp.setExpectedValue(rs.getBigDecimal("expected_value"));

        opp.setStage(rs.getString("stage"));

        // probability có thể NULL
        Integer probability = rs.getObject("probability", Integer.class);
        opp.setProbability(probability);

        opp.setSalesId(rs.getInt("sales_id"));

        try {
            Timestamp ts = rs.getTimestamp("created_at");
            if (ts != null) {
                opp.setCreatedAt(ts.toLocalDateTime());
            }
        } catch (Exception ignored) {
        }

        return opp;
    }

    @Override
    public List<Opportunity> searchOpportunities(int salesId, String search, String stage) {
        StringBuilder sql = new StringBuilder("""
            SELECT o.*, COUNT(q.id) AS quote_count
            FROM Opportunities o
            LEFT JOIN Quotes q ON q.opportunity_id = o.id
            WHERE o.sales_id = ?
        """);
        List<Object> params = new ArrayList<>();
        params.add(salesId);

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND o.name LIKE ?");
            params.add("%" + search.trim() + "%");
        }

        if (stage != null && !stage.trim().isEmpty()) {
            sql.append(" AND o.stage = ?");
            params.add(stage.trim());
        }

        sql.append("""
            GROUP BY o.id, o.name, o.lead_id, o.customer_id, o.type,
                     o.expected_value, o.stage, o.probability, o.sales_id, o.created_at
            ORDER BY o.created_at DESC
        """);

        List<Opportunity> list = new ArrayList<>();
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Opportunity opp = mapResultSetToOpportunity(rs);
                    opp.setQuoteCount(rs.getInt("quote_count"));
                    list.add(opp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException e) {
        }
        try {
            if (stmt != null) {
                stmt.close();
            }
        } catch (SQLException e) {
        }
        dbUtil.closeConnection(conn);
    }

    public static void main(String[] args) {

        OpportunityDAO dao = new OpportunitiesDaoImpl();

        int oopid = 1;
       String stage = "Proposal";
       int p = 10;
       dao.updateStage(oopid, stage, p);

    }

}
