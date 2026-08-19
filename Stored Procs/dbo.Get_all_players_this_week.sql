DROP PROCEDURE IF EXISTS [dbo].[Get_all_players_this_week];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_all_players_this_week]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
select PLAYERNAME, [TOURNAMENT NAME] from Player_Master.[all] a
LEFT OUTER JOIN Player_Master.TOURNAMENTS_TABLE b on a.SID = b.SID and a.[FIRST DAY] = b.[FIRST DAY]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c on BAGBRAND = c.[Mfgr Code]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] d on HEADGEARBRAND = d.[Mfgr Code]
where YEAR(a.[FIRST DAY]) = YEAR(getdate()) 
and DATEDIFF(DAY, a.[FIRST DAY], GETDATE())  BETWEEN 0 and 7
GROUP BY PLAYERNAME, [TOURNAMENT NAME]
ORDER BY [TOURNAMENT NAME], PLAYERNAME;


END
GO
