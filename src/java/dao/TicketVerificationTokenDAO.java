package dao;

import model.entity.TicketVerificationToken;
import java.util.Date;

public interface TicketVerificationTokenDAO {

    /**
     * Lưu token mới vào DB
     * 
     * @param ticketId  ID của ticket
     * @param token     Chuỗi UUID token
     * @param expiresAt Thời điểm hết hạn
     * @return true nếu lưu thành công
     */
    boolean saveToken(int ticketId, String token, Date expiresAt);

    /**
     * Tìm token theo chuỗi token
     * 
     * @param token Chuỗi UUID token
     * @return TicketVerificationToken hoặc null nếu không tồn tại
     */
    TicketVerificationToken findByToken(String token);

    /**
     * Đánh dấu token đã được sử dụng
     * 
     * @param token Chuỗi UUID token
     * @return true nếu cập nhật thành công
     */
    boolean markAsUsed(String token);
}
