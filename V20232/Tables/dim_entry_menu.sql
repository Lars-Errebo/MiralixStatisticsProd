CREATE TABLE [V20232].[dim_entry_menu] (
    [_entry_menu_unique_id] NVARCHAR (100) NOT NULL,
    [_menu_id]              INT            NULL,
    [_dongle_id]            INT            NULL,
    [_entry]                NVARCHAR (128) NULL,
    [_entry_menu_name]      NVARCHAR (256) NULL,
    [_entry_menu_action]    NVARCHAR (128) NULL
);
GO

ALTER TABLE [V20232].[dim_entry_menu]
    ADD CONSTRAINT [PK_dim_entry_menu] PRIMARY KEY CLUSTERED ([_entry_menu_unique_id] ASC);
GO

