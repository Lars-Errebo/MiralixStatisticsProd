
-- =============================================
-- Author:      <Martin Krogh Hollænder>
-- Create Date: <06.03.2023>
-- Description: <A stored proc that does multiple things:
-- If the env parameter is not prod the dongles are filtered by the PBI flags in the datahotel table connection time 
-- The dongle license type is found- The dongle last data date is found
-- The dongle last license date is found>
-- =============================================
CREATE PROCEDURE [VIEW].[PrepareDongleMetadata] @Environment VARCHAR(64) = 'prod'
AS
BEGIN
	SET NOCOUNT ON

--	declare @environment varchar(64) = 'dev'
	-- insert into loaddongleconfig
	--TRUNCATE TABLE [VIEW].[LoadDongleConfig]
	--INSERT INTO [VIEW].[LoadDongleConfig] ([DongleID], [VersionNumber], [Enabled], [UnlimitedInquiries], [LicenseID], [Environment])
	--SELECT DongleID,VersionNumber,[Enabled],lt.UnlimitedInquiries,lt.MrxLicenseID,'dev' FROM [VIEW].[DongleConfig] dc
	--JOIN [VIEW].[DongleLicenseType] lt on lt.id = dc.DongleLicenseTypeID
	   
	-- Disable all dongles that are on the datahotel blacklist
	DELETE
	FROM [VIEW].[LoadDongleConfig]
	WHERE DongleID IN (
			SELECT dongle
			FROM MiralixStatistics.dbo.proxy_connection_black_list
			)
		AND Environment = @Environment

	-- Cleanup the load config table based on the environment we run in.
	IF @Environment = 'dev'
	BEGIN
		DELETE
		FROM [VIEW].[LoadDongleConfig]
		WHERE DongleID NOT IN (
				SELECT id
				FROM MiralixStatistics.dbo.proxy_connection_time
				WHERE _power_bi_enabled_dev = 1
					AND _proxy_version IS NOT NULL
				)
			AND Environment = @Environment
	END

	-- Cleanup the load config table based on the environment we run in.
	IF @Environment = 'test'
	BEGIN
		DELETE
		FROM [VIEW].[LoadDongleConfig]
		WHERE DongleID NOT IN (
				SELECT id
				FROM MiralixStatistics.dbo.proxy_connection_time
				WHERE _power_bi_enabled_test = 1
					AND _proxy_version IS NOT NULL
				)
			AND Environment = @Environment
	END

	-- If we are running in prod, only cleanup the load config table based on dongle that are not in the datahotel.
	IF @Environment NOT IN (
			'test'
			,'dev'
			)
	BEGIN
		DELETE
		FROM [VIEW].[LoadDongleConfig]
		WHERE DongleID NOT IN (
				SELECT id
				FROM MiralixStatistics.dbo.proxy_connection_time
				WHERE _proxy_version IS NOT NULL
				)
			AND Environment = @Environment
	END

	--DECLARE @Environment VARCHAR(64)
	--SET @Environment = 'Test'
	-- Set the versionnumber from the config in the datahotel
	UPDATE LDC
	SET LDC.VersionNumber = LEFT(PDC._proxy_version, 3)
		,LDC.Enabled = 1
	FROM [VIEW].[LoadDongleConfig] AS LDC
	JOIN MiralixStatistics.dbo.proxy_connection_time AS PDC ON (LDC.DongleID = PDC.id)
	WHERE LDC.Environment = @Environment

	-- Housecleaning, delete any dongles in the load config that dont have a version or license
	DELETE
	FROM [VIEW].[LoadDongleConfig]
	WHERE VersionNumber IS NULL
		AND Environment = @Environment

	-- Inset new dongles into the dongle config tale from the load config table.
	INSERT INTO [VIEW].[DongleConfig] (
		[DongleID]
		,[VersionNumber]
		,[Enabled]
		,[Environment]
		)
	SELECT [DongleID]
		,[VersionNumber]
		,[Enabled]
		,@Environment
	FROM [VIEW].[LoadDongleConfig]
	WHERE [DongleID] NOT IN (
			SELECT [DongleID]
			FROM [VIEW].[DongleConfig]
			WHERE Environment = @Environment
			)
		AND Environment = @Environment
		AND [Enabled] = 1

	-- Make sure that they are enabled.
	UPDATE [VIEW].[DongleConfig]
	SET Enabled = 1
	WHERE [DongleID] IN (
			SELECT [DongleID]
			FROM [VIEW].[LoadDongleConfig]
			WHERE Environment = @Environment
			)
		AND Environment = @Environment

	-- Make sure that any missing dongles are disabled.
	UPDATE [VIEW].[DongleConfig]
	SET Enabled = 0
	WHERE [DongleID] NOT IN (
			SELECT [DongleID]
			FROM [VIEW].[LoadDongleConfig]
			WHERE Environment = @Environment
			)
		AND Environment = @Environment

	-- Reset the inquiriesincreased flag in dongleconfig
	UPDATE [MiralixStatisticsProd].[VIEW].[DongleConfig]
	SET InquiriesIncreased = 0
	WHERE Environment = @Environment

	-- Update dongles that have increased inquiries
	UPDATE DC
	SET DC.InquiriesIncreased = 1
	FROM [MiralixStatisticsProd].[VIEW].[DongleConfig] AS DC
	JOIN [MiralixStatisticsProd].[VIEW].[LoadDongleConfig] AS LDC ON DC.DongleID = LDC.DongleID
		AND DC.Environment = LDC.Environment
	JOIN [MiralixStatisticsProd].[VIEW].[DongleLicenseType] AS DCDLT ON DC.DongleLicenseTypeID = DCDLT.id
		AND DC.Environment = DCDLT.Environment
		AND DCDLT.UnlimitedInquiries = 0
	JOIN [MiralixStatisticsProd].[VIEW].[DongleLicenseType] AS LDCDLT ON LDC.LicenseID = LDCDLT.MrxLicenseID
		AND LDC.UnlimitedInquiries = LDCDLT.UnlimitedInquiries
		AND LDC.Environment = LDCDLT.Environment
	WHERE (
			DC.Environment = @Environment
			AND LDC.UnlimitedInquiries <> 1
			AND LDCDLT.Inquiries > DCDLT.Inquiries
			)
		OR (
			DC.Environment = @Environment
			AND LDCDLT.UnlimitedInquiries = 1
			AND DCDLT.UnlimitedInquiries = 0
			)

	-- Create a temp tabel that we use to gather all the relevante metadata on the dongles
	SELECT LDC.[DongleID] AS 'DongleID'
		,DLT.id AS DongleLicenseTypeID
		,DLT.[Inquiries] AS Inquiries
		,CAST(SYSDATETIME() AS DATE) AS LastDataDate
		,CAST(SYSDATETIME() AS DATE) AS LastLicDate
	INTO #LicMap
	FROM [VIEW].[LoadDongleConfig] AS LDC
	JOIN [VIEW].[DongleLicenseType] AS DLT ON (
			DLT.[MrxLicenseID] = LDC.[LicenseID]
			AND DLT.[UnlimitedInquiries] = LDC.[UnlimitedInquiries]
			AND LDC.Environment = @Environment
			AND DLT.Environment = @Environment
			)
		AND LDC.Environment = @Environment
		AND LDC.[Enabled] = 1
		AND DLT.Environment = @Environment

	--SELECT * FROM #LicMap
	-- Insert the corret license id in the dongle config table
	UPDATE DC
	SET DC.[DongleLicenseTypeID] = #LicMap.DongleLicenseTypeID
	FROM [VIEW].[LoadDongleConfig] AS LDC
	JOIN #LicMap ON (
			LDC.DongleID = #LicMap.DongleID
			AND LDC.Environment = @Environment
			)
	JOIN [VIEW].[DongleConfig] AS DC ON (
			LDC.DongleID = DC.DongleID
			AND LDC.Environment = @Environment
			AND DC.Environment = @Environment
			)
	WHERE LDC.[DongleID] = #LicMap.DongleID
		AND DC.Environment = @Environment
		AND DC.[Enabled] = 1

	DECLARE @SqlStatement NVARCHAR(MAX)

	-- Create all the relevant update statesments for finding the first date with data for all the dongles in temp table
	SELECT @SqlStatement = COALESCE(@SqlStatement, N'') + N'UPDATE #LicMap SET LastDataDate = MinDate.MD FROM (SELECT MIN(CAST([_first_call_arrived] AS DATE)) AS MD FROM MiralixStatistics._' + DongleID + '.office_team_statistics_global_call_id) AS MinDate WHERE #LicMap.DongleID = ''' + DongleID + '''' + N';' + CHAR(13)
	FROM #LicMap

	-- SELECT @SqlStatement
	-- Run all the relevant update statesments for finding the first date with data for all the dongles in temp table
	EXECUTE sp_executesql @SqlStatement

	-- Set the last lic data to the last data date where the dongle have unlimted inquries.
	UPDATE #LicMap
	SET LastLicDate = LastDataDate
	WHERE Inquiries = 0

	SET @SqlStatement = ''

	--DECLARE @SqlStatement NVARCHAR(MAX)
	-- Create all the relevant update statesments for finding the first date with data, based on the number of inqiries the donlges have, for all the dongles in temp table
	-- Dongles with unlimted number for inquiries are not included in this
	SELECT @SqlStatement = COALESCE(@SqlStatement, N'') + N'UPDATE #LicMap SET #LicMap.LastLicDate = CAST(RN._first_call_arrived AS date) FROM(SELECT ROW_NUMBER() OVER(PARTITION BY ('''') ORDER BY _first_call_arrived DESC) AS "RowNumber",_first_call_arrived FROM MiralixStatistics._' + DongleID + '.office_team_statistics_global_call_id WHERE _media_type = ''Audio'') AS RN WHERE #LicMap.DongleID = ''' + DongleID + ''' AND RN.RowNumber = #LicMap.Inquiries' + N';' + CHAR(13)
	FROM #LicMap
	WHERE #LicMap.Inquiries <> 0

	--SELECT @SqlStatement
	-- Run the statesments from above
	EXECUTE sp_executesql @SqlStatement

	SET @SqlStatement = ''

	-- Set LastDataDate to today if null
	UPDATE #LicMap
	SET LastDataDate = CAST(SYSDATETIME() AS DATE)
	WHERE LastDataDate IS NULL

	-- Set the correct lastlicdates
	UPDATE #LicMap
	SET LastLicDate = LastDataDate
	WHERE LastLicDate = CAST(SYSDATETIME() AS DATE)
		OR LastLicDate IS NULL

	-- Update the dongle config table with the new metadata we found.
	UPDATE DC
	SET DC.LastDataDate = #LicMap.LastDataDate
		,DC.LastLicDate = #LicMap.LastLicDate
		,DC.DongleLicenseTypeID = #LicMap.DongleLicenseTypeID
	FROM #LicMap
	JOIN [VIEW].[DongleConfig] AS DC ON (
			#LicMap.DongleID = DC.DongleID
			AND DC.Environment = @Environment
			)

	-- Tag all the dongles that exceeded the license inquiries
	UPDATE [VIEW].[DongleConfig]
	SET ExceededLicenseInquiries = 1
	WHERE LastDataDate < LastLicDate
		AND Environment = @Environment

	-- Tag all the dongles that does not exceeded the license inquiries 
	UPDATE [VIEW].[DongleConfig]
	SET ExceededLicenseInquiries = 0
	WHERE (
			LastDataDate = LastLicDate
			AND Environment = @Environment
			)
		OR (
			LastDataDate IS NULL
			AND Environment = @Environment
			)
		OR (
			LastLicDate IS NULL
			AND Environment = @Environment
			)

	-- Set the last data date to todays date when none cannot be found.
	UPDATE [VIEW].[DongleConfig]
	SET LastDataDate = CAST(SYSDATETIME() AS DATE)
	WHERE LastDataDate IS NULL
		AND Environment = @Environment

    -- indsæt manglende rækker fra nye tabeller
	Insert into [VIEW].[LoadConfig]
    select ldc.DongleID,tc.TableName,'V20232',tc.TableName,tc.Cols,'_stamp','Dateime2(7)',null,null,'DELTA',[Enabled],getdate() from [VIEW].[LoadDongleConfig] ldc
    join [VIEW].[TableConfig] tc on tc.VersionNumber = ldc.VersionNumber	
    where not exists ( select * from [VIEW].[LoadConfig] lc where  lc.SRC_tab = tc.TableName )
	order by ldc.DongleID,tc.TableName
END
GO

