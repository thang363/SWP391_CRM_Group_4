package dao;

import model.entity.Quote;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface QuoteDAO {
    /** Lấy toàn bộ quote của 1 opportunity, mới nhất trước */
    List<Quote> getByOpportunityId(long opportunityId);

    /** Lấy 1 quote theo id */
    Quote getById(long id);

    /**
     * Tạo quote mới ở trạng thái Draft.
     * @return id của quote mới tạo
     */
    long create(long opportunityId, String subject, BigDecimal grandTotal, LocalDate validUntil, long createdBy);

    /**
     * Chuyển Draft → Sent.
     * Gọi trước hasActiveSent() để đảm bảo không có quote Sent nào khác.
     */
    void send(long quoteId);

    /**
     * Chuyển Sent → Accepted.
     * Đồng thời set Opportunity.stage = Won (trong 1 transaction).
     */
    void accept(long quoteId, long opportunityId);

    /** Chuyển Sent → Rejected */
    void reject(long quoteId);

    /** Xóa quote (chỉ khi Draft) */
    void delete(long quoteId);

    /** Kiểm tra xem opportunity đã có quote nào đang Sent chưa */
    boolean hasActiveSent(long opportunityId);
}
