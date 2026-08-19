DROP PROCEDURE IF EXISTS [LKP].[Fix_ChangeModelName];
GO

-- =============================================
-- Author:		Alex R.
-- Create date: 11/1/2013
-- Description:	Changes Model Names when fixing incorrect spell
-- =============================================
CREATE PROCEDURE [LKP].[Fix_ChangeModelName]
	@Correct nvarchar(50),
	@Wrong nvarchar(50),
	@WrongCode nvarchar(50),
	@Brand nvarchar(50)
AS
BEGIN

--exec [LKP].[Fix_ChangeModelName] 'DASH PRO V1 X (26)', 'DASH PRO V1 X (25)', 4215, 'TITLEIST'

	SET NOCOUNT OFF;
	declare @RunCount integer = 0
	begin try
		begin tran
			print 'Update [Model Codes and Descr]'
			Update LKP.[Model Codes and Descr] set [Model Descr] = @Correct where [Model Code] = @WrongCode	
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input_1'
			update [DARRELL_MASTER].[dbo].[INPUT_1] set MISC1 = @Correct where MISC1 = @Wrong and model = @Brand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.All.Ball'
			update Input.[All] set ballmodel = @Correct WHERE ballMODEL = @Wrong and BALLBRAND = @Brand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.All.Spike'
			update Input.[All] set spikemodel = @Correct WHERE spikeMODEL = @Wrong and SPIKEBRAND = @Brand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Grip'
			update Input.Grip set gripmodel = @Correct WHERE gripMODEL = @Wrong and GRIPBRAND = @Brand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Iron'
			update Input.Iron set model = @Correct WHERE MODEL = @Wrong and BRAND = @Brand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Putter'
			update Input.Putter set model = @Correct WHERE MODEL = @Wrong and BRAND = @Brand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Shaft'
			update Input.Shaft set SHAFTMODEL = @Correct WHERE SHAFTMODEL = @Wrong and SHAFTBRAND = @Brand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Wedge'
			update Input.Wedge set model = @Correct WHERE MODEL = @Wrong and BRAND = @Brand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Wood'
			update Input.Wood set model = @Correct WHERE MODEL = @Wrong and BRAND = @Brand
			Set @RunCount = @RunCount + @@Rowcount

			if (select COUNT(*)  FROM [Proof].Wood where model = @Correct) > 0 
				begin
					print 'Deleted wrong code from ModelProof'
					delete from [Proof].Wood where model = @Wrong and BRAND = @Brand
					Set @RunCount = @RunCount + @@Rowcount
				end
			else 
				begin
					print 'Updated wrong code in ModelProof'
					update [Proof].Wood set model = @Correct where model = @Wrong and BRAND = @Brand
					Set @RunCount = @RunCount + @@Rowcount
				end;
		--rollback tran
		--print 'rollback'
		commit tran; print 'commit'
	end try
	
	begin catch 
		rollback tran
		print 'rollback'
		print error_message()
		set @RunCount = 99999
	end catch
	return @RunCount
END
GO
