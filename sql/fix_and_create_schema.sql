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
        [source] [nvarchar](255) NULL, 
        [full_name] [nvarchar](255) NULL,
        [email] [varchar](100) NULL,
        [phone] [varchar](20) NULL,
        [is_processed] [bit] NULL DEFAULT 0,
        [submitted_at] [datetime] NULL DEFAULT getdate(),
        PRIMARY KEY CLUSTERED ([id] ASC)
    );
END

-- 3. Tao bang ImportHistory (Moi)
IF OBJECT_ID(N'dbo.ImportHistory', N'U') IS NULL
BEGIN
    PRINT 'Dang tao bang ImportHistory...';
    CREATE TABLE [dbo].[ImportHistory](
        [id] [int] IDENTITY(1,1) NOT NULL,
        [file_name] [nvarchar](255) NOT NULL,
        [file_checksum] [varchar](32) NOT NULL,
        [row_count] [int] NOT NULL,
        [success_count] [int] NOT NULL,
        [error_count] [int] NOT NULL,
        [created_by] [int] NOT NULL,
        [created_at] [datetime] DEFAULT getdate(),
        PRIMARY KEY CLUSTERED ([id] ASC)
    );
    -- Index
    CREATE INDEX IDX_CheckSpam_UserDate ON ImportHistory(created_by, created_at);
    CREATE INDEX IDX_CheckDuplicate_Checksum ON ImportHistory(file_checksum);
    PRINT 'Tao bang ImportHistory THANH CONG.';
END
ELSE
BEGIN
    PRINT 'Bang ImportHistory DA TON TAI.';
END
