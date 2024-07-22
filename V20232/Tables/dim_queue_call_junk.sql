CREATE TABLE [V20232].[dim_queue_call_junk] (
    [_queue_call_junk_unique_id] NVARCHAR (100) NOT NULL,
    [_dongle_id]                 INT            NULL,
    [_agent_skill]               INT            NULL,
    [_agent_client]              NVARCHAR (256) NULL,
    [_action]                    NVARCHAR (128) NULL,
    [_call_type]                 NVARCHAR (128) NULL,
    [_overflow_type]             NVARCHAR (128) NULL
);
GO

ALTER TABLE [V20232].[dim_queue_call_junk]
    ADD CONSTRAINT [PK_dim_queue_call_junk] PRIMARY KEY CLUSTERED ([_queue_call_junk_unique_id] ASC);
GO

