CREATE TABLE [dbo].[proxy_connection_time] (
    [id]                                    INT            NOT NULL,
    [_outgoing_utc]                         DATETIME2 (7)  NULL,
    [_incoming_utc]                         DATETIME2 (7)  NULL,
    [_outgoing_command]                     NVARCHAR (256) NULL,
    [_incoming_command]                     NVARCHAR (256) NULL,
    [_last_clean_up_utc]                    DATETIME2 (7)  NULL,
    [_info]                                 NVARCHAR (MAX) NULL,
    [_next_clean_up_utc]                    DATETIME2 (7)  NULL,
    [_clean_up_interval_hours]              INT            NULL,
    [_minimum_request_interval_minutes]     INT            NULL,
    [_last_clean_up_completion_time_minute] INT            NULL,
    [_connected]                            BIT            NULL,
    [_connected_time_utc]                   DATETIME2 (7)  NULL,
    [_disconnected_time_utc]                DATETIME2 (7)  NULL,
    [_birst_data_cleanup_utc]               DATETIME2 (7)  NULL,
    [_log_data_holder_keys]                 BIT            NOT NULL,
    [_proxy_version]                        NVARCHAR (128) NULL,
    [_power_bi_enabled_dev]                 BIT            NOT NULL,
    [_power_bi_enabled_test]                BIT            NOT NULL,
    [_power_bi_enabled_prod]                BIT            NOT NULL
);
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [DF__proxy_con___conn__71E0CDBC] DEFAULT ((0)) FOR [_connected];
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [DF__proxy_con___clea__2D6BA7DE] DEFAULT ((24)) FOR [_clean_up_interval_hours];
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [DF__proxy_con___disc__73C9162E] DEFAULT (NULL) FOR [_disconnected_time_utc];
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [DF_proxy_connection_time__power_bi_enabled_dev] DEFAULT ((0)) FOR [_power_bi_enabled_dev];
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [DF__proxy_con___last__7F6FD304] DEFAULT (NULL) FOR [_last_clean_up_completion_time_minute];
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [DF_proxy_connection_time__power_bi_enabled_prod] DEFAULT ((0)) FOR [_power_bi_enabled_prod];
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [DF__proxy_con___conn__72D4F1F5] DEFAULT (NULL) FOR [_connected_time_utc];
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [DF__proxy_con___mini__2E5FCC17] DEFAULT ((15)) FOR [_minimum_request_interval_minutes];
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [DF__proxy_con___next__2C7783A5] DEFAULT (NULL) FOR [_next_clean_up_utc];
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [DF__proxy_con___log___338F60DF] DEFAULT ((0)) FOR [_log_data_holder_keys];
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [DF__proxy_con___birs__26DEA5E0] DEFAULT (NULL) FOR [_birst_data_cleanup_utc];
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [DF_proxy_connection_time__power_bi_enabled_test] DEFAULT ((0)) FOR [_power_bi_enabled_test];
GO

ALTER TABLE [dbo].[proxy_connection_time]
    ADD CONSTRAINT [PK__proxy_co__3213E83FB854BEEE] PRIMARY KEY CLUSTERED ([id] ASC);
GO

