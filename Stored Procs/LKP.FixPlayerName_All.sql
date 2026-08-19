DROP PROCEDURE IF EXISTS [LKP].[FixPlayerName_All];
GO

Create Procedure LKP.FixPlayerName_All
(@Correct as nvarchar(50),
@Wrong as nvarchar(50),
@PrintMessage varchar(1000) OUTPUT)
As
Begin

set nocount on
SET XACT_ABORT ON;

if LEN(@Correct) > 0 and LEN(@Wrong) > 0 
begin
	begin tran
		begin try 
			set @Correct = UPPER(@Correct)
			set @Wrong = UPPER(@Wrong)
		
			UPDATE Player_Master.PLAYERNAMES set playername = @Correct WHERE playername = @Wrong;
			set @PrintMessage = 'PMF.Playernames - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			UPDATE tv.TVAudit set playername = @Correct WHERE playername = @Wrong;	
			set @PrintMessage = @PrintMessage + 'TVAudit - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			UPDATE money.TourMoneyStats set [PLAYER NAME] = @Correct WHERE [PLAYER NAME] = @Wrong;	
			set @PrintMessage = @PrintMessage + 'Money Stats - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			UPDATE [Player_Master].[Playernames_Exceptions] set [Original Name] = @Wrong where [Original Name]= @Correct;
			set @PrintMessage = @PrintMessage + 'NamesExeptions1 - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			UPDATE [Player_Master].[Playernames_Exceptions] set [Database Name] = @Correct where [Database Name]= @Wrong;
			set @PrintMessage = @PrintMessage + 'NamesExeptions2 - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update [dbo].[INPUT_1] set [PLAYER] = @Correct WHERE [Player]= @Wrong;
			set @PrintMessage = @PrintMessage + 'INPUT_1 - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update [INPUT].[All] set playername = @Correct WHERE playername = @Wrong;
			set @PrintMessage = @PrintMessage + 'Input_All - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update [INPUT].[Grip] set playername = @Correct WHERE playername = @Wrong;
			set @PrintMessage = @PrintMessage + 'Input.Grip - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update [INPUT].[Iron] set playername = @Correct WHERE playername = @Wrong;
			set @PrintMessage = @PrintMessage + 'Input.Iron - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update [INPUT].[Putter] set playername = @Correct WHERE playername = @Wrong;
			set @PrintMessage = @PrintMessage + 'Input.Putter - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update [INPUT].[Shaft] set playername = @Correct WHERE playername = @Wrong;
			set @PrintMessage = @PrintMessage + 'Input.Shaft - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update [INPUT].[Wedge] set playername = @Correct WHERE playername = @Wrong;
			set @PrintMessage = @PrintMessage + 'Input.Wedge - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update [INPUT].[Wood] set playername = @Correct WHERE playername = @Wrong;
			set @PrintMessage = @PrintMessage + 'Input.Wood - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update Player_Master.[All] set playername = @Correct WHERE playername = @Wrong;
			set @PrintMessage = @PrintMessage + 'PMF.All - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update Player_Master.[Grip Detail] set [Name] = @Correct WHERE [Name] = @Wrong;
			set @PrintMessage = @PrintMessage + 'PMF.Grip - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update Player_Master.[Iron Detail] set [Name] = @Correct WHERE [Name] = @Wrong;
			set @PrintMessage = @PrintMessage + 'PMF.Iron - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update Player_Master.[Putter Detail] set [Name] = @Correct WHERE [Name] = @Wrong;
			set @PrintMessage = @PrintMessage + 'PMF.Putter - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update Player_Master.[Shaft Detail] set [Name] = @Correct WHERE [Name] = @Wrong;
			set @PrintMessage = @PrintMessage + 'PMF.Shaft - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update Player_Master.[Wedge Detail] set [Name] = @Correct WHERE [Name] = @Wrong;
			set @PrintMessage = @PrintMessage + 'PMF.Wedge - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
			update Player_Master.[Wood Detail] set [Name] = @Correct WHERE [Name] = @Wrong;
			set @PrintMessage = @PrintMessage + 'PMF.Wood - ' + cast(@@ROWCOUNT as varchar(9)) + CHAR(10);
		
			commit tran;
			Set @PrintMessage = @PrintMessage + 'COMMITED from TRY';
		end try
		Begin catch
			if (XACT_STATE()) = -1
				begin
					Set @PrintMessage = @PrintMessage + 'Rolled Back From CATCH';
					Rollback Tran;
				end
			if (XACT_STATE()) = 1
				begin
					commit tran; 
					Set @PrintMessage = @PrintMessage + 'COMMITED from CATCH';
				end
		end catch;
end
else
	begin
		Set @PrintMessage = 'Missing Name. No Updated took place.';
	end
return
end;
GO
