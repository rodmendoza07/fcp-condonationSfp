USE CATALOGOS
GO

CREATE PROCEDURE [dbo].[sp_getCondonationPermission](
	@employee INT = 0
	, @dayPeriod INT = 0
)
AS
BEGIN
	IF @dayPeriod < 61 BEGIN
		SET @dayPeriod = 60
	END
	SELECT
		cc.*
	FROM CATALOGOS.dbo.tc_condonationConfig cc
		INNER JOIN CATALOGOS.dbo.tc_empleados emp ON (cc.cc_profileAllow = emp.cve_puesto)
	WHERE emp.id_empleados = @employee
		AND cc_dayPeriod = @dayPeriod
END

--EXEC CATALOGOS.dbo.sp_getCondonationPermission 11,11