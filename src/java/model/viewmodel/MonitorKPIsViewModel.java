package model.viewmodel;

public class MonitorKPIsViewModel {
    private int totalLeads;
    private int hotLeads;
    private int unassignedLeads;
    private double avgScore;

    public MonitorKPIsViewModel() {
    }

    public MonitorKPIsViewModel(int totalLeads, int hotLeads, int unassignedLeads, double avgScore) {
        this.totalLeads = totalLeads;
        this.hotLeads = hotLeads;
        this.unassignedLeads = unassignedLeads;
        this.avgScore = avgScore;
    }

    public int getTotalLeads() {
        return totalLeads;
    }

    public void setTotalLeads(int totalLeads) {
        this.totalLeads = totalLeads;
    }

    public int getHotLeads() {
        return hotLeads;
    }

    public void setHotLeads(int hotLeads) {
        this.hotLeads = hotLeads;
    }

    public int getUnassignedLeads() {
        return unassignedLeads;
    }

    public void setUnassignedLeads(int unassignedLeads) {
        this.unassignedLeads = unassignedLeads;
    }

    public double getAvgScore() {
        return avgScore;
    }

    public void setAvgScore(double avgScore) {
        this.avgScore = avgScore;
    }
}
