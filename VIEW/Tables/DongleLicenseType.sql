CREATE TABLE [VIEW].[DongleLicenseType] (
    [id]                 INT           NOT NULL,
    [Created]            DATETIME2 (7) NOT NULL,
    [Stamp]              DATETIME2 (7) NOT NULL,
    [LicenseType]        VARCHAR (256) NOT NULL,
    [Inquiries]          INT           NOT NULL,
    [UnlimitedInquiries] INT           NOT NULL,
    [MrxLicenseID]       INT           NOT NULL,
    [Environment]        VARCHAR (64)  NOT NULL
);
GO

ALTER TABLE [VIEW].[DongleLicenseType]
    ADD CONSTRAINT [DF_DongleLicenseType_Stamp] DEFAULT (sysdatetime()) FOR [Stamp];
GO

ALTER TABLE [VIEW].[DongleLicenseType]
    ADD CONSTRAINT [DF_DongleLicenseType_Created] DEFAULT (sysdatetime()) FOR [Created];
GO

ALTER TABLE [VIEW].[DongleLicenseType]
    ADD CONSTRAINT [DF_dongle_license_type__unlimited_inquiries] DEFAULT ((0)) FOR [UnlimitedInquiries];
GO

