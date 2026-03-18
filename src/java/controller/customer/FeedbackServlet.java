package controller.customer;

import dao.ReviewDAO;
import dao.impl.ReviewDAOImpl;
import model.entity.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet Giao Diện Công Cộng điều hướng việc thu thập Phản Hồi Khách Hàng.
 * Được ánh xạ vào đường dẫn '/feedback' và có thể truy cập mà không cần đăng nhập CRM.
 */
@WebServlet(name = "FeedbackServlet", urlPatterns = { "/feedback" })
public class FeedbackServlet extends HttpServlet {

    private final ReviewDAO reviewDAO;

    public FeedbackServlet() {
        this.reviewDAO = new ReviewDAOImpl();
    }

    /**
     * Xử lý yêu cầu GET: Truy cập vào đường dẫn đánh giá.
     * Xác thực thông tin, tính khả dụng và trạng thái đã sử dụng của Token trước khi tải Form diện diện.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        if (token == null || token.isEmpty()) {
            request.setAttribute("error", "Link đánh giá không hợp lệ hoặc bị thiếu Mã xác thực.");
            request.getRequestDispatcher("/views/feedbacks/feedback_error.jsp").forward(request, response);
            return;
        }

        Review review = reviewDAO.getReviewByToken(token);
        if (review == null) {
            request.setAttribute("error", "Không tìm thấy yêu cầu đánh giá nào khớp với đường dẫn này.");
            request.getRequestDispatcher("/views/feedbacks/feedback_error.jsp").forward(request, response);
            return;
        }

        if (review.isUsed()) {
            request.setAttribute("error", "Bạn đã thực hiện đánh giá cho lần chăm sóc này rồi. Cảm ơn bạn rất nhiều!");
            request.getRequestDispatcher("/views/feedbacks/feedback_error.jsp").forward(request, response);
            return;
        }

        if (review.getExpiresAt() != null && review.getExpiresAt().getTime() < System.currentTimeMillis()) {
            request.setAttribute("error",
                    "Rất tiếc, đường dẫn đánh giá này đã hết hạn. Mong quay lại phục vụ bạn lần sau!");
            request.getRequestDispatcher("/views/feedbacks/feedback_error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("token", token);
        request.getRequestDispatcher("/views/feedbacks/feedback.jsp").forward(request, response);
    }

    /**
     * Xử lý yêu cầu POST: Bấm Nộp/Gửi Form Đánh Giá.
     * Thu thập các ô đánh giá và bình luận, giao cho DAO thao tác, sau đó chuyển hướng tới thông báo Thành công / Thất bại.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String serviceRatingStr = request.getParameter("serviceRating");
        String staffRatingStr = request.getParameter("staffRating");
        String comment = request.getParameter("comment");

        if (token == null || token.isEmpty() || serviceRatingStr == null || staffRatingStr == null) {
            response.sendRedirect(request.getContextPath() + "/feedback?token=" + token + "&error=missing_fields");
            return;
        }

        try {
            int serviceRating = Integer.parseInt(serviceRatingStr);
            int staffRating = Integer.parseInt(staffRatingStr);

            boolean success = reviewDAO.submitFeedback(token, serviceRating, staffRating, comment);
            if (success) {
                request.setAttribute("successMessage",
                        "Cảm ơn bạn đã dành thời gian để gửi phản hồi. Ý kiến của bạn đã được ghi nhận thành công!");
                request.getRequestDispatcher("/views/feedbacks/feedback_success.jsp").forward(request, response);
            } else {
                request.setAttribute("error",
                        "Đánh giá không thành công. Đường dẫn có thể đã hết hạn bảo mật hoặc đã được dùng trước đó.");
                request.getRequestDispatcher("/views/feedbacks/feedback_error.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/feedback?token=" + token + "&error=invalid_rating");
        }
    }
}
