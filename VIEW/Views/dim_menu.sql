

CREATE view [VIEW].[dim_menu] as

with stampdate as (
   select concat('_',dongleid) as dongle_id,
  isnull(case
         when dc.LoadDataFrom is not null then dc.LoadDataFrom
         when dc.InquiriesIncreased = 1 then dc.LastLicDate
	     when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,-1,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_menu' and Enabled = 1 and WatermarkValue <> '' )
  end,getdate()) as stamp from [VIEW].[DongleConfig] dc where enabled = 1  
), result as (
select
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(m._dongle_id,2,10) as INT),'_',[_menu_id],'_',[_menu_name],'_',[_action])),2) as [_menu_unique_id], m.[_dongle_id], [_menu_id], [_menu_name], [_action] 
from [load].[office_team_statistics_menu] m
join stampdate s on m._dongle_id = s.dongle_id
where convert(date,m._created) >= s.stamp )
, result2 as (
select ROW_NUMBER() OVER(PARTITION BY _menu_unique_id ORDER BY _menu_id) as #row,* from result )
select [_menu_unique_id],cast(substring(_dongle_id,2,10) as INT) as [_dongle_id],[_menu_id],[_menu_name],t2.[trans_1] as _menu_action 
from result2 
left join [V2].[fix_translations] t2 on t2.columnlookup = _action and t2.columnname = '_menu_action' and t2.reference = 'dim_menu'
where #row = 1
GO

