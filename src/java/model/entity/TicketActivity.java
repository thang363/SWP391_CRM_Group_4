package model.entity;

import java.sql.Timestamp;

public class TicketActivity {
    private int id;
    private int ticketId;
    private int userId;
    private String message;
    private String activityType; // 'Comment', 'InternalNote', 'StatusChange', etc.
    private Timestamp createdAt;

    // Display fields
    private String userName; // Name of the user who performed the activity

    public TicketActivity() {
    }

    public TicketActivity(int ticketId, int userId, String message, String activityType) {
        this.ticketId = ticketId;
        this.userId = userId;
        this.message = message;
        this.activityType = activityType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
}
