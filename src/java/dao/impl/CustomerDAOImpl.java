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

/**
 * Lớp triển khai của giao diện CustomerDAO.
 * Chủ yếu xử lý các thao tác CRUD phức tạp, thực hiện JOIN bảng, và kiểm tra
 * ràng buộc
 * đối với bảng 'Customers' trên SQL Server.
 */
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
                return mapCustomer(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return null;
    }

    @Override
    public Customer findCustomerByEmail(String email) {
        if (email == null || email.trim().isEmpty())
            return null;

        String sql = "SELECT * FROM Customers WHERE email = ?";
        try (Connection conn = dbUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapCustomer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Phương thức đặc biệt: Tự động chuyển đổi và tạo hồ sơ Khách hàng (Customer)
     * từ một Cơ Hội (Opportunity) đã chốt/thành công.
     * Sử dụng cấu trúc Transaction nhiều bước nhằm bảo toàn vẹn dữ liệu và tránh
     * trùng lặp.
     */
    @Override
    public void createFromOpportunity(int opportunityId) throws Exception {
        // Bước 1: Câu lệnh SQL để lấy các dữ liệu cơ sở từ khách hàng tiềm năng
        String getDataSql = "SELECT l.full_name, l.email, l.phone, l.assigned_to, l.id as lead_id " +
                "FROM Opportunities o " +
                "JOIN Leads l ON o.lead_id = l.id " +
                "WHERE o.id = ?";

        String checkExistingSql = "SELECT id FROM Customers WHERE lead_id = ? OR email = ?";

        String insertSql = "INSERT INTO Customers (company_name, email, phone, assigned_to, lead_id, status, last_care_date, created_at, updated_at) "
                +
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
            Integer assignedTo = null;
            Integer leadId = null;

            try (PreparedStatement ps = conn.prepareStatement(getDataSql)) {
                ps.setInt(1, opportunityId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        fullName = rs.getString("full_name");
                        email = rs.getString("email");
                        phone = rs.getString("phone");
                        assignedTo = rs.getObject("assigned_to", Integer.class);
                        leadId = rs.getInt("lead_id");
                    } else {
                        throw new Exception("Opportunity not found or Lead not linked.");
                    }
                }
            }

            // 2. Check if a customer with this lead_id or email already exists
            int customerId = -1;
            try (PreparedStatement ps = conn.prepareStatement(checkExistingSql)) {
                ps.setInt(1, leadId);
                ps.setString(2, (email != null && !email.isEmpty()) ? email : "NONE_EXISTENT_EMAIL_CHECK");
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        customerId = rs.getInt("id");
                    }
                }
            }

            // 3. If no existing customer, insert new one
            if (customerId == -1) {
                try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, (fullName != null && !fullName.isEmpty()) ? fullName : "Unknown Customer");
                    ps.setString(2, email);
                    ps.setString(3, phone);
                    if (assignedTo != null)
                        ps.setInt(4, assignedTo);
                    else
                        ps.setNull(4, java.sql.Types.INTEGER);
                    ps.setInt(5, leadId);

                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            customerId = rs.getInt(1);
                        }
                    }
                }
            }

            // 4. Update Opportunity with customer_id if we have one (new or existing)
            if (customerId != -1) {
                try (PreparedStatement ps = conn.prepareStatement(updateOppSql)) {
                    ps.setInt(1, customerId);
                    ps.setInt(2, opportunityId);
                    ps.executeUpdate();
                }
            }

            conn.commit();
        } catch (Exception e) {
            if (conn != null)
                conn.rollback();
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

    @Override
    public List<Customer> getAllCustomers() {
        String sql = "SELECT * FROM Customers ORDER BY id DESC";
        List<Customer> customers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                customers.add(mapCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return customers;
    }

    @Override
    public List<Customer> getCustomers(int offset, int limit, String searchQuery, String tierFilter,
            String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT * FROM Customers WHERE 1=1 ");
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (company_name LIKE ? OR email LIKE ? OR phone LIKE ?) ");
        }
        if (tierFilter != null && !tierFilter.trim().isEmpty() && !tierFilter.equals("All")) {
            sql.append("AND tier = ? ");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("All")) {
            sql.append("AND status = ? ");
        }
        sql.append("ORDER BY id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        List<Customer> customers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String pattern = "%" + searchQuery.trim() + "%";
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
            }
            if (tierFilter != null && !tierFilter.trim().isEmpty() && !tierFilter.equals("All")) {
                stmt.setString(paramIndex++, tierFilter);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("All")) {
                stmt.setString(paramIndex++, statusFilter);
            }
            stmt.setInt(paramIndex++, offset);
            stmt.setInt(paramIndex++, limit);

            rs = stmt.executeQuery();
            while (rs.next()) {
                customers.add(mapCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return customers;
    }

    @Override
    public List<Customer> getCustomersBySalesId(int salesId, int offset, int limit, String searchQuery,
            String tierFilter, String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT * FROM Customers WHERE assigned_to = ? ");
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (company_name LIKE ? OR email LIKE ? OR phone LIKE ?) ");
        }
        if (tierFilter != null && !tierFilter.trim().isEmpty() && !tierFilter.equals("All")) {
            sql.append("AND tier = ? ");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("All")) {
            sql.append("AND status = ? ");
        }
        sql.append("ORDER BY id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        List<Customer> customers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            stmt.setInt(paramIndex++, salesId);

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String pattern = "%" + searchQuery.trim() + "%";
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
            }
            if (tierFilter != null && !tierFilter.trim().isEmpty() && !tierFilter.equals("All")) {
                stmt.setString(paramIndex++, tierFilter);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("All")) {
                stmt.setString(paramIndex++, statusFilter);
            }
            stmt.setInt(paramIndex++, offset);
            stmt.setInt(paramIndex++, limit);

            rs = stmt.executeQuery();
            while (rs.next()) {
                customers.add(mapCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return customers;
    }

    @Override
    public int getTotalCustomersCountBySalesId(int salesId, String searchQuery, String tierFilter,
            String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Customers WHERE assigned_to = ? ");
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (company_name LIKE ? OR email LIKE ? OR phone LIKE ?) ");
        }
        if (tierFilter != null && !tierFilter.trim().isEmpty() && !tierFilter.equals("All")) {
            sql.append("AND tier = ? ");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("All")) {
            sql.append("AND status = ? ");
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int count = 0;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            stmt.setInt(paramIndex++, salesId);

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String pattern = "%" + searchQuery.trim() + "%";
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
            }
            if (tierFilter != null && !tierFilter.trim().isEmpty() && !tierFilter.equals("All")) {
                stmt.setString(paramIndex++, tierFilter);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("All")) {
                stmt.setString(paramIndex++, statusFilter);
            }

            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return count;
    }

    @Override
    public int getTotalCustomersCount(String searchQuery, String tierFilter, String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Customers WHERE 1=1 ");
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (company_name LIKE ? OR email LIKE ? OR phone LIKE ?) ");
        }
        if (tierFilter != null && !tierFilter.trim().isEmpty() && !tierFilter.equals("All")) {
            sql.append("AND tier = ? ");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("All")) {
            sql.append("AND status = ? ");
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int count = 0;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String pattern = "%" + searchQuery.trim() + "%";
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
            }
            if (tierFilter != null && !tierFilter.trim().isEmpty() && !tierFilter.equals("All")) {
                stmt.setString(paramIndex++, tierFilter);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("All")) {
                stmt.setString(paramIndex++, statusFilter);
            }

            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return count;
    }

    @Override
    public boolean createCustomer(Customer customer) {
        String sql = "INSERT INTO Customers (company_name, tax_code, website, industry, number_of_employees, phone, email, billing_address, shipping_address, city, country, tier, status, founded_date, created_at, updated_at) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, customer.getCompanyName());
            stmt.setString(2, customer.getTaxCode());
            stmt.setString(3, customer.getWebsite());
            stmt.setString(4, customer.getIndustry());
            if (customer.getNumberOfEmployees() != null) {
                stmt.setInt(5, customer.getNumberOfEmployees());
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);
            }
            stmt.setString(6, customer.getPhone());
            stmt.setString(7, customer.getEmail());
            stmt.setString(8, customer.getBillingAddress());
            stmt.setString(9, customer.getShippingAddress());
            stmt.setString(10, customer.getCity());
            stmt.setString(11, customer.getCountry());
            stmt.setString(12, customer.getTier() != null ? customer.getTier() : "Standard");
            stmt.setString(13, customer.getStatus() != null ? customer.getStatus() : "Active");
            if (customer.getFoundedDate() != null) {
                stmt.setDate(14, customer.getFoundedDate());
            } else {
                stmt.setNull(14, java.sql.Types.DATE);
            }
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }
        return false;
    }

    @Override
    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE Customers SET company_name=?, tax_code=?, website=?, industry=?, number_of_employees=?, phone=?, email=?, billing_address=?, shipping_address=?, city=?, country=?, status=?, tier=?, founded_date=?, updated_at=GETDATE() WHERE id=?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, customer.getCompanyName());
            stmt.setString(2, customer.getTaxCode());
            stmt.setString(3, customer.getWebsite());
            stmt.setString(4, customer.getIndustry());
            if (customer.getNumberOfEmployees() != null) {
                stmt.setInt(5, customer.getNumberOfEmployees());
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);
            }
            stmt.setString(6, customer.getPhone());
            stmt.setString(7, customer.getEmail());
            stmt.setString(8, customer.getBillingAddress());
            stmt.setString(9, customer.getShippingAddress());
            stmt.setString(10, customer.getCity());
            stmt.setString(11, customer.getCountry());
            stmt.setString(12, customer.getStatus());
            stmt.setString(13, customer.getTier());
            if (customer.getFoundedDate() != null) {
                stmt.setDate(14, customer.getFoundedDate());
            } else {
                stmt.setNull(14, java.sql.Types.DATE);
            }
            stmt.setInt(15, customer.getId());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }
        return false;
    }

    /**
     * Xóa một Khách Hàng khỏi hệ thống bằng ID.
     * Chú ý: Thao tác này sẽ hiển nhiên dính lỗi SQLException nếu khách hàng này đã
     * bị gán khóa ngoại như
     * Liên Hệ (Contacts), Hỗ trợ (Tickets) hoặc Đánh Giá (Reviews) trừ khi DB có
     * bật CASCADE.
     */
    @Override
    public boolean deleteCustomer(int id) {
        String sql = "DELETE FROM Customers WHERE id=?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }
        return false;
    }

    @Override
    public boolean setCustomerTier(int id, String tier) {
        String sql = "UPDATE Customers SET tier=? WHERE id=?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, tier);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }
        return false;
    }

    /**
     * Thực thi chuỗi logic phức tạp nhằm Trộn/Gộp một khách hàng trùng lặp vào một
     * khách hàng chính thống.
     * Kích hoạt một Transaction thủ công (AutoCommit = false) đảm bảo mọi Cập Nhật
     * phải thành công cùng lúc.
     * 1. Điều chuyển Cơ Hội (Opportunities)
     * 2. Điều chuyển Liên Hệ (Contacts)
     * 3. Điều chuyển Yêu cầu hỗ trợ (Tickets)
     * 4. Điều chuyển Phản hồi (CustomerReviews)
     * 5. Xóa bỏ khách hàng Trùng lặp
     * 
     * @return true khi Transaction toàn vẹn, false nếu bị Hủy (rollback) gia chừng.
     */
    @Override
    public boolean mergeCustomers(int primaryId, int duplicateId) {
        Connection conn = null;
        PreparedStatement stmt1 = null;
        PreparedStatement stmt2 = null;
        PreparedStatement stmt3 = null;
        PreparedStatement stmt4 = null;
        try {
            conn = dbUtil.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Khởi chạy Transaction

            // Update Opportunities
            stmt1 = conn.prepareStatement("UPDATE Opportunities SET customer_id=? WHERE customer_id=?");
            stmt1.setInt(1, primaryId);
            stmt1.setInt(2, duplicateId);
            stmt1.executeUpdate();

            // Update Contacts
            stmt2 = conn.prepareStatement("UPDATE Contacts SET customer_id=? WHERE customer_id=?");
            stmt2.setInt(1, primaryId);
            stmt2.setInt(2, duplicateId);
            stmt2.executeUpdate();

            // Update Tickets
            stmt3 = conn.prepareStatement("UPDATE Tickets SET customer_id=? WHERE customer_id=?");
            stmt3.setInt(1, primaryId);
            stmt3.setInt(2, duplicateId);
            stmt3.executeUpdate();

            // Update CustomerReviews
            stmt4 = conn.prepareStatement("UPDATE CustomerReviews SET customer_id=? WHERE customer_id=?");
            stmt4.setInt(1, primaryId);
            stmt4.setInt(2, duplicateId);
            stmt4.executeUpdate();

            // Delete Duplicate Customer
            PreparedStatement stmt5 = conn.prepareStatement("DELETE FROM Customers WHERE id=?");
            stmt5.setInt(1, duplicateId);
            stmt5.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            closeResources(null, stmt4, null);
            closeResources(null, stmt3, null);
            closeResources(null, stmt2, null);
            closeResources(null, stmt1, conn);
        }
        return false;
    }

    @Override
    public boolean updateCustomerStatus(int id, String status) {
        String sql = "UPDATE Customers SET status = ?, updated_at = GETDATE() WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Helper utility.
     * Maps a single SQL ResultSet row directly into a comprehensive Customer entity
     * object.
     * Handles null-checks for boxed primitives (Integer, Double).
     */
    private Customer mapCustomer(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setId(rs.getInt("id"));
        c.setLeadId(rs.getObject("lead_id") != null ? rs.getInt("lead_id") : null);
        c.setAssignedTo(rs.getObject("assigned_to") != null ? rs.getInt("assigned_to") : null);
        c.setCompanyName(rs.getString("company_name"));
        c.setTaxCode(rs.getString("tax_code"));
        c.setWebsite(rs.getString("website"));
        c.setIndustry(rs.getString("industry"));
        c.setNumberOfEmployees(rs.getObject("number_of_employees") != null ? rs.getInt("number_of_employees") : null);
        c.setPhone(rs.getString("phone"));
        c.setEmail(rs.getString("email"));
        c.setBillingAddress(rs.getString("billing_address"));
        c.setShippingAddress(rs.getString("shipping_address"));
        c.setCity(rs.getString("city"));
        c.setCountry(rs.getString("country"));
        c.setTier(rs.getString("tier"));
        c.setStatus(rs.getString("status"));
        c.setFoundedDate(rs.getDate("founded_date"));
        c.setLastCareDate(rs.getTimestamp("last_care_date"));
        c.setTotalRevenue(rs.getObject("total_revenue") != null ? rs.getDouble("total_revenue") : null);
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        return c;
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
