


CREATE PROCEDURE [dbo].[ReindexAllLoadTables]
AS
BEGIN
    
    SET NOCOUNT ON

	DECLARE @db      NVARCHAR(100) = 'MiralixStatisticsProd'
	DECLARE @schema  NVARCHAR(20) 
    DECLARE @table   NVARCHAR(200)
	DECLARE @tid     INT
    DECLARE @index   NVARCHAR(200) 
	DECLARE @iid     INT
	DECLARE @indexid NVARCHAR(500)
	DECLARE @fragpct DECIMAL(16,2)
	DECLARE @tmp     TABLE ( id nvarchar(500),s nvarchar(20),t nvarchar(200),tid int,i nvarchar(200),iid int )	
	DECLARE @sql     NVARCHAR(max)
	
	INSERT INTO @tmp SELECT concat(s.name,'-',t.name,'-',b.name) as Id,s.name,t.name,t.object_id,b.name,b.index_id
								FROM sys.indexes AS b 
								JOIN sys.tables AS t ON t.object_id = b.object_id
								JOIN sys.schemas AS s on s.schema_id = t.schema_id
								WHERE s.name = 'load'

	DECLARE indexcursor CURSOR FOR SELECT id FROM @tmp
	OPEN indexcursor  
    FETCH NEXT FROM indexcursor INTO @indexid  
    WHILE @@FETCH_STATUS = 0  
    BEGIN 
	     SET @schema   = ( SELECT s   FROM @tmp WHERE id = @indexid )
		 SET @table    = ( SELECT t   FROM @tmp WHERE id = @indexid )
		 SET @tid      = ( SELECT tid FROM @tmp WHERE id = @indexid )
		 SET @index    = ( SELECT i   FROM @tmp WHERE id = @indexid )
		 SET @iid      = ( SELECT iid FROM @tmp WHERE id = @indexid )		 
	
         SET @fragpct = (SELECT TOP 1 avg_fragmentation_in_percent FROM sys.dm_db_index_physical_stats ( DB_ID(@db), OBJECT_ID(@schema+'.'+@table), NULL, NULL, NULL)  WHERE object_id = @tid AND index_id = @iid ORDER BY avg_fragmentation_in_percent DESC)

		-- select @indexid, @fragpct

		 IF @fragpct > 30		 
		 BEGIN
		      SET @sql = 'ALTER INDEX '+@index+' ON '+@schema+'.'+@table+' REBUILD'
			  
			  EXECUTE sp_executesql @sql 

			  Print @sql
		 END
	     FETCH NEXT FROM indexcursor INTO @indexid
	END

END
GO

