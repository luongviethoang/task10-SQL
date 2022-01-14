USE AdventureWorks2014
GO

CREATE PROCEDURE sp_DisplayEmployeeHireYear10
    @HireYear INT
AS 
SELECT * FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate) = @HireYear
GO

EXECUTE sp_DisplayEmployeeHireYear10 2009


CREATE PROCEDURE sp_EmployeesHireYearCount10
     @HireYear int,
	 @Count int OUTPUT 
AS
SELECT @Count = COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate) = @HireYear
GO

DECLARE @Number INT
EXECUTE sp_EmployeesHireYearCount10 2009, @Number OUTPUT
PRINT @Number

CREATE PROCEDURE sp_EmployeesHireYearCount10_2
     @HireYear int 
AS 
DECLARE @count INT
SELECT @count = COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate) = @HireYear
RETURN @count

DECLARE @Number INT 
EXECUTE @Number = sp_EmployeesHireYearCount10_2 2009
PRINT @Number


CREATE TABLE #Student
(
    RollNo VARCHAR(6) PRIMARY KEY,
	FullName NVARCHAR(100),
	Birthday DATETIME DEFAULT DATEADD(YY, -18, GETDATE())
)
GO

CREATE PROCEDURE #spInsertStudents
    @rollNo VARCHAR(6),
	@fullName NVARCHAR(100),
	@birthday DATETIME
AS BEGIN
   IF(@birthday IS NULL)
        SET @birthday = DATEADD(YY, -18, GETDATE())
   INSERT INTO #Student(RollNo, FullName, Birthday)
          VALUES (@rollNo, @fullName, @birthday)
   END
GO 

EXEC #spInsertStudents 'A12345', 'abc', NULL
EXEC #spInsertStudents 'A54321', 'abc', '2011/12/24'

SELECT * FROM #Student

CREATE PROCEDURE #spDeleteStudents
     @rollNo varchar(6)
AS BEGIN 
      DELETE FROM #Student WHERE RollNo = @rollNo
END 

EXECUTE #spDeleteStudents 'A12345'
GO 




CREATE PROCEDURE Cal_Square 
     @num INT = 0
AS 
BEGIN 
     RETURN (@num * @num)
END 
GO 


DECLARE @square INT
EXEC @square = dbo.Cal_Square @num = 10 -- int
PRINT @square
GO 

SELECT OBJECT_DEFINITION(OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')) 
AS DEFINITION

SELECT definition FROM sys.sql_modules
WHERE OBJECT_ID = OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')
GO

sp_depends 'HumanResources.uspUpdateEmployeePersonalInfo'
GO 


CREATE PROCEDURE sp_DisplayEmployees 
AS 
SELECT * FROM HumanResources.Employee
GO

ALTER PROCEDURE dbo.sp_DisplayEmpkoyees AS
SELECT * FROM HumanResources.Employee
WHERE Gender = 'F'
GO

EXEC dbo.sp_DisplayEmpkoyees
GO

CREATE PROCEDURE sp_EmployeeHire
AS 
BEGIN 
     EXECUTE sp_DisplayEmployeesHireYear 2009
	 DECLARE @number INT
	 EXECUTE sp_EmployeesHireYearCount 2009, @number OUTPUT 
	 PRINT N'Số nhân viên vào làm năm 2009 là: ' + CONVERT(VARCHAR(3), @number)
END 
GO

EXEC dbo.sp_EmployeeHire
GO 


ALTER PROCEDURE dbo.sp_EmployeeHire
    @HireYear INT 
AS BEGIN
   BEGIN TRY 
        EXECUTE dbo.sp_DisplayEmployeeHireYear @HireYear 
		DECLARE @Number INT
		--Lỗi xảy ra ở đây có thủ tục sp_EmployeesHireYearCount chỉ truyền 2 tham số mà ta truyền 3
		EXECUTE dbo.sp_DisplayEmployeeHireYearCount @HireYear , @Number OUTPUT, '123'
		PRINT N'Số nhân viên vào làm năm là: ' + CONVERT(VARCHAR(3), @Number)
	END TRY 
		BEGIN CATCH 
		     PRINT N'Có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
		END CATCH 
		PRINT N'Kết thúc thủ tục lưu trữ'
   END 
GO 

EXEC dbo.sp_EmplyeeHire 2009 




ALTER PROCEDURE sp_EmployeeHire
     @HireYear int
AS
BEGIN
    EXECUTE sp_DisplayEmployeesHireYear @HireYear
    DECLARE @Number int
    --Lỗi xảy ra ở đây có thủ tục sp_EmployeesHireYearCount chỉ truyền 2 tham số mà ta truyền 3
    EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT, '123'
    IF @@ERROR <> 0
    PRINT N'Có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
    PRINT N'Số nhân viên vào làm năm là: ' + CONVERT(varchar(3),@Number)
END
GO

EXEC sp_EmployeeHire 2009