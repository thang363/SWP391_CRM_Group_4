package model.viewmodel;

import java.math.BigDecimal;
import java.util.List;
import model.entity.LeadSubmission;


/**
 * ViewModel for the Marketing Dashboard for Managers.
 */
public class MarketingDashboardVM {
    // Campaign stats
    private int globalTotalCampaigns;
    private int personalTotalCampaigns;
    private int personalActiveCampaigns;
    private int personalPausedCampaigns;
    private int personalFinishedCampaigns;
    private int personalDraftCampaigns;

    // Landing Page stats
    private int pendingLandingPages; // Relevant to Manager's campaigns
    private int approvedLandingPages;

    // Leads & Conversion stats
    private int totalLeads;
    private int hotLeads;
    private int assignedLeads;
    private int totalOpportunities;
    private int totalCustomers;
    
    // Marketing-specific Submission stats
    private int submissionsToday;
    private int pendingSubmissions;
    private List<LeadSubmission> recentSubmissions;
    
    // Financial stats
    private BigDecimal totalBudget;

    public MarketingDashboardVM() {
        this.totalBudget = BigDecimal.ZERO;
    }

    // Getters and Setters
    public int getGlobalTotalCampaigns() { return globalTotalCampaigns; }
    public void setGlobalTotalCampaigns(int globalTotalCampaigns) { this.globalTotalCampaigns = globalTotalCampaigns; }

    public int getPersonalTotalCampaigns() { return personalTotalCampaigns; }
    public void setPersonalTotalCampaigns(int personalTotalCampaigns) { this.personalTotalCampaigns = personalTotalCampaigns; }

    public int getPersonalActiveCampaigns() { return personalActiveCampaigns; }
    public void setPersonalActiveCampaigns(int personalActiveCampaigns) { this.personalActiveCampaigns = personalActiveCampaigns; }

    public int getPersonalPausedCampaigns() { return personalPausedCampaigns; }
    public void setPersonalPausedCampaigns(int personalPausedCampaigns) { this.personalPausedCampaigns = personalPausedCampaigns; }

    public int getPersonalFinishedCampaigns() { return personalFinishedCampaigns; }
    public void setPersonalFinishedCampaigns(int personalFinishedCampaigns) { this.personalFinishedCampaigns = personalFinishedCampaigns; }

    public int getPersonalDraftCampaigns() { return personalDraftCampaigns; }
    public void setPersonalDraftCampaigns(int personalDraftCampaigns) { this.personalDraftCampaigns = personalDraftCampaigns; }

    public int getPendingLandingPages() { return pendingLandingPages; }
    public void setPendingLandingPages(int pendingLandingPages) { this.pendingLandingPages = pendingLandingPages; }

    public int getApprovedLandingPages() { return approvedLandingPages; }
    public void setApprovedLandingPages(int approvedLandingPages) { this.approvedLandingPages = approvedLandingPages; }

    public int getTotalLeads() { return totalLeads; }
    public void setTotalLeads(int totalLeads) { this.totalLeads = totalLeads; }

    public int getHotLeads() { return hotLeads; }
    public void setHotLeads(int hotLeads) { this.hotLeads = hotLeads; }

    public int getAssignedLeads() { return assignedLeads; }
    public void setAssignedLeads(int assignedLeads) { this.assignedLeads = assignedLeads; }

    public int getTotalOpportunities() { return totalOpportunities; }
    public void setTotalOpportunities(int totalOpportunities) { this.totalOpportunities = totalOpportunities; }

    public int getTotalCustomers() { return totalCustomers; }
    public void setTotalCustomers(int totalCustomers) { this.totalCustomers = totalCustomers; }

    public int getSubmissionsToday() { return submissionsToday; }
    public void setSubmissionsToday(int submissionsToday) { this.submissionsToday = submissionsToday; }

    public int getPendingSubmissions() { return pendingSubmissions; }
    public void setPendingSubmissions(int pendingSubmissions) { this.pendingSubmissions = pendingSubmissions; }

    public List<LeadSubmission> getRecentSubmissions() { return recentSubmissions; }
    public void setRecentSubmissions(List<LeadSubmission> recentSubmissions) { this.recentSubmissions = recentSubmissions; }

    public BigDecimal getTotalBudget() { return totalBudget; }
    public void setTotalBudget(BigDecimal totalBudget) { this.totalBudget = totalBudget; }

    // Derived stats
    public double getLeadToOpportunityRate() {
        return totalLeads > 0 ? (totalOpportunities * 100.0 / totalLeads) : 0;
    }

    public double getLeadToCustomerRate() {
        return totalLeads > 0 ? (totalCustomers * 100.0 / totalLeads) : 0;
    }
}
