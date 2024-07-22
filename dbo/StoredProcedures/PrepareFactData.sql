-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PrepareFactData] 

AS
BEGIN  

    TRUNCATE TABLE [TMP].[fact_queue_name]

    DECLARE @dongle int
	DECLARE @mth int
	DECLARE @dm nvarchar(20)
    DECLARE dm CURSOR FOR SELECT CONCAT([Dongle_Id],':',[yearmth]) FROM [VIEW].[fact_sources_qn]
	OPEN dm
	FETCH NEXT FROM dm INTO @dm
	WHILE @@FETCH_STATUS = 0 
	BEGIN
	    SET @dongle = CONVERT(int,SUBSTRING(@dm,0,CHARINDEX(':',@dm,0)))
		SET @mth    = CONVERT(int,SUBSTRING(@dm,CHARINDEX(':',@dm,0)+1,6))

		-- select @dongle, @mth

		INSERT INTO  [TMP].[fact_queue_name]
	    EXEC [V20232].[fact_queue_name] @dongle, @mth	    

		FETCH NEXT FROM dm INTO @dm
	END

	CLOSE dm  
    DEALLOCATE dm	

	SET NOCOUNT ON;
	
END
GO

