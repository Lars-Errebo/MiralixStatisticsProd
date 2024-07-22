





CREATE PROCEDURE [V20232].[fact_voicemail]
	-- Add the parameters for the stored procedure here
	@Dongle int, @mth int	
AS
BEGIN

with stamp as (
   select concat('_',@dongle) as dongle_id, datefromparts(left(@mth,4),right(@mth,2),1) as stamp, eomonth(datefromparts(left(@mth,4),right(@mth,2),1)) as LoadDataTo		 
), result as (
select
cast(substring(vm._dongle_id,2,10) as INT) as _dongle_id,
vm.id,
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(vm._dongle_id,2,10) as INT),'_',vm.[id],'_',[_action],'_',[_heard_by_name],'_',[_user_account_name],'_',[_voicemail_account_name])),2) as _voicemail_unique_id,
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(vm._dongle_id,2,10) as INT),'_','called','_',ltrim(rtrim(_called_type)),'_',ltrim(rtrim(_called)),'_',ltrim(rtrim(_called_name)),'_',ltrim(rtrim(_called_address)),'_',ltrim(rtrim(_called_department)),'_',ltrim(rtrim(_called_company)))),2) as [_endpoint_contact_called_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(vm._dongle_id,2,10) as INT),'_','calling','_',ltrim(rtrim(_calling_type)),'_',ltrim(rtrim(_calling)),'_',ltrim(rtrim(_calling_name)),'_',ltrim(rtrim(_calling_address)),'_',ltrim(rtrim(_calling_department)),'_',ltrim(rtrim(_calling_company)))),2) as [_endpoint_contact_calling_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(vm._dongle_id,2,10) as INT),'_','transferred','_',ltrim(rtrim(_transferred_type)),'_',ltrim(rtrim(_transferred)),'_',ltrim(rtrim(_transferred_name)),'_',ltrim(rtrim(_transferred_address)),'_',ltrim(rtrim(_transferred_department)),'_',ltrim(rtrim(_transferred_company)))),2) as [_endpoint_contact_transferred_unique_id],
cast(format(vm._event_time,'yyyyMMdd') as int) as _date_id,
cast(format(vm._event_time,'HHmmss') as int) as _time_id,
case when _action = 'CallerHangup' then 1 else 0 end as [_voicemail_caller_hangup],
case when _action = 'LeftMessage' then 1 else 0 end as [_voicemail_left_message],
vm.id as [_voicemail_table_id]
from [load].[office_team_statistics_voicemail] vm
join [load].[office_team_statistics_call] c on c._dongle_id = vm._dongle_id and c._call_id = vm._call_id
join stamp on stamp.dongle_id = vm._dongle_id 
--left join [V2].[dim_call] dc on dc._endpoint_contact_column = 'called' and dc._endpoint_contact_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(vm._dongle_id,2,10) as INT),'_','called','_',trim(_called_type),'_',trim(_called),'_',trim(_called_name),'_',trim(_called_address),'_',trim(_called_department),'_',trim(_called_company))),2)
--left join [V2].[dim_call] dcc on dcc._endpoint_contact_column = 'calling' and dcc._endpoint_contact_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(vm._dongle_id,2,10) as INT),'_','calling','_',trim(_calling_type),'_',trim(_calling),'_',trim(_calling_name),'_',trim(_calling_address),'_',trim(_calling_department),'_',trim(_calling_company))),2) 
--left join [V2].[dim_call] dct on dct._endpoint_contact_column = 'transferred' and dct._endpoint_contact_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(vm._dongle_id,2,10) as INT),'_','transferred','_',trim(_transferred_type),'_',trim(_transferred),'_',trim(_transferred_name),'_',trim(_transferred_address),'_',trim(_transferred_department),'_',trim(_transferred_company))),2)
where convert(date,vm._created) >= stamp.stamp and convert(date,vm._created) <= stamp.LoadDataTo


)
select * from result 

END
GO

