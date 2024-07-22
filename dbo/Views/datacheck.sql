
CREATE view [dbo].[datacheck] as

select 'ae' as fact,_dongle_id,id from [LOAD].[office_team_statistics_agent_event] where convert(date,_created) >= DATEADD(month,-1,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) and convert(date,_created) <= EOMONTH(GETDATE())

union all

select 'qn' as fact,_dongle_id,id from [LOAD].[office_team_statistics_queue_call] where convert(date,_created) >= DATEADD(month,-1,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) and convert(date,_created) <= EOMONTH(GETDATE())
GO

