package dao;

import model.entity.Quote;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface QuoteDAO {
    /** Lấy toàn bộ quote của 1 opportunity, mới nhất trước */
    List<Quote> getByOpportunityId(int opportunityId);

    /** Lấy tất cả quote (cho Manager xem & duyệt) */
    List<Quote> getAll();

    /** Lấy 1 quote theo id */
    Quote getById(int id);

    /**
     * Tạo quote mới ở trạng thái Draft.
     * @return id của quote mới tạo
     */
    int create(int opportunityId, String subject, BigDecimal grandTotal, LocalDate validUntil, int createdBy);

    /**
     * Chuyển Draft → Pending Approval.
     * Gọi trước hasActiveSent() để đảm bảo không có quote Sent nào khác.
     */
    void send(int quoteId);

    /**
     * Chuyển Pending Approval → Approved.
     */
    void approve(int quoteId);

    /**
     * Chuyển Approved → Sent.
     */
    void markAsSent(int quoteId);

    /**
     * Chuyển Sent → Accepted.
     * Đồng thời set Opportunity.stage = Won (trong 1 transaction).
     */
    void accept(int quoteId, int opportunityId);

    /** Chuyển Sent/Pending Approval/Approved → Rejected với lý do */
    void reject(int quoteId, String reason);

    /** Xóa quote (chỉ khi Draft) */
    void delete(int quoteId);

    /** Kiểm tra xem opportunity đã có quote nào đang Sent chưa */
    boolean hasActiveSent(int opportunityId);
}
