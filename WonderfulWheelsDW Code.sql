
GO
CREATE DATABASE WonderfulWheelsDW;
GO

DROP DATABASE WonderfulWheelsDW

GO
USE WonderfulWheels;
	SELECT
		IDENTITY(INT,1,1) AS 'EmployeeSK',
		e.EmployeeID AS 'EmployeeAK',
		p.FirstName,
		p.LastName,
		p.Email,
		p.DateOfBirth,
		p.Title,
		e.HireDate,
		e.Role AS 'EmpRole',
		ce.Commission,
		e.ManagerID
	INTO [WonderfulWheelsDW].[dbo].[DimCommissionEmployee]
	FROM WonderfulWheels.dbo.Employee e
	JOIN WonderfulWheels.dbo.Person p ON p.PersonID = e.EmployeeID
	LEFT JOIN WonderfulWheels.dbo.CommissionEmployee ce ON ce.EmployeeID = e.EmployeeID

	ALTER TABLE [WonderfulWheelsDW].[dbo].[DimCommissionEmployee]
	ADD CONSTRAINT PK_DimCommissionEmployee_EmployeeSK PRIMARY KEY (EmployeeSK);

	ALTER TABLE [WonderfulWheelsDW].[dbo].[DimCommissionEmployee]
	ADD CONSTRAINT UNIQUE_EmployeeAK UNIQUE(EmployeeAK);


	SELECT 
		IDENTITY(INT,1,1) AS 'CustomerSK',
		p.PersonID AS 'CustomerAK',
		p.FirstName,
		p.LastName,
		p.Email,
		p.DateOfBirth,
		p.Title,
		c.RegistrationDate AS 'RegDate'
		INTO [WonderfulWheelsDW].[dbo].[DimCustomer]
		FROM WonderfulWheels.dbo.Person p
		JOIN WonderfulWheels.dbo.Customer c ON c.CustomerID = p.PersonID

	ALTER TABLE [WonderfulWheelsDW].[dbo].[DimCustomer]
	ADD CONSTRAINT PK_DimCustomer_CustomerSK PRIMARY KEY (CustomerSK);
	
	ALTER TABLE [WonderfulWheelsDW].[dbo].[DimCustomer]
	ADD CONSTRAINT UNIQUE_CustomerAK UNIQUE(CustomerAK);

	SELECT 
		IDENTITY(INT,1,1) AS 'VehicleSK',
		v.VehicleID AS 'VehicleAK',
		v.Make,
		v.Model,
		v.Year,
		v.Colour,
		v.Km,
		v.Price
		INTO [WonderfulWheelsDW].[dbo].[DimVehicle]
		FROM WonderfulWheels.dbo.Vehicle v

	ALTER TABLE [WonderfulWheelsDW].[dbo].[DimVehicle]
	ADD CONSTRAINT PK_DimVehicle_VehicleSK PRIMARY KEY (VehicleSK);

	ALTER TABLE [WonderfulWheelsDW].[dbo].[DimVehicle]
	ADD CONSTRAINT UNIQUE_VehicleAK UNIQUE(VehicleAK);

	SELECT
		IDENTITY(INT,1,1) AS 'DealershipSK',
		d.DealershipID AS 'DealershipAK',
		d.Name AS 'DealershipName',
		l.StreetAddress,
		l.City,
		l.Province,
		l.PostalCode
		INTO [WonderfulWheelsDW].[dbo].[DimDealership]
		FROM WonderfulWheels.dbo.Dealership d
		JOIN WonderfulWheels.dbo.Location l ON l.LocationID = d.LocationId
	
	ALTER TABLE [WonderfulWheelsDW].[dbo].[DimDealership]
	ADD CONSTRAINT PK_DimDealership_DealershipSK PRIMARY KEY (DealershipSK);

	ALTER TABLE [WonderfulWheelsDW].[dbo].[DimDealership]
	ADD CONSTRAINT UNIQUE_DealershipAK UNIQUE(DealershipAK);

	SELECT
		o.OrderID AS 'PK OrderId',
		IDENTITY(INT,1,1) AS 'PK OrderItemId',
		e.EmployeeID AS 'EmployeeSK',
		c.CustomerID AS 'CustomerSK',
		v.VehicleID AS 'VehicleSK',
		d.DealershipID AS 'DealershipSK',
		oi.FinalSalePrice AS 'OrderItem',
		o.OrderDate AS 'OrderDateSK',
		oi.FinalSalePrice * ce.Commission AS 'Comission'
		INTO [WonderfulWheelsDW].[dbo].[FactSales]
		FROM WonderfulWheels.dbo.[Order] o
		JOIN WonderfulWheels.dbo.Employee e ON e.EmployeeID = o.OrdEmpID
		JOIN WonderfulWheels.dbo.OrderItem oi ON oi.OrderID = o.OrderID
		JOIN WonderfulWheels.dbo.Customer c ON c.CustomerID = o.OrderCusID
		JOIN WonderfulWheels.dbo.Vehicle v ON v.VehicleID = oi.VehicleID
		JOIN WonderfulWheels.dbo.Dealership d ON d.DealershipID = o.OrdDealID
		JOIN WonderfulWheels.dbo.CommissionEmployee ce ON ce.EmployeeID = e.EmployeeID
	

	SELECT
		IDENTITY(INT,100,1) AS 'PK OrderId',
		IDENTITY(INT,1,1) AS 'PK OrderItemId',
		e.EmployeeSK AS 'EmployeeSK',
		c.CustomerSK AS 'CustomerSK',
		v.VehicleSK AS 'VehicleSK',
		d.DealershipSK AS 'DealershipSK',
		v.Price + 10000 AS 'OrderItem',
		e.??  AS 'OrderDateSK',
		v.Price + 1000 * e.Commission AS 'Comission'
		INTO [WonderfulWheelsDW].[dbo].[FactSales]
		FROM WonderfulWheelsDW.dbo.DimCommissionEmployee e
		JOIN WonderfulWheelsDW.dbo.DimCustomer c ON c.CustomerAK != 0
		JOIN WonderfulWheelsDW.dbo.DimDealership d ON d.DealershipSK != 0
		JOIN WonderfulWheelsDW.dbo.DimVehicle v ON v.VehicleAK != 0
		
	
	ALTER TABLE [WonderfulWheelsDW].[dbo].[FactSales]
	ADD CONSTRAINT FK_FactSales_EmployeeSK FOREIGN KEY(EmployeeSK)
	REFERENCES [WonderfulWheelsDW].[dbo].[DimCommissionEmployee](EmployeeAK)

	ALTER TABLE [WonderfulWheelsDW].[dbo].[FactSales]
	ADD CONSTRAINT FK_FactSales_CustomerSK FOREIGN KEY(CustomerSK)
	REFERENCES [WonderfulWheelsDW].[dbo].[DimCustomer](CustomerAK)

	ALTER TABLE [WonderfulWheelsDW].[dbo].[FactSales]
	ADD CONSTRAINT FK_FactSales_VehicleSK FOREIGN KEY(VehicleSK)
	REFERENCES [WonderfulWheelsDW].[dbo].[DimVehicle](VehicleAK)
	
	ALTER TABLE [WonderfulWheelsDW].[dbo].[FactSales]
	ADD CONSTRAINT FK_FactSales_DealershipSK FOREIGN KEY(DealershipSK)
	REFERENCES [WonderfulWheelsDW].[dbo].[DimDealership](DealershipAK)
	
	ALTER TABLE [WonderfulWheelsDW].[dbo].[FactSales]
	ADD CONSTRAINT PK_FactSales_CompositePrimaryKey
	PRIMARY KEY([PK OrderId],[PK OrderItemId],EmployeeSK,CustomerSK,VehicleSK,DealershipSK);
	
GO

USE WonderfulWheelsDW;
	SELECT * FROM DimCommissionEmployee
	SELECT * FROM DimCustomer
	SELECT * FROM DimVehicle
	SELECT * FROM DimDealership
	SELECT * FROM FactSales