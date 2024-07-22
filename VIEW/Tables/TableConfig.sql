CREATE TABLE [VIEW].[TableConfig] (
    [id]            INT           IDENTITY (1, 1) NOT NULL,
    [TableName]     VARCHAR (300) NULL,
    [VersionNumber] VARCHAR (10)  NULL,
    [Cols]          VARCHAR (MAX) NULL
);
GO

