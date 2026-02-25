USE CRM;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LeadSources]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[LeadSources](
        [id] [int] IDENTITY(1,1) NOT NULL,
        [name] [nvarchar](255) NOT NULL,
        CONSTRAINT [PK_LeadSources] PRIMARY KEY CLUSTERED ([id] ASC)
    );
    PRINT 'Table LeadSources created.';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ImportHistory]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[ImportHistory](
        [id] [int] IDENTITY(1,1) NOT NULL,
        [user_id] [bigint] NULL, -- Matches likely User ID type
        [file_name] [nvarchar](255) NULL,
        [checksum] [varchar](32) NULL,
        [imported_at] [datetime] DEFAULT GETDATE(),
        [total_rows] [int] DEFAULT 0,
        [success_rows] [int] DEFAULT 0,
        [error_rows] [int] DEFAULT 0,
        CONSTRAINT [PK_ImportHistory] PRIMARY KEY CLUSTERED ([id] ASC)
    );
    PRINT 'Table ImportHistory created.';
END
GO
