package dao.impl;

import dao.CustomerDAO;
import model.entity.Customer;
import util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAOImpl implements CustomerDAO {

    private final DatabaseUtil dbUtil;

    public CustomerDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public List<Customer> searchCustomers(String keyword) {
        // Search by company name, email, or phone
        String sql = "SELECT id, company_name, email, phone FROM Customers WHERE company_name LIKE ? OR email LIKE ? OR phone LIKE ? LIMIT 20";
        // Note: SQL Server uses TOP instead of LIMIT. Updating to SQL Server syntax.
        sql = "SELECT TOP 20 id, company_name, email, phone FROM Customers WHERE company_name LIKE ? OR email LIKE ? OR phone LIKE ?";

        List<Customer> customers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            String pattern = "%" + keyword + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, pattern);

            rs = stmt.executeQuery();

            while (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("id"));
                c.setCompanyName(rs.getString("company_name"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                customers.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return customers;
    }

    @Override
    public Customer getCustomerById(int id) {
        String sql = "SELECT * FROM Customers WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("id"));
                c.setCompanyName(rs.getString("company_name"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setIndustry(rs.getString("industry"));
                c.setTier(rs.getString("tier"));
                c.setCity(rs.getString("city"));
                c.setCountry(rs.getString("country"));
                c.setWebsite(rs.getString("website"));
                c.setLastCareDate(rs.getTimestamp("last_care_date"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return null;
    }

    @Override
    public void createFromOpportunity(long opportunityId) throws Exception {
        String getDataSql = "SELECT l.full_name, l.email, l.phone, l.assigned_to, l.id as lead_id " +
                           "FROM Opportunities o " +
                           "JOIN Leads l ON o.lead_id = l.id " +
                           "WHERE o.id = ?";
        
        String checkExistingSql = "SELECT id FROM Customers WHERE lead_id = ? OR email = ?";
        
        String insertSql = "INSERT INTO Customers (company_name, email, phone, assigned_to, lead_id, status, last_care_date, created_at, updated_at) " +
                          "VALUES (?, ?, ?, ?, ?, 'Active', GETDATE(), GETDATE(), GETDATE())";
        
        String updateOppSql = "UPDATE Opportunities SET customer_id = ? WHERE id = ?";

        Connection conn = null;
        try {
            conn = dbUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Get lead data first
            String fullName = "";
            String email = "";
            String phone = "";
            Long assignedTo = null;
            Long leadId = null;

            try (PreparedStatement ps = conn.prepareStatement(getDataSql)) {
                ps.setLong(1, opportunityId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        fullName = rs.getString("full_name");
                        email = rs.getString("email");
                        phone = rs.getString("phone");
                        assignedTo = rs.getObject("assigned_to", Long.class);
                        leadId = rs.getLong("lead_id");
                    } else {
                        throw new Exception("Opportunity not found or Lead not linked.");
                    }
                }
            }

            // 2. Check if a customer with this lead_id or email already exists
            long customerId = -1;
            try (PreparedStatement ps = conn.prepareStatement(checkExistingSql)) {
                ps.setLong(1, leadId);
                ps.setString(2, (email != null && !email.isEmpty()) ? email : "NONE_EXISTENT_EMAIL_CHECK");
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        customerId = rs.getLong("id");
                    }
                }
            }

            // 3. If no existing customer, insert new one
            if (customerId == -1) {
                try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, (fullName != null && !fullName.isEmpty()) ? fullName : "Unknown Customer");
                    ps.setString(2, email);
                    ps.setString(3, phone);
                    if (assignedTo != null) ps.setLong(4, assignedTo); else ps.setNull(4, java.sql.Types.BIGINT);
                    ps.setLong(5, leadId);
                    
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            customerId = rs.getLong(1);
                        }
                    }
                }
            }

            // 4. Update Opportunity with customer_id if we have one (new or existing)
            if (customerId != -1) {
                try (PreparedStatement ps = conn.prepareStatement(updateOppSql)) {
                    ps.setLong(1, customerId);
                    ps.setLong(2, opportunityId);
                    ps.executeUpdate();
                }
            }

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                dbUtil.closeConnection(conn);
            }
        }
    }
    public boolean updateLastCareDate(int id, java.sql.Timestamp date) {
        String sql = "UPDATE Customers SET last_care_date = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setTimestamp(1, date);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);

        }
    }

    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null)
                rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (stmt != null)
                stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (conn != null)
            dbUtil.closeConnection(conn);
    }
}
