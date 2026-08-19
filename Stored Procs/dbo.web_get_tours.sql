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
			SELECT [Type]=[Tour] 
			from Billing.user_levels 
			WHERE [YEAR] >= @YEAR AND username = @loginid 
			GROUP BY TOUR
			order by 
				CASE
				when TOUR = 'PGA' then 1
				when TOUR = 'KORN FERRY' then 2
				when TOUR = 'WEB.COM' then 3
				when TOUR = 'NATIONWIDE' then 4
				when TOUR = 'CHAMPIONS' then 5
				when TOUR = 'LPGA' then 6
				when TOUR = 'JGTO' then 7
				when TOUR = 'JLPGA' then 8
				when TOUR = 'CLPGA' then 9
				when TOUR = 'ONEASIA' then 10
				when TOUR = 'AMATEUR' then 11
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
			SELECT [Type]=[Tour] 
			from Billing.user_levels 
			WHERE [YEAR] = @YEAR AND username = @loginid 
			GROUP BY TOUR
			order by 
				CASE
				when TOUR = 'PGA' then 1
				when TOUR = 'KORN FERRY' then 2
				when TOUR = 'WEB.COM' then 3
				when TOUR = 'NATIONWIDE' then 4
				when TOUR = 'CHAMPIONS' then 5
				when TOUR = 'LPGA' then 6
				when TOUR = 'JGTO' then 7
				when TOUR = 'JLPGA' then 8
				when TOUR = 'CLPGA' then 9
				when TOUR = 'ONEASIA' then 10
				when TOUR = 'AMATEUR' then 11
				else 12
				END	
		end
	
end
GO
