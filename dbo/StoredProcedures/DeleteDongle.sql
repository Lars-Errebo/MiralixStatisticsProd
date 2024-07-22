
-- =============================================
-- Author:		<Martin Krogh Hollænder>
-- Create date: <2021-03-15>
-- Description:	<Delete dongle data and config>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteDongle] @DongleId NVARCHAR(4)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


		DECLARE @SqlStatement NVARCHAR(MAX)
		DECLARE @SqlStatementView NVARCHAR(MAX)

		SELECT @SqlStatement = 
			COALESCE(@SqlStatement, N'') + N'DROP TABLE [_' + @DongleId + '].' + QUOTENAME(TABLE_NAME) + N';' + CHAR(13)
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_SCHEMA = '_' + @DongleId and TABLE_TYPE = 'BASE TABLE'

		SELECT @SqlStatementView = 
			COALESCE(@SqlStatementView, N'') + N'DROP VIEW [_' + @DongleId + '].' + QUOTENAME(TABLE_NAME) + N';' + CHAR(13)
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_TYPE = 'view' AND (TABLE_NAME LIKE 'birst_%' OR TABLE_NAME LIKE 'datahotel_%') AND TABLE_SCHEMA = '_' + @DongleId

		DECLARE @Result NVARCHAR(MAX)

		SET @Result = CONCAT(@SqlStatement, @SqlStatementView, 'DROP SCHEMA _' , @DongleId , ';')

		EXECUTE sp_executesql @Result

		SET @Result = 'DELETE
		FROM [MiralixStatistics].[dbo].[proxy_connection_time]
		where id =' + @DongleId

		EXECUTE sp_executesql @Result
END
GO

