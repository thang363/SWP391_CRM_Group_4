package service.impl;

import dao.AuditDAO;
import dao.CampaignDAO;
import dao.CampaignTransferDAO;
import dao.UserDAO;
import dao.impl.AuditDAOImpl;
import dao.impl.CampaignDAOImpl;
import dao.impl.CampaignTransferDAOImpl;
import dao.impl.UserDAOImpl;
import model.entity.Campaign;
import model.entity.CampaignTransfer;
import model.entity.User;
import service.CampaignTransferService;

import java.sql.Timestamp;
import java.util.List;

/**
 * Implementation of CampaignTransferService
 */
public class CampaignTransferServiceImpl implements CampaignTransferService {

    private final CampaignTransferDAO transferDAO;
    private final CampaignDAO campaignDAO;
    private final UserDAO userDAO;
    private final AuditDAO auditDAO;

    public CampaignTransferServiceImpl() {
        this.transferDAO = new CampaignTransferDAOImpl();
        this.campaignDAO = new CampaignDAOImpl();
        this.userDAO = new UserDAOImpl();
        this.auditDAO = new AuditDAOImpl();
    }

    @Override
    public CampaignTransfer requestTransfer(Long campaignId, Long fromManagerId, Long toManagerId, String reason) {
        // 1. Validate ownership
        Campaign campaign = campaignDAO.findById(campaignId);
        if (campaign == null) {
            throw new IllegalArgumentException("Campaign not found");
        }
        if (campaign.getManagerId() == null) {
            throw new IllegalStateException("Campaign has no assigned manager");
        }
        if (!campaign.getManagerId().equals(fromManagerId)) {
            throw new SecurityException("You are not the owner of this campaign");
        }

        // 2. Check for existing pending transfer
        if (transferDAO.hasPendingTransfer(campaignId)) {
            throw new IllegalStateException("A transfer is already pending for this campaign");
        }

        // 3. Validate target manager
        try {
            User targetManager = userDAO.findById(toManagerId);
            if (targetManager == null) {
                throw new IllegalArgumentException("Target manager not found");
            }
            // In a real app check role here, assuming UI filters correctly for now or add Role check
        } catch (Exception e) {
            throw new RuntimeException("Error validating target manager", e);
        }
        
        if (fromManagerId.equals(toManagerId)) {
            throw new IllegalArgumentException("Cannot transfer to yourself");
        }

        // 4. Create transfer record
        CampaignTransfer transfer = new CampaignTransfer(campaignId, fromManagerId, toManagerId, reason);
        Long id = transferDAO.insert(transfer);
        transfer.setId(id);

        // 5. Audit Log
        auditDAO.log(fromManagerId, "TRANSFER_REQUESTED", "Campaign", campaignId);
        
        return transfer;
    }

    @Override
    public boolean acceptTransfer(Long transferId, Long acceptingManagerId, String notes) {
        CampaignTransfer transfer = transferDAO.findById(transferId);
        if (transfer == null) {
            throw new IllegalArgumentException("Transfer request not found");
        }
        
        if (!"Pending".equals(transfer.getTransferStatus())) {
            throw new IllegalStateException("Transfer is not in Pending status");
        }
        
        if (!transfer.getToManagerId().equals(acceptingManagerId)) {
            throw new SecurityException("You are not the designated recipient");
        }

        // Execute as a logical transaction (Note: ideally should be DB transaction)
        
        // 1. Update Campaign Ownership
        Campaign campaign = campaignDAO.findById(transfer.getCampaignId());
        if (campaign == null) {
            throw new IllegalArgumentException("Campaign not found");
        }
        Long oldManagerId = campaign.getManagerId();
        campaign.setManagerId(acceptingManagerId);
        boolean campaignUpdated = campaignDAO.update(campaign);
        
        if (!campaignUpdated) {
            return false;
        }

        // 2. Update Transfer Status
        transfer.setTransferStatus("Accepted");
        transfer.setRespondedAt(new Timestamp(System.currentTimeMillis()));
        transfer.setResponseNotes(notes);
        transferDAO.update(transfer);

        // 3. Audit Log
        auditDAO.log(acceptingManagerId, "TRANSFER_ACCEPTED", "Campaign", campaign.getId());

        return true;
    }

    @Override
    public boolean rejectTransfer(Long transferId, Long rejectingManagerId, String notes) {
        CampaignTransfer transfer = transferDAO.findById(transferId);
        if (transfer == null) {
            throw new IllegalArgumentException("Transfer request not found");
        }
        
        if (!"Pending".equals(transfer.getTransferStatus())) {
            throw new IllegalStateException("Transfer is not in Pending status");
        }
        
        if (!transfer.getToManagerId().equals(rejectingManagerId)) {
            throw new SecurityException("You are not the designated recipient");
        }

        // Update Transfer Status
        transfer.setTransferStatus("Rejected");
        transfer.setRespondedAt(new Timestamp(System.currentTimeMillis()));
        transfer.setResponseNotes(notes);
        transferDAO.update(transfer);

        // Audit Log
        auditDAO.log(rejectingManagerId, "TRANSFER_REJECTED", "Campaign", transfer.getCampaignId());

        return true;
    }

    @Override
    public boolean cancelTransfer(Long transferId, Long cancellingManagerId) {
        CampaignTransfer transfer = transferDAO.findById(transferId);
        if (transfer == null) {
            throw new IllegalArgumentException("Transfer request not found");
        }
        
        if (!"Pending".equals(transfer.getTransferStatus())) {
            throw new IllegalStateException("Transfer is not in Pending status");
        }
        
        if (!transfer.getFromManagerId().equals(cancellingManagerId)) {
            throw new SecurityException("Only the sender can cancel the request");
        }

        // Update Transfer Status
        transfer.setTransferStatus("Cancelled");
        transfer.setRespondedAt(new Timestamp(System.currentTimeMillis()));
        transferDAO.update(transfer);

        // Audit Log
        auditDAO.log(cancellingManagerId, "TRANSFER_CANCELLED", "Campaign", transfer.getCampaignId());

        return true;
    }

    @Override
    public List<CampaignTransfer> getPendingTransfersForRecipient(Long managerId) {
        return transferDAO.findPendingTransfersByRecipient(managerId);
    }
    
    @Override
    public List<CampaignTransfer> getPendingTransfersForSender(Long managerId) {
         return transferDAO.findPendingTransfersBySender(managerId);
    }
    
    @Override
    public List<CampaignTransfer> getTransferHistory(Long campaignId) {
        return transferDAO.findHistoryByCampaign(campaignId);
    }
    
    @Override
    public CampaignTransfer getTransferById(Long id) {
        return transferDAO.findById(id);
    }
}
