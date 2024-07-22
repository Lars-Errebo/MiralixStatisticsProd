







-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [VIEW].[Update_dim_merge]
AS
BEGIN    
	
	SET NOCOUNT ON

	--Update [VIEW].[DongleConfig]
	--set InquiriesIncreased = 1
	--where Enabled = 1	
	
	MERGE [V20232].[dim_dongle] AS T
	USING [VIEW].[dim_dongle]AS S
	ON S.[_dongle_id] = T.[_dongle_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_dongle_id], [_date_min], [_date_max])
		VALUES (S.[_dongle_id],S.[_date_min],S.[_date_max])	
	WHEN MATCHED THEN UPDATE SET
		 T.[_date_min] = S.[_date_min],
		 T.[_date_max] = S.[_date_max];
	

	MERGE [V20232].[dim_agent_event_agent_org] AS T
	USING [VIEW].[dim_agent_event_agent_org] AS S
	ON S.[_agent_event_agent_org_unique_id] = T.[_agent_event_agent_org_unique_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_agent_event_agent_org_unique_id], [_dongle_id], [_agent_address_name], [_agent_address_id], [_agent_company_name], [_agent_company_id], [_agent_department_name], [_agent_department_id], [_agent_name], [_agent_id], [_max_event_start])
		VALUES (S.[_agent_event_agent_org_unique_id],S.[_dongle_id],S.[_agent_address_name],S.[_agent_address_id],S.[_agent_company_name],S.[_agent_company_id],S.[_agent_department_name],S.[_agent_department_id],S.[_agent_name],S.[_agent_id],S.[_max_event_start])
	WHEN MATCHED THEN UPDATE SET
		T.[_dongle_id]             = S.[_dongle_id],
		T.[_agent_address_name]    = S.[_agent_address_name],
        T.[_agent_address_id]      = S.[_agent_address_id],
		T.[_agent_company_name]    = S.[_agent_company_name],
        T.[_agent_company_id]      = S.[_agent_company_id],
		T.[_agent_department_name] = S.[_agent_department_name],
        T.[_agent_department_id]   = S.[_agent_department_id],
		T.[_agent_name]            = S.[_agent_name],
        T.[_agent_id]              = S.[_agent_id],
		T.[_max_event_start]       = S.[_max_event_start];

	MERGE [V20232].[dim_agent_event_junk] AS T
	USING [VIEW].[dim_agent_event_junk] AS S
	ON S.[_agent_event_junk_unique_id] = T.[_agent_event_junk_unique_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_agent_event_junk_unique_id], [_dongle_id], [_agent_skill], [_agent_client], [_event_type], [_event_type_group], [_event_type_call_answered_status], [_pause_reason], [_note])
		VALUES (S.[_agent_event_junk_unique_id],S.[_dongle_id],S.[_agent_skill],S.[_agent_client],S.[_event_type],S.[_event_type_group], S.[_event_type_call_answered_status],S.[_pause_reason],S.[_note])
	WHEN MATCHED THEN UPDATE SET
		T.[_dongle_id]                       = S.[_dongle_id],
		T.[_agent_skill]                     = S.[_agent_skill],
		T.[_agent_client]                    = S.[_agent_client],
		T.[_event_type]                      = S.[_event_type],
		T.[_event_type_group]                = S.[_event_type_group],
		T.[_event_type_call_answered_status] = S.[_event_type_call_answered_status],
		T.[_pause_reason]                    = S.[_pause_reason],
		T.[_note]                            = S.[_note];

	MERGE [V20232].[dim_agent_event_queue_name] AS T
	USING [VIEW].[dim_agent_event_queue_name] AS S
	ON S.[_agent_event_queue_name_unique_id] = T.[_agent_event_queue_name_unique_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_agent_event_queue_name_unique_id], [_dongle_id], [_queue_id], [_queue_name], [_tags])
		VALUES (S.[_agent_event_queue_name_unique_id],S.[_dongle_id],S.[_queue_id],S.[_queue_name],S.[_tags])
	WHEN MATCHED THEN UPDATE SET
		T.[_dongle_id]  = S.[_dongle_id],
		T.[_queue_id]   = S.[_queue_id],
		T.[_queue_name] = S.[_queue_name], 
		T.[_tags]       = S.[_tags];
	
	MERGE [V20232].[dim_call] AS T
	USING [VIEW].[dim_call] AS S
	ON S.[_endpoint_contact_unique_id] = T.[_endpoint_contact_unique_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_endpoint_contact_unique_id], [_dongle_id], [_endpoint_contact_column], [_endpoint_contact_type], [_endpoint_contact_number], [_endpoint_contact_name], [_endpoint_contact_address], [_endpoint_contact_department], [_endpoint_contact_company])
		VALUES (S.[_endpoint_contact_unique_id],S.[_dongle_id],S.[_endpoint_contact_column],S.[_endpoint_contact_type],S.[_endpoint_contact_number],S.[_endpoint_contact_name],S.[_endpoint_contact_address],S.[_endpoint_contact_department],S.[_endpoint_contact_company])
	WHEN MATCHED THEN UPDATE SET
		T.[_dongle_id]                   = S.[_dongle_id],
		T.[_endpoint_contact_column]     = S.[_endpoint_contact_column],
		T.[_endpoint_contact_type]       = S.[_endpoint_contact_type],
		T.[_endpoint_contact_number]     = S.[_endpoint_contact_number],
		T.[_endpoint_contact_name]       = S.[_endpoint_contact_name],
		T.[_endpoint_contact_address]    = S.[_endpoint_contact_address],
		T.[_endpoint_contact_department] = S.[_endpoint_contact_department],
		T.[_endpoint_contact_company]    = S.[_endpoint_contact_company];
	
	MERGE [V20232].[dim_call_component] AS T
	USING [VIEW].[dim_call_component] AS S
	ON S.[_call_component_unique_id] = T.[_call_component_unique_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_call_component_unique_id], [_dongle_id], [_call_component], [_call_component_name], [_call_component_type])
		VALUES (S.[_call_component_unique_id],S.[_dongle_id],S.[_call_component],S.[_call_component_name],S.[_call_component_type])
	WHEN MATCHED THEN UPDATE SET
		T.[_dongle_id]           = S.[_dongle_id],
		T.[_call_component]      = S.[_call_component],
		T.[_call_component_name] = S.[_call_component_name],
		T.[_call_component_type] = S.[_call_component_type];

	MERGE [V20232].[dim_entry_menu] AS T
	USING [VIEW].[dim_entry_menu] AS S
	ON S.[_entry_menu_unique_id] = T.[_entry_menu_unique_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_entry_menu_unique_id], [_menu_id], [_dongle_id], [_entry], [_entry_menu_name], [_entry_menu_action])
		VALUES (S.[_entry_menu_unique_id],S.[_menu_id],S.[_dongle_id],S.[_entry],S.[_entry_menu_name],S.[_entry_menu_action])
	WHEN MATCHED THEN UPDATE SET		
		T.[_menu_id]               = S.[_menu_id],
		T.[_dongle_id]             = S.[_dongle_id],
		T.[_entry]                 = S.[_entry],
		T.[_entry_menu_name]       = S.[_entry_menu_name],
		T.[_entry_menu_action]     = S.[_entry_menu_action];

	MERGE [V20232].[dim_menu] AS T
	USING [VIEW].[dim_menu] AS S
	ON S.[_menu_unique_id] = T.[_menu_unique_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_menu_unique_id], [_dongle_id], [_menu_id], [_menu_name], [_menu_action])
		VALUES (S.[_menu_unique_id],S.[_dongle_id],S.[_menu_id],S.[_menu_name],S.[_menu_action])
	WHEN MATCHED THEN UPDATE SET
		T.[_dongle_id]   = S.[_dongle_id],  
		T.[_menu_id]     = S.[_menu_id],  
		T.[_menu_name]   = S.[_menu_name],  
		T.[_menu_action] = S.[_menu_action];

	MERGE [V20232].[dim_queue_agent_name] AS T
	USING [VIEW].[dim_queue_agent_name] AS S
	ON S.[_queue_call_agent_org_unique_id] = T.[_queue_call_agent_org_unique_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_queue_call_agent_org_unique_id], [_dongle_id], [_agent_address_name],[_agent_address_id],[_agent_company_name],[_agent_company_id],[_agent_department_name],[_agent_department_id], [_agent_name],[_agent_id], [_max_event_start])
		VALUES (S.[_queue_call_agent_org_unique_id],S.[_dongle_id],S.[_agent_address_name],S.[_agent_address_id],S.[_agent_company_name],S.[_agent_company_id],S.[_agent_department_name],S.[_agent_department_id],S.[_agent_name],S.[_agent_id],S.[_max_event_start])
	WHEN MATCHED THEN UPDATE SET
		T.[_agent_address_name]    = S.[_agent_address_name],
        T.[_agent_address_id]      = S.[_agent_address_id],
		T.[_agent_company_name]    = S.[_agent_company_name],
        T.[_agent_company_id]      = S.[_agent_company_id],
		T.[_agent_department_name] = S.[_agent_department_name],
        T.[_agent_department_id]   = S.[_agent_department_id],
		T.[_agent_name]            = S.[_agent_name],
        T.[_agent_id]              = S.[_agent_id],
		T.[_max_event_start]       = S.[_max_event_start];
	
	MERGE [V20232].[dim_queue_call_junk] AS T
	USING [VIEW].[dim_queue_call_junk] AS S
	ON S.[_queue_call_junk_unique_id] = T.[_queue_call_junk_unique_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_queue_call_junk_unique_id], [_dongle_id], [_agent_skill], [_agent_client], [_action], [_call_type], [_overflow_type])
		VALUES (S.[_queue_call_junk_unique_id],S.[_dongle_id],S.[_agent_skill],S.[_agent_client],S.[_action],S.[_call_type],S.[_overflow_type])
	WHEN MATCHED THEN UPDATE SET
		 T.[_dongle_id]     = S.[_dongle_id],
		 T.[_agent_skill]   = S.[_agent_skill],
		 T.[_agent_client]  = S.[_agent_client],
		 T.[_action]        = S.[_action],
		 T.[_call_type]     = S.[_call_type],
		 T.[_overflow_type] = S.[_overflow_type];
	
	MERGE[V20232].[dim_queue_call_queue_name]  AS T
	USING [VIEW].[dim_queue_call_queue_name] AS S
	ON S.[_queue_call_queue_name_unique_id] = T.[_queue_call_queue_name_unique_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_queue_call_queue_name_unique_id], [_dongle_id], [_queue_id], [_queue_name], [_tags])
		VALUES (S.[_queue_call_queue_name_unique_id],S.[_dongle_id],S.[_queue_id],S.[_queue_name],S.[_tags])
	WHEN MATCHED THEN UPDATE SET
		T.[_dongle_id]  = S.[_dongle_id],
		T.[_queue_id]   = S.[_queue_id],
		T.[_queue_name] = S.[_queue_name],
		T.[_tags]       = S.[_tags];

	MERGE [V20232].[dim_transfer] AS T
	USING [VIEW].[dim_transfer] AS S
	ON S.[_transfer_unique_id] = T.[_transfer_unique_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_transfer_unique_id], [_dongle_id], [_transfer_id], [_transfer_name], [_transfer_type], [_transfer_action], [_transfer_destination])
		VALUES (S.[_transfer_unique_id],S.[_dongle_id],S.[_transfer_id],S.[_transfer_name],S.[_transfer_type],S.[_transfer_action],S.[_transfer_destination])
	WHEN MATCHED THEN UPDATE SET
		T.[_dongle_id]            = S.[_dongle_id],
		T.[_transfer_id]          = S.[_transfer_id],
		T.[_transfer_name]        = S.[_transfer_name],
		T.[_transfer_type]        = S.[_transfer_type],
		T.[_transfer_action]      = S.[_transfer_action],
		T.[_transfer_destination] = S.[_transfer_destination];

	MERGE [V20232].[dim_voicemail] AS T
	USING [VIEW].[dim_voicemail] AS S
	ON S.[_voicemail_unique_id] = T.[_voicemail_unique_id]
	WHEN NOT MATCHED BY Target THEN
		INSERT ([_voicemail_unique_id], [_dongle_id], [_voicemail_id], [_action], [_heard_by_name], [_user_account_name], [_voicemail_account_name],[_voicemail_account_id])
		VALUES (S.[_voicemail_unique_id],S.[_dongle_id],S.[_voicemail_id],S.[_action],S.[_heard_by_name],S.[_user_account_name],S.[_voicemail_account_name],S.[_voicemail_account_id])
	WHEN MATCHED THEN UPDATE SET
		T.[_dongle_id]              = S.[_dongle_id],
		T.[_voicemail_id]           = S.[_voicemail_id],
		T.[_action]                 = S.[_action],
		T.[_heard_by_name]          = S.[_heard_by_name],
		T.[_user_account_name]      = S.[_user_account_name],
		T.[_voicemail_account_name] = S.[_voicemail_account_name],
		T.[_voicemail_account_id]   = S.[_voicemail_account_id];

	UPDATE [V20232].[dim_agent_event_agent_org] 
	SET _agent_name = 'Agent ' + right(lower(convert(nvarchar(100),HASHBYTES('MD5',CONCAT('Agent',_dongle_id,_agent_id)),2)),12)
	where not exists ( select _agent_id from [TMP].[user_account] where _dongle_id = [V20232].[dim_agent_event_agent_org]._dongle_id and _agent_id = [V20232].[dim_agent_event_agent_org]._agent_id and _type = 1)
	and [V20232].[dim_agent_event_agent_org]._agent_id is not null

	UPDATE [MiralixStatisticsProd].[V20232].[dim_queue_agent_name]
    SET _agent_name = 'Agent ' +  right(lower(convert(nvarchar(100),HASHBYTES('MD5',CONCAT('Agent',_dongle_id,_agent_id)),2)),12)
    where not exists ( select _agent_id from [TMP].[user_account] where _dongle_id = [V20232].[dim_queue_agent_name]._dongle_id and _agent_id = [V20232].[dim_queue_agent_name]._agent_id  and _type = 2)
    and [V20232].[dim_queue_agent_name]._agent_id is not null

	--select right(lower(convert(nvarchar(100),HASHBYTES('MD5',CONCAT('Agent','_1710',100)),2)),11)
	


END
GO

