package model.entity;

import java.sql.Timestamp;

public class SystemJobLog {
    private int id;
    private int ruleId;
    private String ruleName; // JOIN from AutomationRules
    private Timestamp executionTime;
    private String status; // "Success" | "Failed"
    private int recordsCreated;
    private String errorMessage;
    private Timestamp createdAt;

    public SystemJobLog() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRuleId() {
        return ruleId;
    }

    public void setRuleId(int ruleId) {
        this.ruleId = ruleId;
    }

    public String getRuleName() {
        return ruleName;
    }

    public void setRuleName(String ruleName) {
        this.ruleName = ruleName;
    }

    public Timestamp getExecutionTime() {
        return executionTime;
    }

    public void setExecutionTime(Timestamp executionTime) {
        this.executionTime = executionTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getRecordsCreated() {
        return recordsCreated;
    }

    public void setRecordsCreated(int recordsCreated) {
        this.recordsCreated = recordsCreated;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
