package model.viewmodel;

import model.entity.Campaign;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Locale;

/**
 * ViewModel for displaying Campaign information.
 * Decouples the View layer from the Database Entity layer.
 */
public class CampaignViewModel {
    private Integer id;
    private String name;
    private BigDecimal budget;
    private Timestamp startDate;
    private Timestamp endDate;
    private Integer managerId;
    private String status;
    private String description;
    private Timestamp createdAt;
    
    // View-specific fields
    private String managerName;
    private boolean hasPendingTransfer;
    private boolean isOwner;

    // Landing Page specific fields
    private String landingPageStatus;
    private Integer assigneeId;
    private String assigneeName;

    // Formatters
    private static final NumberFormat CURRENCY_FORMATTER = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    private static final SimpleDateFormat DATE_FORMATTER = new SimpleDateFormat("dd/MM/yyyy");

    public CampaignViewModel() {}

    /**
     * Convert from Entity to ViewModel
     */
    public static CampaignViewModel fromEntity(Campaign entity, String managerName, boolean hasPendingTransfer, 
                                             String lpStatus, Integer assigneeId, String assigneeName, Integer currentUserId) {
        CampaignViewModel vm = new CampaignViewModel();
        vm.setId(entity.getId());
        vm.setName(entity.getName());
        vm.setBudget(entity.getBudget());
        vm.setStartDate(entity.getStartDate());
        vm.setEndDate(entity.getEndDate());
        vm.setManagerId(entity.getManagerId());
        vm.setStatus(entity.getStatus());
        vm.setDescription(entity.getDescription());
        vm.setCreatedAt(entity.getCreatedAt());
        
        // Enrich with view data
        vm.setManagerName(managerName);
        vm.setHasPendingTransfer(hasPendingTransfer);
        
        // LP Data
        vm.setLandingPageStatus(lpStatus);
        vm.setAssigneeId(assigneeId);
        vm.setAssigneeName(assigneeName);

        // Ownership logic
        vm.setOwner(entity.getManagerId() != null && entity.getManagerId().equals(currentUserId));
        
        return vm;
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public BigDecimal getBudget() { return budget; }
    public void setBudget(BigDecimal budget) { this.budget = budget; }

    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }

    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }

    public Integer getManagerId() { return managerId; }
    public void setManagerId(Integer managerId) { this.managerId = managerId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getManagerName() { return managerName; }
    public void setManagerName(String managerName) { this.managerName = managerName; }

    public boolean isHasPendingTransfer() { return hasPendingTransfer; }
    public void setHasPendingTransfer(boolean hasPendingTransfer) { this.hasPendingTransfer = hasPendingTransfer; }

    public boolean isOwner() { return isOwner; }
    public boolean getIsOwner() { return isOwner; }  // JSTL EL alias: ${campaign.isOwner}
    public void setOwner(boolean owner) { isOwner = owner; }

    public String getLandingPageStatus() { return landingPageStatus; }
    public void setLandingPageStatus(String landingPageStatus) { this.landingPageStatus = landingPageStatus; }

    public Integer getAssigneeId() { return assigneeId; }
    public void setAssigneeId(Integer assigneeId) { this.assigneeId = assigneeId; }

    public String getAssigneeName() { return assigneeName; }
    public void setAssigneeName(String assigneeName) { this.assigneeName = assigneeName; }

    // Helper methods for View display
    public String getFormattedBudget() {
        return budget != null ? CURRENCY_FORMATTER.format(budget) : "0 ₫";
    }

    public String getFormattedStartDate() {
        return startDate != null ? DATE_FORMATTER.format(startDate) : "";
    }

    public String getFormattedEndDate() {
        return endDate != null ? DATE_FORMATTER.format(endDate) : "";
    }
    
    public String getStatusBadgeClass() {
        if (status == null) return "secondary";
        switch (status) {
            case "Active": return "success";
            case "Paused": return "warning";
            case "Draft": return "secondary";
            case "Finished": return "info";
            case "Rejected": return "danger";
            default: return "primary";
        }
    }
    
    public String getStatusDisplayName() {
        if (status == null) return "N/A";
        switch (status) {
            case "Active": return "Đang chạy";
            case "Paused": return "Tạm dừng";
            case "Draft": return "Nháp";
            case "Finished": return "Đã kết thúc";
            case "Rejected": return "Bị từ chối";
            default: return status;
        }
    }
}
