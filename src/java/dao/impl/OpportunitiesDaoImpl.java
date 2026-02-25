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
    public void createFromLead(int leadID, String leadName, long saleID) {

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
            ps.setLong(5, saleID);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
    }

    @Override
    public List<Opportunity> getOpportunitiesBySalesId(long salesId) {
        List<Opportunity> list = new ArrayList<>();
        String sql = "SELECT * FROM Opportunities WHERE sales_id = ? ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, salesId);
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
    public void updateStage(long id, String stage, int probability) {

    String sql = """
        UPDATE Opportunities
        SET stage = ?, probability = ?
        WHERE id = ?
    """;

    try (Connection conn = dbUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, stage);
        ps.setInt(2, probability);
        ps.setLong(3, id);

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

        opp.setId(rs.getLong("id"));
        opp.setName(rs.getString("name"));

        opp.setLeadId(rs.getLong("lead_id"));

        // customer_id có thể NULL → dùng getObject
        Long customerId = rs.getObject("customer_id", Long.class);
        opp.setCustomerId(customerId);

        opp.setType(rs.getString("type"));

        // expected_value dùng BigDecimal
        opp.setExpectedValue(rs.getBigDecimal("expected_value"));

        opp.setStage(rs.getString("stage"));

        // probability có thể NULL
        Integer probability = rs.getObject("probability", Integer.class);
        opp.setProbability(probability);

        opp.setSalesId(rs.getLong("sales_id"));

        try {
            Timestamp ts = rs.getTimestamp("created_at");
            if (ts != null) {
                opp.setCreatedAt(ts.toLocalDateTime());
            }
        } catch (Exception ignored) {
        }

        return opp;
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
