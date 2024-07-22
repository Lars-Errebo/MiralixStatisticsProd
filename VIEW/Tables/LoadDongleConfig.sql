CREATE TABLE [VIEW].[LoadDongleConfig] (
    [id]                 INT           IDENTITY (1, 1) NOT NULL,
    [Created]            DATETIME2 (7) NOT NULL,
    [Stamp]              DATETIME2 (7) NOT NULL,
    [DongleID]           VARCHAR (13)  NULL,
    [VersionNumber]      VARCHAR (128) NULL,
    [Enabled]            INT           NULL,
    [UnlimitedInquiries] INT           NULL,
    [LicenseID]          NVARCHAR (10) NULL,
    [Environment]        VARCHAR (64)  NULL
);
GO

ALTER TABLE [VIEW].[LoadDongleConfig]
    ADD CONSTRAINT [PK_LoadDongleConfig] PRIMARY KEY CLUSTERED ([id] ASC);
GO

ALTER TABLE [VIEW].[LoadDongleConfig]
    ADD CONSTRAINT [DF_LoadDongleConfig_Enabled] DEFAULT ((1)) FOR [Enabled];
GO

ALTER TABLE [VIEW].[LoadDongleConfig]
    ADD CONSTRAINT [DF_LoadDongleConfig__stamp] DEFAULT (sysdatetime()) FOR [Stamp];
GO

ALTER TABLE [VIEW].[LoadDongleConfig]
    ADD CONSTRAINT [DF_LoadDongleConfig__created] DEFAULT (sysdatetime()) FOR [Created];
GO

