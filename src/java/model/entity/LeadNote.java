package model.entity;

import java.time.LocalDateTime;

/**
 * Entity representing an interaction note for a lead.
 */
public class LeadNote {
    private Long id;
    private Long leadId;
    private Long salesId;
    private String noteContent;
    private String noteType; // Call, Meeting, Email, General, FollowUp
    private Boolean isImportant;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public LeadNote() {}

    public LeadNote(Long leadId, Long salesId, String noteContent, String noteType) {
        this.leadId = leadId;
        this.salesId = salesId;
        this.noteContent = noteContent;
        this.noteType = (noteType != null) ? noteType : "General";
        this.isImportant = false;
        this.createdAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getLeadId() { return leadId; }
    public void setLeadId(Long leadId) { this.leadId = leadId; }

    public Long getSalesId() { return salesId; }
    public void setSalesId(Long salesId) { this.salesId = salesId; }

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
