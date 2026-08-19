IF OBJECT_ID('dbo.MoneyStats') IS NOT NULL
    DROP VIEW [dbo].[MoneyStats];
GO

CREATE VIEW dbo.MoneyStats
AS
SELECT        Player_Master.TOURNAMENTS_TABLE.TournamentId, Player_Master.TOURNAMENTS_TABLE.SID, Player_Master.TOURNAMENTS_TABLE.TYPE, 
                         Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], dbo.Ball.PLAYERNAME, 
                         dbo.Ball.BRAND + N'; ' + dbo.Ball.MODEL AS Ball, LTRIM(ISNULL(m.Tie, N'')) + LTRIM(ISNULL(m.Cut, N'')) + LTRIM(ISNULL(CAST(m.[Finish Position] AS nvarchar(3)), 
                         N'')) AS Place, m.[Tour Ranking], m.[Money YTD], m.Tie, m.Cut, m.[Finish Position], m.[Round 1], m.[Round 2], m.[Round 3], m.[Round 4], m.[Round 5], m.[Total Score], 
                         m.[Official Money], m.[Driving Accuracy], m.[Driving Distance], m.[Greens in Reg], m.[Putting Avg], m.[Sand Save], m.[Total Fwys Hit], m.[Total Driving Distance], 
                         m.[Total Drives], m.[Total Fwys Played], m.[Total GIRs], m.[Total GIR Putts], m.[Total Traps Hit], m.[Total Sand Saves], m.[Total Eagles], m.[Total Birdies], 
                         m.[Holes Played], Player_Master.TOURNAMENTS_TABLE.PGASeason
FROM            dbo.Ball INNER JOIN
                         Player_Master.TOURNAMENTS_TABLE ON dbo.Ball.TournamentId = Player_Master.TOURNAMENTS_TABLE.TournamentId FULL OUTER JOIN
                         Money.TourMoneyStats AS m ON dbo.Ball.TournamentId = dbo.Ball.TournamentId AND dbo.Ball.PLAYERNAME = m.[PLAYER NAME] AND 
                         dbo.Ball.TournamentId = m.TournamentId
GO
