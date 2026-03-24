package dao;

import java.util.List;
import model.entity.CampaignTransfer;

/**
 * Interface for Campaign Transfer Database Operations
 */
public interface CampaignTransferDAO {
    // Core CRUD
    Integer insert(CampaignTransfer transfer);
    void update(CampaignTransfer transfer);
    CampaignTransfer findById(Integer id);
    
    // Business Queries
    boolean hasPendingTransfer(Integer campaignId);
    CampaignTransfer findPendingByCampaignId(Integer campaignId);
    
    // List Queries
    List<CampaignTransfer> findPendingTransfersByRecipient(Integer managerId, int offset, int limit);
    int countPendingTransfersByRecipient(Integer managerId);
    
    List<CampaignTransfer> findRecentTransfersBySender(Integer managerId, int offset, int limit);
    int countRecentTransfersBySender(Integer managerId);
}
