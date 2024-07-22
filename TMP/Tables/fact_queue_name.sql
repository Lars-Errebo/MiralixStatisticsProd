CREATE TABLE [TMP].[fact_queue_name] (
    [_dongle_id]                                  INT            NULL,
    [id]                                          INT            NULL,
    [orig]                                        INT            NULL,
    [_queue_call_queue_name_unique_id]            NVARCHAR (100) NULL,
    [_endpoint_contact_called_unique_id]          NVARCHAR (100) NULL,
    [_endpoint_contact_calling_unique_id]         NVARCHAR (100) NULL,
    [_endpoint_contact_transferred_unique_id]     NVARCHAR (100) NULL,
    [_endpoint_contact_transfer_unique_id]        NVARCHAR (100) NULL,
    [_queue_call_agent_org_unique_id]             NVARCHAR (100) NULL,
    [_queue_call_junk_unique_id]                  NVARCHAR (100) NULL,
    [_call_component_unique_id]                   NVARCHAR (100) NULL,
    [_date_id]                                    INT            NULL,
    [_time_id]                                    INT            NULL,
    [_queue_call_table_id]                        INT            NULL,
    [_queue_call_id]                              INT            NULL,
    [_callback]                                   INT            NULL,
    [_callback_agent_logged_out]                  INT            NULL,
    [_callback_agent_new_queue]                   INT            NULL,
    [_callback_agent_no_agent_feedback]           INT            NULL,
    [_callback_replaced_by_new_call]              INT            NULL,
    [_callback_failed]                            INT            NULL,
    [_callback_succesful]                         INT            NULL,
    [_callback_none]                              INT            NULL,
    [_callback_time]                              INT            NULL,
    [_callback_attempts]                          INT            NULL,
    [_first_call_duration]                        INT            NULL,
    [_consultation_transfer_duration]             INT            NULL,
    [_unhandled_action_handled_time]              INT            NULL,
    [_callback_choice_time]                       INT            NULL,
    [_waiting_time]                               INT            NULL,
    [_transfer]                                   INT            NULL,
    [_overflow_all_agent_paused]                  INT            NULL,
    [_overflow_call_waiting_more_than]            INT            NULL,
    [_overflow_caller_pressed_dtmf]               INT            NULL,
    [_overflow_longest_waiting_call]              INT            NULL,
    [_overflow_no_agents_are_avaliable]           INT            NULL,
    [_overflow_no_agents_are_logged_in]           INT            NULL,
    [_overflow_one_or_more_calls_in_queue]        INT            NULL,
    [_call_qualification]                         INT            NULL,
    [_call_no_qualification]                      INT            NULL,
    [_call_answered]                              INT            NULL,
    [_call_pulled_by_agent]                       INT            NULL,
    [_call_lost]                                  INT            NULL,
    [_call_lost_before_5_sek]                     INT            NULL,
    [_call_lost_after_5_sek_before_10_sek]        INT            NULL,
    [_call_lost_after_10_sek_before_15_sek]       INT            NULL,
    [_call_lost_after_15_sek_before_30_sek]       INT            NULL,
    [_call_lost_after_30_sek_before_60_sek]       INT            NULL,
    [_call_lost_after_60_sek_before_120_sek]      INT            NULL,
    [_call_lost_after_120_sek_before_300_sek]     INT            NULL,
    [_call_lost_after_300_sek]                    INT            NULL,
    [_overflow]                                   INT            NULL,
    [_overflow_new]                               INT            NULL,
    [_overflow_existing]                          INT            NULL,
    [_call_service_level_yes]                     INT            NULL,
    [_call_service_level_no]                      INT            NULL,
    [_call_service_level_none]                    INT            NULL,
    [test]                                        NVARCHAR (100) NULL,
    [_transfer_call]                              INT            NULL,
    [_transfer_consultation_call]                 INT            NULL,
    [_transfer_direct_call]                       INT            NULL,
    [_transfer_type]                              NVARCHAR (50)  NULL,
    [_unhandled_action_handled_as_unhandled_call] INT            NULL,
    [_unhandled_action_removed_by_new_call]       INT            NULL,
    [_call_qualification_name]                    NVARCHAR (250) NULL,
    [_media_type]                                 NVARCHAR (100) NULL
);
GO

