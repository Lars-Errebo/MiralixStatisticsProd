CREATE TABLE [TMP].[agent_events_junk] (
    [_agent_event_junk_unique_id]      NVARCHAR (100) NULL,
    [_dongle_id]                       INT            NULL,
    [_agent_skill]                     INT            NULL,
    [_agent_client]                    NVARCHAR (300) NULL,
    [_event_type]                      NVARCHAR (200) NULL,
    [_event_type_group]                NVARCHAR (200) NULL,
    [_event_type_call_answered_status] NVARCHAR (200) NULL,
    [_pause_reason]                    NVARCHAR (200) NULL,
    [_note]                            NVARCHAR (500) NULL
);
GO

