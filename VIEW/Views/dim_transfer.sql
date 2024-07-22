




CREATE view [VIEW].[dim_transfer] as

with stampdate as (
   select concat('_',dongleid) as dongle_id,
	isnull(case
	       when dc.LoadDataFrom is not null then dc.LoadDataFrom	       
		   when dc.InquiriesIncreased = 1 then dc.LastLicDate
	       when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,-1,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_transfer' and Enabled = 1 and WatermarkValue <> '' )
	end,getdate()) as stamp from [VIEW].[DongleConfig] dc where enabled = 1  
), result as (
select 
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(t._dongle_id,2,10) as INT),
[_transfer_id],'_',
[_transfer_name],'_',
[_transfer_type],'_',
[_action],'_',
[_transfer_destination])),2) as [_transfer_unique_id],
cast(substring(t._dongle_id,2,10) as INT) as [_dongle_id],
[_transfer_id],
[_transfer_name],
[_transfer_type],
[_action] as _transfer_action,
[_transfer_destination]
from [load].[office_team_statistics_transfer] t
join stampdate s on t._dongle_id = s.dongle_id
where convert(date,t._created) >= s.stamp 
)
--, result2 as (select ROW_NUMBER() OVER(PARTITION BY _transfer_unique_id ORDER BY _transfer_id) as #row,* from result )

select 
distinct
[_transfer_unique_id],
[_dongle_id],
[_transfer_id],
[_transfer_name],
[_transfer_type],
[_transfer_action],
[_transfer_destination]
from result
--where #row = 1
GO

