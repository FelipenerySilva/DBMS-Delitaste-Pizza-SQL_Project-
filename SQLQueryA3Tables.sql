
-- Delitaste Pizza Basic Database System
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


-- Create required tables:

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
Foreign Key (InstorePayRecordId) references InstorePay(RecordId)ON UPDATE CASCADE ON DELETE CASCADE
);

-- Insert Data:

INSERT INTO InstoreStaff VALUES ('S0001', 'Ingel', 'Kate', '2/22 Riversdale rd', '0411223301', '111111222222', '019000', 'NAB', '5653666666', null, '20');
INSERT INTO InstoreStaff VALUES ('S0002', 'Angel', 'Kota', '2/40 Riversdale rd', '0411223302', '111111222233', '019000', 'NAB', '5653666665', null, '25');
INSERT INTO InstoreStaff VALUES ('S0003', 'Maria', 'Jane', '2/50 Riversdale St', '0411223303', '111111222234', '019000', 'NAB', '5653666667', null, '30');

INSERT INTO Customer VALUES ('C2040', 'Felipe', 'Silva', '2/28 Marine Parade','0422410808', 'verified');
INSERT INTO Customer VALUES ('C2041', 'Fabian', 'Silvaa', '2/30 Marine Parade','0422410809', 'verified');
INSERT INTO Customer VALUES ('C2042', 'John', 'Solsa', '2/50 Marine Parade 2','0422410807', 'verified');

INSERT INTO Orders VALUES ('00001','20210618 10:34:09 PM', 'Delivery', null, 'card', 'AA10555551', null, 'C2040', 'S0003');
INSERT INTO Orders VALUES ('00002','20210619 10:34:33 PM', 'Delivery', null, 'card', 'AA10555553', null, 'C2041', 'S0003');
INSERT INTO Orders VALUES ('00003','20210618 10:40:09 PM', 'Pickup', null, 'card', 'AA10555552', null, 'C2042', 'S0002');
INSERT INTO Orders VALUES ('00004','20210618 09:40:09 PM', 'Pickup', null, 'card', 'AA10555551', null, 'C2042', 'S0002');
INSERT INTO Orders VALUES ('00005','20210618 07:40:09 PM', 'Delivery', null, 'card', 'AA10555554', null, 'C2042', 'S0002');
INSERT INTO Orders VALUES ('00006','20210618 06:40:09 PM', 'Pickup', null, 'card', 'AA10555558', null, 'C2042', 'S0001');


INSERT INTO WalkInOrder VALUES ('00001', '20210618 10:40:09 PM');
INSERT INTO WalkInOrder VALUES ('00004', '20210618 10:41:09 PM');
INSERT INTO WalkInOrder VALUES ('00005', '20210618 10:43:11 PM');

INSERT INTO PhoneOrder VALUES ('00003', '20210618 10:34:09 PM', null);
INSERT INTO PhoneOrder VALUES ('00002', '20210619 10:34:33 PM', null);
INSERT INTO PhoneOrder VALUES ('00006', '20210618 10:44:09 PM', null);

INSERT INTO DriverStaff VALUES ('SA001', 'Mona', 'Katelyn', '2/22 Riversdale rd', '0411223301', '111111222222', '019000', 'NAB', '5653666666', '', '10', '8888999');
INSERT INTO DriverStaff VALUES ('SA005', 'John', 'Moon', '2/22 Riversdale rd', '0411223301', '111111222222', '019000', 'NAB', '5653666666', '', '10', '8888999');
INSERT INTO DriverStaff VALUES ('SA007', 'Paul', 'Kate', '2/22 Riversdale rd', '0411223301', '111111222222', '019000', 'NAB', '5653666666', '', '10', '8888999');


INSERT INTO DriverPayRecord VALUES ( '300', '360', '60');
INSERT INTO DriverPayRecord VALUES ( '350', '420', '70');
INSERT INTO DriverPayRecord VALUES ( '330', '360', '30');
INSERT INTO DriverPayRecord VALUES ( '303', '360', '60');
INSERT INTO DriverPayRecord VALUES ( '353', '420', '70');
INSERT INTO DriverPayRecord VALUES ( '333', '360', '30');

INSERT INTO DriverPay VALUES ('P0012', '300', '20210615', '20210606', '20210612');
INSERT INTO DriverPay VALUES ('P0013', '350', '20210530', '20210522', '20210528');
INSERT INTO DriverPay VALUES ('P0014', '330', '20210515', '20210506', '20210514');
INSERT INTO DriverPay VALUES ('P0022', '303', '20220215', '20220206', '20220212');
INSERT INTO DriverPay VALUES ('P0033', '353', '20220227', '20220222', '20220227');
INSERT INTO DriverPay VALUES ('P0044', '333', '20220215', '20220206', '20220214');


INSERT INTO DriverShift VALUES ('000221', '20210606', '04:34:09 PM', '20210606', '11:34:09 PM', 'SA001', 'P0012');
INSERT INTO DriverShift VALUES ('000222', '20210608', '04:30:09 PM', '20210608', '11:30:09 PM', 'SA005', 'P0012');
INSERT INTO DriverShift VALUES ('000223', '20210608', '04:31:09 PM', '20210608', '11:32:11 PM', 'SA007', 'P0014');
INSERT INTO DriverShift VALUES ('000321', '20220206', '04:34:09 PM', '20220206', '11:34:09 PM', 'SA001', 'P0022');
INSERT INTO DriverShift VALUES ('000322', '20220223', '04:30:09 PM', '20220223', '11:30:09 PM', 'SA005', 'P0033');
INSERT INTO DriverShift VALUES ('000323', '20220208', '04:31:09 PM', '20220208', '11:32:11 PM', 'SA007', 'P0044');


INSERT INTO DeliveryOrder VALUES ('00001', '2/22 Riversdale rd', '20210618 10:44:09 PM', '000221');
INSERT INTO DeliveryOrder VALUES ('00002', '2/55 Riversdale rd', '20210618 10:54:09 PM', '000222');
INSERT INTO DeliveryOrder VALUES ('00005', '2/55 Marine rd', '20210608 09:04:09 PM', '000223');

INSERT INTO MenuSellingPrice VALUES ( '30', '$10', '$20', '$30');
INSERT INTO MenuSellingPrice VALUES ( '10', '$10', '$20', '$30');
INSERT INTO MenuSellingPrice VALUES ( '20', '$10', '$20', '$30');

INSERT INTO MenuItem VALUES ('PZ001', 'Margarita', 'Large', '30', '30', 'Cheese and basil only');
INSERT INTO MenuItem VALUES ('PZ002', 'Salami', 'Large', '30', '30', 'Cheese and Salami');
INSERT INTO MenuItem VALUES ('PZ003', 'Seafood', 'Medium', '20', '20', 'Cheese and Seafood');

INSERT INTO IngredientStock VALUES ('2000', '1000', '500');
INSERT INTO IngredientStock VALUES ('5000', '2500', '1000');
INSERT INTO IngredientStock VALUES ('3000', '1500', '1000');

INSERT INTO Ingredients VALUES ( '0011', 'Cheese', 'Mozarella', 'cheese topping', '5000', '20210605');
INSERT INTO Ingredients VALUES ( '0012', 'Salami', 'hot', 'salami pizza', '2000', '20210605');
INSERT INTO Ingredients VALUES ( '0013', 'Seafood', 'Calamari', 'seafood topping', '3000', '20210605');

INSERT INTO IngredientOrder VALUES ('IN0012', '20210607', '20210610',null, null, 7000, null );
INSERT INTO IngredientOrder VALUES ('IN0010', '20210510', '20210515',null, null, 3000, null );
INSERT INTO IngredientOrder VALUES ('IN0009', '20210530', '20210603',null, null, 2000, null );

INSERT INTO QuantityOrderMenuItem VALUES ( 'PZ001', '00001', 2);
INSERT INTO QuantityOrderMenuItem VALUES ( 'PZ002', '00002', 1);
INSERT INTO QuantityOrderMenuItem VALUES ( 'PZ003', '00003', 2);

INSERT INTO MenuItemMadeofIngredients VALUES ('PZ001', '0011', 100);
INSERT INTO MenuItemMadeofIngredients VALUES ('PZ002', '0012', 100);
INSERT INTO MenuItemMadeofIngredients VALUES ('PZ002', '0011', 100);
INSERT INTO MenuItemMadeofIngredients VALUES ('PZ003', '0013', 100);
INSERT INTO MenuItemMadeofIngredients VALUES ('PZ003', '0011', 100);

INSERT INTO IngredientsQuantityIngredientOrder VALUES ( '0011', 'IN0012', 3000);
INSERT INTO IngredientsQuantityIngredientOrder VALUES ( '0012', 'IN0012', 2000);
INSERT INTO IngredientsQuantityIngredientOrder VALUES ( '0013', 'IN0012', 2000);

INSERT INTO InstorePayRecord VALUES ( '200', '250', '50');
INSERT INTO InstorePayRecord VALUES ( '300', '350', '50');
INSERT INTO InstorePayRecord VALUES ( '400', '450', '50');

INSERT INTO InstorePay VALUES ('PAY0010', '200', '20210615', '20210606', '20210612');
INSERT INTO InstorePay VALUES ('PAY0009', '300', '20210530', '20210522', '20210528');
INSERT INTO InstorePay VALUES ('PAY0008', '400', '20210515', '20210506', '20210512');

INSERT INTO InstoreShift VALUES ( 'SFT10', '20210606', '04:00:00 PM', '20210612', '11:30:00 PM', 'S0001', 'PAY0010');
INSERT INTO InstoreShift VALUES ( 'SFT09', '20210528', '04:00:00 PM', '20210528', '11:30:00 PM', 'S0001', 'PAY0009');
INSERT INTO InstoreShift VALUES ( 'SFT08', '20210512', '04:00:00 PM', '20210512', '11:30:00 PM', 'S0001', 'PAY0008');

-- 2.2.2 Implement the following queries (make sure to populate with enough and proper data into related tables so that non-void result is shown for each query.

--Q.1 For a instore staff with id number xxx (S0003), print his/her 1stname, lname, and hourly payment rate.

SELECT  fName, lName, HourlyRate
FROM    InstoreStaff
WHERE   StaffId='S0003'



--Q.2 List all the ingredient details of a menu item named xxx (Seafood).

SELECT  i.Name
FROM    MenuItemMadeofIngredients m, MenuItem n, Ingredients i
WHERE  m.ItemCode = n.ItemCode AND m.Code = i.Code AND n.Name = 'Seafood' 


--Q.3 List all the shift details of a delivery staff with first name xxx and last name ttt between date yyy and zzz

SELECT *
FROM	 DriverShift d, DriverStaff s
WHERE s.fName = 'Mona' AND s.lName = 'Katelyn' AND
	 d.StartDate BETWEEN'2021-06-01' AND '2021-06-30';



--Q.4 List all the order details of the orders that are made by a walk-in customer with first name xxx and last name ttt between date yyy and zzz.

SELECT  *
FROM    Orders o, Customer c, WalkInOrder w
WHERE   o.OrderNo = w.OrderNo AND c.firstName = 'Felipe' 
            AND c.lastname = 'Silva' AND c.CustomerID=o.CustomerID
            AND o.OrderDateTime BETWEEN'2021-06-01' AND '2021-06-30';

--Q.5 List all the order details of the orders that are taken by an in-office staff with first name xxx and last name ttt between date yyy and zzz.

SELECT   *
FROM    Orders o, InstoreStaff i
WHERE   i.StaffId = o.StaffId 
        AND i.fName = 'Maria' AND i.lName = 'Jane'
        AND o.OrderDateTime BETWEEN'2021-06-01' AND '2021-06-30';

 
--Q.6 Print the salary paid to a delivery staff named xxx in the current month. Note the current month is the current month that is decided by the system.

SELECT  p.TotalAmountPaid as 'salary paid'
FROM    DriverPay p, DriverShift s, DriverStaff d
WHERE   s.DriverpayRecordId = p.RecordId
    AND s.StaffId = d.StaffId
    AND d.fName = 'Mona'
    AND Month(p.Date) = Month(GetDate())
    
