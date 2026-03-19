package dao;

import java.util.List;
import model.entity.Review;

/**
 * Giao diện Data Access Object phụ trách các thao tác với Đánh giá Khách hàng (Customer Feedback).
 */
public interface ReviewDAO {
    
    /**
     * Tạo một mã xác thực (token) an toàn, duy nhất cho một khách hàng.
     * Các mã này được dùng để đính kèm vào URL và thường có ngày hết hạn.
     * @param customerId ID của khách hàng mục tiêu
     * @param userId (Tùy chọn) ID của nhân viên yêu cầu đánh giá
     * @return Chuỗi token duy nhất, hoặc null nếu quá trình tạo thất bại
     */
    String generateFeedbackRequest(int customerId, Integer userId);

    /**
     * Lấy bản ghi chi tiết của một Yêu cầu Đánh giá dựa vào token của nó.
     * Hữu ích trong việc kiểm tra tính hợp lệ, hạn sử dụng và trạng thái đã đánh giá hay chưa của link.
     * @param token Chuỗi token duy nhất
     * @return Đối tượng Review nếu tìm thấy, hoặc null
     */
    Review getReviewByToken(String token);

    /**
     * Cập nhật và lưu lại điểm đánh giá và lời bình luận thực tế của khách hàng.
     * Đánh dấu token tương ứng thành 'đã sử dụng' (is_used = 1) để tránh bị nộp(spam) nhiều lần.
     * @param token Mã xác thực từ đường link URL
     * @param serviceRating Điểm đánh giá dịch vụ (1-5 sao)
     * @param staffRating Điểm đánh giá nhân viên (1-5 sao)
     * @param comment Lời bình luận tĩnh
     * @return true nếu ghi nhận đánh giá thành công
     */
    boolean submitFeedback(String token, int serviceRating, int staffRating, String comment);

    /**
     * Lấy toàn bộ các Đánh giá (đã gửi hoặc đang chờ) của một khách hàng cụ thể.
     * Thường được sắp xếp theo thời gian Gửi/Nộp để hiển thị lịch sử ở giao diện mượt hơn.
     * @param customerId ID của khách hàng mục tiêu
     * @return Danh sách các bản ghi Review trong quá khứ
     */
    List<Review> getReviewsByCustomer(int customerId);

    /**
     * Kiểm tra xem khách hàng có vừa nhận một yêu cầu đánh giá nào gần đây không.
     * Thường dùng để làm cơ chế chống tác động Spam (Giới hạn 24 giờ).
     * @param customerId ID khách hàng cần kiểm tra
     * @return true nếu đã có một yêu cầu tồn tại trong thời gian chờ (cooldown)
     */
    boolean hasActiveFeedbackRequest(int customerId);
}
