






CREATE view [dbo].[datatestrun] as 
SELECT prod.*, new._cnt as _newcnt
  FROM [MiralixStatisticsProd].[dbo].[datatestresult] prod
  JOIN [MiralixStatisticsProd].[dbo].[datatestresult] new on new._dongle = prod._dongle and new._fact = prod._fact and new._yrmth = prod._yrmth
  JOIN [VIEW].[DongleConfig] dc on dc.DongleID = prod._dongle and prod._yrmth > concat(YEAR(lastlicdate),right(concat('00',month(lastlicdate)),2))
  
  where prod._source = 'prod' and prod._yrmth >= 202104 and prod._yrmth < 202403 and new._created = '2024-03-25 14:14:42.810' and convert(date,prod._created) = '2024-03-04' 
  and prod._cnt <> new._cnt 
  --and LEFT(prod._yrmth,4) in ( 2022 )
  and abs(prod._cnt - new._cnt) > 3
  and prod._fact = 'qn'
  and prod._dongle in ( 1887, 2025, 2048, 2121, 2183, 2192, 2217, 2326 ) 
-- and prod._dongle not in ( 1887, 2025, 2048, 2121, 2183, 2192, 2217, 2326 ) 
-- and prod._dongle not  in  (1747,1788,1797,1837,1848,1923,1991,2064,2146,2152,2172, 2185,2196,2236,2239,2253,2265,2270,2275,2321)
--  and prod._dongle not in ( 2128, 2309, 2217, 2146, 2113,1747, 1991, 2232, 2046, 1711, 2057, 1736, 1784, 2152, 2183, 2027, 2025, 2207, 2306, 2048, 2013, 2265, 2010, 1788, 1560, 2138, 2253, 2196, 1996, 2185,
--  2026, 1933, 1785, 2321, 2230, 2121, 2172, 2064, 2236, 2239, 2275, 2021, 2104, 2220, 2252, 2099, 2275, 2307, 1848 
-- )

 --order by _dongle, _yrmth
GO

