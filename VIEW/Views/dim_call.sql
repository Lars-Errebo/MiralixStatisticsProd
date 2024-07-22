
CREATE view [VIEW].[dim_call] as

with result as ( 
select row_number() over( partition by _endpoint_contact_unique_id order by _dongle_id) as #row,* from [TMP].[statistic_call] )

select [_endpoint_contact_unique_id], [_dongle_id], [_endpoint_contact_column], [_endpoint_contact_type], [_endpoint_contact_number],
case when _endpoint_contact_name is null then 'Unknown name' when _endpoint_contact_name = '' then 'Unknown name' else _endpoint_contact_name end as [_endpoint_contact_name],
Case when _endpoint_contact_address is null then 'Unknown address' when _endpoint_contact_address = '' then 'Unknown address' else _endpoint_contact_address end as _endpoint_contact_address,
Case when _endpoint_contact_department is null then 'Unknown department' when _endpoint_contact_department = '' then 'Unknown department' else _endpoint_contact_department end  as _endpoint_contact_department, 
case when _endpoint_contact_company is null then 'Unknown company' when _endpoint_contact_company = '' then 'Unknown company' else _endpoint_contact_company end as _endpoint_contact_company
from result 
where  #row = 1
GO

