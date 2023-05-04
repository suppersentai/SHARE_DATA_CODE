
--- tìm  giá trị trên all table 
DECLARE @SearchText nvarchar(255) = 'Bp70CORL~0Cn7zXPolZd]>hu'
DECLARE @SearchTableName nvarchar(255) = NULL 
DECLARE @SearchColumnName nvarchar(255) = NULL 

DECLARE @SearchColumnValue nvarchar(255)
, @SearchInXML bit
, @FullRowResult bit
, @FullRowResultRows int SET @SearchColumnValue = '%'+@SearchText+'%' 	/* use LIKE syntax */ 

SET @FullRowResult = 1 
SET @FullRowResultRows = 3
SET @SearchTableName = NULL /* NULL for all tables, uses LIKE syntax */
SET @SearchColumnName = NULL /* NULL for all columns, uses LIKE syntax */ 
SET @SearchInXML = 0 /* Searching XML data may be slow */ 
IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results 
CREATE TABLE #Results (TableName nvarchar(128), ColumnName nvarchar(128), ColumnValue nvarchar(max),ColumnType nvarchar(20)) SET NOCOUNT ON DECLARE @TableName nvarchar(256) = '',@ColumnName nvarchar(128),@ColumnType nvarchar(20), @QuotedSearchStrColumnValue nvarchar(110), @QuotedSearchStrColumnName nvarchar(110) SET @QuotedSearchStrColumnValue = QUOTENAME(@SearchColumnValue,'''') DECLARE @ColumnNameTable TABLE (COLUMN_NAME nvarchar(128),DATA_TYPE nvarchar(20)) WHILE @TableName IS NOT NULL BEGIN SET @TableName = ( SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME LIKE COALESCE(@SearchTableName,TABLE_NAME) AND QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName AND OBJECTPROPERTY(OBJECT_ID(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)), 'IsMSShipped') = 0 ) IF @TableName IS NOT NULL BEGIN DECLARE @sql VARCHAR(MAX) SET @sql = 'SELECT QUOTENAME(COLUMN_NAME),DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = PARSENAME(''' + @TableName + ''', 2) AND TABLE_NAME = PARSENAME(''' + @TableName + ''', 1) AND DATA_TYPE IN (' + CASE WHEN ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SearchColumnValue,'%',''),'_',''),'[',''),']',''),'-','')) = 1 THEN '''tinyint'',''int'',''smallint'',''bigint'',''numeric'',''decimal'',''smallmoney'',''money'',' ELSE '' END + '''char'',''varchar'',''nchar'',''nvarchar'',''timestamp'',''uniqueidentifier''' + CASE @SearchInXML WHEN 1 THEN ',''xml''' ELSE '' END + ') AND COLUMN_NAME LIKE COALESCE(' + CASE WHEN @SearchColumnName IS NULL THEN 'NULL' ELSE '''' + @SearchColumnName + '''' END + ',COLUMN_NAME)' INSERT INTO @ColumnNameTable EXEC (@sql) WHILE EXISTS (SELECT TOP 1 COLUMN_NAME FROM @ColumnNameTable) BEGIN PRINT @ColumnName SELECT TOP 1 @ColumnName = COLUMN_NAME,@ColumnType = DATA_TYPE FROM @ColumnNameTable SET @sql = 'SELECT ''' + @TableName + ''',''' + @ColumnName + ''',' + CASE @ColumnType WHEN 'xml' THEN 'LEFT(CAST(' + @ColumnName + ' AS nvarchar(MAX)), 4096),''' WHEN 'timestamp' THEN 'master.dbo.fn_varbintohexstr('+ @ColumnName + '),''' ELSE 'LEFT(' + @ColumnName + ', 4096),''' END + @ColumnType + ''' FROM ' + @TableName + ' (NOLOCK) ' + ' WHERE ' + CASE @ColumnType WHEN 'xml' THEN 'CAST(' + @ColumnName + ' AS nvarchar(MAX))' WHEN 'timestamp' THEN 'master.dbo.fn_varbintohexstr('+ @ColumnName + ')' ELSE @ColumnName END + ' LIKE ' + @QuotedSearchStrColumnValue INSERT INTO #Results EXEC(@sql) IF @@ROWCOUNT > 0 IF @FullRowResult = 1 BEGIN SET @sql = 'SELECT TOP ' + CAST(@FullRowResultRows AS VARCHAR(3)) + ' ''' + @TableName + ''' AS [TableFound],''' + @ColumnName + ''' AS [ColumnFound],''FullRow>'' AS [FullRow>],*' + ' FROM ' + @TableName + ' (NOLOCK) ' + ' WHERE ' + CASE @ColumnType WHEN 'xml' THEN 'CAST(' + @ColumnName + ' AS nvarchar(MAX))' WHEN 'timestamp' THEN 'master.dbo.fn_varbintohexstr('+ @ColumnName + ')' ELSE @ColumnName END + ' LIKE ' + @QuotedSearchStrColumnValue EXEC(@sql) END DELETE FROM @ColumnNameTable WHERE COLUMN_NAME = @ColumnName END END END SET NOCOUNT OFF SELECT TableName, ColumnName, ColumnValue, ColumnType, COUNT(*) AS Count FROM #Results GROUP BY TableName, ColumnName, ColumnValue, ColumnType
DROP TABLE #Results 





-- Tìm kiếm không dấu trong sql cần set COLLATE  column search sang SQL_Latin1_General_CP1_CS_AS.
-- Lưu ý: Có thể set cả database COLLATE sang SQL_Latin1_General_CP1_CS_AS
ALTER TABLE dbo.STUDENTS
ALTER COLUMN FullName VARCHAR(500) COLLATE SQL_Latin1_General_CP1_CI_AI;

-- Split string
CREATE FUNCTION [dbo].[split](
          @delimited NVARCHAR(MAX),
          @delimiter NVARCHAR(100)
        ) RETURNS @t TABLE (id INT IDENTITY(1,1), value NVARCHAR(MAX))
        AS
        BEGIN
          DECLARE @xml XML
          SET @xml = N'<t>' + REPLACE(@delimited,@delimiter,'</t><t>') + '</t>'

          INSERT INTO @t(value)
          SELECT  r.value('.','varchar(MAX)') as item
          FROM  @xml.nodes('/t') as records(r)
          RETURN
        END
		go
		select * from dbo.split('toi-la-toaj','-')
		
-- ========= Show time select - in message tab if time < 1 second =========		
 SET STATISTICS IO ON;
 GO
 SET STATISTICS TIME ON;
 GO
-- ========== remove cache sql =======================
CHECKPOINT; 
GO 
DBCC DROPCLEANBUFFERS; 
GO

		
		
--============================ PAGINNATION ===========================
SELECT *
From a
ORDER BY p.CreateDate DESC
OFFSET @ItemQuanity *( @PageIndex -1) ROW FETCH NEXT @ItemQuanity ROW ONLY

--============================ CREATED STORED PROCEDURE ===========================
-- =============================================
-- Author: Truong Chung Toan
-- Create date: 19/10/2020
-- Description:	
-- =============================================

CREATE PROCEDURE 

AS
BEGIN

END	
GO

--============================ CREATED STORED PROCEDURE END ===========================
--============================ TRANSACTION ===========================
-- =============================================
-- Author: Truong Chung Toan
-- Create date: 19/10/2020
-- Description:	
-- =============================================
  BEGIN TRAN
        BEGIN TRY	

            COMMIT 
        END TRY
        BEGIN CATCH
            ROLLBACK
            DECLARE @Msg NVARCHAR(500) = ERROR_MESSAGE()
            RAISERROR(@Msg, 16, 1)
        END CATCH


--============================ CREATED STORED PROCEDURE END ===========================

-- ========== FORMAT ================
 FORMAT( hd.TongCong, 'C', 'vi-vn') AS TongCong,
 

 -- Xóa tất cả table trong 1 db

 DECLARE @Sql NVARCHAR(500) DECLARE @Cursor CURSOR

SET @Cursor = CURSOR FAST_FORWARD FOR
SELECT DISTINCT sql = 'ALTER TABLE [' + tc2.TABLE_SCHEMA + '].[' +  tc2.TABLE_NAME + '] DROP [' + rc1.CONSTRAINT_NAME + '];'
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc1
LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc2 ON tc2.CONSTRAINT_NAME =rc1.CONSTRAINT_NAME

OPEN @Cursor FETCH NEXT FROM @Cursor INTO @Sql

WHILE (@@FETCH_STATUS = 0)
BEGIN
Exec sp_executesql @Sql
FETCH NEXT FROM @Cursor INTO @Sql
END

CLOSE @Cursor DEALLOCATE @Cursor
GO

EXEC sp_MSforeachtable 'DROP TABLE ?'
GO



--============================ DELETE ===========================
--============================ TRANSACTION ===========================


/* Drop all non-system stored procs */
DECLARE @name VARCHAR(128)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'P' AND category = 0 ORDER BY [name])

WHILE @name is not null
BEGIN
    SELECT @SQL = 'DROP PROCEDURE [dbo].[' + RTRIM(@name) +']'
    EXEC (@SQL)
    PRINT 'Dropped Procedure: ' + @name
    SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'P' AND category = 0 AND [name] > @name ORDER BY [name])
END
GO

/* Drop all views */
DECLARE @name VARCHAR(128)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'V' AND category = 0 ORDER BY [name])

WHILE @name IS NOT NULL
BEGIN
    SELECT @SQL = 'DROP VIEW [dbo].[' + RTRIM(@name) +']'
    EXEC (@SQL)
    PRINT 'Dropped View: ' + @name
    SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'V' AND category = 0 AND [name] > @name ORDER BY [name])
END
GO

/* Drop all functions */
DECLARE @name VARCHAR(128)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] IN (N'FN', N'IF', N'TF', N'FS', N'FT') AND category = 0 ORDER BY [name])

WHILE @name IS NOT NULL
BEGIN
    SELECT @SQL = 'DROP FUNCTION [dbo].[' + RTRIM(@name) +']'
    EXEC (@SQL)
    PRINT 'Dropped Function: ' + @name
    SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] IN (N'FN', N'IF', N'TF', N'FS', N'FT') AND category = 0 AND [name] > @name ORDER BY [name])
END
GO

/* Drop all Foreign Key constraints */
DECLARE @name VARCHAR(128)
DECLARE @constraint VARCHAR(254)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'FOREIGN KEY' ORDER BY TABLE_NAME)

WHILE @name is not null
BEGIN
    SELECT @constraint = (SELECT TOP 1 CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME = @name ORDER BY CONSTRAINT_NAME)
    WHILE @constraint IS NOT NULL
    BEGIN
        SELECT @SQL = 'ALTER TABLE [dbo].[' + RTRIM(@name) +'] DROP CONSTRAINT [' + RTRIM(@constraint) +']'
        EXEC (@SQL)
        PRINT 'Dropped FK Constraint: ' + @constraint + ' on ' + @name
        SELECT @constraint = (SELECT TOP 1 CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'FOREIGN KEY' AND CONSTRAINT_NAME <> @constraint AND TABLE_NAME = @name ORDER BY CONSTRAINT_NAME)
    END
SELECT @name = (SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'FOREIGN KEY' ORDER BY TABLE_NAME)
END
GO

/* Drop all Primary Key constraints */
DECLARE @name VARCHAR(128)
DECLARE @constraint VARCHAR(254)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'PRIMARY KEY' ORDER BY TABLE_NAME)

WHILE @name IS NOT NULL
BEGIN
    SELECT @constraint = (SELECT TOP 1 CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME = @name ORDER BY CONSTRAINT_NAME)
    WHILE @constraint is not null
    BEGIN
        SELECT @SQL = 'ALTER TABLE [dbo].[' + RTRIM(@name) +'] DROP CONSTRAINT [' + RTRIM(@constraint)+']'
        EXEC (@SQL)
        PRINT 'Dropped PK Constraint: ' + @constraint + ' on ' + @name
        SELECT @constraint = (SELECT TOP 1 CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'PRIMARY KEY' AND CONSTRAINT_NAME <> @constraint AND TABLE_NAME = @name ORDER BY CONSTRAINT_NAME)
    END
SELECT @name = (SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'PRIMARY KEY' ORDER BY TABLE_NAME)
END
GO

/* Drop all tables */
DECLARE @name VARCHAR(128)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'U' AND category = 0 ORDER BY [name])

WHILE @name IS NOT NULL
BEGIN
    SELECT @SQL = 'DROP TABLE [dbo].[' + RTRIM(@name) +']'
    EXEC (@SQL)
    PRINT 'Dropped Table: ' + @name
    SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'U' AND category = 0 AND [name] > @name ORDER BY [name])
END
GO
