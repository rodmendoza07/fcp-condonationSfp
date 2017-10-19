USE [CATALOGOS]
GO
/****** Object:  StoredProcedure [dbo].[getInfoUser]    Script Date: 28/02/2017 4:08:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getInfoUser]
	@user varchar(33),
	@pass varchar(33),
	@tryn int,
	@id_emp int
AS
BEGIN TRY
	DECLARE @msg varchar(500) = ''

	IF (@tryn >= 3) 
		BEGIN
			UPDATE CATALOGOS.dbo.te_users_passw_encrypt 
			SET peusr_passw_encrypt_lock = 1 
			WHERE peusr_user_id = @id_emp
		END
	ELSE
		BEGIN 
			SELECT enc.peusr_passw_encrypt_lock AS [on_lock]
				, enc.peusr_passw_encrypt_reset AS [reset]
				, emp.estatus
				, emp.cve_depto AS [id_sucursal]
				, emp.cve_puesto AS [id_puesto]
				--, dep.descripcion As [sucursal]
				, emp.id_empleados
				--, RTRIM(LTRIM(emp.usuario)) AS [usuario]
				, RTRIM(LTRIM(emp.nombre)) AS [nombre]
				, RTRIM(LTRIM(emp.ap_paterno)) AS [apellido_paterno]
				, RTRIM(LTRIM(emp.ap_materno)) AS [apellido_materno]
				, RTRIM(LTRIM(emp.nombre)) + ' ' + RTRIM(LTRIM(emp.ap_paterno)) + ' ' + RTRIM(LTRIM(emp.ap_materno)) AS [nombre_emp]
			FROM CATALOGOS.dbo.tc_empleados emp WITH(NOLOCK)
				INNER JOIN CATALOGOS.dbo.tc_departamento dep WITH(NOLOCK) ON (emp.cve_depto = dep.id_departamento) 
				INNER JOIN CATALOGOS.dbo.te_users_passw_encrypt enc WITH(NOLOCK) ON (enc.peusr_user_id = emp.id_empleados)
			WHERE enc.peusr_passw_encrypt = @pass 
				And emp.estatus = 1
		END
END TRY
	BEGIN CATCH
		SET @msg = (SELECT ERROR_MESSAGE())
		RAISERROR(@msg, 16, 1)
	END CATCH 

--exec getInfoUser 'marcmg', '8e252c536ef99d3123150f91ed3bec65', 1, 1

