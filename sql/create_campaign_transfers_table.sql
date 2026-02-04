-- =============================================
-- CAMPAIGN HANDOVER EXTENSION
-- =============================================

-- 1. CampaignTransfers: Manages active transfer requests
-- Only stores the current state of a transfer processing
CREATE TABLE CampaignTransfers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    campaign_id INT NOT NULL,
    from_manager_id INT NOT NULL,
    to_manager_id INT NOT NULL,
    transfer_status VARCHAR(20) NOT NULL 
        CHECK (transfer_status IN ('Pending', 'Accepted', 'Rejected', 'Cancelled')),
    transfer_reason NVARCHAR(500),
    notes NVARCHAR(MAX), -- Internal system notes if needed
    requested_at DATETIME DEFAULT GETDATE(),
    responded_at DATETIME NULL,
    response_notes NVARCHAR(500), -- Notes from the recipient upon accept/reject
    
    CONSTRAINT FK_CampaignTransfers_Campaign 
        FOREIGN KEY (campaign_id) REFERENCES Campaigns(id),
    CONSTRAINT FK_CampaignTransfers_FromManager 
        FOREIGN KEY (from_manager_id) REFERENCES Users(id),
    CONSTRAINT FK_CampaignTransfers_ToManager 
        FOREIGN KEY (to_manager_id) REFERENCES Users(id)
);

-- Business rule enforcement via Index: Only one PENDING transfer per campaign allowed at a time
-- Note: SQL Server specific syntax for filtered unique index
CREATE UNIQUE NONCLUSTERED INDEX UQ_OnePendingPerCampaign 
ON CampaignTransfers(campaign_id) 
WHERE transfer_status = 'Pending';

-- Index for querying transfers by status (e.g., finding all Pending)
CREATE INDEX IX_CampaignTransfers_Status 
ON CampaignTransfers(transfer_status, campaign_id);

-- Index for finding active requests for a specific manager
CREATE INDEX IX_CampaignTransfers_ToManager 
ON CampaignTransfers(to_manager_id, transfer_status);

-- 2. CampaignTransferHistory: Archival record of completed transfers
-- Stores the final result of transfers for audit and history purposes
CREATE TABLE CampaignTransferHistory (
    id INT IDENTITY(1,1) PRIMARY KEY,
    transfer_id INT NOT NULL, -- Reference to the original transfer ID (optional, logic association)
    campaign_id INT NOT NULL,
    from_manager_id INT NOT NULL,
    to_manager_id INT NOT NULL,
    final_status VARCHAR(20) NOT NULL,
    requested_at DATETIME NOT NULL,
    completed_at DATETIME NOT NULL,
    reason NVARCHAR(500),
    
    -- We reference the ID even if the original record is deleted/archived, 
    -- keeping the ID is useful for tracing. 
    -- If you plan to delete from CampaignTransfers, remove the FK constraint.
    CONSTRAINT FK_TransferHistory_Transfer 
        FOREIGN KEY (transfer_id) REFERENCES CampaignTransfers(id)
);
