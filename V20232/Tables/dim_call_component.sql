CREATE TABLE [V20232].[dim_call_component] (
    [_call_component_unique_id] NVARCHAR (100) NOT NULL,
    [_dongle_id]                INT            NOT NULL,
    [_call_component]           NVARCHAR (128) NULL,
    [_call_component_name]      NVARCHAR (256) NULL,
    [_call_component_type]      NVARCHAR (128) NULL
);
GO

ALTER TABLE [V20232].[dim_call_component]
    ADD CONSTRAINT [PK_dim_call_component] PRIMARY KEY CLUSTERED ([_call_component_unique_id] ASC);
GO

