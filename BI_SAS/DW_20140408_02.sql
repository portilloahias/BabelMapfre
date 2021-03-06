USE [master]
GO
/****** Object:  Database [DW_SAS]    Script Date: 4/8/2014 3:56:32 PM ******/
CREATE DATABASE [DW_SAS] ON  PRIMARY 
( NAME = N'DW_SAS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQL2008\MSSQL\DATA\DW_SAS.mdf' , SIZE = 36864KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DW_SAS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQL2008\MSSQL\DATA\DW_SAS_log.ldf' , SIZE = 16576KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
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
/****** Object:  StoredProcedure [dbo].[spCargarDimFecha]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[spDefaultValueDimensiones]    Script Date: 4/8/2014 3:56:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDefaultValueDimensiones]
AS
BEGIN


--*****************************************************************************
--*****************************************************************************
--Dimension CIA

IF (SELECT COUNT(1) 
			FROM [dbo].[DimCia]
				WHERE [IdCia]=-1)<=0
	BEGIN

			SET IDENTITY_INSERT [dbo].[DimCia] ON;

				INSERT INTO [dbo].[DimCia]
					   ([IdCia]
					   ,[NombreCia]
					   ,[CodigoCia]
					   ,[IdCodigoPais])
				 VALUES
					   (-1
					   ,'No Definido'
					   ,'N/D'
					   ,'N/D');

			SET IDENTITY_INSERT [dbo].[DimCia] OFF;

	END


IF (SELECT COUNT(1) 
			FROM [dbo].[DimCia]
				WHERE [IdCia]=-2)<=0
	BEGIN

			SET IDENTITY_INSERT [dbo].[DimCia] ON;



				INSERT INTO [dbo].[DimCia]
					   ([IdCia]
					   ,[NombreCia]
					   ,[CodigoCia]
					   ,[IdCodigoPais])
				 VALUES
					   (-2
					   ,'No Aplica'
					   ,'N/A'
					   ,'No Aplica');

			SET IDENTITY_INSERT [dbo].[DimCia] OFF;

	END

--*****************************************************************************
--*****************************************************************************
--[dbo].[DimFechaBaja]

IF (SELECT COUNT(1) 
			FROM [dbo].[DimFechaBaja]
				WHERE [IdFechaBaja]=-1)<=0
	BEGIN		

				INSERT INTO [dbo].[DimFechaBaja]
						   ([IdFechaBaja]
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
						   (-1
						   ,null
						   ,-1
						   ,'No Definido'
						   ,-1
						   ,-1
						   ,'No Definido'
						   ,'No Definido'
						   ,'No Definido'
						   ,'No Definido'
						   ,-1
						   ,-1
						   ,-1
						   ,-1);

	END


--*****************************************************************************
--*****************************************************************************
--[dbo].[DimFechaFinVigencia]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimFechaFinVigencia]
				WHERE [IdFechaFinVigencia]=-1)<=0
	BEGIN		

				INSERT INTO [dbo].[DimFechaFinVigencia]
						   ([IdFechaFinVigencia]
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
						   (-1
						   ,null
						   ,-1
						   ,'No Definido'
						   ,-1
						   ,-1
						   ,'No Definido'
						   ,'No Definido'
						   ,'No Definido'
						   ,'No Definido'
						   ,-1
						   ,-1
						   ,-1
						   ,-1);

	END



--*****************************************************************************
--*****************************************************************************
--[dbo].[DimFechaInicioVigencia]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimFechaInicioVigencia]
				WHERE [IdFechaInicioVigencia]=-1)<=0
	BEGIN		

				INSERT INTO [dbo].[DimFechaInicioVigencia]
						   ([IdFechaInicioVigencia]
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
						   (-1
						   ,null
						   ,-1
						   ,'No Definido'
						   ,-1
						   ,-1
						   ,'No Definido'
						   ,'No Definido'
						   ,'No Definido'
						   ,'No Definido'
						   ,-1
						   ,-1
						   ,-1
						   ,-1);

	END


--*****************************************************************************
--*****************************************************************************
--[dbo].[DimFechaInscripcion]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimFechaInscripcion]
				WHERE [IdFechaInscripcion]=-1)<=0
	BEGIN		

				INSERT INTO [dbo].[DimFechaInscripcion]
						   ([IdFechaInscripcion]
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
						   (-1
						   ,null
						   ,-1
						   ,'No Definido'
						   ,-1
						   ,-1
						   ,'No Definido'
						   ,'No Definido'
						   ,'No Definido'
						   ,'No Definido'
						   ,-1
						   ,-1
						   ,-1
						   ,-1);

	END

--*****************************************************************************
--*****************************************************************************
--[dbo].[DimFechaNacimiento]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimFechaNacimiento]
				WHERE [IdFechaNacimiento]=-1)<=0
	BEGIN		

				INSERT INTO [dbo].[DimFechaNacimiento]
						   ([IdFechaNacimiento]
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
						   (-1
						   ,null
						   ,-1
						   ,'No Definido'
						   ,-1
						   ,-1
						   ,'No Definido'
						   ,'No Definido'
						   ,'No Definido'
						   ,'No Definido'
						   ,-1
						   ,-1
						   ,-1
						   ,-1);

	END


--*****************************************************************************
--*****************************************************************************
--[dbo].[DimFechaRenovacion]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimFechaRenovacion]
				WHERE [IdFechaRenovacion]=-1)<=0
	BEGIN		

				INSERT INTO [dbo].[DimFechaRenovacion]
						   ([IdFechaRenovacion]
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
						   (-1
						   ,null
						   ,-1
						   ,'No Definido'
						   ,-1
						   ,-1
						   ,'No Definido'
						   ,'No Definido'
						   ,'No Definido'
						   ,'No Definido'
						   ,-1
						   ,-1
						   ,-1
						   ,-1);

	END



--*****************************************************************************
--*****************************************************************************
--[dbo].[DimMoneda]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimMoneda]
				WHERE [IdMoneda]=-1)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimMoneda] ON;

     INSERT INTO [dbo].[DimMoneda]
           ([IdMoneda]
		   ,[CodigoMoneda]
           ,[DescripcionMoneda]
           ,[Simbolo])
     VALUES
           (-1
		   ,'No Definido'
           ,'No Definido'
           ,'No Definido');


    SET IDENTITY_INSERT [dbo].[DimMoneda] OFF;

	END

--[dbo].[DimMoneda]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimMoneda]
				WHERE [IdMoneda]=-2)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimMoneda] ON;

     INSERT INTO [dbo].[DimMoneda]
           ([IdMoneda]
		   ,[CodigoMoneda]
           ,[DescripcionMoneda]
           ,[Simbolo])
     VALUES
           (-2
		   ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica');


    SET IDENTITY_INSERT [dbo].[DimMoneda] OFF;

	END



--*****************************************************************************
--*****************************************************************************
--[dbo].[DimPlan]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimPlan]
				WHERE [IdPlan]=-1)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimPlan] ON;

	INSERT INTO [dbo].[DimPlan]
           ([IdPlan]
		   ,[CodigoCIA]
           ,[CodigoRamo]
           ,[DescripcionRamo]
           ,[CodigoProducto]
           ,[DescripcionProducto]
           ,[CodigoPlan]
           ,[DescripcionPlan]
           ,[DescripcionMoneda])
     VALUES
           (-1
		   ,'No Definido'
           ,'No Definido'
           ,'No Definido'
           ,'No Definido'
           ,'No Definido'
           ,'No Definido'
           ,'No Definido'
           ,'No Definido')

    SET IDENTITY_INSERT [dbo].[DimPlan] OFF;

	END

--[dbo].[DimPlan]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimPlan]
				WHERE [IdPlan]=-2)<=0
	BEGIN		

SET IDENTITY_INSERT [dbo].[DimPlan] ON;

	INSERT INTO [dbo].[DimPlan]
           ([IdPlan]
		   ,[CodigoCIA]
           ,[CodigoRamo]
           ,[DescripcionRamo]
           ,[CodigoProducto]
           ,[DescripcionProducto]
           ,[CodigoPlan]
           ,[DescripcionPlan]
           ,[DescripcionMoneda])
     VALUES
           (-2
		   ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica')

    SET IDENTITY_INSERT [dbo].[DimPlan] OFF;

	END



--*****************************************************************************
--*****************************************************************************
--[dbo].[DimPoliza]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimPoliza]
				WHERE [IdPoliza]=-1)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimPoliza] ON;

	INSERT INTO [dbo].[DimPoliza]
			   ([IdPoliza]
			   ,[CodigoCia]
			   ,[DescripcionRamo]
			   ,[Certificado]
			   ,[CodigoPoliza]
			   ,[Poliza]
			   ,[EstadoPoliza]
			   ,[DescripcionTipoPoliza]
			   ,[DescripcionFormaDePago]
			   ,[DescripcionMotivoCancelacion]
			   ,[DescripcionTipoCuenta]
			   ,[DescripcionTipoTarjeta]
			   ,[IdSistema])
		 VALUES
			   (-1
			   ,'No Definido'
			   ,'No Definido'
			   ,'No Definido'
			   ,'No Definido'
			   ,'No Definido'
			   ,'No Definido'
			   ,'No Definido'
			   ,'No Definido'
			   ,'No Definido'
			   ,'No Definido'
			   ,'No Definido'
			   ,0)



    SET IDENTITY_INSERT [dbo].[DimPoliza] OFF;

	END

--[dbo].[DimPoliza]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimPoliza]
				WHERE [IdPoliza]=-2)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimPoliza] ON;

	INSERT INTO [dbo].[DimPoliza]
			   ([IdPoliza]
			   ,[CodigoCia]
			   ,[DescripcionRamo]
			   ,[Certificado]
			   ,[CodigoPoliza]
			   ,[Poliza]
			   ,[EstadoPoliza]
			   ,[DescripcionTipoPoliza]
			   ,[DescripcionFormaDePago]
			   ,[DescripcionMotivoCancelacion]
			   ,[DescripcionTipoCuenta]
			   ,[DescripcionTipoTarjeta]
			   ,[IdSistema])
		 VALUES
			   (-2
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'No Aplica'
			   ,0)



    SET IDENTITY_INSERT [dbo].[DimPoliza] OFF;

	END


--*****************************************************************************
--*****************************************************************************
--[dbo].[DimSocio]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimSocio]
				WHERE [IdSocio]=-1)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimSocio] ON;



		INSERT INTO [dbo].[DimSocio]
			   ([IdSocio]
			   ,[CodigoSocio]
			   ,[NombreSocio]
			   ,[CodigoGlobalCorp]
			   ,[NombreSocioGlobalCorp]
			   ,[TipoSocio]
			   ,[CodigoCia])
		 VALUES
			   (-1
			   ,'No Definido'
			   ,'No Definido'
			   ,'No Definido'
			   ,'No Definido'
			   ,'No Definido'
			   ,'N/D');

    SET IDENTITY_INSERT [dbo].[DimSocio] OFF;

	END


--[dbo].[DimSocio]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimSocio]
				WHERE [IdSocio]=-2)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimSocio] ON;



		INSERT INTO [dbo].[DimSocio]
			   ([IdSocio]
			   ,[CodigoSocio]
			   ,[NombreSocio]
			   ,[CodigoGlobalCorp]
			   ,[NombreSocioGlobalCorp]
			   ,[TipoSocio]
			   ,[CodigoCia])
		 VALUES
			   (-2
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'No Aplica'
			   ,'N/A');

    SET IDENTITY_INSERT [dbo].[DimSocio] OFF;

	END


--*****************************************************************************
--*****************************************************************************
--[dbo].[DimSucursal]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimSucursal]
				WHERE [IdSucursal] =-1)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimSucursal] ON;

	
	INSERT INTO [dbo].[DimSucursal]
           ([IdSucursal]
		   ,[CodigoSocio]
           ,[NombreSocio]
           ,[CodigoGlobalCorp]
           ,[NombreSocioGlobalCorp]
           ,[TipoSocio]
           ,[CodigoCia]
           ,[CodigoSucursal]
           ,[NombreSucursal])
     VALUES
           (-1
		   ,'No Definido'
           ,'No Definido'
           ,'No Definido'
           ,'No Definido'
           ,'No Definido'
           ,'No Definido'
           ,'No Definido'
           ,'No Definido')


    SET IDENTITY_INSERT [dbo].[DimSucursal] OFF;

	END


--[dbo].[DimSucursal]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimSucursal]
				WHERE [IdSucursal] =-2)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimSucursal] ON;

	
	INSERT INTO [dbo].[DimSucursal]
           ([IdSucursal]
		   ,[CodigoSocio]
           ,[NombreSocio]
           ,[CodigoGlobalCorp]
           ,[NombreSocioGlobalCorp]
           ,[TipoSocio]
           ,[CodigoCia]
           ,[CodigoSucursal]
           ,[NombreSucursal])
     VALUES
           (-2
		   ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica')


    SET IDENTITY_INSERT [dbo].[DimSucursal] OFF;

	END


--*****************************************************************************
--*****************************************************************************
--[dbo].[DimTer]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimTer]
				WHERE  [IdTer]=-1)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimTer] ON;

	
		INSERT INTO [dbo].[DimTer]
				   ([IdTer]
				   ,[IdSistemaTer]
				   ,[TipoDocumento]
				   ,[NumeroDocumento]
				   ,[NombreBase1]
				   ,[NombreBase2]
				   ,[Apellido1]
				   ,[Apellido2]
				   ,[ApellidoCasada]
				   ,[CodigoSexo]
				   ,[DescripcionSexo]
				   ,[CodigoEstadoCivil]
				   ,[DescripcionEstadoCivil]
				   ,[CodigoTipoPersona]
				   ,[TipoPersona]
				   ,[IdFechaNacimiento]
				   ,[Edad]
				   ,[RangoEdad]
				   ,[IdSistema])
			 VALUES
				   (-1
				   ,'No Definido'
				   ,'No Definido'
				   ,'No Definido'
				   ,'No Definido'
				   ,'No Definido'
				   ,'No Definido'
				   ,'No Definido'
				   ,'No Definido'
				   ,'No Definido'
				   ,'No Definido'
				   ,'No Definido'
				   ,'No Definido'
				   ,'No Definido'
				   ,'No Definido'
				   ,-1
				   ,0
				   ,'No Definido'
				   ,0)
	

    SET IDENTITY_INSERT [dbo].[DimTer] OFF;

	END



--[dbo].[DimTer]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimTer]
				WHERE  [IdTer]=-2)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimTer] ON;

	
		INSERT INTO [dbo].[DimTer]
				   ([IdTer]
				   ,[IdSistemaTer]
				   ,[TipoDocumento]
				   ,[NumeroDocumento]
				   ,[NombreBase1]
				   ,[NombreBase2]
				   ,[Apellido1]
				   ,[Apellido2]
				   ,[ApellidoCasada]
				   ,[CodigoSexo]
				   ,[DescripcionSexo]
				   ,[CodigoEstadoCivil]
				   ,[DescripcionEstadoCivil]
				   ,[CodigoTipoPersona]
				   ,[TipoPersona]
				   ,[IdFechaNacimiento]
				   ,[Edad]
				   ,[RangoEdad]
				   ,[IdSistema])
			 VALUES
				   (-2
				   ,'No Aplica'
				   ,'No Aplica'
				   ,'No Aplica'
				   ,'No Aplica'
				   ,'No Aplica'
				   ,'No Aplica'
				   ,'No Aplica'
				   ,'No Aplica'
				   ,'No Aplica'
				   ,'No Aplica'
				   ,'No Aplica'
				   ,'No Aplica'
				   ,'No Aplica'
				   ,'No Aplica'
				   ,0
				   ,0
				   ,'No Aplica'
				   ,0)
	

    SET IDENTITY_INSERT [dbo].[DimTer] OFF;

	END


--*****************************************************************************
--*****************************************************************************
--[dbo].[DimUsuarios]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimUsuarios]
				WHERE [IdUsuario]=-1)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimUsuarios] ON;


	INSERT INTO [dbo].[DimUsuarios]
           ([IdUsuario]
		   ,[IdSucursal]
           ,[CodigoUsuario]
           ,[NombreUsuario])
     VALUES
           (-1
		   ,-1
           ,'No Definido'
           ,'No Definido');

    SET IDENTITY_INSERT [dbo].[DimUsuarios] OFF;

	END


--[dbo].[DimUsuarios]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimUsuarios]
				WHERE [IdSucursal]=-2)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimUsuarios] ON;


	INSERT INTO [dbo].[DimUsuarios]
           ([IdUsuario]
		   ,[IdSucursal]
           ,[CodigoUsuario]
           ,[NombreUsuario])
     VALUES
           (-2
		   ,-2
           ,'No Aplica'
           ,'No Aplica');

    SET IDENTITY_INSERT [dbo].[DimUsuarios] OFF;

	END


END
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetRangoEdad]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimCia]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimFechaAnulacionRecibo]    Script Date: 4/8/2014 3:56:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimFechaAnulacionRecibo](
	[IdFechaAnulacionRecibo] [int] NOT NULL,
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
 CONSTRAINT [PK_DimFechaAnulacionRecibo] PRIMARY KEY CLUSTERED 
(
	[IdFechaAnulacionRecibo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaBaja]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimFechaCobroRecibo]    Script Date: 4/8/2014 3:56:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimFechaCobroRecibo](
	[IdFechaCobroRecibo] [int] NOT NULL,
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
 CONSTRAINT [PK_DimFechaCobroRecibo] PRIMARY KEY CLUSTERED 
(
	[IdFechaCobroRecibo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaFinVigencia]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimFechaInicioVigencia]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimFechaInscripcion]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimFechaNacimiento]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimFechaRenovacion]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimFechaVencimientoRecibo]    Script Date: 4/8/2014 3:56:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimFechaVencimientoRecibo](
	[IdFechaVencimientoRecibo] [int] NOT NULL,
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
 CONSTRAINT [PK_DimFechaVencimientoRecibo] PRIMARY KEY CLUSTERED 
(
	[IdFechaVencimientoRecibo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimMoneda]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimPlan]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimPoliza]    Script Date: 4/8/2014 3:56:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimPoliza](
	[IdPoliza] [bigint] IDENTITY(1,1) NOT NULL,
	[CodigoCia] [varchar](150) NULL,
	[DescripcionRamo] [varchar](150) NULL,
	[Certificado] [varchar](150) NULL,
	[CodigoPoliza] [varchar](150) NULL,
	[Poliza] [varchar](150) NULL,
	[EstadoPoliza] [varchar](150) NULL,
	[DescripcionTipoPoliza] [varchar](150) NULL,
	[DescripcionFormaDePago] [varchar](150) NULL,
	[DescripcionMotivoCancelacion] [varchar](150) NULL,
	[DescripcionTipoCuenta] [varchar](150) NULL,
	[DescripcionTipoTarjeta] [varchar](150) NULL,
	[IdSistema] [int] NULL,
 CONSTRAINT [PK_DimPoliza] PRIMARY KEY CLUSTERED 
(
	[IdPoliza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimRecibo]    Script Date: 4/8/2014 3:56:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimRecibo](
	[IdRecibo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoPoliza] [varchar](50) NULL,
	[CodigoRecibo] [varchar](50) NULL,
	[NumeroRecibo] [varchar](50) NULL,
	[NumeroCuota] [varchar](50) NULL,
	[EstadoRecibo] [varchar](150) NULL,
 CONSTRAINT [PK_DimRecibo] PRIMARY KEY CLUSTERED 
(
	[IdRecibo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimSocio]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimSucursal]    Script Date: 4/8/2014 3:56:32 PM ******/
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
	[CodigoUbicacionGeografica] [varchar](50) NULL,
 CONSTRAINT [PK_DimSucursal] PRIMARY KEY CLUSTERED 
(
	[IdSucursal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimTer]    Script Date: 4/8/2014 3:56:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimTer](
	[IdTer] [bigint] IDENTITY(1,1) NOT NULL,
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
/****** Object:  Table [dbo].[DimUbicacionGeograficaCliente]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimUbicacionGeograficaSucursal]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[DimUsuarios]    Script Date: 4/8/2014 3:56:32 PM ******/
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
/****** Object:  Table [dbo].[FactPoliza]    Script Date: 4/8/2014 3:56:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactPoliza](
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
/****** Object:  Table [dbo].[FactRecibo]    Script Date: 4/8/2014 3:56:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactRecibo](
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
 CONSTRAINT [PK_FactRecibo_1] PRIMARY KEY CLUSTERED 
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
USE [master]
GO
ALTER DATABASE [DW_SAS] SET  READ_WRITE 
GO
