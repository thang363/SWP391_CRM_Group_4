package dao;

import java.util.List;
import model.entity.Review;

public interface ReviewDAO {
    String generateFeedbackRequest(int customerId, Integer userId);

    Review getReviewByToken(String token);

    boolean submitFeedback(String token, int serviceRating, int staffRating, String comment);

    List<Review> getReviewsByCustomer(int customerId);

    boolean hasActiveFeedbackRequest(int customerId);
}
