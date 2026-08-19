IF OBJECT_ID('dbo.Get_TopSheet_with_money') IS NOT NULL
    DROP PROCEDURE [dbo].[Get_TopSheet_with_money];
GO

CREATE PROCEDURE [dbo].[Get_TopSheet_with_money]

	-- Add the parameters for the stored procedure here

	@COMPANY varchar(50),

	@TOURNAMENTNAME varchar(60),

	@FIRSTDAY varchar(15),

	@REPORTNAME varchar(35)

	

	

AS

BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT ON;



DECLARE @TournamentID Int;

DECLARE @SID INT;



SELECT TOP 1 @SID = SID, @TournamentID = TournamentID FROM [Player_Master].[TOURNAMENTS_TABLE] WHERE [TOURNAMENT NAME] = @TOURNAMENTNAME AND [FIRST DAY] = @FIRSTDAY;



declare @TableName as varchar(max)

declare @Where as varchar(50)

declare @TableField as varchar(50)



IF (@REPORTNAME = 'Driver')

	begin

		set @TableName = '[Player_Master].[Wood Detail]'

		set @TableField = '[Wood Brand Code]'

		Set @Where = ' and ISDRIVER = 1 '

	end

ELSE IF (@REPORTNAME = 'All Woods')

	begin

		set @TableName = '[Player_Master].[Wood Detail]'

		set @TableField = '[Wood Brand Code]'

		Set @Where = ''

	end		

ELSE IF (@REPORTNAME = 'Fairway Including Hybrid')

	begin

		set @TableName = '[Player_Master].[Wood Detail]'

		set @TableField = '[Wood Brand Code]'

		Set @Where = ' and ISDRIVER = 0 '

	end	

ELSE IF (@REPORTNAME = 'Fairway wo Hybrid')

	begin

		set @TableName = '[Player_Master].[Wood Detail]'

		set @TableField = '[Wood Brand Code]'		

		Set @Where = ' and ISDRIVER = 0 and [CLUBCODE] <> ''HYB'''

	end	

ELSE IF (@REPORTNAME = 'Hybrid Woods')

	begin

		set @TableName = '[Player_Master].[Wood Detail]'

		set @TableField = '[Wood Brand Code]'		

		Set @Where = ' and [CLUBCODE] = ''HYB'''

	end	

ELSE IF (@REPORTNAME = 'Iron')

	begin

		set @TableName = '(SELECT NAME, 

								[Iron Brand Code],

								[FIRST DAY],

								[Survey ID],

								ISSET 

							FROM [Player_Master].[Iron Detail] 

							WHERE [Survey ID] = ''' + cast(@SID as varchar(4)) + 

							''' AND [First Day] = ''' + 

							cast(@FIRSTDAY as varchar(10)) + ''' and isset = 1 

							group by NAME, [Iron Brand Code], [FIRST DAY], [Survey ID], ISSET )'

		set @TableField = '[Iron Brand Code]'							

		Set @Where = ''

	end	

ELSE IF (@REPORTNAME = 'Utility Iron')

	begin

		set @TableName = '[Player_Master].[Iron Detail]'

		set @TableField = '[Iron Brand Code]'		

		Set @Where = ' and CLUBCODE LIKE ''%^%'''

	end	

ELSE IF (@REPORTNAME = 'Putter')

	begin

		set @TableName = '[Player_Master].[Putter Detail]'

		set @TableField = '[Putter Brand Code]'		

		Set @Where = ''

	end	

ELSE IF (@REPORTNAME = 'All Wedges (Including PW)')

	begin

		set @TableName = '[Player_Master].[Wedge Detail]'

		set @TableField = '[Wedge Brand Code]'		

		Set @Where = ''

	end	     

ELSE IF (@REPORTNAME = 'Pitching Wedge')

	begin

		set @TableName = '[Player_Master].[Wedge Detail]'

		set @TableField = '[Wedge Brand Code]'				

		Set @Where = ' and CLUBCODE = ''PW'''

	end	

ELSE IF (@REPORTNAME = 'All Wedges (Excl. PW) AW,GW,SW,LW')

	begin

		set @TableName = '[Player_Master].[Wedge Detail]'

		set @TableField = '[Wedge Brand Code]'				

		Set @Where = ' and CLUBCODE <> ''PW'''

	end	



      

 

declare @SQLString as varchar(Max) 

set @SQLString = 'SELECT  [Mfgr Descr] AS Brand, 

						  COUNT([Mfgr Descr]) AS Count,

						  sum(COUNT([Mfgr Descr])) over() AS TOTAL

				  FROM ' + @TableName + ' b

				  inner join (SELECT [PLAYER NAME]

								FROM [DARRELL_MASTER].[Money].[TourMoneyStats]

								where [Finish Position] < 11 and

								tournamentid = ' + cast(@TournamentID as varchar(4)) + ') n 

					 on b.[Name] = n.[PLAYER NAME] 

				  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a 

						  ON ' + @TableField + ' = [Mfgr Code]

				  WHERE [FIRST DAY] = ''' + cast(@FIRSTDAY as varchar(10)) + ''' AND 

						  [Survey ID] = ' + cast(@SID as varchar(4)) + @Where +

				  ' GROUP BY [Mfgr Descr]

				  ORDER BY COUNT([Mfgr Descr]) DESC, [Mfgr Descr] ASC' 

 

print @SQLString 

exec(@SQLString) 

 

--dummy select to set ourput variables for crystal reports

SELECT 'TITLEISTTITLEISTTITLEISTTITLEIST' AS Brand, 34 as [Count], 12 as [%] WHERE 1=0;



     







END
GO
