package model.entity;

import java.sql.Timestamp;

/**
 * Entity class for Landing Page Submissions.
 * Maps to 'LandingPageSubmissions' table in database.
 * Stores form data submitted by users from Landing Pages.
 */
public class LeadSubmission {
    private Integer id;
    private Integer landingPageId;
    private Integer campaignId;
    private String campaignName; // Transient field for display
    private String source; 
    private String mobile; // Transient? No, phone is persistent.
    private String landingPageName; // Transient field for display
    private String fullName;
    private String email;
    private String phone;
    private Boolean isProcessed; // true if converted to Lead, false otherwise
    private Timestamp submittedAt;

    public LeadSubmission() {
        this.isProcessed = false;
        this.submittedAt = new Timestamp(System.currentTimeMillis());
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

    public String getCampaignName() {
        return campaignName;
    }

    public void setCampaignName(String campaignName) {
        this.campaignName = campaignName;
    }

    public Integer getLandingPageId() {
        return landingPageId;
    }

    public void setLandingPageId(Integer landingPageId) {
        this.landingPageId = landingPageId;
    }

    public String getLandingPageName() {
        return landingPageName;
    }

    public void setLandingPageName(String landingPageName) {
        this.landingPageName = landingPageName;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
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

    public Boolean getIsProcessed() {
        return isProcessed;
    }

    public void setIsProcessed(Boolean isProcessed) {
        this.isProcessed = isProcessed;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }

    @Override
    public String toString() {
        return "LeadSubmission{" +
                "id=" + id +
                ", landingPageId=" + landingPageId +
                ", source='" + source + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", isProcessed=" + isProcessed +
                '}';
    }
}
