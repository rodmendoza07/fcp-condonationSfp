USE [CATALOGOS]
GO
/****** Object:  StoredProcedure [dbo].[getCondonations]    Script Date: 28/02/2017 4:08:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getCondonations](
	@startDate varchar(8),
	@endDate varchar(8)
	, @option INT = -1
)
AS
BEGIN 
	DECLARE @msg varchar(500) = ''
	BEGIN TRY
		IF @option = 0 BEGIN
			SELECT
				RTRIM(LTRIM(emp.usuario)) AS [user]
				, CONVERT(varchar(10), con.createdAt, 103) AS [date]
				, CONVERT(varchar(10), con.createdAt, 108) AS [hour]
				, con.credit
				, cred.CLIENTE AS client
				, REPLACE(cte.TITULAR, '*','') AS [name]
				, cte.TELEF AS tel1
				, cte.TELEF_2 AS tel2
				, LTRIM(RTRIM(cte.DIRECCION)) + ', ' + LTRIM(RTRIM(cte.COLONIA)) + ', ' + LTRIM(RTRIM(cte.CIUDAD)) AS [address]
				, CONVERT(varchar(10), con.datePromisePayment, 103) AS [datePromisePayment]
				, con.commissionsPercent
				, con.interestArrearsPercent
				, con.interestTaxDuePercent
				, con.interesDuePercent
				, con.capitalPercent
			FROM CATALOGOS.dbo.Condonation con WITH(NOLOCK)
				INNER JOIN CATALOGOS.dbo.tc_empleados emp WITH(NOLOCK) ON (emp.id_empleados = con.employee)
				INNER JOIN ISILOANSWEB.dbo.T_CRED cred WITH(NOLOCK) ON (con.credit = cred.NUMERO)
				INNER JOIN ISILOANSWEB.dbo.T_CTE cte WITH(NOLOCK) ON (cte.ACREDITADO = cred.CLIENTE)
			WHERE CONVERT(varchar(8), con.createdAt, 112) BETWEEN @startDate AND @endDate
				AND con.status = 1
		END                           
		IF @option = 1 BEGIN

			SELECT
				RTRIM(LTRIM(emp.usuario)) AS [user]
				, CONVERT(varchar(10), man.createdAt, 103) AS [date]
				, CONVERT(varchar(10), man.createdAt, 108) AS [hour]
				, man.credit
				, man.client AS client
				, REPLACE(cte.TITULAR, '*','') AS [name]
				, cte.TELEF AS tel1
				, cte.TELEF_2 AS tel2
				, LTRIM(RTRIM(cte.DIRECCION)) + ', ' + LTRIM(RTRIM(cte.COLONIA)) + ', ' + LTRIM(RTRIM(cte.CIUDAD)) AS [address]
				, a.[description] AS [action]
				, e.[description] AS [effect]
				, CONVERT(varchar, man.datePromise, 103) AS [datePromisePayment]
			FROM CATALOGOS.dbo.creditManagement man WITH(NOLOCK)
				INNER JOIN CATALOGOS.dbo.tc_empleados emp WITH(NOLOCK) ON (emp.id_empleados = man.employee)
				INNER JOIN ISILOANSWEB.dbo.T_CTE cte  WITH(NOLOCK) ON (cte.ACREDITADO = man.client)
				INNER JOIN CATALOGOS.dbo.creditManagementAction a WITH(NOLOCK) ON (a.id = man.[action])
				INNER JOIN CATALOGOS.dbo.creditManagementEffect e WITH(NOLOCK) ON (e.id = man.[effect])
			WHERE CONVERT(varchar(8), man.createdAt, 112) BETWEEN @startDate AND @endDate
				AND man.status = 1
			ORDER BY man.datePromise ASC
		END
	END TRY
	BEGIN CATCH
		SET @msg = (SELECT ERROR_MESSAGE())
		RAISERROR(@msg, 16, 1)
	END CATCH 
END 

-- exec CATALOGOS.dbo.getCondonations '20171014', '20171026', 1