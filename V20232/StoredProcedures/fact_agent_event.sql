



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [V20232].[fact_agent_event]
	-- Add the parameters for the stored procedure here
	@Dongle int, @mth int
	
AS
BEGIN

with stamp as (	
    --select '_2207' as dongle_id, '2023-12-01' as stamp, '2024-01-16' as LoadDataTo
	select concat('_',@dongle) as dongle_id, datefromparts(left(@mth,4),right(@mth,2),1) as stamp, eomonth(datefromparts(left(@mth,4),right(@mth,2),1)) as LoadDataTo	
), onhold as (
	SELECT 
	QueueOnHold._dongle_id AS _dongle_id, QueueOnHold.[_queue_call_id] AS QCID,
	SUM(DATEDIFF(second,QueueOnHold.[_event_start],QueueOnHold.[_event_stop])) AS QDURSUM 	
	FROM [load].office_team_statistics_agent_event  AS QueueOnHold with(nolock)
	join stamp on stamp.dongle_id = QueueOnHold._dongle_id	
	where QueueOnHold.[_event_type] in ('OfficeTeamCallOnHold','OfficeTeamConsultationCall')
	and QueueOnHold._created >= stamp.stamp and QueueOnHold._created <= stamp.LoadDataTo
	GROUP BY QueueOnHold.[_queue_call_id], 	QueueOnHold._dongle_id	
), eventstop_callid as (
	select ae._dongle_id,ae._call_id,ae.[_event_type] ,
	sum(datediff(second,ae._event_start,case when ae._event_stop > ae._event_start then ae._event_stop else ae._event_start end)) as duration
	from [load].office_team_statistics_agent_event ae with(nolock)
	join stamp on stamp.dongle_id = ae._dongle_id
	AND _call_id is not null
	where ae._created >= stamp.stamp and ae._created <= stamp.LoadDataTo
	group by ae._dongle_id,ae.[_call_id],ae._event_type
), eventstop_privcallid as (
	select ae._dongle_id,ae._private_call_id,ae.[_event_type],sum(datediff(second,ae._event_start,ae._event_stop)) as duration
	from [load].office_team_statistics_agent_event ae  with(nolock)
    join stamp on stamp.dongle_id = ae._dongle_id
	where ae._created >= stamp.stamp and ae._created <= stamp.LoadDataTo
	AND _private_call_id is not null 
	group by ae._dongle_id,ae._private_call_id,ae._event_type
)

, result as ( 

select

cast(substring(ae._dongle_id,2,10) as INT) as _dongle_id,
cast(format(ae._event_start,'yyyyMMdd') as int) as _date_id,
cast(format(ae._event_start,'HHmmss') as int) as _time_id,

case when ae._param2     = 'Consultation' then datediff(SECOND, ae.[_event_start], ae.[_event_stop]) else 0 end as [_consultation_transfer_duration],
case when ae._event_type = '' then 1 else 0 end as [_event_duration_other],
case when ae._event_type = 'Ready' then datediff(SECOND, ae.[_event_start], ae.[_event_stop]) else 0 end as [_event_duration_ready],
case when ae._event_type = 'AfterCallWorkTime' then datediff(SECOND, ae.[_event_start], ae.[_event_stop]) else 0 end as [_event_duration_acwt],
case when ae._event_type = 'OfficeTeamCall' then datediff(SECOND, ae.[_event_start], ae.[_event_stop]) else 0 end as [_event_duration_officeteam_call],
case when ae._event_type = 'PrivateCallIn' then datediff(SECOND, ae.[_event_start], ae.[_event_stop]) else 0 end as [_event_duration_direct_call_in],
case when ae._event_type = 'PrivateCallOut' then datediff(SECOND, ae.[_event_start], ae.[_event_stop]) else 0 end as [_event_duration_direct_call_out],
case when ae._event_type = 'PrivateCallUnknown' then datediff(SECOND, ae.[_event_start], ae.[_event_stop]) else 0 end as [_event_duration_direct_call_unknown],
case when ae._event_type = 'Quarantined' then datediff(SECOND, ae.[_event_start], ae.[_event_stop]) else 0 end as [_event_duration_quarantined],
case when ae._event_type = 'Paused' then datediff(SECOND, ae.[_event_start], ae.[_event_stop]) else 0 end as [_event_duration_paused],

case when ae._event_type = 'CallOfferedAcceptedCall' then 1 else 0 end as [_event_call_offered_accepted_call],
case when ae._event_type = 'CallOfferedEndedByService' then 1 else 0 end as [_event_call_offered_ended_by_service],
case when ae._event_type = 'PulledCallByAgent' then 1 else 0 end as [_event_call_pulled_by_agent],
case when ae._event_type = 'PulledCallFromAgent' then 1 else 0 end as [_event_call_pulled_from_agent],
case when ae._event_type = 'PickedUpCall' then 1 else 0 end as [_event_picked_up_officeteam_call],
case when ae._event_type = 'CallOfferedCallerHangup' then 1 else 0 end as [_event_call_offered_caller_hangup],
case when ae._event_type = 'CallOfferedNotAcceptedCall' then 1 else 0 end as [_event_call_offered_not_accepted_call],
case when ae._event_type = 'ReceivedMotPulled' then 1 else 0 end as [_event_received_officeteam_pulled],

case when ae._event_type in ('CallOfferedAcceptedCall', 'PickUpCall') then 1 else 0 end as [_call_answered_status_answered], 
case when ae._event_type in ('CallOfferedNotAcceptedCall') then 1 else 0 end as [_call_answered_status_not_answered],
case when ae._event_type not in ('CallOfferedAcceptedCall', 'PickUpCall','CallOfferedNotAcceptedCall') then 1 else 0 end as [_call_answered_status_unknown],

case when ae._event_type = 'PrivateCallIn' then 1 else 0 end as [_call_private_call_in],
case when ae._event_type = 'PrivateCallOut' then 1 else 0 end as [_call_private_call_out],
case when ae._event_type = 'PrivateCallUnknown' then 1 else 0 end as [_call_private_call_unknown],

case when ae._event_type = 'MotTransfer' then 1 else 0 end as [_officeteam_call_transfer],
case when ae._event_type = 'MotCobTransfer' then 1 else 0 end as [_officeteam_call_cob_transfer],

case when ae._event_type = 'PrivateTransfer' then 1 else 0 end as [_private_call_transfer],
case when ae._event_type = 'PrivateCobTransfer' then 1 else 0 end as [_private_call_cob_transfer],

0 as [_private_call_transfer_type],

case when ae._event_type = 'LoggedOut' then 1 else 0 end as [_event_logged_out],
case when ae._event_type = 'LoggedIn' then 1 else 0 end as [_event_logged_in],
ae._call_id,
ae._global_call_id,
ae.[_queue_call_id],
ae._private_call_id,
1 as #row,

ae._queue_id,
ae._queue_name,
ae._tags,
ae._agent_skill,
ae._agent_client,
ae._event_type,
ae._agent_address_name,
ae._agent_company_name,
ae._agent_department_name,
ae._agent_name,
ae._agent_id,
ae._param1,
ae._param2,
ae._param3,
ae._pause_reason,
ae.Id,
ae._created,
case when ae._stamp = ae._created then 1 else 0 end as orig
from [load].office_team_statistics_agent_event as ae with(nolock)
join stamp on stamp.dongle_id = ae._dongle_id
where  ae._media_type IN ('Audio','None','Unknown') 
and ae.[_event_type] NOT IN ('OfficeTeamCall','OfficeTeamCallOnHold','PrivateCallIn','PrivateCallInOnHold','PrivateCallOut','PrivateCallOutOnHold','PrivateCallUnknown','PrivateCallUnknownOnHold')
and convert(date,ae._created) >= stamp.stamp and convert(date,ae._created) <= stamp.LoadDataTo

UNION ALL 

select

cast(substring(ae._dongle_id,2,10) as INT) as _dongle_id,
cast(format(ae._event_start,'yyyyMMdd') as int) as _date_id,
cast(format(ae._event_start,'HHmmss') as int) as _time_id,

case when ae._param2     = 'Consultation' then datediff(SECOND, ae.[_event_start], ae.[_event_stop]) else 0 end as [_consultation_transfer_duration],
case when ae._event_type = '' then 1 else 0 end as [_event_duration_other],
case when ae._event_type = 'Ready' then s.duration else 0 end as [_event_duration_ready],
case when ae._event_type = 'AfterCallWorkTime' then s.duration else 0 end as [_event_duration_acwt],
case when ae._event_type in ('OfficeTeamCall','OfficeTeamCallOnhold') then s.duration + isnull(onhold.QDURSUM,0) else 0 end as [_event_duration_officeteam_call],
case when ae._event_type = 'PrivateCallIn' then s.duration else 0 end as [_event_duration_direct_call_in],
case when ae._event_type = 'PrivateCallOut' then s.duration else 0 end as [_event_duration_direct_call_out],
case when ae._event_type = 'PrivateCallUnknown' then s.duration else 0 end as [_event_duration_direct_call_unknown],
case when ae._event_type = 'Quarantined' then s.duration else 0 end as [_event_duration_quarantined],
case when ae._event_type = 'Paused' then s.duration else 0 end as [_event_duration_paused],

case when ae._event_type = 'CallOfferedAcceptedCall' then 1 else 0 end as [_event_call_offered_accepted_call],
case when ae._event_type = 'CallOfferedEndedByService' then 1 else 0 end as [_event_call_offered_ended_by_service],
case when ae._event_type = 'PulledCallByAgent' then 1 else 0 end as [_event_call_pulled_by_agent],
case when ae._event_type = 'PulledCallFromAgent' then 1 else 0 end as [_event_call_pulled_from_agent],
case when ae._event_type = 'PickedUpCall' then 1 else 0 end as [_event_picked_up_officeteam_call],
case when ae._event_type = 'CallOfferedCallerHangup' then 1 else 0 end as [_event_call_offered_caller_hangup],
case when ae._event_type = 'CallOfferedNotAcceptedCall' then 1 else 0 end as [_event_call_offered_not_accepted_call],
case when ae._event_type = 'ReceivedMotPulled' then 1 else 0 end as [_event_received_officeteam_pulled],

0 as [_call_answered_status_answered], 
0 as [_call_answered_status_not_answered],
0 as [_call_answered_status_unknown],

case when ae._event_type = 'PrivateCallIn' then 1 else 0 end as [_call_private_call_in],
case when ae._event_type = 'PrivateCallOut' then 1 else 0 end as [_call_private_call_out],
case when ae._event_type = 'PrivateCallUnknown' then 1 else 0 end as [_call_private_call_unknown],

case when ae._event_type = 'MotTransfer' then 1 else 0 end as [_officeteam_call_transfer],
case when ae._event_type = 'MotCobTransfer' then 1 else 0 end as [_officeteam_call_cob_transfer],

case when ae._event_type = 'PrivateTransfer' then 1 else 0 end as [_private_call_transfer],
case when ae._event_type = 'PrivateCobTransfer' then 1 else 0 end as [_private_call_cob_transfer],

0 as [_private_call_transfer_type],

case when ae._event_type = 'LoggedOut' then 1 else 0 end as [_event_logged_out],
case when ae._event_type = 'LoggedIn' then 1 else 0 end as [_event_logged_in],
ae._call_id,
ae._global_call_id,
ae.[_queue_call_id],
ae._private_call_id,
--row_number() over( partition by ae._private_call_id,ae._paf_call,ae.[_agent_id],ae.[_agent_name],ae.[_call_id] order by ae._agent_id,ae._private_call_id,ae._event_type,ae.id) as #row,
row_number() over( partition by ae._dongle_id,ae._queue_call_id, ae._paf_call, ae._agent_id, ae._agent_name, ae._call_id order by ae._agent_id,ae._private_call_id,ae._event_type,ae.id desc) as #row,
ae._queue_id,
ae._queue_name,
ae._tags,
ae._agent_skill,
ae._agent_client,
ae._event_type,
ae._agent_address_name,
ae._agent_company_name,
ae._agent_department_name,
ae._agent_name,
ae._agent_id,
ae._param1,
ae._param2,
ae._param3,
ae._pause_reason,
ae.id,
ae._created,
case when ae._stamp = ae._created then 1 else 0 end as orig
from [load].office_team_statistics_agent_event as ae with(nolock)
join stamp on stamp.dongle_id =  ae._dongle_id 
left join onhold on onhold._dongle_id = ae._dongle_id and onhold.QCID = ae._queue_call_id
left join eventstop_callid s on s._dongle_id = ae._dongle_id and s._call_id = ae._call_id and s._event_type = ae._event_type
where ae._queue_call_id IS NOT NULL AND ae._event_type LIKE 'OfficeTeamCall%'
and convert(date,ae._created) >= stamp.stamp and convert(date,ae._created) <= stamp.LoadDataTo

UNION ALL

select 

cast(substring(ae._dongle_id,2,10) as INT) as _dongle_id,
cast(format(ae._event_start,'yyyyMMdd') as int) as _date_id,
cast(format(ae._event_start,'HHmmss') as int) as _time_id,

case when ae._param2     = 'Consultation' then datediff(SECOND, ae.[_event_start], ae.[_event_stop]) else 0 end as [_consultation_transfer_duration_sum],
case when ae._event_type = '' then 1 else 0 end as [_event_duration_other],
case when ae._event_type = 'Ready' then s.duration else 0 end as [_event_duration_ready],
case when ae._event_type = 'AfterCallWorkTime' then s.duration else 0 end as [_event_duration_acwt],
case when ae._event_type = 'OfficeTeamCall' then s.duration else 0 end as [_event_duration_officeteam_call],
case when ae._event_type = 'PrivateCallIn' then s.duration else 0 end as [_event_duration_direct_call_in],
case when ae._event_type = 'PrivateCallOut' then s.duration else 0 end as [_event_duration_direct_call_out],
case when ae._event_type = 'PrivateCallUnknown' then s.duration else 0 end as [_event_duration_direct_call_unknown],
case when ae._event_type = 'Quarantined' then s.duration else 0 end as [_event_duration_quarantined],
case when ae._event_type = 'Paused' then s.duration else 0 end as [_event_duration_paused],

case when ae._event_type = 'CallOfferedAcceptedCall' then 1 else 0 end as [_event_call_offered_accepted_call],
case when ae._event_type = 'CallOfferedEndedByService' then 1 else 0 end as [_event_call_offered_ended_by_service],
case when ae._event_type = 'PulledCallByAgent' then 1 else 0 end as [_event_call_pulled_by_agent],
case when ae._event_type = 'PulledCallFromAgent' then 1 else 0 end as [_event_call_pulled_from_agent],
case when ae._event_type = 'PickedUpCall' then 1 else 0 end as [_event_picked_up_officeteam_call],
case when ae._event_type = 'CallOfferedCallerHangup' then 1 else 0 end as [_event_call_offered_caller_hangup],
case when ae._event_type = 'CallOfferedNotAcceptedCall' then 1 else 0 end as [_event_call_offered_not_accepted_call],
case when ae._event_type = 'ReceivedMotPulled' then 1 else 0 end as [_event_received_officeteam_pulled],

case when ae.[_param1] = 'Answered' and ae.[_event_type] = 'PrivateCallIn' then 1 else 0 end as [_call_answered_status_answered], 
case when ae.[_param1] = 'NotAnswered' and ae.[_event_type] = 'PrivateCallIn' then 1 else 0 end as [_call_answered_status_not_answered],
case when ae.[_param1] not in ('Answered','NotAnswered') and ae.[_event_type] = 'PrivateCallIn' then 1 else 0 end as [_call_answered_status_unknown],

case when ae._event_type = 'PrivateCallIn' then 1 else 0 end as [_call_private_call_in],
case when ae._event_type = 'PrivateCallOut' then 1 else 0 end as [_call_private_call_out],
case when ae._event_type = 'PrivateCallUnknown' then 1 else 0 end as [_call_private_call_unknown],

case when ae._event_type = 'MotTransfer' then 1 else 0 end as [_officeteam_call_transfer],
case when ae._event_type = 'MotCobTransfer' then 1 else 0 end as [_officeteam_call_cob_transfer],

case when ae._event_type = 'PrivateTransfer' then 1 else 0 end as [_private_call_transfer],
case when ae._event_type = 'PrivateCobTransfer' then 1 else 0 end as [_private_call_cob_transfer],

0 as [_private_call_transfer_type_sum],

case when ae._event_type = 'LoggedOut' then 1 else 0 end as [_event_logged_out],
case when ae._event_type = 'LoggedIn' then 1 else 0 end as [_event_logged_in],
ae._call_id,
ae._global_call_id,
ae._queue_call_id,
ae._private_call_id,
row_number() over( partition by  ae._dongle_id,ae._private_call_id,ae.[_agent_id],ae.[_agent_name],ae.[_call_id] order by ae._agent_id,ae._private_call_id,ae._event_type,ae.id) as #row,
ae._queue_id,
ae._queue_name,
ae._tags,
ae._agent_skill,
ae._agent_client,
ae._event_type,
ae._agent_address_name,
ae._agent_company_name,
ae._agent_department_name,
ae._agent_name,
ae._agent_id,
ae._param1,
ae._param2,
ae._param3,
ae._pause_reason,
ae.id,
ae._created,
case when ae._stamp = ae._created then 1 else 0 end as orig

from [load].office_team_statistics_agent_event as ae with(nolock)
join stamp on stamp.dongle_id =  ae._dongle_id  
left join onhold on onhold.QCID = ae._queue_call_id and onhold._dongle_id = ae._dongle_id
left join eventstop_privcallid s on s._dongle_id = ae._dongle_id and s._private_call_id = ae._private_call_id and s._event_type = ae._event_type
where ae.[_private_call_id] IS NOT NULL AND ae.[_event_type] LIKE 'Privatecall%' 
and convert(date,ae._created) >= stamp.stamp and convert(date,ae._created) <= stamp.LoadDataTo


)

select 
ae._dongle_id,
ae.Id,
ae.orig,
ae._queue_call_id,
convert(nvarchar(100),hashbytes('MD5',concat(ae._dongle_id,'_',ae.[_queue_id],'_',lower(ltrim(rtrim(ae.[_queue_name]))),'_',lower(ltrim(rtrim(ae.[_tags]))))),2) as [_agent_event_queue_name_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(ae._dongle_id,'_','called','_',ltrim(rtrim(_called_type)),'_',ltrim(rtrim(_called)),'_',ltrim(rtrim(_called_name)),'_',ltrim(rtrim(_called_address)),'_',ltrim(rtrim(_called_department)),'_',ltrim(rtrim(_called_company)))),2) as [_endpoint_contact_called_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(ae._dongle_id,'_','calling','_',ltrim(rtrim(_calling_type)),'_',ltrim(rtrim(_calling)),'_',ltrim(rtrim(_calling_name)),'_',ltrim(rtrim(_calling_address)),'_',ltrim(rtrim(_calling_department)),'_',ltrim(rtrim(_calling_company)))),2) as [_endpoint_contact_calling_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(ae._dongle_id,'_','transferred','_',ltrim(rtrim(_transferred_type)),'_',ltrim(rtrim(_transferred)),'_',ltrim(rtrim(_transferred_name)),'_',ltrim(rtrim(_transferred_address)),'_',ltrim(rtrim(_transferred_department)),'_',ltrim(rtrim(_transferred_company)))),2) as [_endpoint_contact_transferred_unique_id],
ae._date_id,
ae._time_id,
convert(nvarchar(100),hashbytes('MD5',concat(ae._dongle_id,'_',ae.[_agent_skill],'_',ae.[_agent_client],'_',ae.[_event_type],'_',CASE WHEN ae.[_private_call_id] IS NOT NULL THEN 'Direct Call Event' WHEN ae.[_queue_call_id] IS NOT NULL THEN 'Contact Center Call Event' END,'_',CASE WHEN ae.[_event_type] IN ('CallOfferedAcceptedCall', 'PickUpCall') OR (ae.[_private_call_id] IS NOT NULL AND ae.[_param1] = 'Answered') THEN 'Call Answered' WHEN ae.[_event_type] IN ('CallOfferedNotAcceptedCall') OR (ae.[_private_call_id] IS NOT NULL AND ae.[_param1] = 'NotAnswered') THEN 'Call Not Answered' ELSE 'Unknown' END,'_',ae.[_pause_reason],'_',ae.[_param3])),2) as [_agent_event_junk_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(ae._dongle_id,'_',ae.[_agent_address_name],'',ae.[_agent_company_name],'',ae.[_agent_department_name],'',ae.[_agent_name])),2) as [_agent_event_agent_org_unique_id],
--convert(nvarchar(100),hashbytes('MD5',concat(ae._dongle_id,'_',ae.[_agent_id],'_',ae.[_agent_name])),2) as [_agent_event_agent_org_unique_id],
ae._agent_client,
ae._event_type,
ae._private_call_id,
ae._call_id,

ae.[_consultation_transfer_duration] as [_consultation_transfer_duration],

ae.[_event_duration_other] as  [_event_duration_other_sum],
ae.[_event_duration_ready] as [_event_duration_ready_sum],
ae.[_event_duration_acwt] as [_event_duration_acwt_sum],
ae.[_event_duration_officeteam_call] as [_event_duration_officeteam_call_sum],

ae.[_event_duration_direct_call_in] as [_event_duration_direct_call_in_sum],
ae.[_event_duration_direct_call_out] as [_event_duration_direct_call_out_sum],
ae.[_event_duration_direct_call_unknown] as [_event_duration_direct_call_unknown_sum],

ae.[_event_duration_quarantined] as [_event_duration_quarantined_sum],
ae.[_event_duration_paused] as [_event_duration_paused_sum],

ae.[_event_call_offered_accepted_call] as [_event_call_offered_accepted_call_sum],
ae.[_event_call_offered_ended_by_service] as [_event_call_offered_ended_by_service_sum],
ae.[_event_call_pulled_by_agent] as [_event_call_pulled_by_agent_sum],
ae.[_event_call_pulled_from_agent] as [_event_call_pulled_from_agent_sum],
ae.[_event_picked_up_officeteam_call] as [_event_picked_up_officeteam_call_sum],
ae.[_event_call_offered_caller_hangup] as [_event_call_offered_caller_hangup_sum],
ae.[_event_call_offered_not_accepted_call] as [_event_call_offered_not_accepted_call_sum],
ae.[_event_received_officeteam_pulled] as [_event_received_officeteam_pulled_sum],

ae.[_call_answered_status_answered] as  [_call_answered_status_answered_sum],
ae.[_call_answered_status_not_answered] as [_call_answered_status_not_answered_sum],
ae.[_call_answered_status_unknown] as [_call_answered_status_unknown_sum],

ae.[_call_private_call_in] as [_call_private_call_in_sum],
ae.[_call_private_call_out] as [_call_private_call_out_sum],
ae.[_call_private_call_unknown] as [_call_private_call_unknown_sum],

ae.[_officeteam_call_transfer] as [_officeteam_call_transfer_sum],
ae.[_officeteam_call_cob_transfer] as [_officeteam_call_cob_transfer_sum],

ae.[_private_call_transfer] as [_private_call_transfer_sum],
ae.[_private_call_cob_transfer] as [_private_call_cob_transfer_sum],

ae.[_private_call_transfer_type] as [_private_call_transfer_type_sum],

ae.[_event_logged_out] as [_event_logged_out_sum],
ae.[_event_logged_in] as [_event_logged_in_sum]

from result ae
left join [load].office_team_statistics_call AS C ON ( AE._dongle_id = cast(substring(c._dongle_id,2,10) as INT) and C._global_call_id = ae._global_call_id and AE._call_id = C._call_id)

END
GO

