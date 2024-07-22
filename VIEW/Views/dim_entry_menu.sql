




CREATE view [VIEW].[dim_entry_menu] as

with stampdate as (
  select concat('_',dongleid) as dongle_id,
  isnull(case 
         when dc.LoadDataFrom is not null then dc.LoadDataFrom
         when dc.InquiriesIncreased = 1 then dc.LastLicDate
	     when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,-1,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_entry_menu' and Enabled = 1 and WatermarkValue <> '' )
  end,getdate()) as stamp from [VIEW].[DongleConfig] dc where enabled = 1  
), result as (
select convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(em._dongle_id,2,10) as INT),'_',[_entry_menu_id],'_',_entry,'_',[_entry_menu_name],'_',[_action])),2) as [_entry_menu_unique_id],
em.[_dongle_id],
[_entry_menu_id],
[_entry], 
[_entry_menu_name],
[_action] from [load].[office_team_statistics_entry_menu] em
join stampdate s on em._dongle_id = s.dongle_id
where convert(date,em._created) >= s.stamp ),
result2 as (
select ROW_NUMBER() OVER(PARTITION BY _entry_menu_unique_id ORDER BY _entry_menu_id) as #row,* from result )
select [_entry_menu_unique_id],[_entry_menu_id] as _menu_id,cast(substring(_dongle_id,2,10) as INT) as [_dongle_id],_entry,[_entry_menu_name],[_action] as _entry_menu_action from result2 where #row = 1
GO

