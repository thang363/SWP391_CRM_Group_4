package model.entity;

import java.time.LocalDateTime;

/**
 * Entity representing an interaction note for an opportunity.
 */
public class OpportunityNote {
    private Integer id;
    private Integer opportunityId;
    private Integer salesId;
    private String noteContent;
    private String noteType; // StageChange, General, Call, Meeting, Email
    private Boolean isImportant;
    private String oldStage;
    private String newStage;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Additional field for UI display (joined from Users table)
    private String salesName;

    public OpportunityNote() {}

    public OpportunityNote(Integer opportunityId, Integer salesId, String noteContent, String noteType) {
        this.opportunityId = opportunityId;
        this.salesId = salesId;
        this.noteContent = noteContent;
        this.noteType = (noteType != null) ? noteType : "General";
        this.isImportant = false;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getOpportunityId() { return opportunityId; }
    public void setOpportunityId(Integer opportunityId) { this.opportunityId = opportunityId; }

    public Integer getSalesId() { return salesId; }
    public void setSalesId(Integer salesId) { this.salesId = salesId; }

    public String getNoteContent() { return noteContent; }
    public void setNoteContent(String noteContent) { this.noteContent = noteContent; }

    public String getNoteType() { return noteType; }
    public void setNoteType(String noteType) { this.noteType = noteType; }

    public Boolean getIsImportant() { return isImportant; }
    public void setIsImportant(Boolean isImportant) { this.isImportant = isImportant; }

    public String getOldStage() { return oldStage; }
    public void setOldStage(String oldStage) { this.oldStage = oldStage; }

    public String getNewStage() { return newStage; }
    public void setNewStage(String newStage) { this.newStage = newStage; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getSalesName() { return salesName; }
    public void setSalesName(String salesName) { this.salesName = salesName; }
}
