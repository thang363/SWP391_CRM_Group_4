package model.viewmodel;

public class MonitorKPIsViewModel {
    private int hotLeads;
    private int unassignedLeads;

    public MonitorKPIsViewModel() {
    }

    public MonitorKPIsViewModel(int hotLeads, int unassignedLeads) {
        this.hotLeads = hotLeads;
        this.unassignedLeads = unassignedLeads;
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
}
