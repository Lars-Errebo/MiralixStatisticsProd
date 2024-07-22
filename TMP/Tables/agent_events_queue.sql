CREATE TABLE [TMP].[agent_events_queue] (
    [_agent_event_queue_name_unique_id] NVARCHAR (100)  NULL,
    [_dongle_id]                        INT             NULL,
    [_queue_id]                         INT             NULL,
    [_queue_name]                       NVARCHAR (300)  NULL,
    [_tags]                             NVARCHAR (2000) NULL
);
GO

