package service;

import model.entity.Ticket;
import java.util.List;

public interface TicketService {
    List<Ticket> getAllTickets();

    List<Ticket> searchTickets(String keyword, String status, String priority, Integer assignedTo,
            boolean isUnassigned);

    Ticket getTicketById(int id);

    int createTicket(Ticket ticket);

    boolean updateStatus(int ticketId, String status);

    boolean updatePriority(int ticketId, String priority);

    boolean assignTicket(int ticketId, Integer userId);

    List<model.entity.TicketActivity> getActivitiesByTicketId(int ticketId);

    boolean addActivity(model.entity.TicketActivity activity);

    boolean resolveTicket(int ticketId, String note);

    /**
     * Sinh token xác nhận cho khách hàng (hết hạn sau 72h)
     * 
     * @return chuỗi UUID token, hoặc null nếu lỗi
     */
    String generateVerificationToken(int ticketId);

    /**
     * Xử lý phản hồi của khách hàng thông qua token (không yêu cầu đăng nhập)
     * 
     * @param token    UUID token từ email
     * @param decision "accept" hoặc "reject"
     * @return kết quả: "accepted", "rejected", "invalid", "expired", "already_used"
     */
    String processCustomerFeedbackByToken(String token, String decision);
}
