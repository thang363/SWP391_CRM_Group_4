package model.entity;

import java.util.Date;

public class TicketVerificationToken {

    private int id;
    private int ticketId;
    private String token;
    private boolean used;
    private Date expiresAt;
    private Date createdAt;

    public TicketVerificationToken() {
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

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public boolean isUsed() {
        return used;
    }

    public void setUsed(boolean used) {
        this.used = used;
    }

    public Date getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Date expiresAt) {
        this.expiresAt = expiresAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * Kiểm tra token còn hiệu lực (chưa dùng và chưa hết hạn)
     */
    public boolean isValid() {
        return !used && expiresAt != null && expiresAt.after(new Date());
    }
}
