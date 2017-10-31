Select *
From CATALOGOS.dbo.tc_empleados
Where id_empleados = 1044

Select *
From CATALOGOS.dbo.te_users_passw_encrypt
Where peusr_id = 694

--Usuario claudia

UPDATE CATALOGOS.dbo.te_users_passw_encrypt SET
	peusr_passw_encrypt = 'a09c4db2d2c72be4fbc4c683bb65056d'
	, peusr_passw_encrypt_lock = 0
	, peusr_passw_encrypt_reset = 0
WHERE peusr_user_id = 23

--Usuario Monica Trujano
UPDATE CATALOGOS.dbo.te_users_passw_encrypt SET
	peusr_passw_encrypt = 'fa64b025b024ffee7604258ad5937b99'
	, peusr_passw_encrypt_lock = 0
	, peusr_passw_encrypt_reset = 0
WHERE peusr_user_id = 1

--Usuario Carlos Cobranza
UPDATE CATALOGOS.dbo.te_users_passw_encrypt SET
	peusr_passw_encrypt = '342cf7d3911bc693860bcc2caae64e7a'
	, peusr_passw_encrypt_lock = 0
	, peusr_passw_encrypt_reset = 0
WHERE peusr_user_id = 29

--Usuario Paco
UPDATE CATALOGOS.dbo.te_users_passw_encrypt SET
	peusr_passw_encrypt = '49313129888d127822cdfab68cccb634'
	, peusr_passw_encrypt_lock = 0
	, peusr_passw_encrypt_reset = 0
WHERE peusr_user_id = 28


Select  peusr_passw_encrypt_lock,peusr_passw_encrypt_reset,estatus, cve_depto, cve_puesto ,
	deto.descripcion, emp.id_empleados, emp.usuario, nombre, ap_paterno, ap_materno, a.*
from CATALOGOS.dbo.tc_empleados emp 
	INNER JOIN CATALOGOS.dbo.tc_departamento deto ON (emp.cve_depto = deto.id_departamento) 
	INNER JOIN CATALOGOS.dbo.te_users_passw_encrypt a ON (a.peusr_user_id = emp.id_empleados)
where estatus =1
	and emp.id_empleados = 1044

update CATALOGOS.dbo.te_users_passw_encrypt
set peusr_passw_encrypt = '8e252c536ef99d3123150f91ed3bec65', peusr_passw_encrypt_reset = 0, peusr_passw_encrypt_lock = 0
where peusr_id = 694

Select *
From CATALOGOS.dbo.td_loginUsers_bitacora

INSERT INTO CATALOGOS.dbo.td_loginUsers_bitacora
                    ([blogUsers_id]
					,[blogUsers_login]
                    ,[blogUsers_date_s] 
					,[blogUsers_date_e]
                    ,[blogUsers_status_s] 
					,[blogUsers_status_e]
					,[blogUsers_app])
VALUES (NEWID(), 'marcmg', GETDATE(), getdate(), 0, 0, 2)

Select  * From CATALOGOS.dbo.td_loginUsers_bitacora 


Select top 5 SUBSTRING(APLI_CONTA, 23, 1), *
From ISILOANSWEB.dbo.T_CRED2

Select top 5 *
From ISILOANSWEB.dbo.T_SALDOS

select * from CATALOGOS.dbo.tc_empleados