CREATE DATABASE WonderfulWheels;
CREATE DATABASE EventLog;
GO


DROP DATABASE WonderfulWheels
DROP DATABASE WonderfulWheelsDW
DROP DATABASE EventLog

USE master

USE EventLog;
GO

BEGIN TRY
	BEGIN TRANSACTION

		CREATE TABLE DbErrorLog
			(
				ErrorID        INT IDENTITY(1, 1),
				UserName       VARCHAR(100),
				ErrorNumber    INT,
				ErrorState     INT,
				ErrorSeverity  INT,
				ErrorLine      INT,
				ErrorProcedure VARCHAR(MAX),
				ErrorMessage   VARCHAR(MAX),
				ErrorDateTime  DATETIME DEFAULT GETDATE()
			)

	COMMIT TRANSACTION

END TRY
BEGIN CATCH	

	ROLLBACK TRANSACTION		

		INSERT INTO dbo.DbErrorLog (UserName, ErrorNumber, ErrorState, ErrorSeverity, ErrorLine, ErrorProcedure, ErrorMessage)
		VALUES (SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE());		

END CATCH
GO
USE WonderfulWheels;

GO
BEGIN TRY
	BEGIN TRANSACTION
		CREATE TABLE Location(
			LocationID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
			StreetAddress VARCHAR(50),
			City VARCHAR(50),
			Province VARCHAR(25),
			PostalCode VARCHAR(6)
			)
		CREATE TABLE Dealership(
			DealershipID INT PRIMARY KEY IDENTITY(1,1),
			LocationId INT FOREIGN KEY REFERENCES Location(LocationID),
			Name VARCHAR(50),
			Phone VARCHAR(10)
			)
		CREATE TABLE Person(
			PersonID INT IDENTITY(1000,1) PRIMARY KEY NOT NULL,
			FirstName VARCHAR(25),
			LastName VARCHAR(25),
			Telephone VARCHAR(10),
			Email VARCHAR(50),
			PerLocID INT NOT NULL FOREIGN KEY REFERENCES Location(LocationID),
			DateOfBirth DATE,
			Title CHAR(2) CHECK(Title IN ('Mr','Ms'))
			)
		CREATE NONCLUSTERED INDEX Person_FirstName
		ON Person(FirstName);
		CREATE NONCLUSTERED INDEX Person_LastName
		ON Person(LastName);
		CREATE TABLE Employee(
			EmployeeID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Person(PersonID),
			EmpDealID INT FOREIGN KEY REFERENCES Dealership(DealershipID),
			HireDate DATE,
			Role VARCHAR(25),
			ManagerID INT NULL FOREIGN KEY REFERENCES Employee(EmployeeID)
			)
		CREATE TABLE Customer(
			CustomerID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Person(PersonID),
			RegistrationDate DATE
			)
		CREATE TABLE SalaryEmployee(
			EmployeeID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Employee(EmployeeID),
			Salary DECIMAL NOT NULL CHECK(Salary > 999)
		)
		CREATE TABLE CommissionEmployee(
			EmployeeID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Employee(EmployeeID),
			Commission INT NOT NULL CHECK(Commission > 9)
			)
		CREATE TABLE [Order](
			OrderID INT NOT NULL PRIMARY KEY,
			OrderCusID INT NOT NULL FOREIGN KEY REFERENCES Customer(CustomerID),
			OrdEmpID INT NOT NULL FOREIGN KEY REFERENCES Employee(EmployeeID),
			OrderDate DATE,
			OrdDealID INT NOT NULL FOREIGN KEY REFERENCES Dealership(DealershipID)
			)
		CREATE TABLE Vehicle(
			VehicleID INT NOT NULL PRIMARY KEY,
			Make VARCHAR(25),
			Model VARCHAR(25),
			Year  INT,
			Colour VARCHAR(25),
			Km DECIMAL,
			Price DECIMAL NOT NULL DEFAULT 0.00 CHECK(Price > 0)
			)
		CREATE TABLE OrderItem(
			OrderID INT NOT NULL FOREIGN KEY REFERENCES [Order](OrderID),
			VehicleID INT FOREIGN KEY REFERENCES Vehicle(VehicleID),
			FinalSalePrice DECIMAL NOT NULL DEFAULT 0.00 CHECK(FinalSalePrice >= 0), 
			)
		CREATE TABLE Account(
			AccountID INT PRIMARY KEY NOT NULL,
			CustomerID INT NOT NULL FOREIGN KEY REFERENCES Customer(CustomerID),
			AccountBalance DECIMAL NOT NULL CHECK(AccountBalance >= 0),
			LastPaymentAmount DECIMAL NOT NULL CHECK(LastPaymentAmount >= 0),
			LastPaymentDate DATE
			)
	COMMIT Transaction 

END TRY
BEGIN CATCH	

	ROLLBACK TRANSACTION		

	INSERT INTO EventLog.dbo.DbErrorLog (UserName, ErrorNumber, ErrorState, ErrorSeverity, ErrorLine, ErrorProcedure, ErrorMessage)
	VALUES (SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE());		

END CATCH
GO

BEGIN TRY
	BEGIN TRANSACTION

		-- Insert Location
		INSERT INTO Location(StreetAddress,City,Province,PostalCode)
		VALUES ('22 Queen St','Waterloo', 'Ontario', 'N2A48B'),
		('44 King St', 'Gulph', 'Ontario', 'G2A47U'),
		('55 Krug St', 'Kitchener', 'Ontario', 'N2A4U7'),
		('77 Lynn Ct', 'Toronto', 'Ontario', 'M7U4BA'),
		('221 Kitng St W', 'Kitchner', 'Ontario', 'G8B3C6'),
		('77 Victoria St N','Campbridge','Ontario','N1Z8B8'),
		('100 White Oak Rd', 'London', 'Ontario','L9B1W2'),
		('88 King St', 'Gulph', 'Ontario', 'G2A47U'),
		('99 Lynn Ct', 'Toronto', 'Ontario', 'M7U4BA'),
		('44 Cedar St', 'Kitchener', 'Ontario', 'N2A7L6')


		--Insert Person
		DECLARE @22QueenLocationID INT 
		DECLARE @44KingLocationID INT 
		DECLARE @55KrungLocationID INT 
		DECLARE @77LynnLocationID INT 
		DECLARE @88KingLocationID INT 
		DECLARE @99LynnLocationID INT 
		DECLARE @44CedarLocationID INT 



		SELECT TOP 1 @22QueenLocationID = LocationID FROM Location WHERE StreetAddress = '22 Queen St'
		SELECT TOP 1 @44KingLocationID = LocationID FROM Location WHERE StreetAddress = '44 King St'
		SELECT TOP 1 @55KrungLocationID = LocationID FROM Location WHERE StreetAddress = '55 Krug St'
		SELECT TOP 1 @77LynnLocationID = LocationID FROM Location WHERE StreetAddress = '77 Lynn Ct'
		SELECT TOP 1 @88KingLocationID = LocationID FROM Location WHERE StreetAddress = '88 King St'
		SELECT TOP 1 @99LynnLocationID = LocationID FROM Location WHERE StreetAddress = '99 Lynn Ct'
		SELECT TOP 1 @44CedarLocationID = LocationID FROM Location WHERE StreetAddress = '44 Cedar St'


		INSERT INTO Person(PerLocID,FirstName,LastName,Telephone,Email,DateOfBirth,Title)
		VALUES(@22QueenLocationID,'John','Smith','5194443333','jsmtith@email.com','1968-04-09','Mr'),
		(@44KingLocationID,'Mary','Brown','5198883333','mbrown@email.com','1972-02-04','Ms'),
		(@55KrungLocationID,'Tracy','Spencer','5198882222','tspencer@email.com','1998-07-22','Ms'),
		(@77LynnLocationID,'James', 'Stewart','4168881111','jstewart@email.com','1996-11-22','Mr'),
		(@55KrungLocationID,'Paul','Newman','5198884444','pnewman@email.com','1992-09-23','Mr'),

		--Customer data
		(@55KrungLocationID, 'Tom', 'Cruise', '5193332222','tcruise@email.com', '1962-3-22','Mr'),
		(@88KingLocationID, 'Bette', 'Davis', '5194521111',	'bdavis@email.com',	'1952-9-1',	'Ms'),
		(@99LynnLocationID, 'Grace', 'Kelly',	'4168872222',	'gkelly@email.com',	'1973-9-6',	'Ms'),
		(@44CedarLocationID, 'Doris', 'Day',	'5198885456',	'dday@email.com',	'1980-5-25', 'Ms')

		-- Insert Dealership
		DECLARE @LocationID5 INT 
		DECLARE @LocationID6 INT 
		DECLARE @LocationID7 INT 
		SELECT TOP 1 @LocationID5 = LocationID FROM Location WHERE StreetAddress = '221 Kitng St W'
		SELECT TOP 1 @LocationID6 = LocationID FROM Location WHERE StreetAddress = '77 Victoria St N'
		SELECT TOP 1 @LocationID7 = LocationID FROM Location WHERE StreetAddress = '100 White Oak Rd'


		INSERT INTO Dealership(LocationId,Name) 
		VALUES(@LocationID5,'Kitchener'),
		(@LocationID6,'Cambrige'),
		(@LocationID7,'London')

		-- Insert Employee
		DECLARE @JSmithPersonID INT 
		DECLARE @MBrownPersonID INT 
		DECLARE @TSpencerPersonID INT 
		DECLARE @JStelwartPersonID INT 
		DECLARE @PNewmanPersonID INT 

		DECLARE @KitchenerDelershipID INT 

		SELECT TOP 1 @JSmithPersonID = PersonID FROM Person WHERE Email = 'jsmtith@email.com'
		SELECT TOP 1 @MBrownPersonID = PersonID FROM Person WHERE Email = 'mbrown@email.com'
		SELECT TOP 1 @TSpencerPersonID = PersonID FROM Person WHERE Email = 'tspencer@email.com'
		SELECT TOP 1 @JStelwartPersonID = PersonID FROM Person WHERE Email = 'jstewart@email.com'
		SELECT TOP 1 @PNewmanPersonID = PersonID FROM Person WHERE Email = 'pnewman@email.com'

		SELECT TOP 1 @KitchenerDelershipID = DealershipID FROM Dealership WHERE Name = 'Kitchener'

		INSERT INTO Employee(EmployeeID,EmpDealID,Role,ManagerID)
		VALUES(@JSmithPersonID,@KitchenerDelershipID,'Manager',NULL),
		(@MBrownPersonID,@KitchenerDelershipID,'Office Admin',@JSmithPersonID),
		(@TSpencerPersonID,@KitchenerDelershipID,'Sales',@JSmithPersonID),
		(@JStelwartPersonID,@KitchenerDelershipID,'Sales',@JSmithPersonID),
		(@PNewmanPersonID,@KitchenerDelershipID,'Sales',@JSmithPersonID)


		-- Insert Salary
		INSERT INTO SalaryEmployee(EmployeeID,Salary)
		VALUES(@JSmithPersonID,95000),
		(@MBrownPersonID,65000) 


		-- Insert Commision
		INSERT INTO CommissionEmployee(EmployeeID,Commission)
		VALUES(@TSpencerPersonID,13),
		(@JStelwartPersonID,15),
		(@PNewmanPersonID,10) 


		--Insert Vehicle
		INSERT INTO Vehicle(VehicleID, Make, Model, Year, Colour, Km, Price)
		VALUES(100001,'Toyota','Corola',2018,'Silver',45000,18000),
		(100002,'Toyota','Corola',2016,'White',60000,15000),
		(100003,'Toyota','Corola',2016,'Black',65000,14000),
		(100004,'Toyota','Camry',2018,'White',35000,22000),
		(100005,'Honda','Acord',2020,'Gray',10000,24000),
		(100006,'Honda','Acord',2015,'Red',85000,16000),
		(100007,'Honda','Acord',2000,'Gray',10000,40000),
		(100008,'Ford','Focus',2017,'Blue',40000,16000)

		--Insert Customer
		DECLARE @TCruisePersonID INT 
		DECLARE @BDavisPersonID INT 
		DECLARE @GKellyPersonID INT 
		DECLARE @DDayPersonID INT 

		SELECT TOP 1 @TCruisePersonID = PersonID FROM Person WHERE Email = 'tcruise@email.com'
		SELECT TOP 1 @BDavisPersonID = PersonID FROM Person WHERE Email = 'bdavis@email.com'
		SELECT TOP 1 @GKellyPersonID = PersonID FROM Person WHERE Email = 'gkelly@email.com'
		SELECT TOP 1 @DDayPersonID = PersonID FROM Person WHERE Email = 'dday@email.com'


		INSERT INTO Customer(CustomerID)
		VALUES(@TCruisePersonID ),
		(@BDavisPersonID),
		(@TSpencerPersonID),
		(@GKellyPersonID),
		(@DDayPersonID)

		--Insert Order

		INSERT INTO [Order] (OrderID, OrderCusID, OrdEmpID, OrdDealID)
		VALUES (100, @TCruisePersonID, @TSpencerPersonID, @KitchenerDelershipID),
		(101, @BDavisPersonID, @TSpencerPersonID, @KitchenerDelershipID),
		(102, @TSpencerPersonID, @JStelwartPersonID, @KitchenerDelershipID)


		--Insert OrderItem

		INSERT INTO OrderItem(OrderID, VehicleID, FinalSalePrice)
		VALUES(100, 100001, 17500),
		(100, 100004, 21000),
		(101, 100008, 15000),
		(102, 100006, 15000)

	COMMIT Transaction 
END TRY
	BEGIN CATCH	
		ROLLBACK TRANSACTION		

		INSERT INTO EventLog.dbo.DbErrorLog (UserName, ErrorNumber, ErrorState, ErrorSeverity, ErrorLine, ErrorProcedure, ErrorMessage)
		VALUES (SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE());		

END CATCH
GO

