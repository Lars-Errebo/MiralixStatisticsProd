




CREATE PROCEDURE [V20232].[fact_transfer]
	-- Add the parameters for the stored procedure here
	@Dongle int, @mth int	
AS
BEGIN

with stamp as (
    select concat('_',@dongle) as dongle_id, datefromparts(left(@mth,4),right(@mth,2),1) as stamp, eomonth(datefromparts(left(@mth,4),right(@mth,2),1)) as LoadDataTo	
), result as (
select
cast(substring(t._dongle_id,2,10) as INT) as _dongle_id,
t.id,
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(t._dongle_id,2,10) as INT),t.[_transfer_id],'_',t.[_transfer_name],'_',t.[_transfer_type],'_',t.[_action],'_',t.[_transfer_destination])),2) as [_transfer_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(t._dongle_id,2,10) as INT),'_','called','_',ltrim(rtrim(_called_type)),'_',ltrim(rtrim(_called)),'_',ltrim(rtrim(_called_name)),'_',ltrim(rtrim(_called_address)),'_',ltrim(rtrim(_called_department)),'_',ltrim(rtrim(_called_company)))),2) as [_endpoint_contact_called_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(t._dongle_id,2,10) as INT),'_','calling','_',ltrim(rtrim(_calling_type)),'_',ltrim(rtrim(_calling)),'_',ltrim(rtrim(_calling_name)),'_',ltrim(rtrim(_calling_address)),'_',ltrim(rtrim(_calling_department)),'_',ltrim(rtrim(_calling_company)))),2) as [_endpoint_contact_calling_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(t._dongle_id,2,10) as INT),'_','transferred','_',ltrim(rtrim(_transferred_type)),'_',ltrim(rtrim(_transferred)),'_',ltrim(rtrim(_transferred_name)),'_',ltrim(rtrim(_transferred_address)),'_',ltrim(rtrim(_transferred_department)),'_',ltrim(rtrim(_transferred_company)))),2) as [_endpoint_contact_transferred_unique_id],
cast(format(t._event_time,'yyyyMMdd') as int) as _date_id,
cast(format(t._event_time,'HHmmss') as int) as _time_id,
datediff(ss,_event_time,_left_transfer) as [_transfer_duration],
case when _action = 'Success' then 1 else 0 end as [_transfer_action_success],
case when _action = 'HangUp' then 1 else 0 end as[_transfer_action_hangup],
case when _action = 'FailureCallComponent' then 1 else 0 end as[_transfer_failure_call_component],
t.[_transfer_id] as [_transfer_table_id]
from [load].[office_team_statistics_transfer] t
left join [load].[office_team_statistics_call] c on c._dongle_id = t._dongle_id and c._call_id = t._call_id
join stamp on stamp.dongle_id = t._dongle_id 
join [V20232].[dim_transfer] trf on trf._transfer_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(t._dongle_id,2,10) as INT),t.[_transfer_id],'_',t.[_transfer_name],'_',t.[_transfer_type],'_',t.[_action],'_',t.[_transfer_destination])),2)
left join [V20232].[dim_call] dc on dc._endpoint_contact_column = 'called' and dc._endpoint_contact_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(t._dongle_id,2,10) as INT),'_','called','_',ltrim(rtrim(_called_type)),'_',ltrim(rtrim(_called)),'_',ltrim(rtrim(_called_name)),'_',ltrim(rtrim(_called_address)),'_',ltrim(rtrim(_called_department)),'_',ltrim(rtrim(_called_company)))),2)
left join [V20232].[dim_call] dcc on dcc._endpoint_contact_column = 'calling' and dcc._endpoint_contact_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(t._dongle_id,2,10) as INT),'_','calling','_',ltrim(rtrim(_calling_type)),'_',ltrim(rtrim(_calling)),'_',ltrim(rtrim(_calling_name)),'_',ltrim(rtrim(_calling_address)),'_',ltrim(rtrim(_calling_department)),'_',ltrim(rtrim(_calling_company)))),2) 
left join [V20232].[dim_call] dct on dct._endpoint_contact_column = 'transferred' and dct._endpoint_contact_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(t._dongle_id,2,10) as INT),'_','transferred','_',ltrim(rtrim(_transferred_type)),'_',ltrim(rtrim(_transferred)),'_',ltrim(rtrim(_transferred_name)),'_',ltrim(rtrim(_transferred_address)),'_',ltrim(rtrim(_transferred_department)),'_',ltrim(rtrim(_transferred_company)))),2)
and convert(date,t._created) >= stamp.stamp and convert(date,t._created) <= stamp.LoadDataTo

)
select * from result

END
GO

