
-- =============================================
-- Author:		Martin Krogh Hollænder & Rasmus Helstrup Pedersen
-- Create date: 2022-09-01
-- Description:	Creates a metadata structure from data in load tables.
-- =============================================
CREATE PROCEDURE [VIEW].[CreateRLSRightsStructure]
AS
BEGIN
	--TJEK OM ADDRESS TABEL FINDES, ELLERS OPRETTES DEN.
	SET NOCOUNT ON;

	IF OBJECT_ID(N'VIEW.security_address_rls_right', N'U') IS NULL
	BEGIN
		CREATE TABLE [VIEW].[security_address_rls_right] (
			[ID] [int] IDENTITY(1, 1) NOT NULL
			,[_created] [datetime2](7) NOT NULL
			,[_stamp] [datetime2](7) NOT NULL
			,[_dongle_id] [int] NOT NULL
			,[_rls_object_source] [varchar](64) NOT NULL
			,[_rls_object_column] [varchar](64) NOT NULL
			,[_rls_object_id] [int] NOT NULL
			,[_rls_object_name] [varchar](256) NOT NULL
			,CONSTRAINT [PK_security_address_rls_right] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (
				STATISTICS_NORECOMPUTE = OFF
				,IGNORE_DUP_KEY = OFF
				) ON [PRIMARY]
			) ON [PRIMARY]

		ALTER TABLE [VIEW].[security_address_rls_right] ADD CONSTRAINT [DF__security_address_rls_right___crea__0D0FEE32] DEFAULT(sysdatetime())
		FOR [_created]

		ALTER TABLE [VIEW].[security_address_rls_right] ADD CONSTRAINT [DF__security_address_rls_right___stam__0E04126B] DEFAULT(sysdatetime())
		FOR [_stamp]
	END

	DELETE
	FROM [VIEW].security_address_rls_right

	--INDSÆT DATA I ADDRESS
	INSERT INTO [VIEW].security_address_rls_right (
		[_dongle_id]
		,[_rls_object_source]
		,[_rls_object_column]
		,[_rls_object_id]
		,[_rls_object_name]
		)
	SELECT REPLACE(_dongle_id, '_', '')
		,'AgentEvent'
		,'_agent_address_id'
		,_agent_address_id
		,_agent_address_name
	FROM [LOAD].[office_team_statistics_agent_event] AS OTSAE
	WHERE OTSAE._agent_address_id IS NOT NULL
		AND OTSAE._agent_address_name IS NOT NULL
		AND OTSAE.id IN (
			SELECT id
			FROM (
				SELECT row_number() OVER (
						PARTITION BY AE._agent_address_id
						,AE._dongle_id ORDER BY AE.id DESC
						) AS LastQC
					,AE.id
					,AE._dongle_id
				FROM [LOAD].[office_team_statistics_agent_event] AS AE
				) AS QC
			WHERE LastQC = 1
				AND QC._dongle_id = OTSAE._dongle_id
			)
	GROUP BY _agent_address_id
		,_agent_address_name
		,_dongle_id

	--TJEK OM COMPANY TABEL FINDES, ELLERS OPRETTES DEN.
	IF OBJECT_ID(N'VIEW.security_company_rls_right', N'U') IS NULL
	BEGIN
		CREATE TABLE [VIEW].[security_company_rls_right] (
			[ID] [int] IDENTITY(1, 1) NOT NULL
			,[_created] [datetime2](7) NOT NULL
			,[_stamp] [datetime2](7) NOT NULL
			,[_dongle_id] [INT] NOT NULL
			,[_rls_object_source] [varchar](64) NOT NULL
			,[_rls_object_column] [varchar](64) NOT NULL
			,[_rls_object_id] [int] NOT NULL
			,[_rls_object_name] [varchar](256) NOT NULL
			,CONSTRAINT [PK_security_company_rls_right] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (
				STATISTICS_NORECOMPUTE = OFF
				,IGNORE_DUP_KEY = OFF
				) ON [PRIMARY]
			) ON [PRIMARY]

		ALTER TABLE [VIEW].[security_company_rls_right] ADD CONSTRAINT [DF__security_company_rls_right___crea__0D0FEE32] DEFAULT(sysdatetime())
		FOR [_created]

		ALTER TABLE [VIEW].[security_company_rls_right] ADD CONSTRAINT [DF__security_company_rls_right___stam__0E04126B] DEFAULT(sysdatetime())
		FOR [_stamp]
	END

	DELETE
	FROM [VIEW].[security_company_rls_right]

	--INDSÆT DATA I COMPANY
	INSERT INTO [VIEW].[security_company_rls_right] (
		[_dongle_id]
		,[_rls_object_source]
		,[_rls_object_column]
		,[_rls_object_id]
		,[_rls_object_name]
		)
	SELECT REPLACE(_dongle_id, '_', '')
		,'AgentEvent'
		,'_agent_company_id'
		,_agent_company_id
		,_agent_company_name
	FROM [LOAD].[office_team_statistics_agent_event] AS OTSAE
	WHERE OTSAE._agent_company_id IS NOT NULL
		AND OTSAE._agent_company_name IS NOT NULL
		AND OTSAE.id IN (
			SELECT id
			FROM (
				SELECT row_number() OVER (
						PARTITION BY AE._agent_company_id
						,AE._dongle_id ORDER BY AE.id DESC
						) AS LastQC
					,AE.id
					,AE._dongle_id
				FROM [LOAD].[office_team_statistics_agent_event] AS AE
				) AS QC
			WHERE LastQC = 1
				AND QC._dongle_id = OTSAE._dongle_id
			)
	GROUP BY OTSAE._agent_company_id
		,OTSAE._agent_company_name
		,OTSAE._dongle_id

	--TJEK OM DEPARTMENT TABEL FINDES, ELLERS OPRETTES DEN.
	IF OBJECT_ID(N'VIEW.security_department_rls_right', N'U') IS NULL
	BEGIN
		CREATE TABLE [VIEW].[security_department_rls_right] (
			[ID] [int] IDENTITY(1, 1) NOT NULL
			,[_created] [datetime2](7) NOT NULL
			,[_stamp] [datetime2](7) NOT NULL
			,[_dongle_id] [INT] NOT NULL
			,[_rls_object_source] [varchar](64) NOT NULL
			,[_rls_object_column] [varchar](64) NOT NULL
			,[_rls_company_object_id] [int] NULL
			,[_rls_object_id] [int] NOT NULL
			,[_rls_object_name] [varchar](256) NOT NULL
			,CONSTRAINT [PK_security_department_rls_right] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (
				STATISTICS_NORECOMPUTE = OFF
				,IGNORE_DUP_KEY = OFF
				) ON [PRIMARY]
			) ON [PRIMARY]

		ALTER TABLE [VIEW].[security_department_rls_right] ADD CONSTRAINT [DF_security_department_rls_right__created] DEFAULT(sysdatetime())
		FOR [_created]

		ALTER TABLE [VIEW].[security_department_rls_right] ADD CONSTRAINT [DF_security_department_rls_right__stamp] DEFAULT(sysdatetime())
		FOR [_stamp]
	END

	DELETE
	FROM [VIEW].[security_department_rls_right]

	--INDSÆT DATA I DEPARTMENT
	INSERT INTO [VIEW].[security_department_rls_right] (
		[_dongle_id]
		,[_rls_object_source]
		,[_rls_object_column]
		,[_rls_company_object_id]
		,[_rls_object_id]
		,[_rls_object_name]
		)
	SELECT REPLACE(_dongle_id, '_', '')
		,'AgentEvent'
		,'_agent_department_id'
		,_agent_company_id
		,_agent_department_id
		,_agent_department_name
	FROM [LOAD].[office_team_statistics_agent_event] AS OTSAE
	WHERE OTSAE._agent_department_id IS NOT NULL
		AND OTSAE._agent_department_name IS NOT NULL
		AND OTSAE.id IN (
			SELECT id
			FROM (
				SELECT row_number() OVER (
						PARTITION BY AE._agent_company_id
						,AE._agent_department_id
						,AE._dongle_id ORDER BY AE.id DESC
						) AS LastQC
					,AE.id
					,AE._dongle_id
				FROM [LOAD].[office_team_statistics_agent_event] AS AE
				) AS QC
			WHERE LastQC = 1
				AND QC._dongle_id = OTSAE._dongle_id
			)
	GROUP BY _agent_department_id
		,_agent_company_id
		,_agent_department_name
		,_dongle_id

	--TJEK OM OBJECT RLS TABEL FINDES, ELLERS OPRETTES DEN.
	IF OBJECT_ID(N'VIEW.security_object_rls_right', N'U') IS NULL
	BEGIN
		CREATE TABLE [VIEW].[security_object_rls_right] (
			[ID] [int] IDENTITY(1, 1) NOT NULL
			,[_created] [datetime2](7) NOT NULL
			,[_stamp] [datetime2](7) NOT NULL
			,[_dongle_id] [INT] NOT NULL
			,[_rls_company_object_id] [int] NULL
			,[_rls_address_object_id] [int] NULL
			,[_rls_department_object_id] [int] NULL
			,[_rls_object_source] [varchar](64) NOT NULL
			,[_rls_object_column] [varchar](64) NOT NULL
			,[_rls_object_id] [int] NOT NULL
			,[_rls_object_name] [varchar](256) NOT NULL
			,CONSTRAINT [PK_security_rls_right] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (
				STATISTICS_NORECOMPUTE = OFF
				,IGNORE_DUP_KEY = OFF
				) ON [PRIMARY]
			) ON [PRIMARY]

		ALTER TABLE [VIEW].[security_object_rls_right] ADD CONSTRAINT [DF__RLSMetaVIEWDa___crea__0D0FEE32] DEFAULT(sysdatetime())
		FOR [_created]

		ALTER TABLE [VIEW].[security_object_rls_right] ADD CONSTRAINT [DF__RLSMetaDa___stam__0E04126B] DEFAULT(sysdatetime())
		FOR [_stamp]
	END

	DELETE
	FROM [VIEW].[security_object_rls_right]

	--INDSÆT SIDSTE AGENT NAVN PÅ AGENT I OBJECT RLS
	INSERT INTO [VIEW].[security_object_rls_right] (
		[_dongle_id]
		,[_rls_object_source]
		,[_rls_company_object_id]
		,[_rls_address_object_id]
		,[_rls_department_object_id]
		,[_rls_object_column]
		,[_rls_object_id]
		,[_rls_object_name]
		)
	SELECT REPLACE(_dongle_id, '_', '')
		,'AgentEvent'
		,_agent_address_id
		,_agent_company_id
		,_agent_department_id
		,'_agent_id'
		,_agent_id
		,_agent_name
	FROM [LOAD].[office_team_statistics_agent_event]
	WHERE id IN (
			SELECT AE.id
			FROM (
				SELECT row_number() OVER (
						PARTITION BY _agent_id
						,_dongle_id ORDER BY id DESC
						) AS LastAE
					,id
					,_dongle_id
				FROM [LOAD].[office_team_statistics_agent_event] AS AE
				) AS AE
			WHERE LastAE = 1
				AND _agent_name NOT LIKE 'Agent %'
				AND AE._dongle_id = [LOAD].[office_team_statistics_agent_event]._dongle_id
			)
	GROUP BY _dongle_id
		,_agent_address_id
		,_agent_company_id
		,_agent_department_id
		,_agent_id
		,_agent_name

	--INDSÆT KØ DATA I OBJECT RLS
	INSERT INTO [VIEW].[security_object_rls_right] (
		[_dongle_id]
		,[_rls_object_source]
		,[_rls_object_column]
		,[_rls_object_id]
		,[_rls_object_name]
		)
	SELECT REPLACE(OTSQC._dongle_id, '_', '')
		,'QueueCall'
		,'_queue_id'
		,OTSQC._queue_id
		,OTSQC._queue_name
	FROM [LOAD].[office_team_statistics_queue_call] AS OTSQC
	WHERE id IN (
			SELECT QC.id
			FROM (
				SELECT row_number() OVER (
						PARTITION BY QC._queue_id
						,QC._dongle_id ORDER BY QC.id DESC
						) AS LastQC
					,QC.id
					,QC._dongle_id
				FROM [LOAD].[office_team_statistics_queue_call] AS QC
				) AS QC
			WHERE LastQC = 1
				AND QC._dongle_id = OTSQC._dongle_id
			)
	GROUP BY OTSQC._dongle_id
		,OTSQC._queue_id
		,OTSQC._queue_name
  
    UNION ALL

	SELECT REPLACE(OTSQC._dongle_id, '_', '')
		,'QueueCall'
		,'_queue_id'
		,OTSQC._queue_id
		,OTSQC._queue_name
	FROM [LOAD].[office_team_statistics_queue_web_chat] AS OTSQC
	WHERE id IN (
			SELECT QC.id
			FROM (
				SELECT row_number() OVER (
						PARTITION BY QC._queue_id
						,QC._dongle_id ORDER BY QC.id DESC
						) AS LastQC
					,QC.id
					,QC._dongle_id
				FROM [LOAD].[office_team_statistics_queue_web_chat] AS QC
				) AS QC
			WHERE LastQC = 1
				AND QC._dongle_id = OTSQC._dongle_id
			)
	GROUP BY OTSQC._dongle_id
		,OTSQC._queue_id
		,OTSQC._queue_name

	UNION ALL

	SELECT REPLACE(OTSQC._dongle_id, '_', '')
		,'QueueCall'
		,'_queue_id'
		,OTSQC._queue_id
		,OTSQC._queue_name
	FROM [LOAD].[office_team_statistics_queue_task] AS OTSQC
	WHERE id IN (
			SELECT QC.id
			FROM (
				SELECT row_number() OVER (
						PARTITION BY QC._queue_id
						,QC._dongle_id ORDER BY QC.id DESC
						) AS LastQC
					,QC.id
					,QC._dongle_id
				FROM [LOAD].[office_team_statistics_queue_task] AS QC
				) AS QC
			WHERE LastQC = 1
				AND QC._dongle_id = OTSQC._dongle_id
			)
	GROUP BY OTSQC._dongle_id
		,OTSQC._queue_id
		,OTSQC._queue_name

	--INDSÆT MENU DATA I OBJECT RLS
	INSERT INTO [VIEW].[security_object_rls_right] (
		[_dongle_id]
		,[_rls_object_source]
		,[_rls_object_column]
		,[_rls_object_id]
		,[_rls_object_name]
		)
	SELECT REPLACE(_dongle_id, '_', '')
		,'Menu'
		,'_menu_id'
		,_menu_id
		,_menu_name
	FROM [LOAD].[office_team_statistics_menu]
	WHERE id IN (
			SELECT M.id
			FROM (
				SELECT row_number() OVER (
						PARTITION BY _menu_id
						,_dongle_id ORDER BY id DESC
						) AS LastM
					,id
					,_dongle_id
				FROM [LOAD].[office_team_statistics_menu] AS M
				) AS M
			WHERE LastM = 1
				AND M._dongle_id = [LOAD].[office_team_statistics_menu]._dongle_id
			)
	GROUP BY _dongle_id
		,_menu_id
		,_menu_name

	--INDSÆT VOICEMAIL DATA I OBJECT RLS
	INSERT INTO [VIEW].[security_object_rls_right] (
		[_dongle_id]
		,[_rls_object_source]
		,[_rls_object_column]
		,[_rls_object_id]
		,[_rls_object_name]
		)
	SELECT REPLACE(_dongle_id, '_', '')
		,'Voicemail'
		,'_voicemail_account_id'
		,_voicemail_account_id
		,_voicemail_account_name
	FROM [LOAD].[office_team_statistics_voicemail]
	WHERE id IN (
			SELECT VM.id
			FROM (
				SELECT row_number() OVER (
						PARTITION BY _voicemail_account_id
						,_dongle_id ORDER BY id DESC
						) AS LastVM
					,id
					,_dongle_id
				FROM [LOAD].[office_team_statistics_voicemail] AS VM
				) AS VM
			WHERE LastVM = 1
				AND VM._dongle_id = [LOAD].[office_team_statistics_voicemail]._dongle_id
			)
	GROUP BY _dongle_id
		,_voicemail_account_id
		,_voicemail_account_name

	--INDSÆT INDTASTNINGSMENU DATA I OBJECT RLS
	INSERT INTO [VIEW].[security_object_rls_right] (
		[_dongle_id]
		,[_rls_object_source]
		,[_rls_object_column]
		,[_rls_object_id]
		,[_rls_object_name]
		)
	SELECT REPLACE(_dongle_id, '_', '')
		,'EntryMenu'
		,'_entry_menu_id'
		,_entry_menu_id
		,_entry_menu_name
	FROM [LOAD].[office_team_statistics_entry_menu]
	WHERE id IN (
			SELECT EM.id
			FROM (
				SELECT row_number() OVER (
						PARTITION BY _entry_menu_id
						,_dongle_id ORDER BY id DESC
						) AS LastEM
					,id
					,_dongle_id
				FROM [LOAD].[office_team_statistics_entry_menu] AS EM
				) AS EM
			WHERE LastEM = 1
				AND EM._dongle_id = [LOAD].[office_team_statistics_entry_menu]._dongle_id
			)
	GROUP BY _dongle_id
		,_entry_menu_id
		,_entry_menu_name

	--INDSÆT OMSTILLING DATA I OBJECT RLS
	INSERT INTO [VIEW].[security_object_rls_right] (
		[_dongle_id]
		,[_rls_object_source]
		,[_rls_object_column]
		,[_rls_object_id]
		,[_rls_object_name]
		)
	SELECT REPLACE(_dongle_id, '_', '')
		,'Transfer'
		,'_transfer_id'
		,_transfer_id
		,_transfer_name
	FROM [LOAD].[office_team_statistics_transfer]
	WHERE id IN (
			SELECT T.id
			FROM (
				SELECT row_number() OVER (
						PARTITION BY _transfer_id
						,_dongle_id ORDER BY id DESC
						) AS LastT
					,id
					,_dongle_id
				FROM [LOAD].[office_team_statistics_transfer] AS T
				) AS T
			WHERE LastT = 1
				AND T._dongle_id = [LOAD].[office_team_statistics_transfer]._dongle_id
			)
	GROUP BY _dongle_id
		,_transfer_id
		,_transfer_name
END
GO

