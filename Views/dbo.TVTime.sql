DROP VIEW IF EXISTS [dbo].[TVTime];
GO

CREATE VIEW dbo.TVTime
AS
SELECT     Player_Master.TOURNAMENTS_TABLE.TYPE, Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], 
                      TV.TVAudit.Duration, TV.TVAudit.PlayerName, TV.TVAudit.Equip, TV.TVAudit.Brand, TV.TVAudit.Model, TV.TVAudit.Placement, TV.TVAudit.ProAm, TV.TVAudit.Caddie, 
                      TV.TVAudit.ReplayCurrent, TV.TVAudit.ReplayOther, TV.TVAudit.Interview, TV.TVAudit.Round
FROM         TV.TVAudit INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON TV.TVAudit.TntNid = Player_Master.TOURNAMENTS_TABLE.SID AND 
                      TV.TVAudit.TntFirstDay = Player_Master.TOURNAMENTS_TABLE.[FIRST DAY]
GO
