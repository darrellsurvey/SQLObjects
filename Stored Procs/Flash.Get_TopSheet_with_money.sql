DROP PROCEDURE IF EXISTS [Flash].[Get_TopSheet_with_money];
GO

-- =============================================

-- Author:		Alex

-- Create date: 3/18/2014

-- Description:	Top 10 finishers Club repor counts 

--              (Titleist wanted to order data just on top10 players and not the whole field

-- =============================================

CREATE PROCEDURE [Flash].[Get_TopSheet_with_money]

	-- Add the parameters for the stored procedure here

	@COMPANY varchar(50),

	@TOURNAMENTNAME varchar(60),

	@FIRSTDAY varchar(15),

	@REPORTNAME varchar(35)

	

	--EXECUTE flash.get_topsheet 'TITLEIST', 'The Masters', '4/7/2011', 'Balls'

	

AS

BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT ON;



--DECLARE @FIRSTDAY DATE;

DECLARE @SID INT;

DECLARE @TournamentID INT;



--checks that it is a valid candidate for a flash report first

IF (SELECT ISFLASH FROM Player_master.[TOURNAMENTS_TABLE] WHERE "TOURNAMENT NAME" = @TOURNAMENTNAME AND [FIRST DAY] = @FIRSTDAY) <> 1 RETURN;

SELECT TOP 1 @SID = SID, @TournamentID = TournamentID FROM Player_master.[TOURNAMENTS_TABLE] WHERE "TOURNAMENT NAME" = @TOURNAMENTNAME AND [FIRST DAY] = @FIRSTDAY;



declare @TableName as varchar(max)

declare @Where as varchar(50)



IF (@REPORTNAME = 'Driver')

	begin

		set @TableName = '[Input].[Wood]'

		Set @Where = ' and ISDRIVER = 1 '

	end

ELSE IF (@REPORTNAME = 'All Woods')

	begin

		set @TableName = '[Input].[Wood]'

		Set @Where = ''

	end		

ELSE IF (@REPORTNAME = 'Fairway Including Hybrid')

	begin

		set @TableName = '[Input].[Wood]'

		Set @Where = ' and ISDRIVER = 0 '

	end	

ELSE IF (@REPORTNAME = 'Fairway wo Hybrid')

	begin

		set @TableName = '[Input].[Wood]'

		Set @Where = ' and ISDRIVER = 0 and [CLUBCODE] <> ''HYB'''

	end	

ELSE IF (@REPORTNAME = 'Hybrid Woods')

	begin

		set @TableName = '[Input].[Wood]'

		Set @Where = ' and [CLUBCODE] = ''HYB'''

	end	

ELSE IF (@REPORTNAME = 'Iron')

	begin

		set @TableName = '(SELECT PLAYERNAME, 

								BRAND as BRAND,

								[FIRST DAY],

								[SID],

								ISSET 

							FROM Input.[Iron] 

							WHERE SID = ''' + cast(@SID as varchar(4)) + 

							''' AND [First Day] = ''' + 

							cast(@FIRSTDAY as varchar(10)) + ''' and isset = 1 

							group by PLAYERNAME, BRAND, [FIRST DAY], [SID], ISSET )'

		Set @Where = ''

	end	

ELSE IF (@REPORTNAME = 'Utility Iron')

	begin

		set @TableName = '[Input].[Iron]'

		Set @Where = ' and CLUBCODE LIKE ''%^%'''

	end	

ELSE IF (@REPORTNAME = 'Putter')

	begin

		set @TableName = '[Input].[Putter]'

		Set @Where = ''

	end	

ELSE IF (@REPORTNAME = 'All Wedges (Including PW)')

	begin

		set @TableName = '[Input].[Wedge]'

		Set @Where = ''

	end	     

ELSE IF (@REPORTNAME = 'Pitching Wedge')

	begin

		set @TableName = '[Input].[Wedge]'

		Set @Where = ' and CLUBCODE = ''PW'''

	end	

ELSE IF (@REPORTNAME = 'All Wedges (Excl. PW) AW,GW,SW,LW')

	begin

		set @TableName = '[Input].[Wedge]'

		Set @Where = ' and CLUBCODE <> ''PW'''

	end	

ELSE



declare @SQLString as varchar(Max)

set @SQLString = 'SELECT  [Mfgr Descr] AS Brand, 

						  COUNT([Mfgr Descr]) AS Count,

						  sum(COUNT([Mfgr Descr])) over() AS TOTAL

				  FROM ' + @TableName + ' b

				  inner join (SELECT [PLAYER NAME]

								FROM [DARRELL_MASTER].[Money].[TourMoneyStats]

								where [Finish Position] < 11 and

								tournamentid = ' + cast(@TournamentID as varchar(4)) + ') n 

					 on b.PLAYERNAME = n.[PLAYER NAME] 

				  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a 

						  ON BRAND = [Mfgr Descr]

				  WHERE [FIRST DAY] = ''' + cast(@FIRSTDAY as varchar(10)) + ''' AND 

						  [SID] = ' + cast(@SID as varchar(4)) + @Where +

				  ' GROUP BY [Mfgr Descr]

				  ORDER BY COUNT([Mfgr Descr]) DESC, [Mfgr Descr] ASC'

 

print @SQLString 

exec(@SQLString)

 

--dummy select to set ourput variables for crystal reports

SELECT 'TITLEISTTITLEISTTITLEISTTITLEIST' AS Brand, 34 as "Count", 12 as "%" WHERE 1=0;



END
GO
