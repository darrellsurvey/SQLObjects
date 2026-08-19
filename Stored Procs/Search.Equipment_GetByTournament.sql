IF OBJECT_ID('Search.Equipment_GetByTournament') IS NOT NULL
    DROP PROCEDURE [Search].[Equipment_GetByTournament];
GO

CREATE PROCEDURE [Search].[Equipment_GetByTournament]
	@COMPANY nvarchar(20) = '',
	@loginid nvarchar(20) = '',
	@SID int,
	@Year int
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @COMPANY = 'DARRELL SURVEY'
	BEGIN
	SELECT e.ItemName,
	       e.ReportName,
	       e.RequiresModel, 
	       EquipmentId = e.[INDEX], 
	       EquipmentIdWithRequiresModel = CAST(e.[INDEX] AS VARCHAR(10)) + '_' + e.RequiresModel
    FROM [LKP].[Equipment] e
      inner join 
      (SELECT [ItemName] 
          FROM [LKP].[Report_Lookup] a
          inner join 
	      (SELECT [Report Name] FROM [Billing].[AllOrdersYTD]
	        where year([First Day]) = @Year and TD = @SID
	        group by [Report Name]) b 

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
	end
	
	else
	begin
           
	SELECT e.ItemName,
	       e.ReportName,
		   e.RequiresModel, 
	       EquipmentId = e.[INDEX], 
	       EquipmentIdWithRequiresModel = CAST(e.[INDEX] AS VARCHAR(10)) + '_' + e.RequiresModel
    FROM [LKP].[Equipment] e
      inner join 
      (SELECT ItemName 
          FROM [LKP].[Report_Lookup] a
          inner join 
	      (SELECT [Report Name] FROM [Billing].[AllOrdersYTD]
	        where Company = @COMPANY and year([First Day]) = @Year and TD = @SID
	        group by [Report Name]) b 

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
	
END
GO
