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
PRINT N'Creating [dbo].[Employees]'
GO
CREATE TABLE [dbo].[Employees]
(
[EmployeeID] [int] NOT NULL IDENTITY(1, 1),
[EmployeeName] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[Company] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[Initials] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[Office] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[Email] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Department] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Employees] on [dbo].[Employees]'
GO
ALTER TABLE [dbo].[Employees] ADD CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED  ([EmployeeID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Offices]'
GO
CREATE TABLE [dbo].[Offices]
(
[OfficeID] [bigint] NOT NULL IDENTITY(1, 1),
[OfficeCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Offices] on [dbo].[Offices]'
GO
ALTER TABLE [dbo].[Offices] ADD CONSTRAINT [PK_Offices] PRIMARY KEY CLUSTERED  ([OfficeID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[UserCheckBy]'
GO
CREATE TABLE [dbo].[UserCheckBy]
(
[checkByID] [bigint] NOT NULL IDENTITY(1, 1),
[checkByName] [nvarchar] (200) COLLATE Latin1_General_CI_AS NULL,
[checkByEmail] [nvarchar] (200) COLLATE Latin1_General_CI_AS NULL,
[checkByCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_UserCheckBy] on [dbo].[UserCheckBy]'
GO
ALTER TABLE [dbo].[UserCheckBy] ADD CONSTRAINT [PK_UserCheckBy] PRIMARY KEY CLUSTERED  ([checkByID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[UserFunction]'
GO
CREATE TABLE [dbo].[UserFunction]
(
[FuncID] [bigint] NOT NULL IDENTITY(1, 1),
[FuncName] [nvarchar] (150) COLLATE Latin1_General_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_UserFunction] on [dbo].[UserFunction]'
GO
ALTER TABLE [dbo].[UserFunction] ADD CONSTRAINT [PK_UserFunction] PRIMARY KEY CLUSTERED  ([FuncID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[UserFunction]'
GO
ALTER TABLE [dbo].[UserFunction] ADD CONSTRAINT [IX_UserFunction] UNIQUE NONCLUSTERED  ([FuncName])
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