IF OBJECT_ID('TV.Player_Money_TVtime') IS NOT NULL
    DROP PROCEDURE [TV].[Player_Money_TVtime];
GO

CREATE PROCEDURE [TV].[Player_Money_TVtime]
(@FirstDay as date,
 @lastDay as date,
 @PLAYERNAME as nvarchar(50))
AS
BEGIN

SELECT	m.[Official Money],
		ISNULL(m.Tie,'') + isnull(m.Cut,'') + isnull(cast(m.[Finish Position] as nvarchar(3)),'') as [Finish Position],
		sum(tv.[Duration]) as TVTime
      ,m.[Player Name] as PlayerName
      ,t.[Tournament Name] as TntName
      ,t.[First Day] as TntFirstDay
      ,t.[TYPE] as Tour
   FROM [Money].TourMoneyStats  m
  inner join DARRELL_MASTER.Player_Master.TOURNAMENTS_TABLE t
  on m.TournamentId = t.TournamentId
 full outer join [DARRELL_MASTER].[TV].[TVAudit] tv
 on tv.PlayerName = m.[PLAYER NAME] and  tv.TntFirstDay = t.[FIRST DAY]  and tv.TntNid = t.SID
  where t.[first day] between @FirstDay and @lastDay
  and m.[PLAYER NAME] = @PLAYERNAME
  group by m.[Player Name], t.[Tournament Name], t.[First Day],t.[TYPE], m.[Official Money], m.Tie, m.Cut, m.[Finish Position]
order by t.[First Day]


    
END
GO
