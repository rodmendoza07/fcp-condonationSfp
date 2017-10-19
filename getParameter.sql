
SELECT cc.id
	, cc.type
	, cc.description
FROM CondonationCatalogs cc WITH(NOLOCK)
WHERE cc.status = 1
	AND cc.type = 1

SELECT cc.id
	, cc.type
	, cc.description
FROM CondonationCatalogs cc WITH(NOLOCK)
WHERE cc.status = 1
	AND cc.type = 2

SELECT CAST(ts.SUCURSAL AS int) AS [id]
	, 3 AS [type]
	, RTRIM(LTRIM(ts.NOMBRE)) COLLATE Modern_Spanish_CI_AS  AS [description]
FROM T_SUC ts WITH(NOLOCK)
ORDER BY ts.NOMBRE

SELECT tc.INDICAT AS [id]
	, 4 AS [type]
	, tc.INDDESC AS [description]
FROM ISILOANSWEB.dbo.T_CATID tc WITH(NOLOCK)
WHERE tc.CATALOGO = 5
ORDER BY tc.INDDESC
