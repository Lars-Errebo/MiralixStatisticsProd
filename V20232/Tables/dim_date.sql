CREATE TABLE [V20232].[dim_date] (
    [_date_id]          INT           NOT NULL,
    [_date]             DATE          NULL,
    [_date_minus_one]   DATE          NULL,
    [_day]              INT           NULL,
    [_day_name]         NVARCHAR (10) NULL,
    [_day_of_week]      INT           NULL,
    [_day_of_year]      INT           NULL,
    [_day_of_offset]    INT           NULL,
    [_days_in_month]    INT           NULL,
    [_end_of_month]     DATE          NULL,
    [_end_of_quarter]   DATE          NULL,
    [_end_of_week]      DATE          NULL,
    [_end_of_year]      DATE          NULL,
    [_iso_weeknumber]   INT           NULL,
    [_month]            INT           NULL,
    [_month_name]       NVARCHAR (9)  NULL,
    [_month_offset]     INT           NULL,
    [_quarter]          INT           NULL,
    [_start_of_month]   DATE          NULL,
    [_start_of_quarter] DATE          NULL,
    [_start_of_week]    DATE          NULL,
    [_start_of_year]    DATE          NULL,
    [_week_of_month]    INT           NULL,
    [_week_of_year]     INT           NULL,
    [_week_offset]      INT           NULL,
    [_year]             INT           NULL,
    [_year_offset]      INT           NULL
);
GO

ALTER TABLE [V20232].[dim_date]
    ADD CONSTRAINT [PK_dim_date] PRIMARY KEY CLUSTERED ([_date_id] ASC);
GO

