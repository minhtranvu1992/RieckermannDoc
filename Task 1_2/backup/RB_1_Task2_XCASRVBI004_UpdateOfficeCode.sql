USE [LOD]
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateOfficeCode]    Script Date: 05/19/2016 10:16:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_UpdateOfficeCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_UpdateOfficeCode]
GO


