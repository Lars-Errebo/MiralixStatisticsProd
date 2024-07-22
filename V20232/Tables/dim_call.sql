CREATE TABLE [V20232].[dim_call] (
    [_endpoint_contact_unique_id]  NVARCHAR (100) NOT NULL,
    [_dongle_id]                   INT            NULL,
    [_endpoint_contact_column]     NVARCHAR (128) NULL,
    [_endpoint_contact_type]       NVARCHAR (50)  NULL,
    [_endpoint_contact_number]     NVARCHAR (256) NULL,
    [_endpoint_contact_name]       NVARCHAR (257) NULL,
    [_endpoint_contact_address]    NVARCHAR (256) NULL,
    [_endpoint_contact_department] NVARCHAR (256) NULL,
    [_endpoint_contact_company]    NVARCHAR (256) NULL
);
GO

ALTER TABLE [V20232].[dim_call]
    ADD CONSTRAINT [PK_dim_call] PRIMARY KEY CLUSTERED ([_endpoint_contact_unique_id] ASC);
GO

