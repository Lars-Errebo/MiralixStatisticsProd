CREATE TABLE [V20232].[dim_transfer] (
    [_transfer_unique_id]   NVARCHAR (100) NOT NULL,
    [_dongle_id]            INT            NULL,
    [_transfer_id]          INT            NULL,
    [_transfer_name]        NVARCHAR (256) NULL,
    [_transfer_type]        NVARCHAR (128) NULL,
    [_transfer_action]      NVARCHAR (128) NULL,
    [_transfer_destination] NVARCHAR (128) NULL
);
GO

ALTER TABLE [V20232].[dim_transfer]
    ADD CONSTRAINT [PK_dim_transfer] PRIMARY KEY CLUSTERED ([_transfer_unique_id] ASC);
GO

