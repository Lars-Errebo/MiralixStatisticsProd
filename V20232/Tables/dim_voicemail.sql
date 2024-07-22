CREATE TABLE [V20232].[dim_voicemail] (
    [_voicemail_unique_id]    NVARCHAR (100) NOT NULL,
    [_dongle_id]              INT            NULL,
    [_voicemail_id]           INT            NULL,
    [_action]                 NVARCHAR (128) NULL,
    [_heard_by_name]          NVARCHAR (256) NULL,
    [_user_account_name]      NVARCHAR (256) NULL,
    [_voicemail_account_name] NVARCHAR (256) NULL,
    [_voicemail_account_id]   INT            NULL
);
GO

ALTER TABLE [V20232].[dim_voicemail]
    ADD CONSTRAINT [PK_dim_voicemail] PRIMARY KEY CLUSTERED ([_voicemail_unique_id] ASC);
GO

