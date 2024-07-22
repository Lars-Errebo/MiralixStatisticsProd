





CREATE view [VIEW].[dim_queue_call_junk] as

with stampdate as (
   select concat('_',dongleid) as dongle_id,
	isnull(case 
	       when dc.LoadDataFrom is not null then dc.LoadDataFrom	       
		   when dc.InquiriesIncreased = 1 then dc.LastLicDate
	       when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,-1,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_queue_call' and Enabled = 1 and WatermarkValue <> '' )
	end,getdate()) as stamp from [VIEW].[DongleConfig] dc where enabled = 1  
), result as (
select
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(s.dongle_id,2,10) as INT),'_',qc.[_agent_skill],'_',ltrim(rtrim(qc.[_agent_client])),'_',ltrim(rtrim(qc.[_action])),'_',
CASE
           WHEN 
                qc._action = 'Hangup'
                OR qc._action = 'LostCall'
                OR qc._action = 'TerminatedOnRequest'
				THEN 'Lost'
           WHEN [_overflow_type] <> 'None' 
				THEN 'Overflow'
		   WHEN t._event_type in ('MotTransfer','MotCobTransfer')
				THEN 'Transfers'
		   WHEN qc._action = 'Agent'
				THEN 'Agent'
END,
'_',ltrim(rtrim([_overflow_type])))),2) as [_queue_call_junk_unique_id],
cast(substring(s.dongle_id,2,10) as INT) as [_dongle_id],
qc.[_agent_skill],
qc.[_agent_client],
qc.[_action],
CASE
           WHEN 
                qc._action = 'Hangup'
                OR qc._action = 'LostCall'
                OR qc._action = 'TerminatedOnRequest'
				THEN 'Lost'
           WHEN [_overflow_type] <> 'None' 
				THEN 'Overflow'
		   WHEN t._event_type in ('MotTransfer','MotCobTransfer')
				THEN 'Transfers'
		   WHEN qc._action = 'Agent'
				THEN 'Agent'
END AS _call_type,
[_overflow_type],
t.id
from [load].[office_team_statistics_queue_call] as qc
left join [load].[office_team_statistics_agent_event] t on t._dongle_id = qc._dongle_id and t._queue_call_id = qc._queue_call_id 
join stampdate s on qc._dongle_id = s.dongle_id
where convert(date,qc._created) >= s.stamp 
), result2 as (
select ROW_NUMBER() OVER(PARTITION BY [_queue_call_junk_unique_id] ORDER BY [_queue_call_junk_unique_id] ) as #row,* from result )
select  
[_queue_call_junk_unique_id],
[_dongle_id],
[_agent_skill] as [_agent_skill],
isnull([_agent_client],'No client') as [_agent_client],
--[load].[V2_Translate]([load].[V2_GetLanguage](_dongle_id),'_action','dim_queue_call_junk',[_action]) as [_action],
a.trans_1 as  [_action],
isnull([_call_type],'No type') as [_call_type],
--[load].[V2_Translate]([load].[V2_GetLanguage](_dongle_id),'_overflow_type','dim_queue_call_junk',[_overflow_type]) as [_overflow_type]
o.trans_1 as [_overflow_type]
from result2 
left join [V2].[fix_translations] as a on a.columnlookup = result2._action and a.reference = 'dim_queue_call_junk' and a.columnname = '_action'
left join [V2].[fix_translations] as o on o.columnlookup = result2._overflow_type and o.reference = 'dim_queue_call_junk' and o.columnname = '_overflow_type'
where #row = 1
GO

