USE [CATALOGOS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[condonationRecord](
	@employee int = 0,
	@client int = 0,
	@credit int = 0,
	@datePromisePayment datetime, 
	@commissionsPercent int = 0,
	@interestArrearsPercent int = 0,
	@interestTaxDuePercent int = 0,
	@interesDuePercent int = 0,
	@capitalPercent int = 0
)
AS
BEGIN
	DECLARE @msg varchar(500) = ''
		, @count int = 0
		, @datePtp varchar(10) = ''
		, @name varchar(200) = ''

	BEGIN TRY
		BEGIN TRANSACTION
		SELECT TOP 1 @count = COUNT(*)
			, @datePtp = CONVERT(varchar(10), con.datePromisePayment, 103)
			, @name = RTRIM(LTRIM(UPPER(emp.nombre))) + ' ' + RTRIM(RTRIM(emp.ap_paterno)) + ' ' + RTRIM(LTRIM(emp.ap_materno)) 
		FROM CATALOGOS.dbo.Condonation con WITH(NOLOCK)
			INNER JOIN CATALOGOS.dbo.tc_empleados emp WITH(NOLOCK) ON (emp.id_empleados = con.employee)
		WHERE con.credit = @credit
			AND con.client = @client
			AND GETDATE() BETWEEN con.createdAt AND con.datePromisePayment
			AND con.status = 1
		GROUP BY con.createdAt, con.datePromisePayment, emp.nombre, emp.ap_paterno, emp.ap_materno
		ORDER BY con.createdAt DESC

		IF @count > 0
			BEGIN
				SET @msg = @name + ' realizó una condonación a este crédito con promesa de pago hasta ' +  @datePtp

				RAISERROR(@msg, 16, 1)
				RETURN
			END

		INSERT INTO CATALOGOS.dbo.Condonation (employee
			, credit
			, client
			, datePromisePayment
			, commissionsPercent
			, interestArrearsPercent
			, interestTaxDuePercent
			, interesDuePercent
			, capitalPercent
			, status
			, createdAt
			, updatedAt)
		VALUES (@employee
			, @credit
			, @client
			, @datePromisePayment
			, @commissionsPercent
			, @interestArrearsPercent
			, @interestTaxDuePercent
			, @interesDuePercent
			, @capitalPercent
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


-- EXEC condonationRecord 1044, 293, 33, '2017-04-05 5:15:43'

-- select * from Condonation ORDER BY con.createdAt DESC select getdate() truncate table Condonation