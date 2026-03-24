package service.impl;

import dao.CampaignDAO;
import dao.CampaignTransferDAO;
import dao.UserDAO;
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

    public CampaignTransferServiceImpl() {
        this.transferDAO = new CampaignTransferDAOImpl();
        this.campaignDAO = new CampaignDAOImpl();
        this.userDAO = new UserDAOImpl();
    }

    @Override
    public CampaignTransfer requestTransfer(Integer campaignId, Integer fromManagerId, Integer toManagerId, String reason) {
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

        if ("Finished".equals(campaign.getStatus())) {
            throw new IllegalStateException("Cannot transfer a finished campaign");
        }

        // 2. Check for existing pending transfer
        if (transferDAO.hasPendingTransfer(campaignId)) {
            throw new IllegalStateException("A transfer is already pending for this campaign");
        }

       
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
        Integer id = transferDAO.insert(transfer);
        transfer.setId(id);

        
        return transfer;
    }

    @Override
    public boolean acceptTransfer(Integer transferId, Integer acceptingManagerId, String notes) {
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


        return true;
    }

    @Override
    public boolean rejectTransfer(Integer transferId, Integer rejectingManagerId, String notes) {
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


        return true;
    }

    @Override
    public boolean cancelTransfer(Integer transferId, Integer cancellingManagerId) {
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


        return true;
    }

    @Override
    public List<CampaignTransfer> getPendingTransfersForRecipient(Integer managerId, int offset, int limit) {
        return transferDAO.findPendingTransfersByRecipient(managerId, offset, limit);
    }

    @Override
    public int countPendingTransfersByRecipient(Integer managerId) {
        return transferDAO.countPendingTransfersByRecipient(managerId);
    }


    
    @Override
    public List<CampaignTransfer> getRecentTransfersForSender(Integer managerId, int offset, int limit) {
        return transferDAO.findRecentTransfersBySender(managerId, offset, limit);
    }

    @Override
    public int countRecentTransfersBySender(Integer managerId) {
        return transferDAO.countRecentTransfersBySender(managerId);
    }
    
    @Override
    public CampaignTransfer getTransferById(Integer id) {
        return transferDAO.findById(id);
    }
}
