
CREATE PROCEDURE [dbo].[MRX-View-5-4-6-Prep-Script]
	@DongleSN INT
AS
BEGIN
		DECLARE @Schema NVARCHAR(5)

		SET @Schema = CONCAT('_',CAST(@DongleSN AS NVARCHAR(4)))

		DECLARE @SQLString NVARCHAR(MAX);  

		-- birst_agent_event_5_4_6 DROP		
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.birst_agent_event_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[birst_agent_event_5_4_6]')
		
		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		-- birst_agent_event_6_0_0		
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.birst_agent_event_6_0_0'') AND type = N''V'') DROP VIEW [',@Schema,'].[birst_agent_event_6_0_0]')
		
		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE VIEW [', @Schema,'].[birst_agent_event_6_0_0]
					AS
		SELECT [id] AS id,
			[_call_id] AS _call_id,
			[_stamp] AS _stamp,
			[dbo].[datetime_to_quater_hour]([_event_start]) AS _quarter_number,
			[dbo].[datetime_to_hour]([_event_start]) AS _hour,
			DATEPART(iso_week, [_event_start]) AS _week_number,
			[_global_call_id] AS _global_call_id,
			[_sequence_number] AS _sequence_number,
			[_event_start] AS _event_start,
			[_event_stop] AS _event_stop,
			[_agent_name] AS _agent_name,
			[_agent_skill] AS _agent_skill,
			[_agent_client] AS _agent_client,
			[_agent_company_name] AS _agent_company_name,
			[_agent_department_name] AS _agent_department_name,
			[_agent_address_name] AS _agent_address_name,
			[_private_call_id] AS _private_call_id,
			[_queue_call_id] AS _queue_call_id,
			[_queue_name] AS _queue_name,
			[_event_type] AS _event_type,
			[_transfer_contact_endpoint] AS _transfer_contact_endpoint,
			[_transfer_agent_id] AS _transfer_agent_id,
			[_transfer_agent_name] AS _transfer_agent_name,
			[_call_qualification_id] AS _call_qualification_id,
			[_call_qualification_name] AS _call_qualification_name,
			[_role_id] AS _role_id,
			[_role_name] AS _role_name,
			[_tags] AS _tags,
			[_pause_reason] AS _pause_reason,
			[_param1] AS _param1,
			[_param2] AS _param2,
			[_param3] AS _param3,
			[_param4] AS _param4,
			               CASE
				               WHEN DATEDIFF(DAY, _event_start, _event_stop) < 23 OR DATEDIFF(YEAR, _event_start, _event_stop) < 1 
						       THEN DATEDIFF(MILLISECOND, _event_start, _event_stop)
						   END AS ''sql_event_duration'',
						   NULL AS ''sql_officeteamcall_duration'',
						   CASE
							   WHEN _event_type = ''CallOfferedAcceptedCall'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_callofferedacceptedcall_duration'',
						   CASE
							   WHEN _event_type = ''Paused'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_paused_duration'',
						   CASE
							   WHEN _event_type = ''Ready'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_ready_duration'',
						   CASE
							   WHEN _event_type = ''AfterCallWorkTime'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_aftercallworktime_duration'',
						   CASE
							   WHEN _event_type = ''Quarantined'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_quarantined_duration'',
						   NULL AS ''sql_privatecallin_duration'',
						   NULL AS ''sql_privatecallout_duration'',
						   NULL AS ''sql_privatecallunknown_duration'',
						   CASE
							   WHEN _event_type = ''CallOfferedNotAcceptedCall'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
							   END AS ''sql_callofferednotacceptedcall_duration'',
						   CASE
							   WHEN _event_type = ''CallOfferedCallerHangup'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_callofferedcallerhangup_duration'',
						   NULL AS ''sql_call'',
						   NULL AS ''sql_office_team_call'',
						   CASE
							   WHEN _event_type IN ( ''CallOfferedAcceptedCall'', ''CallOfferedNotAcceptedCall'' ) THEN
								   1
						   END AS ''sql_offered_call'',
						   CASE
							   WHEN _event_type = ''CallOfferedAcceptedCall'' THEN
								   1
						   END AS ''sql_offered_accepted_call'',
						   NULL AS ''sql_private_call_out'',
						   NULL AS ''sql_private_call_in'',
						   NULL AS ''sql_private_call_unknown'',
						   CASE
							   WHEN _event_type = ''CallOfferedNotAcceptedCall'' THEN
								   1
						   END AS ''sql_call_offered_not_accepted_call'',
						   CASE
							   WHEN _event_type = ''CallOfferedCallerHangup'' THEN
								   1
						   END AS ''sql_call_offered_caller_hangup'',
						   CASE
							   WHEN _event_type = ''CallOfferedPickedByOtherAgent'' THEN
								   1
						   END AS ''sql_call_offered_picked_by_other_agent'',
						   CASE
							   WHEN _event_type = ''MotTransfer'' THEN
								   1
						   END AS ''sql_mot_transfer'',
						   CASE
							   WHEN _event_type = ''MotCobTransfer'' THEN
								   1
						   END AS ''sql_mot_cob_transfer'',
						   CASE
							   WHEN _event_type = ''PickedUpCall'' THEN
								   1
						   END AS ''sql_picked_up_call'',
						   CASE
							   WHEN _event_type = ''PrivateTransfer'' THEN
								   1
						   END AS ''sql_private_transfer'',
						   CASE
							   WHEN _event_type = ''PrivateCobTransfer'' THEN
								   1
						   END AS ''sql_private_cob_transfer'',
						   CASE
							   WHEN _event_type = ''ParkPrivateTransfer'' THEN
								   1
						   END AS ''sql_park_private_transfer'',
						   CASE
							   WHEN _event_type = ''ParkMotTransfer'' THEN
								   1
						   END AS ''sql_park_mot_transfer'',
						   CASE
							   WHEN _event_type = ''ReceivedMotTransfer'' THEN
								   1
						   END AS ''sql_received_mot_transfer'',
						   CASE
							   WHEN _event_type = ''CallQualification'' THEN
								   1
						   END AS ''sql_call_qualification'',
						   CASE
							   WHEN _event_type = ''Callofferendedbyservice'' THEN
								   1
						   END AS ''sql_call_offer_ended_by_service'',
						   CASE
							   WHEN _event_type = ''LoggedIn'' THEN
								   1
						   END AS ''sql_logged_in'',
						   CASE
							   WHEN _event_type = ''LoggedOut'' THEN
								   1
						   END AS ''sql_logged_out'',
						   CASE
							   WHEN _event_type = ''DuallineTransferRequest'' THEN
								   1
						   END AS ''sql_dualline_transfer_request'',
						   CASE
							   WHEN _event_type = ''PulledCallFromAgent'' THEN
								   1
						   END AS ''sql_pulled_call_from_agent'',
						   CASE
							   WHEN _event_type = ''PulledCallByAgent'' THEN
								   1
						   END AS ''sql_pulled_call_by_agent'',
						   CASE
							   WHEN _event_type = ''ReceivedMotPulled'' THEN
								   1
						   END AS ''sql_received_mot_pulled'',
						   CASE
							   WHEN _paf_call = 1 THEN
								   1
						   END AS ''sql_agent_paf_call'',
						   CASE
							   WHEN _pause_reason = ''None'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_pause_reason_none_duration'',
						   CASE
							   WHEN _pause_reason = ''MobilePhoneBusy'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_pause_reason_mobilephonebusy_duration'',
						   CASE
							   WHEN _pause_reason = ''NoteBusy'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_pause_reason_notebusy_duration'',
						   CASE
							   WHEN _pause_reason = ''CalendarBusy'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_pause_reason_calendarbusy_duration'',
						   CASE
							   WHEN _pause_reason = ''DoNotDisturb'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_pause_reason_donotdisturb_duration'',
						   CASE
							   WHEN _pause_reason = ''CallForwardingAlways'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_pause_reason_callforwardingalways_duration'',
						   CASE
							   WHEN _pause_reason = ''Agent'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_pause_reason_agent_duration'',
						   CASE
							   WHEN _pause_reason = ''OtherUser'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_pause_reason_otheruser_duration'',
						   CASE
							   WHEN _pause_reason = ''NoAudioDevice'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_pause_reason_noaudiodevice_duration'',
						   CASE
							   WHEN _pause_reason = ''MachineBusy'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_pause_reason_machinebusy_duration'',
						   CASE
							   WHEN _pause_reason = ''LyncBusy'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_pause_reason_lyncbusy_duration'',
						   CASE
							   WHEN _pause_reason = ''Service'' AND DATEDIFF(DAY,_event_start,_event_stop) < 23 AND DATEDIFF(YEAR,_event_start,_event_stop) < 1
							   THEN DATEDIFF(MILLISECOND,_event_start,_event_stop)
						   END AS ''sql_pause_reason_service_duration'',
						   CASE
							   WHEN _pause_reason = ''NoteBusy'' THEN
								   _param2
						   END AS ''sql_pause_reason_notebusy_text'',
						   CASE
							   WHEN _event_type = ''DuallineTransferRequest'' THEN
								   _transfer_contact_endpoint
						   END AS ''sql_dualline_transfer_request_endpoint'',
						   CASE
							   WHEN _event_type = ''ReceivedMotTransfer'' THEN
								   _transfer_contact_endpoint
						   END AS ''sql_received_mot_transfer_endpoint'',
						   CASE
							   WHEN _event_type = ''PrivateCallUnknown'' THEN
								   _transfer_contact_endpoint
						   END AS ''sql_private_call_unknown_endpoint'',
						   CASE
							   WHEN _event_type = ''PrivateCallIn'' THEN
								   _transfer_contact_endpoint
						   END AS ''sql_private_call_in_endpoint'',
						   CASE
							   WHEN _event_type = ''PrivateCallOut'' THEN
								   _transfer_contact_endpoint
						   END AS ''sql_private_call_out_endpoint'',
						   CASE
							   WHEN _event_type = ''MotCobTransfer'' THEN
								   _transfer_contact_endpoint
						   END AS ''sql_mot_cob_transfer_endpoint'',
						   CASE
							   WHEN _event_type = ''PrivateCobTransfer'' THEN
								   _transfer_contact_endpoint
						   END AS ''sql_private_cob_transfer_endpoint'',
						   CASE
							   WHEN _event_type = ''ParkPrivateTransfer'' THEN
								   _transfer_contact_endpoint
						   END AS ''sql_park_private_transfer_endpoint'',
						   CASE
							   WHEN _event_type = ''PrivateTransfer'' THEN
								   _transfer_contact_endpoint
						   END AS ''sql_private_transfer_endpoint'',
						   CASE
							   WHEN _event_type = ''MotTransfer'' THEN
								   _transfer_contact_endpoint
						   END AS ''sql_mot_transfer_endpoint''
	FROM ',@Schema,'.office_team_statistics_agent_event AS AE
	WHERE _event_type NOT IN(''OfficeTeamCall'',''OfficeTeamCallOnHold'',''PrivateCallIn'',''PrivateCallInOnHold'',''PrivateCallOut'',''PrivateCallOutOnHold'',''PrivateCallUnknown'',''PrivateCallUnknownOnHold'') 
	UNION ALL

		SELECT	MIN(AgentMetaData.[id]) AS id,
			MIN(AgentMetaData.[_call_id]) AS _call_id,
			MIN(AgentMetaData._stamp) AS _stamp,
			[dbo].[datetime_to_quater_hour](MIN(AgentMetaData.[_event_start])) AS _quarter_number,
			[dbo].[datetime_to_hour](MIN(AgentMetaData.[_event_start])) AS _hour,
			DATEPART(iso_week, MIN(AgentMetaData.[_event_start])) AS _week_number,
			MIN(AgentMetaData.[_global_call_id]) AS _global_call_id,
			MIN(AgentMetaData.[_sequence_number]) AS _sequence_number,
			MIN(AgentMetaData.[_event_start]) AS _event_start, 
			MAX(AgentMetaData.[_event_stop]) AS _event_stop, 
			AgentMetaData.[_agent_name] AS _agent_name,
			MIN(AgentMetaData.[_agent_skill]) AS _agent_skill,
			MIN(AgentMetaData.[_agent_client]) AS _agent_client,
			MIN(AgentMetaData.[_agent_company_name]) AS _agent_company_name,
			MIN(AgentMetaData.[_agent_department_name]) AS _agent_department_name,
			MIN(AgentMetaData.[_agent_address_name]) AS _agent_address_name,
			MIN(AgentMetaData.[_private_call_id]) AS _private_call_id,
			AgentMetaData.[_queue_call_id] AS _queue_call_id,
			MIN(AgentMetaData.[_queue_name]) AS _queue_name,
			MIN(AgentMetaData.[_event_type]) AS _event_type,
			MIN(AgentMetaData.[_transfer_contact_endpoint]) AS _transfer_contact_endpoint,
			MIN(AgentMetaData.[_transfer_agent_id]) AS _trasfer_agent_id,
			MIN(AgentMetaData.[_transfer_agent_name]) AS _transfer_agent_name,
			MIN(AgentMetaData.[_call_qualification_id]) AS _call_qualification_id,
			MIN(AgentMetaData.[_call_qualification_name]) AS _call_qualification_name,
			MIN(AgentMetaData.[_role_id]) AS _role_id,
			MIN(AgentMetaData.[_role_name]) AS _role_name,
			MIN(AgentMetaData.[_tags]) AS _tags,
			MIN(AgentMetaData.[_pause_reason]) AS _pause_reason,
			MIN(AgentMetaData.[_param1]) AS _param1,
			MIN(AgentMetaData.[_param2]) AS _param2,
			MIN(AgentMetaData.[_param3]) AS _param3,
			MIN(AgentMetaData.[_param4]) AS _param4,
			               CASE
				               WHEN DATEDIFF(DAY, MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) < 23 OR DATEDIFF(YEAR, MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) < 1 
						       THEN DATEDIFF(MILLISECOND, MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop))
						   END AS ''sql_event_duration'',
						   CASE
							   WHEN MIN(AgentMetaData._event_type) = ''OfficeteamCall'' AND DATEDIFF(DAY,MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) < 23 AND DATEDIFF(YEAR,MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) < 1
							   THEN DATEDIFF(MILLISECOND,MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) 
						   END AS ''sql_officeteamcall_duration'',
						   NULL AS ''sql_callofferedacceptedcall_duration'',
						   NULL AS ''sql_paused_duration'',
						   NULL AS ''sql_ready_duration'',
						   NULL AS ''sql_aftercallworktime_duration'',
						   NULL AS ''sql_quarantined_duration'',						   
						   NULL AS ''sql_privatecallin_duration'',
						   NULL AS ''sql_privatecallout_duration'',
						   NULL AS ''sql_privatecallunknown_duration'',
						   NULL AS ''sql_callofferednotacceptedcall_duration'',
						   NULL AS ''sql_callofferedcallerhangup_duration'',
						   1 AS ''sql_call'',
						   1 AS ''sql_office_team_call'',
						   NULL AS ''sql_offered_call'',
						   NULL AS ''sql_offered_accepted_call'',
						   NULL AS ''sql_private_call_out'',
						   NULL AS ''sql_private_call_in'',
						   NULL AS ''sql_private_call_unknown'',
						   NULL AS ''sql_call_offered_not_accepted_call'',
						   NULL AS ''sql_call_offered_caller_hangup'',
						   NULL AS ''sql_call_offered_picked_by_other_agent'',
						   NULL AS ''sql_mot_transfer'',
						   NULL AS ''sql_mot_cob_transfer'',
						   NULL AS ''sql_picked_up_call'',
						   NULL AS ''sql_private_transfer'',
						   NULL AS ''sql_private_cob_transfer'',
						   NULL AS ''sql_park_private_transfer'',
						   NULL AS ''sql_park_mot_transfer'',
						   NULL AS ''sql_received_mot_transfer'',
						   NULL AS ''sql_call_qualification'',
						   NULL AS ''sql_call_offer_ended_by_service'',
						   NULL AS ''sql_logged_in'',
						   NULL AS ''sql_logged_out'',
						   NULL AS ''sql_dualline_transfer_request'',
						   NULL AS ''sql_pulled_call_from_agent'',
						   NULL AS ''sql_pulled_call_by_agent'',
						   NULL AS ''sql_received_mot_pulled'',
						   CASE
							   WHEN AgentMetaData._paf_call = 1 THEN
								   1
						   END AS ''sql_agent_paf_call'',
						   NULL AS ''sql_pause_reason_none_duration'',
						   NULL AS ''sql_pause_reason_mobilephonebusy_duration'',
						   NULL AS ''sql_pause_reason_notebusy_duration'',
						   NULL AS ''sql_pause_reason_calendarbusy_duration'',
						   NULL AS ''sql_pause_reason_donotdisturb_duration'',
						   NULL AS ''sql_pause_reason_callforwardingalways_duration'',
						   NULL AS ''sql_pause_reason_agent_duration'',
						   NULL AS ''sql_pause_reason_otheruser_duration'',
						   NULL AS ''sql_pause_reason_noaudiodevice_duration'',
						   NULL AS ''sql_pause_reason_machinebusy_duration'',
						   NULL AS ''sql_pause_reason_lyncbusy_duration'',
						   NULL AS ''sql_pause_reason_service_duration'',
						   NULL AS ''sql_pause_reason_notebusy_text'',
						   NULL AS ''sql_dualline_transfer_request_endpoint'',
						   NULL AS ''sql_received_mot_transfer_endpoint'',
						   NULL AS ''sql_private_call_unknown_endpoint'',
						   NULL AS ''sql_private_call_in_endpoint'',
						   NULL AS ''sql_private_call_out_endpoint'',
						   NULL AS ''sql_mot_cob_transfer_endpoint'',
						   NULL AS ''sql_private_cob_transfer_endpoint'',
						   NULL AS ''sql_park_private_transfer_endpoint'',
						   NULL AS ''sql_private_transfer_endpoint'',
						   NULL AS ''sql_mot_transfer_endpoint''
		FROM ',@Schema,'.office_team_statistics_agent_event AS AgentMetaData
		LEFT JOIN (
		SELECT SUM(DATEDIFF(millisecond,QueueOnHold.[_event_start],QueueOnHold.[_event_stop])) AS QDURSUM, QueueOnHold.[_queue_call_id] AS QCID
		FROM ',@Schema,'.office_team_statistics_agent_event AS QueueOnHold
		WHERE QueueOnHold.[_event_type] = ''OfficeTeamCallOnHold''
		GROUP BY QueueOnHold.[_queue_call_id]) 
		AS Q 
		ON(AgentMetaData._queue_call_id=Q.QCID)
		WHERE AgentMetaData._queue_call_id IS NOT NULL AND AgentMetaData._event_type LIKE ''OfficeTeamCall%''
		GROUP BY AgentMetaData._queue_call_id, AgentMetaData._paf_call, AgentMetaData._agent_id, AgentMetaData._agent_name

		UNION ALL

		SELECT	MIN(AgentMetaData.[id]) AS id,
			MIN(AgentMetaData.[_call_id]) AS _call_id,
			MIN(AgentMetaData._stamp) AS _stamp,
			[dbo].[datetime_to_quater_hour](MIN(AgentMetaData.[_event_start])) AS _quarter_number,
			[dbo].[datetime_to_hour](MIN(AgentMetaData.[_event_start])) AS _hour,
			DATEPART(iso_week, MIN(AgentMetaData.[_event_start])) AS _week_number,
			MIN(AgentMetaData.[_global_call_id]) AS _global_call_id,
			MIN(AgentMetaData.[_sequence_number]) AS _sequence_number,
			MIN(AgentMetaData.[_event_start]) AS _event_start, 
			MAX(AgentMetaData.[_event_stop]) AS _event_stop, 
			AgentMetaData.[_agent_name] AS _agent_name,
			MIN(AgentMetaData.[_agent_skill]) AS _agent_skill,
			MIN(AgentMetaData.[_agent_client]) AS _agent_client,
			MIN(AgentMetaData.[_agent_company_name]) AS _agent_company_name,
			MIN(AgentMetaData.[_agent_department_name]) AS _agent_department_name,
			MIN(AgentMetaData.[_agent_address_name]) AS _agent_address_name,
			[_private_call_id] AS _private_call_id,
			MIN(AgentMetaData.[_queue_call_id]) AS _queue_call_id, 
			MIN(AgentMetaData.[_queue_name]) AS _queue_name,
			MIN(AgentMetaData.[_event_type]) AS _event_type,
			MIN(AgentMetaData.[_transfer_contact_endpoint]) AS _transfer_contact_endpoint,
			MIN(AgentMetaData.[_transfer_agent_id]) AS _trasfer_agent_id,
			MIN(AgentMetaData.[_transfer_agent_name]) AS _transfer_agent_name,
			MIN(AgentMetaData.[_call_qualification_id]) AS _call_qualification_id,
			MIN(AgentMetaData.[_call_qualification_name]) AS _call_qualification_name,
			MIN(AgentMetaData.[_role_id]) AS _role_id,
			MIN(AgentMetaData.[_role_name]) AS _role_name,
			MIN(AgentMetaData.[_tags]) AS _tags,
			MIN(AgentMetaData.[_pause_reason]) AS _pause_reason,
			MIN(AgentMetaData.[_param1]) AS _param1,
			MIN(AgentMetaData.[_param2]) AS _param2,
			MIN(AgentMetaData.[_param3]) AS _param3,
			MIN(AgentMetaData.[_param4]) AS _param4,
			               CASE
				               WHEN DATEDIFF(DAY, MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) < 23 OR DATEDIFF(YEAR, MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) < 1 
						       THEN DATEDIFF(MILLISECOND, MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop))
						   END AS ''sql_event_duration'',
						   NULL AS ''sql_officeteamcall_duration'',
						   NULL AS ''sql_callofferedacceptedcall_duration'',
						   NULL AS ''sql_paused_duration'',
						   NULL AS ''sql_ready_duration'',
						   NULL AS ''sql_aftercallworktime_duration'',
						   NULL AS ''sql_quarantined_duration'',						   
						   CASE
							   WHEN MIN(_event_type) = ''PrivateCallIn'' AND DATEDIFF(DAY,MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) < 23 AND DATEDIFF(YEAR,MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) < 1
							   THEN DATEDIFF(MILLISECOND, MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop))
						   END AS ''sql_privatecallin_duration'',
						   CASE
							   WHEN MIN(_event_type) = ''PrivateCallOut'' AND DATEDIFF(DAY,MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) < 23 AND DATEDIFF(YEAR,MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) < 1
							   THEN DATEDIFF(MILLISECOND,MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop))
						   END AS ''sql_privatecallout_duration'',
						   CASE
							   WHEN MIN(_event_type) = ''PrivateCallUnknown'' AND DATEDIFF(DAY,MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) < 23 AND DATEDIFF(YEAR,MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop)) < 1
							   THEN DATEDIFF(MILLISECOND,MIN(AgentMetaData._event_start), MAX(AgentMetaData._event_stop))
						   END AS ''sql_privatecallunknown_duration'',
						   NULL AS ''sql_callofferednotacceptedcall_duration'',
						   NULL AS ''sql_callofferedcallerhangup_duration'',
						   1 AS ''sql_call'',
						   NULL AS ''sql_office_team_call'',
						   NULL AS ''sql_offered_call'',
						   NULL AS ''sql_offered_accepted_call'',
						   CASE 
						   WHEN MIN(AgentMetaData._event_type) = ''PrivateCallOut'' 
						   THEN 1 
						   END AS ''sql_private_call_out'',
						   CASE 
						   WHEN MIN(AgentMetaData._event_type) = ''PrivateCallIn'' 
						   THEN 1 
						   END AS ''sql_private_call_in'',
						   CASE 
						   WHEN MIN(AgentMetaData._event_type) = ''PrivateCallUnknown'' 
						   THEN 1 
						   END AS ''sql_private_call_unknown'',
						   NULL AS ''sql_call_offered_not_accepted_call'',
						   NULL AS ''sql_call_offered_caller_hangup'',
						   NULL AS ''sql_call_offered_picked_by_other_agent'',
						   NULL AS ''sql_mot_transfer'',
						   NULL AS ''sql_mot_cob_transfer'',
						   NULL AS ''sql_picked_up_call'',
						   NULL AS ''sql_private_transfer'',
						   NULL AS ''sql_private_cob_transfer'',
						   NULL AS ''sql_park_private_transfer'',
						   NULL AS ''sql_park_mot_transfer'',
						   NULL AS ''sql_received_mot_transfer'',
						   NULL AS ''sql_call_qualification'',
						   NULL AS ''sql_call_offer_ended_by_service'',
						   NULL AS ''sql_logged_in'',
						   NULL AS ''sql_logged_out'',
						   NULL AS ''sql_dualline_transfer_request'',
						   NULL AS ''sql_pulled_call_from_agent'',
						   NULL AS ''sql_pulled_call_by_agent'',
						   NULL AS ''sql_received_mot_pulled'',
						   NULL AS ''sql_agent_paf_call'',
						   NULL AS ''sql_pause_reason_none_duration'',
						   NULL AS ''sql_pause_reason_mobilephonebusy_duration'',
						   NULL AS ''sql_pause_reason_notebusy_duration'',
						   NULL AS ''sql_pause_reason_calendarbusy_duration'',
						   NULL AS ''sql_pause_reason_donotdisturb_duration'',
						   NULL AS ''sql_pause_reason_callforwardingalways_duration'',
						   NULL AS ''sql_pause_reason_agent_duration'',
						   NULL AS ''sql_pause_reason_otheruser_duration'',
						   NULL AS ''sql_pause_reason_noaudiodevice_duration'',
						   NULL AS ''sql_pause_reason_machinebusy_duration'',
						   NULL AS ''sql_pause_reason_lyncbusy_duration'',
						   NULL AS ''sql_pause_reason_service_duration'',
						   NULL AS ''sql_pause_reason_notebusy_text'',
						   NULL AS ''sql_dualline_transfer_request_endpoint'',
						   NULL AS ''sql_received_mot_transfer_endpoint'',
						   CASE
							   WHEN MIN(AgentMetaData._event_type) = ''PrivateCallUnknown'' THEN
								   MIN(AgentMetaData._transfer_contact_endpoint)
						   END AS ''sql_private_call_unknown_endpoint'',
						   CASE
							   WHEN MIN(AgentMetaData._event_type) = ''PrivateCallIn'' THEN
								   MIN(AgentMetaData._transfer_contact_endpoint)
						   END AS ''sql_private_call_in_endpoint'',
						   CASE
							   WHEN MIN(AgentMetaData._event_type) = ''PrivateCallOut'' THEN
								   MIN(AgentMetaData._transfer_contact_endpoint)
						   END AS ''sql_private_call_out_endpoint'',
						   NULL AS ''sql_mot_cob_transfer_endpoint'',
						   NULL AS ''sql_private_cob_transfer_endpoint'',
						   NULL AS ''sql_park_private_transfer_endpoint'',
						   NULL AS ''sql_private_transfer_endpoint'',
						   NULL AS ''sql_mot_transfer_endpoint''
			FROM ',@Schema,'.office_team_statistics_agent_event AS AgentMetaData
			LEFT JOIN (SELECT SUM(DATEDIFF(millisecond,PrivateOnHold._event_start,PrivateOnHold._event_stop)) AS PDURSUM, PrivateOnHold.[_private_call_id] AS PID
			FROM ',@Schema,'.office_team_statistics_agent_event AS PrivateOnHold
			WHERE PrivateOnHold.[_event_type] IN (''PrivateCallInOnHold'', ''PrivateCallOutOnHold'', ''PrivateCallUnknownOnHold'')
			GROUP BY PrivateOnHold.[_private_call_id]) AS P ON (AgentMetaData._private_call_id = P.PID)
			WHERE AgentMetaData._private_call_id IS NOT NULL AND AgentMetaData._event_type LIKE ''Privatecall%''
			GROUP BY AgentMetaData._private_call_id, AgentMetaData._agent_id, AgentMetaData._agent_name')
		
		PRINT CAST(@SQLString AS NTEXT)
		
		EXECUTE sp_executesql @SQLString
		-- birst_queue_call_6_0_0

		-- birst_queue_call_5_4_6		
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.birst_queue_call_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[birst_queue_call_5_4_6]')
		
		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = ''

		SET @SQLString = @SQLString + N'CREATE VIEW [' + @Schema + N'].[birst_queue_call_5_4_6]
									AS
									SELECT DISTINCT
										   (SQC._queue_call_id) AS _queue_call_id,
										   SQC.id AS id,
										   SQC._stamp AS _stamp,
										   [dbo].[datetime_to_quater_hour](SQC.[_event_time]) AS [_quarter_number],
										   [dbo].[datetime_to_hour](SQC.[_event_time]) AS _hour,
										   DATEPART(iso_week, SQC.[_event_time]) AS _week_number,
										   SQC._global_call_id AS _global_call_id,
										   SQC._sequence_number AS _sequence_number,
										   SQC._event_time AS _event_time,
										   SQC._calling AS _calling,
										   SQC._called AS _called,
										   SQC._transferred AS _transferred,
										   SQC._queue_name AS _queue_name,
										   SQC._action AS _action,
										   SQC._agent_call_distribution AS _agent_call_distribution,
										   CASE
											   WHEN SQC._agent_name IS NULL
													OR SQC._action = ''Hangup''
													OR SQC._action = ''LostCall''
													OR SQC._action = ''TerminatedOnRequest''
													THEN ''No Agent''
											   ELSE
												   SQC._agent_name
										   END AS _agent_name,
										   SQC._agent_count AS _agent_count,
										   SQC._agent_skill AS _agent_skill,
										   SQC._agent_client AS _agent_client,
										   CASE
											   WHEN DATEDIFF(DAY, ''00:00:00'', SQC._agent_call_duration) > 23
													OR DATEDIFF(YEAR, ''00:00:00'', SQC._agent_call_duration) > 1 THEN
												   NULL
											   ELSE
												   DATEDIFF(MILLISECOND, ''00:00:00'', SQC._agent_call_duration)
										   END AS _agent_call_duration,
										   SQC._agent_company_name AS _agent_company_name,
										   SQC._agent_department_name AS _agent_department_name,
										   SQC._agent_address_name AS _agent_address_name,
										   CASE
											   WHEN DATEDIFF(DAY, ''00:00:00'', SQC._agent_offered_duration) > 23
													OR DATEDIFF(YEAR, ''00:00:00'', SQC._agent_offered_duration) > 1 THEN
												   NULL
											   ELSE
												   DATEDIFF(MILLISECOND, ''00:00:00'', SQC._agent_offered_duration)
										   END AS _agent_offered_duration,
										   SQC._agent_pickup AS _agent_pickup,
										   SQC._forward_to_same_agent AS _forward_to_same_agent,
										   SQC._overflow_type AS _overflow_type,
										   SQC._call_component_type AS _call_component_type,
										   SQC._call_component_name AS _call_component_name,
										   SQC._call_qualification_name AS _call_qualification_name,
										   SQC._callback AS _callback,
										   SQC._callback_attempts AS _callback_attempts,
										   SQC._callback_accepted AS _callback_accepted,
										   SQC._callback_calling AS _callback_calling,
										   SQC._service_level AS _service_level,
										   SQC._camp_on_busy AS _camp_on_busy,
										   SQC._left_queue AS _left_queue,
										   SQC._tags AS _tags,
										   SQC._unhandled_action AS _unhandled_action,
										   SQC._unhandled_handled_time AS _unhandled_handled_time,
										   SQC._paf_name AS _queue_paf_name,
										   CASE
											   WHEN CASE
														WHEN _action <> ''OverflowNewCall'' AND SQC._callback = 0 THEN
															DATEDIFF(DAY, _event_time, _left_queue)
													END > 23
													OR CASE
														   WHEN _action <> ''OverflowNewCall'' AND SQC._callback = 0 THEN
															   DATEDIFF(YEAR, _event_time, _left_queue)
													   END > 1 THEN
												   NULL
											   ELSE
												   CASE
													   WHEN _action <> ''OverflowNewCall'' AND SQC._callback = 0 THEN
														   DATEDIFF(MILLISECOND, _event_time, _left_queue)
												   END
										   END AS ''sql_queue_time'',
										   CASE
											   WHEN CASE
														WHEN _action <> ''OverflowNewCall'' AND SQC._callback = 1 THEN
															DATEDIFF(DAY, _event_time, SQC._real_left_queue)
													END > 23
													OR CASE
														   WHEN _action <> ''OverflowNewCall'' AND SQC._callback = 1 THEN
															   DATEDIFF(YEAR, _event_time, SQC._real_left_queue)
													   END > 1 THEN
												   NULL
											   ELSE
												   CASE
													   WHEN _action <> ''OverflowNewCall'' AND SQC._callback = 1 THEN
														   DATEDIFF(MILLISECOND, _event_time, SQC._real_left_queue)
												   END
										   END AS ''sql_queue_callback_time'',
										   CASE
											   WHEN DATEDIFF(   DAY,
													(
														SELECT MIN(_event_start)
														FROM [' + @Schema + N'].office_team_statistics_agent_event
														WHERE _queue_call_id = SAE._queue_call_id
															  AND _event_type = ''OfficeTeamCall''
														GROUP BY _queue_call_id
													),
													(
														SELECT MAX(_event_stop)
														FROM [' + @Schema + N'].office_team_statistics_agent_event
														WHERE _queue_call_id = SAE._queue_call_id
															  AND _event_type = ''OfficeTeamCall''
														GROUP BY _queue_call_id
													)
															) > 23
													OR DATEDIFF(   YEAR,
													   (
														   SELECT MIN(_event_start)
														   FROM [' + @Schema + N'].office_team_statistics_agent_event
														   WHERE _queue_call_id = SAE._queue_call_id
																 AND _event_type = ''OfficeTeamCall''
														   GROUP BY _queue_call_id
													   ),
													   (
														   SELECT MAX(_event_stop)
														   FROM [' + @Schema + N'].office_team_statistics_agent_event
														   WHERE _queue_call_id = SAE._queue_call_id
																 AND _event_type = ''OfficeTeamCall''
														   GROUP BY _queue_call_id
													   )
															   ) > 1 THEN
												   NULL
											   ELSE
												   DATEDIFF(   MILLISECOND,
												   (
													   SELECT MIN(_event_start)
													   FROM [' + @Schema + N'].office_team_statistics_agent_event
													   WHERE _queue_call_id = SAE._queue_call_id
															 AND _event_type = ''OfficeTeamCall''
													   GROUP BY _queue_call_id
												   ),
												   (
													   SELECT MAX(_event_stop)
													   FROM [' + @Schema + N'].office_team_statistics_agent_event
													   WHERE _queue_call_id = SAE._queue_call_id
															 AND _event_type = ''OfficeTeamCall''
													   GROUP BY _queue_call_id
												   )
														   )
										   END AS ''sql_office_team_call_duration'',
										   (CASE
												WHEN
												(
													SELECT TOP 1
														   _event_type
													FROM [' + @Schema + N'].office_team_statistics_agent_event
													WHERE (
															  _queue_call_id = SAE._queue_call_id
															  AND _event_type = ''MotTransfer''
														  )
												) IS NULL THEN
													0
												ELSE
													1
											END
										   ) + (CASE
													WHEN
													(
														SELECT TOP 1
															   _event_type
														FROM [' + @Schema + N'].office_team_statistics_agent_event
														WHERE (
																  _queue_call_id = SAE._queue_call_id
																  AND _event_type = ''MotCobTransfer''
															  )
													) IS NULL THEN
														0
													ELSE
														1
												END
											   ) AS ''sql_mot_tranfer'',
										   CASE
											   WHEN
											   (
												   SELECT COUNT(*)
												   FROM [' + @Schema + N'].office_team_statistics_agent_event
												   WHERE _queue_call_id = SAE._queue_call_id
														 AND _event_type = ''MotTransfer''
											   ) > 0 THEN
											   (
												   SELECT TOP 1
														  _transfer_agent_id
												   FROM [' + @Schema + N'].office_team_statistics_agent_event
												   WHERE _queue_call_id = SAE._queue_call_id
														 AND _event_type = ''MotTransfer''
											   )
											   WHEN
											   (
												   SELECT COUNT(*)
												   FROM [' + @Schema + N'].office_team_statistics_agent_event
												   WHERE _queue_call_id = SAE._queue_call_id
														 AND _event_type = ''MotCobTransfer''
											   ) > 0 THEN
											   (
												   SELECT TOP 1
														  _transfer_agent_id
												   FROM [' + @Schema + N'].office_team_statistics_agent_event
												   WHERE _queue_call_id = SAE._queue_call_id
														 AND _event_type = ''MotCobTransfer''
											   )
											   ELSE
												   NULL
										   END AS ''sql_transfer_agent_id'',
										   CASE
											   WHEN
											   (
												   SELECT COUNT(*)
												   FROM [' + @Schema + N'].office_team_statistics_agent_event
												   WHERE _queue_call_id = SAE._queue_call_id
														 AND _event_type = ''MotTransfer''
											   ) > 0 THEN
											   (
												   SELECT TOP 1
														  _transfer_agent_name
												   FROM [' + @Schema + N'].office_team_statistics_agent_event
												   WHERE _queue_call_id = SAE._queue_call_id
														 AND _event_type = ''MotTransfer''
											   )
											   WHEN
											   (
												   SELECT COUNT(*)
												   FROM [' + @Schema + N'].office_team_statistics_agent_event
												   WHERE _queue_call_id = SAE._queue_call_id
														 AND _event_type = ''MotCobTransfer''
											   ) > 0 THEN
											   (
												   SELECT TOP 1
														  _transfer_agent_name
												   FROM [' + @Schema + N'].office_team_statistics_agent_event
												   WHERE _queue_call_id = SAE._queue_call_id
														 AND _event_type = ''MotCobTransfer''
											   )
											   ELSE
												   NULL
										   END AS ''sql_transfer_agent_name'',
										   CASE
											   WHEN
											   (
												   SELECT COUNT(*)
												   FROM [' + @Schema + N'].office_team_statistics_agent_event
												   WHERE _queue_call_id = SAE._queue_call_id
														 AND _event_type = ''MotTransfer''
											   ) > 0 THEN
											   (
												   SELECT TOP 1
														  _transfer_contact_endpoint
												   FROM [' + @Schema + N'].office_team_statistics_agent_event
												   WHERE _queue_call_id = SAE._queue_call_id
														 AND _event_type = ''MotTransfer''
											   )
											   WHEN
											   (
												   SELECT COUNT(*)
												   FROM [' + @Schema + N'].office_team_statistics_agent_event
												   WHERE _queue_call_id = SAE._queue_call_id
														 AND _event_type = ''MotCobTransfer''
											   ) > 0 THEN
											   (
												   SELECT TOP 1
														  _transfer_contact_endpoint
												   FROM [' + @Schema + N'].office_team_statistics_agent_event
												   WHERE _queue_call_id = SAE._queue_call_id
														 AND _event_type = ''MotCobTransfer''
											   )
											   ELSE
												   NULL
										   END AS ''sql_transfer_contact_endpoint'',
										   CASE
											   WHEN SQC._action = ''Agent''
													OR SQC._action = ''PulledByAgent'' THEN
												   1
										   END AS ''sql_answered_call'',
										   CASE
											   WHEN SQC._action = ''PulledByAgent'' THEN
												   1
										   END AS ''sql_pulled_by_agent'',
										   CASE
											   WHEN SQC._action = ''Agent''
													AND SQC._callback = ''True'' THEN
												   1
										   END AS ''sql_succeded_callback'',
										   CASE
											   WHEN SQC._action = ''CallbackFailed'' THEN
												   1
										   END AS ''sql_failed_callback'',
										   CASE
											   WHEN SQC._action = ''CallbackNewQueue'' THEN
												   1
										   END AS ''sql_callback_new_queue'',
										   CASE
											   WHEN SQC._action = ''CallbackReplacedByNewCall'' THEN
												   1
										   END AS ''sql_callback_replaced'',
										   CASE
											   WHEN SQC._action = ''CallbackAgentLoggedOut'' THEN
												   1
										   END AS ''sql_callback_agent_logged_out'',
										   CASE
											   WHEN SQC._action = ''CallbackNoAgentFeedback'' THEN
												   1
										   END AS ''sql_callback_no_agent_feedback'',
										   CASE
											   WHEN SQC._action = ''Hangup''
													OR SQC._action = ''LostCall''
													OR SQC._action = ''TerminatedOnRequest''THEN
												   1
										   END AS ''sql_lost_call'',
										   CASE
											   WHEN SQC.[_overflow_type] <> ''None'' THEN
												   1
										   END AS ''sql_overflow_count'',
										   CASE
											   WHEN SQC._action = ''OverflowExistingCall'' THEN
												   1
										   END AS ''sql_overflow_existing'',
										   CASE
											   WHEN SQC._action = ''OverflowNewCall'' THEN
												   1
										   END AS ''sql_overflow_new'',
										   CASE
											   WHEN SQC._overflow_type = ''OneOrMoreCallsInQueue'' THEN
												   1
										   END AS ''sql_overflow_one_or_more_in_queue'',
										   CASE
											   WHEN SQC._overflow_type = ''LongestWaitingCall'' THEN
												   1
										   END AS ''sql_overflow_longest_waiting'',
										   CASE
											   WHEN SQC._overflow_type = ''NoAgentsAreAvailable'' THEN
												   1
										   END AS ''sql_overflow_no_agents_available'',
										   CASE
											   WHEN SQC._overflow_type = ''NoAgentsAreLoggedIn'' THEN
												   1
										   END AS ''sql_overflow_no_agents_logged_in'',
										   CASE
											   WHEN SQC._overflow_type = ''AllAgentsPaused'' THEN
												   1
										   END AS ''sql_overflow_all_agents_paused'',
										   CASE
											   WHEN SQC._overflow_type = ''CallWaitedMoreThan'' THEN
												   1
										   END AS ''sql_overflow_call_waited_more_than'',
										   CASE
											   WHEN SQC._overflow_type = ''CallerPressedDtmf'' THEN
												   1
										   END AS ''sql_overflow_caller_pressed_dtmf'',
										   CASE
											   WHEN SQC._overflow_type = ''NoAgentsAreLoggedInExistingCalls'' THEN
												   1
										   END AS ''sql_overflow_no_agents_are_logged_in_existing_calls'',
										   CASE
											   WHEN SQC._overflow_type = ''AllAgentsPausedExistingCalls'' THEN
												   1
										   END AS ''sql_overflow_all_agents_paused_existing_calls'',
										   CASE
											   WHEN SQC._callback = ''True'' THEN
												   1
										   END AS ''sql_callback'',
										   CASE
											   WHEN SQC._camp_on_busy <> ''None'' THEN
												   1
										   END AS ''sql_camp_on_busy_call'',
										   CASE
											   WHEN SQC.[_action] = ''ProcessProgress'' THEN
												   1
										   END AS ''sql_process_progress'',
										   CASE
											   WHEN SQC._service_level = ''No'' THEN
												   1
										   END AS ''sql_service_level_no'',
										   CASE
											   WHEN SQC._service_level = ''Yes'' THEN
												   1
										   END AS ''sql_service_level_yes'',
										   CASE
											   WHEN SQC._service_level = ''None'' THEN
												   1
										   END AS ''sql_service_level_none'',
										   CASE
											   WHEN SQC._camp_on_busy = ''SentToDestinationSuccess'' THEN
												   1
										   END AS ''sql_cob_sent_to_destination'',
										   CASE
											   WHEN SQC._camp_on_busy = ''CampOnBusyPutInReturnQueue'' THEN
												   1
										   END AS ''sql_cob_sent_to_queue_destination'',
										   CASE
											   WHEN SQC._camp_on_busy = ''Park'' THEN
												   1
										   END AS ''sql_park_call'',
										   CASE
											   WHEN SQC._camp_on_busy = ''SentToDestinationFailed''
													OR SQC._camp_on_busy = ''SentToDestinationTimeout''
													OR SQC._camp_on_busy = ''Attempting'' THEN
												   1
										   END AS ''sql_cob_failed'',
										   CASE
											   WHEN SQC._unhandled_action = ''HandledAsUnhandledCall'' THEN
												   1
										   END AS ''sql_unhandled_action_handled_as_unhandledcall'',
										   CASE
											   WHEN SQC._unhandled_action = ''UnhandledInvisible'' THEN
												   1
										   END AS ''sql_unhandled_action_handled_as_unhandledinvisible'',
										   CASE
											   WHEN SQC._unhandled_action = ''RemovedByNewCall'' THEN
												   1
										   END AS ''sql_unhandled_action_removed_by_new_call'',
										   CASE
											   WHEN CASE
														WHEN SQC._unhandled_action = ''HandledAsUnhandledCall'' THEN
															DATEDIFF(DAY, SQC._left_queue, SQC._unhandled_handled_time)
													END > 23
													OR CASE
														   WHEN SQC._unhandled_action = ''HandledAsUnhandledCall'' THEN
															   DATEDIFF(YEAR, SQC._left_queue, SQC._unhandled_handled_time)
													   END > 1 THEN
												   NULL
											   ELSE
												   CASE
													   WHEN SQC._unhandled_action = ''HandledAsUnhandledCall'' THEN
														   DATEDIFF(MILLISECOND, SQC._left_queue, SQC._unhandled_handled_time)
												   END
										   END AS ''sql_unhandled_action_handled_time'',
										   CASE
											   WHEN SQC._paf_id IS NOT NULL THEN
												   1
										   END AS sql_queue_paf_call
									FROM [' + @Schema + N'].[office_team_statistics_queue_call] AS SQC
										LEFT JOIN [' + @Schema + N'].[office_team_statistics_agent_event] AS SAE
											ON (SQC._queue_call_id = SAE._queue_call_id);'

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString
		-- birst_queue_call_5_4_6	

		-- datahotel_birst_user_call_log_5_4_6	
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.datahotel_birst_user_call_log_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[datahotel_birst_user_call_log_5_4_6]')
		
		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE VIEW ',@Schema,'.[datahotel_birst_user_call_log_5_4_6]
							AS
							SELECT [_user_call_log_id] AS id,
								  [_stamp] AS _stamp,
								  [_created] AS _created,
								  [dbo].[datetime_to_hour]([_call_started]) AS _quarter_number,
								  [dbo].datetime_to_hour([_call_started]) AS _hour,
								  DATEPART(iso_week, [_call_started]) AS _week_number,
								  [_application_context] AS _application_context,
								  [_user_account_id] AS _user_account_id,
								  [_user_account_name] AS sql_user_name,
								  [_event_action] AS _event_action,
								  [_call_started] AS _call_started,
								  [_call_answered] AS _call_anwered,
								  [_call_ended] AS _call_ended,
								  [_answering] AS _answering,
								  [_calling] AS _calling,
								  [_called] AS _called,
								  [_calldivertnew] AS _calldivertnew,
								  [_send_to] AS _send_to,
								  [_send_text] AS _send_text,
								  [_queue_call_id] AS _queue_call_id,
								  ''''  AS sql_queue_name,
								  [_user_company_name] AS sql_company_name,
								  [_user_department_name] AS sql_department_name,
								  [_user_address_name] AS sql_address_name,
								  [_user_account_office] AS _office,
								  [_user_account_area] AS _area,
								  [_user_account_location] AS _location,
								  [_user_account_user01] AS _user01,
								  [_user_account_user02] AS _user02,
								  [_user_account_user03] AS _user03,
										 CASE
									   WHEN _event_action IN ( ''CallingNotAnswered'', ''CallingBlindTransfer'', ''CallingSupervisedTransfer'',
																   ''CallingAnswered'', ''CallBlindTransfer'', ''CallSupervisedTransfer'',
																   ''CallNotAnswered'', ''CallAnswered''
																 ) THEN
										   1
								   END AS sql_call_count,
								   CASE
									   WHEN _event_action = ''CallingNotAnswered'' THEN
										   1
								   END AS sql_calling_not_answered,
								   CASE
									   WHEN _event_action = ''CallBlindTransfer'' THEN
										   1
								   END AS sql_call_blind_transfer,
								   CASE
									   WHEN _event_action = ''CallingBlindTransfer'' THEN
										   1
								   END AS sql_calling_blind_transfer,
								   CASE
									   WHEN _event_action = ''CallSupervisedTransfer'' THEN
										   1
								   END AS sql_call_supervised_transfer,
								   CASE
									   WHEN _event_action = ''SendSms'' THEN
										   1
								   END AS sql_send_sms,
								   CASE
									   WHEN _event_action = ''CallNotAnswered'' THEN
										   1
								   END AS sql_call_not_answered,
								   CASE
									   WHEN _event_action = ''CallingSupervisedTransfer'' THEN
										   1
								   END AS sql_calling_supervised_transfer,
								   CASE
									   WHEN _event_action = ''CallAnswered'' THEN
										   1
								   END AS sql_call_answered,
								   CASE
									   WHEN _event_action = ''CallingAnswered'' THEN
										   1
								   END AS sql_calling_answered,
								   CASE
									   WHEN _application_context LIKE ''%OO%'' THEN
										   1
								   END AS sql_app_context_oo,
								   CASE
									   WHEN _application_context LIKE ''%OT%'' THEN
										   1
								   END AS sql_app_context_ot,
								   CASE
									   WHEN _application_context LIKE ''%OC%'' THEN
										   1
								   END AS sql_app_context_oc,
								   CASE
									   WHEN _application_context NOT LIKE ''%OO%'' THEN
										   1
									   WHEN _application_context NOT LIKE ''%OT%'' THEN
										   1
									   WHEN _application_context NOT LIKE ''%OC%'' THEN
										   1
								   END AS sql_app_context_other,
								   '''' AS sql_user_tags,
								   CASE
									   WHEN _event_action IN ( ''CallingNotAnswered'', ''CallingBlindTransfer'', ''CallingSupervisedTransfer'',
															   ''CallingAnswered''
															 ) THEN
										   1
								   END AS sql_calling_type,
								   CASE
									   WHEN _event_action IN ( ''CallBlindTransfer'', ''CallSupervisedTransfer'', ''CallNotAnswered'', ''CallAnswered'' ) THEN
										   1
								   END AS sql_call_type,
								   CASE
									   WHEN _event_action IN ( ''CallingNotAnswered'', ''CallNotAnswered'' ) THEN
										   1
								   END AS sql_lost_call,
								   CASE
									   WHEN _event_action IN ( ''CallingNotAnswered'', ''CallNotAnswered'' )
											AND LEN(_called) < 8 THEN
										   1
								   END AS sql_lost_call_internal_pbx_only,
								   CASE
									   WHEN _event_action IN ( ''CallingNotAnswered'', ''CallNotAnswered'' )
											AND LEN(_called) > 7 THEN
										   1
								   END AS sql_lost_call_external_pbx_only,
								   CASE
									   WHEN _event_action IN ( ''CallingAnswered'', ''CallAnswered'' )
											AND LEN(_called) < 8 THEN
										   1
								   END AS sql_answered_call_internal_pbx_only,
								   CASE
									   WHEN _event_action IN ( ''CallingAnswered'', ''CallAnswered'' )
											AND LEN(_called) > 7 THEN
										   1
								   END AS sql_answered_call_external_pbx_only,
								   CASE
									   WHEN _event_action IN ( ''CallingAnswered'', ''CallAnswered'' ) THEN
										   1
								   END AS sql_answered,
								   CASE
									   WHEN _event_action IN ( ''CallingBlindTransfer'', ''CallingSupervisedTransfer'', ''CallingAnswered'',
															   ''CallAnswered'', ''CallBlindTransfer'', ''CallSupervisedTransfer''
															 ) THEN
										   1
								   END AS sql_answered_and_transfered_call,
								   CASE
									   WHEN _event_action IN ( ''CallingBlindTransfer'', ''CallingSupervisedTransfer'', ''CallBlindTransfer'',
															   ''CallSupervisedTransfer''
															 ) THEN
										   1
								   END AS sql_transfer_call_type,
								   CASE
									   WHEN _event_action = ''CallingNotAnswered''
											AND LEN(_called) < 8 THEN
										   1
								   END AS sql_calling_not_answered_internal_pbx_only,
								   CASE
									   WHEN _event_action = ''CallingNotAnswered''
											AND LEN(_called) > 7 THEN
										   1
								   END AS sql_calling_not_answered_external_pbx_only,
								   CASE
									   WHEN _event_action = ''CallNotAnswered''
											AND LEN(_called) < 8 THEN
										   1
								   END AS sql_call_not_answered_internal_pbx_only,
								   CASE
									   WHEN _event_action = ''CallNotAnswered''
											AND LEN(_called) > 7 THEN
										   1
								   END AS sql_call_not_answered_external_pbx_only,
								   CASE
									   WHEN _event_action = ''CallingAnswered''
											AND LEN(_called) < 8 THEN
										   1
								   END AS sql_calling_answered_internal_pbx_only,
								   CASE
									   WHEN _event_action = ''CallingAnswered''
											AND LEN(_called) > 7 THEN
										   1
								   END AS sql_calling_answered_external_pbx_only,
								   CASE
									   WHEN _event_action = ''CallAnswered''
											AND LEN(_called) < 8 THEN
										   1
								   END AS sql_call_answered_internal_pbx_only,
								   CASE
									   WHEN _event_action = ''CallAnswered''
											AND LEN(_called) > 7 THEN
										   1
								   END AS sql_call_answered_external_pbx_only,
								   CASE
									   WHEN _event_action IN ( ''CallingBlindTransfer'', ''CallingSupervisedTransfer'' )
											AND LEN(_called) < 8 THEN
										   1
								   END AS sql_calling_transfer_internal_pbx_only,
								   CASE
									   WHEN _event_action IN ( ''CallingBlindTransfer'', ''CallingSupervisedTransfer'' )
											AND LEN(_called) > 7 THEN
										   1
								   END AS sql_calling_transfer_external_pbx_only,
								   CASE
									   WHEN _event_action IN ( ''CallBlindTransfer'', ''CallSupervisedTransfer'' )
											AND LEN(_called) < 8 THEN
										   1
								   END AS sql_call_transfer_internal_pbx_only,
								   CASE
									   WHEN _event_action IN ( ''CallBlindTransfer'', ''CallSupervisedTransfer'' )
											AND LEN(_called) > 7 THEN
										   1
								   END AS sql_call_transfer_external_pbx_only,
	   	       CASE
           WHEN DATEDIFF(DAY, _call_started, _call_ended) > 23
                OR DATEDIFF(YEAR, _call_started, _call_ended) > 1
				OR _call_ended < _call_started THEN
               NULL
           ELSE
               DATEDIFF(MILLISECOND, _call_started, _call_ended)
       END AS ''sql_total_call_duration'',
	   	       CASE
           WHEN DATEDIFF(DAY, _call_started, _call_answered) > 23
                OR DATEDIFF(YEAR, _call_started, _call_answered) > 1
				OR _call_answered < _call_started  THEN
               NULL
           ELSE
               DATEDIFF(MILLISECOND, _call_started, _call_answered)
       END AS ''sql_responce_time'',
	          CASE
           WHEN CASE
                    WHEN _event_action IN ( ''CallNotAnswered'', ''CallingNotAnswered'' ) THEN
                        DATEDIFF(DAY, _call_started, _call_ended)
                END > 23
                OR CASE
                    WHEN _event_action IN ( ''CallNotAnswered'', ''CallingNotAnswered'' ) THEN
                        DATEDIFF(YEAR, _call_started, _call_ended)
                   END > 1
				OR _call_ended < _call_started  THEN
               NULL
           ELSE
               CASE
                    WHEN _event_action IN ( ''CallNotAnswered'', ''CallingNotAnswered'' ) THEN
                        DATEDIFF(MILLISECOND, _call_started, _call_ended)
               END
       END AS ''sql_ringing_duration_lost'',
	   	          CASE
           WHEN CASE
					WHEN _event_action IN ( ''CallNotAnswered'' ) THEN
                        DATEDIFF(DAY, _call_started, _call_ended)
                END > 23
                OR CASE
					WHEN _event_action IN ( ''CallNotAnswered'' ) THEN
                        DATEDIFF(YEAR, _call_started, _call_ended)
                   END > 1 
				OR _call_ended < _call_started  THEN
               NULL
           ELSE
               CASE
					WHEN _event_action IN ( ''CallNotAnswered'' ) THEN
                        DATEDIFF(MILLISECOND, _call_started, _call_ended)
               END
       END AS ''sql_call_type_ringing_duration_lost'',
	   	   	          CASE
           WHEN CASE
					WHEN _event_action IN ( ''CallingNotAnswered'' ) THEN
                        DATEDIFF(DAY, _call_started, _call_ended)
                END > 23
                OR CASE
					WHEN _event_action IN ( ''CallingNotAnswered'' ) THEN
                        DATEDIFF(YEAR, _call_started, _call_ended)
                   END > 1
				OR _call_ended < _call_started   THEN
               NULL
           ELSE
               CASE
					WHEN _event_action IN ( ''CallingNotAnswered'' ) THEN
                        DATEDIFF(MILLISECOND, _call_started, _call_ended)
               END
       END AS ''sql_calling_type_ringing_duration_lost'',
	   	   	          CASE
           WHEN CASE
					WHEN _event_action IN ( ''CallAnswered'', ''CallBlindTransfer'', ''CallSupervisedTransfer'' ) THEN
                        DATEDIFF(DAY, _call_started, _call_answered)
                END > 23
                OR CASE
					WHEN _event_action IN ( ''CallAnswered'', ''CallBlindTransfer'', ''CallSupervisedTransfer'' ) THEN
                        DATEDIFF(YEAR, _call_started, _call_answered)
                   END > 1 
				OR _call_answered < _call_started THEN
               NULL
           ELSE
               CASE
					WHEN _event_action IN ( ''CallAnswered'', ''CallBlindTransfer'', ''CallSupervisedTransfer'' ) THEN
                        DATEDIFF(MILLISECOND, _call_started, _call_answered)
               END
       END AS ''sql_call_type_responce_time'',
	   	   	          CASE
           WHEN CASE
					WHEN _event_action IN ( ''CallingAnswered'', ''CallingBlindTransfer'', ''CallingSupervisedTransfer'' )  THEN
                        DATEDIFF(DAY, _call_started, _call_answered)
                END > 23
                OR CASE
					WHEN _event_action IN ( ''CallingAnswered'', ''CallingBlindTransfer'', ''CallingSupervisedTransfer'' )  THEN
                        DATEDIFF(YEAR, _call_started, _call_answered)
                   END > 1
				OR _call_answered < _call_started  THEN
               NULL
           ELSE
               CASE
           WHEN _event_action IN ( ''CallingAnswered'', ''CallingBlindTransfer'', ''CallingSupervisedTransfer'' )  THEN                        
		   DATEDIFF(MILLISECOND, _call_started, _call_answered)
               END
       END AS ''sql_calling_type_responce_time'',
	   	   	          CASE
           WHEN CASE
					WHEN _event_action IN ( ''CallAnswered'', ''CallBlindTransfer'', ''CallSupervisedTransfer'' ) THEN
                        DATEDIFF(DAY, _call_started, _call_ended)
                END > 23
                OR CASE
					WHEN _event_action IN ( ''CallAnswered'', ''CallBlindTransfer'', ''CallSupervisedTransfer'' ) THEN
                        DATEDIFF(YEAR, _call_started, _call_ended)
                   END > 1
				OR _call_ended < _call_started THEN
               NULL
           ELSE
               CASE
					WHEN _event_action IN ( ''CallAnswered'', ''CallBlindTransfer'', ''CallSupervisedTransfer'' ) THEN                        
						DATEDIFF(MILLISECOND, _call_started, _call_ended)
               END
       END AS ''sql_call_type_call_duration'',
	   	       CASE
           WHEN DATEDIFF(DAY, _call_answered, _call_ended) > 23
                OR DATEDIFF(YEAR, _call_answered, _call_ended) > 1
				OR _call_ended < _call_answered  THEN
               NULL
           ELSE
               DATEDIFF(MILLISECOND, _call_started, _call_answered)
       END AS ''sql_call_duration'',
	   	   	          CASE
           WHEN CASE
					WHEN _event_action IN ( ''CallingAnswered'', ''CallingBlindTransfer'', ''CallingSupervisedTransfer'' ) THEN
                        DATEDIFF(DAY, _call_started, _call_ended)
                END > 23
                OR CASE
					WHEN _event_action IN ( ''CallingAnswered'', ''CallingBlindTransfer'', ''CallingSupervisedTransfer'' ) THEN
                        DATEDIFF(YEAR, _call_started, _call_ended)
                   END > 1
				OR _call_ended < _call_started THEN
               NULL
           ELSE
               CASE
					WHEN _event_action IN ( ''CallingAnswered'', ''CallingBlindTransfer'', ''CallingSupervisedTransfer'' ) THEN                        
						DATEDIFF(MILLISECOND, _call_started, _call_ended)
               END
       END AS ''sql_calling_type_call_duration''
							  FROM [MiralixStatistics].[',@Schema,'].[statistics_user_call_log]')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString
		-- datahotel_birst_user_call_log_5_4_6

		-- birst_agent_queue_5_4_6
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.birst_agent_queue_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[birst_agent_queue_5_4_6]')
		
		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE VIEW ',@Schema,'.[birst_agent_queue_5_4_6]
								AS
								SELECT [id] AS _agent_queue_id,
									   [_created] AS _created,
									   [dbo].[datetime_to_quater_hour]([_created]) AS _agent_queue_quarter_number, 
									   [dbo].[datetime_to_hour]([_created]) AS _agent_queue_hour,
									   DATEPART(iso_week, [_created]) AS _agent_queue_week_number,
									   [_queue_name] AS _agent_queue_queue_name,
									   [_queue_type] AS _agent_queue_queue_type,
									   ([_ready_state] + [_await_state] + [_idle_state]) AS sql_agent_queue_ready,
									   ([_alerting_state] +[_alerting_queue_call_state] + [_busy_in_state] + [_busy_out_state] + [_busy_unknown_state] + [_busy_queue_call_state]) AS sql_agent_queue_busy,
									   [_acwt_state] AS _agent_queue_acwt,
									   [_paused_state] AS _agent_queue_paused,
									   [_quarantined_state] AS _agent_queue_quarantined_state, 
									   ([_busy_in_state] + [_busy_out_state] + [_busy_unknown_state] + [_busy_queue_call_state]) AS sql_agent_queue_busy_with_call,
									   ([_alerting_state] + [_alerting_queue_call_state]) AS sql_agent_queue_busy_with_alerting,
									   [_busy_queue_call_state] AS _agent_queue_busy_queue_call_state,
									   ([_busy_in_state] + [_busy_out_state] + [_busy_unknown_state]) AS sql_agent_queue_busy_private_call_state,
									   [_busy_in_state] AS _agent_queue_busy_in_state,
									   [_busy_out_state] AS _agent_queue_busy_out_state,
									   [_busy_unknown_state] AS _agent_queue_busy_unknown_state,
									   [_alerting_state] AS _agent_queue_alerting_state,
									   [_alerting_queue_call_state] AS _agent_queue_alerting_queue_call_state,
									   [_normal_calls] AS _agent_queue_normal_calls,
									   [_callback_calls] AS _agent_queue_callback_calls

								FROM [MiralixStatistics].[',@Schema,'].[office_team_statistics_agent_queue]')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString
		-- birst_agent_queue_5_4_6
		
		-- birst_call_5_4_6
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.birst_call_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[birst_call_5_4_6]')
		
		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE VIEW ',@Schema,'.[birst_call_5_4_6]
									AS
									SELECT [id],
											[_call_id],
											[dbo].[datetime_to_quater_hour]([_call_start]) AS [_quarter_number],
											[dbo].[datetime_to_hour]([_call_start]) AS _hour,
											DATEPART(iso_week, [_call_start]) AS _week_number,
											[_sequence_number],
											[_global_call_id],
											[_call_start],
											[_call_ended],
											[_calling],
											[_called],
											[_transferred],
											[_type],
											[_agent_name]
									FROM [MiralixStatistics].[',@Schema,'].[office_team_statistics_call];')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString
		-- birst_call_5_4_6


		-- birst_conditional_switch_5_4_6
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.birst_conditional_switch_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[birst_conditional_switch_5_4_6]')
		
		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE VIEW ',@Schema,'.[birst_conditional_switch_5_4_6]
									AS
									SELECT [id] AS id,
										   [_created] AS _created,
										   [_call_id] AS _call_id,
										   [dbo].[datetime_to_quater_hour]([_event_time]) AS _quarter_number,
										   [dbo].[datetime_to_hour]([_event_time]) AS _hour,
										   DATEPART(iso_week, [_event_time]) AS _week_number,
										   [_global_call_id] AS _global_call_id,
										   [_sequence_number] AS _sequence_number,
										   [_event_time] AS _event_time,
										   [_conditional_switch_id] AS _conditional_switch_id,
										   [_conditional_switch_name] AS _conditional_switch_name,
										   [_ifthisthen_id] AS _ifthisthen_id,
										   [_ifthisthen_name] AS _ifthisthen_name,
										   [_call_component_type] AS _call_component_type,
										   [_call_component_id] AS _call_component_id,
										   [_call_component_name] AS _call_component_name,
										   [_default_call_component] AS _default_call_component
									FROM [MiralixStatistics].[',@Schema,'].[office_team_statistics_conditional_switch];')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString
		-- birst_conditional_switch_5_4_6



		-- birst_entry_menu_5_4_6
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.birst_entry_menu_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[birst_entry_menu_5_4_6]')
		
		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE VIEW ',@Schema,'.[birst_entry_menu_5_4_6]
									AS
									SELECT [id],
										   [_call_id],
										   [dbo].[datetime_to_quater_hour]([_event_time]) AS [_quarter_number],
										   [dbo].[datetime_to_hour]([_event_time]) AS _hour,
										   DATEPART(iso_week, [_event_time]) AS _week_number,
										   [_global_call_id],
										   [_sequence_number],
										   [_event_time],
										   [_entry_menu_name],
										   [_entry],
										   [_action],
										   [_call_component_type],
										   [_call_component_name],
										   [_process_name],
										   [_process_result],
										   [_left_entry_menu],
										   DATEDIFF(MILLISECOND, [_event_time], [_left_entry_menu]) AS _entry_menu_duration,
										   CASE
											   WHEN _action = ''Hangup'' THEN
												   1
										   END AS ''sql_hangup'',
										   CASE
											   WHEN _action = ''Primary'' THEN
												   1
										   END AS ''sql_primary'',
										   CASE
											   WHEN _action = ''ProcessProgress'' THEN
												   1
										   END AS ''sql_processprogress''
									FROM [MiralixStatistics].[',@Schema,'].[office_team_statistics_entry_menu];')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString
		-- birst_entry_menu_5_4_6
		

		-- birst_global_call_id_5_4_6
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.birst_global_call_id_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[birst_global_call_id_5_4_6]')
		
		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE VIEW ',@Schema,'.[birst_global_call_id_5_4_6]
									AS
									SELECT [id],
										   [_created],
										   [dbo].[datetime_to_quater_hour]([_first_call_arrived]) AS [_quarter_number],
										   [dbo].[datetime_to_hour]([_first_call_arrived]) AS _hour,
										   DATEPART(iso_week, [_first_call_arrived]) AS _week_number,
										   [_global_call_id],
										   [_first_call_arrived],
										   [_first_call_id]
									FROM [MiralixStatistics].[',@Schema,'].[office_team_statistics_global_call_id];')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString
		-- birst_global_call_id_5_4_6		


		-- birst_identification_5_4_6
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.birst_identification_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[birst_identification_5_4_6]')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE VIEW ',@Schema,'.[birst_identification_5_4_6]
										AS
										SELECT [id],
												[_call_id],
												[dbo].[datetime_to_quater_hour]([_event_time]) AS [_quarter_number],
												[dbo].[datetime_to_hour]([_event_time]) AS _hour,
												DATEPART(iso_week, [_event_time]) AS _week_number,
												[_sequence_number],
												[_global_call_id],
												[_event_time],
												[_calling],
												[_called],
												[_transferred],
												[_identifikation_name],
												[_type],
												[_combination_name],
												[_call_component_type],
												[_call_component_name],
												[_default_call_component],
												[_main_identification],
												[_agent_name]
										FROM [MiralixStatistics].[',@Schema,'].[office_team_statistics_identification];')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString
		-- birst_identification_5_4_6	


		-- birst_menu_5_4_6
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.birst_menu_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[birst_menu_5_4_6]')
		
		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = ''

		SET @SQLString = @SQLString + N'CREATE VIEW ['+ @Schema + N'].[birst_menu_5_4_6]
									AS
									SELECT [id],
										   [_call_id],
										   [dbo].[datetime_to_quater_hour]([_event_time]) AS [_quarter_number],
										   [dbo].[datetime_to_hour]([_event_time]) AS _hour,
										   DATEPART(iso_week, [_event_time]) AS _week_number,
										   [_global_call_id],
										   [_sequence_number],
										   [_event_time],
										   [_menu_name],
										   CASE
											   WHEN [_action] = ''On1'' THEN
												   ''Press 1''
											   WHEN [_action] = ''On2'' THEN
												   ''Press 2''
											   WHEN [_action] = ''On3'' THEN
												   ''Press 3''
											   WHEN [_action] = ''On4'' THEN
												   ''Press 4''
											   WHEN [_action] = ''On5'' THEN
												   ''Press 5''
											   WHEN [_action] = ''On6'' THEN
												   ''Press 6''
											   WHEN [_action] = ''On7'' THEN
												   ''Press 7''
											   WHEN [_action] = ''On8'' THEN
												   ''Press 8''
											   WHEN [_action] = ''On9'' THEN
												   ''Press 9''
											   WHEN [_action] = ''On0'' THEN
												   ''Press 0''
											   WHEN [_action] = ''On*''
													OR [_action] = ''OnStar'' THEN
												   ''Press *''
											   WHEN [_action] = ''On#''
													OR [_action] = ''OnSquare'' THEN
												   ''Press #''
											   WHEN [_action] = ''OnAuto'' THEN
												   ''Auto''
											   WHEN [_action] = ''CallerHangup'' THEN
												   ''Caller hangup''
											   WHEN [_action] = ''ServiceHangup'' THEN
												   ''Service hangup''
											   WHEN [_action] = ''ProcessProgress'' THEN
												   ''Process failed component''
										   END AS [_action],
										   CASE
											   WHEN [_action] = ''On1'' THEN
												   1
										   END AS sql_menu_press_1,
										   CASE
											   WHEN [_action] = ''On2'' THEN
												   1
										   END AS sql_menu_press_2,
										   CASE
											   WHEN [_action] = ''On3'' THEN
												   1
										   END AS sql_menu_press_3,
										   CASE
											   WHEN [_action] = ''On4'' THEN
												   1
										   END AS sql_menu_press_4,
										   CASE
											   WHEN [_action] = ''On5'' THEN
												   1
										   END AS sql_menu_press_5,
										   CASE
											   WHEN [_action] = ''On6'' THEN
												   1
										   END AS sql_menu_press_6,
										   CASE
											   WHEN [_action] = ''On7'' THEN
												   1
										   END AS sql_menu_press_7,
										   CASE
											   WHEN [_action] = ''On8'' THEN
												   1
										   END AS sql_menu_press_8,
										   CASE
											   WHEN [_action] = ''On9'' THEN
												   1
										   END AS sql_menu_press_9,
										   CASE
											   WHEN [_action] = ''On0'' THEN
												   1
										   END AS sql_menu_press_0,
										   CASE
											   WHEN [_action] = ''On*''
													OR [_action] = ''OnStar'' THEN
												   1
										   END AS sql_menu_press_Star,
										   CASE
											   WHEN [_action] = ''On#''
													OR [_action] = ''OnSquare'' THEN
												   1
										   END AS sql_menu_press_Square,
										   CASE
											   WHEN [_action] = ''OnAuto'' THEN
												   1
										   END AS sql_menu_press_Auto,
										   CASE
											   WHEN [_action] = ''CallerHangup'' THEN
												   1
										   END AS sql_menu_press_CallerHangup,
										   CASE
											   WHEN [_action] = ''ServiceHangup'' THEN
												   1
										   END AS sql_menu_press_ServiceHangup,
										   CASE
											   WHEN [_action] = ''ProcessProgress'' THEN
												   1
										   END AS sql_menu_press_ProcessProgress,
										   [_call_component_type],
										   [_call_component_name],
										   [_process_name],
										   [_left_menu],
										   DATEDIFF(MILLISECOND, [_event_time], [_left_menu]) AS _menu_duration,
										   CASE
											   WHEN _action = ''CallerHangup'' THEN
												   1
										   END AS ''sql_caller_hangup'',
										   CASE
											   WHEN _action = ''ServiceHangup'' THEN
												   1
										   END AS ''sql_service_hangup''
									FROM [MiralixStatistics].[' + @Schema + N'].[office_team_statistics_menu];'

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString
		-- birst_menu_5_4_6	


		-- birst_schedule_5_4_6
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.birst_schedule_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[birst_schedule_5_4_6]')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE VIEW ',@Schema,'.[birst_schedule_5_4_6]
									AS
									SELECT [id],
										   [_call_id],
										   [dbo].[datetime_to_quater_hour]([_event_time]) AS [_quarter_number],
										   [dbo].[datetime_to_hour]([_event_time]) AS _hour,
										   DATEPART(iso_week, [_event_time]) AS _week_number,
										   [_global_call_id],
										   [_sequence_number],
										   [_event_time],
										   [_schedule_type],
										   [_schedule_name],
										   [_timeframe_name],
										   [_call_component_type],
										   [_call_component_name],
										   [_default_call_component],
										   [_used_special_schedule],
										   CASE
											   WHEN [_schedule_type] = ''Normal'' THEN
												   1
										   END AS ''sql_schedule_type_normal'',
										   CASE
											   WHEN [_schedule_type] = ''Callback'' THEN
												   1
										   END AS ''sql_schedule_type_callback''
									FROM [MiralixStatistics].[',@Schema,'].[office_team_statistics_schedule];')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString
		-- birst_schedule_5_4_6


		-- birst_transfer_5_4_6
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.birst_transfer_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[birst_transfer_5_4_6]')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE VIEW ',@Schema,'.[birst_transfer_5_4_6]
									AS
									SELECT [id],
										   [_call_id],
										   [dbo].[datetime_to_quater_hour]([_event_time]) AS [_quarter_number],
										   [dbo].[datetime_to_hour]([_event_time]) AS _hour,
										   DATEPART(iso_week, [_event_time]) AS _week_number,
										   [_global_call_id],
										   [_sequence_number],
										   [_event_time],
										   [_transfer_name],
										   [_action],
										   [_transfer_type],
										   [_transfer_destination],
										   [_call_component_type],
										   [_call_component_name],
										   [_left_transfer],
										   DATEDIFF(MILLISECOND, [_event_time], [_left_transfer]) AS _transfer_duration,
										   CASE
											   WHEN _action = ''Success'' THEN
												   1
										   END AS ''sql_success'',
										   CASE
											   WHEN _action = ''Hangup'' THEN
												   1
										   END AS ''sql_hangup'',
										   CASE
											   WHEN _action = ''FailureCallComponent'' THEN
												   1
										   END AS ''sql_failure_call_component'',
										   CASE
											   WHEN _transfer_type = ''Supervised'' THEN
												   1
										   END AS ''sql_supervised'',
										   CASE
											   WHEN _transfer_type = ''Singlestep'' THEN
												   1
										   END AS ''sql_singlestep'',
										   CASE
											   WHEN _transfer_type = ''Dualline'' THEN
												   1
										   END AS ''sql_dualline''
								FROM [MiralixStatistics].[',@Schema,'].[office_team_statistics_transfer];')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString
		-- birst_transfer_5_4_6


		-- datahotel_birst_voicemail_5_4_6
		SET @SQLString = CONCAT('IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(''',@Schema,'.datahotel_birst_voicemail_5_4_6'') AND type = N''V'') DROP VIEW [',@Schema,'].[datahotel_birst_voicemail_5_4_6]')
		
		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE VIEW ',@Schema,'.[datahotel_birst_voicemail_5_4_6]
									AS
									SELECT [id] AS ''id'',
											[_created] AS ''_created'',
											[_stamp] AS ''_stamp'',
											[_call_id] AS ''_call_id'',
											[dbo].[datetime_to_quater_hour]([_event_time]) AS _quarter_number,
											[dbo].[datetime_to_hour]([_event_time]) AS _hour,
											DATEPART(iso_week, [_event_time]) AS _week_number,
											[_global_call_id] AS _global_call_id,
											[_sequence_number] AS _sequence_number,
											[_event_time] AS _event_time,
											[_voicemail_account_id] AS _voicemail_account_id,
											[_voicemail_account_name] AS _voicemail_account_name,
											[_group] AS _group,
											[_user_account_id] AS _user_account_id,
											[_user_account_name] AS _user_account_name,
											[_action] AS _action,
											[_dtmf_call_component_type] AS _dtmf_call_component_type,
											[_dtmf_call_component_id] AS _dtmf_call_component_id,
											[_dtmf_call_component_name] AS _dtmf_call_component_name,
											[_dtmf_mobile_phone] AS _dtmf_mobile_phone,
											CASE
												WHEN _action = ''CallerHangup'' THEN
													1
											END AS ''sql_vm_caller_hangup'',
											CASE
												WHEN _action = ''LeftMessage'' THEN
													1
											END AS ''sql_vm_left_message'',
											CASE
												WHEN _action = ''DtmfMobilePhone'' THEN
													1
											END AS ''sql_vm_dtmf_mobile_phone'',
											CASE
												WHEN _action = ''DtmfCallComponent'' THEN
													1
											END AS ''sql_vm_dtmf_call_component'',
											[_user_department_name] AS _department_name,
											[_user_company_name] AS _company_name,
											[_user_address_name] AS _address_name,
											[_heard_by_name] AS _heard_by_name
								FROM [MiralixStatistics].[',@Schema,'].[office_team_statistics_voicemail];')

		PRINT @SQLString
		
		EXECUTE sp_executesql @SQLString
		-- datahotel_birst_voicemail_5_4_6

		-- Missing indexes
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_agent_event'') AND NAME =''IX_auto_created'')

									DROP INDEX IX_auto_created ON ',@Schema,'.office_team_statistics_agent_event;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_created] ON ',@Schema,'.[office_team_statistics_agent_event]
		(
			[_created] ASC
		)
		INCLUDE ( 	[id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_agent_event'') AND NAME =''IX_auto_queue_call_id_event_type'')

									DROP INDEX IX_auto_queue_call_id_event_type ON ',@Schema,'.office_team_statistics_agent_event;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_queue_call_id_event_type] ON ',@Schema,'.[office_team_statistics_agent_event]
		(
			[_queue_call_id] ASC,
			[_event_type] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_agent_event'') AND NAME =''IX_office_team_statistics_agent_event__agent_id_CEEDD'')

									DROP INDEX IX_office_team_statistics_agent_event__agent_id_CEEDD ON ',@Schema,'.office_team_statistics_agent_event;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_agent_event__agent_id_CEEDD] ON ',@Schema,'.[office_team_statistics_agent_event]
		(
			[_agent_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_agent_event'') AND NAME =''IX_office_team_statistics_agent_event__transfer_agent_id_40F2C'')

									DROP INDEX IX_office_team_statistics_agent_event__transfer_agent_id_40F2C ON ',@Schema,'.office_team_statistics_agent_event;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_agent_event__transfer_agent_id_40F2C] ON ',@Schema,'.[office_team_statistics_agent_event]
		(
			[_transfer_agent_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_agent_event'') AND NAME =''IX_office_team_statistics_agent_event__transfer_agent_id_A6FB3'')

									DROP INDEX IX_office_team_statistics_agent_event__transfer_agent_id_A6FB3 ON ',@Schema,'.office_team_statistics_agent_event;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_agent_event__transfer_agent_id_A6FB3] ON ',@Schema,'.[office_team_statistics_agent_event]
		(
			[_transfer_agent_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_agent_event'') AND NAME =''missing_index_17'')

									DROP INDEX missing_index_17 ON ',@Schema,'.office_team_statistics_agent_event;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [missing_index_17] ON ',@Schema,'.[office_team_statistics_agent_event]
		(
			[_event_type] ASC,
			[_event_start] ASC
		)
		INCLUDE ( 	[_agent_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_agent_event'') AND NAME =''missing_index_19'')

									DROP INDEX missing_index_19 ON ',@Schema,'.office_team_statistics_agent_event;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [missing_index_19] ON ',@Schema,'.[office_team_statistics_agent_event]
		(
			[_event_type] ASC
		)
		INCLUDE ( 	[_event_start],
			[_agent_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_agent_event'') AND NAME =''missing_index_4720'')

									DROP INDEX missing_index_4720 ON ',@Schema,'.office_team_statistics_agent_event;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [missing_index_4720] ON ',@Schema,'.[office_team_statistics_agent_event]
		(
			[_event_type] ASC
		)
		INCLUDE ( 	[_event_stop],
			[_queue_call_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')
				
		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_agent_event'') AND NAME =''missing_index_4722'')

									DROP INDEX missing_index_4722 ON ',@Schema,'.office_team_statistics_agent_event;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [missing_index_4722] ON ',@Schema,'.[office_team_statistics_agent_event]
		(
			[_event_type] ASC
		)
		INCLUDE ( 	[_event_start],
			[_queue_call_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_agent_event'') AND NAME =''NonClusteredIndex-20140414-213610'')

									DROP INDEX [NonClusteredIndex-20140414-213610] ON ',@Schema,'.office_team_statistics_agent_event;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [NonClusteredIndex-20140414-213610] ON ',@Schema,'.[office_team_statistics_agent_event]
		(
			[_event_type] ASC,
			[_event_start] ASC,
			[_event_stop] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_agent_queue'') AND NAME =''IX_office_team_statistics_agent_queue__created_33B93'')

									DROP INDEX IX_office_team_statistics_agent_queue__created_33B93 ON ',@Schema,'.office_team_statistics_agent_queue;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_agent_queue__created_33B93] ON ',@Schema,'.[office_team_statistics_agent_queue]
		(
			[_created] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_call'') AND NAME =''IX_auto_created'')

									DROP INDEX IX_auto_created ON ',@Schema,'.office_team_statistics_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString

		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_created] ON ',@Schema,'.[office_team_statistics_call]
		(
			[_created] ASC
		)
		INCLUDE ( 	[id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')
		
		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_call'') AND NAME =''IX_office_team_statistics_call__agent_id_3076A'')

									DROP INDEX IX_office_team_statistics_call__agent_id_3076A ON ',@Schema,'.office_team_statistics_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_call__agent_id_3076A] ON ',@Schema,'.[office_team_statistics_call]
		(
			[_agent_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_call'') AND NAME =''IX_office_team_statistics_call__paf_id_F15B6'')

									DROP INDEX IX_office_team_statistics_call__paf_id_F15B6 ON ',@Schema,'.office_team_statistics_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_call__paf_id_F15B6] ON ',@Schema,'.[office_team_statistics_call]
		(
			[_paf_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_global_call_id'') AND NAME =''IX_auto_created'')

									DROP INDEX IX_auto_created ON ',@Schema,'.office_team_statistics_global_call_id;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_created] ON ',@Schema,'.[office_team_statistics_global_call_id]
		(
			[_created] ASC
		)
		INCLUDE ( 	[id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_global_call_id'') AND NAME =''IX_office_team_statistics_global_call_id__paf_id_97C23'')

									DROP INDEX IX_office_team_statistics_global_call_id__paf_id_97C23 ON ',@Schema,'.office_team_statistics_global_call_id;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_global_call_id__paf_id_97C23] ON ',@Schema,'.[office_team_statistics_global_call_id]
		(
			[_paf_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')
		
		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_identification'') AND NAME =''IX_auto_created'')

									DROP INDEX IX_auto_created ON ',@Schema,'.office_team_statistics_identification;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_created] ON ',@Schema,'.[office_team_statistics_identification]
		(
			[_created] ASC
		)
		INCLUDE ( 	[id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')
		
		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_identification'') AND NAME =''IX_office_team_statistics_identification__agent_id_68839'')

									DROP INDEX IX_office_team_statistics_identification__agent_id_68839 ON ',@Schema,'.office_team_statistics_identification;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_identification__agent_id_68839] ON ',@Schema,'.[office_team_statistics_identification]
		(
			[_agent_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_identification'') AND NAME =''IX_office_team_statistics_identification__paf_id_70B13'')

									DROP INDEX IX_office_team_statistics_identification__paf_id_70B13 ON ',@Schema,'.office_team_statistics_identification;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_identification__paf_id_70B13] ON ',@Schema,'.[office_team_statistics_identification]
		(
			[_paf_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_incomplete_queue_call'') AND NAME =''IX_auto_created'')

									DROP INDEX IX_auto_created ON ',@Schema,'.office_team_statistics_incomplete_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_created] ON ',@Schema,'.[office_team_statistics_incomplete_queue_call]
		(
			[_created] ASC
		)
		INCLUDE ( 	[id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')
		
		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_incomplete_queue_call'') AND NAME =''IX_office_team_statistics_incomplete_queue_call__agent_id_0AD44'')

									DROP INDEX IX_office_team_statistics_incomplete_queue_call__agent_id_0AD44 ON ',@Schema,'.office_team_statistics_incomplete_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_incomplete_queue_call__agent_id_0AD44] ON ',@Schema,'.[office_team_statistics_incomplete_queue_call]
		(
			[_agent_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')
		
		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_incomplete_queue_call'') AND NAME =''IX_office_team_statistics_incomplete_queue_call__paf_id_4F3F3'')

									DROP INDEX IX_office_team_statistics_incomplete_queue_call__paf_id_4F3F3 ON ',@Schema,'.office_team_statistics_incomplete_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_incomplete_queue_call__paf_id_4F3F3] ON ',@Schema,'.[office_team_statistics_incomplete_queue_call]
		(
			[_paf_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
		
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_menu'') AND NAME =''IX_auto_created'')

									DROP INDEX IX_auto_created ON ',@Schema,'.office_team_statistics_menu;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_created] ON ',@Schema,'.[office_team_statistics_menu]
		(
			[_created] ASC
		)
		INCLUDE ( 	[id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_menu'') AND NAME =''IX_office_team_statistics_menu__paf_id_94D34'')

									DROP INDEX IX_office_team_statistics_menu__paf_id_94D34 ON ',@Schema,'.office_team_statistics_menu;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_menu__paf_id_94D34] ON ',@Schema,'.[office_team_statistics_menu]
		(
			[_paf_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''IX_auto_action_left_queue'')

									DROP INDEX IX_auto_action_left_queue ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_action_left_queue] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_action] ASC,
			[_left_queue] ASC
		)
		INCLUDE ( 	[_queue_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''IX_auto_callback_action_left'')

									DROP INDEX IX_auto_callback_action_left ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_callback_action_left] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_callback] ASC,
			[_action] ASC,
			[_left_queue] ASC
		)
		INCLUDE ( 	[_event_time],
			[_queue_id],
			[_agent_call_duration]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''IX_auto_callback_service_action'')

									DROP INDEX IX_auto_callback_service_action ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_callback_service_action] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_callback] ASC,
			[_service_level] ASC,
			[_action] ASC,
			[_left_queue] ASC
		)
		INCLUDE ( 	[_queue_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''IX_auto_created'')

									DROP INDEX IX_auto_created ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_created] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_created] ASC
		)
		INCLUDE ( 	[id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''IX_auto_event_time_queue_name'')

									DROP INDEX IX_auto_event_time_queue_name ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_event_time_queue_name] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_event_time] ASC,
			[_calling] ASC,
			[_queue_name] ASC,
			[_agent_call_duration] ASC,
			[_left_queue] ASC
		)
		INCLUDE ( 	[_global_call_id],
			[_queue_call_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''IX_office_team_statistics_queue_call__agent_id_F8C47'')

									DROP INDEX IX_office_team_statistics_queue_call__agent_id_F8C47 ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_queue_call__agent_id_F8C47] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_agent_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''IX_office_team_statistics_queue_call__paf_id_46B8E'')

									DROP INDEX IX_office_team_statistics_queue_call__paf_id_46B8E ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_queue_call__paf_id_46B8E] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_paf_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')


		EXECUTE sp_executesql @SQLString 
		
				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''IX_office_team_statistics_queue_call__pulling_agent_id_73BA3'')

									DROP INDEX IX_office_team_statistics_queue_call__pulling_agent_id_73BA3 ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_queue_call__pulling_agent_id_73BA3] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_pulling_agent_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''IX_office_team_statistics_queue_call__queue_call_id_8B413'')

									DROP INDEX IX_office_team_statistics_queue_call__queue_call_id_8B413 ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_queue_call__queue_call_id_8B413] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_queue_call_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		
				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''missing_index_1'')

									DROP INDEX missing_index_1 ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [missing_index_1] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_action] ASC,
			[_left_queue] ASC
		)
		INCLUDE ( 	[_queue_id],
			[_personal_agent_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''missing_index_11'')

									DROP INDEX missing_index_11 ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [missing_index_11] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_callback] ASC,
			[_action] ASC,
			[_left_queue] ASC
		)
		INCLUDE ( 	[_event_time],
			[_queue_id],
			[_personal_agent_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''missing_index_13'')

									DROP INDEX missing_index_13 ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [missing_index_13] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_callback] ASC,
			[_action] ASC
		)
		INCLUDE ( 	[_event_time],
			[_queue_id],
			[_left_queue],
			[_personal_agent_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''missing_index_2230'')

									DROP INDEX missing_index_2230 ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [missing_index_2230] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_action] ASC,
			[_left_queue] ASC
		)
		INCLUDE ( 	[_queue_id],
			[_personal_agent_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''missing_index_3'')

									DROP INDEX missing_index_3 ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [missing_index_3] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_action] ASC
		)
		INCLUDE ( 	[_queue_id],
			[_left_queue],
			[_personal_agent_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''missing_index_5'')

									DROP INDEX missing_index_5 ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [missing_index_5] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_action] ASC
		)
		INCLUDE ( 	[_queue_id],
			[_left_queue],
			[_personal_agent_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''missing_index_7'')

									DROP INDEX missing_index_7 ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [missing_index_7] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_callback] ASC,
			[_action] ASC,
			[_left_queue] ASC
		)
		INCLUDE ( 	[_queue_id],
			[_agent_call_duration],
			[_personal_agent_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_queue_call'') AND NAME =''missing_index_9'')

									DROP INDEX missing_index_9 ON ',@Schema,'.office_team_statistics_queue_call;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [missing_index_9] ON ',@Schema,'.[office_team_statistics_queue_call]
		(
			[_callback] ASC,
			[_action] ASC
		)
		INCLUDE ( 	[_queue_id],
			[_agent_call_duration],
			[_left_queue],
			[_personal_agent_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_schedule'') AND NAME =''IX_auto_created'')

									DROP INDEX IX_auto_created ON ',@Schema,'.office_team_statistics_schedule;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_created] ON ',@Schema,'.[office_team_statistics_schedule]
		(
			[_created] ASC
		)
		INCLUDE ( 	[id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_schedule'') AND NAME =''IX_office_team_statistics_schedule__paf_id_14AB3'')

									DROP INDEX IX_office_team_statistics_schedule__paf_id_14AB3 ON ',@Schema,'.office_team_statistics_schedule;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_schedule__paf_id_14AB3] ON ',@Schema,'.[office_team_statistics_schedule]
		(
			[_paf_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_transfer'') AND NAME =''IX_auto_created'')

									DROP INDEX IX_auto_created ON ',@Schema,'.office_team_statistics_transfer;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_auto_created] ON ',@Schema,'.[office_team_statistics_transfer]
		(
			[_created] ASC
		)
		INCLUDE ( 	[id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 

				
		SET @SQLString = CONCAT('IF EXISTS(SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID(''',@Schema,'.office_team_statistics_transfer'') AND NAME =''IX_office_team_statistics_transfer__paf_id_A951A'')

									DROP INDEX IX_office_team_statistics_transfer__paf_id_A951A ON ',@Schema,'.office_team_statistics_transfer;')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString


		SET @SQLString = CONCAT('CREATE NONCLUSTERED INDEX [IX_office_team_statistics_transfer__paf_id_A951A] ON ',@Schema,'.[office_team_statistics_transfer]
		(
			[_paf_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)')

		PRINT @SQLString

		EXECUTE sp_executesql @SQLString 
		

		-- Missing indexes
END
GO

