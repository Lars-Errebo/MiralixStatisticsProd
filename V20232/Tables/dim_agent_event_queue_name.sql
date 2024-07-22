CREATE TABLE [V20232].[dim_agent_event_queue_name] (
    [_agent_event_queue_name_unique_id] NVARCHAR (100)  NOT NULL,
    [_queue_id]                         INT             NULL,
    [_dongle_id]                        INT             NULL,
    [_queue_name]                       NVARCHAR (256)  NULL,
    [_tags]                             NVARCHAR (1024) NULL
);
GO

ALTER TABLE [V20232].[dim_agent_event_queue_name]
    ADD CONSTRAINT [PK_dim_agent_event_queue_name] PRIMARY KEY CLUSTERED ([_agent_event_queue_name_unique_id] ASC);
GO

