USE [master]
GO
/****** Object:  Database [DW_SAS]    Script Date: 3/28/2014 3:50:00 PM ******/
CREATE DATABASE [DW_SAS] ON  PRIMARY 
( NAME = N'DW_SAS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQL2008\MSSQL\DATA\DW_SAS.mdf' , SIZE = 21504KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DW_SAS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQL2008\MSSQL\DATA\DW_SAS_log.ldf' , SIZE = 13632KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DW_SAS] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DW_SAS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DW_SAS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DW_SAS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DW_SAS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DW_SAS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DW_SAS] SET ARITHABORT OFF 
GO
ALTER DATABASE [DW_SAS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DW_SAS] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [DW_SAS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DW_SAS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DW_SAS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DW_SAS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DW_SAS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DW_SAS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DW_SAS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DW_SAS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DW_SAS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DW_SAS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DW_SAS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DW_SAS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DW_SAS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DW_SAS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DW_SAS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DW_SAS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DW_SAS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DW_SAS] SET  MULTI_USER 
GO
ALTER DATABASE [DW_SAS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DW_SAS] SET DB_CHAINING OFF 
GO
EXEC sys.sp_db_vardecimal_storage_format N'DW_SAS', N'ON'
GO
USE [DW_SAS]
GO
/****** Object:  StoredProcedure [dbo].[spCargarDimFecha]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spCargarDimFecha '1999-01-02','2014-12-31', 'Nacimiento'
CREATE PROCEDURE [dbo].[spCargarDimFecha]
(
	 @FechaInicio DATETIME,
     @FechaFin DATETIME,
	 @strDimensionProcesamiento VARCHAR(50)
)
AS
BEGIN

        --Varibales de procesamiento
		DECLARE @FechaProcesamiento DATETIME;
		DECLARE @strQuery nvarchar(max);
		DECLARE @strParameters nvarchar(max);


		--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		--Validar si las fecha ya fueron ingresadas
		DECLARE @DimFechaInicio datetime;
		DECLARE @DimFechaFin datetime;
		SET @strParameters='@DimFechaInicio datetime OUTPUT,@DimFechaFin datetime OUTPUT';
		
		SET @strQuery='		SELECT @DimFechaInicio = Min([Fecha]),
								   @DimFechaFin = Max ([Fecha])
							FROM  [dbo].[DimFecha'+@strDimensionProcesamiento+']';
        
	    execute sp_executesql   @strQuery,
		                        @strParameters,
		                        @DimFechaInicio=@DimFechaInicio OUTPUT,
								@DimFechaFin=@DimFechaFin OUTPUT;


	   --Validar si es necesario agregar nuevos registros en la dimension de tiempo
	   if @FechaFin <= @DimFechaFin
	     BEGIN
				return;
		 END

        --Modificar el rango de fecha si es necesario cargar ingrementalmente
	    if @DimFechaFin is not null
		 BEGIN
			   SET @FechaInicio=CASE WHEN @FechaInicio<=@DimFechaFin
			                            THEN DATEADD(day,1,@DimFechaFin)
								ELSE @FechaInicio END;
		 END
		 
		--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		SET @FechaProcesamiento=@FechaInicio;


		SET @strQuery = 'INSERT INTO [dbo].[DimFecha'+@strDimensionProcesamiento+']
												   ([IdFecha'+@strDimensionProcesamiento+']
												   ,[Fecha]
												   ,[Anno]
												   ,[Mes]
												   ,[SemanaMes]
												   ,[SemanaAnno]
												   ,[DescripcionMes]
												   ,[DescripcionDia]
												   ,[Trimestre]
												   ,[Semestre]
												   ,[DiaSemana]
												   ,[DiaMes]
												   ,[DiaAnno]
												   ,[AnnoMes])
											 VALUES
												   (
												     @IdFecha ,
													 @FechaProcesamiento,
													 @Anno ,
													 @Mes ,
													 @SemanaMes ,
													 @SemanaAnno ,
													 @DescripcionMes ,
													 @DescripcionDia ,
													 @Trimestre ,
													 @Semestre ,
													 @DiaSemana ,
													 @DiaMes ,
													 @DiaAnno ,
													 @AnnoMes )';

          SET @strParameters=	'@IdFecha int,
								 @Anno int,
								 @Mes int,
								 @SemanaMes int,
								 @SemanaAnno int,
								 @DescripcionMes varchar(50),
								 @DescripcionDia varchar(50),
								 @Trimestre varchar(50),
								 @Semestre varchar(50),
								 @DiaSemana Varchar(50),
								 @DiaMes int,
								 @DiaAnno int,
								 @AnnoMes int,
								 @FechaProcesamiento DATETIME';

		--Variables desnormalizadas de dimension de tiempo
		DECLARE @IdFecha int;
		DECLARE @Anno int;
		DECLARE @Mes int;
		DECLARE @SemanaMes int;
		DECLARE @SemanaAnno int;
		DECLARE @DescripcionMes varchar(50);
		DECLARE @DescripcionDia varchar(50);
		DECLARE @Trimestre varchar(50);
		DECLARE @Semestre varchar(50);
		DECLARE @DiaSemana Varchar(50);
		DECLARE @DiaMes int;
		DECLARE @DiaAnno int;
		DECLARE @AnnoMes int;




		WHILE @FechaFin>=@FechaProcesamiento
		BEGIN
	
	
			SET @IdFecha =CONVERT(int,CONVERT(VARCHAR(10),@FechaProcesamiento,112));
			SET @Anno =YEAR(@FechaProcesamiento);
			SET @Mes=Month(@FechaProcesamiento);
			SET @SemanaMes=(DATEDIFF(week, DATEADD(MONTH, DATEDIFF(MONTH, 0, @FechaProcesamiento), 0), @FechaProcesamiento) +1) ;
			SET @SemanaAnno=datepart(week,@FechaProcesamiento);
			SET @DescripcionMes=CASE MONTH(@FechaProcesamiento)  
								   WHEN 1 THEN 'ENERO'
								   WHEN 2  THEN 'FEBRERO'
								   WHEN 3  THEN 'MARZO'
								   WHEN 4  THEN 'ABRIL'
								   WHEN 5  THEN 'MAYO'
								   WHEN 6  THEN 'JUNIO'
								   WHEN 7  THEN 'JULIO'
								   WHEN 8  THEN 'AGOSTO'
								   WHEN 9  THEN 'SEPTIEMBRE'
								   WHEN 10 THEN 'OCTUBRE'
								   WHEN 11 THEN 'NOVIEMBRE'
								   WHEN 12 THEN 'DICIEMBRE' END;
			SET @DescripcionDia=CASE datepart(weekday,@FechaProcesamiento)
								   WHEN 1 THEN 'DOMINGO'
								   WHEN 2 THEN 'LUNES'
								   WHEN 3 THEN 'MARTES'
								   WHEN 4 THEN 'MIERCOLES'
								   WHEN 5 THEN 'JUEVES'
								   WHEN 6 THEN 'VIERNES'
								   WHEN 7 THEN 'SABADO' END;
			SET @Trimestre=CASE DATEPART(quarter,@FechaProcesamiento)
								   WHEN 1 THEN CONVERT(VARCHAR(4),YEAR( @FechaProcesamiento)) + '-TRIMESTRE I'
								   WHEN 2 THEN CONVERT(VARCHAR(4),YEAR( @FechaProcesamiento)) + '-TRIMESTRE II'
								   WHEN 3 THEN CONVERT(VARCHAR(4),YEAR( @FechaProcesamiento)) + '-TRIMESTRE III'
								   WHEN 4 THEN CONVERT(VARCHAR(4),YEAR( @FechaProcesamiento)) + '-TRIMESTRE IV' END;
			SET @Semestre=CASE WHEN MONTH(@FechaProcesamiento)<=6 
								   THEN (CONVERT(VARCHAR(4),YEAR( @FechaProcesamiento)) + '-SEMESTRE I' )
								   ELSE (CONVERT(VARCHAR(4),YEAR( @FechaProcesamiento)) + '-SEMESTRE II' ) END;
			SET @DiaSemana = DATEPART(weekday,@FechaProcesamiento);
			SET @DiaMes = DAY(@FechaProcesamiento);
			SET @DiaAnno =DATEPART (dayofyear,@FechaProcesamiento);
			SET @AnnoMes =CONVERT(int,CONVERT(VARCHAR(6),@FechaProcesamiento,112));

		
			--realizar insert
			 execute sp_executesql @strQuery,
		                        @strParameters,
		                        @IdFecha=@IdFecha ,
								@FechaProcesamiento=@FechaProcesamiento,
								@Anno=@Anno,
								@Mes=@Mes,
								@SemanaMes=@SemanaMes ,
								@SemanaAnno=@SemanaAnno ,
								@DescripcionMes=@DescripcionMes ,
								@DescripcionDia= @DescripcionDia,
								@Trimestre =@Trimestre,
								@Semestre=@Semestre ,
								@DiaSemana=@DiaSemana ,
								@DiaMes=@DiaMes ,
								@DiaAnno=@DiaAnno ,
								@AnnoMes=@AnnoMes ;
												   

			--agregar un dia para continuar el procesamiento.
			SET @FechaProcesamiento= DATEADD(day,1,@FechaProcesamiento);
	     
		END




END





GO
/****** Object:  UserDefinedFunction [dbo].[fnGetRangoEdad]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select dbo.fnGetRangoEdad(100)




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
/****** Object:  Table [dbo].[DimCia]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimCia](
	[IdCia] [int] IDENTITY(1,1) NOT NULL,
	[NombreCia] [varchar](50) NULL,
	[CodigoCia] [varchar](5) NULL,
	[IdCodigoPais] [varchar](10) NULL,
 CONSTRAINT [PK_DimCia] PRIMARY KEY CLUSTERED 
(
	[IdCia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaBaja]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimFechaBaja](
	[IdFechaBaja] [int] NOT NULL,
	[Fecha] [datetime] NULL,
	[Anno] [int] NULL,
	[Mes] [varchar](50) NULL,
	[SemanaMes] [int] NULL,
	[SemanaAnno] [int] NULL,
	[DescripcionMes] [varchar](50) NULL,
	[DescripcionDia] [varchar](50) NULL,
	[Trimestre] [varchar](50) NULL,
	[Semestre] [varchar](50) NULL,
	[DiaSemana] [int] NULL,
	[DiaMes] [int] NULL,
	[DiaAnno] [int] NULL,
	[AnnoMes] [int] NULL,
 CONSTRAINT [PK_DimFechaBaja] PRIMARY KEY CLUSTERED 
(
	[IdFechaBaja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaFinVigencia]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimFechaFinVigencia](
	[IdFechaFinVigencia] [int] NOT NULL,
	[Fecha] [datetime] NULL,
	[Anno] [int] NULL,
	[Mes] [varchar](50) NULL,
	[SemanaMes] [int] NULL,
	[SemanaAnno] [int] NULL,
	[DescripcionMes] [varchar](50) NULL,
	[DescripcionDia] [varchar](50) NULL,
	[Trimestre] [varchar](50) NULL,
	[Semestre] [varchar](50) NULL,
	[DiaSemana] [int] NULL,
	[DiaMes] [int] NULL,
	[DiaAnno] [int] NULL,
	[AnnoMes] [int] NULL,
 CONSTRAINT [PK_DimFechaFinVigencia] PRIMARY KEY CLUSTERED 
(
	[IdFechaFinVigencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaInicioVigencia]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimFechaInicioVigencia](
	[IdFechaInicioVigencia] [int] NOT NULL,
	[Fecha] [datetime] NULL,
	[Anno] [int] NULL,
	[Mes] [varchar](50) NULL,
	[SemanaMes] [int] NULL,
	[SemanaAnno] [int] NULL,
	[DescripcionMes] [varchar](50) NULL,
	[DescripcionDia] [varchar](50) NULL,
	[Trimestre] [varchar](50) NULL,
	[Semestre] [varchar](50) NULL,
	[DiaSemana] [int] NULL,
	[DiaMes] [int] NULL,
	[DiaAnno] [int] NULL,
	[AnnoMes] [int] NULL,
 CONSTRAINT [PK_DimFechaInicioVigencia] PRIMARY KEY CLUSTERED 
(
	[IdFechaInicioVigencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaInscripcion]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimFechaInscripcion](
	[IdFechaInscripcion] [int] NOT NULL,
	[Fecha] [datetime] NULL,
	[Anno] [int] NULL,
	[Mes] [varchar](50) NULL,
	[SemanaMes] [int] NULL,
	[SemanaAnno] [int] NULL,
	[DescripcionMes] [varchar](50) NULL,
	[DescripcionDia] [varchar](50) NULL,
	[Trimestre] [varchar](50) NULL,
	[Semestre] [varchar](50) NULL,
	[DiaSemana] [int] NULL,
	[DiaMes] [int] NULL,
	[DiaAnno] [int] NULL,
	[AnnoMes] [int] NULL,
 CONSTRAINT [PK_DimFechaInscripcion] PRIMARY KEY CLUSTERED 
(
	[IdFechaInscripcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaNacimiento]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimFechaNacimiento](
	[IdFechaNacimiento] [int] NOT NULL,
	[Fecha] [datetime] NULL,
	[Anno] [int] NULL,
	[Mes] [varchar](50) NULL,
	[SemanaMes] [int] NULL,
	[SemanaAnno] [int] NULL,
	[DescripcionMes] [varchar](50) NULL,
	[DescripcionDia] [varchar](50) NULL,
	[Trimestre] [varchar](50) NULL,
	[Semestre] [varchar](50) NULL,
	[DiaSemana] [int] NULL,
	[DiaMes] [int] NULL,
	[DiaAnno] [int] NULL,
	[AnnoMes] [int] NULL,
 CONSTRAINT [PK_DimFechaNacimiento] PRIMARY KEY CLUSTERED 
(
	[IdFechaNacimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaRenovacion]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimFechaRenovacion](
	[IdFechaRenovacion] [int] NOT NULL,
	[Fecha] [datetime] NULL,
	[Anno] [int] NULL,
	[Mes] [varchar](50) NULL,
	[SemanaMes] [int] NULL,
	[SemanaAnno] [int] NULL,
	[DescripcionMes] [varchar](50) NULL,
	[DescripcionDia] [varchar](50) NULL,
	[Trimestre] [varchar](50) NULL,
	[Semestre] [varchar](50) NULL,
	[DiaSemana] [int] NULL,
	[DiaMes] [int] NULL,
	[DiaAnno] [int] NULL,
	[AnnoMes] [int] NULL,
 CONSTRAINT [PK_DimFechaRenovacion] PRIMARY KEY CLUSTERED 
(
	[IdFechaRenovacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimMoneda]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimMoneda](
	[IdMoneda] [int] IDENTITY(1,1) NOT NULL,
	[CodigoMoneda] [varchar](50) NULL,
	[DescripcionMoneda] [varchar](50) NULL,
	[Simbolo] [varchar](50) NULL,
 CONSTRAINT [PK_DimMoneda] PRIMARY KEY CLUSTERED 
(
	[IdMoneda] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimPais]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimPais](
	[IdPais] [int] NOT NULL,
	[DescripcionPais] [varchar](50) NULL,
 CONSTRAINT [PK_DimPais] PRIMARY KEY CLUSTERED 
(
	[IdPais] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimPlan]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimPlan](
	[IdPlan] [int] IDENTITY(1,1) NOT NULL,
	[CodigoCIA] [varchar](50) NULL,
	[CodigoRamo] [varchar](50) NULL,
	[DescripcionRamo] [varchar](50) NULL,
	[CodigoProducto] [varchar](50) NULL,
	[DescripcionProducto] [varchar](50) NULL,
	[CodigoPlan] [varchar](50) NULL,
	[DescripcionPlan] [varchar](50) NULL,
	[DescripcionMoneda] [varchar](50) NULL,
 CONSTRAINT [PK_DimPlan] PRIMARY KEY CLUSTERED 
(
	[IdPlan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimPoliza]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimPoliza](
	[IdPoliza] [bigint] NOT NULL,
	[CodigoRamo] [varchar](50) NULL,
	[Certificado] [varchar](50) NULL,
	[Poliza] [varchar](50) NULL,
	[EstadoPoliza] [varchar](50) NULL,
	[DescripcionFormaDePago] [varchar](100) NULL,
	[CodigoMotivoCancelacion] [varchar](100) NULL,
	[DescripcionMotivoCancelacion] [varchar](100) NULL,
	[CodigoTipoCuenta] [varchar](100) NULL,
	[DescripcionTipoCuenta] [varchar](100) NULL,
	[CodigoTipoTarjeta] [varchar](100) NULL,
	[DescripcionTipoTarjeta] [varchar](100) NULL,
 CONSTRAINT [PK_DimPoliza] PRIMARY KEY CLUSTERED 
(
	[IdPoliza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimSocio]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimSocio](
	[IdSocio] [int] IDENTITY(1,1) NOT NULL,
	[CodigoSocio] [varchar](50) NULL,
	[NombreSocio] [varchar](150) NULL,
	[CodigoGlobalCorp] [varchar](50) NULL,
	[NombreSocioGlobalCorp] [varchar](150) NULL,
	[TipoSocio] [varchar](150) NULL,
	[CodigoCia] [varchar](5) NULL,
 CONSTRAINT [PK_DimSocio] PRIMARY KEY CLUSTERED 
(
	[IdSocio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimSucursal]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimSucursal](
	[IdSucursal] [int] IDENTITY(1,1) NOT NULL,
	[CodigoSocio] [varchar](150) NULL,
	[NombreSocio] [varchar](150) NULL,
	[CodigoGlobalCorp] [varchar](150) NULL,
	[NombreSocioGlobalCorp] [varchar](150) NULL,
	[TipoSocio] [varchar](150) NULL,
	[CodigoCia] [varchar](150) NULL,
	[CodigoSucursal] [varchar](150) NULL,
	[NombreSucursal] [varchar](150) NOT NULL,
 CONSTRAINT [PK_DimSucursal] PRIMARY KEY CLUSTERED 
(
	[IdSucursal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimTer]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimTer](
	[IdTer] [bigint] NOT NULL,
	[IdSistemaTer] [varchar](50) NULL,
	[TipoDocumento] [varchar](100) NULL,
	[NumeroDocumento] [varchar](50) NULL,
	[NombreBase1] [varchar](255) NULL,
	[NombreBase2] [varchar](100) NULL,
	[Apellido1] [varchar](100) NULL,
	[Apellido2] [varchar](100) NULL,
	[ApellidoCasada] [varchar](100) NULL,
	[CodigoSexo] [varchar](50) NULL,
	[DescripcionSexo] [varchar](50) NULL,
	[CodigoEstadoCivil] [varchar](50) NULL,
	[DescripcionEstadoCivil] [varchar](50) NULL,
	[CodigoTipoPersona] [varchar](50) NULL,
	[TipoPersona] [varchar](100) NULL,
	[IdFechaNacimiento] [int] NULL,
	[Edad] [smallint] NULL,
	[RangoEdad] [varchar](50) NULL,
	[IdSistema] [int] NULL,
 CONSTRAINT [PK_DimTer] PRIMARY KEY CLUSTERED 
(
	[IdTer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimUbicacionGeograficaCliente]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimUbicacionGeograficaCliente](
	[IdUbicacionGeograficaCliente] [int] NOT NULL,
	[IdUbicacionGeograficaPadre] [varchar](50) NULL,
	[CodigoUbicacionGeograficaPadre] [varchar](50) NULL,
	[DescripcionUbicacionGeograficaPadre] [varchar](50) NULL,
	[CodigoUbicacionGeografica] [varchar](50) NULL,
	[DescripcionUbicacionGeografica] [varchar](50) NULL,
	[Latitud] [varchar](50) NULL,
	[Longitu] [varchar](50) NULL,
 CONSTRAINT [PK_DimUbicacionGeografica] PRIMARY KEY CLUSTERED 
(
	[IdUbicacionGeograficaCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimUbicacionGeograficaSucursal]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimUbicacionGeograficaSucursal](
	[IdUbicacionGeograficaSucursal] [int] NOT NULL,
	[IdUbicacionGeograficaPadre] [varchar](50) NULL,
	[CodigoUbicacionGeograficaPadre] [varchar](50) NULL,
	[DescripcionUbicacionGeograficaPadre] [varchar](50) NULL,
	[CodigoUbicacionGeografica] [varchar](50) NULL,
	[DescripcionUbicacionGeografica] [varchar](50) NULL,
	[Latitud] [varchar](50) NULL,
	[Longitu] [varchar](50) NULL,
 CONSTRAINT [PK_DimUbicacionGeograficaSucursal] PRIMARY KEY CLUSTERED 
(
	[IdUbicacionGeograficaSucursal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimUsuarios]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimUsuarios](
	[IdUsuario] [int] IDENTITY(1,1) NOT NULL,
	[IdSucursal] [int] NULL,
	[CodigoUsuario] [varchar](150) NULL,
	[NombreUsuario] [varchar](150) NULL,
 CONSTRAINT [PK_DimUsuarios] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FactPoliza]    Script Date: 3/28/2014 3:50:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactPoliza](
	[IdCia] [int] NOT NULL,
	[IdTer] [int] NOT NULL,
	[IdPoliza] [int] NOT NULL,
	[IdPlan] [int] NOT NULL,
	[IdFechaInscripcion] [int] NOT NULL,
	[IdFechaInicioVigencia] [int] NOT NULL,
	[IdFechaFinVigencia] [int] NOT NULL,
	[IdFechaRenovacion] [int] NOT NULL,
	[IdFechaBaja] [int] NOT NULL,
	[IdSucursal] [int] NOT NULL,
	[IdMoneda] [int] NOT NULL,
	[IdPais] [int] NOT NULL,
	[IdUbicacionGeograficaCliente] [int] NOT NULL,
	[IdUbicacionGeograficaSucursal] [int] NOT NULL,
	[MontoSumaAseguradaDolares] [decimal](24, 4) NULL,
	[MontoSumaFacturadaDolares] [decimal](24, 4) NULL,
	[MontoPrimaAseguradaDolares] [decimal](24, 4) NULL,
	[MontoSumaAsegurada] [decimal](24, 4) NULL,
	[MontoSumaFacturada] [decimal](24, 4) NULL,
	[MontoPrimaAsegurada] [decimal](24, 4) NULL,
	[TasaDeCambio] [decimal](24, 4) NULL,
 CONSTRAINT [PK_FactPoliza] PRIMARY KEY CLUSTERED 
(
	[IdCia] ASC,
	[IdTer] ASC,
	[IdPoliza] ASC,
	[IdPlan] ASC,
	[IdFechaInscripcion] ASC,
	[IdFechaInicioVigencia] ASC,
	[IdFechaFinVigencia] ASC,
	[IdFechaRenovacion] ASC,
	[IdFechaBaja] ASC,
	[IdSucursal] ASC,
	[IdMoneda] ASC,
	[IdPais] ASC,
	[IdUbicacionGeograficaCliente] ASC,
	[IdUbicacionGeograficaSucursal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
USE [master]
GO
ALTER DATABASE [DW_SAS] SET  READ_WRITE 
GO
