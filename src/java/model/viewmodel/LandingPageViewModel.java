package model.viewmodel;

import model.entity.LandingPage;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/**
 * ViewModel for Landing Page to decouple Entity from View logic.
 * Contains formatted dates and resolved names.
 */
public class LandingPageViewModel {
    private Integer id;
    private Integer campaignId;
    private String campaignName;
    private String name;
    private String status;
    private String statusBadgeClass; // For CSS badge
    private String createdByName;
    private String formattedCreatedAt;
    
    // Static factory method
    public static LandingPageViewModel fromEntity(LandingPage lp, String campaignName, String createdByName) {
        LandingPageViewModel vm = new LandingPageViewModel();
        vm.setId(lp.getId());
        vm.setCampaignId(lp.getCampaignId());
        vm.setCampaignName(campaignName != null ? campaignName : "Unknown Campaign");
        vm.setName(lp.getName());
        vm.setStatus(lp.getStatus());
        vm.setCreatedByName(createdByName != null ? createdByName : "Unknown");
        
        // Format Date
        if (lp.getCreatedAt() != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            vm.setFormattedCreatedAt(sdf.format(lp.getCreatedAt()));
        } else {
            vm.setFormattedCreatedAt("");
        }
        
        // Resolve Status Badge
        vm.setStatusBadgeClass(resolveBadgeClass(lp.getStatus()));
        
        return vm;
    }
    
    private static String resolveBadgeClass(String status) {
        if (status == null) return "secondary";
        
        switch (status.toLowerCase()) {
            case "draft": return "secondary"; // Grey
            case "public": return "success"; // Green
            case "active": return "success"; // Green
            case "archived": return "dark"; // Black
            case "paused": return "light"; // White/Grey
            default: return "secondary";
        }
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getCampaignId() { return campaignId; }
    public void setCampaignId(Integer campaignId) { this.campaignId = campaignId; }
    public String getCampaignName() { return campaignName; }
    public void setCampaignName(String campaignName) { this.campaignName = campaignName; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getStatusBadgeClass() { return statusBadgeClass; }
    public void setStatusBadgeClass(String statusBadgeClass) { this.statusBadgeClass = statusBadgeClass; }
    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }
    public String getFormattedCreatedAt() { return formattedCreatedAt; }
    public void setFormattedCreatedAt(String formattedCreatedAt) { this.formattedCreatedAt = formattedCreatedAt; }
}
