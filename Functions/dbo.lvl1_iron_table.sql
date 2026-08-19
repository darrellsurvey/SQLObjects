DROP FUNCTION IF EXISTS [dbo].[lvl1_iron_table];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[lvl1_iron_table] 
(	
	@FIRSTDAY date,
	@SID int,
	@COMPANY_CODE int
)
RETURNS TABLE 
AS
RETURN 
(

SELECT a.PKey, a.Name, a.[Survey ID], a.[First Day], a.ISSET, [Iron Equip Type], [Iron Club Code], DCLUBCODE,
[Iron Brand Code], DBRANDCODE,
[Iron Model Code], DMODELCODE,
[Iron Type Code], DTYPECODE,
[Iron Mat'l Code], DMATERIAL,
[Iron Size Code], DSIZECODE,
row_number() OVER(ORDER BY [Name], [PKey]) AS ROW_ORDER
FROM Player_Master.[Iron Detail] a
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON a.[Iron Brand Code] = b.[Mfgr Code]
WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID 







)




--  select * from [Media].[base_report]('8/4/2011', 648) ORDER BY row_order


-- select * from [dbo].[lvl1_report]('8/4/2011', 648) ORDER BY row_order
GO
