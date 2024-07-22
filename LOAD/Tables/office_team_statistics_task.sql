CREATE TABLE [LOAD].[office_team_statistics_task] (
    [id]                   INT            NULL,
    [_stamp]               DATETIME2 (7)  NULL,
    [_created]             DATETIME2 (7)  NULL,
    [_task_id]             INT            NULL,
    [_quarter_number]      INT            NULL,
    [_sequence_number]     INT            NULL,
    [_global_task_id]      VARCHAR (128)  NULL,
    [_task_start]          DATETIME2 (7)  NULL,
    [_task_ended]          DATETIME2 (7)  NULL,
    [_type]                VARCHAR (128)  NULL,
    [_agent_id]            INT            NULL,
    [_agent_name]          VARCHAR (257)  NULL,
    [_external_task_id]    VARCHAR (256)  NULL,
    [_subject]             VARCHAR (512)  NULL,
    [_tags]                VARCHAR (1024) NULL,
    [_language]            VARCHAR (50)   NULL,
    [_external_source]     VARCHAR (50)   NULL,
    [_call_component_type] VARCHAR (128)  NULL,
    [_call_component_id]   INT            NULL,
    [_call_component_name] VARCHAR (256)  NULL,
    [_dongle_id]           VARCHAR (10)   NOT NULL,
    [_data_loaded]         DATETIME2 (7)  NULL
);
GO

