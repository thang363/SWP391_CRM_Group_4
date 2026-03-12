package model.entity;

import java.sql.Timestamp;

/**
 * Entity class for Landing Pages.
 * Maps to 'LandingPages' table in database.
 */
public class LandingPage {
    private Integer id;
    private Integer campaignId;
    private String htmlTemplate;
    private String dataConfig; // JSON string
    private String status; // Draft, Public, Active, Archived
    private String managerComment;
    private Integer approvedBy;
    private Timestamp createdAt;
    
    // New fields
    private String name;
    private Integer createdBy; // Marketing staff ID
    private Integer viewCount;
    private String brief;

    public LandingPage() {
        this.status = "Draft";
        this.viewCount = 0;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }

    // Getters and Setters
    public String getBrief() {
        return brief;
    }

    public void setBrief(String brief) {
        this.brief = brief;
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

    public String getDataConfig() {
        return dataConfig;
    }

    public void setDataConfig(String dataConfig) {
        this.dataConfig = dataConfig;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getManagerComment() {
        return managerComment;
    }

    public void setManagerComment(String managerComment) {
        this.managerComment = managerComment;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    @Override
    public String toString() {
        return "LandingPage{" +
                "id=" + id +
                ", campaignId=" + campaignId +
                ", status='" + status + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
