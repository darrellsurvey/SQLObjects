IF OBJECT_ID('Tour.Rangefinders-Flash') IS NOT NULL
    DROP PROCEDURE [Tour].[Rangefinders-Flash];
GO

create PROCEDURE [Tour].[Rangefinders-Flash]
(@TournamentId as int)
AS
BEGIN

SELECT p.[SID]
      ,t.[TYPE] as TOUR
      ,t.[TOURNAMENT NAME]
      ,t.[FIRST DAY]
      ,t.[LAST DAY]
      ,p.[PLAYERNAME]
      ,[RANGEPLAYERBRAND] as PlayerBrand
      ,NULL as CaddieBrand
      ,t.[TournamentId]
  FROM [Input].[All] p
  inner join [Player_Master].[TOURNAMENTS_TABLE] t on p.SID = t.SID and p.[FIRST DAY] = t.[FIRST DAY]
  where t.TournamentId = @TournamentId



    
END
GO
