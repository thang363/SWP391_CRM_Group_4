package model.viewmodel;

import java.sql.Timestamp;

public class LeadInteractionViewModel {
    private int interactionId;
    private int leadId;
    private String leadName;
    private String leadEmail;
    private String activityName;
    private String details;
    private int scoreChange;
    private Timestamp createdAt;

    public LeadInteractionViewModel() {
    }

    public LeadInteractionViewModel(int interactionId, int leadId, String leadName, String leadEmail, String activityName, String details, int scoreChange, Timestamp createdAt) {
        this.interactionId = interactionId;
        this.leadId = leadId;
        this.leadName = leadName;
        this.leadEmail = leadEmail;
        this.activityName = activityName;
        this.details = details;
        this.scoreChange = scoreChange;
        this.createdAt = createdAt;
    }

    public int getInteractionId() {
        return interactionId;
    }

    public void setInteractionId(int interactionId) {
        this.interactionId = interactionId;
    }

    public int getLeadId() {
        return leadId;
    }

    public void setLeadId(int leadId) {
        this.leadId = leadId;
    }

    public String getLeadName() {
        return leadName;
    }

    public void setLeadName(String leadName) {
        this.leadName = leadName;
    }

    public String getLeadEmail() {
        return leadEmail;
    }

    public void setLeadEmail(String leadEmail) {
        this.leadEmail = leadEmail;
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public int getScoreChange() {
        return scoreChange;
    }

    public void setScoreChange(int scoreChange) {
        this.scoreChange = scoreChange;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
