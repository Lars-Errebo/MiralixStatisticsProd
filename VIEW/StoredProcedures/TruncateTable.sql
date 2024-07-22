




CREATE PROCEDURE [VIEW].[TruncateTable]
    @TableSchema varchar(250)  
	,@TableName varchar(250)

AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @SQLcmd nvarchar(512)
  

  IF (LEN(@TableName) > 0)
  BEGIN

  IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @TableSchema 
	AND TABLE_NAME = @TableName )) 
	 BEGIN 

	SET @SQLcmd = 'TRUNCATE TABLE ' + QUOTENAME(@TableSchema)+'.'+QUOTENAME(@TableName)
	EXEC sp_executesql @SQLcmd
	 
	 END

  END
END
GO

