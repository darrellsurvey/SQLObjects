IF OBJECT_ID('dbo.web_get_tours') IS NOT NULL
    DROP PROCEDURE [dbo].[web_get_tours];
GO

-- =============================================
-- Author:		Alex
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ==========================================
CREATE  PROCEDURE [dbo].[web_get_tours]
	@COMPANY varchar(50),
	@loginid varchar(50) = '',
	@YEAR int = 0
	
AS
begin
	SET NOCOUNT ON;
	IF @YEAR = 0 
	begin
		SELECT @YEAR = YEAR(GETDATE()) -2
	
		IF @COMPANY = 'DARRELL SURVEY'
			SELECT [Type]
			from Billing.AllOrdersYTD with (nolock)
			WHERE YEAR([FIRST DAY]) >= @YEAR 
			GROUP BY [Type]
			order by 
				CASE
				when [Type] = 'PGA' then 1
				when [Type] = 'KORN FERRY' then 2
				when [Type] = 'WEB.COM' then 3
				when [Type] = 'NATIONWIDE' then 4
				when [Type] = 'CHAMPIONS' then 5
				when [Type] = 'LPGA' then 6
				when [Type] = 'JGTO' then 7
				when [Type] = 'JLPGA' then 8
				when [Type] = 'CLPGA' then 9
				when [Type] = 'ONEASIA' then 10
				when [Type] = 'AMATEUR' then 11
				else 12
				END
		ELSE
			SELECT [Type]=ul.[Tour]
			from Billing.user_levels ul
			WHERE ul.[YEAR] >= @YEAR AND ul.username = @loginid
			  AND EXISTS (
				  SELECT 1
				  FROM Billing.OrderCompleted oc
				  JOIN Player_Master.TOURNAMENTS_TABLE tt ON tt.TournamentId = oc.TournamentId
				  WHERE oc.CustomerId = ul.CompanyId
					AND COALESCE(oc.[Type], tt.[TYPE]) = ul.[Tour]
					AND COALESCE(oc.[Year], tt.[Year]) >= @YEAR
			  )
			GROUP BY ul.[Tour]
			order by
				CASE
				when ul.[Tour] = 'PGA' then 1
				when ul.[Tour] = 'KORN FERRY' then 2
				when ul.[Tour] = 'WEB.COM' then 3
				when ul.[Tour] = 'NATIONWIDE' then 4
				when ul.[Tour] = 'CHAMPIONS' then 5
				when ul.[Tour] = 'LPGA' then 6
				when ul.[Tour] = 'JGTO' then 7
				when ul.[Tour] = 'JLPGA' then 8
				when ul.[Tour] = 'CLPGA' then 9
				when ul.[Tour] = 'ONEASIA' then 10
				when ul.[Tour] = 'AMATEUR' then 11
				else 12
				END
		END
	else
		begin
			IF @COMPANY = 'DARRELL SURVEY'
			SELECT [Type]
			from Billing.AllOrdersYTD 
			WHERE YEAR([FIRST DAY]) = @YEAR 
			GROUP BY [Type]
			order by 
				CASE
				when [Type] = 'PGA' then 1
				when [Type] = 'KORN FERRY' then 2
				when [Type] = 'WEB.COM' then 3
				when [Type] = 'NATIONWIDE' then 4
				when [Type] = 'CHAMPIONS' then 5
				when [Type] = 'LPGA' then 6
				when [Type] = 'JGTO' then 7
				when [Type] = 'JLPGA' then 8
				when [Type] = 'CLPGA' then 9
				when [Type] = 'ONEASIA' then 10
				when [Type] = 'AMATEUR' then 11
				else 12
				END
		ELSE
			SELECT [Type]=ul.[Tour]
			from Billing.user_levels ul
			WHERE ul.[YEAR] = @YEAR AND ul.username = @loginid
			  AND EXISTS (
				  SELECT 1
				  FROM Billing.OrderCompleted oc
				  JOIN Player_Master.TOURNAMENTS_TABLE tt ON tt.TournamentId = oc.TournamentId
				  WHERE oc.CustomerId = ul.CompanyId
					AND COALESCE(oc.[Type], tt.[TYPE]) = ul.[Tour]
					AND COALESCE(oc.[Year], tt.[Year]) = @YEAR
			  )
			GROUP BY ul.[Tour]
			order by
				CASE
				when ul.[Tour] = 'PGA' then 1
				when ul.[Tour] = 'KORN FERRY' then 2
				when ul.[Tour] = 'WEB.COM' then 3
				when ul.[Tour] = 'NATIONWIDE' then 4
				when ul.[Tour] = 'CHAMPIONS' then 5
				when ul.[Tour] = 'LPGA' then 6
				when ul.[Tour] = 'JGTO' then 7
				when ul.[Tour] = 'JLPGA' then 8
				when ul.[Tour] = 'CLPGA' then 9
				when ul.[Tour] = 'ONEASIA' then 10
				when ul.[Tour] = 'AMATEUR' then 11
				else 12
				END
		end
	
end
GO
