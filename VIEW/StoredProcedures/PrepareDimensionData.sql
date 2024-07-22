
-- =============================================
-- author:		<author,,name>
-- create date: <create date,,>
-- description:	<description,,>
-- =============================================
CREATE procedure [VIEW].[PrepareDimensionData]

as
begin

    set nocount on;

	truncate table [TMP].[user_account]
	;with result as (
	SELECT 1 as _type,cast(substring(_dongle_id,2,10) as INT) as [_dongle_id] ,[_agent_id] FROM [MiralixStatisticsProd].[LOAD].[office_team_statistics_agent_event] where _agent_id is not null group by  [_dongle_id] ,[_agent_id]
	union all
	SELECT 2,cast(substring(_dongle_id,2,10) as INT) as [_dongle_id] ,[_agent_id] FROM [MiralixStatisticsProd].[LOAD].[office_team_statistics_queue_call] where _agent_id is not null  group by  [_dongle_id] ,[_agent_id]
	)
	insert into [TMP].[user_account] select * from result

    truncate table [TMP].[agent_events_org]		
	insert into [TMP].[agent_events_org]
	select 
	convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(ae._dongle_id,2,10) as INT),'_',[_agent_address_name],'',[_agent_company_name],'',[_agent_department_name],'',[_agent_name])),2) as [_agent_event_agent_org_unique_id],
	--convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(ae._dongle_id,2,10) as INT),'_',[_agent_id],'_',[_agent_name])),2) as [_agent_event_agent_org_unique_id],
	cast(substring(ae._dongle_id,2,10) as INT) as [_dongle_id],
	[_agent_address_name],
	[_agent_address_id],
	[_agent_company_name],
	[_agent_company_id],
	[_agent_department_name],
	[_agent_department_id],
	[_agent_name],
	[_agent_id],
	[_event_start] as [_max_event_start]
	from [load].[office_team_statistics_agent_event] ae --with(index(StampOrgIdx))
	join (  select concat('_',dongleid) as dongle_id,
			case when dc.LoadDataFrom is not null then dc.LoadDataFrom
				 when dc.InquiriesIncreased = 1 then dc.LastLicDate
				 when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,0,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_agent_event' and Enabled = 1 and WatermarkValue <> '' )
			end as stamp from [VIEW].[DongleConfig] dc where enabled = 1 ) as s on ae._dongle_id = s.dongle_id	
	where ae._created >= s.stamp

	truncate table [TMP].[agent_events_junk]
	insert into [TMP].[agent_events_junk]
	select 
	convert(nvarchar(100),hashbytes('MD5',concat(
	cast(substring(ae._dongle_id,2,10) as INT),'_',
	[_agent_skill],'_',
	[_agent_client],'_',
	[_event_type],'_',
	CASE WHEN [_private_call_id] IS NOT NULL THEN 'Direct Call Event'
			  WHEN [_queue_call_id] IS NOT NULL THEN 'Contact Center Call Event'
			  END,'_',
	CASE WHEN [_event_type] IN ('CallOfferedAcceptedCall', 'PickUpCall') OR ([_private_call_id] IS NOT NULL AND [_param1] = 'Answered') THEN 'Call Answered'
			  WHEN [_event_type] IN ('CallOfferedNotAcceptedCall') OR ([_private_call_id] IS NOT NULL AND [_param1] = 'NotAnswered') THEN 'Call Not Answered'
			  ELSE 'Unknown'		  
			  END,'_',
	[_pause_reason],'_',
	[_param3]
	)),2) as [_agent_event_junk_unique_id],
	cast(substring(ae._dongle_id,2,10) as INT) as [_dongle_id],
	[_agent_skill],
	[_agent_client],
	[_event_type],
	CASE WHEN [_private_call_id] IS NOT NULL THEN 'Direct Call Event'
			  WHEN [_queue_call_id] IS NOT NULL THEN 'Contact Center Call Event'
			  END AS [_event_type_group],
	CASE WHEN ae._event_type IN ('CallOfferedAcceptedCall', 'PickUpCall') THEN 'Call Answered' 
			 WHEN  ae._event_type = 'PrivateCallIn' and ae._param1 = 'Answered' THEN 'Call Answered' 
			 WHEN  ae._event_type = 'CallOfferedNotAcceptedCall' THEN 'Call Not Answered'
			 WHEN  ae._event_type = 'PrivateCallIn' and ae._param1 = 'NotAnswered' THEN 'Call Not Answered' 
		 ELSE 'Unknown' END AS [_event_type_call_answered_status],
	[_pause_reason],
	[_param3]
	from [load].[office_team_statistics_agent_event] ae --with(index(StampJunkIdx))
	join (  select concat('_',dongleid) as dongle_id,
			case when dc.LoadDataFrom is not null then dc.LoadDataFrom
				 when dc.InquiriesIncreased = 1 then dc.LastLicDate
				 when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,0,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_agent_event' and Enabled = 1 and WatermarkValue <> '' )
			end as stamp from [VIEW].[DongleConfig] dc where enabled = 1 ) as s on ae._dongle_id = s.dongle_id	
	where convert(date,ae._created) >= s.stamp

	truncate table  [TMP].[agent_events_queue]
	insert into [TMP].[agent_events_queue] 
    select
	convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(ae._dongle_id,2,10) as INT),'_',[_queue_id],'_',lower(ltrim(rtrim([_queue_name]))),'_',lower(ltrim(rtrim([_tags]))))),2) as [_agent_event_queue_name_unique_id],
	cast(substring(ae._dongle_id,2,10) as INT) as [_dongle_id],
	[_queue_id],
	[_queue_name],
	[_tags]
	from [load].[office_team_statistics_agent_event] ae --with(index(StampQueueIdx))
	join (  select concat('_',dongleid) as dongle_id,
		case when dc.LoadDataFrom is not null then dc.LoadDataFrom
				when dc.InquiriesIncreased = 1 then dc.LastLicDate
				when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,0,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_agent_event' and Enabled = 1 and WatermarkValue <> '' )
		end as stamp from [VIEW].[DongleConfig] dc where enabled = 1 ) as s on ae._dongle_id = s.dongle_id	
	where convert(date,ae._created) >= s.stamp
	group by ae.[_dongle_id],[_queue_id],[_queue_name],[_tags] 
		
	truncate table  [TMP].[agent_events_trans]
	insert into [TMP].[agent_events_trans] 
	select row_number() over (partition by [_queue_call_id] , ae.[_dongle_id] order by [id] asc) as #row,
		[_queue_call_id],
        cast(substring(_dongle_id,2,10) as INT),
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
	from load.office_team_statistics_agent_event ae --with(index([QueueCallIdIdx]))
	join (  select concat('_',dongleid) as dongle_id,
		case when dc.LoadDataFrom is not null then dc.LoadDataFrom
				when dc.InquiriesIncreased = 1 then dc.LastLicDate
				when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,0,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_agent_event' and Enabled = 1 and WatermarkValue <> '' )
		end as stamp from [VIEW].[DongleConfig] dc where enabled = 1 ) as s on ae._dongle_id = s.dongle_id	
	where convert(date,ae._created) >= s.stamp and [_event_type] IN ('MotTransfer','MotCobTransfer') 

	truncate table [TMP].[statistic_call]
	insert into [TMP].[statistic_call]
	select convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(c._dongle_id,2,10) as INT),'_','calling','_',ltrim(rtrim(_calling_type)),'_',ltrim(rtrim(_calling)),'_',ltrim(rtrim(_calling_name)),'_',ltrim(rtrim(_calling_address)),'_',ltrim(rtrim(_calling_department)),'_',ltrim(rtrim(_calling_company)))),2) as _endpoint_contact_unique_id,cast(substring(c._dongle_id,2,10) as INT) as _dongle_id,cast('calling' as nvarchar(128)) as _endpoint_contact_column,_calling_type as _endpoint_contact_type,_calling as _endpoint_contact_number,_calling_name as _endpoint_contact_name,isnull(_calling_address,'') as _endpoint_contact_address,isnull(_calling_department,'') as _endpoint_contact_department,isnull(ltrim(rtrim(_calling_company)),'') as _endpoint_contact_company 
	from [load].[office_team_statistics_call] c with(index(StampIdx)) join (  select concat('_',dongleid) as dongle_id,
				case when dc.LoadDataFrom is not null then dc.LoadDataFrom
					 when dc.InquiriesIncreased = 1 then dc.LastLicDate
					 when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,0,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_agent_event' and Enabled = 1 and WatermarkValue <> '' )
				end as stamp from [VIEW].[DongleConfig] dc where enabled = 1 ) as s on c._dongle_id = s.dongle_id	
		where convert(date,c._created) >= s.stamp	
	union all
	select convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(c._dongle_id,2,10) as INT),'_','called','_',ltrim(rtrim(_called_type)),'_',ltrim(rtrim(_called)),'_',ltrim(rtrim(_called_name)),'_',ltrim(rtrim(_called_address)),'_',ltrim(rtrim(_called_department)),'_',ltrim(rtrim(_called_company)))),2),cast(substring(c._dongle_id,2,10) as INT) as _dongle_id,cast('called' as nvarchar(128)),_called_type,_called,_called_name,isnull(_called_address,''),isnull(_called_department,''),isnull(ltrim(rtrim(_called_company)),'') 
	from [load].[office_team_statistics_call] c with(index(StampIdx)) join (  select concat('_',dongleid) as dongle_id,
				case when dc.LoadDataFrom is not null then dc.LoadDataFrom
					 when dc.InquiriesIncreased = 1 then dc.LastLicDate
					 when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,0,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_agent_event' and Enabled = 1 and WatermarkValue <> '' )
				end as stamp from [VIEW].[DongleConfig] dc where enabled = 1 ) as s on c._dongle_id = s.dongle_id	
		where convert(date,c._created) >= s.stamp	
	union all
	select convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(c._dongle_id,2,10) as INT),'_','transferred','_',ltrim(rtrim(_transferred_type)),'_',ltrim(rtrim(_transferred)),'_',ltrim(rtrim(_transferred_name)),'_',ltrim(rtrim(_transferred_address)),'_',ltrim(rtrim(_transferred_department)),'_',ltrim(rtrim(_transferred_company)))),2),cast(substring(c._dongle_id,2,10) as INT) as _dongle_id,cast('transferred' as nvarchar(128)),_transferred_type,_transferred,_transferred_name,isnull(_transferred_address,''),isnull(_transferred_department,''),isnull(ltrim(rtrim(_transferred_company)),'') 
	from [load].[office_team_statistics_call] c with(index(StampIdx)) join (  select concat('_',dongleid) as dongle_id,
				case when dc.LoadDataFrom is not null then dc.LoadDataFrom
					 when dc.InquiriesIncreased = 1 then dc.LastLicDate
					 when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,0,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_agent_event' and Enabled = 1 and WatermarkValue <> '' )
				end as stamp from [VIEW].[DongleConfig] dc where enabled = 1 ) as s on c._dongle_id = s.dongle_id	
		where convert(date,c._created) >= s.stamp		
	union all
	select convert(nvarchar(100),hashbytes('MD5',concat(ae._dongle_id ,'_','transfer','_',ae._transfer_type,'_',ae._transfer_contact_endpoint,'_',ae._transfer_name,'_',ae._transfer_address,'_',ae._transfer_department,'_',ltrim(rtrim(ae._transfer_company)))),2), cast(ae._dongle_id as INT) as _dongle_id,cast('transfer' as nvarchar(128)),ae._transfer_type,ae._transfer_contact_endpoint,ae._transfer_name,isnull(ae._transfer_address,''),isnull(ae._transfer_department,''),isnull(ltrim(rtrim(ae._transfer_company)),'')
	from [TMP].[agent_events_trans] ae where #row = 1
	union all
	select convert(nvarchar(100),hashbytes('MD5',concat(_dongle_id,'_','transfer','_','','_','','_','','_','','_','','_','')),2), _dongle_id, 'transfer', '','','','','','' from [V20232].[dim_dongle]
	union all
	select convert(nvarchar(100),hashbytes('MD5',concat(_dongle_id,'_','called','_','','_','','_','','_','','_','','_','')),2), _dongle_id, 'transfer', '','','','','','' from [V20232].[dim_dongle]
	union all
	select convert(nvarchar(100),hashbytes('MD5',concat(_dongle_id,'_','calling','_','','_','','_','','_','','_','','_','')),2), _dongle_id, 'transfer', '','','','','','' from [V20232].[dim_dongle]
	union all
	select convert(nvarchar(100),hashbytes('MD5',concat(_dongle_id,'_','transferred','_','','_','','_','','_','','_','','_','')),2), _dongle_id, 'transfer', '','','','','','' from [V20232].[dim_dongle]
	union all
	select convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_','calling','_',ltrim(rtrim(_calling_type)),'_',ltrim(rtrim(_calling)),'_',ltrim(rtrim(_calling_name)),'_',ltrim(rtrim(_calling_address)),'_',ltrim(rtrim(_calling_department)),'_',ltrim(rtrim(_calling_company)))),2) as _endpoint_contact_unique_id,cast(substring(qc._dongle_id,2,10) as INT) as _dongle_id,cast('calling' as nvarchar(128)) as _endpoint_contact_column,_calling_type as _endpoint_contact_type,_calling as _endpoint_contact_number,_calling_name as _endpoint_contact_name,isnull(_calling_address,'') as _endpoint_contact_address,isnull(_calling_department,'') as _endpoint_contact_department,isnull(ltrim(rtrim(_calling_company)),'') as _endpoint_contact_company 
	from [load].[office_team_statistics_queue_call] qc join (  select concat('_',dongleid) as dongle_id,
				case when dc.LoadDataFrom is not null then dc.LoadDataFrom
					 when dc.InquiriesIncreased = 1 then dc.LastLicDate
					 when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,0,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_agent_event' and Enabled = 1 and WatermarkValue <> '' )
				end as stamp from [VIEW].[DongleConfig] dc where enabled = 1 ) as s on qc._dongle_id = s.dongle_id	
		where convert(date,qc._created) >= s.stamp			
	union all
	select convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_','called','_',ltrim(rtrim(_called_type)),'_',ltrim(rtrim(_called)),'_',ltrim(rtrim(_called_name)),'_',ltrim(rtrim(_called_address)),'_',ltrim(rtrim(_called_department)),'_',ltrim(rtrim(_called_company)))),2),cast(substring(qc._dongle_id,2,10) as INT) as _dongle_id,cast('called' as nvarchar(128)),_called_type,_called,_called_name,isnull(_called_address,''),isnull(_called_department,''),isnull(ltrim(rtrim(_called_company)),'') 
	from [load].[office_team_statistics_queue_call] qc join (  select concat('_',dongleid) as dongle_id,
				case when dc.LoadDataFrom is not null then dc.LoadDataFrom
					 when dc.InquiriesIncreased = 1 then dc.LastLicDate
					 when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,0,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_agent_event' and Enabled = 1 and WatermarkValue <> '' )
				end as stamp from [VIEW].[DongleConfig] dc where enabled = 1 ) as s on qc._dongle_id = s.dongle_id	
		where convert(date,qc._created) >= s.stamp		
	union all
	select convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_','transferred','_',ltrim(rtrim(_transferred_type)),'_',ltrim(rtrim(_transferred)),'_',ltrim(rtrim(_transferred_name)),'_',ltrim(rtrim(_transferred_address)),'_',ltrim(rtrim(_transferred_department)),'_',ltrim(rtrim(_transferred_company)))),2),cast(substring(qc._dongle_id,2,10) as INT) as _dongle_id,cast('transferred' as nvarchar(128)),_transferred_type,_transferred,_transferred_name,isnull(_transferred_address,''),isnull(_transferred_department,''),isnull(ltrim(rtrim(_transferred_company)),'') 
	from [load].[office_team_statistics_queue_call] qc join (  select concat('_',dongleid) as dongle_id,
				case when dc.LoadDataFrom is not null then dc.LoadDataFrom
					 when dc.InquiriesIncreased = 1 then dc.LastLicDate
					 when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,0,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_agent_event' and Enabled = 1 and WatermarkValue <> '' )
				end as stamp from [VIEW].[DongleConfig] dc where enabled = 1 ) as s on qc._dongle_id = s.dongle_id	
		where convert(date,qc._created) >= s.stamp	
	
	truncate table [TMP].[queue_call_agent]
	insert into [TMP].[queue_call_agent]
	select
	convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',[_agent_address_name],'_',[_agent_company_name],'_',[_agent_department_name],'_',[_agent_name])),2) as [_queue_call_agent_org_unique_id],
	--convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',[_agent_id],'_',[_agent_name])),2) as [_queue_call_agent_org_unique_id],
	cast(substring(qc._dongle_id,2,10) as INT) as [_dongle_id],
	[_agent_address_name],
	[_agent_address_id],
	[_agent_company_name],
	[_agent_company_id],
	[_agent_department_name],
	[_agent_department_id],
	[_agent_name],
    [_agent_id],
	[_event_time] as [_max_event_start]
	from [load].[office_team_statistics_queue_call] qc join (  select concat('_',dongleid) as dongle_id,
					case when dc.LoadDataFrom is not null then dc.LoadDataFrom
						 when dc.InquiriesIncreased = 1 then dc.LastLicDate
						 when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,0,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_agent_event' and Enabled = 1 and WatermarkValue <> '' )
					end as stamp from [VIEW].[DongleConfig] dc where enabled = 1 ) as s on qc._dongle_id = s.dongle_id	
			where convert(date,qc._created) >= s.stamp



 
end
GO

