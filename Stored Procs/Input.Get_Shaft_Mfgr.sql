DROP PROCEDURE IF EXISTS [Input].[Get_Shaft_Mfgr];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Input].[Get_Shaft_Mfgr]
	-- Add the parameters for the stored procedure here
@MFGRDESCR nvarchar(40),
@EQUIPTYPE nvarchar(4)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

SELECT COUNT(b.[Mfgr Descr]) AS MFGRCOUNT, b.[Mfgr Descr] AS MFGR, a.[Mfgr Descr] AS BRAND
from Player_Master.[Shaft Detail]
LEFT OUTER JOIN
LKP.[Manufacturer Codes and Desc] a ON [Shaft Brand Code] = a.[Mfgr Code]
LEFT OUTER JOIN
LKP.[Manufacturer Codes and Desc] b ON [Shaft Mfgr Code] = b.[Mfgr Code]
where YEAR([first day]) >= YEAR(GETDATE()) -1 and [Shaft Equip Type] = @EQUIPTYPE
and a.[Mfgr Descr] = @MFGRDESCR
GROUP BY b.[Mfgr Descr], a.[Mfgr Descr]
ORDER BY COUNT(b.[Mfgr Descr]) DESC


END
GO
