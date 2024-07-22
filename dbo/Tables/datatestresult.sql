CREATE TABLE [dbo].[datatestresult] (
    [_created] DATETIME      DEFAULT (getdate()) NOT NULL,
    [_source]  NVARCHAR (10) NULL,
    [_fact]    NVARCHAR (10) NULL,
    [_dongle]  INT           NULL,
    [_yrmth]   INT           NULL,
    [_cnt]     INT           NULL
);
GO

