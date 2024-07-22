

CREATE view [VIEW].[dim_date] as

WITH seq(n) AS 
(
  SELECT 0 UNION ALL SELECT n + 1 FROM seq
  WHERE n < DATEDIFF(DAY,'20100101', DATEADD(DAY, -1, DATEADD(YEAR, 30, '20100101')))
),
d(d) AS 
(
  SELECT DATEADD(DAY, n, '20100101') FROM seq
),
src AS
(
  SELECT
    TheDate         = CONVERT(date, d),
    TheDay          = DATEPART(DAY,       d),
    TheDayName      = DATENAME(WEEKDAY,   d),
    TheWeek         = DATEPART(WEEK,      d),
    TheISOWeek      = DATEPART(ISO_WEEK,  d),
    TheDayOfWeek    = DATEPART(WEEKDAY,   d),
    TheMonth        = DATEPART(MONTH,     d),
    TheMonthName    = DATENAME(MONTH,     d),
    TheQuarter      = DATEPART(Quarter,   d),
    TheYear         = DATEPART(YEAR,      d),
    TheFirstOfMonth = DATEFROMPARTS(YEAR(d), MONTH(d), 1),
    TheLastOfYear   = DATEFROMPARTS(YEAR(d), 12, 31),
    TheDayOfYear    = DATEPART(DAYOFYEAR, d)
  FROM d
),
dim AS
(
  SELECT
    FORMAT(CAST(TheDate AS DATE),'yyyyMMdd') as _date_id,
    TheDate as _date, 
    TheDay as _day, 
    TheDayOfWeek as _day_of_week, 
    TheDayOfYear as _day_of_year,    
	DATEDIFF(DAY, getdate(), TheDate) as _day_of_offset,  
	DAY(EOMONTH(TheDate)) as _days_in_month,
	EOMONTH(TheDate) as _end_of_month,
	_end_of_quarter = MAX(TheDate) OVER (PARTITION BY TheYear, TheQuarter),
	_end_of_week    = DATEADD(DAY, 6, DATEADD(DAY, 1 - TheDayOfWeek, TheDate)),
	TheLastOfYear as _end_of_year,
	TheISOweek as _iso_weeknumber,
	TheMonth as _month,
	TheMonthName as _month_name,
	DATEDIFF(MONTH, getdate(), TheDate) AS _month_offset,
	TheQuarter as _quarter,
	TheFirstOfMonth as _start_of_month,
	_start_of_quarter   = MIN(TheDate) OVER (PARTITION BY TheYear, TheQuarter),
	_start_of_week      = DATEADD(DAY, 1 - TheDayOfWeek, TheDate),
	_start_of_year      = DATEFROMPARTS(TheYear, 1,  1),
	_week_of_month      = CONVERT(tinyint, DENSE_RANK() OVER (PARTITION BY TheYear, TheMonth ORDER BY TheWeek)),
	TheWeek as _week_of_year,	  
    DATEDIFF(WEEK, getdate(), TheDate) as _week_offset,
	TheYear as _year, 
	DATEDIFF(YEAR, getdate(), TheDate) as _year_offset    
	
  FROM src
)

select * from src
--SELECT * FROM dim
--SELECT * FROM dim
GO

