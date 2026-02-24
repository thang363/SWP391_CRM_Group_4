/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.impl;

import dao.OpportunityDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.entity.Lead;
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
    public void createFromLead(int leadID,String leadName,long saleID) {

        String sql = """
        INSERT INTO Opportunities 
        (lead_id, name, stage, amount, assigned_to, created_at)
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
        }
    }
}
