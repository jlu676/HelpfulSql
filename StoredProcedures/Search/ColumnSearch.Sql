-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jerky676
-- Create date: 12/14/2017
-- =============================================
CREATE PROCEDURE ColumnSearch
	-- Add the parameters for the stored procedure here
	@searchterm VARCHAR(100),
	@DatabaseName VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ParmDefinition NVARCHAR(500);
	DECLARE @Query NVARCHAR(1000);

	SET @ParmDefinition = N'@SearchTerm Varchar(100)';
	SET @Query = 'Use [' + @DatabaseName + ']
		SELECT c.name AS ColName, t.name AS TableName
		FROM sys.columns c
		JOIN sys.tables t ON c.object_id = t.object_id
		WHERE c.name LIKE @searchterm';

	EXECUTE sp_executesql @Query,
		@ParmDefinition,
		@SearchTerm = @SearchTerm
END
GO


