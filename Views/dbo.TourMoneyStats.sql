DROP VIEW IF EXISTS [dbo].[TourMoneyStats];
GO

CREATE VIEW dbo.TourMoneyStats
AS
SELECT     Player_Master.TOURNAMENTS_TABLE.TournamentId, Player_Master.TOURNAMENTS_TABLE.TYPE, Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], 
                      Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], TourMoneyStats_1.[PLAYER NAME], TourMoneyStats_1.[Tour Ranking], 
                      TourMoneyStats_1.[Money YTD], TourMoneyStats_1.Tie, TourMoneyStats_1.Cut, TourMoneyStats_1.[Finish Position], TourMoneyStats_1.[Round 1], 
                      TourMoneyStats_1.[Round 2], TourMoneyStats_1.[Round 3], TourMoneyStats_1.[Round 4], TourMoneyStats_1.[Round 5], TourMoneyStats_1.[Total Score], 
                      TourMoneyStats_1.[Official Money], TourMoneyStats_1.[Driving Accuracy], TourMoneyStats_1.[Driving Distance], TourMoneyStats_1.[Greens in Reg], 
                      TourMoneyStats_1.[Putting Avg], TourMoneyStats_1.[Sand Save], TourMoneyStats_1.[Total Fwys Hit], TourMoneyStats_1.[Total Driving Distance], 
                      TourMoneyStats_1.[Total Drives], TourMoneyStats_1.[Total Fwys Played], TourMoneyStats_1.[Total GIRs], TourMoneyStats_1.[Total GIR Putts], 
                      TourMoneyStats_1.[Total Traps Hit], TourMoneyStats_1.[Total Sand Saves], TourMoneyStats_1.[Total Eagles], TourMoneyStats_1.[Total Birdies], 
                      TourMoneyStats_1.[Holes Played], Player_Master.TOURNAMENTS_TABLE.PGASeason
FROM         Money.TourMoneyStats AS TourMoneyStats_1 INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON TourMoneyStats_1.TournamentId = Player_Master.TOURNAMENTS_TABLE.TournamentId
GO
