CREATE TABLE [TMP].[agent_events_trans] (
    [#row]                       INT            NULL,
    [_queue_call_id]             INT            NULL,
    [_dongle_id]                 INT            NULL,
    [_event_type]                NVARCHAR (200) NULL,
    [_transfer_agent_id]         INT            NULL,
    [_transfer_agent_name]       NVARCHAR (300) NULL,
    [_transfer_contact_endpoint] NVARCHAR (300) NULL,
    [_transfer_source_id]        INT            NULL,
    [_transfer_type]             NVARCHAR (100) NULL,
    [_transfer_name]             NVARCHAR (300) NULL,
    [_transfer_department]       NVARCHAR (300) NULL,
    [_transfer_company]          NVARCHAR (300) NULL,
    [_transfer_address]          NVARCHAR (300) NULL,
    [_param1]                    NVARCHAR (300) NULL,
    [_param2]                    NVARCHAR (300) NULL,
    [_call_id]                   INT            NULL
);
GO

