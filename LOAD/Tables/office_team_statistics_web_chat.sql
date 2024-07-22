CREATE TABLE [LOAD].[office_team_statistics_web_chat] (
    [id]                   INT           NULL,
    [_stamp]               DATETIME2 (7) NULL,
    [_created]             DATETIME2 (7) NULL,
    [_web_chat_id]         INT           NULL,
    [_quarter_number]      INT           NULL,
    [_sequence_number]     INT           NULL,
    [_global_web_chat_id]  VARCHAR (128) NULL,
    [_web_chat_start]      DATETIME2 (7) NULL,
    [_web_chat_ended]      DATETIME2 (7) NULL,
    [_agent_id]            INT           NULL,
    [_agent_name]          VARCHAR (257) NULL,
    [_language]            VARCHAR (50)  NULL,
    [_call_component_type] VARCHAR (128) NULL,
    [_call_component_id]   INT           NULL,
    [_call_component_name] VARCHAR (256) NULL,
    [_type]                VARCHAR (128) NULL,
    [_dongle_id]           VARCHAR (10)  NOT NULL,
    [_data_loaded]         DATETIME2 (7) NULL
);
GO

