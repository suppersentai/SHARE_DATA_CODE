Title Publish Main Database from DACPAC
@ECHO OFF

:: Reference to url for more information https://docs.microsoft.com/en-us/sql/tools/sqlpackage?view=sql-server-ver15#publish-parameters-properties-and-sqlcmd-variables

REM *** Prepare parameters for executing ***

set "databaseSource=D:\SOURCE\DB\Db_3_0\VSA.SQLDB\DatabaseDeployment"
set "MSBuild=C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe"
set "SqlPackage=C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\SqlPackage.exe"

set "deployenv=DEV"

:: Drop & create new database or just migration True/False
set CreateNewDatabase=false
set WipeData=true

:: SQL Server information
set SQLServerInstance=TOANSM\MSI
set SQLServerUsername=sa
set SQLServerPassword=123
Set BlockOnPossibleDataLoss=false
:: SQL Server information

:: Geo information to create login user for Catalog database
set Geo=ema
set Geo_Login_Password=Vsa*12345#

:: Container code to create prefix database
set ContainerCode=CA

:: Container code information to create login user for Core & WorkingPaper database
set UserContainerCode=ca
set Contaner_Login_Password=Vsa*12345#


set "SQLServerSolution=%databaseSource%\DatabaseDeployment.sln"

set "Catalog_DACPAC=%databaseSource%\Catalog\bin\Local\Catalog.dacpac"

set "Core_DACPAC=%databaseSource%\Core\bin\Local\Core.dacpac"

set "WorkingPaper_DACPAC=%databaseSource%\WorkingPaper\bin\Local\WorkingPaper.dacpac"

REM *** End Prepare parameters for executing ***

ECHO Begin build SQL Server solution

"%MSBuild%" "%SQLServerSolution%" -nologo -nr:false -t:rebuild -p:Configuration=Local

ECHO End build SQL Server Projects

ECHO Begin publish to Catalog DB

"%SqlPackage%" /BlockOnPossibleDataLoss:%BlockOnPossibleDataLoss% /TargetDatabaseName:Catalog /TargetServerName:%SQLServerInstance% /TargetUser:%SQLServerUsername% /TargetPassword:%SQLServerPassword% /Action:Publish /Properties:CreateNewDatabase=%CreateNewDatabase% /SourceFile:%Catalog_DACPAC% /Variables:deployenv=%deployenv% /Variables:container=%UserContainerCode% /Variables:container_password=%Contaner_Login_Password% /Variables:geo=%Geo% /Variables:geo_password=%Geo_Login_Password% /Variables:WipeData=%WipeData%

ECHO End publish to Catalog DB

ECHO Begin publish to Core DB

"%SqlPackage%" /BlockOnPossibleDataLoss:%BlockOnPossibleDataLoss% /TargetDatabaseName:%ContainerCode%Core /TargetServerName:%SQLServerInstance% /TargetUser:%SQLServerUsername% /TargetPassword:%SQLServerPassword% /Action:Publish /Properties:CreateNewDatabase=%CreateNewDatabase% /SourceFile:%Core_DACPAC% /Variables:deployenv=%deployenv% /Variables:container=%UserContainerCode% /Variables:container_password=%Contaner_Login_Password% /Variables:geo=%Geo% /Variables:geo_password=%Geo_Login_Password% /Variables:WipeData=%WipeData%

ECHO End publish to Core DB

ECHO Begin publish to WorkingPaper DB

"%SqlPackage%" /BlockOnPossibleDataLoss:%BlockOnPossibleDataLoss% /TargetDatabaseName:%ContainerCode%WorkingPaper /TargetServerName:%SQLServerInstance% /TargetUser:%SQLServerUsername% /TargetPassword:%SQLServerPassword% /Action:Publish /Properties:CreateNewDatabase=%CreateNewDatabase% /SourceFile:%WorkingPaper_DACPAC% /Variables:deployenv=%deployenv% /Variables:container=%UserContainerCode% /Variables:container_password=%Contaner_Login_Password% /Variables:geo=%Geo% /Variables:geo_password=%Geo_Login_Password% /Variables:WipeData=%WipeData%

ECHO End publish to WorkingPaper DB

@pause

exit