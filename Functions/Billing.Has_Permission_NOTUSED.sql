DROP FUNCTION IF EXISTS [Billing].[Has_Permission_NOTUSED];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [Billing].[Has_Permission_NOTUSED]
(
	@COMPANY varchar(50),
	@USER varchar(50),
	@TOUR varchar(15),
	@YEAR varchar(6),
	@TOURNAMENTNAME varchar(75),
	@ITEM varchar(75)
)
RETURNS Integer
AS
BEGIN
	DECLARE @RESULT bit
	DECLARE @VIEW_LVL Integer
/*
	-- ANY permission denied rule will return a denial
	IF (NOT 0 IN (Select permission from Billing.permissions
		WHERE (rule_entity = @COMPANY OR rule_entity = @USER) AND (expires_on > GETDATE() OR expires_on IS NULL)
		AND (rule_item IN (@YEAR, @TOUR, @TOURNAMENTNAME, @ITEM) OR rule_item IS NULL)
		AND (year_applicable = @YEAR OR year_applicable IS NULL)))
	SET @RESULT = 1
		
		
	IF (@RESULT = 1)
		Select TOP 1 @VIEW_LVL = view_lvl from Billing.permissions
		WHERE (rule_entity = @COMPANY OR rule_entity = @USER) AND (expires_on > GETDATE() OR expires_on IS NULL)
		AND (rule_item IN (@YEAR, @TOUR, @TOURNAMENTNAME, @ITEM) OR rule_item IS NULL)
		AND (year_applicable = @YEAR OR year_applicable IS NULL)
		ORDER BY priority DESC, priority_lvl ASC
*/

DECLARE @SID integer
SELECT TOP 1 @SID = SID FROM player_master.tournaments_table WHERE [tournament name] = @TOURNAMENTNAME AND YEAR([First Day]) = @YEAR

SELECT TOP 1 @VIEW_LVL = view_lvl FROM Billing.Permissions
--COALESCE means if it's null, it'll apply to everything, only the user/company cannot be null
WHERE COALESCE(SID, @SID) = @SID
AND (rule_entity = @COMPANY OR rule_entity = @USER)
AND COALESCE(tour, @TOUR) = @TOUR
AND COALESCE(year, @YEAR) = @YEAR
AND COALESCE(report, @ITEM) = @ITEM
ORDER BY priority DESC, priority_lvl ASC

	-- Return the result of the function
	RETURN @VIEW_LVL

END
GO
