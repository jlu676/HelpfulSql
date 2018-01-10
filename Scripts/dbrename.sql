

DECLARE @srcdbname VARCHAR(1000) = 'Retailbase'
DECLARE @newdbname VARCHAR(1000) = 'RetailJustin'



DECLARE @files TABLE (
	FilePath VARCHAR(max)
	,FileName VARCHAR(max)
	,NAME VARCHAR(max)
	)

INSERT INTO @files (
	filepath
	,filename
	,NAME
	)
EXEC (
		'USE [' + @srcdbname + '] SELECT 
master.dbo.GetFilePath(physical_name) as [FilePath],
master.dbo.GetFileName(physical_name) as [FileName],
name
FROM sys.database_files'
		)



EXEC ('ALTER DATABASE ' + @srcdbname + ' SET OFFLINE')

DECLARE @MyCursor CURSOR;
DECLARE @SQlCommand NVARCHAR(MAX) 
DECLARE @DosCommand VARCHAR(1000) 
DECLARE @Commands TABLE (
		sqlcommand NVARCHAR(MAX)
		,doscommand VARCHAR(1000)
		) 
		
		
INSERT INTO @Commands (
	sqlcommand
	,doscommand
	)
SELECT 'ALTER DATABASE [' + @srcdbname + '] MODIFY FILE (Name=' + REPLACE(NAME, @srcdbname, @newdbname) + ', FILENAME=''' + filepath + REPLACE(Filename, @srcdbname, @newdbname) + ''')' AS [sqlcommand]
	,'move ' + filepath + Filename + ' ' + filepath + REPLACE(Filename, @srcdbname, @newdbname) AS [doscommand]
FROM @files
 
	
	
	
	BEGIN
	SET @MyCursor = CURSOR
	FOR

	SELECT sqlcommand
		,doscommand
	FROM @Commands

	OPEN @MyCursor

	FETCH NEXT
	FROM @MyCursor
	INTO @SQlCommand
		,@DosCommand

	WHILE @@FETCH_STATUS = 0
	BEGIN

		PRINT @SQlcommand
		PRINT @DosCommand
		
		
		exec sp_executesql @SQlcommand
		EXEC xp_cmdshell @DosCommand

		FETCH NEXT
		FROM @MyCursor
		INTO @SQlCommand
			,@DosCommand
	END;

	CLOSE @MyCursor

	DEALLOCATE @MyCursor
END
 

	EXEC ('ALTER DATABASE ' + @srcdbname + ' SET ONLINE')

	EXEC master..sp_renamedb @srcdbname,@newdbname 
	
	
