package dao;

import java.util.List;
import model.entity.CampaignTransfer;

/**
 * Interface for Campaign Transfer Database Operations
 */
public interface CampaignTransferDAO {
    // Core CRUD
    Long insert(CampaignTransfer transfer);
    void update(CampaignTransfer transfer);
    CampaignTransfer findById(Long id);
    
    // Business Queries
    boolean hasPendingTransfer(Long campaignId);
    CampaignTransfer findPendingByCampaignId(Long campaignId);
    
    // List Queries
    List<CampaignTransfer> findPendingTransfersByRecipient(Long managerId);
    List<CampaignTransfer> findPendingTransfersBySender(Long managerId);
    List<CampaignTransfer> findRecentTransfersBySender(Long managerId);
    List<CampaignTransfer> findHistoryByCampaign(Long campaignId);
}
