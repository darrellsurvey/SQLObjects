IF OBJECT_ID('dbo.web_get_tourneys') IS NOT NULL
    DROP PROCEDURE [dbo].[web_get_tourneys];
GO

--EXECUTE dbo.web_get_tourneys 'TITLEIST', 'PGA', 2011, 'Charles'

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ==========================================
CREATE PROCEDURE [dbo].[web_get_tourneys]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50),
	@TOUR varchar(20),
	@YEAR int,
	@USERNAME varchar(50)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @COMPANY = 'DARRELL SURVEY'
		SELECT [TOURNAMENT NAME] AS "TOURNAMENT NAME",
				RIGHT('0' + CAST(MONTH([First Day]) as nvarchar), 2) + '/' + RIGHT('0' + CAST(DAY([First Day]) as nvarchar), 2)
					+ ' - ' + [tournament name] AS "NAME AND DATE"
					 /*FROM Player_Master.TOURNAMENTS_TABLE
			LEFT OUTER JOIN (SELECT DISTINCT(REPORTNAME) FROM LKP.Report_Lookup WHERE REPORTITEM = 'Top' AND REPORTCONTEXT = 'Website') b ON 1=1*/
			FROM Billing.AllOrdersYTD
		WHERE YEAR("FIRST DAY") = @YEAR AND "TYPE" = @TOUR
		GROUP BY [TOURNAMENT NAME], [FIRST DAY]
		ORDER BY [FIRST DAY] DESC
		
		/*BEGIN
			SELECT [TOURNAMENT NAME] AS "TOURNAMENT NAME",
				RIGHT('0' + CAST(MONTH([First Day]) as nvarchar), 2) + '/' + RIGHT('0' + CAST(DAY([First Day]) as nvarchar), 2)
					+ ' - ' + [tournament name] AS "NAME AND DATE"
			FROM Player_Master.TOURNAMENTS_TABLE WHERE YEAR("FIRST DAY") = @YEAR AND "TYPE" = @TOUR AND [FIRST DAY] <= GETDATE()
			ORDER BY [FIRST DAY] DESC
		END*/
	ELSE
		/*SELECT [TOURNAMENT NAME] AS "TOURNAMENT NAME",
				RIGHT('0' + CAST(MONTH([First Day]) as nvarchar), 2) + '/' + RIGHT('0' + CAST(DAY([First Day]) as nvarchar), 2)
					+ ' - ' + [tournament name] AS "NAME AND DATE"
					 FROM Player_Master.TOURNAMENTS_TABLE
			LEFT OUTER JOIN (SELECT DISTINCT(REPORTNAME) FROM LKP.Report_Lookup WHERE REPORTITEM = 'Top' AND REPORTCONTEXT = 'Website') b ON 1=1
		WHERE YEAR("FIRST DAY") = @YEAR AND "TYPE" = @TOUR AND [FIRST DAY] <= GETDATE()
		AND Billing.Has_Permission(@COMPANY, @USERNAME, TYPE, YEAR([first day]), [TOURNAMENT NAME], REPORTNAME) > 0
		AND active_flag = 1
		GROUP BY [TOURNAMENT NAME], [FIRST DAY]
		ORDER BY [FIRST DAY] DESC
		BEGIN
			SELECT [TOURNAMENT NAME] AS "TOURNAMENT NAME",
				RIGHT('0' + CAST(MONTH([First Day]) as nvarchar), 2) + '/' + RIGHT('0' + CAST(DAY([First Day]) as nvarchar), 2)
					+ ' - ' + [tournament name] AS "NAME AND DATE"
			FROM Player_Master.TOURNAMENTS_TABLE WHERE YEAR("FIRST DAY") = @YEAR AND "TYPE" = @TOUR AND [FIRST DAY] <= GETDATE()
			ORDER BY [FIRST DAY] DESC
		END*/
		SELECT [TOURNAMENT NAME] AS "TOURNAMENT NAME",
				RIGHT('0' + CAST(MONTH([First Day]) as nvarchar), 2) + '/' + RIGHT('0' + CAST(DAY([First Day]) as nvarchar), 2)
					+ ' - ' + [tournament name] AS "NAME AND DATE"
					 /*FROM Player_Master.TOURNAMENTS_TABLE
					 WHERE YEAR("FIRST DAY") = @YEAR AND "TYPE" = @TOUR AND [FIRST DAY] <= GETDATE() AND active_flag = 1
					 AND ((select SID from Billing.permissions where rule_entity = 'TITLEIST' and year = '2012' and permission = 1 group by SID) IS NULL
					 OR SID IN (select SID from Billing.permissions where rule_entity = 'TITLEIST' and year = '2012' and permission = 1 group by SID))
					 AND ISFLASH <> 2*/
					 FROM Billing.AllOrdersYTD WHERE Company = @COMPANY and Type = @TOUR and year([First Day]) = @YEAR
			GROUP BY [TOURNAMENT NAME], [FIRST DAY]
			ORDER BY [FIRST DAY] DESC
	END
		
	-- execute web_get_tourneys 'TITLEIST', 'PGA', '2012', 'Charles'
	
	-- select * from billing.allordersytd
	
	/*
	
	IF @COMPANY = 'DARRELL'
		BEGIN
			Select b.[TOURNAMENT NAME] AS "TOURNAMENT NAME", RIGHT('0' + CAST(MONTH(a.[First Day]) as nvarchar), 2) + '/' + RIGHT('0' + CAST(DAY(a.[First Day]) as nvarchar), 2) + ' - ' + b.[tournament name] AS "NAME AND DATE"
			 from Billing.AllOrdersYTD a
			LEFT OUTER JOIN Player_Master.TOURNAMENTS_TABLE b ON YEAR(a."FIRST DAY") = YEAR(b."First Day") AND TD = SID
			where b.TYPE = @TOUR AND YEAR(b.[first day]) = @YEAR and b.[Type] IS NOT NULL
			GROUP BY b.[TOURNAMENT NAME], a.[First Day] 
			 order by a.[First Day] DESC 
		
		
		END
	ELSE
		BEGIN
		
		DECLARE @COUNTER AS INT
		
			SELECT @COUNTER = COUNT(*) FROM Player_Master.TOURNAMENTS_TABLE 
				WHERE type  = @TOUR and Billing.has_permission(@COMPANY, '', @TOUR, @YEAR, [Tournament Name], '') = 1
				and [FIRST DAY] <= GETDATE() and YEAR([FIRST DAY]) > YEAR(GETDATE()) -2
				
				
		Select [TOURNAMENT NAME] AS "TOURNAMENT NAME", RIGHT('0' + CAST(MONTH([First Day]) as nvarchar), 2) + '/' + RIGHT('0' + CAST(DAY([First Day]) as nvarchar), 2) + ' - ' + [tournament name] AS "NAME AND DATE"
			FROM Player_Master.TOURNAMENTS_TABLE 
			WHERE type  = @TOUR AND YEAR([first day]) = @YEAR and Billing.has_permission(@COMPANY, '', @TOUR, @YEAR, [Tournament Name], '') = 1
			and [FIRST DAY] <= GETDATE() and YEAR([FIRST DAY]) > YEAR(GETDATE()) -2
			GROUP BY [TOURNAMENT NAME], [First Day]
			ORDER BY [FIRST DAY] DESC
		*/
		
		/*
			IF ((SELECT COUNT(*) FROM Billing.AllOrdersYTD a
			LEFT OUTER JOIN Player_Master.TOURNAMENTS_TABLE b ON YEAR(a."FIRST DAY") = YEAR(b."First Day") AND TD = SID
			where Company = @COMPANY and b.TYPE = @TOUR AND YEAR(b.[first day]) = @YEAR and b.[Type] IS NOT NULL)
			= 0)
			
			SELECT 'Event Not Purchased' as "TOURNAMENT NAME", 'Event Not Purchased' AS "NAME AND DATE"
			
			ELSE
			
			
			Select [TOURNAMENT NAME] AS "TOURNAMENT NAME", RIGHT('0' + CAST(MONTH([First Day]) as nvarchar), 2) + '/' + RIGHT('0' + CAST(DAY([First Day]) as nvarchar), 2) + ' - ' + [tournament name] AS "NAME AND DATE"
			 from Player_Master.TOURNAMENTS_TABLE
			where TYPE = @TOUR AND YEAR([first day]) = @YEAR and [Type] IS NOT NULL
			GROUP BY [TOURNAMENT NAME], [First Day] 
			 order by [First Day] DESC
			
			 
			 
		END
		 */
GO
