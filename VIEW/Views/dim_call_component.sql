




CREATE view [VIEW].[dim_call_component] as

with idstampdate as (
  select concat('_',dongleid) as dongle_id,
  case when dc.LoadDataFrom is not null then dc.LoadDataFrom
       when dc.InquiriesIncreased = 1 then dc.LastLicDate
	   when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,-1,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_agent_event' and Enabled = 1 and WatermarkValue <> '' )
  end as stamp from [VIEW].[DongleConfig] dc where enabled = 1
), mstampdate as (
  select concat('_',dongleid) as dongle_id,
  case when dc.LoadDataFrom is not null then dc.LoadDataFrom
       when dc.InquiriesIncreased = 1 then dc.LastLicDate
	   when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,-1,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_menu' and Enabled = 1 and WatermarkValue <> '' )
  end as stamp from [VIEW].[DongleConfig] dc where enabled = 1  
), emstampdate as (
  select concat('_',dongleid) as dongle_id,
  case when dc.LoadDataFrom is not null then dc.LoadDataFrom
       when dc.InquiriesIncreased = 1 then dc.LastLicDate
	   when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,-1,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_entry_menu' and Enabled = 1 and WatermarkValue <> '' )
  end as stamp from [VIEW].[DongleConfig] dc where enabled = 1  
), scstampdate as (
  select concat('_',dongleid) as dongle_id,
  case when dc.LoadDataFrom is not null then dc.LoadDataFrom
       when dc.InquiriesIncreased = 1 then dc.LastLicDate
	   when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,-1,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_schedule' and Enabled = 1 and WatermarkValue <> '' )
  end as stamp from [VIEW].[DongleConfig] dc where enabled = 1   
), tstampdate as (
  select concat('_',dongleid) as dongle_id,
  case when dc.LoadDataFrom is not null then dc.LoadDataFrom
       when dc.InquiriesIncreased = 1 then dc.LastLicDate
	   when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,-1,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_transfer' and Enabled = 1 and WatermarkValue <> '' )
  end as stamp from [VIEW].[DongleConfig] dc where enabled = 1  
), qcstampdate as (
  select concat('_',dongleid) as dongle_id,
  case when dc.LoadDataFrom is not null then dc.LoadDataFrom  
       when dc.InquiriesIncreased = 1 then dc.LastLicDate
	   when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,-1,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_queue_call' and Enabled = 1 and WatermarkValue <> '' )
  end as stamp from [VIEW].[DongleConfig] dc where enabled = 1  
),
result as (

select convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(i._dongle_id,2,10) as INT),'_',_call_component_id,'_',_call_component_name,'_',_call_component_type)),2) as _call_component_unique_id,cast(substring(i._dongle_id,2,10) as INT) as _dongle_id,_call_component_id as _call_component, _call_component_name,_call_component_type
from [load].[office_team_statistics_identification] i join idstampdate s on i._dongle_id = s.dongle_id where convert(date,i._created) >= s.stamp	
group by i._dongle_id,_call_component_id,_call_component_name,_call_component_type

union all

select  convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(m._dongle_id,2,10) as INT),'_',_call_component_id,'_',_call_component_name,'_',_call_component_type)),2) as _call_component_unique_id,cast(substring(m._dongle_id,2,10) as INT) as _dongle_id,_call_component_id as _call_component, _call_component_name,_call_component_type
from [load].[office_team_statistics_menu] m join mstampdate s on m._dongle_id = s.dongle_id where convert(date,m._created) >= s.stamp	
group by m._dongle_id,_call_component_id,_call_component_name,_call_component_type

union all

select  convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(em._dongle_id,2,10) as INT),'_',_call_component_id,'_',_call_component_name,'_',_call_component_type)),2) as _call_component_unique_id,cast(substring(em._dongle_id,2,10) as INT) as _dongle_id,_call_component_id as _call_component, _call_component_name,_call_component_type
from [load].[office_team_statistics_entry_menu] em join emstampdate s on em._dongle_id = s.dongle_id where convert(date,em._created) >= s.stamp	
group by em._dongle_id,_call_component_id,_call_component_name,_call_component_type

union all

select  convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(sc._dongle_id,2,10) as INT),'_',_call_component_id,'_',_call_component_name,'_',_call_component_type)),2) as _call_component_unique_id,cast(substring(sc._dongle_id,2,10) as INT) as _dongle_id,_call_component_id as _call_component, _call_component_name,_call_component_type
from [load].[office_team_statistics_schedule] sc join scstampdate s on sc._dongle_id = s.dongle_id where sc._created >= s.stamp
group by sc._dongle_id,_call_component_id,_call_component_name,_call_component_type

union all

select  convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(t._dongle_id,2,10) as INT),'_',_call_component_id,'_',_call_component_name,'_',_call_component_type)),2) as _call_component_unique_id,cast(substring(t._dongle_id,2,10) as INT) as _dongle_id,_call_component_id as _call_component, _call_component_name,_call_component_type
from [load].[office_team_statistics_transfer] t join tstampdate s on t._dongle_id = s.dongle_id where convert(date,t._created) >= s.stamp
group by t._dongle_id,_call_component_id,_call_component_name,_call_component_type

union all 

select  convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',_call_component_id,'_',ltrim(rtrim(_call_component_name)),'_',ltrim(rtrim(_call_component_type)))),2) as _call_component_unique_id,cast(substring(qc._dongle_id,2,10) as INT) as _dongle_id,_call_component_id as _call_component, _call_component_name,_call_component_type
from [load].[office_team_statistics_queue_call]  qc join qcstampdate s on qc._dongle_id = s.dongle_id where convert(date,qc._created) >= s.stamp
group by qc._dongle_id,_call_component_id,_call_component_name,_call_component_type


), result2 as (
select ROW_NUMBER() OVER(PARTITION BY _call_component_unique_id ORDER BY _call_component) as #row,* from result )
select _call_component_unique_id,_dongle_id,_call_component,_call_component_name,_call_component_type from result2 where #row = 1

--and _call_component_unique_id = 'FB16A5EDBFF29510B0E0ABABF3D48737'
--and _dongle_id = 1710
--and _call_component = 28
--and _call_component_name = 'Send Notifikation STARK'
--1710_28_Send Notifikation STARK_ConditionalSwitch
GO

