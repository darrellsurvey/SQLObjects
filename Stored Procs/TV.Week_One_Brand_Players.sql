IF OBJECT_ID('TV.Week_One_Brand_Players') IS NOT NULL
    DROP PROCEDURE [TV].[Week_One_Brand_Players];
GO

CREATE PROCEDURE [TV].[Week_One_Brand_Players]
(@Year int,
 @SID int,
 @Brand varchar(50))
AS
BEGIN


SELECT sum([Duration]) as RoundTime
	  ,(SELECT sum([Duration]) FROM [DARRELL_MASTER].[TV].[TVAudit] z
			where TntNid = @SID and YEAR([TntFirstDay]) = @year and z.Brand = @Brand
			and z.PlayerName = a.PlayerName) as TotalTime
      ,[Brand]
      ,[Round]
      ,TntName
      ,PlayerName
      ,isnull(coalesce(m.Cut, m.Tie),'') + convert(nvarchar,m.[Finish Position]) as Finish
      ,m.[Official Money]
  FROM [DARRELL_MASTER].[TV].[TVAudit] a
  inner join Player_Master.TOURNAMENTS_TABLE tt
  on a.TntNid = tt.SID and a.TntFirstDay = tt.[FIRST DAY]
  left join [Money].[TourMoneyStats] m
  on tt.TournamentId = m.TournamentId and a.PlayerName = m.[PLAYER NAME]
  where TntNid = @SID and YEAR([TntFirstDay]) = @year and a.Brand = @Brand
  group by Brand, [Round], TntName ,PlayerName, [Official Money],
  isnull(coalesce(m.Cut, m.Tie),'') + convert(nvarchar,m.[Finish Position])
  order by TotalTime desc, PlayerName
  
END
GO
