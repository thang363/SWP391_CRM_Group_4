package dao.impl;

import dao.QuoteDetailDAO;
import model.entity.QuoteDetail;
import util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuoteDetailDAOImpl implements QuoteDetailDAO {

    private final DatabaseUtil dbUtil;

    public QuoteDetailDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public void create(QuoteDetail detail) {
        String sql = "INSERT INTO QuoteDetails (quote_id, product_id, quantity, unit_price, discount) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, detail.getQuoteId());
            ps.setInt(2, detail.getProductId());
            ps.setInt(3, detail.getQuantity());
            ps.setBigDecimal(4, detail.getUnitPrice());
            ps.setBigDecimal(5, detail.getDiscount());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<QuoteDetail> getByQuoteId(int quoteId) {
        List<QuoteDetail> list = new ArrayList<>();
        String sql = "SELECT qd.*, p.name as product_name " +
                     "FROM QuoteDetails qd " +
                     "JOIN Products p ON qd.product_id = p.id " +
                     "WHERE qd.quote_id = ?";
        
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quoteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuoteDetail qd = new QuoteDetail();
                    qd.setId(rs.getInt("id"));
                    qd.setQuoteId(rs.getInt("quote_id"));
                    qd.setProductId(rs.getInt("product_id"));
                    qd.setQuantity(rs.getInt("quantity"));
                    qd.setUnitPrice(rs.getBigDecimal("unit_price"));
                    qd.setDiscount(rs.getBigDecimal("discount"));
                    qd.setLineTotal(rs.getBigDecimal("line_total")); // Calculated column in DB
                    
                    qd.setProductName(rs.getString("product_name"));
                    list.add(qd);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
