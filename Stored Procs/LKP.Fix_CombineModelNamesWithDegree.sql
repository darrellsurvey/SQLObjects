DROP PROCEDURE IF EXISTS [LKP].[Fix_CombineModelNamesWithDegree];
GO

-- =============================================
-- Author:		Alex R.
-- Create date: 11/7/2013
-- Description:	Changes Model Names and move out Degree when fixing incorrect spell
-- =============================================
CREATE PROCEDURE [LKP].[Fix_CombineModelNamesWithDegree]
	@Correct nvarchar(50),
	@CorrectCode nvarchar(4),
	@Wrong nvarchar(50),
	@WrongCode nvarchar(4),
	@WrongBrand nvarchar(50),
	@Degree nvarchar(5)

AS
BEGIN
	SET NOCOUNT OFF;
	declare @RunCount integer = 0
	declare @WrongBrandCode nvarchar(4)
	Declare @DegreeCode nvarchar(4)
	
	select @WrongBrandCode = [Mfgr Code] from LKP.[Manufacturer Codes and Desc] where [Mfgr Descr] = @WrongBrand
	select @DegreeCode = [Size Code] from LKP.[Size Codes and Description] where [Size Descr] = @Degree
	print @DegreeCode
	

	begin try
		begin tran

			print 'Updating Input_1'
			update [DARRELL_MASTER].[dbo].[INPUT_1] set MISC1 = @Correct, MISC3 = @Degree where MISC1 = @Wrong and [model] = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Wood'
			update Input.Wood set model = @Correct, SIZE = @Degree WHERE MODEL = @Wrong and BRAND =  @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.Wood'
			update Player_Master.[Wood Detail] set [Wood Model Code] = @CorrectCode, [Wood Size Code] = @DegreeCode WHERE [Wood Model Code] = @WrongCode and [Wood Brand Code] =  @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			if @WrongCode <> @CorrectCode
				begin
					print 'Deleting from LKp.Brand/Model'
					delete from LKP.[Brand/Model Codes with Equip] where [Model Code] = @WrongCode and [Mfgr Code] = @WrongBrandCode
					Set @RunCount = @RunCount + @@Rowcount
				end;
			
			if (select COUNT(*)  FROM [LKP].[Brand/Model Codes with Equip] where [Model Code]  = @WrongCode) = 0
				-- we cannot delete bad model code if there are more brands associated with it
				begin
					print 'Deleting from LKp.Model'
					delete from LKP.[Model Codes and Descr] where [Model Code] = @WrongCode
					Set @RunCount = @RunCount + @@Rowcount
				end;

		--rollback tran
		--set @RunCount = 99999
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
