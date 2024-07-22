




CREATE PROCEDURE [VIEW].[TruncateTMPTables]
 
AS
BEGIN
  SET NOCOUNT ON;

truncate table [TMP].[user_account]
truncate table [TMP].[agent_events_org]
truncate table [TMP].[agent_events_junk]
truncate table [TMP].[agent_events_queue]
truncate table [TMP].[agent_events_trans]
truncate table [TMP].[statistic_call]
truncate table [TMP].[queue_call_agent]


END
GO

