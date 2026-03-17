
package model.entity;

import java.time.LocalDateTime;

/**
 *
 * @author ADMIN
 */
public class Lead {
    
    private Integer id;

    private Integer campaignId;
    private Integer sourceId;

    private String fullName;
    private String email;
    private String phone;

    private String potentialStatus;  // Hot, Cool
    private String status;           // New, Nurturing, Qualified, Assigned, Junk
    private Boolean isConverted;

    private Integer assignedTo;      // sale_id
    private LocalDateTime createdAt;

    // Optional: object mapping
    private User assignedSale;    // dùng khi JOIN Users
    //private LeadSource source;    // dùng khi JOIN LeadSources
    private Campaign campaign;      // dùng khi JOIN Campaigns

    public Lead() {
    }

    public Lead(Integer id, Integer campaignId, Integer sourceId, String fullName, String email, String phone, String potentialStatus, String status, Boolean isConverted, Integer assignedTo, LocalDateTime createdAt, User assignedSale) {
        this.id = id;
        this.campaignId = campaignId;
        this.sourceId = sourceId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.potentialStatus = potentialStatus;
        this.status = status;
        this.isConverted = isConverted;
        this.assignedTo = assignedTo;
        this.createdAt = createdAt;
        this.assignedSale = assignedSale;
    }

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

    public Integer getSourceId() {
        return sourceId;
    }

    public void setSourceId(Integer sourceId) {
        this.sourceId = sourceId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPotentialStatus() {
        return potentialStatus;
    }
    
    public void setPotentialStatus(String potentialStatus) {
        this.potentialStatus = potentialStatus;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Boolean getIsConverted() {
        return isConverted;
    }

    public void setIsConverted(Boolean isConverted) {
        this.isConverted = isConverted;
    }

    public Integer getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(Integer assignedTo) {
        this.assignedTo = assignedTo;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public User getAssignedSale() {
        return assignedSale;
    }

    public void setAssignedSale(User assignedSale) {
        this.assignedSale = assignedSale;
    }

    public Campaign getCampaign() {
        return campaign;
    }

    public void setCampaign(Campaign campaign) {
        this.campaign = campaign;
    }

    @Override
    public String toString() {
        return "Lead{" + "id=" + id + ", campaignId=" + campaignId + ", sourceId=" + sourceId + ", fullName=" + fullName + ", email=" + email + ", phone=" + phone + ", potentialStatus=" + potentialStatus + ", status=" + status + ", isConverted=" + isConverted + ", assignedTo=" + assignedTo + ", createdAt=" + createdAt + ", assignedSale=" + assignedSale + ", campaign=" + campaign + '}';
    }

    
    
    
}

