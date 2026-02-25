package model.entity;

import java.sql.Timestamp;

public class AutomationRule {
    private int id;
    private String ruleName;
    private String targetType; // "Expiring" | "HighPotential"
    private String conditionsJson; // JSON string
    private String actionType; // "CreateTask" | "SendEmail"
    private String assignStrategy; // "CurrentOwner" | "SpecificUser"
    private Integer assignToUser; // nullable FK -> Users.id
    private String assignToUserName; // JOIN field
    private String status; // "Active" | "Inactive"
    private Integer createdBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public AutomationRule() {
        this.status = "Active";
        this.assignStrategy = "CurrentOwner";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRuleName() {
        return ruleName;
    }

    public void setRuleName(String ruleName) {
        this.ruleName = ruleName;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public String getConditionsJson() {
        return conditionsJson;
    }

    public void setConditionsJson(String conditionsJson) {
        this.conditionsJson = conditionsJson;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public String getAssignStrategy() {
        return assignStrategy;
    }

    public void setAssignStrategy(String assignStrategy) {
        this.assignStrategy = assignStrategy;
    }

    public Integer getAssignToUser() {
        return assignToUser;
    }

    public void setAssignToUser(Integer assignToUser) {
        this.assignToUser = assignToUser;
    }

    public String getAssignToUserName() {
        return assignToUserName;
    }

    public void setAssignToUserName(String assignToUserName) {
        this.assignToUserName = assignToUserName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
