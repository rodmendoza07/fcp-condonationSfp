USE CATALOGOS
GO 

CREATE TABLE [dbo].[tc_condonationConfig](
	cc_id INT IDENTITY(1,1)
	, cc_accesorios BIT NOT NULL CONSTRAINT def_cc_accesorios DEFAULT(0)
	, cc_moratorios BIT NOT NULL CONSTRAINT def_cc_moratorios DEFAULT(0)
	, cc_IVAinteresVencido BIT NOT NULL CONSTRAINT def_cc_IVAinteresVencido DEFAULT(0)
	, cc_interesVencido BIT NOT NULL CONSTRAINT def_cc_interesVencido DEFAULT(0)
	, cc_capital BIT NOT NULL CONSTRAINT def_cc_capital DEFAULT(0)
	, cc_button BIT NOT NULL CONSTRAINT def_cc_button DEFAULT(0)
	, cc_profileAllow INT NOT NULL CONSTRAINT def_cc_userAllow DEFAULT(0)
	, cc_dayPeriod INT NOT NULL CONSTRAINT def_cc_dayPeriod DEFAULT(0)
	, cc_createDate DATE NOT NULL CONSTRAINT def_cc_createDate DEFAULT(GETDATE())
	, cc_modDate DATE NOT NULL CONSTRAINT def_cc_modDate DEFAULT(GETDATE())
)

--USUARIOS DE SUCURSAL

--Mayor 61 dias 
INSERT INTO tc_condonationConfig (
	cc_accesorios
	, cc_moratorios
	, cc_dayPeriod
	, cc_profileAllow
	, cc_button
) VALUES (1,1,61,3,1), (1,1,61,8,1)

--Menor 61 días
INSERT INTO tc_condonationConfig (
	cc_accesorios
	--, cc_moratorios
	, cc_dayPeriod
	, cc_profileAllow
	, cc_button
) VALUES (1,60,3,1), (1,60,8,1)

--GESTOR
--Menor a 61 días
INSERT INTO tc_condonationConfig (
	cc_accesorios
	--, cc_moratorios
	, cc_dayPeriod
	, cc_profileAllow
	, cc_button
) VALUES (1,60,69,1)

--Mayor a 61 días
INSERT INTO tc_condonationConfig (
	cc_accesorios
	, cc_moratorios
	, cc_dayPeriod
	, cc_profileAllow
	, cc_button
) VALUES (1,1,61,69,1)

--SUBDIRECTOR 
--Mayor a 61 días
INSERT INTO tc_condonationConfig (
	cc_accesorios
	, cc_moratorios
	, cc_IVAinteresVencido
	, cc_interesVencido
	, cc_dayPeriod
	, cc_profileAllow
	, cc_button
) VALUES (1,1,1,1,61,86,1)

--Menor a 61 días
INSERT INTO tc_condonationConfig (
	cc_accesorios
	, cc_moratorios
	, cc_dayPeriod
	, cc_profileAllow
	, cc_button
) VALUES (1,1,60,86,1)


--DIRECTOR
--Menor a 61 días
INSERT INTO tc_condonationConfig (
	cc_accesorios
	, cc_moratorios
	, cc_IVAinteresVencido
	, cc_interesVencido
	, cc_dayPeriod
	, cc_profileAllow
	, cc_button
) VALUES (1,1,1,1,60,87,1)

--Mayor a 61 días
INSERT INTO tc_condonationConfig (
	cc_accesorios
	, cc_moratorios
	, cc_IVAinteresVencido
	, cc_interesVencido
	, cc_capital
	, cc_dayPeriod
	, cc_profileAllow
	, cc_button
) VALUES (1,1,1,1,1,61,87,1)


SELECT * FROM tc_condonationConfig
--SELECT * FROM CATALOGOS.dbo.tc_empleados