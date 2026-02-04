package service;

import model.entity.CampaignTransfer;
import java.util.List;

/**
 * Service interface for handling Campaign Handover logic
 */
public interface CampaignTransferService {
    
    // Core Handover Actions
    CampaignTransfer requestTransfer(Long campaignId, Long fromManagerId, Long toManagerId, String reason);
    
    boolean acceptTransfer(Long transferId, Long acceptingManagerId, String notes);
    
    boolean rejectTransfer(Long transferId, Long rejectingManagerId, String notes);
    
    boolean cancelTransfer(Long transferId, Long cancellingManagerId);
    
    // Queries
    List<CampaignTransfer> getPendingTransfersForRecipient(Long managerId);
    
    List<CampaignTransfer> getPendingTransfersForSender(Long managerId);
    
    List<CampaignTransfer> getTransferHistory(Long campaignId);
    
    CampaignTransfer getTransferById(Long id);
}
