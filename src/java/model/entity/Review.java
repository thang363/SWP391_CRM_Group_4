package model.entity;

import java.sql.Timestamp;

/**
 * Lớp thực thể đại diện cho Đánh giá/Phản hồi của Khách hàng (Customer Review).
 * Chứa thông tin về đường dẫn đánh giá, các mức xếp hạng và lời bình luận.
 */
public class Review {
    private int id; // Khóa chính
    private int customerId;      // ID của khách hàng nhận yêu cầu đánh giá
    private Integer userId;      // (Tùy chọn) ID của nhân viên (ví dụ: Sale) đã gửi yêu cầu
    private String feedbackToken;// Mã xác thực duy nhất dùng cho đường dẫn URL đánh giá công khai
    private Timestamp expiresAt; // Thời hạn của đường dẫn yêu cầu đánh giá
    private boolean isUsed;      // Cờ đánh dấu phản hồi này đã được gửi hay chưa
    private Timestamp sentAt;    // Thời điểm yêu cầu đánh giá được tạo/gửi đi
    private Integer serviceRating; // Điểm đánh giá chất lượng dịch vụ (ví dụ: 1-5 sao)
    private Integer staffRating;   // Điểm đánh giá nhân viên hỗ trợ (ví dụ: 1-5 sao)
    private String comment;        // Lời bình luận/góp ý của khách hàng
    private Timestamp submittedAt; // Thời điểm khách hàng thực sự bấm nút Gửi trên Form

    /**
     * Hàm khởi tạo mặc định.
     */

    public Review() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getFeedbackToken() {
        return feedbackToken;
    }

    public void setFeedbackToken(String feedbackToken) {
        this.feedbackToken = feedbackToken;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isUsed() {
        return isUsed;
    }

    public void setUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public Timestamp getSentAt() {
        return sentAt;
    }

    public void setSentAt(Timestamp sentAt) {
        this.sentAt = sentAt;
    }

    public Integer getServiceRating() {
        return serviceRating;
    }

    public void setServiceRating(Integer serviceRating) {
        this.serviceRating = serviceRating;
    }

    public Integer getStaffRating() {
        return staffRating;
    }

    public void setStaffRating(Integer staffRating) {
        this.staffRating = staffRating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }
}
