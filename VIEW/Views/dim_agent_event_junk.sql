

CREATE view [VIEW].[dim_agent_event_junk] as

with result as (
select 
[_agent_event_junk_unique_id],
[_dongle_id],
[_agent_skill],
[_agent_client],
[_event_type],
[_event_type_group],
[_event_type_call_answered_status],
[_pause_reason],
[_note]
from [TMP].[agent_events_junk]
group by [_agent_event_junk_unique_id],
[_dongle_id],
[_agent_skill],
[_agent_client],
[_event_type],
[_event_type_group],
[_event_type_call_answered_status],
[_pause_reason],
[_note]
)

select 
[_agent_event_junk_unique_id],
[_dongle_id],
[_agent_skill] as [_agent_skill],
[_agent_client],
t.trans_1 as [_event_type],
isnull([_event_type_group],'No group') as [_event_type_group],
[_event_type_call_answered_status],
t2.trans_1 as [_pause_reason],
isnull([_note],'No note') as [_note]
from result
left join [V2].[fix_translations] t on t.columnlookup = _event_type and t.columnname = '_event_type' and t.reference = 'dim_agent_event_junk'
left join [V2].[fix_translations] t2 on t2.columnlookup = _pause_reason and t2.columnname = '_pause_reason' and t2.reference = 'dim_agent_event_junk'
GO

