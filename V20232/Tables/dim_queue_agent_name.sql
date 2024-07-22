CREATE TABLE [V20232].[dim_queue_agent_name] (
    [_queue_call_agent_org_unique_id] NVARCHAR (100) NOT NULL,
    [_dongle_id]                      INT            NULL,
    [_agent_address_name]             NVARCHAR (256) NULL,
    [_agent_address_id]               INT            NULL,
    [_agent_company_name]             NVARCHAR (256) NULL,
    [_agent_company_id]               INT            NULL,
    [_agent_department_name]          NVARCHAR (256) NULL,
    [_agent_department_id]            INT            NULL,
    [_agent_name]                     NVARCHAR (257) NULL,
    [_agent_id]                       INT            NULL,
    [_max_event_start]                DATETIME2 (7)  NULL
);
GO

ALTER TABLE [V20232].[dim_queue_agent_name]
    ADD CONSTRAINT [PK_dim_queue_agent_name] PRIMARY KEY CLUSTERED ([_queue_call_agent_org_unique_id] ASC);
GO

