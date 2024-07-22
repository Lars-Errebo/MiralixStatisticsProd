CREATE TABLE [V20232].[dim_agent_event_junk] (
    [_agent_event_junk_unique_id]      NVARCHAR (100) NOT NULL,
    [_dongle_id]                       INT            NULL,
    [_agent_skill]                     INT            NULL,
    [_agent_client]                    NVARCHAR (128) NULL,
    [_event_type]                      NVARCHAR (128) NULL,
    [_event_type_group]                NVARCHAR (128) NULL,
    [_event_type_call_answered_status] NVARCHAR (128) NULL,
    [_pause_reason]                    NVARCHAR (256) NULL,
    [_note]                            NVARCHAR (256) NULL
);
GO

ALTER TABLE [V20232].[dim_agent_event_junk]
    ADD CONSTRAINT [PK_dim_agent_event_junk] PRIMARY KEY CLUSTERED ([_agent_event_junk_unique_id] ASC);
GO

