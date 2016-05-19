USE LOD
GO
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[Employees]'
GO
ALTER TABLE [dbo].[Employees] DROP CONSTRAINT [PK_Employees]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[Offices]'
GO
ALTER TABLE [dbo].[Offices] DROP CONSTRAINT [PK_Offices]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[UserCheckBy]'
GO
ALTER TABLE [dbo].[UserCheckBy] DROP CONSTRAINT [PK_UserCheckBy]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[UserFunction]'
GO
ALTER TABLE [dbo].[UserFunction] DROP CONSTRAINT [PK_UserFunction]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[UserFunction]'
GO
ALTER TABLE [dbo].[UserFunction] DROP CONSTRAINT [IX_UserFunction]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[UserFunction]'
GO
DROP TABLE [dbo].[UserFunction]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[UserCheckBy]'
GO
DROP TABLE [dbo].[UserCheckBy]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[Offices]'
GO
DROP TABLE [dbo].[Offices]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[Employees]'
GO
DROP TABLE [dbo].[Employees]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO