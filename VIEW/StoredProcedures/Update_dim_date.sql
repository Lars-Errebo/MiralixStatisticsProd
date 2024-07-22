





-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [VIEW].[Update_dim_date] 
 
AS
BEGIN
    
  SET NOCOUNT ON


;WITH seq (n)
AS (
	SELECT 0
	
	UNION ALL
	
	SELECT n + 1
	FROM seq
	WHERE n < DATEDIFF(DAY, '20100101', DATEADD(DAY, - 1, DATEADD(YEAR, 30, '20100101')))
	)
	,d (d)
AS (
	SELECT DATEADD(DAY, n, '20100101')
	FROM seq
	)
	,src
AS (
	SELECT TheDate = CONVERT(DATE, d)
		,TheDay = DATEPART(DAY, d)
		,TheDayName = DATENAME(WEEKDAY, d)
		,TheWeek = DATEPART(WEEK, d)
		,TheISOWeek = DATEPART(ISO_WEEK, d)
		,TheDayOfWeek = CASE WHEN DATEPART(WEEKDAY, d) = 1 THEN 7 ELSE DATEPART(WEEKDAY, d)-1 END
		,TheMonth = DATEPART(MONTH, d)
		,TheMonthName = DATENAME(MONTH, d)
		,TheQuarter = DATEPART(Quarter, d)
		,TheYear = DATEPART(YEAR, d)
		,TheFirstOfMonth = DATEFROMPARTS(YEAR(d), MONTH(d), 1)
		,TheLastOfYear = DATEFROMPARTS(YEAR(d), 12, 31)
		,TheDayOfYear = DATEPART(DAYOFYEAR, d)
	FROM d
	)
	,dim
AS (
	SELECT FORMAT(CAST(TheDate AS DATE), 'yyyyMMdd') AS _date_id
		,TheDate AS _date
		,dateadd(day,-1,TheDate) as _date_minus_one
		,TheDay AS _day
		,TheDayName as _day_name
		,TheDayOfWeek AS _day_of_week
		,TheDayOfYear AS _day_of_year
		,DATEDIFF(DAY, getdate(), TheDate) AS _day_of_offset
		,DAY(EOMONTH(TheDate)) AS _days_in_month
		,EOMONTH(TheDate) AS _end_of_month
		,_end_of_quarter = MAX(TheDate) OVER (
			PARTITION BY TheYear
			,TheQuarter
			)
		,_end_of_week = DATEADD(DAY, 6, DATEADD(DAY, 1 - TheDayOfWeek, TheDate))
		,TheLastOfYear AS _end_of_year
		,TheISOweek AS _iso_weeknumber
		,TheMonth AS _month
		,TheMonthName AS _month_name
		,DATEDIFF(MONTH, getdate(), TheDate) AS _month_offset
		,TheQuarter AS _quarter
		,TheFirstOfMonth AS _start_of_month
		,_start_of_quarter = MIN(TheDate) OVER (
			PARTITION BY TheYear
			,TheQuarter
			)
		,_start_of_week = DATEADD(DAY, 1 - TheDayOfWeek, TheDate)
		,_start_of_year = DATEFROMPARTS(TheYear, 1, 1)
		,_week_of_month = CONVERT(TINYINT, DENSE_RANK() OVER (
				PARTITION BY TheYear
				,TheMonth ORDER BY TheWeek
				))
		,TheWeek AS _week_of_year		
	    ,case when DATEDIFF(YEAR, getdate(), TheDate) = -1 and DATEDIFF(DAY, getdate(), TheDate) > -100 then 
		      case when year(TheDate) < year(getdate()) then TheISOweek - DATEPART(ISO_WEEK, getdate()) - datepart(ISO_WEEK,dateadd(day,-7,getdate())) else TheISOweek - DATEPART(ISO_WEEK, getdate()) end
		 else
		    case when YEAR(TheDate) = YEAR(getdate()) and TheWeek <> 53 then TheISOweek - DATEPART(ISO_WEEK, getdate()) end
		 end as _week_offset
		,TheYear AS _year
		,DATEDIFF(YEAR, getdate(), TheDate) AS _year_offset
	FROM src
	)


UPDATE V20232.dim_date 
SET 
V20232.dim_date._date = dim._date,
V20232.dim_date.[_date_minus_one]        = dim.[_date_minus_one]       ,   
V20232.dim_date.[_day]					 = dim.[_day]				   ,
V20232.dim_date.[_day_name]				 = dim.[_day_name]			   ,
V20232.dim_date.[_day_of_week]			 = dim.[_day_of_week]		   ,
V20232.dim_date.[_day_of_year]			 = dim.[_day_of_year]		   ,
V20232.dim_date.[_day_of_offset]		 = dim.[_day_of_offset]		   ,
V20232.dim_date.[_days_in_month]		 = dim.[_days_in_month]		   ,
V20232.dim_date.[_end_of_month]			 = dim.[_end_of_month]		   ,
V20232.dim_date.[_end_of_quarter]		 = dim.[_end_of_quarter]	   ,
V20232.dim_date.[_end_of_week]			 = dim.[_end_of_week]		   ,
V20232.dim_date.[_end_of_year]			 = dim.[_end_of_year]		   ,
V20232.dim_date.[_iso_weeknumber]		 = dim.[_iso_weeknumber]	   ,
V20232.dim_date.[_month]				 = dim.[_month]				   ,
V20232.dim_date.[_month_name]			 = dim.[_month_name]		   ,
V20232.dim_date.[_month_offset]			 = dim.[_month_offset]		   ,
V20232.dim_date.[_quarter]				 = dim.[_quarter]			   ,
V20232.dim_date.[_start_of_month]		 = dim.[_start_of_month]	   ,
V20232.dim_date.[_start_of_quarter]		 = dim.[_start_of_quarter]	   ,
V20232.dim_date.[_start_of_week]		 = dim.[_start_of_week]		   ,
V20232.dim_date.[_start_of_year]		 = dim.[_start_of_year]		   ,
V20232.dim_date.[_week_of_month]		 = dim.[_week_of_month]		   ,
V20232.dim_date.[_week_of_year]			 = dim.[_week_of_year]		   ,
V20232.dim_date.[_week_offset]			 = dim.[_week_offset]		   ,
V20232.dim_date.[_year]					 = dim.[_year]				   ,
V20232.dim_date.[_year_offset]			 = dim.[_year_offset]		
FROM V20232.dim_date
INNER JOIN dim ON dim._date_id = V20232.dim_date._date_id
 
OPTION (MAXRECURSION 32767)








END
GO

