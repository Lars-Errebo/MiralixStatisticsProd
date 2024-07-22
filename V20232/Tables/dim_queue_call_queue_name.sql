CREATE TABLE [V20232].[dim_queue_call_queue_name] (
    [_queue_call_queue_name_unique_id] NVARCHAR (100)  NOT NULL,
    [_dongle_id]                       INT             NULL,
    [_queue_id]                        INT             NULL,
    [_queue_name]                      NVARCHAR (256)  NULL,
    [_tags]                            NVARCHAR (1024) NULL
);
GO

ALTER TABLE [V20232].[dim_queue_call_queue_name]
    ADD CONSTRAINT [PK_dim_queue_call_queue_name] PRIMARY KEY CLUSTERED ([_queue_call_queue_name_unique_id] ASC);
GO

