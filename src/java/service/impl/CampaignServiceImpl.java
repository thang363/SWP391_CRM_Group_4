package service.impl;

import dao.CampaignDAO;
import dao.impl.CampaignDAOImpl;
import model.entity.Campaign;
import model.entity.Role;
import service.CampaignService;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

/**
 * Implementation of CampaignService interface
 */
public class CampaignServiceImpl implements CampaignService {
    
    private final CampaignDAO campaignDAO;
    private final dao.CampaignTransferDAO transferDAO;
    
    public CampaignServiceImpl() {
        this.campaignDAO = new CampaignDAOImpl();
        this.transferDAO = new dao.impl.CampaignTransferDAOImpl();
    }
    
    // Constructor for testing with dependency injection
    public CampaignServiceImpl(CampaignDAO campaignDAO, dao.CampaignTransferDAO transferDAO) {
        this.campaignDAO = campaignDAO;
        this.transferDAO = transferDAO;
    }
    
    @Override
    public Campaign getCampaignById(Integer id) {
        if (id == null || id <= 0) {
            return null;
        }
        return campaignDAO.findById(id);
    }
    
    @Override
    public List<Campaign> getAllCampaigns() {
        return campaignDAO.findAll();
    }
    
    @Override
    public List<Campaign> searchCampaigns(String name, String status, Timestamp startDate, Timestamp endDate, Integer managerId, int offset, int limit) {
        if (offset < 0) offset = 0;
        if (limit <= 0) limit = 10;
        if (offset < 0) offset = 0;
        if (limit <= 0) limit = 10;
        
        // Auto-finish expired campaigns (Lazy check)
        // Ideally this should be a background job, but for simplicity we check on access
        List<Campaign> campaigns = campaignDAO.findByFilters(name, status, startDate, endDate, managerId, offset, limit);
        
        Timestamp now = new Timestamp(System.currentTimeMillis());
        boolean needsRefetch = false;
        
        for (Campaign c : campaigns) {
            if ("Active".equals(c.getStatus()) && c.getEndDate().before(now)) {
                c.setStatus("Finished");
                campaignDAO.update(c); // Update DB
                revertPublicLPsToDraft(c.getId()); // Auto-revert LPs to Draft
                needsRefetch = true;
            }
        }
        
        // If we updated any status, we might need to refetch to ensure consistency/order 
        // if the filter relied on status, but for now just updating the object is enough for display
        
        return campaigns;
    }

    @Override
    public int countCampaigns(String name, String status, Timestamp startDate, Timestamp endDate, Integer managerId) {
        return campaignDAO.countByFilters(name, status, startDate, endDate, managerId);
    }
    
    @Override
    public Campaign createCampaign(Campaign campaign) {
        if (campaign == null) return null;

        // 1. Force Draft status for new campaigns
        campaign.setStatus("Draft");

        // 2. Validate campaign
        String validationError = validateCampaign(campaign);
        if (validationError != null) {
            System.err.println("Campaign validation failed: " + validationError);
            return null;
        }
        
        // 3. Set default budget if not provided
        if (campaign.getBudget() == null) {
            campaign.setBudget(BigDecimal.ZERO);
        }
        
        return campaignDAO.create(campaign);
    }
    
    @Override
    public boolean updateCampaign(Campaign campaign) {
        if (campaign == null || campaign.getId() == null) {
            return false;
        }

        // 1. Core Validation
        String validationError = validateCampaign(campaign);
        if (validationError != null) {
            System.err.println("Campaign validation failed: " + validationError);
            return false;
        }

        // 2. Fetch current state for business rule checks
        Campaign existing = campaignDAO.findById(campaign.getId());
        if (existing == null) return false;

        // 3. Business Rule: Cannot edit Finished campaigns
        if ("Finished".equals(existing.getStatus())) {
            System.err.println("Cannot edit Finished campaign ID " + campaign.getId());
            return false;
        }

        // 4. Business Rule: Validate status transition
        String oldStatus = existing.getStatus();
        String newStatus = campaign.getStatus();
        if (oldStatus != null && newStatus != null && !oldStatus.equals(newStatus)) {
            if (!isValidTransition(oldStatus, newStatus)) {
                System.err.println("Invalid status transition from " + oldStatus + " to " + newStatus);
                return false;
            }
        }

        // 5. Database Update
        boolean success = campaignDAO.update(campaign);

        // 6. Post-update Logic: If Campaign is no longer Active, revert Public LPs to Draft
        if (success && !"Active".equals(newStatus)) {
            revertPublicLPsToDraft(campaign.getId());
        }

        return success;
    }

    private boolean isValidTransition(String oldStatus, String newStatus) {
        if (oldStatus == null || newStatus == null) return false;
        if (oldStatus.equals(newStatus)) return true;

        switch (oldStatus) {
            case "Draft":
                return newStatus.equals("Active") || newStatus.equals("Finished");
            case "Active":
                return newStatus.equals("Paused") || newStatus.equals("Finished");
            case "Paused":
                return newStatus.equals("Active") || newStatus.equals("Finished");
            case "Finished":
                return false; // Terminal state
            default:
                return false;
        }
    }

    private void revertPublicLPsToDraft(Integer campaignId) {
        try {
            dao.LandingPageDAO lpDAO = new dao.impl.LandingPageDAOImpl();
            List<model.entity.LandingPage> lps = lpDAO.findAllByCampaignId(campaignId);
            for (model.entity.LandingPage lp : lps) {
                if ("Public".equals(lp.getStatus())) {
                    lp.setStatus("Draft");
                    lpDAO.update(lp);
                    System.out.println("Auto-reverted LP ID " + lp.getId() + " to Draft (Campaign is not Active)");
                }
            }
        } catch (Exception e) {
            System.err.println("Error reverting LPs for campaign " + campaignId + ": " + e.getMessage());
        }
    }
    
    @Override
    public boolean deleteCampaign(Integer id) {
        if (id == null || id <= 0) {
            return false;
        }

        // 1. Check existence and state
        Campaign existing = campaignDAO.findById(id);
        if (existing == null) {
            System.err.println("Cannot delete: Campaign ID " + id + " not found");
            return false;
        }

        // 2. Business Rule: Only 'Draft' campaigns can be deleted
        if (!"Draft".equals(existing.getStatus())) {
            System.err.println("Cannot delete: Campaign ID " + id + " is in status " + existing.getStatus());
            return false;
        }

        // 3. Business Rule: Cannot delete if it has a pending transfer
        if (transferDAO.hasPendingTransfer(id)) {
            System.err.println("Cannot delete: Campaign ID " + id + " has a pending transfer");
            return false;
        }

        return campaignDAO.delete(id);
    }
    
    @Override
    public String validateCampaign(Campaign campaign) {
        if (campaign == null) {
            return "Campaign không được null";
        }
        
        // Validate name
        if (campaign.getName() == null || campaign.getName().trim().isEmpty()) {
            return "Tên chiến dịch không được để trống";
        }
        
        if (campaign.getName().length() > 255) {
            return "Tên chiến dịch không được vượt quá 255 ký tự";
        }
        
        // Validate dates
        if (campaign.getStartDate() == null) {
            return "Ngày bắt đầu không được để trống";
        }
        
        if (campaign.getEndDate() == null) {
            return "Ngày kết thúc không được để trống";
        }
        
        // Validate date range: start_date must be before end_date
        if (campaign.getStartDate().after(campaign.getEndDate())) {
            return "Ngày bắt đầu phải trước ngày kết thúc";
        }
        
        // Validate budget
        if (campaign.getBudget() != null && campaign.getBudget().compareTo(BigDecimal.ZERO) < 0) {
            return "Ngân sách không được âm";
        }
        
        // Validate status
        if (campaign.getStatus() != null && !campaign.getStatus().trim().isEmpty()) {
            String status = campaign.getStatus();
            // Simplified status list for Manager-led workflow
            if (!status.equals("Draft") && 
                !status.equals("Active") && 
                !status.equals("Paused") && 
                !status.equals("Finished")) {
                return "Trạng thái không hợp lệ";
            }
        }
        
        return null; // Valid
    }
    
    @Override
    public int getTotalCount() {
        return campaignDAO.countAll();
    }
    
    @Override
    public int getCountByStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return 0;
        }
        return campaignDAO.countByStatus(status);
    }


}
