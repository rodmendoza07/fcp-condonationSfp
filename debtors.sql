USE [CATALOGOS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[debtors](
	@credit int = 0
	, @daysPastDue int = 0
	, @branchOffices int = 0
	, @typeProduct int = 0
	, @balanceRange int = 0
)
AS
BEGIN
	DECLARE @msg varchar(500) = ''
		, @minValueDays int = 0
		, @maxValueDays int = 0
		, @minValueBalance int = 0
		, @maxValueBalance int = 0

	BEGIN TRY
		IF (@daysPastDue <> 0)
			BEGIN
				SELECT @minValueDays = cat.minValue
					, @maxValueDays = cat.maxValue
				FROM CATALOGOS.dbo.CondonationCatalogs cat
				WHERE cat.id = @daysPastDue
					AND cat.type = 1
			END

		IF (@balanceRange <> 0)
			BEGIN
				SELECT @minValueBalance = cat.minValue
					, @maxValueBalance = cat.maxValue
				FROM CATALOGOS.dbo.CondonationCatalogs cat
				WHERE cat.id = @balanceRange
					AND cat.type = 2
			END

		SELECT sal.CREDITO AS [credit]
			, sal.CLIENTE AS [client]
			, RTRIM(LTRIM(UPPER(REPLACE(cli.TITULAR, '*', '')))) AS [name]
			, sal.SUCURSAL AS [branchoffice]
			, REPLICATE('0', 5 - LEN(suc.id_departamento)) + CAST(suc.id_departamento AS varchar) + ' - ' + suc.descripcion AS [branchoffice_description]
			, sal.PRODUCTO AS [product]
			, RTRIM(LTRIM(UPPER(pro.INDDESC))) AS [product_description]
			, sal.DIAMORA AS [days_mora]
			, sal.SALDO_AC AS [balance]
		FROM ISILOANSWEB.dbo.T_SALDOS sal WITH(NOLOCK)
			INNER JOIN ISILOANSWEB.dbo.T_CTE cli WITH(NOLOCK) ON (cli.ACREDITADO = sal.CLIENTE)
			INNER JOIN CATALOGOS.dbo.tc_departamento suc WITH(NOLOCK) ON (suc.id_departamento = sal.SUCURSAL)
			INNER JOIN ISILOANSWEB.dbo.T_CATID pro WITH(NOLOCK) ON (pro.INDICAT = sal.PRODUCTO AND pro.CATALOGO = 5)
		WHERE (sal.CREDITO = @credit OR @credit = 0)
			AND ((@daysPastDue <> 0 AND sal.DIAMORA BETWEEN @minValueDays AND @maxValueDays) OR (@daysPastDue = 0))
			AND (sal.SUCURSAL = @branchOffices OR @branchOffices = 0)
			AND (sal.PRODUCTO = @typeProduct OR @typeProduct = 0)
			AND ((@balanceRange <> 0 AND sal.SALDO_AC BETWEEN @minValueBalance AND @maxValueBalance) OR (@balanceRange = 0))
		ORDER BY sal.SUCURSAL, sal.SALDO_AC DESC
	END TRY
	BEGIN CATCH
		SET @msg = (SELECT ERROR_MESSAGE())
		RAISERROR(@msg, 16, 1)
	END CATCH        
END       

-- EXEC debtors 32, 1, 13, 1, 6