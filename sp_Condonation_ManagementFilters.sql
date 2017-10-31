USE CATALOGOS
GO

CREATE PROCEDURE [dbo].[sp_Condonation_ManagementFilters]
AS
BEGIN
	SELECT cc.id  
		, cc.[type]
		, cc.[description]  
	FROM CATALOGOS.dbo.CondonationCatalogs cc WITH(NOLOCK)  
	WHERE cc.[status] = 1  
		AND cc.[type] = 1

	SELECT
		dep.id_departamento as [id]
		, REPLICATE('0', 5 - LEN(dep.id_departamento)) + CAST(dep.id_departamento AS varchar) + ' - ' + dep.descripcion AS branchOffice
	FROM CATALOGOS.dbo.tc_departamento dep
	WHERE dep.id_departamento < 1000

	SELECT 
		tc.INDICAT AS [id]
		, 4 AS[type]  
		, RTRIM(LTRIM(UPPER(tc.INDDESC))) AS [description]  
	FROM ISILOANSWEB.dbo.T_CATID tc WITH(NOLOCK)  
	WHERE tc.CATALOGO = 5  
	ORDER BY tc.INDDESC

	SELECT 
		cc.id
		, cc.[type]
		, cc.[description]
	FROM CATALOGOS.dbo.CondonationCatalogs cc WITH(NOLOCK)
	WHERE cc.status = 1
		AND cc.type = 2
END

--EXEC CATALOGOS.dbo.sp_Condonation_ManagementFilters