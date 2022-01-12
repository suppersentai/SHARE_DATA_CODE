
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
