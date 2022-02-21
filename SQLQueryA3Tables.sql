

drop table DeliveryOrder    
drop table DriverShift
drop table DriverStaff
drop table PickupOrder
drop table WalkInOrder
drop table PhoneOrder
drop table QuantityOrderMenuItem
drop table Orders
drop table Customer
drop table MenuItemMadeofIngredients
drop table MenuItem
drop table MenuSellingPrice
drop table IngredientsQuantityIngredientOrder
drop table Ingredients
drop table IngredientStock
drop table IngredientOrder
drop table InstoreShift
drop table DriverPay
drop table DriverPayRecord
drop table InstorePay
drop table InstorePayRecord
drop table InstoreStaff




CREATE TABLE InstoreStaff(
StaffId		VARCHAR(10) PRIMARY KEY,
fName		VARCHAR(50),
lName		VARCHAR(50), 
ADDRESS		VARCHAR(20) NOT NULL, 
ContactNo	CHAR(10) NOT NULL, 
taxFileNo	CHAR(12) NOT NULL, 
BankCode	CHAR(6) NOT NULL, 
bName		VARCHAR(20) NOT NULL, 
accNo		CHAR(10) NOT NULL, 
Status		VARCHAR(20), 
HourlyRate	VARCHAR(10) NOT NULL
);

CREATE TABLE Customer (
CustomerID		CHAR(10)		PRIMARY KEY,
firstName		VARCHAR(20)	NOT NULL,
lastname		VARCHAR(20) NOT NULL,
Address		VARCHAR(200) NOT NULL,
phoneNumber		VARCHAR(10) NOT NULL,
isHoax			VARCHAR(10) DEFAULT 'unverified',
CHECK(isHoax IN ('verified', 'unverified'))
);

CREATE TABLE Orders (
OrderNo		CHAR(10)		PRIMARY KEY,
OrderDateTime	DATETIME2,	
OrderType		VARCHAR(10),
TotalAmountDue	FLOAT,
PaymentMethod	VARCHAR(20) NOT NULL,
PaymentApprovalNo VARCHAR(20) NOT NULL,
OrderStatus VARCHAR (20),
CustomerID	CHAR(10),
StaffId		VARCHAR(10),
FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY(StaffId) REFERENCES InstoreStaff(StaffId) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE WalkInOrder (
OrderNo		CHAR(10)		PRIMARY KEY,
WalkInTime	DATETIME2,	
FOREIGN KEY (OrderNo) REFERENCES Orders(OrderNo) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE PhoneOrder (
OrderNo		CHAR(10)		PRIMARY KEY,
TimeCallAnswered	DATETIME2,	
TimeCallTerminated	DATETIME2,
FOREIGN KEY (OrderNo) REFERENCES Orders(OrderNo) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE PickupOrder (
OrderNo		CHAR(10)		PRIMARY KEY,
PickupTime	DATETIME2,	
FOREIGN KEY (OrderNo) REFERENCES Orders(OrderNo) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE DriverPayRecord(
TotalAmountPaid		VARCHAR(20) PRIMARY KEY,
GrossPayment		CHAR(20),
TaxWithheld			CHAR(20)
);

CREATE TABLE DriverPay(
RecordId		VARCHAR(10) PRIMARY KEY, 
TotalAmountPaid	VARCHAR(20), 
Date			DATE, 
PeriodStartDate	DATE, 
PeriodEndDate	DATE,
FOREIGN KEY (TotalAmountPaid) REFERENCES DriverPayRecord(TotalAmountPaid) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE DriverStaff(
StaffId		VARCHAR(10) PRIMARY KEY,
fName		VARCHAR(50),
lName		VARCHAR(50), 
ADDRESS		VARCHAR(20) NOT NULL, 
ContactNo	CHAR(10) NOT NULL, 
taxFileNo	CHAR(12) NOT NULL, 
BankCode	CHAR(6) NOT NULL, 
bName		VARCHAR(20) NOT NULL, 
accNo		CHAR(10) NOT NULL, 
Status		VARCHAR(20), 
DeliveryRate	VARCHAR(10) NOT NULL, 
DriverLicense	VARCHAR(8)
);

CREATE TABLE DriverShift(
RecordId		VARCHAR(10) PRIMARY KEY, 
StartDate		DATE,
StartTime		TIME,
EndDate			DATE, 
EndTime			TIME, 
StaffId			VARCHAR(10),
DriverPayRecordId	VARCHAR(10),
FOREIGN KEY (StaffId) REFERENCES DriverStaff (StaffId)ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (DriverPayRecordId) REFERENCES DriverPay(RecordId)ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE DeliveryOrder (
OrderNo		CHAR(10)		PRIMARY KEY,
Address		VARCHAR(200) NOT NULL,
DeliveryTime	DATETIME2,
RecordId	VARCHAR(10),
FOREIGN KEY (OrderNo) REFERENCES Orders(OrderNo) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY(RecordId) REFERENCES DriverShift (RecordId) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE MenuSellingPrice(
CurrentSellingPrice	FLOAT	PRIMARY KEY,
Small		VARCHAR(20)  ,
Medium 		VARCHAR(10)  ,
Large 		VARCHAR(10)  
);

CREATE TABLE MenuItem(
ItemCode		CHAR(10)	PRIMARY KEY,
Name		VARCHAR(20) NOT NULL,
Size		VARCHAR(10) NOT NULL,
Price		FLOAT,
CurrentSellingPrice FLOAT,
Description VARCHAR(50),
FOREIGN KEY (CurrentSellingPrice) REFERENCES MenuSellingPrice (CurrentSellingPrice) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IngredientStock(
StockLevel	CHAR(20) PRIMARY KEY,
SuggestedStockLevel	VARCHAR(20),
ReorderLevel	VARCHAR(20)
);
 
CREATE TABLE Ingredients(
Code	VARCHAR(10) PRIMARY KEY,
Name	VARCHAR(40) NOT NULL, 
Type	VARCHAR(40) NULL, 
Description	VARCHAR(40) NULL, 
StockLevel	CHAR(20) NOT NULL,
DateLastStockTake DATE,
FOREIGN KEY (StockLevel) REFERENCES IngredientStock(StockLevel) ON UPDATE CASCADE ON DELETE CASCADE
);

 CREATE TABLE IngredientOrder(
 OrderNo	VARCHAR(10) PRIMARY KEY,
 Date		DATE,
 ReceivedDate	DATE,
 Status			VARCHAR(60),
 Description	VARCHAR(60),
 quantity		int,
 ToTalAmount	CHAR(20)
 );

CREATE TABLE QuantityOrderMenuItem (
ItemCode	CHAR(10) NOT NULL,
OrderNo		CHAR(10) NOT NULL,
quantity	int NOT NULL,
PRIMARY KEY	(ItemCode, OrderNo, quantity),	
FOREIGN KEY (OrderNo) REFERENCES Orders(OrderNo) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (ItemCode) REFERENCES MenuItem(ItemCode) ON UPDATE CASCADE ON DELETE CASCADE
); 

CREATE TABLE MenuItemMadeofIngredients (
ItemCode	CHAR(10) NOT NULL,
Code		VARCHAR(10) NOT NULL,
quantity	int NOT NULL,
PRIMARY KEY	(ItemCode, Code, quantity),	
FOREIGN KEY (Code) REFERENCES Ingredients(Code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (ItemCode) REFERENCES MenuItem(ItemCode) ON UPDATE CASCADE ON DELETE CASCADE
); 

CREATE TABLE IngredientsQuantityIngredientOrder (
Code		VARCHAR(10) NOT NULL,
OrderNo		VARCHAR(10) NOT NULL,
quantity	int NOT NULL,
PRIMARY KEY	(Code, OrderNo, quantity),	
FOREIGN KEY (Code) REFERENCES Ingredients(Code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (OrderNo) REFERENCES IngredientOrder(OrderNo) ON UPDATE CASCADE ON DELETE CASCADE
); 


CREATE TABLE InstorePayRecord(
TotalAmountPaid		VARCHAR(20) PRIMARY KEY,
GrossPayment		CHAR(20),
TaxWithheld			CHAR(20)
);

CREATE TABLE InstorePay(
RecordId		VARCHAR(10) PRIMARY KEY, 
TotalAmountPaid	VARCHAR(20), 
Date			DATE, 
PeriodStartDate	DATE, 
PeriodEndDate	DATE,
Foreign Key (TotalAmountPaid) references InstorePayRecord(TotalAmountPaid)ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE InstoreShift(
RecordId		CHAR(10) PRIMARY KEY, 
StartDate		DATE,
StartTime		TIME,
EndDate			DATE, 
EndTime			TIME, 
StaffId			VARCHAR(10) NOT NULL,
InstorePayRecordId	VARCHAR(10) NOT NULL,
Foreign Key (StaffId) references InstoreStaff (StaffId)ON UPDATE CASCADE ON DELETE CASCADE,
Foreign Key (InstorePayRecordId) references DriverPay(RecordId)ON UPDATE CASCADE ON DELETE CASCADE
);



