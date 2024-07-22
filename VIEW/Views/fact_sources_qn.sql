


CREATE view [VIEW].[fact_sources_qn] as

with facts as (
select s.SPECIFIC_SCHEMA as [schema],SPECIFIC_NAME as [table] from INFORMATION_SCHEMA.ROUTINES s where ROUTINE_TYPE = 'PROCEDURE' and s.SPECIFIC_SCHEMA = 'V20232'
), dongles as (
    select Dongleid as Dongle_Id from [VIEW].[DongleConfig] where Enabled = 1
), yearmth as (    
   select distinct DongleID, LEFT(_date_id,6) as yearmth from [VIEW].[DongleConfig]
 --  join [V20232].[dim_date] d on d._date >= '2023-10-01' and d._date <= '2023-12-31' 
   join [V20232].[dim_date] d on d._date >= isnull(LoadDataFrom,dateadd(day,-1,GETDATE())) and d._date <= isnull(LoadDataTo,GETDATE())  
), result as (
   select facts.*,d.*,ym.yearmth from facts cross join dongles d join yearmth ym on ym.DongleID = d.Dongle_ID
)
select result.* from result 
--join [dbo].[datatestrun] dr on dr._dongle = result.Dongle_Id and result.yearmth = dr._yrmth
where result.[table] = 'fact_queue_name' -- and Dongle_Id = 2352
GO

