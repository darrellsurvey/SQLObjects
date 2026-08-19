DROP PROCEDURE IF EXISTS [Search].[Equipment_GetByDate];
GO

CREATE PROCEDURE [Search].[Equipment_GetByDate]
	@COMPANY nvarchar(20) = '',
	@loginid nvarchar(20) = '',
	@Tour nvarchar(20),
	@FirstDay date,
	@LastDay date
	
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
	Declare @SQLstr AS varchar(2000)	
	
	set @SQLstr = 'SELECT e.[ITEMNAME],e.ReportName,e.RequiresModel,EquipmentId = e.[INDEX], 
           EquipmentIdWithRequiresModel = CAST(e.[INDEX] AS VARCHAR(10)) + ''_'' + e.RequiresModel
    FROM [LKP].[Equipment] e
      inner join 
      (SELECT ITEMNAME FROM [LKP].[Report_Lookup] a
          inner join 
	      (SELECT  [Report Name] FROM [Billing].[AllOrdersYTD]
	        where zzzCompanyzzz [Type] = ''' + @Tour + ''' and [First Day] between ''' + cast(@FirstDay as varchar) + ''' and ''' + cast(@LastDay as varchar) + ''' 
	        group by [Report Name] zzzUnionzzz) b 
      on a.REPORTNAME = b.[Report Name]
	  where REPORTCONTEXT = ''website''
	  group by [ITEMNAME]) d 
  	on e.reportNAME = d.ITEMNAME
	group by e.ItemName, 
 			 e.[REPORTNAME], 
			 e.[ITEMORDER], 
			 e.RequiresModel,	
		     e.[INDEX], 
			 CAST(e.[INDEX] AS VARCHAR(10)) + ''_'' + e.RequiresModel  
	order by e.[ITEMNAME]'


	
	IF @COMPANY = 'MATRIX'
		begin
			set @SQLstr = REPLACE(@SQLstr,'zzzUnionzzz', ' UNION SELECT ''Driver''')
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

END
GO
