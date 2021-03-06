USE [master]
GO
/****** Object:  Database [ST_SAS]    Script Date: 3/28/2014 3:50:42 PM ******/
CREATE DATABASE [ST_SAS] ON  PRIMARY 
( NAME = N'ST_SAS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQL2008\MSSQL\DATA\ST_SAS.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ST_SAS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQL2008\MSSQL\DATA\ST_SAS_log.ldf' , SIZE = 1536KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ST_SAS] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ST_SAS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ST_SAS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ST_SAS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ST_SAS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ST_SAS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ST_SAS] SET ARITHABORT OFF 
GO
ALTER DATABASE [ST_SAS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ST_SAS] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ST_SAS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ST_SAS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ST_SAS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ST_SAS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ST_SAS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ST_SAS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ST_SAS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ST_SAS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ST_SAS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ST_SAS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ST_SAS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ST_SAS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ST_SAS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ST_SAS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ST_SAS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ST_SAS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ST_SAS] SET RECOVERY FULL 
GO
ALTER DATABASE [ST_SAS] SET  MULTI_USER 
GO
ALTER DATABASE [ST_SAS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ST_SAS] SET DB_CHAINING OFF 
GO
EXEC sys.sp_db_vardecimal_storage_format N'ST_SAS', N'ON'
GO
USE [ST_SAS]
GO
/****** Object:  StoredProcedure [dbo].[spDimGenericaUbicacionGeograficaRegional]    Script Date: 3/28/2014 3:50:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spDimGenericaUbicacionGeograficaRegional]
AS
BEGIN


--******************************************************************************
--******************************************************************************
--******************************************************************************
--Ingresando El valor no aplica
IF (SELECT COUNT(1) 
			FROM [dbo].[TMP_DimUbicacionGeografica]
				WHERE [IdUbicacionGeografica]=-2)<=0
	BEGIN

			SET IDENTITY_INSERT [dbo].[TMP_DimUbicacionGeografica] ON;

			INSERT INTO [dbo].[TMP_DimUbicacionGeografica]
				   (
					[IdUbicacionGeografica]
				   ,[IdUbicacionGeograficaPadre]
				   ,[CodigoUbicacionGeograficaPadre]
				   ,[DescripcionUbicacionGeograficaPadre]
				   ,[CodigoUbicacionGeografica]
				   ,[DescripcionUbicacionGeografica]
				   ,[Latitud]
				   ,[Longitu])
			 VALUES
				   (-2,
					null,
					'No Aplica',
					'No Aplica',
					'No Aplica',
					'No Aplica',
					'No Aplica',
					'No Aplica');

			SET IDENTITY_INSERT [dbo].[TMP_DimUbicacionGeografica] OFF;

	END


--Ingresando El valor no definido
IF (SELECT COUNT(1) 
			FROM [dbo].[TMP_DimUbicacionGeografica]
				WHERE [IdUbicacionGeografica]=-1)<=0
	BEGIN

			SET IDENTITY_INSERT [dbo].[TMP_DimUbicacionGeografica] ON;

			INSERT INTO [dbo].[TMP_DimUbicacionGeografica]
				   (
					[IdUbicacionGeografica]
				   ,[IdUbicacionGeograficaPadre]
				   ,[CodigoUbicacionGeograficaPadre]
				   ,[DescripcionUbicacionGeograficaPadre]
				   ,[CodigoUbicacionGeografica]
				   ,[DescripcionUbicacionGeografica]
				   ,[Latitud]
				   ,[Longitu])
			 VALUES
				   (-1,
					null,
					'No Definido',
					'No Definido',
					'No Definido',
					'No Definido',
					'No Definido',
					'No Definido');

			SET IDENTITY_INSERT [dbo].[TMP_DimUbicacionGeografica] OFF;

	END



--******************************************************************************
--******************************************************************************
--******************************************************************************

--Variables de proceso.
DECLARE @CodigoUbicacionGeograficaPadre [varchar](50);
DECLARE @DescripcionUbicacionGeograficaPadre [varchar](50);
DECLARE @CodigoUbicacionGeografica [varchar](50);
DECLARE @DescripcionUbicacionGeografica [varchar](50);


--Variables para insert;
DECLARE @IdUbicacionGeografica int;
DECLARE @IdUbicacionGeograficaPadre int;



--Iniciar cursor
DECLARE tmp_ubica
	CURSOR FOR 
			SELECT [CodigoUbicacionGeograficaPadre]
				  ,[DescripcionUbicacionGeograficaPadre]
				  ,[CodigoUbicacionGeografica]
				  ,[DescripcionUbicacionGeografica]
			FROM [dbo].[TMP_UbicacionGeografica]
			ORDER BY [CodigoUbicacionGeograficaPadre],
			         [CodigoUbicacionGeografica];


		OPEN tmp_ubica
			FETCH NEXT FROM tmp_ubica 
				INTO @CodigoUbicacionGeograficaPadre,
					 @DescripcionUbicacionGeograficaPadre,
					 @CodigoUbicacionGeografica,
					 @DescripcionUbicacionGeografica

		WHILE @@FETCH_STATUS = 0
		BEGIN
   
		   --validar si es necesario insert;
		   SELECT @IdUbicacionGeografica =[IdUbicacionGeografica],
				  @IdUbicacionGeograficaPadre =[IdUbicacionGeograficaPadre]
		   FROM [dbo].[TMP_DimUbicacionGeografica]
		   WHERE [CodigoUbicacionGeograficaPadre]=Convert(varchar(50),@CodigoUbicacionGeograficaPadre)  AND
				 [CodigoUbicacionGeografica]=Convert(varchar(50),@CodigoUbicacionGeografica);

		   IF @IdUbicacionGeografica>0 --Update
				BEGIN
					   UPDATE [dbo].[TMP_DimUbicacionGeografica]
					   SET [IdUbicacionGeograficaPadre] = isnull(@IdUbicacionGeograficaPadre,-2)
						  ,[CodigoUbicacionGeograficaPadre] = @CodigoUbicacionGeograficaPadre 
						  ,[DescripcionUbicacionGeograficaPadre] = @DescripcionUbicacionGeograficaPadre
						  ,[CodigoUbicacionGeografica] = @CodigoUbicacionGeografica
						  ,[DescripcionUbicacionGeografica] = @DescripcionUbicacionGeografica
					   WHERE [IdUbicacionGeografica]=@IdUbicacionGeografica;

				END
		   ELSE
				BEGIN
			  
					  SET  @IdUbicacionGeograficaPadre =(SELECT TOP 1 [IdUbicacionGeografica]
														 FROM [dbo].[TMP_DimUbicacionGeografica]
														 WHERE [CodigoUbicacionGeografica]=Convert(varchar(50),@CodigoUbicacionGeograficaPadre));


						INSERT INTO [dbo].[TMP_DimUbicacionGeografica]
							   ([IdUbicacionGeograficaPadre]
							   ,[CodigoUbicacionGeograficaPadre]
							   ,[DescripcionUbicacionGeograficaPadre]
							   ,[CodigoUbicacionGeografica]
							   ,[DescripcionUbicacionGeografica])
						 VALUES
							   (isnull(@IdUbicacionGeograficaPadre,-2)
							   ,@CodigoUbicacionGeograficaPadre
							   ,@DescripcionUbicacionGeograficaPadre
							   ,@CodigoUbicacionGeografica
							   ,@DescripcionUbicacionGeografica);
				END




    
			FETCH NEXT FROM tmp_ubica 
				INTO @CodigoUbicacionGeograficaPadre,
					 @DescripcionUbicacionGeograficaPadre,
					 @CodigoUbicacionGeografica,
					 @DescripcionUbicacionGeografica
		END 
		CLOSE tmp_ubica;
		DEALLOCATE tmp_ubica;


END


GO
/****** Object:  UserDefinedFunction [dbo].[fnGetRangoEdad]    Script Date: 3/28/2014 3:50:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select dbo.fnGetRangoEdad(10)

CREATE FUNCTION [dbo].[fnGetRangoEdad] 
(
	@Edad int
)
RETURNS varchar(50)
AS
BEGIN
	    -- Declare the return variable here
	    DECLARE @RangoEdad varchar(50);
	
	
		SELECT   @RangoEdad= Descripcion
		FROM     dbo.ParametrosNumericos
		WHERE    CodigoConfiguracion = 'RangoEdad' 
				 AND @Edad between [ValorInicial] and [ValorFinal]; 


		Return @RangoEdad;

END



GO
/****** Object:  Table [dbo].[ParametrosNumericos]    Script Date: 3/28/2014 3:50:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ParametrosNumericos](
	[ValorInicial] [int] NULL,
	[ValorFinal] [int] NULL,
	[CodigoConfiguracion] [varchar](50) NULL,
	[Descripcion] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SSIS Configurations]    Script Date: 3/28/2014 3:50:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS Configurations](
	[ConfigurationFilter] [nvarchar](255) NOT NULL,
	[ConfiguredValue] [nvarchar](255) NULL,
	[PackagePath] [nvarchar](255) NOT NULL,
	[ConfiguredValueType] [nvarchar](20) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TMP_DimUbicacionGeografica]    Script Date: 3/28/2014 3:50:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TMP_DimUbicacionGeografica](
	[IdUbicacionGeografica] [int] IDENTITY(1,1) NOT NULL,
	[IdUbicacionGeograficaPadre] [varchar](50) NULL,
	[CodigoUbicacionGeograficaPadre] [varchar](50) NULL,
	[DescripcionUbicacionGeograficaPadre] [varchar](50) NULL,
	[CodigoUbicacionGeografica] [varchar](50) NULL,
	[DescripcionUbicacionGeografica] [varchar](50) NULL,
	[Latitud] [varchar](50) NULL,
	[Longitu] [varchar](50) NULL,
 CONSTRAINT [PK_TMP_DimUbicacionGeografica] PRIMARY KEY CLUSTERED 
(
	[IdUbicacionGeografica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TMP_UbicacionGeografica]    Script Date: 3/28/2014 3:50:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TMP_UbicacionGeografica](
	[CodigoUbicacionGeograficaPadre] [int] NULL,
	[DescripcionUbicacionGeograficaPadre] [varchar](150) NULL,
	[CodigoUbicacionGeografica] [int] NULL,
	[DescripcionUbicacionGeografica] [varchar](150) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
USE [master]
GO
ALTER DATABASE [ST_SAS] SET  READ_WRITE 
GO
