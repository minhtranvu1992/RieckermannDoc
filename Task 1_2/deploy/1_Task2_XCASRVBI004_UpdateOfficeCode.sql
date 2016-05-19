USE [LOD]
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateOfficeCode]    Script Date: 05/19/2016 10:14:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_UpdateOfficeCode]
AS
BEGIN

BEGIN TRY
		IF OBJECT_ID('tempdb..#temp') is not null DROP TABLE #temp

		SELECT u.UserName,u.OfficeCode
		INTO #temp 
		FROM dbo.Users u
		WHERE u.UserName like '%_.%' and u.OfficeCode is null

		UPDATE #temp SET OfficeCode=UPPER(LEFT(UserName,3))

		UPDATE dbo.Users SET OfficeCode=u.OfficeCode
		FROM #temp u
		WHERE dbo.Users.UserName=u.UserName
END TRY
		--Catch Section
		BEGIN CATCH
		    /* rollback transaction if there is open transaction */
		    IF @@TRANCOUNT > 0	ROLLBACK TRANSACTION

		    
		    DECLARE @ErrorMessage NVARCHAR(4000),
				    @ErrorNumber INT,
				    @ErrorSeverity INT,
				    @ErrorState INT,
				    @ErrorLine INT,
				    @ErrorProcedure NVARCHAR(200)

		    /* Assign variables to error-handling functions that capture information for RAISERROR */
		    SELECT  @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(),
			    @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(),
			    @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-')

		    /* Building the message string that will contain original error information */
		    SELECT  @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, '
			+ 'Message: ' + ERROR_MESSAGE()

		    /* Raise an error: msg_str parameter of RAISERROR will contain the original error information */
		    RAISERROR (@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber,
			    @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine)

		END CATCH
END
GO


