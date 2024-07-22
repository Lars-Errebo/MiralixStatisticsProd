-- =============================================
-- Author:      <Kia Thomsen>
-- Create Date: <16.03.2022>
-- Description: <SP for updating data in the load tables using SCD Type 1 (no history)
--				Info about dynamic SQL: https://www.sqlservercentral.com/articles/dynamic-sql-merge-1 >
-- Modified by LAE
-- =============================================
CREATE PROCEDURE [VIEW].[DeleteInsert]
(
    @DB         VARCHAR(100),
    @SRC_schema VARCHAR(100),
	@DST_schema VARCHAR(100),
    @Table_name VARCHAR(250),
	@Dongle_Id  VARCHAR(100)	
)
AS
BEGIN
    SET NOCOUNT OFF
	DECLARE @DeleteSQL  VARCHAR(8000)
	DECLARE @DeleteSQL2 VARCHAR(8000)
	DECLARE @IdUpdateSQL VARCHAR(8000)
	DECLARE @InsertSQL  VARCHAR(8000)
	DECLARE @datefrom   DATE
	DECLARE @datedelta  DATE

	IF (LEN(@Table_name) > 0)
	BEGIN

-- GETS ALL COLUMNS FROM THE SPECIFIC TABLE
			SELECT COLUMN_NAME AS col
			INTO #Cols
			FROM [MiralixStatistics].INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_SCHEMA = @SRC_schema AND TABLE_NAME = @Table_name AND COLUMN_NAME not in ( '_dongle_id','_data_loaded' )			
			
			SET @datefrom  = (select [LastLicDate] from [VIEW].[DongleConfig] where DongleID = @dongle_id);
			SET @datedelta = (select ISNULL([WatermarkValue],@datefrom) from [VIEW].[LoadConfig] where SRC_Schema = @dongle_id and SRC_tab = @Table_name);


-- CREATES THE DYNAMIC DELETE STATEMENTS:
			SET @DeleteSQL = 'DELETE DST ' +
							 'FROM ' + QUOTENAME(@DST_schema) + '.' + QUOTENAME(@Table_name) + ' AS DST ' +
							 'WHERE DST._dongle_id = ''' + '_' + @Dongle_Id + ''' AND						 
							  EXISTS ( ' +
											'SELECT 1 ' +
												'FROM ' + QUOTENAME(@DB) + '.' +  QUOTENAME(@SRC_schema) + '.' + QUOTENAME(@Table_name) + ' AS SRC ' +
												'WHERE DST.id = SRC.id AND _stamp >= ''' + convert(nvarchar(10),cast(@datedelta as date)) + ''');' -- The join columns are hardcoded since they are the same for all tables
          
            SET @DeleteSQL2 = 'DELETE DST ' +
							 'FROM ' + QUOTENAME(@DST_schema) + '.' + QUOTENAME(@Table_name) + ' AS DST ' +
							 'WHERE DST._dongle_id = ''' + '_' + @Dongle_Id + ''' AND						 
							  EXISTS ( ' +
											'SELECT 1 ' +
												'FROM ' + QUOTENAME(@DB) + '.' +  QUOTENAME(@SRC_schema) + '.' + QUOTENAME(@Table_name) + ' AS SRC ' +
												'WHERE DST.id = SRC.id AND _stamp < ''' + convert(nvarchar(10),cast(@datefrom as date)) + ''');' -- The join columns are hardcoded since they are the same for all tables
            
			 
		    IF @Table_name in ('office_team_statistics_agent_event','office_team_statistics_queue_call')  
		    BEGIN

			   SET @IdUpdateSQL = 'INSERT INTO TMP.agent_id_update ' +
								  'SELECT getdate() , ''' +  @Table_name + ''' , ' + @Dongle_Id + ', DST._agent_id, DST._agent_name, SRC._agent_id, SRC._agent_name FROM ' + QUOTENAME(@DST_schema) + '.' + QUOTENAME(@Table_name) + ' AS DST ' +		
								  'JOIN ' + QUOTENAME(@DB) + '.' +  QUOTENAME(@SRC_schema) + '.' + QUOTENAME(@Table_name) + ' AS SRC ON  DST.Id = SRC.Id WHERE DST._dongle_id = ''' + '_' + @Dongle_Id + ''' AND SRC._agent_id = 0 AND DST._agent_id <> 0 AND SRC._stamp >= ''' + convert(nvarchar(10),cast(@datedelta as date)) + ''''
		
			   
			-- PRINT @idupdatesql			   
			 --  EXEC (@IdUpdateSQL)
		
		    END


-- CREATES THE DYNAMIC INSERT STATEMENT:
			SELECT @InsertSQL = 'INSERT INTO ' + QUOTENAME(@DST_schema) + '.' + QUOTENAME(@Table_name) + ' WITH (TABLOCK) ( '
			SELECT @InsertSQL = @InsertSQL + col + ',' from #Cols			
			SELECT @InsertSQL = SUBSTRING(@InsertSQL, 1, len(@InsertSQL)-1) 
			SELECT @InsertSQL = @InsertSQL + ',_dongle_id,_data_loaded ) SELECT '
			SELECT @InsertSQL = @InsertSQL + col + ',' from #Cols -- returns a list of all columns with a comma inbetween
			SELECT @InsertSQL = @InsertSQL + '''' + '_'+@Dongle_Id + ''',''' + convert(nvarchar(23),cast(getdate() as datetime2)) + ''','
			SELECT @InsertSQL = SUBSTRING(@InsertSQL, 1, len(@InsertSQL)-1) -- the subquery removed the last character from the @InsertSQL string, which is the comma after the last column
			SELECT @InsertSQL = @InsertSQL + ' FROM ' + QUOTENAME(@DB)+  '.' + QUOTENAME(@SRC_schema) + '.' + QUOTENAME(@Table_name) 
			SELECT @InsertSQL = @InsertSQL + ' WHERE _stamp >= ' + '''' + convert(nvarchar(10),cast(@datedelta as date)) + ''';'


-- RUNS THE DYNAMIC DELETE STATEMENT:
--		PRINT @DeleteSQL; -- For debugging/testing	
		BEGIN TRANSACTION
		EXEC (@DeleteSQL)			  
		EXEC (@DeleteSQL2)		  

-- RUNS THE DYNAMIC INSERT STATEMENT:
--		PRINT @InsertSQL; -- For debugging/testing
		EXEC (@InsertSQL)
		COMMIT TRANSACTION
		
				
	END 
END
GO

