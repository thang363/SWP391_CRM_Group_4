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

/**
 * Lớp triển khai của ReviewDAO.
 * Đảm nhiệm trực tiếp việc kết nối CSDL và thực thi SQL cho tính năng Đánh Giá Khách Hàng.
 */
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

    /**
     * Tạo mới một mã yêu cầu đánh giá cho khách hàng.
     * Thiết lập ngày hết hạn là 7 ngày kể từ hiện tại.
     */
    @Override
    public String generateFeedbackRequest(int customerId, Integer userId) {
        String sql = "INSERT INTO CustomerReviews (customer_id, user_id, feedback_token, expires_at, is_used, sent_at) VALUES (?, ?, ?, ?, 0, GETDATE())";
        Connection conn = null;
        PreparedStatement stmt = null;

        // Khởi tạo ngẫu nhiên một chuỗi dịnh danh bảo mật duy nhất - UUID
        String token = UUID.randomUUID().toString();
        // Thiết lập Thời Hạn Thêm +7 Ngày nhằm quản lý rủi ro các URL Đánh Giá hết hạn
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

    /**
     * Lấy dữ liệu đánh giá tương ứng với một token cụ thể từ CSDL.
     */
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

    /**
     * Đẩy bản lưu Đánh Giá của khách hàng vào CSDL.
     * Ngăn chặn gửi nhiều lần (Submit lặp lại) trên cùng 1 token và từ chối nếu token hết hạn.
     */
    @Override
    public boolean submitFeedback(String token, int serviceRating, int staffRating, String comment) {
        // Điều kiện: 'is_used = 0' đảm bảo mỗi token chỉ có thể gọi Submit thành công duy nhất 1 lần.
        // Điều kiện: 'expires_at >= GETDATE()' chặn các token hết hạn gọi request POST.
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

    /**
     * Lấy danh sách toàn bộ phản hồi dành cho một khách hàng, sắp xếp theo thứ tự mới nhất nằm trên cùng.
     */
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

    /**
     * Kiểm tra xem khách hàng này có nhận yêu cầu đánh giá nào trong phạm vi 24 tiếng gần nhất hay không.
     * Hoạt động như một cơ chế chống Spam và Spam-limit.
     */
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
