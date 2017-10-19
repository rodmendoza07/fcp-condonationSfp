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
)
AS
BEGIN 
	DECLARE @msg varchar(500) = ''
	BEGIN TRY
		SELECT con.credit
			, RTRIM(LTRIM(emp.usuario)) AS [user]
			, CONVERT(varchar(10), con.createdAt, 103) AS [date]
			, CONVERT(varchar(10), con.createdAt, 108) AS [hour]
			, CONVERT(varchar(10), con.datePromisePayment, 103) AS [datePromisePayment]
			, con.commissionsPercent
			, con.interestArrearsPercent
			, con.interestTaxDuePercent
			, con.interesDuePercent
			, con.capitalPercent
		FROM CATALOGOS.dbo.Condonation con WITH(NOLOCK)
			INNER JOIN CATALOGOS.dbo.tc_empleados emp WITH(NOLOCK) ON (emp.id_empleados = con.employee)
		WHERE CONVERT(varchar(8), con.createdAt, 112) BETWEEN @startDate AND @endDate
			AND con.status = 1
	END TRY
	BEGIN CATCH
		SET @msg = (SELECT ERROR_MESSAGE())
		RAISERROR(@msg, 16, 1)
	END CATCH 
END 

-- exec getCondonations '20170406', '20170406'

-- select * from CATALOGOS.dbo.Condonation
-- select * from ISILOANSWEB.dbo.T_SALDOS where credito = 33