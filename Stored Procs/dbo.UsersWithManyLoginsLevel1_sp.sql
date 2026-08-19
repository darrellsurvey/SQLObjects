IF OBJECT_ID('dbo.UsersWithManyLoginsLevel1_sp') IS NOT NULL
    DROP PROCEDURE [dbo].[UsersWithManyLoginsLevel1_sp];
GO

CREATE PROCEDURE [dbo].[UsersWithManyLoginsLevel1_sp]
(
  @BeginDateTime datetime = null,
  @EndDateTime   datetime = null
)
AS
BEGIN

  SET NOCOUNT ON

  DECLARE @DateTimeNow datetime = GETDATE()
  IF (@BeginDateTime is null) SET @BeginDateTime = dateadd(d,-15,@DateTimeNow)
  IF (@EndDateTime is null)   SET @EndDateTime = @DateTimeNow 

  CREATE TABLE #Users 
  (
  Company varchar(35),
  --UserName varchar(25),
  --FirstName varchar(20),
  --LastName varchar(30),
  --EmailAddress varchar(50),
  IPAddress varchar(30),
  CountDistinctIPAddress integer,
  Region varchar(300)
  )

  INSERT #Users
  (
  company,
  IPAddress, 
  CountDistinctIPAddress 
  )
  SELECT i.COMPANY,
         wl.[IP_ADDRESS],
         count(wl.[IP_ADDRESS])
    FROM web.Log_website wl with (nolock)
    INNER JOIN web.Login_info i
      ON wl.UserName = i.UserName 

    WHERE log_time between @BeginDateTime  and  @EndDateTime 

    and (LOG_EVENT='login' OR LOG_EVENT='loginmobile' 
         OR LOG_EVENT = 'frontpage')
    and wl.USERNAME <> '' 

  GROUP BY COMPANY, [IP_ADDRESS]
  --HAVING count(data.IPSegment) >= 5
  --ORDER BY count(data.IPSegment) DESC

  SELECT * FROM #Users
  Order by #Users.Company  
    
  --UPDATE #Users
  --SET 
  --  --FirstName = web.Login_info.[First Name],
  --  --LastName = web.Login_info.[Last Name],
  --  --Name = COALESCE(#Users.FirstName,' ') + ' ' + COALESCE(#Users.LastName,' ') ,
  --  Company = web.Login_info.COMPANY,
  --  --EmailAddress = web.Login_info.EMAIL 
  --FROM #Users INNER JOIN web.Login_info
  --  ON #Users.UserName = web.Login_info.UserName 

  --SELECT * FROM #Users

  UPDATE #Users
  SET 
    Region = (SELECT [CountryShortName]+'_'+[Region]+'_'+[City]+'_'+[ZipCode]
			  FROM LKP.GeoIPAddress with (nolock)
			  WHERE LKP.GeoIPAddress.IpNumberFrom <= LKP.IPNumber_fn(#Users.IPADDRESS)
			  and LKP.IPNumber_fn(#Users.IPADDRESS) <= LKP.GeoIPAddress.IpNumberTo
			  )


  --return results
  SELECT * 
  FROM #Users
  ORDER BY 
    #Users.Company  
    


/*----------------------------------------------

SELECT  i.COMPANY, i.[FIRST NAME], i.[LAST NAME]
      ,w.[IP_ADDRESS]
      ,count(w.[IP_ADDRESS])
      ,Region = (SELECT [CountryShortName]+'_'+[Region]+'_'+[City]+'_'+[ZipCode]
			  FROM LKP.GeoIPAddress with (nolock)
			  WHERE LKP.GeoIPAddress.IpNumberFrom <= LKP.IPNumber_fn(w.IP_ADDRESS)
			  and LKP.IPNumber_fn(w.IP_ADDRESS) <= LKP.GeoIPAddress.IpNumberTo
			  )
FROM  web.Log_website w INNER JOIN
      web.Login_info i 
      ON w.USERNAME = i.USERNAME 
  
  where LOG_TIME between '4/10/2013' and '4/17/2013' and LOG_EVENT = 'frontpage'
  /*and IP_ADDRESS not in ('173.196.137.178',
								'12.188.94.130',
								'142.129.54.232', 
								'67.191.128.79', 
								'98.173.93.143', 
								'174.254.91.166',
								'76.173.246.125', 
								'76.170.228.97',
								'99.182.21.10', 
								'99.182.22.102', 
								'64.60.83.66',
								'166.205.55.16',
								'170.170.59.139',
								'170.170.59.138',
								'166.205.55.16',
								'166.205.55.20',
								'198.228.228.170',
								'108.184.241.98')  */
								
  group by i.COMPANY, i.[FIRST NAME], i.[LAST NAME]
      ,[IP_ADDRESS]
  order by i.COMPANY, i.[LAST NAME]
      ,count([IP_ADDRESS])
      
      
*/





END
GO
