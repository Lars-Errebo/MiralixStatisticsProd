CREATE TABLE [VIEW].[LoadConfig] (
    [SRC_schema]              VARCHAR (100) NOT NULL,
    [SRC_tab]                 VARCHAR (500) NOT NULL,
    [DST_schema]              VARCHAR (100) NOT NULL,
    [DST_tab]                 VARCHAR (500) NOT NULL,
    [Cols]                    VARCHAR (MAX) NULL,
    [WatermarkColumn]         VARCHAR (100) NULL,
    [WatermarkColumnDatatype] VARCHAR (100) NULL,
    [WatermarkValue]          VARCHAR (128) NULL,
    [OldWatermarkValue]       VARCHAR (128) NULL,
    [LoadPattern]             VARCHAR (100) NULL,
    [Enabled]                 BIT           NULL,
    [MetaUpdatedTime]         DATETIME      NULL
);
GO

