



CREATE PROCEDURE [V20232].[fact_queue_name]
	-- Add the parameters for the stored procedure here
	@Dongle int, @mth int	
AS
BEGIN

;with stamp as (
   select concat('_',@dongle) as dongle_id, datefromparts(left(@mth,4),right(@mth,2),1) as stamp,  eomonth(datefromparts(left(@mth,4),right(@mth,2),1)) as LoadDataTo		 
), agentevent as (
    select row_number() over (partition by [_queue_call_id] , [_dongle_id] order by [id] asc) as #row,
		[_queue_call_id],
        [_dongle_id],
        [_event_type],
		[_transfer_agent_id],
		[_transfer_agent_name],
		[_transfer_contact_endpoint],
		[_transfer_source_id],
		[_transfer_type],
		[_transfer_name],
		[_transfer_department],
		[_transfer_company],
		[_transfer_address],
		[_param1],
		[_param2],
		[_call_id]
	from [load].office_team_statistics_agent_event ae with (nolock)
	join stamp on stamp.dongle_id = ae._dongle_id 
	where [_event_type] IN ('MotTransfer','MotCobTransfer') 
	and ae._created >= stamp.stamp and ae._created <= stamp.LoadDataTo
), agenttime as (
    select
    	min([_event_start]) as min_event_start, 
		max([_event_stop]) as max_event_stop,
		[_queue_call_id],
        [_dongle_id]
	from [load].office_team_statistics_agent_event ae with (nolock)
	join stamp on stamp.dongle_id = ae._dongle_id 
	where [_event_type] = 'OfficeTeamCall'
	and ae._created >= stamp.stamp and ae._created <= stamp.LoadDataTo
	group by _queue_call_id , _dongle_id
)

, result as (

select

cast(substring(qc._dongle_id,2,10) as INT) as _dongle_id,
id,
case when qc._stamp = qc._created then 1 else 0 end as orig,
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',qc.[_queue_id],'_',qc.[_queue_name],'_',qc.[_tags])),2) as [_queue_call_queue_name_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_','called','_',ltrim(rtrim(qc._called_type)),'_',ltrim(rtrim(qc._called)),'_',ltrim(rtrim(qc._called_name)),'_',ltrim(rtrim(qc._called_address)),'_',ltrim(rtrim(qc._called_department)),'_',ltrim(rtrim(qc._called_company)))),2) as [_endpoint_contact_called_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_','calling','_',ltrim(rtrim(qc._calling_type)),'_',ltrim(rtrim(qc._calling)),'_',ltrim(rtrim(qc._calling_name)),'_',ltrim(rtrim(qc._calling_address)),'_',ltrim(rtrim(qc._calling_department)),'_',ltrim(rtrim(qc._calling_company)))),2) as [_endpoint_contact_calling_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_','transferred','_',ltrim(rtrim(qc._transferred_type)),'_',ltrim(rtrim(qc._transferred)),'_',ltrim(rtrim(qc._transferred_name)),'_',ltrim(rtrim(qc._transferred_address)),'_',ltrim(rtrim(qc._transferred_department)),'_',ltrim(rtrim(qc._transferred_company)))),2) as [_endpoint_contact_transferred_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_','transfer','_',ae._transfer_type,'_',ae._transfer_contact_endpoint,'_',ltrim(rtrim(ae._transfer_name)),'_',ltrim(rtrim(ae._transfer_address)),'_',ltrim(rtrim(ae._transfer_department)),'_',ltrim(rtrim(ae._transfer_company)))),2) as [_endpoint_contact_transfer_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',qc.[_agent_address_name],'_',qc.[_agent_company_name],'_',qc.[_agent_department_name],'_',qc.[_agent_name])),2) as [_queue_call_agent_org_unique_id],
--convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',qc.[_agent_id])),2) as [_queue_call_agent_org_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',qc.[_agent_skill],'_',ltrim(rtrim(qc.[_agent_client])),'_',ltrim(rtrim(qc.[_action])),'_',CASE WHEN qc._action = 'Hangup' OR qc._action = 'LostCall' OR qc._action = 'TerminatedOnRequest' THEN 'Lost' WHEN qc.[_overflow_type] <> 'None' THEN 'Overflow' WHEN ae._queue_call_id is not null THEN 'Transfers' WHEN qc._action = 'Agent' THEN 'Agent' END,'_',ltrim(rtrim(qc.[_overflow_type])))),2) as  [_queue_call_junk_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',qc._call_component_id,'_',ltrim(rtrim(qc._call_component_name)),'_',ltrim(rtrim(qc._call_component_type)))),2) as [_call_component_unique_id],

cast(format(qc._event_time,'yyyyMMdd') as int) as _date_id,
cast(format(qc._event_time,'HHmmss') as int) as _time_id,

qc._queue_id as [_queue_call_table_id],
qc._queue_call_id as [_queue_call_id],
convert(int,qc.[_callback]) as [_callback],
case when qc._action = 'CallbackAgentLoggedOut' then 1 end as [_callback_agent_logged_out],
case when qc._action = 'CallbackNewQueue' then 1 end as [_callback_agent_new_queue],
case when qc._action = 'CallbackNoAgentFeedback' then 1 end as [_callback_agent_no_agent_feedback],
case when qc._action = 'CallbackReplacedByNewCall' then 1 end as [_callback_replaced_by_new_call],
case when qc._action in ('CallbackFailed','TerminatedOnRequest','LostCall') and qc._callback = 1 then 1 end as [_callback_failed],
case when qc._callback_accepted is not null then 1 else 0 end as [_callback_successful], /* Koorekt ?? */

case when qc._callback is null then 1 else 0 end as [_callback_none],

case when qc.[_action] <> 'OverflowNewCall' and qc.[_callback] = 1 then DATEDIFF(SECOND, qc.[_event_time], qc.[_real_left_queue]) end as [_callback_time],
qc._callback_attempts AS [_callback_attempts],

datediff(SECOND,[at].[min_event_start],[at].[max_event_stop]) as [_first_call_duration],
case when ae.[_param2] = 'Consultation' then ae.[_param1] / 1000 end as [_consultation_transfer_duration],
case when qc.[_unhandled_action] = 'HandledAsUnhandledCall' then datediff(SECOND, qc.[_left_queue], qc.[_unhandled_handled_time]) end as [_unhandled_action_handled_time],
case when qc._action <> 'OverflowNewCall' and qc._callback = 1 then datediff(SECOND, qc._event_time, qc._callback_accepted) end as [_callback_choice_time],
case when qc.[_action] <> 'OverflowNewCall' and qc.[_callback] = 0 then datediff(SECOND, qc.[_event_time], qc.[_left_queue]) end as [_waiting_time],
case when ae.[_queue_call_id] is null then 0 else 1 end as [_transfer],

case when qc._overflow_type = 'AllAgentsPaused' then 1 else 0 end as [_overflow_all_agent_paused],
case when qc._overflow_type = 'CallWaitedMoreThan' then 1 else 0 end as [_overflow_call_waiting_more_than],
case when qc._overflow_type = 'CallerPressedDtmf' then 1 else 0 end as [_overflow_caller_pressed_dtmf],
case when qc._overflow_type = 'LongestWaitingCall' then 1 else 0 end as [_overflow_longest_waiting_call],
case when qc._overflow_type = 'NoAgentsAreAvailable' then 1 else 0 end as [_overflow_no_agents_are_avaliable],
case when qc._overflow_type = 'NoAgentsAreLoggedIn' then 1 else 0 end as [_overflow_no_agents_are_logged_in],
case when qc._overflow_type = 'OneOrMoreCallsInQueue' then 1 else 0 end as [_overflow_one_or_more_calls_in_queue],

case when qc._call_qualification_id is not null then 1 else 0 end as [_call_qualification],
case when qc._call_qualification_id is null and qc._action in ('Agent','PulledByAgent') then 1 when qc._call_qualification_name = '' and qc._action in ('Agent','PulledByAgent') then 1 else 0 end as [_call_no_qualification],

case when qc._action in ('Agent','PulledByAgent') then 1 else 0 end as [_call_answered],
case when qc._action = 'PulledByAgent' then 1 else 0 end as [_call_pulled_by_agent],
case when qc._action in ('LostCall','Hangup','TerminatedOnRequest') then 1 else 0 end as [_call_lost],

CASE WHEN (qc._action = 'Hangup' OR qc._action = 'LostCall' OR qc._action = 'TerminatedOnRequest') AND qc._callback = 0 AND DATEDIFF(SECOND, _event_time, _left_queue) < 5 THEN 1 END AS [_call_lost_before_5_sek],
CASE WHEN (qc._action = 'Hangup' OR qc._action = 'LostCall' OR qc._action = 'TerminatedOnRequest') AND qc._callback = 0 AND DATEDIFF(SECOND, _event_time, _left_queue) BETWEEN 5 AND 10 THEN 1 END AS [_call_lost_after_5_sek_before_10_sek],
CASE WHEN (qc._action = 'Hangup' OR qc._action = 'LostCall' OR qc._action = 'TerminatedOnRequest') AND qc._callback = 0 AND DATEDIFF(SECOND, _event_time, _left_queue) BETWEEN 11 AND 15 THEN 1 END AS [_call_lost_after_10_sek_before_15_sek],
CASE WHEN (qc._action = 'Hangup' OR qc._action = 'LostCall' OR qc._action = 'TerminatedOnRequest') AND qc._callback = 0 AND DATEDIFF(SECOND, _event_time, _left_queue) BETWEEN 16 AND 30 THEN 1 END AS [_call_lost_after_15_sek_before_30_sek],
CASE WHEN (qc._action = 'Hangup' OR qc._action = 'LostCall' OR qc._action = 'TerminatedOnRequest') AND qc._callback = 0 AND DATEDIFF(SECOND, _event_time, _left_queue) BETWEEN 31 AND 60 THEN 1 END AS [_call_lost_after_30_sek_before_60_sek],
CASE WHEN (qc._action = 'Hangup' OR qc._action = 'LostCall' OR qc._action = 'TerminatedOnRequest') AND qc._callback = 0 AND DATEDIFF(SECOND, _event_time, _left_queue) BETWEEN 61 AND 120 THEN 1 END AS [_call_lost_after_60_sek_before_120_sek],
CASE WHEN (qc._action = 'Hangup' OR qc._action = 'LostCall' OR qc._action = 'TerminatedOnRequest') AND qc._callback = 0 AND DATEDIFF(SECOND, _event_time, _left_queue) BETWEEN 121 AND 300 THEN 1 END AS [_call_lost_after_120_sek_before_300_sek],	   
CASE WHEN (qc._action = 'Hangup' OR qc._action = 'LostCall' OR qc._action = 'TerminatedOnRequest') AND qc._callback = 0 AND DATEDIFF(SECOND, _event_time, _left_queue) > 300 THEN 1 END AS [_call_lost_after_300_sek],	   

case when qc._overflow_type <> 'None' then 1 else 0 end as [_overflow],

case when qc._action = 'OverflowNewCall' then 1 else 0 end as [_overflow_new],
case when qc._action = 'OverflowExistingCall' then 1 else 0 end as [_overflow_existing],

case when qc._service_level = 'Yes' then 1 else 0 end as  [_call_service_level_yes],
case when qc._service_level = 'No' then 1 else 0 end as  [_call_service_level_no],
case when qc._service_level = 'None' then 1 else 0 end as  [_call_service_level_none],

ae._transfer_type as test,
case when ae._transfer_type is not null then 1 else 0 end as [_transfer_call],
case when ae._param2 = 'Consultation' then 1 else 0 end as [_transfer_consultation_call],
case when ae._param2 = 'Direct' then 1 else 0 end as [_transfer_direct_call],
case when ae._param2 = 'Consultation' then 'Consultation' when ae._param2 = 'Direct' then 'Direct' when ae._event_type = 'MotCobTransfer' then 'Camp On Busy' when ae._transfer_type != 'MotCobTransfer' AND ae._param2 is null and ae._queue_call_id is not null then 'Unknown' end as '_transfer_type',

case when qc._unhandled_action = 'HandledAsUnhandledCall' then 1 else 0 end as [_unhandled_action_handled_as_unhandled_call],
case when qc._unhandled_action = 'RemovedByNewCall' then 1 else 0 end as [_unhandled_action_removed_by_new_call],
qc._call_qualification_name,
qc._media_type

from [load].[office_team_statistics_queue_call] qc with (nolock)
join stamp on stamp.dongle_id = qc._dongle_id 
join [V20232].[dim_queue_call_queue_name] qn on qn.[_queue_call_queue_name_unique_id] = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',qc.[_queue_id],'_',qc.[_queue_name],'_',qc.[_tags])),2)
join [V20232].[dim_call] dc on dc._endpoint_contact_column = 'called' and dc._endpoint_contact_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_','called','_',ltrim(rtrim(qc._called_type)),'_',ltrim(rtrim(qc._called)),'_',ltrim(rtrim(qc._called_name)),'_',ltrim(rtrim(qc._called_address)),'_',ltrim(rtrim(qc._called_department)),'_',ltrim(rtrim(qc._called_company)))),2)
join [V20232].[dim_call] dcc on dcc._endpoint_contact_column = 'calling' and dcc._endpoint_contact_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_','calling','_',ltrim(rtrim(qc._calling_type)),'_',ltrim(rtrim(qc._calling)),'_',ltrim(rtrim(qc._calling_name)),'_',ltrim(rtrim(qc._calling_address)),'_',ltrim(rtrim(qc._calling_department)),'_',ltrim(rtrim(qc._calling_company)))),2)
join [V20232].[dim_call] dct on dct._endpoint_contact_column = 'transferred' and dct._endpoint_contact_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_','transferred','_',ltrim(rtrim(qc._transferred_type)),'_',ltrim(rtrim(qc._transferred)),'_',ltrim(rtrim(qc._transferred_name)),'_',ltrim(rtrim(qc._transferred_address)),'_',ltrim(rtrim(qc._transferred_department)),'_',ltrim(rtrim(qc._transferred_company)))),2)
join [V20232].[dim_queue_agent_name] qeo on qeo.[_queue_call_agent_org_unique_id] = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',qc.[_agent_address_name],'_',qc.[_agent_company_name],'_',qc.[_agent_department_name],'_',qc.[_agent_name])),2)
join [V20232].[dim_call_component] cc on cc._call_component_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',qc._call_component_id,'_',ltrim(rtrim(qc._call_component_name)),'_',ltrim(rtrim(qc._call_component_type)))),2)
left join agentevent ae on qc.[_queue_call_id] = ae.[_queue_call_id] and qc.[_dongle_id] = ae.[_dongle_id]  and #row = 1
left join [V20232].[dim_queue_call_junk] qcj on qcj._queue_call_junk_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',qc.[_agent_skill],'_',qc.[_agent_client],'_',qc.[_action],'_',CASE WHEN qc._action = 'Hangup' OR qc._action = 'LostCall' OR qc._action = 'TerminatedOnRequest' THEN 'Lost' WHEN qc.[_overflow_type] <> 'None' THEN 'Overflow' WHEN ae._queue_call_id is not null	THEN 'Transfers' WHEN qc._action = 'Agent' THEN 'Agent' END,'_',qc.[_overflow_type])),2)
left join agenttime [at] on qc.[_queue_call_id] = [at].[_queue_call_id] AND qc.[_dongle_id] = [at].[_dongle_id] 
where qc._media_type = 'Audio' 
and convert(date,qc._created) >= stamp.stamp and convert(date,qc._created) <= stamp.LoadDataTo

union all

select
cast(substring(qw._dongle_id,2,10) as int) as _dongle_id,
w.id,
case when qw._stamp = qw._created then 1 else 0 end as orig,
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_',qw.[_queue_id],'_',qw.[_queue_name],'_',qw.[_tags])),2) as [_queue_call_queue_name_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_','called','_','','_','','_','','_','','_','','_','')),2) as [_endpoint_contact_called_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_','calling','_','','_','','_','','_','','_','','_','')),2) as [_endpoint_contact_calling_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_','transferred','_','','_','','_','','_','','_','','_','')),2) as [_endpoint_contact_transferred_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_','transfer','_','','_','','_','','_','','_','','_','')),2) as [_endpoint_contact_transfer_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_',qw.[_agent_address_name],'_',qw.[_agent_company_name],'_',qw.[_agent_department_name],'_',qw.[_agent_name])),2) as [_queue_call_agent_org_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_',qw.[_agent_skill],'_',rtrim(ltrim(qw.[_agent_client])),'_',rtrim(ltrim(qw.[_action])),'_',case when qw._action = 'ChatServiceDisconnected' or qw._action = 'ProxyServiceDisconnected' or qw._action = 'TerminatedOnRequest' then 'Lost' when qw.[_overflow_type] <> 'None' then 'Overflow' end,'_',rtrim(ltrim(qw.[_overflow_type])))),2) as  [_queue_call_junk_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_',qw._call_component_id,'_',rtrim(ltrim(qw._call_component_name)),'_',rtrim(ltrim(qw._call_component_type)))),2) as [_call_component_unique_id],

cast(format(qw._event_time,'yyyyMMdd') as int) as _date_id,
cast(format(qw._event_time,'HHmmss') as int) as _time_id,
qw._queue_id as [_queue_call_table_id],
qw._web_chat_id as [_queue_call_id],

convert(int,0) as [_callback],
0 as [_callback_agent_logged_out],
0 as [_callback_agent_new_queue],
0 as [_callback_agent_no_agent_feedback],
0 as [_callback_replaced_by_new_call],
0 as [_callback_failed],
0 as [_callback_successful], /* koorekt ?? */
1 as [_callback_none],
0 as [_callback_time],
0 as [_callback_attempts],  
				
isnull(datediff(minute,'00:00:00.000000',[_agent_web_chat_duration]),0)  * 60 as [_first_call_duration],

0 as [_consultation_transfer_duration],
0 as [_unhandled_action_handled_time],
0 as [_callback_choice_time],
case when qw.[_action] <> 'OverflowNewCall' then datediff(minute, qw.[_event_time], qw.[_left_queue]) * 60 end as [_waiting_time],
0 as [_transfer],

case when qw._overflow_type = 'AllAgentsPaused' then 1 else 0 end as [_overflow_all_agent_paused],				
case when qw._overflow_type = 'CallWaitedMoreThan' then 1 else 0 end as [_overflow_call_waiting_more_than],
case when qw._overflow_type = 'CallerPressedDtmf' then 1 else 0 end as [_overflow_caller_pressed_dtmf],
case when qw._overflow_type = 'LongestWaitingCall' then 1 else 0 end as [_overflow_longest_waiting_call],
case when qw._overflow_type = 'NoAgentsAreAvailable' then 1 else 0 end as [_overflow_no_agents_are_avaliable],
case when qw._overflow_type = 'NoAgentsAreLoggedIn' then 1 else 0 end as [_overflow_no_agents_are_logged_in],
case when qw._overflow_type = 'OneOrMoreCallsInQueue' then 1 else 0 end as [_overflow_one_or_more_calls_in_queue],
				
case when qw._call_qualification_id is not null then 1 else 0 end as [_call_qualification],
case when qw._call_qualification_id is null and qw._action in ('Agent') or qw._agent_web_chat_distribution in ('Pickup') then 1 when qw._call_qualification_name = '' and ( qw._action in ('Agent') or qw._agent_web_chat_distribution in ('Pickup')) then 1 else 0 end as [_call_no_qualification],

case when qw._action in ('Agent') or qw._agent_web_chat_distribution in ('Pickup') then 1 else 0 end as [_call_answered],
case when qw._agent_web_chat_distribution in ('Pickup') then 1 else 0 end as [_call_pulled_by_agent],
case when qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') then 1 else 0 end as [_call_lost],

CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 < 5 THEN 1 END AS [_call_lost_before_5_sek],
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 BETWEEN 5 AND 10 THEN 1 END AS [_call_lost_after_5_sek_before_10_sek],
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 BETWEEN 11 AND 15 THEN 1 END AS [_call_lost_after_10_sek_before_15_sek],
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 BETWEEN 16 AND 30 THEN 1 END AS [_call_lost_after_15_sek_before_30_sek],
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 BETWEEN 31 AND 60 THEN 1 END AS [_call_lost_after_30_sek_before_60_sek],
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 BETWEEN 61 AND 120 THEN 1 END AS [_call_lost_after_60_sek_before_120_sek],
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 BETWEEN 121 AND 300 THEN 1 END AS [_call_lost_after_120_sek_before_300_sek],	   
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 > 300 THEN 1 END AS [_call_lost_after_300_sek],	   
      
case when qw._overflow_type <> 'None' then 1 else 0 end as [_overflow],

case when qw._action = 'OverflowNewCall' then 1 else 0 end as [_overflow_new],
case when qw._action = 'OverflowExistingCall' then 1 else 0 end as [_overflow_existing],

case when qw._service_level = 'Yes' then 1 else 0 end as  [_call_service_level_yes],
case when qw._service_level = 'No' then 1 else 0 end as  [_call_service_level_no],
case when qw._service_level = 'None' then 1 else 0 end as  [_call_service_level_none],
					
'' as test,	
0 as [_transfer_call],
0 as [_transfer_consultation_call],
0 as [_transfer_direct_call],
'Unknown' as _transfer_type,

0 as [_unhandled_action_handled_as_unhandled_call],
0 as [_unhandled_action_removed_by_new_call],
qw._call_qualification_name,
'WebChat' as _media_type

from [load].[office_team_statistics_web_chat] w
join [load].[office_team_statistics_queue_web_chat] qw on qw.[_global_web_chat_id] = w._global_web_chat_id
join stamp on stamp.dongle_id = w._dongle_id 
and convert(date,w._created) >= stamp.stamp and convert(date,w._created) <= stamp.LoadDataTo


union all

select
cast(substring(qw._dongle_id,2,10) as int) as _dongle_id,
w.id,
case when qw._stamp = qw._created then 1 else 0 end as orig,
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_',qw.[_queue_id],'_',qw.[_queue_name],'_',qw.[_tags])),2) as [_queue_call_queue_name_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_','called','_','','_','','_','','_','','_','','_','')),2) as [_endpoint_contact_called_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_','calling','_','','_','','_','','_','','_','','_','')),2) as [_endpoint_contact_calling_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_','transferred','_','','_','','_','','_','','_','','_','')),2) as [_endpoint_contact_transferred_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_','transfer','_','','_','','_','','_','','_','','_','')),2) as [_endpoint_contact_transfer_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_',qw.[_agent_address_name],'_',qw.[_agent_company_name],'_',qw.[_agent_department_name],'_',qw.[_agent_name])),2) as [_queue_call_agent_org_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_',qw.[_agent_skill],'_',rtrim(ltrim(qw.[_agent_client])),'_',rtrim(ltrim(qw.[_action])),'_',case when qw._action = 'ChatServiceDisconnected' or qw._action = 'ProxyServiceDisconnected' or qw._action = 'TerminatedOnRequest' then 'Lost' when qw.[_overflow_type] <> 'None' then 'Overflow' end,'_',rtrim(ltrim(qw.[_overflow_type])))),2) as  [_queue_call_junk_unique_id],
convert(nvarchar(100),hashbytes('md5',concat(cast(substring(qw._dongle_id,2,10) as int),'_',qw._call_component_id,'_',rtrim(ltrim(qw._call_component_name)),'_',rtrim(ltrim(qw._call_component_type)))),2) as [_call_component_unique_id],

cast(format(qw._event_time,'yyyyMMdd') as int) as _date_id,
cast(format(qw._event_time,'HHmmss') as int) as _time_id,
qw._queue_id as [_queue_call_table_id],
qw._task_id as [_queue_call_id],

convert(int,0) as [_callback],
0 as [_callback_agent_logged_out],
0 as [_callback_agent_new_queue],
0 as [_callback_agent_no_agent_feedback],
0 as [_callback_replaced_by_new_call],
0 as [_callback_failed],
0 as [_callback_successful], /* koorekt ?? */
1 as [_callback_none],
0 as [_callback_time],
0 as [_callback_attempts],  
				
isnull(datediff(minute,'00:00:00.000000',[_agent_task_duration]),0) * 60 as [_first_call_duration],

0 as [_consultation_transfer_duration],
0 as [_unhandled_action_handled_time],
0 as [_callback_choice_time],
case when qw.[_action] <> 'OverflowNewCall' then datediff(minute, qw.[_event_time], qw.[_left_queue]) * 60 end as [_waiting_time],
0 as [_transfer],

case when qw._overflow_type = 'AllAgentsPaused' then 1 else 0 end as [_overflow_all_agent_paused],				
case when qw._overflow_type = 'CallWaitedMoreThan' then 1 else 0 end as [_overflow_call_waiting_more_than],
case when qw._overflow_type = 'CallerPressedDtmf' then 1 else 0 end as [_overflow_caller_pressed_dtmf],
case when qw._overflow_type = 'LongestWaitingCall' then 1 else 0 end as [_overflow_longest_waiting_call],
case when qw._overflow_type = 'NoAgentsAreAvailable' then 1 else 0 end as [_overflow_no_agents_are_avaliable],
case when qw._overflow_type = 'NoAgentsAreLoggedIn' then 1 else 0 end as [_overflow_no_agents_are_logged_in],
case when qw._overflow_type = 'OneOrMoreCallsInQueue' then 1 else 0 end as [_overflow_one_or_more_calls_in_queue],
				
0 as [_call_qualification],
0 as [_call_no_qualification],

case when qw._action in ('Agent') or qw._agent_task_distribution in ('Pickup') then 1 else 0 end as [_call_answered],
case when qw._agent_task_distribution in ('Pickup') then 1 else 0 end as [_call_pulled_by_agent],
case when qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') then 1 else 0 end as [_call_lost],

CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 < 5 THEN 1 END AS [_call_lost_before_5_sek],
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 BETWEEN 5 AND 10 THEN 1 END AS [_call_lost_after_5_sek_before_10_sek],
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 BETWEEN 11 AND 15 THEN 1 END AS [_call_lost_after_10_sek_before_15_sek],
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 BETWEEN 16 AND 30 THEN 1 END AS [_call_lost_after_15_sek_before_30_sek],
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 BETWEEN 31 AND 60 THEN 1 END AS [_call_lost_after_30_sek_before_60_sek],
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 BETWEEN 61 AND 120 THEN 1 END AS [_call_lost_after_60_sek_before_120_sek],
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 BETWEEN 121 AND 300 THEN 1 END AS [_call_lost_after_120_sek_before_300_sek],	   
CASE WHEN qw._action in ('TerminatedOnRequest','ChatServiceDisconnected','ProxyServiceDisconnected') AND datediff(minute, _event_time, _left_queue) * 60 > 300 THEN 1 END AS [_call_lost_after_300_sek],	   
      
case when qw._overflow_type <> 'None' then 1 else 0 end as [_overflow],

case when qw._action = 'OverflowNewCall' then 1 else 0 end as [_overflow_new],
case when qw._action = 'OverflowExistingCall' then 1 else 0 end as [_overflow_existing],

case when qw._service_level = 'Yes' then 1 else 0 end as  [_call_service_level_yes],
case when qw._service_level = 'No' then 1 else 0 end as  [_call_service_level_no],
case when qw._service_level = 'None' then 1 else 0 end as  [_call_service_level_none],
								
'' as test,
0 as [_transfer_call],
0 as [_transfer_consultation_call],
0 as [_transfer_direct_call],
'Unknown' as _transfer_type,

0 as [_unhandled_action_handled_as_unhandled_call],
0 as [_unhandled_action_removed_by_new_call],
'' as _call_qualification_name,
'Task' as _media_type

from [load].[office_team_statistics_task] w
join [load].[office_team_statistics_queue_task] qw on qw.[_global_task_id] = w._global_task_id
join stamp on stamp.dongle_id = w._dongle_id 
and convert(date,w._created) >= stamp.stamp and convert(date,w._created) <= stamp.LoadDataTo

)
select * from result

END
GO

