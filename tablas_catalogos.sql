USE [CATALOGOS]
GO

IF OBJECT_ID('dbo.CatalogDescription', 'U') IS NOT NULL
DROP TABLE dbo.CatalogsDescrip

IF OBJECT_ID('dbo.CondonationCatalogs', 'U') IS NOT NULL
DROP TABLE dbo.CondonationCatalogs

IF OBJECT_ID('dbo.Condonation', 'U') IS NOT NULL
DROP TABLE dbo.Condonation

IF OBJECT_ID('dbo.BusinessRulesCondonation', 'U') IS NOT NULL
DROP TABLE dbo.BusinessRulesCondonation

IF OBJECT_ID('dbo.DescriptionApplicationConcept', 'U') IS NOT NULL
DROP TABLE dbo.DescriptionApplicationConcept

IF OBJECT_ID('dbo.BusinessRulesCondonation', 'U') IS NOT NULL
DROP TABLE dbo.BusinessRulesCondonation

IF OBJECT_ID('dbo.creditManagementAction', 'U') IS NOT NULL
DROP TABLE dbo.creditManagementAction

IF OBJECT_ID('dbo.creditManagementEffect', 'U') IS NOT NULL
DROP TABLE dbo.creditManagementEffect

IF OBJECT_ID('dbo.creditManagement', 'U') IS NOT NULL
DROP TABLE dbo.creditManagement

IF OBJECT_ID('dbo.CatalogDescription', 'U') IS NULL
CREATE TABLE CatalogDescription (
	id int IDENTITY(1,1) primary key,
	description varchar(100) NOT NULL,
	status bit NOT NULL,
	createdAt datetime,
	updatedAt datetime
);

IF OBJECT_ID('dbo.CondonationCatalogs', 'U') IS NULL
CREATE TABLE CondonationCatalogs (
	id int IDENTITY(1,1) primary key,
	type int NOT NULL,
	description varchar(50) NOT NULL,
	minValue int NOT NULL,
	maxValue int NOT NULL,
	status bit NOT NULL,
	createdAt datetime,
	updatedAt datetime,
	CONSTRAINT fk_CondonationCatalogs FOREIGN KEY (type)
	REFERENCES CatalogDescription(id)
);

IF OBJECT_ID('dbo.Condonation', 'U') IS NULL
CREATE TABLE Condonation (
	id int IDENTITY(1,1) primary key,
	employee int NOT NULL,
	credit int NOT NULL,
	client int NOT NULL,
	datePromisePayment datetime NOT NULL, -- fecha promesa de pago
	commissionsPercent int NOT NULL, -- comisiones
	interestArrearsPercent int NOT NULL, -- moratorios
	interestTaxDuePercent int NOT NULL, -- iva int vencido
	interesDuePercent int NOT NULL, -- int vencido
	capitalPercent int NOT NULL,
	status bit NOT NULL,
	createdAt datetime,
	updatedAt datetime
);

CREATE NONCLUSTERED INDEX  IDX_SEARCH
ON Condonation (id, credit, client)

DROP INDEX IDX_SEARCH ON Condonation;

IF OBJECT_ID('dbo.DescriptionApplicationConcept', 'U') IS NULL
CREATE TABLE DescriptionApplicationConcept (
	id int IDENTITY(1,1) primary key,
	application int NOT NULL,
	concept int NOT NULL,
	description varchar(200) NOT NULL,
	status bit NOT NULL,
	icon varchar(50) NOT NULL,
	bgcolor varchar(50) NOT NULL,
	createdAt datetime,
	updatedAt datetime
);

IF OBJECT_ID('dbo.BusinessRulesCondonation', 'U') IS NULL
CREATE TABLE BusinessRulesCondonation (
	id int IDENTITY(1,1) primary key,
	accountant int NOT NULL,
	percentCondonation int NOT NULL,
	status bit NOT NULL,
	createdAt datetime,
	updatedAt datetime
);

IF OBJECT_ID('dbo.creditManagementAction', 'U') IS NULL
CREATE TABLE creditManagementAction (
	id int IDENTITY(1,1) primary key,
	description varchar(100) NOT NULL,
	status bit NOT NULL,
	createdAt datetime,
	updatedAt datetime
);

IF OBJECT_ID('dbo.creditManagementEffect', 'U') IS NULL
CREATE TABLE creditManagementEffect (
	id int IDENTITY(1,1) primary key,
	parent int NOT NULL,
	description varchar(100) NOT NULL,
	status bit NOT NULL,
	createdAt datetime,
	updatedAt datetime,
	CONSTRAINT fk_creditManagementEffect FOREIGN KEY (parent)
	REFERENCES creditManagementAction(id)
);

IF OBJECT_ID('dbo.creditManagement', 'U') IS NULL
CREATE TABLE creditManagement (
	id int IDENTITY(1,1) primary key,
	employee int NOT NULL,
	credit int NOT NULL,
	client int NOT NULL,
	action int NOT NULL,
	effect int NOT NULL,
	datePromise datetime NOT NULL,
	comment varchar(500) NOT NULL,
	status bit NOT NULL,
	createdAt datetime,
	updatedAt datetime
);

INSERT INTO CatalogDescription(description, status, createdAt, updatedAt)
VALUES ('Dias de mora', 1, GETDATE(), GETDATE()),
('Rango de saldo', 1, GETDATE(), GETDATE())

INSERT INTO CondonationCatalogs(type, description, minValue, maxValue, status, createdAt, updatedAt)
VALUES (1, '1 a 7', 1, 7, 1, GETDATE(), GETDATE()),
(1, '8 a 30', 8, 30, 1, GETDATE(), GETDATE()),
(1, '31 a 60', 31, 60, 1, GETDATE(), GETDATE()),
(1, '>= 61', 61, 99999999, 1, GETDATE(), GETDATE()),
(2, '$ 0 a 1,000', 0, 1000, 1, GETDATE(), GETDATE()),
(2, '$ 1,001 a 5,000', 1001, 5000, 1, GETDATE(), GETDATE()),
(2, '$ 5,001 a 10,000', 5001, 10000, 1, GETDATE(), GETDATE()),
(2, '$ 10,001 a 15,000', 10000, 15000, 1, GETDATE(), GETDATE())

INSERT INTO BusinessRulesCondonation (accountant, percentCondonation, status, createdAt, updatedAt)
VALUES(1, 100, 1, GETDATE(), GETDATE()),
(2, 80, 1, GETDATE(), GETDATE()),
(3, 50, 1, GETDATE(), GETDATE()),
(4, 20, 1, GETDATE(), GETDATE()),
(5, 0, 1, GETDATE(), GETDATE())

select * from DescriptionApplicationConcept

INSERT INTO DescriptionApplicationConcept (application, concept, description, status, icon, bgcolor, createdAt, updatedAt)
VALUES (1, 1, 'Pago', 1, 'fa fa-dollar', 'navy-bg', GETDATE(), GETDATE()),
(1, 2, 'Disposición', 1, 'fa fa-credit-card', 'blue-bg', GETDATE(), GETDATE()),
(1, 3, 'Condonación', 1, 'fa fa-handshake-o', 'yellow-bg', GETDATE(), GETDATE()),
(2, 1, 'Recuperación por condonación', 1, 'fa fa-book', 'blue-bg', GETDATE(), GETDATE()),
(2, 2, 'Cargo por venta', 1, 'fa fa-wrench', 'bg-danger', GETDATE(), GETDATE()),
(3, 1, 'Recuperación por disposición', 1, 'fa fa-briefcase', 'lazur-bg', GETDATE(), GETDATE()),
(6, 4, 'Apertura de crédito', 1, 'fa fa-trophy', 'navy-bg', GETDATE(), GETDATE()),
(7, 1, 'Reestructura', 1, 'fa fa-refresh', 'navy-bg', GETDATE(), GETDATE()),
(10, 4, 'Baja por corrección', 1, 'fa fa-arrow-circle-down', 'bg-danger', GETDATE(), GETDATE()),
(35, 4, 'Castigo contable', 1, 'fa fa-chain', 'bg-danger', GETDATE(), GETDATE())

INSERT INTO creditManagementAction(description, status, createdAt, updatedAt)
VALUES ('Llamada teléfonica', 1, GETDATE(), GETDATE()),
('Visita domicilaria', 1, GETDATE(), GETDATE()),
('SMS', 1, GETDATE(), GETDATE()),
('E-mail', 1, GETDATE(), GETDATE())

INSERT INTO creditManagementEffect(parent, description, status, createdAt, updatedAt)
VALUES (1, 'Promesa de pago', 1, GETDATE(), GETDATE()),
(1, 'Colgo', 1, GETDATE(), GETDATE()),
(1, 'Dificultad de pago', 1, GETDATE(), GETDATE()),
(1, 'Teléfono ocupado', 1, GETDATE(), GETDATE()),
(1, 'Recado', 1, GETDATE(), GETDATE()),
(1, 'Cliente sin localizar', 1, GETDATE(), GETDATE()),
(1, 'Teléfono equivocado', 1, GETDATE(), GETDATE()),
(1, 'Teléfono ilocalizable', 1, GETDATE(), GETDATE()),
(1, 'Cliente en desacuerdo', 1, GETDATE(), GETDATE()),
(1, 'Teléfono no contesta', 1, GETDATE(), GETDATE()),
(1, 'Renuente', 1, GETDATE(), GETDATE()),
(1, 'Ya pago', 1, GETDATE(), GETDATE()),
(2, 'Promesa de pago', 1, GETDATE(), GETDATE()),
(2, 'Colgo', 1, GETDATE(), GETDATE()),
(2, 'Dificultad de pago', 1, GETDATE(), GETDATE()),
(2, 'Teléfono ocupado', 1, GETDATE(), GETDATE()),
(2, 'Recado', 1, GETDATE(), GETDATE()),
(2, 'Cliente sin localizar', 1, GETDATE(), GETDATE()),
(2, 'Teléfono equivocado', 1, GETDATE(), GETDATE()),
(2, 'Teléfono ilocalizable', 1, GETDATE(), GETDATE()),
(2, 'Cliente en desacuerdo', 1, GETDATE(), GETDATE()),
(2, 'Teléfono no contesta', 1, GETDATE(), GETDATE()),
(2, 'Renuente', 1, GETDATE(), GETDATE()),
(2, 'Ya pago', 1, GETDATE(), GETDATE()),
(3, 'No aplica', 1, GETDATE(), GETDATE()),
(4, 'No aplica', 1, GETDATE(), GETDATE())


SELECT * FROM CatalogDescription
SELECT * FROM CondonationCatalogs
SELECT * FROM Condonation
SELECT * FROM BusinessRulesCondonation
SELECT * FROM DescriptionApplicationConcept

SELECT * FROM creditManagementAction
SELECT * FROM creditManagementEffect
SELECT * FROM creditManagement
