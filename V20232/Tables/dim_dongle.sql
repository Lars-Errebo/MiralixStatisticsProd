CREATE TABLE [V20232].[dim_dongle] (
    [_dongle_id] INT  NOT NULL,
    [_date_min]  DATE NULL,
    [_date_max]  DATE NULL
);
GO

ALTER TABLE [V20232].[dim_dongle]
    ADD CONSTRAINT [PK_dim_dongle] PRIMARY KEY CLUSTERED ([_dongle_id] ASC);
GO

