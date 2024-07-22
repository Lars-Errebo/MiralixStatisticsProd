CREATE TABLE [LOAD].[office_team_statistics_menu] (
    [id]                   INT           NOT NULL,
    [_created]             DATETIME2 (7) NULL,
    [_call_id]             INT           NULL,
    [_quarter_number]      INT           NULL,
    [_global_call_id]      VARCHAR (128) NULL,
    [_sequence_number]     INT           NULL,
    [_event_time]          DATETIME2 (7) NULL,
    [_menu_id]             INT           NULL,
    [_menu_name]           VARCHAR (256) NULL,
    [_action]              VARCHAR (128) NULL,
    [_call_component_type] VARCHAR (128) NULL,
    [_call_component_id]   INT           NULL,
    [_call_component_name] VARCHAR (256) NULL,
    [_process_id]          INT           NULL,
    [_process_name]        VARCHAR (256) NULL,
    [_left_menu]           DATETIME2 (7) NULL,
    [_paf_id]              INT           NULL,
    [_paf_name]            VARCHAR (257) NULL,
    [_stamp]               DATETIME2 (7) NULL,
    [_media_type]          VARCHAR (128) NULL,
    [_dongle_id]           VARCHAR (10)  NOT NULL,
    [_data_loaded]         DATETIME2 (7) NULL
);
GO

