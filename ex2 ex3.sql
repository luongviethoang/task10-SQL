IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'Task10_BTTL')
	DROP DATABASE Task10_BTTL
GO
CREATE DATABASE Task10_BTTL
USE Task10_BTTL
go
-- tạo bảng Toys
CREATE TABLE Toys (
	ProductCode VARCHAR(5) PRIMARY KEY,
	Name VARCHAR(30),
	Category VARCHAR(30),
	Manufacturer VARCHAR(40),
	AgeRange VARCHAR(15),
	UnitPrice MONEY,
	Netweight INT,
	QtyOnHand INT
)
go
-- Thêm dữ liệu
INSERT INTO Toys (ProductCode, Name, Category, Manufacturer, AgeRange, UnitPrice, Netweight, QtyOnHand)
	VALUES
		('A1', 'Small Car', 'Car Toy 1', '2021-11-03', '3 - 6', 10000, 100, 12),
		('A2', 'Medium Car', 'Car Toy 2', '2021-11-05', '3 - 7', 20000, 500, 20),
		('A3', 'Big Car', 'Car Toy 3', '2021-11-08', '5 - 10', 50000, 1000, 30),
		('A4', 'Small BarbieGirl', 'Doll 1', '2021-12-03', '2 - 5', 15000, 50, 15),
		('A5', 'Medium BarbieGirl', 'Doll 2', '2021-12-05', '3 - 6', 25000, 100, 50),
		('A6', 'Big BarbieGirl', 'Doll 3', '2021-12-08', '4 - 8', 50000, 300, 70),
		('A7', 'Small Water Gun', 'Gun Toy 1', '2022-01-03', '5 - 7', 100000, 200, 40),
		('A8', 'Medium Water Gun', 'Gun Toy 2', '2022-01-05', '5 - 9', 150000, 300, 25),
		('A9', 'Big Water Gun', 'Gun Toy 3', '2022-01-08', '5 - 12', 200000, 600, 70),
		('A10', 'Spider Man', 'Doll 4', '2021-10-03', '3 - 8', 120000, 400, 60)
GO		
-- Viết câu lệnh tạo Thủ tục lưu trữ có tên là HeavyToys cho phép liệt kê tất cả các loại đồ chơi có trọng lượng lớn hơn 500g.
CREATE PROCEDURE HeavyToys
AS
SELECT Category FROM Toys 
WHERE Netweight > 500
GO
EXECUTE HeavyToys
go
-- Viết câu lệnh tạo Thủ tục lưu trữ có tên là PriceIncrease cho phép tăng giá của tất cả các loại đồ chơi lên thêm 10000 đơn vị giá.
SELECT * FROM Toys
go
CREATE PROCEDURE PriceIncrease
AS
UPDATE Toys
SET UnitPrice += 10000
GO
EXEC PriceIncrease
GO
SELECT * FROM Toys
GO
-- Viết câu lệnh tạo Thủ tục lưu trữ có tên là QtyOnHand làm giảm số lượng đồ chơi còn trong của hàng mỗi thứ 5 đơn vị.
CREATE PROCEDURE QtyOnHand
AS
UPDATE Toys
SET QtyOnHand -= 5
GO
EXEC QtyOnHand
GO
SELECT * FROM Toys
GO
-- Bài Tập Về Nhà
-- yêu cầu 1
-- sp_helptext
EXEC sp_helptext 'PriceIncrease'
GO
EXEC sp_helptext 'HeavyToys'
GO
EXEC sp_helptext 'QtyOnHand'
GO
-- sys.sql_modules
SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID('HeavyToys')
GO
SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID('PriceIncrease')
GO
SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID('QtyOnHand')
GO
-- OBJECT_DEFINITION()
SELECT OBJECT_DEFINITION(OBJECT_ID(N'HeavyToys')) AS PROCEDURES 
GO
SELECT OBJECT_DEFINITION(OBJECT_ID(N'PriceIncrease')) AS PROCEDURES 
GO
SELECT OBJECT_DEFINITION(OBJECT_ID(N'QtyOnHand')) AS PROCEDURES 
GO
-- 2. Viết câu lệnh hiển thị các đối tượng phụ thuộc của mỗi thủ tục lưu trữ trên
EXEC sp_depends 'HeavyToys'
GO
EXEC sp_depends 'PriceIncrease'
GO
EXEC sp_depends 'QtyOnHand'
GO
-- Chỉnh sửa thủ tục PriceIncrease và QtyOnHand thêm câu lệnh cho phép hiển thị giá trị mới đã được cập nhật của các trường (UnitPrice,QtyOnHand).
ALTER PROCEDURE PriceIncrease 
AS
BEGIN
	UPDATE Toys
	SET UnitPrice += 10000
	SELECT UnitPrice AS 'New Price' FROM Toys
END
GO
EXEC PriceIncrease
GO
ALTER PROCEDURE QtyOnHand 
AS
BEGIN
	UPDATE Toys
	SET QtyOnHand -= 5
	SELECT QtyOnHand AS 'New QTY' from Toys
END
GO
EXEC QtyOnHand
GO
-- Viết câu lệnh tạo thủ tục lưu trữ có tên là SpecificPriceIncrease thực hiện cộng thêm tổng số sản phẩm (giá trị trường QtyOnHand)vào giá của sản phẩm đồ chơi tương ứng.
CREATE PROCEDURE SpecificPriceIncrease
AS
BEGIN
	UPDATE Toys
	SET UnitPrice = UnitPrice + QtyOnHand
END
GO
-- Chỉnh sửa thủ tục lưu trữ SpecificPriceIncrease cho thêm tính năng trả lại tổng số các bản ghi được cập nhật.
ALTER PROCEDURE SpecificPriceIncrease
AS
BEGIN
	UPDATE Toys
	SET UnitPrice = UnitPrice + QtyOnHand
	SELECT COUNT(*) AS 'Updated' FROM Toys
END
GO
-- Chỉnh sửa thủ tục lưu trữ SpecificPriceIncrease cho phép gọi thủ tục HeavyToysbên trong nó
ALTER PROCEDURE SpecificPriceIncrease
AS
BEGIN
	UPDATE Toys
	SET UnitPrice = UnitPrice + QtyOnHand
	SELECT COUNT(*) AS 'Updated' FROM Toys
	EXEC HeavyToys
END
GO
-- Thực hiện điều khiển xử lý lỗi cho tất cả các thủ tục lưu trữ được tạo ra.
-- Xóa bỏ tất cả các thủ tục lưu trữ đã được tạo ra
DROP PROCEDURE HeavyToys
DROP PROCEDURE PriceIncrease
DROP PROCEDURE QtyOnHand
DROP PROCEDURE SpecificPriceIncrease