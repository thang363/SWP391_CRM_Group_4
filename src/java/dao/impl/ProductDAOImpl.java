package dao.impl;

import dao.ProductDAO;
import model.entity.Product;
import util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAOImpl implements ProductDAO {

    private final DatabaseUtil dbUtil;

    public ProductDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public List<Product> getAllActiveProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE is_active = 1";
        
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Product getById(int id) {
        String sql = "SELECT * FROM Products WHERE id = ?";
        
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setProductCode(rs.getString("product_code"));
        p.setName(rs.getString("name"));
        p.setCategory(rs.getString("category"));
        p.setUnitPrice(rs.getBigDecimal("unit_price"));
        p.setDescription(rs.getString("description"));
        p.setIsActive(rs.getBoolean("is_active"));
        return p;
    }
}
