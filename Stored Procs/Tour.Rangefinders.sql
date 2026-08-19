DROP PROCEDURE IF EXISTS [Tour].[Rangefinders];
GO

CREATE PROCEDURE [Tour].[Rangefinders]
(@TournamentId as int)
AS
BEGIN

SELECT p.[SID]
      ,p.[TOUR]
      ,p.[TOURNAMENT NAME]
      ,p.[FIRST DAY]
      ,p.[LAST DAY]
      ,p.[PLAYERNAME]
      ,p.[BRAND] as PlayerBrand
      ,c.BRAND  as CaddieBrand
      ,p.[TournamentId]
  FROM [DARRELL_MASTER].[dbo].[RangefindersPlayer] p
  left outer join
  [DARRELL_MASTER].[dbo].[RangefindersCaddie] c
  on p.[TournamentId] = c.[TournamentId] and
 	 p.playername = c.playername
 where p.TournamentId = @TournamentId



    
END
GO
