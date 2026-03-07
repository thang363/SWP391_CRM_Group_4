package model.entity;

import java.sql.Timestamp;

/**
 * Entity class representing a Campaign Transfer Request
 * Maps to CampaignTransfers table in database
 */
public class CampaignTransfer {
    private Integer id;
    private Integer campaignId;
    private Integer fromManagerId;
    private Integer toManagerId;
    private String transferStatus; // Pending, Accepted, Rejected, Cancelled
    private String transferReason;
    private String notes;
    private Timestamp requestedAt;
    private Timestamp respondedAt;
    private String responseNotes;
    
    // Auxiliary fields for display (not persisted directly in this table)
    private String campaignName;
    private String fromManagerName;
    private String toManagerName;
    private java.math.BigDecimal campaignBudget;

    public CampaignTransfer() {
    }

    public CampaignTransfer(Integer campaignId, Integer fromManagerId, Integer toManagerId, String transferReason) {
        this.campaignId = campaignId;
        this.fromManagerId = fromManagerId;
        this.toManagerId = toManagerId;
        this.transferReason = transferReason;
        this.transferStatus = "Pending";
        this.requestedAt = new Timestamp(System.currentTimeMillis());
    }

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getCampaignId() {
        return campaignId;
    }

    public void setCampaignId(Integer campaignId) {
        this.campaignId = campaignId;
    }

    public Integer getFromManagerId() {
        return fromManagerId;
    }

    public void setFromManagerId(Integer fromManagerId) {
        this.fromManagerId = fromManagerId;
    }

    public Integer getToManagerId() {
        return toManagerId;
    }

    public void setToManagerId(Integer toManagerId) {
        this.toManagerId = toManagerId;
    }

    public String getTransferStatus() {
        return transferStatus;
    }

    public void setTransferStatus(String transferStatus) {
        this.transferStatus = transferStatus;
    }

    public String getTransferReason() {
        return transferReason;
    }

    public void setTransferReason(String transferReason) {
        this.transferReason = transferReason;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Timestamp requestedAt) {
        this.requestedAt = requestedAt;
    }

    public Timestamp getRespondedAt() {
        return respondedAt;
    }

    public void setRespondedAt(Timestamp respondedAt) {
        this.respondedAt = respondedAt;
    }

    public String getResponseNotes() {
        return responseNotes;
    }

    public void setResponseNotes(String responseNotes) {
        this.responseNotes = responseNotes;
    }

    // Auxiliary getters/setters
    public String getCampaignName() {
        return campaignName;
    }

    public void setCampaignName(String campaignName) {
        this.campaignName = campaignName;
    }

    public String getFromManagerName() {
        return fromManagerName;
    }

    public void setFromManagerName(String fromManagerName) {
        this.fromManagerName = fromManagerName;
    }

    public String getToManagerName() {
        return toManagerName;
    }

    public void setToManagerName(String toManagerName) {
        this.toManagerName = toManagerName;
    }

    public java.math.BigDecimal getCampaignBudget() {
        return campaignBudget;
    }

    public void setCampaignBudget(java.math.BigDecimal campaignBudget) {
        this.campaignBudget = campaignBudget;
    }

    @Override
    public String toString() {
        return "CampaignTransfer{" +
                "id=" + id +
                ", campaignId=" + campaignId +
                ", fromManagerId=" + fromManagerId +
                ", toManagerId=" + toManagerId +
                ", transferStatus='" + transferStatus + '\'' +
                ", requestedAt=" + requestedAt +
                '}';
    }
}
