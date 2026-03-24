package service;

import model.entity.CampaignTransfer;
import java.util.List;

/**
 * Service interface for handling Campaign Handover logic
 */
public interface CampaignTransferService {
    
    // Core Handover Actions
    CampaignTransfer requestTransfer(Integer campaignId, Integer fromManagerId, Integer toManagerId, String reason);
    
    boolean acceptTransfer(Integer transferId, Integer acceptingManagerId, String notes);
    
    boolean rejectTransfer(Integer transferId, Integer rejectingManagerId, String notes);
    
    boolean cancelTransfer(Integer transferId, Integer cancellingManagerId);
    
    // Queries
    List<CampaignTransfer> getPendingTransfersForRecipient(Integer managerId, int offset, int limit);
    int countPendingTransfersByRecipient(Integer managerId);
    
    List<CampaignTransfer> getRecentTransfersForSender(Integer managerId, int offset, int limit);
    int countRecentTransfersBySender(Integer managerId);
    
    CampaignTransfer getTransferById(Integer id);
}
