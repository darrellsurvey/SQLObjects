DROP PROCEDURE IF EXISTS [dbo].[MonthlyBilling_sp];
GO

CREATE PROCEDURE [dbo].[MonthlyBilling_sp]
(@Year int,
 @Month int)
AS
BEGIN

SELECT a.[Company]
      ,a.[Type]
      ,a.[Tournament Name]
      ,CONVERT(varchar(8),a.[first day],1) as [First Day]
      ,a.[Report Name]
      ,b.[times]
  FROM [DARRELL_MASTER].[Billing].[AllOrdersYTD] a 
  inner join 
  (select Company, [Type], [Report Name], count([report name]) as [times] 
   from [DARRELL_MASTER].[Billing].[AllOrdersYTD]
   where Year([First Day])= @Year
     and Month([First Day])= @Month
   group by Company, [Type], [Report Name]) b
    on a.company = b.Company and a.[type]=b.[Type] 
    and a.[Report Name]=b.[Report Name]
  where Year([First Day])= @Year
    and Month([First Day])= @Month 
  group by a.Company, a.[Type], a.[First Day],a.[Tournament Name], a.[Report Name], b.times
  order by Company,
  (case 
  when a.[Type] = 'PGA' then 0
  when a.[Type] = 'Champions' then 1
  when a.[Type] = 'LPGA' then 2
  when a.[Type] = 'Amateur' then 3
  when a.[Type] = 'Web.com' then 4
  when a.[Type] = 'JGTO' then 5
  when a.[Type] = 'JLPGA' then 6
  when a.[Type] = 'OneAsia' then 7
  when a.[Type] = 'CLPGA' then 8
  when a.[Type] = 'Latinoamerica' then 9
  end), 
  [Report Name], [First Day]
  
END
GO
