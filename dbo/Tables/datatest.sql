CREATE TABLE [dbo].[datatest] (
    [created] DATETIME2 (7) NOT NULL,
    [source]  NVARCHAR (50) NOT NULL,
    [fact]    NVARCHAR (50) NOT NULL,
    [dongle]  INT           NOT NULL,
    [yrmth]   INT           NOT NULL,
    [cnt]     INT           NOT NULL
);
GO

