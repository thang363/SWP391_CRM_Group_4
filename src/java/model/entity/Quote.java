package model.entity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Quote {

    private Integer id;
    private Integer opportunityId;
    private String quoteNumber;
    private String subject;
    private BigDecimal subtotal;
    private BigDecimal discountAmount;
    private BigDecimal taxAmount;
    private BigDecimal grandTotal;
    private String status; // Draft | Sent | Accepted | Rejected | Expired
    private String rejectionReason;
    private LocalDate validUntil;
    private Integer createdBy;
    private LocalDateTime createdAt;

    // Transient — dùng để hiển thị tên opportunity trong danh sách
    private String opportunityName;
    private String creatorName;

    // Transient — dùng để chứa chi tiết các sản phẩm trong báo giá để show modal
    private java.util.List<QuoteDetail> details;

    public Quote() {
    }

    // ===== Helpers =====

    public boolean isDraft() {
        return "Draft".equals(status);
    }

    public boolean isSent() {
        return "Sent".equals(status);
    }

    public boolean isAccepted() {
        return "Accepted".equals(status);
    }

    public boolean isLocked() {
        return "Accepted".equals(status) || "Rejected".equals(status) || "Expired".equals(status);
    }

    // ===== Getters & Setters =====

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getOpportunityId() { return opportunityId; }
    public void setOpportunityId(Integer opportunityId) { this.opportunityId = opportunityId; }

    public String getQuoteNumber() { return quoteNumber; }
    public void setQuoteNumber(String quoteNumber) { this.quoteNumber = quoteNumber; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }

    public BigDecimal getTaxAmount() { return taxAmount; }
    public void setTaxAmount(BigDecimal taxAmount) { this.taxAmount = taxAmount; }

    public BigDecimal getGrandTotal() { return grandTotal; }
    public void setGrandTotal(BigDecimal grandTotal) { this.grandTotal = grandTotal; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public LocalDate getValidUntil() { return validUntil; }
    public void setValidUntil(LocalDate validUntil) { this.validUntil = validUntil; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getOpportunityName() { return opportunityName; }
    public void setOpportunityName(String opportunityName) { this.opportunityName = opportunityName; }

    public String getCreatorName() { return creatorName; }
    public void setCreatorName(String creatorName) { this.creatorName = creatorName; }

    public java.util.List<QuoteDetail> getDetails() { return details; }
    public void setDetails(java.util.List<QuoteDetail> details) { this.details = details; }
}
