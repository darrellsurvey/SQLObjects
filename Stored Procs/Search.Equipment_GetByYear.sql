DROP PROCEDURE IF EXISTS [Search].[Equipment_GetByYear];
GO

CREATE PROCEDURE [Search].[Equipment_GetByYear]
(
  @COMPANY nvarchar(20) = '',
	@loginid nvarchar(20) = '',
	@Year int 
)
AS
BEGIN
		SET NOCOUNT ON;
	Declare @SQLstr AS varchar(2000)	
	
	set @SQLstr = 'SELECT e.[ITEMNAME],e.ReportName, EquipmentId = e.[INDEX]
    FROM [LKP].[Equipment] e
      inner join 
      (SELECT ITEMNAME FROM [LKP].[Report_Lookup] a
          inner join 
	      (SELECT  [Report Name] FROM [Billing].[AllOrdersYTD]
	        where zzzCompanyzzz [Year] = ' +  cast(@Year as varchar) +
	        ' group by [Report Name]) b 
      on a.REPORTNAME = b.[Report Name]
	  where REPORTCONTEXT = ''website''
	  group by [ITEMNAME]) d 
  	on e.reportNAME = d.ITEMNAME
	group by e.ItemName, 
 			 e.[REPORTNAME], 
			 e.[ITEMORDER], 
			 e.[INDEX] 
zzzUnionzzz
	order by e.[ITEMNAME]'


	
	IF @COMPANY = 'TAYLORMADE'
		begin
			set @SQLstr = REPLACE(@SQLstr,'zzzUnionzzz', ' UNION SELECT ''Wood - 3 Wood'', ''Wood - 3 Wood'', 999')
		end
	else
		begin
			set @SQLstr = REPLACE(@SQLstr,'zzzUnionzzz', ' ')
		end
	
	IF @COMPANY = 'DARRELL SURVEY'
		begin
			set @SQLstr = REPLACE(@SQLstr,'zzzCompanyzzz', ' ')
		end
	else
		begin
			set @SQLstr = REPLACE(@SQLstr,'zzzCompanyzzz', 'Company = ''' + @COMPANY + ''' and ')
		end


	
	print @SQLstr
    execute (@SQLstr)
    







	/* SET NOCOUNT ON;
	
	IF @COMPANY = 'DARRELL SURVEY'
	BEGIN
	SELECT e.ItemName,
	       e.ReportName,
		     --e.RequiresModel, 
	       EquipmentId = e.[INDEX] 
	       --EquipmentIdWithRequiresModel = CAST(e.[INDEX] AS VARCHAR(10)) + '_' + e.RequiresModel
    FROM [LKP].[Equipment] e
      inner join 
      (SELECT ItemName 
        FROM [LKP].[Report_Lookup] a
        inner join 
	      (SELECT DISTINCT [Report Name] FROM [Billing].[AllOrdersYTD]
	        where [Year] = @Year 
	       ) b 
        on a.REPORTNAME = b.[Report Name]
	      where REPORTCONTEXT = 'website'
	      group by [ItemName]) d 	  
  	  on e.reportNAME = d.ItemName
  	group by e.ItemName, 
	  		e.[REPORTNAME], 
		  	e.[ITEMORDER], 
	  		e.RequiresModel, 
		  	e.[INDEX], 
			  CAST(e.[INDEX] AS VARCHAR(10)) + '_' + e.RequiresModel
	  order by e.ItemName
	END
	
	ELSE
	BEGIN
	SELECT e.ItemName,
	       e.ReportName,
		     --e.RequiresModel, 
	       EquipmentId = e.[INDEX] 
	       --EquipmentIdWithRequiresModel = CAST(e.[INDEX] AS VARCHAR(10)) + '_' + e.RequiresModel
    FROM [LKP].[Equipment] e
      inner join 
      (SELECT ItemName 
        FROM [LKP].[Report_Lookup] a
        inner join 
	      (SELECT DISTINCT [Report Name] FROM [Billing].[AllOrdersYTD]
	        where Company = @COMPANY and [Year] = @Year 
	       ) b 
        on a.REPORTNAME = b.[Report Name]
	      where REPORTCONTEXT = 'website'
	      group by [ItemName]) d 	  
  	  on e.reportNAME = d.ItemName
  	group by e.ItemName, 
	  		e.[REPORTNAME], 
		  	e.[ITEMORDER], 
	  		e.RequiresModel, 
		  	e.[INDEX], 
			  CAST(e.[INDEX] AS VARCHAR(10)) + '_' + e.RequiresModel
	  order by e.ItemName

	END
*/  
END
GO
