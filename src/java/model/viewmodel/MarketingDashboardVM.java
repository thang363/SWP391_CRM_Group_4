package model.viewmodel;

import java.math.BigDecimal;
import java.util.List;
import model.entity.LeadSubmission;


/**
 * ViewModel for the Marketing Dashboard for Managers.
 */
public class MarketingDashboardVM {
    private int globalTotalCampaigns;
    private int personalTotalCampaigns;
    private int personalActiveCampaigns;
    private int totalLeads;
    private int hotLeads;
    private int unassignedHotLeads;
    private int totalOpportunities;
    private int totalCustomers;
    private int approvedLandingPages;
    private int submissionsToday;
    private int pendingSubmissions;
    private double totalBudget;
    private double personalPipelineValue;

    public MarketingDashboardVM() {}

    // Getters and Setters
    public int getGlobalTotalCampaigns() { return globalTotalCampaigns; }
    public void setGlobalTotalCampaigns(int globalTotalCampaigns) { this.globalTotalCampaigns = globalTotalCampaigns; }

    public int getPersonalTotalCampaigns() { return personalTotalCampaigns; }
    public void setPersonalTotalCampaigns(int personalTotalCampaigns) { this.personalTotalCampaigns = personalTotalCampaigns; }

    public int getPersonalActiveCampaigns() { return personalActiveCampaigns; }
    public void setPersonalActiveCampaigns(int personalActiveCampaigns) { this.personalActiveCampaigns = personalActiveCampaigns; }

    public int getTotalLeads() { return totalLeads; }
    public void setTotalLeads(int totalLeads) { this.totalLeads = totalLeads; }

    public int getHotLeads() { return hotLeads; }
    public void setHotLeads(int hotLeads) { this.hotLeads = hotLeads; }

    public int getUnassignedHotLeads() { return unassignedHotLeads; }
    public void setUnassignedHotLeads(int unassignedHotLeads) { this.unassignedHotLeads = unassignedHotLeads; }

    public int getTotalOpportunities() { return totalOpportunities; }
    public void setTotalOpportunities(int totalOpportunities) { this.totalOpportunities = totalOpportunities; }

    public int getTotalCustomers() { return totalCustomers; }
    public void setTotalCustomers(int totalCustomers) { this.totalCustomers = totalCustomers; }

    public int getApprovedLandingPages() { return approvedLandingPages; }
    public void setApprovedLandingPages(int approvedLandingPages) { this.approvedLandingPages = approvedLandingPages; }

    public int getSubmissionsToday() { return submissionsToday; }
    public void setSubmissionsToday(int submissionsToday) { this.submissionsToday = submissionsToday; }

    public int getPendingSubmissions() { return pendingSubmissions; }
    public void setPendingSubmissions(int pendingSubmissions) { this.pendingSubmissions = pendingSubmissions; }

    public double getTotalBudget() { return totalBudget; }
    public void setTotalBudget(double totalBudget) { this.totalBudget = totalBudget; }

    public double getPersonalPipelineValue() { return personalPipelineValue; }
    public void setPersonalPipelineValue(double personalPipelineValue) { this.personalPipelineValue = personalPipelineValue; }
}
