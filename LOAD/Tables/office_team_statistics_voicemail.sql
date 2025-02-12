CREATE TABLE [LOAD].[office_team_statistics_voicemail] (
    [id]                        INT           NOT NULL,
    [_created]                  DATETIME2 (7) NULL,
    [_call_id]                  INT           NULL,
    [_quarter_number]           INT           NULL,
    [_global_call_id]           VARCHAR (128) NULL,
    [_sequence_number]          INT           NULL,
    [_event_time]               DATETIME2 (7) NULL,
    [_voicemail_account_id]     INT           NULL,
    [_voicemail_account_name]   VARCHAR (256) NULL,
    [_group]                    BIT           NULL,
    [_user_account_id]          INT           NULL,
    [_user_account_name]        VARCHAR (256) NULL,
    [_action]                   VARCHAR (50)  NULL,
    [_dtmf_call_component_type] VARCHAR (128) NULL,
    [_dtmf_call_component_id]   INT           NULL,
    [_dtmf_call_component_name] VARCHAR (256) NULL,
    [_dtmf_mobile_phone]        VARCHAR (128) NULL,
    [_paf_id]                   INT           NULL,
    [_paf_name]                 VARCHAR (257) NULL,
    [_stamp]                    DATETIME2 (7) NULL,
    [_heard]                    DATETIME2 (7) NULL,
    [_user_company_id]          INT           NULL,
    [_user_company_name]        VARCHAR (256) NULL,
    [_user_department_id]       INT           NULL,
    [_user_department_name]     VARCHAR (256) NULL,
    [_user_address_id]          INT           NULL,
    [_user_address_name]        VARCHAR (256) NULL,
    [_message_id]               INT           NULL,
    [_heard_by_id]              INT           NULL,
    [_heard_by_name]            VARCHAR (257) NULL,
    [_dongle_id]                VARCHAR (10)  NOT NULL,
    [_data_loaded]              DATETIME2 (7) NULL
);
GO

