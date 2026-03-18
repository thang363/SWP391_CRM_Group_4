package model.viewmodel;

/**
 * ViewModel for Marketing Performance report.
 * Contains basic funnel stats per Campaign.
 */
public class CampaignPerformanceVM {
    private int campaignId;
    private String campaignName;
    private String campaignStatus;
    private int totalLeads;

    public CampaignPerformanceVM() {}

    public CampaignPerformanceVM(int campaignId, String campaignName, String campaignStatus,
                                  int totalLeads) {
        this.campaignId = campaignId;
        this.campaignName = campaignName;
        this.campaignStatus = campaignStatus;
        this.totalLeads = totalLeads;
    }

    // Getters & Setters
    public int getCampaignId() { return campaignId; }
    public void setCampaignId(int campaignId) { this.campaignId = campaignId; }

    public String getCampaignName() { return campaignName; }
    public void setCampaignName(String campaignName) { this.campaignName = campaignName; }

    public String getCampaignStatus() { return campaignStatus; }
    public void setCampaignStatus(String campaignStatus) { this.campaignStatus = campaignStatus; }

    public int getTotalLeads() { return totalLeads; }
    public void setTotalLeads(int totalLeads) { this.totalLeads = totalLeads; }

    // Helper methods for JSP display
    public String getStatusBadgeClass() {
        if (campaignStatus == null) return "secondary";
        switch (campaignStatus) {
            case "Active": return "success";
            case "Paused": return "warning";
            case "Draft": return "secondary";
            case "Finished": return "info";
            default: return "primary";
        }
    }

    public String getStatusDisplayName() {
        if (campaignStatus == null) return "N/A";
        switch (campaignStatus) {
            case "Active": return "Đang chạy";
            case "Paused": return "Tạm dừng";
            case "Draft": return "Nháp";
            case "Finished": return "Đã kết thúc";
            default: return campaignStatus;
        }
    }
}
