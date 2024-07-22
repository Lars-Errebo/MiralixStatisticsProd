CREATE TABLE [V20232].[dim_time] (
    [_time_id]       INT           NOT NULL,
    [_time]          TIME (7)      NULL,
    [_hour]          INT           NULL,
    [_hour_label]    NVARCHAR (2)  NULL,
    [_minute]        INT           NULL,
    [_minute_label]  NVARCHAR (2)  NULL,
    [_quater_range]  NVARCHAR (13) NULL,
    [_secound]       INT           NULL,
    [_secound_label] NVARCHAR (2)  NULL,
    [_hour_range]    NVARCHAR (5)  NULL
);
GO

ALTER TABLE [V20232].[dim_time]
    ADD CONSTRAINT [PK_dim_time] PRIMARY KEY CLUSTERED ([_time_id] ASC);
GO

