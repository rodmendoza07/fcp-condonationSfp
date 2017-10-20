USE [CATALOGOS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[detailCredit](
	@credit int = 0,
	@client int = 0
)
AS
BEGIN
	DECLARE @msg varchar(500) = ''
		, @percentLimit tinyint = 0
		, @rowNumber int = 0
		, @accountant tinyint = 1
		, @dateCondonationPtp varchar(8) = ''
		, @dateCondonationCreate varchar(8) = ''
		, @count int = 0

	BEGIN TRY
		IF OBJECT_ID('tempdb..#BUSINESSRULE') IS NOT NULL
			BEGIN
				DROP TABLE #BUSINESSRULE
			END

		IF OBJECT_ID('tempdb..#HISTORY') IS NOT NULL
			BEGIN
				DROP TABLE #HISTORY
			END

		CREATE TABLE #HISTORY(
			id int IDENTITY(1,1) primary key,
			credit int NOT NULL,
			transactions int NOT NULL,
			dateOperation varchar(10) NOT NULL,
			userCancel varchar(20) NOT NULL,
			userApply varchar(20) NOT NULL,
			application int NOT NULL,
			concept int NOT NULL,
			description varchar(30) NOT NULL,
			icon varchar(20) NOT NULL,
			bgcolor varchar(15) NOT NULL,
			dateBack varchar(10) NOT NULL,
			amount decimal(18,2) NOT NULL,
			status int NOT NULL,
			hourApply varchar(5) NOT NULL,
			hourBack varchar(5) NOT NULL,
			datePromisePayment varchar(10) NOT NULL,
			commissionsPercent int NOT NULL,
			interestArrearsPercent int NOT NULL,
			interestTaxDuePercent int NOT NULL,
			interesDuePercent int NOT NULL,
			capitalPercent int NOT NULL,
			managementEffectDescript varchar(50) NOT NULL,
			managementEffectComment varchar(200) NOT NULL
		)

		SELECT ROW_NUMBER() OVER (ORDER BY con.credit) AS rowNumber
			, id
			, employee
			, credit
			, client
			, datePromisePayment
			, createdAt
		INTO #BUSINESSRULE
		FROM CATALOGOS.dbo.Condonation con WITH(NOLOCK)
		WHERE con.credit = @credit
			AND con.client = @client
			AND con.status = 1

		WHILE @rowNumber IS NOT NULL
			BEGIN
				SET @rowNumber = (SELECT MIN(rowNumber) FROM #BUSINESSRULE WITH(NOLOCK) WHERE rowNumber > @rowNumber)

				IF @rowNumber IS NOT NULL
					BEGIN
						SELECT @dateCondonationPtp = CONVERT(varchar(8), datePromisePayment, 112)
							, @dateCondonationCreate = CONVERT(varchar(8), createdAt, 112)
						FROM #BUSINESSRULE WITH(NOLOCK)
						WHERE rowNumber = @rowNumber

						SELECT  @count = COUNT(*)
						FROM ISILOANSWEB.dbo.T_HIST his WITH(NOLOCK)
						WHERE his.NUMERO = @credit
							AND his.FEC_OPERA BETWEEN @dateCondonationCreate AND @dateCondonationPtp
							AND his.APLICACION = 1
							AND his.CONCEPTO = 3

						IF (@count > 0)
							BEGIN
								SET @accountant = @accountant + 1
							END

						SET @count = 0
					END
			END

		SELECT @percentLimit = brc.percentCondonation
		FROM CATALOGOS.dbo.BusinessRulesCondonation brc WITH(NOLOCK)
		WHERE brc.accountant = @accountant
			AND brc.status = 1

		SELECT sal.CREDITO AS [credit]
			, sal.CLIENTE AS [client]
			, RTRIM(LTRIM(UPPER(REPLACE(cli.TITULAR, '*', '')))) AS [name]
			, RTRIM(LTRIM(UPPER(REPLACE(cli.BEN_NOMBRE, '*', '')))) AS [first_name]
			, RTRIM(LTRIM(UPPER(REPLACE(cli.BEN_PATERNO, '*', '')))) AS [last_name1]
			, RTRIM(LTRIM(UPPER(REPLACE(cli.BEN_MATERNO, '*', '')))) AS [last_name2]
			, RTRIM(LTRIM(cli.TELEF)) AS [phone1]
			, RTRIM(LTRIM(cli.TELEF_2)) AS [phone2]
			, RTRIM(LTRIM(UPPER(edo.INDDESC))) AS [civil]
			, RTRIM(LTRIM(cli.COD_SEXO)) AS [sex] 
			, (RTRIM(LTRIM(UPPER(cli.BEN_DIRECCION))) + ' COL. ' + RTRIM(LTRIM(UPPER(cli.BEN_COLONIA))) + ' CP. ' + RTRIM(LTRIM(cli.BEN_CP)) + ' NO. EXT. ' + CASE WHEN cli.NO_EXT <> 0 THEN RTRIM(LTRIM(cli.NO_EXT)) ELSE 'S/N' END  + ' NO. INT. ' +CASE WHEN cli.NO_INT <> 0 THEN  RTRIM(LTRIM(cli.NO_INT)) ELSE 'S/N' END) AS [address]
			, sal.SUCURSAL AS [branchoffice]
			, RTRIM(LTRIM(suc.NOMBRE)) AS [branchoffice_description]
			, suc.DIRECCION AS [branchoffice_address]
			, RTRIM(LTRIM(suc.TELEFONO)) AS [branchoffice_phone]
			, sal.PRODUCTO AS [product]
			, RTRIM(LTRIM(UPPER(pro.INDDESC))) AS [description_product]
			, RTRIM(LTRIM(pro.INDDESC)) AS [product_description]
			, sal.DIAMORA AS [days_mora]
			, sal.SALDO_AC AS [balance]
			, sal.INT_VEN AS [int_ven]
			, sal.INT_MORA AS [int_mora]
			, sal.PAGOS_VE AS [payment_ven]
			, sal.MONPRO_PAG AS [amountPaid]
			, @accountant AS [accountant]
			, @percentLimit AS [percentLimit]
		FROM ISILOANSWEB.dbo.T_SALDOS sal WITH(NOLOCK)
			INNER JOIN ISILOANSWEB.dbo.T_CTE cli WITH(NOLOCK) ON (cli.ACREDITADO = sal.CLIENTE)
			INNER JOIN ISILOANSWEB.dbo.T_SUC suc WITH(NOLOCK) ON (suc.SUCURSAL = sal.SUCURSAL)
			INNER JOIN ISILOANSWEB.dbo.T_CATID pro WITH(NOLOCK) ON (pro.INDICAT = sal.PRODUCTO AND pro.CATALOGO = 5)
			INNER JOIN ISILOANSWEB.dbo.T_CATID edo WITH(NOLOCK) ON (edo.INDICAT = cli.EDOCIVIL AND edo.CATALOGO = 253)
		WHERE sal.CREDITO = @credit
			AND sal.CLIENTE = @client
		ORDER BY sal.SUCURSAL, sal.SALDO_AC DESC

		INSERT INTO #HISTORY (credit
			, transactions
			, dateOperation
			, userCancel
			, userApply
			, application
			, concept
			, description
			, icon
			, bgcolor
			, dateBack
			, amount
			, status
			, hourApply
			, hourBack
			, datePromisePayment
			, commissionsPercent
			, interestArrearsPercent
			, interestTaxDuePercent
			, interesDuePercent
			, capitalPercent
			, managementEffectDescript
			, managementEffectComment)
		SELECT his.NUMERO AS [credit]
			, his.TRANS AS [transaction]
			, RTRIM(LTRIM(SUBSTRING(CONVERT(varchar, his.FEC_OPERA, 112), 7, 2))) + '/' + RTRIM(LTRIM(SUBSTRING(CONVERT(varchar, his.FEC_OPERA, 112), 5, 2))) + '/' + RTRIM(LTRIM(SUBSTRING(CONVERT(varchar, his.FEC_OPERA, 112), 1, 4))) AS [dateOperation]
			, RTRIM(LTRIM(UPPER(his.USUA_ANULA))) AS [userCancel]
			, RTRIM(LTRIM(UPPER(his.USUARIO))) AS [user]
			, his.APLICACION AS [application]
			, his.CONCEPTO AS [concept]
			, app.description
			, app.icon
			, CASE WHEN RTRIM(LTRIM(his.USUA_ANULA)) <> '' THEN 'bg-danger' ELSE app.bgcolor END AS [bgcolor]
			, CASE WHEN RTRIM(LTRIM(CONVERT(varchar, his.FECH_ANULA, 112))) <> '0'  
					THEN RTRIM(LTRIM(SUBSTRING(CONVERT(varchar, his.FECH_ANULA, 112), 7, 2))) + '/' + RTRIM(LTRIM(SUBSTRING(CONVERT(varchar, his.FECH_ANULA, 112), 5, 2))) + '/' + RTRIM(LTRIM(SUBSTRING(CONVERT(varchar, his.FECH_ANULA, 112), 1, 4)))
					ELSE RTRIM(LTRIM(CONVERT(varchar, his.FECH_ANULA, 112))) END AS [dateBack]
			, his.IMPORTE AS [amount]
			, his.STATU AS [status]
			, RTRIM(LTRIM(SUBSTRING(CAST(his.HORA AS varchar), 1, 2))) + ':' + RTRIM(LTRIM(SUBSTRING(CAST(his.HORA AS varchar), 2, 2))) AS [hour]
			, RTRIM(LTRIM(SUBSTRING(CAST(his.HORA_ANULA AS varchar), 1, 2))) + ':' + RTRIM(LTRIM(SUBSTRING(CAST(his.HORA_ANULA AS varchar), 2, 2))) AS [hourBack]
			, CONVERT(varchar(10), GETDATE(), 103)  AS [datePromisePayment]
			, 0 AS [commissionsPercent]
			, 0 AS [interestArrearsPercent]
			, 0 AS [interestTaxDuePercent]
			, 0 AS [interesDuePercent]
			, 0 AS [capitalPercent]
			, ''
			, ''
		FROM ISILOANSWEB.dbo.T_HIST his WITH(NOLOCK)
			INNER JOIN CATALOGOS.dbo.DescriptionApplicationConcept app WITH(NOLOCK) ON (app.application = his.APLICACION AND app.concept = his.CONCEPTO)
		WHERE his.NUMERO = @credit
		ORDER BY his.FEC_OPERA, his.HORA 

		INSERT INTO #HISTORY (credit
			, transactions
			, dateOperation
			, userCancel
			, userApply
			, application
			, concept
			, description
			, icon
			, bgcolor
			, dateBack
			, amount
			, status
			, hourApply
			, hourBack
			, datePromisePayment
			, commissionsPercent
			, interestArrearsPercent
			, interestTaxDuePercent
			, interesDuePercent
			, capitalPercent
			, managementEffectDescript
			, managementEffectComment)
		SELECT con.credit
			, 0
			, CONVERT(varchar(10), con.createdAt, 103)
			, ''
			, RTRIM(LTRIM(emp.usuario))
			, 0
			, 0
			, 'Condonación'
			, 'fa fa-handshake-o'
			, 'yellow-bg'
			, GETDATE()
			, 0
			, 2 -- condonation
			, CONVERT(varchar(5), con.createdAt, 108)
			, CONVERT(varchar(5), con.createdAt, 108)
			, CONVERT(varchar(10), con.datePromisePayment, 103)
			, con.commissionsPercent
			, con.interestArrearsPercent
			, con.interestTaxDuePercent
			, con.interesDuePercent
			, con.capitalPercent
			, ''
			, ''
		FROM CATALOGOS.dbo.Condonation con WITH(NOLOCK)
			INNER JOIN CATALOGOS.dbo.tc_empleados emp WITH(NOLOCK) ON (emp.id_empleados = con.employee)
		WHERE con.credit = @credit

		INSERT INTO #HISTORY (credit
			, transactions
			, dateOperation
			, userCancel
			, userApply
			, application
			, concept
			, description
			, icon
			, bgcolor
			, dateBack
			, amount
			, status
			, hourApply
			, hourBack
			, datePromisePayment
			, commissionsPercent
			, interestArrearsPercent
			, interestTaxDuePercent
			, interesDuePercent
			, capitalPercent
			, managementEffectDescript
			, managementEffectComment)
		SELECT  cm.credit
			, 0
			, CONVERT(varchar(10), cm.createdAt, 103)
			, ''
			, RTRIM(LTRIM(emp.usuario))
			, 0
			, 0
			, cma.description
			, CASE WHEN cma.id = 1 THEN 'fa fa-phone'
				WHEN cma.id = 2 THEN 'fa fa-home'
				WHEN cma.id = 3 THEN 'fa fa-comments'
				ELSE 'fa fa-envelope-o'
			END
			, CASE WHEN cma.id = 1 THEN 'navy-bg'
				WHEN cma.id = 2 THEN 'lazur-bg'
				WHEN cma.id = 3 THEN 'blue-bg'
				ELSE 'bg-danger'
			END
			, GETDATE()
			, 0
			, 3 -- management
			, CONVERT(varchar(5), cm.createdAt, 108)
			, CONVERT(varchar(5), cm.createdAt, 108)
			, CONVERT(varchar(10), GETDATE(), 103)
			, 0
			, 0
			, 0
			, 0
			, 0
			, cme.description
			, cm.comment
		FROM CATALOGOS.dbo.creditManagement cm WITH(NOLOCK)
			INNER JOIN CATALOGOS.dbo.tc_empleados emp WITH(NOLOCK) ON (emp.id_empleados = cm.employee)
			INNER JOIN CATALOGOS.dbo.creditManagementAction cma WITH(NOLOCK) ON (cma.id = cm.action)
			INNER JOIN CATALOGOS.dbo.creditManagementEffect cme WITH(NOLOCK) ON (cme.id = cm.effect)
		WHERE cm.credit = @credit
		
		SELECT *
		FROM #HISTORY
		ORDER BY id DESC

		DROP TABLE #BUSINESSRULE
		DROP TABLE #HISTORY
	END TRY
	BEGIN CATCH
		SET @msg = (SELECT ERROR_MESSAGE())
		RAISERROR(@msg, 16, 1)
	END CATCH        
END       

-- EXEC detailCredit 33, 293

/*
Missing Index Details from detailCredit.sql - 192.168.1.6.ISILOANSWEB (joseob (56))
The Query Processor estimates that implementing the following index could improve the query cost by 67.4424%.
*/


--USE [ISILOANSWEB]
--GO
--CREATE NONCLUSTERED INDEX [INDX_CREDIT]
--ON [dbo].[T_SALDOS] ([CREDITO])

--GO