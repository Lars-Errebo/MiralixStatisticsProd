CREATE TABLE [V20232].[dim_menu] (
    [_menu_unique_id] NVARCHAR (100) NOT NULL,
    [_dongle_id]      INT            NULL,
    [_menu_id]        INT            NULL,
    [_menu_name]      NVARCHAR (256) NULL,
    [_menu_action]    NVARCHAR (128) NULL
);
GO

ALTER TABLE [V20232].[dim_menu]
    ADD CONSTRAINT [PK_dim_menu] PRIMARY KEY CLUSTERED ([_menu_unique_id] ASC);
GO

