
CREATE PROCEDURE [dbo].[IndexMaintenance]
AS
BEGIN

DECLARE @sqlcmd NVARCHAR(MAX)

-- IF START - Hvis SQL serveren har været oppe mere end 14 dage og dagen i måneden er større end d. 13
IF (SELECT DATEDIFF(day,DATEADD(ms,-sample_ms,GETDATE()), GETDATE())
	FROM sys.dm_io_virtual_file_stats(1,1)) > 7

BEGIN

-- SQL til at fjerne alle SQL indexes der ikke blevet brugt siden SQL serveren er blevet genstartet
DECLARE @IndexesCount INT
	SET @IndexesCount = (SELECT COUNT(*) FROM [dbo].[StatisticsForIndexes] WHERE seeks = 0 AND scans = 0 AND lookups = 0 AND DATEDIFF(DAY,createdDate,GETDATE()) > 13)
	PRINT 'Number of unused indexes to delete: ' + CAST(@IndexesCount AS NVARCHAR(10))

WHILE @IndexesCount != 0
BEGIN
   -- DECLARE @sqlcmd NVARCHAR(MAX)
	SET @sqlcmd = (SELECT TOP 1 dropindexsql FROM dbo.[StatisticsForIndexes] WHERE seeks = 0 AND scans = 0 AND lookups = 0 AND DATEDIFF(DAY,createdDate,GETDATE()) > 13)
	PRINT @sqlcmd
	EXEC(@sqlcmd)
	SET @IndexesCount = (SELECT COUNT(*) FROM [dbo].[StatisticsForIndexes] WHERE seeks = 0 AND scans = 0 AND lookups = 0 AND DATEDIFF(DAY,createdDate,GETDATE()) > 13)
	PRINT 'Number of Indexes to delete: ' + CAST(@IndexesCount AS NVARCHAR(10))
END

END
-- IF SLUT

-- Slet dublikaterede indexes
DECLARE @DubIndexesCount INT
	SET @DubIndexesCount = (SELECT COUNT(*) FROM [dbo].[DropDubIndexes])
--	PRINT @DubIndexesCount
IF @DubIndexesCount > 0
BEGIN
DECLARE @dupindexessqlcmd1 VARCHAR(MAX)
DECLARE @dupindexessqlcmd2 VARCHAR(MAX)

	PRINT 'Number of Dub Indexes to delete ' + CAST(@DubIndexesCount AS NVARCHAR(10))
WHILE @DubIndexesCount != 0
BEGIN

	SET @dupindexessqlcmd1 = (SELECT TOP 1 dropindexsql1 FROM [dbo].[DropDubIndexes])
	SET @dupindexessqlcmd2 = (SELECT TOP 1 dropindexsql2 FROM [dbo].[DropDubIndexes])
	PRINT @dupindexessqlcmd1
	EXEC(@dupindexessqlcmd1)
	PRINT @dupindexessqlcmd2
	EXEC(@dupindexessqlcmd2)
	SET @DubIndexesCount = (SELECT COUNT(*) FROM [dbo].[DropDubIndexes])
	PRINT 'Number of Dub Indexes to delete ' + CAST(@DubIndexesCount AS NVARCHAR(10))
END

END

-- SQL til at tilføje manglende indexes
DECLARE @MissingIndexesCount INT
	SET @MissingIndexesCount = (SELECT COUNT(*) FROM [dbo].[MissingIndexesV2])
--DECLARE @sqlcmd NVARCHAR(MAX)
	IF @MissingIndexesCount > 0
BEGIN
	PRINT 'Number of Missing Indexes ' + CAST(@MissingIndexesCount AS NVARCHAR(10))

WHILE @MissingIndexesCount != 0
BEGIN
	SET @sqlcmd = (SELECT TOP 1 [create_index_statement] FROM [MissingIndexesV2])
	PRINT @sqlcmd
	EXEC(@sqlcmd)
	SET @MissingIndexesCount = (SELECT COUNT(*) FROM [dbo].[MissingIndexesV2])
	PRINT 'Number of Missing Indexes ' + CAST(@MissingIndexesCount AS NVARCHAR(10))
END

END

END;
GO

