





CREATE view [VIEW].[dim_queue_agent_name] as

with result as (
   select ROW_NUMBER() OVER(PARTITION BY _queue_call_agent_org_unique_id ORDER BY _max_event_start DESC) as #row,* from [TMP].[queue_call_agent]
)
select 
[_queue_call_agent_org_unique_id],
[_dongle_id],
isnull([_agent_address_name],'No address') as [_agent_address_name],
[_agent_address_id],
isnull([_agent_company_name],'No company') as [_agent_company_name],
[_agent_company_id],
isnull([_agent_department_name],'No department') as [_agent_department_name],
[_agent_department_id],
isnull([_agent_name],'No agent') as [_agent_name],
[_agent_id],
[_max_event_start]
from result where #row = 1
GO

