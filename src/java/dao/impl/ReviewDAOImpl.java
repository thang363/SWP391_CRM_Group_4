package dao.impl;

import dao.ReviewDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import model.entity.Review;
import util.DatabaseUtil;

public class ReviewDAOImpl implements ReviewDAO {

    private final DatabaseUtil dbUtil;

    public ReviewDAOImpl() {
        this.dbUtil = DatabaseUtil.getInstance();
    }

    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (conn != null)
                dbUtil.closeConnection(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Review mapReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setId(rs.getInt("id"));
        review.setCustomerId(rs.getInt("customer_id"));

        int userId = rs.getInt("user_id");
        if (rs.wasNull()) {
            review.setUserId(null);
        } else {
            review.setUserId(userId);
        }

        review.setFeedbackToken(rs.getString("feedback_token"));
        review.setExpiresAt(rs.getTimestamp("expires_at"));
        review.setUsed(rs.getBoolean("is_used"));
        review.setSentAt(rs.getTimestamp("sent_at"));

        int serviceRating = rs.getInt("service_rating");
        if (!rs.wasNull())
            review.setServiceRating(serviceRating);

        int staffRating = rs.getInt("staff_rating");
        if (!rs.wasNull())
            review.setStaffRating(staffRating);

        review.setComment(rs.getString("comment"));
        review.setSubmittedAt(rs.getTimestamp("submitted_at"));

        return review;
    }

    @Override
    public String generateFeedbackRequest(int customerId, Integer userId) {
        String sql = "INSERT INTO CustomerReviews (customer_id, user_id, feedback_token, expires_at, is_used, sent_at) VALUES (?, ?, ?, ?, 0, GETDATE())";
        Connection conn = null;
        PreparedStatement stmt = null;

        String token = UUID.randomUUID().toString();
        // Set Expiry to +7 days for security against stale feedback links
        Timestamp expiresAt = Timestamp.valueOf(LocalDateTime.now().plusDays(7));

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customerId);
            if (userId != null) {
                stmt.setInt(2, userId);
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            stmt.setString(3, token);
            stmt.setTimestamp(4, expiresAt);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                return token;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }
        return null;
    }

    @Override
    public Review getReviewByToken(String token) {
        String sql = "SELECT * FROM CustomerReviews WHERE feedback_token = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, token);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapReview(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return null;
    }

    @Override
    public boolean submitFeedback(String token, int serviceRating, int staffRating, String comment) {
        // Condition: 'is_used = 0' ensures a token can only be successfully submitted
        // once.
        // Condition: 'expires_at >= GETDATE()' blocks expired tokens at POST.
        String sql = "UPDATE CustomerReviews SET is_used = 1, service_rating = ?, staff_rating = ?, comment = ?, submitted_at = GETDATE() WHERE feedback_token = ? AND is_used = 0 AND expires_at >= GETDATE()";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, serviceRating);
            stmt.setInt(2, staffRating);
            stmt.setString(3, comment);
            stmt.setString(4, token);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    @Override
    public List<Review> getReviewsByCustomer(int customerId) {
        String sql = "SELECT * FROM CustomerReviews WHERE customer_id = ? ORDER BY sent_at DESC";
        List<Review> reviews = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customerId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                reviews.add(mapReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return reviews;
    }

    @Override
    public boolean hasActiveFeedbackRequest(int customerId) {
        String sql = "SELECT COUNT(*) FROM CustomerReviews WHERE customer_id = ? AND is_used = 0 AND sent_at >= DATEADD(hour, -24, GETDATE())";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customerId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }
        return false;
    }
}
