package model.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Entity class representing a Marketing Campaign
 * Maps to Campaigns table in database
 */
public class Campaign {
    private Integer id;
    private String name;
    private BigDecimal budget;
    private Timestamp startDate;
    private Timestamp endDate;
    private Integer managerId;
    private String status;
    private String description;
    private Timestamp createdAt;
    
    public Campaign() {
        this.status = "Draft";
        this.budget = BigDecimal.ZERO;
    }
    
    public Campaign(String name, BigDecimal budget, Timestamp startDate, Timestamp endDate, 
                    Integer managerId, String description) {
        this.name = name;
        this.budget = budget;
        this.startDate = startDate;
        this.endDate = endDate;
        this.managerId = managerId;
        this.description = description;
        this.status = "Draft";
    }
    
    public Campaign(Integer id, String name, BigDecimal budget, Timestamp startDate, 
                    Timestamp endDate, Integer managerId, String status, String description, 
                    Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.budget = budget;
        this.startDate = startDate;
        this.endDate = endDate;
        this.managerId = managerId;
        this.status = status;
        this.description = description;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public BigDecimal getBudget() {
        return budget;
    }
    
    public void setBudget(BigDecimal budget) {
        this.budget = budget;
    }
    
    public Timestamp getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }
    
    public Timestamp getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }
    
    public Integer getManagerId() {
        return managerId;
    }
    
    public void setManagerId(Integer managerId) {
        this.managerId = managerId;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    
    @Override
    public String toString() {
        return "Campaign{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", budget=" + budget +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", managerId=" + managerId +
                ", status='" + status + '\'' +
                ", description='" + description + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
