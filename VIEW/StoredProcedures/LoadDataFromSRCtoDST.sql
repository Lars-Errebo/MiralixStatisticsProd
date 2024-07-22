
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [VIEW].[LoadDataFromSRCtoDST] 
     @environment NVARCHAR(10)
	,@dstschema   NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dongle    NVARCHAR(10)
	DECLARE @table     NVARCHAR(50)
	DECLARE @srcschema NVARCHAR(50)
	DECLARE @database  NVARCHAR(50)
	DECLARE @sql       NVARCHAR(MAX)

	DECLARE dongle_cursor CURSOR
	FOR
	SELECT [Dongleid]
	FROM [VIEW].[DongleConfig]
	WHERE [Enabled] = 1
	    AND Environment = @environment
	ORDER BY DongleID

	OPEN dongle_cursor

	FETCH NEXT
	FROM dongle_cursor
	INTO @dongle

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SET @database = 'MiralixStatistics'
		SET @srcschema = CONCAT (
				'_'
				,@dongle
				)

		DECLARE table_cursor CURSOR
		FOR
		SELECT DISTINCT [TableName]
		FROM [VIEW].[TableConfig]

		OPEN table_cursor

		FETCH NEXT
		FROM table_cursor
		INTO @table

		WHILE @@FETCH_STATUS = 0
		BEGIN
		
	    	PRINT @dongle + ' ' + @table
			
		--  TRUNCATE TABLE [TMP].[agent_id_update]
			
			EXEC [VIEW].DeleteInsert @database
				,@srcschema
				,@dstschema
				,@table
				,@dongle

			SET @sql = 'UPDATE [VIEW].LoadConfig SET OldWatermarkValue = WatermarkValue,  MetaUpdatedTime = ''' + convert(varchar(25), getutcdate(), 120)   + ''', WatermarkValue = ( SELECT MAX(_stamp) FROM ' + @dstschema + '.' + @table + ' WHERE _dongle_id  = ''_' + @dongle   + ''') WHERE SRC_schema = ' + @dongle + ' AND SRC_tab = ''' + @table + '''' 
					       			
			--PRINT @sql	
			BEGIN TRANSACTION			
			EXECUTE sp_executesql @sql
			COMMIT TRANSACTION

			FETCH NEXT
			FROM table_cursor
			INTO @table			

		END

		CLOSE table_cursor
		DEALLOCATE table_cursor

		FETCH NEXT
		FROM dongle_cursor
		INTO @dongle
	END

	CLOSE dongle_cursor

	DEALLOCATE dongle_cursor
END
GO

