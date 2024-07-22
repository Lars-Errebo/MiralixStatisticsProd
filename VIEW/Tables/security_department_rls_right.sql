CREATE TABLE [VIEW].[security_department_rls_right] (
    [ID]                     INT           IDENTITY (1, 1) NOT NULL,
    [_created]               DATETIME2 (7) NOT NULL,
    [_stamp]                 DATETIME2 (7) NOT NULL,
    [_dongle_id]             INT           NOT NULL,
    [_rls_object_source]     VARCHAR (64)  NOT NULL,
    [_rls_object_column]     VARCHAR (64)  NOT NULL,
    [_rls_company_object_id] INT           NULL,
    [_rls_object_id]         INT           NOT NULL,
    [_rls_object_name]       VARCHAR (256) NOT NULL
);
GO

ALTER TABLE [VIEW].[security_department_rls_right]
    ADD CONSTRAINT [DF_security_department_rls_right__stamp] DEFAULT (sysdatetime()) FOR [_stamp];
GO

ALTER TABLE [VIEW].[security_department_rls_right]
    ADD CONSTRAINT [DF_security_department_rls_right__created] DEFAULT (sysdatetime()) FOR [_created];
GO

ALTER TABLE [VIEW].[security_department_rls_right]
    ADD CONSTRAINT [PK_security_department_rls_right] PRIMARY KEY CLUSTERED ([ID] ASC);
GO

