CREATE TABLE [LOAD].[office_team_statistics_queue_web_chat] (
    [id]                             INT            NULL,
    [_stamp]                         DATETIME2 (7)  NULL,
    [_created]                       DATETIME2 (7)  NULL,
    [_web_chat_id]                   INT            NULL,
    [_quarter_number]                INT            NULL,
    [_global_web_chat_id]            VARCHAR (128)  NULL,
    [_sequence_number]               INT            NULL,
    [_event_time]                    DATETIME2 (7)  NULL,
    [_queue_web_chat_id]             INT            NULL,
    [_queue_id]                      INT            NULL,
    [_queue_name]                    VARCHAR (256)  NULL,
    [_action]                        VARCHAR (128)  NULL,
    [_agent_web_chat_distribution]   VARCHAR (128)  NULL,
    [_agent_id]                      INT            NULL,
    [_agent_name]                    VARCHAR (257)  NULL,
    [_agent_count]                   INT            NULL,
    [_agent_skill]                   INT            NULL,
    [_agent_client]                  VARCHAR (256)  NULL,
    [_agent_web_chat_duration]       TIME (7)       NULL,
    [_agent_company_id]              INT            NULL,
    [_agent_company_name]            VARCHAR (256)  NULL,
    [_agent_department_id]           INT            NULL,
    [_agent_department_name]         VARCHAR (256)  NULL,
    [_agent_address_id]              INT            NULL,
    [_agent_address_name]            VARCHAR (256)  NULL,
    [_agent_offered_duration]        TIME (7)       NULL,
    [_agent_pickup]                  DATETIME2 (7)  NULL,
    [_overflow_type]                 VARCHAR (128)  NULL,
    [_call_component_type]           VARCHAR (128)  NULL,
    [_call_component_id]             INT            NULL,
    [_call_component_name]           VARCHAR (256)  NULL,
    [_service_level]                 VARCHAR (128)  NULL,
    [_left_queue]                    DATETIME2 (7)  NULL,
    [_tags]                          VARCHAR (1024) NULL,
    [_terminated_by_external_source] VARCHAR (50)   NULL,
    [_call_qualification_id]         INT            NULL,
    [_call_qualification_name]       VARCHAR (MAX)  NULL,
    [_dongle_id]                     VARCHAR (10)   NULL,
    [_data_loaded]                   DATETIME2 (7)  NULL
);
GO

