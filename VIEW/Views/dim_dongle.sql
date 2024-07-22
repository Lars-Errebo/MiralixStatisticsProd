





CREATE view [VIEW].[dim_dongle] as
  select DongleID as _dongle_id, LastLicDate as _date_min, convert(date,dateadd(day,-1,GETDATE())) as _date_max  from [VIEW].[DongleConfig] where Enabled = 1
GO

