



CREATE view [VIEW].[dim_queue_call_queue_name] as

with stampdate as (
   select concat('_',dongleid) as dongle_id,
    isnull(case 
	       when dc.LoadDataFrom is not null then dc.LoadDataFrom	       
		   when dc.InquiriesIncreased = 1 then dc.LastLicDate
	       when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,-1,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_queue_call' and Enabled = 1 and WatermarkValue <> '' )
	end,getdate()) as stamp from [VIEW].[DongleConfig] dc where enabled = 1   
), result as (
select
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(qc._dongle_id,2,10) as INT),'_',[_queue_id],'_',[_queue_name],'_',isnull([_tags],''))),2) as [_queue_call_queue_name_unique_id],
cast(substring(qc._dongle_id,2,10) as INT) as [_dongle_id],
[_queue_id],
[_queue_name],
isnull([_tags],'No tag') as _tags
from [load].[office_team_statistics_queue_call] qc
join stampdate s on qc._dongle_id = s.dongle_id
where convert(date,qc._stamp) >= s.stamp
), result1 as (
select ROW_NUMBER() OVER(PARTITION BY _queue_call_queue_name_unique_id ORDER BY _queue_call_queue_name_unique_id ) as #row,* from result
), result2 as (
select [_queue_call_queue_name_unique_id],[_dongle_id],[_queue_id],[_queue_name],_tags from result1 where #row = 1
group by
[_queue_call_queue_name_unique_id],
[_dongle_id],
[_queue_id],
[_queue_name],
[_tags])

select 
[_queue_call_queue_name_unique_id],
[_dongle_id],
[_queue_id],
[_queue_name],
[_tags]
from result2 
--where _dongle_id = 1710
GO

