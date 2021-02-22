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

--============================ CREATED STORED PROCEDURE ===========================
