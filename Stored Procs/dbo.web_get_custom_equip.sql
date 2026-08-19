DROP PROCEDURE IF EXISTS [dbo].[web_get_custom_equip];
GO

CREATE PROCEDURE [dbo].[web_get_custom_equip]
	@COMPANY varchar(50) = '',
	@loginid varchar(50) = ''
AS
BEGIN

/*	
	select * from LKP.Report_Lookup WHERE REPORTCONTEXT = 'Website' AND REPORTITEM = 'Custom' ORDER BY REPORTNAME	
*/	
	
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @COMPANY = 'DARRELL SURVEY'
	
	BEGIN
	SELECT 
	  [ReportContext]
      ,[ReportName]
      ,[ReportItem]
      ,[ItemName]
      ,[ItemOrder]
	FROM LKP.Report_Lookup 
	WHERE REPORTCONTEXT = 'Website' AND REPORTITEM = 'Custom' 
	ORDER BY REPORTNAME
	end
	else
	begin
           
    SELECT c.[ReportContext]
      ,c.[ReportName]
      ,c.[ReportItem]
      ,c.[ItemName]
      ,c.[ItemOrder]
    FROM [LKP].[Report_Lookup] c
      inner join 
      (SELECT (case [ITEMNAME] 
			when 'Driver' then 'Drivers'
			when 'Fairway no Hyb' then 'Fairway Woods'
			when 'Hybrid Woods' then 'Hybrids'
			when 'Iron' then 'Irons'
			when 'Iron Shaft Brand' then 'Iron Shafts'
			when 'Wood Shaft Brand' then 'Wood Shafts'
			when 'Iron Grip Brand' then 'Iron Grips'
			when 'Putter Grip Brand' then 'Putter Grips'
			when 'Wood Grip Brand' then 'Wood Grips'
			else [ITEMNAME]
			end) as ITEMNAME 
          FROM [LKP].[Report_Lookup] a
          inner join 
	      (SELECT Company, [Report Name], COUNT([Report Name]) as times
	        FROM [Billing].[AllOrdersYTD]
	        where Company = @COMPANY
	        group by Company, [Report Name]
	        having COUNT([Report Name]) > 2) b 

      on a.REPORTNAME = b.[Report Name]
	  where Company = @COMPANY and REPORTCONTEXT = 'website'
	  group by [ITEMNAME]) d 
	  
  	on c.reportNAME = d.ITEMNAME
	where c.REPORTITEM = 'Custom' and c.REPORTCONTEXT = 'website'
	group by c.[REPORTCONTEXT]
		  ,c.[REPORTNAME]
		  ,c.[REPORTITEM]
		  ,c.[ITEMNAME]
		  ,c.[ITEMORDER]
	  
	end



END
GO
