package model.entity;

import java.time.LocalDateTime;

/**
 * Entity representing an interaction note for a lead.
 */
public class LeadNote {
    private Integer id;
    private Integer leadId;
    private Integer salesId;
    private String noteContent;
    private String noteType; // Call, Meeting, Email, General, FollowUp
    private Boolean isImportant;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public LeadNote() {}

    public LeadNote(Integer leadId, Integer salesId, String noteContent, String noteType) {
        this.leadId = leadId;
        this.salesId = salesId;
        this.noteContent = noteContent;
        this.noteType = (noteType != null) ? noteType : "General";
        this.isImportant = false;
        this.createdAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getLeadId() { return leadId; }
    public void setLeadId(Integer leadId) { this.leadId = leadId; }

    public Integer getSalesId() { return salesId; }
    public void setSalesId(Integer salesId) { this.salesId = salesId; }

    public String getNoteContent() { return noteContent; }
    public void setNoteContent(String noteContent) { this.noteContent = noteContent; }

    public String getNoteType() { return noteType; }
    public void setNoteType(String noteType) { this.noteType = noteType; }

    public Boolean getIsImportant() { return isImportant; }
    public void setIsImportant(Boolean isImportant) { this.isImportant = isImportant; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
