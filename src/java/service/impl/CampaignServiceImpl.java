package service.impl;

import dao.CampaignDAO;
import dao.impl.CampaignDAOImpl;
import model.entity.Campaign;
import service.CampaignService;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

/**
 * Implementation of CampaignService interface
 */
public class CampaignServiceImpl implements CampaignService {
    
    private final CampaignDAO campaignDAO;
    
    public CampaignServiceImpl() {
        this.campaignDAO = new CampaignDAOImpl();
    }
    
    // Constructor for testing with dependency injection
    public CampaignServiceImpl(CampaignDAO campaignDAO) {
        this.campaignDAO = campaignDAO;
    }
    
    @Override
    public Campaign getCampaignById(Long id) {
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
    public List<Campaign> searchCampaigns(String name, String status, Timestamp startDate, Timestamp endDate) {
        return campaignDAO.findByFilters(name, status, startDate, endDate);
    }
    
    @Override
    public Campaign createCampaign(Campaign campaign) {
        // Validate campaign
        String validationError = validateCampaign(campaign);
        if (validationError != null) {
            System.err.println("Campaign validation failed: " + validationError);
            return null;
        }
        
        // Set default values if not provided
        if (campaign.getStatus() == null || campaign.getStatus().trim().isEmpty()) {
            campaign.setStatus("Draft");
        }
        
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
        
        // Validate campaign
        String validationError = validateCampaign(campaign);
        if (validationError != null) {
            System.err.println("Campaign validation failed: " + validationError);
            return false;
        }
        
        return campaignDAO.update(campaign);
    }
    
    @Override
    public boolean deleteCampaign(Long id) {
        if (id == null || id <= 0) {
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
            if (!status.equals("Draft") && !status.equals("Pending") && 
                !status.equals("Approved") && !status.equals("Active") && 
                !status.equals("Finished") && !status.equals("Rejected")) {
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
