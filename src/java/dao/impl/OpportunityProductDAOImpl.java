package dao.impl;

import dao.OpportunityProductDAO;
import model.entity.OpportunityProduct;
import util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OpportunityProductDAOImpl implements OpportunityProductDAO {

    private final DatabaseUtil dbUtil;

    public OpportunityProductDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public void create(OpportunityProduct op) {
        String sql = "INSERT INTO OpportunityProducts (opportunity_id, product_id, quantity, sales_price) VALUES (?, ?, ?, ?)";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, op.getOpportunityId());
            ps.setInt(2, op.getProductId());
            ps.setInt(3, op.getQuantity());
            ps.setBigDecimal(4, op.getSalesPrice());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<OpportunityProduct> getByOpportunityId(int oppId) {
        List<OpportunityProduct> list = new ArrayList<>();
        String sql = "SELECT op.*, p.name as product_name " +
                     "FROM OpportunityProducts op " +
                     "JOIN Products p ON op.product_id = p.id " +
                     "WHERE op.opportunity_id = ?";
        
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, oppId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OpportunityProduct op = new OpportunityProduct();
                    op.setId(rs.getInt("id"));
                    op.setOpportunityId(rs.getInt("opportunity_id"));
                    op.setProductId(rs.getInt("product_id"));
                    op.setQuantity(rs.getInt("quantity"));
                    op.setSalesPrice(rs.getBigDecimal("sales_price"));
                    op.setTotalAmount(rs.getBigDecimal("total_amount"));
                    op.setProductName(rs.getString("product_name"));
                    list.add(op);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void delete(int id) {
        String sql = "DELETE FROM OpportunityProducts WHERE id = ?";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
