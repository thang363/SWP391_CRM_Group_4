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
    private String source; // New field for Import source e.g. "Landing Page", "Excel Import: filename.csv"
    private String fullName;
    private String email;
    private String phone;
    private String rawData; // JSON string containing all form fields
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

    public Integer getLandingPageId() {
        return landingPageId;
    }

    public void setLandingPageId(Integer landingPageId) {
        this.landingPageId = landingPageId;
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

    public String getRawData() {
        return rawData;
    }

    public void setRawData(String rawData) {
        this.rawData = rawData;
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
