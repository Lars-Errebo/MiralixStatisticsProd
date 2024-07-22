



CREATE view [VIEW].[dim_agent_event_queue_name] as


select 
distinct
[_agent_event_queue_name_unique_id],
[_dongle_id],
[_queue_id],
isnull([_queue_name],'No name') as [_queue_name],
isnull([_tags],'No tag') as [_tags]
from [TMP].[agent_events_queue]
GO

