





CREATE view [VIEW].[dim_sources] as


select s.name as [schema],v.name as [table] from sys.tables v
join sys.schemas s on s.schema_id = v.schema_id
where s.name = 'V20232' and v.name like 'dim%' 

union all

select s.name as [schema],v.name as [table] from sys.tables v
join sys.schemas s on s.schema_id = v.schema_id
where s.name = 'V2' and v.name like 'fix%'
GO

