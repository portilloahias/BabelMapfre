USE [master]
GO
/****** Object:  Database [ST_SAS]    Script Date: 4/9/2014 3:49:58 PM ******/
CREATE DATABASE [ST_SAS] ON  PRIMARY 
( NAME = N'ST_SAS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQL2008\MSSQL\DATA\ST_SAS.mdf' , SIZE = 24576KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ST_SAS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQL2008\MSSQL\DATA\ST_SAS_log.ldf' , SIZE = 39296KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
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
/****** Object:  StoredProcedure [dbo].[spDimGenericaUbicacionGeograficaRegional]    Script Date: 4/9/2014 3:49:58 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[fnGetRangoEdad]    Script Date: 4/9/2014 3:49:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
		FROM     dbo.Parametros
		WHERE    CodigoConfiguracion = 'RangoEdad' 
				 AND @Edad between convert(int,[ValorInicial]) and convert(int,[ValorFinal]); 


		Return @RangoEdad;

END




GO
/****** Object:  Table [dbo].[Parametros]    Script Date: 4/9/2014 3:49:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Parametros](
	[ValorInicial] [varchar](50) NULL,
	[ValorFinal] [varchar](50) NULL,
	[CodigoConfiguracion] [varchar](50) NULL,
	[Descripcion] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SSIS Configurations]    Script Date: 4/9/2014 3:49:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS Configurations](
	[ConfigurationFilter] [nvarchar](600) NOT NULL,
	[ConfiguredValue] [nvarchar](600) NULL,
	[PackagePath] [nvarchar](600) NOT NULL,
	[ConfiguredValueType] [nvarchar](20) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ST_master_pol]    Script Date: 4/9/2014 3:49:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ST_master_pol](
	[id] [bigint] NOT NULL,
	[cdgocia] [numeric](5, 0) NOT NULL,
	[cdgoramo] [numeric](5, 0) NOT NULL,
	[numepoli] [varchar](15) NOT NULL,
	[id_tipopol] [bigint] NULL,
	[numecert] [varchar](15) NOT NULL,
	[parentid] [bigint] NULL,
	[terceroid] [bigint] NULL,
	[grupo_id] [bigint] NULL,
	[id_estado] [smallint] NOT NULL,
	[fechinsc] [datetime] NOT NULL,
	[fechorig] [datetime] NOT NULL,
	[fechbaja] [datetime] NULL,
	[id_causbaja] [smallint] NULL,
	[fechinic] [datetime] NOT NULL,
	[fechvenc] [datetime] NOT NULL,
	[fechreno] [datetime] NOT NULL,
	[planid] [bigint] NOT NULL,
	[cdgomone] [smallint] NULL,
	[sumaaseg] [numeric](15, 2) NOT NULL,
	[sumafact] [numeric](15, 2) NULL,
	[id_formpago] [smallint] NULL,
	[prmaaseg] [numeric](15, 2) NULL,
	[id_tipotasa] [smallint] NULL,
	[tasaaseg] [numeric](18, 6) NULL,
	[id_tipocta] [smallint] NULL,
	[numecta] [varchar](255) NULL,
	[fechvctocta] [date] NULL,
	[titularcta] [varchar](100) NULL,
	[initialid] [varchar](5) NULL,
	[cdgosucu] [bigint] NULL,
	[ejecutivo] [varchar](50) NULL,
	[fechultm] [datetime] NOT NULL,
	[userultm] [varchar](50) NOT NULL,
	[cdgoprod] [numeric](5, 0) NULL,
 CONSTRAINT [PrimaryKey_29970547-a1f8-4675-95d6-e0bf6c257e07] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ST_moneda_fac]    Script Date: 4/9/2014 3:49:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ST_moneda_fac](
	[id] [bigint] NOT NULL,
	[cdgocia] [numeric](5, 0) NOT NULL,
	[cdgomone] [smallint] NOT NULL,
	[fechdesde] [date] NOT NULL,
	[fechhasta] [date] NULL,
	[factor] [numeric](18, 5) NOT NULL,
	[fechultm] [datetime] NOT NULL,
	[userultm] [varchar](50) NOT NULL,
 CONSTRAINT [PrimaryKey_a0e299e7-aa4b-4bfc-afa0-c0c93da839f1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ST_recibo]    Script Date: 4/9/2014 3:49:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ST_recibo](
	[id] [bigint] NOT NULL,
	[master_pol_id] [bigint] NOT NULL,
	[numerecibo] [int] NOT NULL,
	[numecuota] [smallint] NOT NULL,
	[id_estcuota] [smallint] NOT NULL,
	[fechsuge] [date] NOT NULL,
	[fechinic] [date] NOT NULL,
	[fechvenc] [date] NOT NULL,
	[cdgomone] [smallint] NOT NULL,
	[monto] [numeric](15, 2) NOT NULL,
	[comision1] [numeric](15, 2) NULL,
	[comision2] [numeric](15, 2) NULL,
	[fechcobro] [datetime] NULL,
	[fechproceso] [datetime] NULL,
	[cdgoproceso] [numeric](5, 0) NULL,
	[fechultm] [datetime] NOT NULL,
	[userultm] [varchar](50) NOT NULL,
 CONSTRAINT [PrimaryKey_d4bc1202-bf4c-4233-af1d-750061803f23] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TMP_DimUbicacionGeografica]    Script Date: 4/9/2014 3:49:58 PM ******/
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
/****** Object:  Table [dbo].[TMP_FactPoliza]    Script Date: 4/9/2014 3:49:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_FactPoliza](
	[IdCia] [int] NOT NULL,
	[IdFechaBaja] [int] NOT NULL,
	[IdFechaFinVigencia] [int] NOT NULL,
	[IdFechaInicioVigencia] [int] NOT NULL,
	[IdFechaInscripcion] [int] NOT NULL,
	[IdFechaNacimiento] [int] NOT NULL,
	[IdFechaRenovacion] [int] NOT NULL,
	[IdMoneda] [int] NOT NULL,
	[IdPlan] [int] NOT NULL,
	[IdPoliza] [int] NOT NULL,
	[IdSocio] [int] NOT NULL,
	[IdSucursal] [int] NOT NULL,
	[IdTer] [int] NOT NULL,
	[IdUbicacionGeograficaCliente] [int] NOT NULL,
	[IdUbicacionGeograficaSucursal] [int] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[MontoSumaAseguradaDolares] [decimal](24, 4) NULL,
	[MontoSumaFacturadaDolares] [decimal](24, 4) NULL,
	[MontoPrimaAseguradaDolares] [decimal](24, 4) NULL,
	[MontoSumaAsegurada] [decimal](24, 4) NULL,
	[MontoSumaFacturada] [decimal](24, 4) NULL,
	[MontoPrimaAsegurada] [decimal](24, 4) NULL,
	[TasaDeCambio] [decimal](24, 4) NULL,
 CONSTRAINT [PK_FactPoliza_1] PRIMARY KEY CLUSTERED 
(
	[IdCia] ASC,
	[IdFechaBaja] ASC,
	[IdFechaFinVigencia] ASC,
	[IdFechaInicioVigencia] ASC,
	[IdFechaInscripcion] ASC,
	[IdFechaNacimiento] ASC,
	[IdFechaRenovacion] ASC,
	[IdMoneda] ASC,
	[IdPlan] ASC,
	[IdPoliza] ASC,
	[IdSocio] ASC,
	[IdSucursal] ASC,
	[IdTer] ASC,
	[IdUbicacionGeograficaCliente] ASC,
	[IdUbicacionGeograficaSucursal] ASC,
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TMP_FactRecibo]    Script Date: 4/9/2014 3:49:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_FactRecibo](
	[IdCia] [int] NOT NULL,
	[IdMoneda] [int] NOT NULL,
	[IdPlan] [int] NOT NULL,
	[IdPoliza] [bigint] NOT NULL,
	[IdSocio] [int] NOT NULL,
	[IdSucursal] [int] NOT NULL,
	[IdTer] [int] NOT NULL,
	[IdUbicacionGeograficaCliente] [int] NOT NULL,
	[IdUbicacionGeograficaSucursal] [int] NOT NULL,
	[IdFechaAnulacionRecibo] [int] NOT NULL,
	[IdFechaCobroRecibo] [int] NOT NULL,
	[IdFechaVencimientoRecibo] [int] NOT NULL,
	[IdRecibo] [int] NOT NULL,
	[MontoDolares] [decimal](24, 4) NULL,
	[Comision1Dolares] [decimal](24, 4) NULL,
	[Comision2Dolares] [decimal](24, 4) NULL,
	[Monto] [decimal](24, 4) NULL,
	[Comision1] [decimal](24, 4) NULL,
	[Comision2] [decimal](24, 4) NULL,
 CONSTRAINT [TMP_FactRecib] PRIMARY KEY CLUSTERED 
(
	[IdCia] ASC,
	[IdMoneda] ASC,
	[IdPlan] ASC,
	[IdPoliza] ASC,
	[IdSocio] ASC,
	[IdSucursal] ASC,
	[IdTer] ASC,
	[IdUbicacionGeograficaCliente] ASC,
	[IdUbicacionGeograficaSucursal] ASC,
	[IdFechaAnulacionRecibo] ASC,
	[IdFechaCobroRecibo] ASC,
	[IdFechaVencimientoRecibo] ASC,
	[IdRecibo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TMP_ResumenFactPoliza]    Script Date: 4/9/2014 3:49:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_ResumenFactPoliza](
	[IdCia] [int] NOT NULL,
	[IdMoneda] [int] NOT NULL,
	[IdPlan] [int] NOT NULL,
	[IdPoliza] [int] NOT NULL,
	[IdSocio] [int] NOT NULL,
	[IdSucursal] [int] NOT NULL,
	[IdTer] [int] NOT NULL,
	[IdUbicacionGeograficaCliente] [int] NOT NULL,
	[IdUbicacionGeograficaSucursal] [int] NOT NULL,
 CONSTRAINT [PK_TMP_ResumenFactPoliza] PRIMARY KEY CLUSTERED 
(
	[IdCia] ASC,
	[IdMoneda] ASC,
	[IdPlan] ASC,
	[IdPoliza] ASC,
	[IdSocio] ASC,
	[IdSucursal] ASC,
	[IdTer] ASC,
	[IdUbicacionGeograficaCliente] ASC,
	[IdUbicacionGeograficaSucursal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TMP_UbicacionGeografica]    Script Date: 4/9/2014 3:49:58 PM ******/
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
