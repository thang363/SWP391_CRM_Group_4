-- 1. Kiem tra xem bang LeadSubmissions da ton tai chua
IF OBJECT_ID(N'dbo.LeadSubmissions', N'U') IS NOT NULL
BEGIN
    PRINT 'Bang LeadSubmissions DA TON TAI. Khong can doi ten nua.';
END
ELSE IF OBJECT_ID(N'dbo.LandingPageSubmissions', N'U') IS NOT NULL
BEGIN
    PRINT 'Dang doi ten LandingPageSubmissions -> LeadSubmissions...';
    EXEC sp_rename 'dbo.LandingPageSubmissions', 'LeadSubmissions';
END
ELSE
BEGIN
    PRINT 'LOI: Khong tim thay ca LandingPageSubmissions lan LeadSubmissions!';
END

-- 2. Tao bang LeadSubmissions neu chua co (Phong truong hop xoa nham)
IF OBJECT_ID(N'dbo.LeadSubmissions', N'U') IS NULL AND OBJECT_ID(N'dbo.LandingPageSubmissions', N'U') IS NULL
BEGIN
    PRINT 'Dang tao moi bang LeadSubmissions...';
    CREATE TABLE [dbo].[LeadSubmissions](
        [id] [int] IDENTITY(1,1) NOT NULL,
        [landing_page_id] [int] NULL, 
        [campaign_id] [int] NOT NULL, -- New Column (NOT NULL)
        [source] [nvarchar](255) NULL, 
        [full_name] [nvarchar](255) NULL,
        [email] [varchar](100) NULL,
        [phone] [varchar](20) NULL,
        [is_processed] [bit] NULL DEFAULT 0,
        [submitted_at] [datetime] NULL DEFAULT getdate(),
        PRIMARY KEY CLUSTERED ([id] ASC)
    );
    PRINT 'Tao bang LeadSubmissions THANH CONG.';
END

-- 3. Update Schema: Them cot campaign_id neu chua co (Cho bang da ton tai)
IF COL_LENGTH('dbo.LeadSubmissions', 'campaign_id') IS NULL
BEGIN
    PRINT 'Xoa du lieu cu de dam bao cot campaign_id NOT NULL...';
    -- Xoa data cu vi user yeu cau (De dam bao ADD COLUMN NOT NULL thanh cong)
    DELETE FROM [dbo].[LeadSubmissions]; 
    
    PRINT 'Them cot campaign_id vao LeadSubmissions...';
    ALTER TABLE [dbo].[LeadSubmissions]
    ADD [campaign_id] [int] NOT NULL;
    PRINT 'Da them cot campaign_id (NOT NULL).';
END

-- 4. Them Foreign Key (Neu chua co)
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LeadSubmissions_Campaigns]') AND parent_object_id = OBJECT_ID(N'[dbo].[LeadSubmissions]'))
BEGIN
    PRINT 'Them Foreign Key FK_LeadSubmissions_Campaigns...';
    ALTER TABLE [dbo].[LeadSubmissions]  WITH CHECK ADD  CONSTRAINT [FK_LeadSubmissions_Campaigns] FOREIGN KEY([campaign_id])
    REFERENCES [dbo].[Campaigns] ([id])
    ON DELETE NO ACTION; -- Khong cho xoa Campaign neu con Submission lien quan
    
    ALTER TABLE [dbo].[LeadSubmissions] CHECK CONSTRAINT [FK_LeadSubmissions_Campaigns];
    PRINT 'Da them Foreign Key thanh cong.';
END

