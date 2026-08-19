IF OBJECT_ID('dbo.viewer_get_tourneys') IS NOT NULL
    DROP PROCEDURE [dbo].[viewer_get_tourneys];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ==========================================
CREATE PROCEDURE [dbo].[viewer_get_tourneys]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50),
	@TOUR varchar(20),
	@YEAR int --,
	--@USERNAME varchar(100)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @COMPANY = 'DARRELL SURVEY'
	
	BEGIN
		Select b.[TOURNAMENT NAME] AS [TOURNAMENT NAME], RIGHT('0' + CAST(MONTH(a.[First Day]) as nvarchar), 2) + '/' + RIGHT('0' + CAST(DAY(a.[First Day]) as nvarchar), 2) + ' - ' + b.[tournament name] AS [NAME AND DATE]
		from Billing.AllOrdersYTD a
		LEFT OUTER JOIN Player_Master.TOURNAMENTS_TABLE b ON YEAR(a.[FIRST DAY]) = YEAR(b.[First Day]) AND TD = SID
		where b.TYPE = @TOUR AND YEAR(b.[first day]) = @YEAR and b.[Type] IS NOT NULL AND ISFLASH = 0
		GROUP BY b.[TOURNAMENT NAME], a.[First Day] 
		order by a.[First Day] DESC ;
	end 
	else
	begin
		Select b.[TOURNAMENT NAME] AS [TOURNAMENT NAME], RIGHT('0' + CAST(MONTH(a.[First Day]) as nvarchar), 2) + '/' + RIGHT('0' + CAST(DAY(a.[First Day]) as nvarchar), 2) + ' - ' + b.[tournament name] AS [NAME AND DATE]
		from Billing.AllOrdersYTD a
		LEFT OUTER JOIN Player_Master.TOURNAMENTS_TABLE b ON YEAR(a.[FIRST DAY]) = YEAR(b.[First Day]) AND TD = SID
		where Company = @COMPANY and b.TYPE = @TOUR AND YEAR(b.[first day]) = @YEAR and b.[Type] IS NOT NULL AND ISFLASH = 0
		GROUP BY b.[TOURNAMENT NAME], a.[First Day] 
		order by a.[First Day] DESC ;
	end
end

/*		
Select b.[TOURNAMENT NAME] AS [TOURNAMENT NAME], RIGHT('0' + CAST(MONTH(a.[First Day]) as nvarchar), 2) + '/' + RIGHT('0' + CAST(DAY(a.[First Day]) as nvarchar), 2) + ' - ' + b.[tournament name] AS [NAME AND DATE]
 from Billing.AllOrdersYTD a
LEFT OUTER JOIN Player_Master.TOURNAMENTS_TABLE b ON YEAR(a.[FIRST DAY]) = YEAR(b.[First Day]) AND TD = SID
where Company = @COMPANY and b.TYPE = @TOUR AND YEAR(b.[first day]) = @YEAR and b.[Type] IS NOT NULL AND ISFLASH = 0
GROUP BY b.[TOURNAMENT NAME], a.[First Day] 
 order by a.[First Day] DESC ;
*/





-- execute dbo.viewer_get_tourneys 'TITLEIST', 'AMATEUR', 2011


-- select * from player_master.tournaments_table order by [first day] desc
GO
