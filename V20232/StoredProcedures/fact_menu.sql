




CREATE PROCEDURE [V20232].[fact_menu]
	-- Add the parameters for the stored procedure here
	@Dongle int, @mth int	
AS
BEGIN

with stamp as (
   select concat('_',@dongle) as dongle_id, datefromparts(left(@mth,4),right(@mth,2),1) as stamp, eomonth(datefromparts(left(@mth,4),right(@mth,2),1)) as LoadDataTo	
), result as (
select
cast(substring(m._dongle_id,2,10) as INT) as _dongle_id,
m.id,
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(m._dongle_id,2,10) as INT),'_',m.[_menu_id],'_',m.[_menu_name],'_',m.[_action])),2) as  [_menu_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(m._dongle_id,2,10) as INT),'_','called','_',ltrim(rtrim(_called_type)),'_',ltrim(rtrim(_called)),'_',ltrim(rtrim(_called_name)),'_',ltrim(rtrim(_called_address)),'_',ltrim(rtrim(_called_department)),'_',ltrim(rtrim(_called_company)))),2) as [_endpoint_contact_called_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(m._dongle_id,2,10) as INT),'_','calling','_',ltrim(rtrim(_calling_type)),'_',ltrim(rtrim(_calling)),'_',ltrim(rtrim(_calling_name)),'_',ltrim(rtrim(_calling_address)),'_',ltrim(rtrim(_calling_department)),'_',ltrim(rtrim(_calling_company)))),2) as [_endpoint_contact_calling_unique_id],
convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(m._dongle_id,2,10) as INT),'_','transferred','_',ltrim(rtrim(_transferred_type)),'_',ltrim(rtrim(_transferred)),'_',ltrim(rtrim(_transferred_name)),'_',ltrim(rtrim(_transferred_address)),'_',ltrim(rtrim(_transferred_department)),'_',ltrim(rtrim(_transferred_company)))),2) as [_endpoint_contact_transferred_unique_id],
cast(format(m._event_time,'yyyyMMdd') as int) as _date_id,
cast(format(m._event_time,'HHmmss') as int) as _time_id,
datediff(ss,m._event_time,m._left_menu) as [_menu_duration],
m._menu_id as [_menu_table_id],
case when m._action = 'CallerHangup' then 1 else 0 end as [_menu_action_caller_hangup],
case when m._action = 'ServiceHangup' then 1 else 0 end as [_menu_action_system_hangup]
from [load].[office_team_statistics_menu] m
left join [load].[office_team_statistics_call] c on c._dongle_id = m._dongle_id and c._call_id = m._call_id
join stamp on stamp.dongle_id = m._dongle_id
join [V20232].[dim_menu] dm on dm._menu_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(m._dongle_id,2,10) as INT),'_',m.[_menu_id],'_',m.[_menu_name],'_',m.[_action])),2)
left join [V20232].[dim_call] dc on dc._endpoint_contact_column = 'called' and dc._endpoint_contact_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(m._dongle_id,2,10) as INT),'_','called','_',ltrim(rtrim(_called_type)),'_',ltrim(rtrim(_called)),'_',ltrim(rtrim(_called_name)),'_',ltrim(rtrim(_called_address)),'_',ltrim(rtrim(_called_department)),'_',ltrim(rtrim(_called_company)))),2)
left join [V20232].[dim_call] dcc on dcc._endpoint_contact_column = 'calling' and dcc._endpoint_contact_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(m._dongle_id,2,10) as INT),'_','calling','_',ltrim(rtrim(_calling_type)),'_',ltrim(rtrim(_calling)),'_',ltrim(rtrim(_calling_name)),'_',ltrim(rtrim(_calling_address)),'_',ltrim(rtrim(_calling_department)),'_',ltrim(rtrim(_calling_company)))),2) 
left join [V20232].[dim_call] dct on dct._endpoint_contact_column = 'transferred' and dct._endpoint_contact_unique_id = convert(nvarchar(100),hashbytes('MD5',concat(cast(substring(m._dongle_id,2,10) as INT),'_','transferred','_',ltrim(rtrim(_transferred_type)),'_',ltrim(rtrim(_transferred)),'_',ltrim(rtrim(_transferred_name)),'_',ltrim(rtrim(_transferred_address)),'_',ltrim(rtrim(_transferred_department)),'_',ltrim(rtrim(_transferred_company)))),2)
where m._media_type = 'Audio'
and convert(date,m._created) >= stamp.stamp and convert(date,m._created) <= stamp.LoadDataTo

)
select distinct * from result

END
GO

