package model.entity;

import java.sql.Timestamp;

public class Task {
    private int id;
    private String title;
    private String description;
    private Timestamp dueDate;
    private String status; // Open, In Progress, Done
    private Integer assignedTo; // FK → Users.id
    private String assignedToName; // JOIN field
    private String relatedToEntity; // "Customer"
    private Integer relatedRecordId;// FK → Customers.id
    private String customerName; // JOIN field
    private Integer careProgramId;
    private String taskType; // Renewal, Upsell
    private Timestamp createdAt;

    public Task() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getDueDate() {
        return dueDate;
    }

    public void setDueDate(Timestamp dueDate) {
        this.dueDate = dueDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(Integer assignedTo) {
        this.assignedTo = assignedTo;
    }

    public String getAssignedToName() {
        return assignedToName;
    }

    public void setAssignedToName(String assignedToName) {
        this.assignedToName = assignedToName;
    }

    public String getRelatedToEntity() {
        return relatedToEntity;
    }

    public void setRelatedToEntity(String relatedToEntity) {
        this.relatedToEntity = relatedToEntity;
    }

    public Integer getRelatedRecordId() {
        return relatedRecordId;
    }

    public void setRelatedRecordId(Integer relatedRecordId) {
        this.relatedRecordId = relatedRecordId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public Integer getCareProgramId() {
        return careProgramId;
    }

    public void setCareProgramId(Integer careProgramId) {
        this.careProgramId = careProgramId;
    }

    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
