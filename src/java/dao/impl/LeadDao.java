/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.impl;

import java.time.LocalDateTime;

import java.util.List;
import model.entity.Lead;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;

/**
 *
 * @author ADMIN
 */
public class LeadDao {

    private final DatabaseUtil dbUtil;

    public LeadDao(DatabaseUtil dbUtil) {
        this.dbUtil = dbUtil;
    }

    //get lead list by sale id
    public List<Lead> getLeadListBySaleID(long Sale_id) throws Exception {
        String sql = "SELECT \n"
                + "    l.id,\n"
                + "    l.full_name,\n"
                + "    l.email,\n"
                + "    l.phone,\n"
                + "    l.status,\n"
                + "    l.current_score,\n"
                + "    l.is_converted,\n"
                + "    l.created_at\n"
                + "FROM Leads l\n"
                + "WHERE l.assigned_to = ?;";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Lead> SaleList = new ArrayList<Lead>();

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, Sale_id);
            rs = stmt.executeQuery();
            while (rs.next()) {
                SaleList.add(mapResultSetToLead(rs));
            }
            return SaleList;
        } finally{
            closeResources(rs, stmt, conn);
        }

    }

    //
    public Lead mapResultSetToLead(ResultSet rs) throws Exception{
        Lead lead = new Lead();
        lead.setId(rs.getLong("id"));
        lead.setFullName(rs.getString("full_name"));
        lead.setEmail(rs.getString("email"));
        lead.setPhone(rs.getString("phone"));
        lead.setStatus(rs.getString("status"));
        lead.setCurrentScore(rs.getInt("current_score"));
        lead.setIsConverted(rs.getBoolean("is_converted"));
        Timestamp ts = rs.getTimestamp("created_at");
        lead.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
        return lead;
    }
    //
    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            System.err.println("Error closing ResultSet: " + e.getMessage());
        }
        
        try {
            if (stmt != null) stmt.close();
        } catch (SQLException e) {
            System.err.println("Error closing Statement: " + e.getMessage());
        }
        
        if (conn != null) {
            dbUtil.closeConnection(conn);
        }
    }

}
