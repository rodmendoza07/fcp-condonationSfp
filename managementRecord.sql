USE [CATALOGOS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[managementRecord](
	@employee int = 0,
	@client int = 0,
	@credit int = 0,
	@action int = 0,
	@effect int = 0,
	@datePromise datetime, 
	@comment varchar(200) = ''
)
AS
BEGIN
	DECLARE @msg varchar(500) = ''
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO CATALOGOS.dbo.creditManagement (employee
			, credit
			, client
			, action
			, effect
			, datePromise
			, comment
			, status
			, createdAt
			, updatedAt)
		VALUES (@employee
			, @credit
			, @client
			, @action
			, @effect
			, @datePromise
			, @comment
			, 1
			, GETDATE()
			, GETDATE())

		SELECT @@IDENTITY AS ID	
		COMMIT TRANSACTION	
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE() AS [error]
	END CATCH        
END       

-- EXEC managementRecord 1044, 293, 33, 1, 2, '2017-04-05 9:08:50', 'teste 1'

-- SELECT * FROM CATALOGOS.dbo.creditManagement

-- TRUNCATE TABLE CATALOGOS.dbo.creditManagement