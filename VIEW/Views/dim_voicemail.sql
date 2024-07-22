




CREATE view [VIEW].[dim_voicemail] as

with stampdate as (
  select concat('_',dongleid) as dongle_id,
	isnull(case
	       when dc.LoadDataFrom is not null then dc.LoadDataFrom	       
		   when dc.InquiriesIncreased = 1 then dc.LastLicDate
	       when dc.InquiriesIncreased = 0 then (select top 1 dateadd(day,-1,cast(WatermarkValue as date)) from [VIEW].[LoadConfig] where SRC_schema = dc.dongleid and SRC_tab = 'office_team_statistics_voicemail' and Enabled = 1 and WatermarkValue <> '' )
	end,getdate()) as stamp from [VIEW].[DongleConfig] dc where enabled = 1 
), result as (
select 
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(v._dongle_id,2,10) as INT),'_',[id],'_',[_action],'_',[_heard_by_name],'_',[_user_account_name],'_',[_voicemail_account_name])),2) as [_voicemail_unique_id],
cast(substring(v._dongle_id,2,10) as INT) as[_dongle_id],
id as [_voicemail_id], /* ??? */
[_action],
[_heard_by_name],
[_user_account_name],
[_voicemail_account_name],
[_voicemail_account_id]
from [load].[office_team_statistics_voicemail] v
join stampdate s on v._dongle_id = s.dongle_id
where convert(date,v._created) >= s.stamp)
, result2 as (
select ROW_NUMBER() OVER(PARTITION BY _voicemail_unique_id ORDER BY _voicemail_id) as #row,* from result )
select 
[_voicemail_unique_id],
[_dongle_id],
[_voicemail_id],
[_action],
[_heard_by_name],
[_user_account_name],
[_voicemail_account_name],
[_voicemail_account_id]
from result2 where #row = 1
GO

