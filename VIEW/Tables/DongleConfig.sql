CREATE TABLE [VIEW].[DongleConfig] (
    [ID]                       INT           IDENTITY (1, 1) NOT NULL,
    [Created]                  DATETIME2 (7) NOT NULL,
    [Stamp]                    DATETIME2 (7) NOT NULL,
    [DongleID]                 VARCHAR (13)  NULL,
    [VersionNumber]            VARCHAR (128) NULL,
    [Enabled]                  INT           NULL,
    [DongleLicenseTypeID]      INT           NULL,
    [LastDataDate]             DATE          NULL,
    [LastLicDate]              DATE          NULL,
    [ExceededLicenseInquiries] BIT           NULL,
    [Environment]              VARCHAR (64)  NULL,
    [InquiriesIncreased]       BIT           NULL,
    [Language]                 INT           NULL,
    [LoadDataFrom]             DATE          NULL,
    [LoadDataTo]               DATE          NULL
);
GO

ALTER TABLE [VIEW].[DongleConfig]
    ADD CONSTRAINT [DF_DongleConfig_Stamp] DEFAULT (sysdatetime()) FOR [Stamp];
GO

ALTER TABLE [VIEW].[DongleConfig]
    ADD CONSTRAINT [DF_DongleConfig_Created] DEFAULT (sysdatetime()) FOR [Created];
GO

ALTER TABLE [VIEW].[DongleConfig]
    ADD CONSTRAINT [DF_DongleConfig_InquiriesIncreased] DEFAULT ((0)) FOR [InquiriesIncreased];
GO

ALTER TABLE [VIEW].[DongleConfig]
    ADD CONSTRAINT [PK_DongleConfig] PRIMARY KEY CLUSTERED ([ID] ASC);
GO

