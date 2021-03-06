USE [master]
GO
/****** Object:  Database [DW_SAS]    Script Date: 4/22/2014 2:31:37 PM ******/
CREATE DATABASE [DW_SAS] ON  PRIMARY 
( NAME = N'DW_SAS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQL2008\MSSQL\DATA\DW_SAS.mdf' , SIZE = 45056KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DW_SAS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQL2008\MSSQL\DATA\DW_SAS_log.ldf' , SIZE = 69760KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
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
/****** Object:  StoredProcedure [dbo].[spCargarDimFecha]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  StoredProcedure [dbo].[spDefaultValueDimensiones]    Script Date: 4/22/2014 2:31:37 PM ******/
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
-- [dbo].[DimFechaAnulacionRecibo]

IF (SELECT COUNT(1) 
			FROM [dbo].[DimFechaAnulacionRecibo]
				WHERE [IdFechaAnulacionRecibo]=-1)<=0
	BEGIN		

				INSERT INTO [dbo].[DimFechaAnulacionRecibo]
						   ([IdFechaAnulacionRecibo]
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
--[dbo].[DimFechaCobroRecibo]

IF (SELECT COUNT(1) 
			FROM [dbo].[DimFechaCobroRecibo]
				WHERE [IdFechaCobroRecibo]=-1)<=0
	BEGIN		

				INSERT INTO [dbo].[DimFechaCobroRecibo]
						   ([IdFechaCobroRecibo]
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
-- [dbo].[DimFechaVencimientoRecibo]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimFechaVencimientoRecibo]
				WHERE [IdFechaVencimientoRecibo]=-1)<=0
	BEGIN		

				INSERT INTO [dbo].[DimFechaVencimientoRecibo]
						   ([IdFechaVencimientoRecibo]
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
-- [dbo].[DimRecibo]
IF (SELECT COUNT(1) 
			FROM [dbo].[DimRecibo]
				WHERE [IdRecibo]=-1)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimRecibo] ON;  

    INSERT INTO [dbo].[DimRecibo]
           ([IdRecibo]
		   ,[CodigoPoliza]
           ,[CodigoRecibo]
           ,[NumeroRecibo]
           ,[NumeroCuota]
           ,[EstadoRecibo])
     VALUES( -1
           ,'No Definido'
           ,'No Definido'
           ,'No Definido'
           ,'No Definido'
           ,'No Definido') ;


    SET IDENTITY_INSERT [dbo].[DimRecibo] OFF;

	END


	IF (SELECT COUNT(1) 
			FROM [dbo].[DimRecibo]
				WHERE [IdRecibo]=-2)<=0
	BEGIN		

	SET IDENTITY_INSERT [dbo].[DimRecibo] ON;  

    INSERT INTO [dbo].[DimRecibo]
           ([IdRecibo]
		   ,[CodigoPoliza]
           ,[CodigoRecibo]
           ,[NumeroRecibo]
           ,[NumeroCuota]
           ,[EstadoRecibo])
     VALUES( -2
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica'
           ,'No Aplica') ;


    SET IDENTITY_INSERT [dbo].[DimRecibo] OFF;

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
/****** Object:  StoredProcedure [dbo].[spRPTDetalleDeCancelaciones]    Script Date: 4/22/2014 2:31:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--exec  [dbo].[spRPTDetalleDeCancelaciones] 2,-1,'ND','ND','201311','201401'
CREATE PROCEDURE [dbo].[spRPTDetalleDeCancelaciones]
(
		
		@IdCia int,
		@IdSocio int,
		@CodigoRamo varchar(50),
		@CodigoProducto varchar(50),
		@MesYearFila varchar(6),
		@MesYearColumna varchar(6)	 
)
AS
BEGIN
    
	--Definir Filtros de Poliza por CIA, SOCIO, Ramo, Producto

	--Filtrar los planes.
	CREATE TABLE #tmpFiltroPlan (IdPlan int);
	INSERT INTO #tmpFiltroPlan(IdPlan)
	SELECT 	IdPlan
	FROM  [dbo].[DimPlan]  as pln
	INNER JOIN 	[dbo].[DimCia]	as cia
		ON cia.[IdCia]=@IdCia 
		AND pln.[CodigoCIA] = cia.[CodigoCIA]
	WHERE (pln.[CodigoRamo] = @CodigoRamo OR  @CodigoRamo='ND') AND
		  (pln.[CodigoProducto] =@CodigoProducto OR @CodigoProducto='ND');



	--Filtrar los socios
	CREATE TABLE #tmpFiltroSocio (IdSocio int);
	INSERT INTO #tmpFiltroSocio( IdSocio)
	SELECT [IdSocio]
	FROM [dbo].[DimSocio] as sci
	INNER JOIN 	[dbo].[DimCia]	as cia
		ON cia.[IdCia]=@IdCia 
		AND sci.[CodigoCIA] = cia.[CodigoCIA]
	WHERE ([IdSocio]=@IdSocio OR @IdSocio=-1);

			
	--********************************************************************************************
	--********************************************************************************************
	--Consultar detalle de polizas

	SELECT  pol.IdPoliza,
	        CodigoCia= dpol.CodigoCia,
	        DescripcionRamo= dpol.DescripcionRamo,
			Certificado= dpol.Certificado,
			Documento = ter.NumeroDocumento, 
			Asegurado = ter.NombreBase1 + ' ' + ter.NombreBase2 + ' ' + ter.Apellido1 + ' ' + ter.Apellido2, 
			FechaInscripcion = CASE WHEN pol.IdFechaInscripcion > 1 
									THEN CONVERT(DATETIME,CONVERT(varchar(10),pol.IdFechaInscripcion),112) 
									ELSE NULL 
							   END,
			FechaBaja =CASE WHEN pol.IdFechaBaja > 1 
								THEN CONVERT(DATETIME,CONVERT(varchar(10),pol.IdFechaBaja),112) 
								ELSE NULL 
						END,
			EstadoPoliza= dpol.EstadoPoliza,
			TipoPoliza = dpol.DescripcionTipoPoliza,
			FormaDePago=dpol.DescripcionFormaDePago,
			TipoCuenta=dpol.DescripcionTipoCuenta,
			MotivoCancelacion=dpol.DescripcionMotivoCancelacion,
			Prima = pol.MontoPrimaAseguradaDolares,			
			Recibo = SUM(rcb.[MontoDolares])			 
	FROM  [dbo].[FactPoliza] as pol
	INNER JOIN 	  #tmpFiltroSocio as soc
		ON pol.[IdSocio]= soc.IdSocio
	INNER JOIN #tmpFiltroPlan as pln
		ON pol.IdPlan=pln.IdPlan
	INNER JOIN dbo.DimPoliza as dpol
		ON pol.IdPoliza=dpol.IdPoliza
		AND dpol.EstadoPoliza in (  'Cancelada')
	INNER JOIN dbo.DimTer as ter
		ON pol.IdTer= ter.IdTer
	LEFT JOIN  [dbo].[FactRecibo] as rcb	 			 
		ON 	 rcb.[IdPoliza]=pol.idpoliza  
		AND  left(rcb.IdFechaVencimientoRecibo,6)=@MesYearColumna 
	WHERE pol.[IdCia]=@IdCia 
	AND  left(pol.IdFechaInscripcion,6)=@MesYearFila  
	AND  left(pol.IdFechaInscripcion,6)<>left(pol.IdFechaBaja,6)
	GROUP BY   pol.IdPoliza,dpol.CodigoCia,
	         dpol.DescripcionRamo,
			 ter.NumeroDocumento, 
			 ter.NombreBase1 + ' ' + ter.NombreBase2 + ' ' + ter.Apellido1 + ' ' + ter.Apellido2, 
			 dpol.Certificado,
			 CASE WHEN pol.IdFechaInscripcion > 1 
									THEN CONVERT(DATETIME,CONVERT(varchar(10),pol.IdFechaInscripcion),112) 
									ELSE NULL 
			 END,
			 CASE WHEN pol.IdFechaBaja > 1 
								THEN CONVERT(DATETIME,CONVERT(varchar(10),pol.IdFechaBaja),112) 
								ELSE NULL 
			 END,
			 dpol.EstadoPoliza,
			 dpol.DescripcionTipoPoliza,
			 dpol.DescripcionFormaDePago,
			 dpol.DescripcionTipoCuenta,
			 dpol.DescripcionMotivoCancelacion,
			 pol.MontoPrimaAseguradaDolares,
			 pol.MontoPrimaAseguradaDolares;




	 DROP TABLE #tmpFiltroPlan;
	 DROP TABLE #tmpFiltroSocio
	
 
 
END		
GO
/****** Object:  StoredProcedure [dbo].[spRPTDetalleDeCobros]    Script Date: 4/22/2014 2:31:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--exec  [dbo].[spRPTDetalleDeCobros] 2,-1,'ND','ND','201207','201207'
CREATE PROCEDURE [dbo].[spRPTDetalleDeCobros]
(
		
		@IdCia int,
		@IdSocio int,
		@CodigoRamo varchar(50),
		@CodigoProducto varchar(50),
		@MesYearFila varchar(6),
		@MesYearColumna varchar(6)	 
)
AS
BEGIN
    
	--Definir Filtros de Poliza por CIA, SOCIO, Ramo, Producto

	--Filtrar los planes.
	CREATE TABLE #tmpFiltroPlan (IdPlan int);
	INSERT INTO #tmpFiltroPlan(IdPlan)
	SELECT 	IdPlan
	FROM  [dbo].[DimPlan]  as pln
	INNER JOIN 	[dbo].[DimCia]	as cia
		ON cia.[IdCia]=@IdCia 
		AND pln.[CodigoCIA] = cia.[CodigoCIA]
	WHERE (pln.[CodigoRamo] = @CodigoRamo OR  @CodigoRamo='ND') AND
		  (pln.[CodigoProducto] =@CodigoProducto OR @CodigoProducto='ND');



	--Filtrar los socios
	CREATE TABLE #tmpFiltroSocio (IdSocio int);
	INSERT INTO #tmpFiltroSocio( IdSocio)
	SELECT [IdSocio]
	FROM [dbo].[DimSocio] as sci
	INNER JOIN 	[dbo].[DimCia]	as cia
		ON cia.[IdCia]=@IdCia 
		AND sci.[CodigoCIA] = cia.[CodigoCIA]
	WHERE ([IdSocio]=@IdSocio OR @IdSocio=-1);

			
	--********************************************************************************************
	--********************************************************************************************
	--Consultar detalle de polizas

	SELECT  CodigoCia= dpol.CodigoCia,
	        DescripcionRamo= dpol.DescripcionRamo,
			Certificado= dpol.Certificado,
			Documento = ter.NumeroDocumento, 
			Asegurado = ter.NombreBase1 + ' ' + ter.NombreBase2 + ' ' + ter.Apellido1 + ' ' + ter.Apellido2, 
			FechaInscripcion = CASE WHEN pol.IdFechaInscripcion > 1 
									THEN CONVERT(DATETIME,CONVERT(varchar(10),pol.IdFechaInscripcion),112) 
									ELSE NULL 
							   END,
			FechaBaja =CASE WHEN pol.IdFechaBaja > 1 
								THEN CONVERT(DATETIME,CONVERT(varchar(10),pol.IdFechaBaja),112) 
								ELSE NULL 
						END,
			EstadoPoliza= dpol.EstadoPoliza,
			TipoPoliza = dpol.DescripcionTipoPoliza,
			FormaDePago=dpol.DescripcionFormaDePago,
			TipoCuenta=dpol.DescripcionTipoCuenta,
			MotivoCancelacion=dpol.DescripcionMotivoCancelacion,
			Prima = pol.MontoPrimaAseguradaDolares,			
			Recibo = SUM(rcb.[MontoDolares])			 
	FROM  [dbo].[FactPoliza] as pol
	INNER JOIN 	  #tmpFiltroSocio as soc
		ON pol.[IdSocio]= soc.IdSocio
	INNER JOIN #tmpFiltroPlan as pln
		ON pol.IdPlan=pln.IdPlan
	INNER JOIN dbo.DimPoliza as dpol
		ON pol.IdPoliza=dpol.IdPoliza
		AND dpol.EstadoPoliza in (  'Cancelada', 	'Vigente')
	INNER JOIN dbo.DimTer as ter
		ON pol.IdTer= ter.IdTer
	LEFT JOIN  [dbo].[FactRecibo] as rcb	 			 
		ON 	 rcb.[IdPoliza]=pol.idpoliza  
		AND  left(rcb.[IdFechaCobroRecibo],6)=@MesYearColumna 
		AND  rcb.[IdFechaAnulacionRecibo] =-1
	WHERE pol.[IdCia]=@IdCia 
	AND  left(pol.IdFechaInscripcion,6)=@MesYearFila  
	AND  left(pol.IdFechaInscripcion,6)<>left(pol.IdFechaBaja,6)
	GROUP BY  dpol.CodigoCia,
	         dpol.DescripcionRamo,
			 ter.NumeroDocumento, 
			 ter.NombreBase1 + ' ' + ter.NombreBase2 + ' ' + ter.Apellido1 + ' ' + ter.Apellido2, 
			 dpol.Certificado,
			 CASE WHEN pol.IdFechaInscripcion > 1 
									THEN CONVERT(DATETIME,CONVERT(varchar(10),pol.IdFechaInscripcion),112) 
									ELSE NULL 
			 END,
			 CASE WHEN pol.IdFechaBaja > 1 
								THEN CONVERT(DATETIME,CONVERT(varchar(10),pol.IdFechaBaja),112) 
								ELSE NULL 
			 END,
			 dpol.EstadoPoliza,
			 dpol.DescripcionTipoPoliza,
			 dpol.DescripcionFormaDePago,
			 dpol.DescripcionTipoCuenta,
			 dpol.DescripcionMotivoCancelacion,
			 pol.MontoPrimaAseguradaDolares,
			 pol.MontoPrimaAseguradaDolares;




	 DROP TABLE #tmpFiltroPlan;
	 DROP TABLE #tmpFiltroSocio
	
 
 
END		
GO
/****** Object:  StoredProcedure [dbo].[spRPTResumenDeCancelaciones]    Script Date: 4/22/2014 2:31:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec  spRPTResumenDeCancelaciones '2014-04-01',6,2,-1,'ND','ND'

CREATE PROCEDURE [dbo].[spRPTResumenDeCancelaciones]
(
		@fechaInicio datetime,
		@MesesAnalisis int,
		@IdCia int,
		@IdSocio int,
		@CodigoRamo varchar(50),
		@CodigoProducto varchar(50)	 
)
AS
BEGIN  
	--********************************************************************************************
	--********************************************************************************************
	--Variables Globales de proceso
	DECLARE @fechaInicioIncripcion int;
	DECLARE @fechaFinInscripcion int;
	DECLARE @fechaFinRecibos int;


	--********************************************************************************************
	--********************************************************************************************
	--Calcular la Fecha de Inscripcion de polizas
	SET  @fechaInicioIncripcion = CONVERT(int, (LEFT(CONVERT(VARCHAR(10),  DATEADD(Month,-@MesesAnalisis,@fechaInicio),112),6) + '01')	);
	SET  @fechaFinInscripcion =   CONVERT(VARCHAR(10),DATEADD(DAY, -1, DATEADD(MONTH,1,CONVERT(datetime,CONVERT(VARCHAR(10),@fechaInicioIncripcion)))),112)
	SET  @fechaFinRecibos =CONVERT (int, CONVERT(VARCHAR(10),@fechaInicio,112));
		  

	--Definir Filtros de Poliza por CIA, SOCIO, Ramo, Producto

	--Filtrar los planes.
	CREATE TABLE #tmpFiltroPlan (IdPlan int);
	INSERT INTO #tmpFiltroPlan(IdPlan)
	SELECT 	IdPlan
	FROM  [dbo].[DimPlan]  as pln
	INNER JOIN 	[dbo].[DimCia]	as cia
		ON cia.[IdCia]=@IdCia 
		AND pln.[CodigoCIA] = cia.[CodigoCIA]
	WHERE (pln.[CodigoRamo] = @CodigoRamo OR  @CodigoRamo='ND') AND
		  (pln.[CodigoProducto] =@CodigoProducto OR @CodigoProducto='ND');



	--Filtrar los socios
	CREATE TABLE #tmpFiltroSocio (IdSocio int);
	INSERT INTO #tmpFiltroSocio( IdSocio)
	SELECT [IdSocio]
	FROM [dbo].[DimSocio] as sci
	INNER JOIN 	[dbo].[DimCia]	as cia
		ON cia.[IdCia]=@IdCia 
		AND sci.[CodigoCIA] = cia.[CodigoCIA]
	WHERE ([IdSocio]=@IdSocio OR @IdSocio=-1);

			
	--********************************************************************************************
	--********************************************************************************************
	--Tablas de proceso de registros temporales.

	--Tabla de proceso de polizas
	CREATE TABLE #tmpPolizasInscritas (idpoliza int,
									   idFechaBaja int);


	 --Tabla de proceso de recibos
	 CREATE TABLE #tmpRecibos (MontoDolares decimal(24,4),
							   IdFechaAnulacion int);

	--Tabla final de query
	CREATE TABLE #TmpResumenDeCobros (
									  idMesFila int, 
	                                  MesYearFila varchar(6),
									  DescripcionMesYearFila varchar(50),

									  idMesColumna int,
	                                  MesYearColumna varchar(6),
									  DescripcionMesYearColumna varchar(50),


									  PolizasBaja int,
									  MontoDolares decimal(24,4)); 
 
	--********************************************************************************************
	--********************************************************************************************
	--Generar Elementos de Filas y columnas.

	--Variables de proceso.
	DECLARE @contador int;
	DECLARE @year varchar(4);
	DECLARE @mes varchar(2);


	--Iniciando variables de proceso
	SET @contador = 1; 
			  
	--Generar Meses 
	CREATE TABLE #Meses (IdMes int,
						 MesYear varchar(6),
						 DescripcionMesYear varchar(50));

	--Insertar Historial
	WHILE  @contador<=@MesesAnalisis
	BEGIN
       
			SET @year=left(@fechaInicioIncripcion,4);
			SET @mes =right(left(@fechaInicioIncripcion,6),2); 

			INSERT INTO  #Meses (idMes, MesYear,DescripcionMesYear)
			SELECT 	IdMes=@contador,
					MesYear = LEFT(@fechaInicioIncripcion,6),
					DescripcionMesYear = CASE @mes
													WHEN '01' THEN	'Enero-'       +  @year 
													WHEN '02' THEN  'Febrero-'     +  @year 
													WHEN '03' THEN  'Marzo-'	   +  @year 
													WHEN '04' THEN  'Abril-'	   +  @year 
													WHEN '05' THEN  'Mayo-'	       +  @year
													WHEN '06' THEN  'Junio-'	   +  @year
													WHEN '07' THEN  'Julio-'	   +  @year
													WHEN '08' THEN  'Agosto-'	   +  @year
													WHEN '09' THEN  'Septiembre-'  +  @year
													WHEN '10' THEN  'Octubre-'	   +  @year	 
													WHEN '11' THEN  'Noviembre-'   +  @year
													WHEN '12' THEN  'Diciembre-'   +  @year
												END;
		 --Aumentar contadores
		 SET @contador = @contador + 1;
		 SET @fechaInicioIncripcion =  CONVERT(int,CONVERT(varchar(10),DATEADD(MONTH,1,CONVERT(datetime,CONVERT(varchar(10),@fechaInicioIncripcion),112)),112));
		        
	END		  

	--********************************************************************************************
	--********************************************************************************************
	--Generar matrix de Fecha de inscripcion vrs Anyejamiento de polizas
	DECLARE   @idMesFila int; 
	DECLARE   @MesYearFila varchar(6);
	DECLARE   @DescripcionMesYearFila varchar(50);


	--Inicializar variables para generar matrix final
	SET @contador = 1; 
	SET  @fechaInicioIncripcion = CONVERT(int, (LEFT(CONVERT(VARCHAR(10),  DATEADD(Month,-@MesesAnalisis,@fechaInicio),112),6) + '01')	);
	SET  @fechaFinInscripcion =   CONVERT(VARCHAR(10),DATEADD(DAY, -1, DATEADD(MONTH,1,CONVERT(datetime,CONVERT(VARCHAR(10),@fechaInicioIncripcion)))),112);
	

	WHILE  @contador<=@MesesAnalisis
	BEGIN
		 	--*********************************************************************
	        --Limpiar tablas de proceso
		    TRUNCATE TABLE #tmpPolizasInscritas;
		    TRUNCATE TABLE #tmpRecibos; 

			--Definir variables de polizas inscritas
			 SELECT  @idMesFila=IdMes,
		             @MesYearFila=MesYear,
				     @DescripcionMesYearFila=DescripcionMesYear
			 FROM 	#Meses
			 WHERE IdMes=@contador;

			--*********************************************************************
			--Insertar la polizas que fueron inscritas en el periodo definido.
			INSERT INTO #tmpPolizasInscritas (idpoliza,idFechaBaja)
			SELECT 	pol.[IdPoliza],
					pol.[IdFechaBaja]
			FROM  [dbo].[FactPoliza] as pol
			INNER JOIN [dbo].[DimPoliza] as dpol
				ON pol.IdPoliza=dpol.IdPoliza
				AND dpol.EstadoPoliza in (  'Cancelada', 	'Vigente')
			INNER JOIN 	  #tmpFiltroSocio as soc
				ON pol.[IdSocio]= soc.IdSocio
			INNER JOIN #tmpFiltroPlan as pln
				ON pol.IdPlan=pln.IdPlan
			WHERE pol.[IdCia]=@IdCia   
			AND pol.[IdFechaInscripcion]  BETWEEN 	@fechaInicioIncripcion AND	 @fechaFinInscripcion
			AND pol.IdFechaBaja>0
			AND left(pol.IdFechaInscripcion,6)<>left(pol.[IdFechaBaja],6)
			
			--Insertar recibos que aplican en el periodo 
			INSERT INTO #tmpRecibos(MontoDolares,IdFechaAnulacion) 
			SELECT  
					 MontoDolares=SUM([MontoDolares]),
					 IdFechaAnulacion=CONVERT(int,left([IdFechaVencimientoRecibo],6)) 
			FROM [dbo].[FactRecibo] as rcb
			INNER JOIN #tmpPolizasInscritas as tmp
 				ON rcb.[IdPoliza]=tmp.idpoliza
			WHERE  [IdFechaVencimientoRecibo]	  BETWEEN @fechaInicioIncripcion AND  @fechaFinRecibos
			AND  [IdFechaAnulacionRecibo]  > -1
			AND rcb.IdFechaVencimientoRecibo>=tmp.idFechaBaja
			GROUP BY   CONVERT(int,left([IdFechaVencimientoRecibo],6))  ;


		

			--*********************************************************************
			--Generar producto final
			INSERT INTO #TmpResumenDeCobros (idMesFila,MesYearFila,DescripcionMesYearFila,idMesColumna,MesYearColumna,DescripcionMesYearColumna,PolizasBaja,MontoDolares)
			SELECT 
					idMesFila=@idMesFila, 
					MesYearFila=@MesYearFila,
					DescripcionMesYearFila=@DescripcionMesYearFila,


					idMesColumna= PolizasVigentesPorMes.IdMes,
					MesYearColumna= PolizasVigentesPorMes.MesYear,
					DescripcionMesYearColumna=PolizasVigentesPorMes.DescripcionMesYear,
					
					PolizasBaja=PolizasVigentesPorMes.PolizasBaja,
					MontoDolares=rcb.MontoDolares 				   
			FROM (
					SELECT 	m.IdMes,
							m.MesYear,
							m.DescripcionMesYear,
							PolizasBaja= SUM( 
							                   CASE  WHEN  convert(int,m.MesYear) = convert(int,left(pol.[IdFechaBaja],6))	  THEN 1
											         WHEN    convert(int,m.MesYear) > convert(int,left(pol.[IdFechaBaja],6))  THEN 1
											   ELSE 0 END)
					FROM #Meses as M
					LEFT JOIN  #tmpPolizasInscritas as pol
						ON 	 m.IdMes>=@idMesFila
					GROUP BY   m.IdMes,
							   m.MesYear,
							   m.DescripcionMesYear
				) PolizasVigentesPorMes
			LEFT JOIN  #tmpRecibos rcb
				ON 	PolizasVigentesPorMes.MesYear=left(rcb.IdFechaAnulacion,6)
			ORDER BY	PolizasVigentesPorMes.IdMes



	     --Aumentar contadores
		 SET @contador = @contador + 1;
		 SET @fechaInicioIncripcion =  CONVERT(int,CONVERT(varchar(10),DATEADD(MONTH,1,CONVERT(datetime,CONVERT(varchar(10),@fechaInicioIncripcion),112)),112));
		 SET  @fechaFinInscripcion =   CONVERT(VARCHAR(10),DATEADD(DAY, -1, DATEADD(MONTH,1,CONVERT(datetime,CONVERT(VARCHAR(10),@fechaInicioIncripcion)))),112);
	END
	   		   
	
	SELECT 		
			idMesFila, 
			MesYearFila,
			DescripcionMesYearFila,
			idMesColumna,
			MesYearColumna,
			DescripcionMesYearColumna,					
			PolizasBaja,
			MontoDolares				   
	FROM #TmpResumenDeCobros
	ORDER BY idMesFila,idMesColumna;


	 DROP TABLE #tmpFiltroPlan;
	 DROP TABLE #tmpFiltroSocio
	 DROP TABLE #tmpPolizasInscritas	
	 DROP TABLE #Meses;	
	 DROP TABLE #tmpRecibos;
	 DROP TABLE #TmpResumenDeCobros;	
 
 
END		
GO
/****** Object:  StoredProcedure [dbo].[spRPTResumenDeCobros]    Script Date: 4/22/2014 2:31:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec  spRPTResumenDeCobros '2014-04-01',36,2,-1,'ND','ND'

CREATE PROCEDURE [dbo].[spRPTResumenDeCobros]
(
		@fechaInicio datetime,
		@MesesAnalisis int,
		@IdCia int,
		@IdSocio int,
		@CodigoRamo varchar(50),
		@CodigoProducto varchar(50)	 
)
AS
BEGIN  
	--********************************************************************************************
	--********************************************************************************************
	--Variables Globales de proceso
	DECLARE @fechaInicioIncripcion int;
	DECLARE @fechaFinInscripcion int;
	DECLARE @fechaFinRecibos int;


	--********************************************************************************************
	--********************************************************************************************
	--Calcular la Fecha de Inscripcion de polizas
	SET  @fechaInicioIncripcion = CONVERT(int, (LEFT(CONVERT(VARCHAR(10),  DATEADD(Month,-@MesesAnalisis,@fechaInicio),112),6) + '01')	);
	SET  @fechaFinInscripcion =   CONVERT(VARCHAR(10),DATEADD(DAY, -1, DATEADD(MONTH,1,CONVERT(datetime,CONVERT(VARCHAR(10),@fechaInicioIncripcion)))),112)
	SET  @fechaFinRecibos =CONVERT (int, CONVERT(VARCHAR(10),@fechaInicio,112));
		  

	--Definir Filtros de Poliza por CIA, SOCIO, Ramo, Producto

	--Filtrar los planes.
	CREATE TABLE #tmpFiltroPlan (IdPlan int);
	INSERT INTO #tmpFiltroPlan(IdPlan)
	SELECT 	IdPlan
	FROM  [dbo].[DimPlan]  as pln
	INNER JOIN 	[dbo].[DimCia]	as cia
		ON cia.[IdCia]=@IdCia 
		AND pln.[CodigoCIA] = cia.[CodigoCIA]
	WHERE (pln.[CodigoRamo] = @CodigoRamo OR  @CodigoRamo='ND') AND
		  (pln.[CodigoProducto] =@CodigoProducto OR @CodigoProducto='ND');



	--Filtrar los socios
	CREATE TABLE #tmpFiltroSocio (IdSocio int);
	INSERT INTO #tmpFiltroSocio( IdSocio)
	SELECT [IdSocio]
	FROM [dbo].[DimSocio] as sci
	INNER JOIN 	[dbo].[DimCia]	as cia
		ON cia.[IdCia]=@IdCia 
		AND sci.[CodigoCIA] = cia.[CodigoCIA]
	WHERE ([IdSocio]=@IdSocio OR @IdSocio=-1);

			
	--********************************************************************************************
	--********************************************************************************************
	--Tablas de proceso de registros temporales.

	--Tabla de proceso de polizas
	CREATE TABLE #tmpPolizasInscritas (idpoliza int,
									   idFechaBaja int);


	 --Tabla de proceso de recibos
	 CREATE TABLE #tmpRecibos (MontoDolares decimal(24,4),
							   IdFechaCobroRecibo int);

	--Tabla final de query
	CREATE TABLE #TmpResumenDeCobros (
									  idMesFila int, 
	                                  MesYearFila varchar(6),
									  DescripcionMesYearFila varchar(50),

									  idMesColumna int,
	                                  MesYearColumna varchar(6),
									  DescripcionMesYearColumna varchar(50),


									  PolizasActivas int,
									  MontoDolares decimal(24,4)); 
 
	--********************************************************************************************
	--********************************************************************************************
	--Generar Elementos de Filas y columnas.

	--Variables de proceso.
	DECLARE @contador int;
	DECLARE @year varchar(4);
	DECLARE @mes varchar(2);


	--Iniciando variables de proceso
	SET @contador = 1; 
			  
	--Generar Meses 
	CREATE TABLE #Meses (IdMes int,
						 MesYear varchar(6),
						 DescripcionMesYear varchar(50));

	--Insertar Historial
	WHILE  @contador<=@MesesAnalisis
	BEGIN
       
			SET @year=left(@fechaInicioIncripcion,4);
			SET @mes =right(left(@fechaInicioIncripcion,6),2); 

			INSERT INTO  #Meses (idMes, MesYear,DescripcionMesYear)
			SELECT 	IdMes=@contador,
					MesYear = LEFT(@fechaInicioIncripcion,6),
					DescripcionMesYear = CASE @mes
													WHEN '01' THEN	'Enero-'       +  @year 
													WHEN '02' THEN  'Febrero-'     +  @year 
													WHEN '03' THEN  'Marzo-'	   +  @year 
													WHEN '04' THEN  'Abril-'	   +  @year 
													WHEN '05' THEN  'Mayo-'	       +  @year
													WHEN '06' THEN  'Junio-'	   +  @year
													WHEN '07' THEN  'Julio-'	   +  @year
													WHEN '08' THEN  'Agosto-'	   +  @year
													WHEN '09' THEN  'Septiembre-'  +  @year
													WHEN '10' THEN  'Octubre-'	   +  @year	 
													WHEN '11' THEN  'Noviembre-'   +  @year
													WHEN '12' THEN  'Diciembre-'   +  @year
												END;
		 --Aumentar contadores
		 SET @contador = @contador + 1;
		 SET @fechaInicioIncripcion =  CONVERT(int,CONVERT(varchar(10),DATEADD(MONTH,1,CONVERT(datetime,CONVERT(varchar(10),@fechaInicioIncripcion),112)),112));
		        
	END		  

	--********************************************************************************************
	--********************************************************************************************
	--Generar matrix de Fecha de inscripcion vrs Anyejamiento de polizas
	DECLARE   @idMesFila int; 
	DECLARE   @MesYearFila varchar(6);
	DECLARE   @DescripcionMesYearFila varchar(50);


	--Inicializar variables para generar matrix final
	SET @contador = 1; 
	SET  @fechaInicioIncripcion = CONVERT(int, (LEFT(CONVERT(VARCHAR(10),  DATEADD(Month,-@MesesAnalisis,@fechaInicio),112),6) + '01')	);
	SET  @fechaFinInscripcion =   CONVERT(VARCHAR(10),DATEADD(DAY, -1, DATEADD(MONTH,1,CONVERT(datetime,CONVERT(VARCHAR(10),@fechaInicioIncripcion)))),112);
	

	WHILE  @contador<=@MesesAnalisis
	BEGIN
		 	--*********************************************************************
	        --Limpiar tablas de proceso
		    TRUNCATE TABLE #tmpPolizasInscritas;
		    TRUNCATE TABLE #tmpRecibos; 

			--Definir variables de polizas inscritas
			 SELECT  @idMesFila=IdMes,
		             @MesYearFila=MesYear,
				     @DescripcionMesYearFila=DescripcionMesYear
			 FROM 	#Meses
			 WHERE IdMes=@contador;

			--*********************************************************************
			--Insertar la polizas que fueron inscritas en el periodo definido.
			INSERT INTO #tmpPolizasInscritas (idpoliza,idFechaBaja)
			SELECT 	pol.[IdPoliza],
					pol.[IdFechaBaja]
			FROM  [dbo].[FactPoliza] as pol
			INNER JOIN [dbo].[DimPoliza] as dpol
				ON pol.IdPoliza=dpol.IdPoliza
				AND dpol.EstadoPoliza in (  'Cancelada', 	'Vigente')
			INNER JOIN 	  #tmpFiltroSocio as soc
				ON pol.[IdSocio]= soc.IdSocio
			INNER JOIN #tmpFiltroPlan as pln
				ON pol.IdPlan=pln.IdPlan
			WHERE pol.[IdCia]=@IdCia   
			AND pol.[IdFechaInscripcion]  BETWEEN 	@fechaInicioIncripcion AND	 @fechaFinInscripcion
			AND left(pol.IdFechaInscripcion,6)<>left(pol.[IdFechaBaja],6)
			
			--Insertar recibos que aplican en el periodo 
			INSERT INTO #tmpRecibos(MontoDolares,IdFechaCobroRecibo) 
			SELECT  
					 MontoDolares=SUM([MontoDolares]),
					 IdFechaCobroRecibo=CONVERT(int,left([IdFechaCobroRecibo],6)) 
			FROM [dbo].[FactRecibo] as rcb
			 INNER JOIN #tmpPolizasInscritas as tmp
 				ON 	 rcb.[IdPoliza]=tmp.idpoliza
			WHERE  [IdFechaCobroRecibo]	  BETWEEN @fechaInicioIncripcion AND  @fechaFinRecibos
			AND  [IdFechaAnulacionRecibo]  = -1
			GROUP BY   CONVERT(int,left([IdFechaCobroRecibo],6))  ;


		

			--*********************************************************************
			--Generar producto final
			INSERT INTO #TmpResumenDeCobros (idMesFila,MesYearFila,DescripcionMesYearFila,idMesColumna,MesYearColumna,DescripcionMesYearColumna,PolizasActivas,MontoDolares)
			SELECT 
					idMesFila=@idMesFila, 
					MesYearFila=@MesYearFila,
					DescripcionMesYearFila=@DescripcionMesYearFila,


					idMesColumna= PolizasVigentesPorMes.IdMes,
					MesYearColumna= PolizasVigentesPorMes.MesYear,
					DescripcionMesYearColumna=PolizasVigentesPorMes.DescripcionMesYear,
					
					PolizasActivas=PolizasVigentesPorMes.PolizasActivas,
					MontoDolares=rcb.MontoDolares 				   
			FROM (
					SELECT 	m.IdMes,
							m.MesYear,
							m.DescripcionMesYear,
							PolizasActivas= SUM( CASE WHEN pol.[IdFechaBaja]=-1 THEN 1
													  WHEN    convert(int,m.MesYear) < convert(int,left(pol.[IdFechaBaja],6))  THEN 1
													  ELSE 0 END)
					FROM #Meses as M
					LEFT JOIN  #tmpPolizasInscritas as pol
						ON 	 m.IdMes>=@idMesFila
					GROUP BY   m.IdMes,
							   m.MesYear,
							   m.DescripcionMesYear
				) PolizasVigentesPorMes
			LEFT JOIN  #tmpRecibos rcb
				ON 	PolizasVigentesPorMes.MesYear=left(rcb.IdFechaCobroRecibo,6)
			ORDER BY	PolizasVigentesPorMes.IdMes



	     --Aumentar contadores
		 SET @contador = @contador + 1;
		 SET @fechaInicioIncripcion =  CONVERT(int,CONVERT(varchar(10),DATEADD(MONTH,1,CONVERT(datetime,CONVERT(varchar(10),@fechaInicioIncripcion),112)),112));
		 SET  @fechaFinInscripcion =   CONVERT(VARCHAR(10),DATEADD(DAY, -1, DATEADD(MONTH,1,CONVERT(datetime,CONVERT(VARCHAR(10),@fechaInicioIncripcion)))),112);
	END
	   		   
	
	SELECT 		
			idMesFila, 
			MesYearFila,
			DescripcionMesYearFila,
			idMesColumna,
			MesYearColumna,
			DescripcionMesYearColumna,					
			PolizasActivas,
			MontoDolares				   
	FROM #TmpResumenDeCobros
	ORDER BY idMesFila,idMesColumna;


	 DROP TABLE #tmpFiltroPlan;
	 DROP TABLE #tmpFiltroSocio
	 DROP TABLE #tmpPolizasInscritas	
	 DROP TABLE #Meses;	
	 DROP TABLE #tmpRecibos;
	 DROP TABLE #TmpResumenDeCobros;	
 
 
END		
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetRangoEdad]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimCia]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimFechaAnulacionRecibo]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimFechaBaja]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimFechaCobroRecibo]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimFechaFinVigencia]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimFechaInicioVigencia]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimFechaInscripcion]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimFechaNacimiento]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimFechaRenovacion]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimFechaVencimientoRecibo]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimMoneda]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimPlan]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimPoliza]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimRecibo]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimSocio]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimSucursal]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimTer]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[DimUbicacionGeograficaCliente]    Script Date: 4/22/2014 2:31:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimUbicacionGeograficaCliente](
	[IdUbicacionGeograficaCliente] [int] NOT NULL,
	[IdUbicacionGeograficaPadre] [int] NULL,
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
/****** Object:  Table [dbo].[DimUbicacionGeograficaSucursal]    Script Date: 4/22/2014 2:31:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimUbicacionGeograficaSucursal](
	[IdUbicacionGeograficaSucursal] [int] NOT NULL,
	[IdUbicacionGeograficaPadre] [int] NULL,
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
/****** Object:  Table [dbo].[DimUsuarios]    Script Date: 4/22/2014 2:31:37 PM ******/
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
/****** Object:  Table [dbo].[FactPoliza]    Script Date: 4/22/2014 2:31:37 PM ******/
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
	[IdPoliza] [bigint] NOT NULL,
	[IdSocio] [int] NOT NULL,
	[IdSucursal] [int] NOT NULL,
	[IdTer] [bigint] NOT NULL,
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
	[FechaSistema] [datetime] NULL,
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
/****** Object:  Table [dbo].[FactRecibo]    Script Date: 4/22/2014 2:31:37 PM ******/
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
	[IdTer] [bigint] NOT NULL,
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
	[FechaSistema] [datetime] NULL,
	[FechaProceso] [datetime] NULL,
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
ALTER TABLE [dbo].[FactPoliza] ADD  CONSTRAINT [DF_FactPoliza_FechaSistema]  DEFAULT (getdate()) FOR [FechaSistema]
GO
ALTER TABLE [dbo].[FactRecibo] ADD  CONSTRAINT [DF_FactRecibo_FechaSistema]  DEFAULT (getdate()) FOR [FechaSistema]
GO
ALTER TABLE [dbo].[DimUbicacionGeograficaCliente]  WITH CHECK ADD  CONSTRAINT [FK_DimUbicacionGeograficaCliente_DimUbicacionGeograficaCliente] FOREIGN KEY([IdUbicacionGeograficaPadre])
REFERENCES [dbo].[DimUbicacionGeograficaCliente] ([IdUbicacionGeograficaCliente])
GO
ALTER TABLE [dbo].[DimUbicacionGeograficaCliente] CHECK CONSTRAINT [FK_DimUbicacionGeograficaCliente_DimUbicacionGeograficaCliente]
GO
ALTER TABLE [dbo].[DimUbicacionGeograficaSucursal]  WITH CHECK ADD  CONSTRAINT [FK_DimUbicacionGeograficaSucursal_DimUbicacionGeograficaSucursal] FOREIGN KEY([IdUbicacionGeograficaPadre])
REFERENCES [dbo].[DimUbicacionGeograficaSucursal] ([IdUbicacionGeograficaSucursal])
GO
ALTER TABLE [dbo].[DimUbicacionGeograficaSucursal] CHECK CONSTRAINT [FK_DimUbicacionGeograficaSucursal_DimUbicacionGeograficaSucursal]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimCia] FOREIGN KEY([IdCia])
REFERENCES [dbo].[DimCia] ([IdCia])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimCia]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimFechaBaja] FOREIGN KEY([IdFechaBaja])
REFERENCES [dbo].[DimFechaBaja] ([IdFechaBaja])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimFechaBaja]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimFechaFinVigencia] FOREIGN KEY([IdFechaFinVigencia])
REFERENCES [dbo].[DimFechaFinVigencia] ([IdFechaFinVigencia])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimFechaFinVigencia]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimFechaInicioVigencia] FOREIGN KEY([IdFechaInicioVigencia])
REFERENCES [dbo].[DimFechaInicioVigencia] ([IdFechaInicioVigencia])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimFechaInicioVigencia]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimFechaInscripcion] FOREIGN KEY([IdFechaInscripcion])
REFERENCES [dbo].[DimFechaInscripcion] ([IdFechaInscripcion])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimFechaInscripcion]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimFechaNacimiento] FOREIGN KEY([IdFechaNacimiento])
REFERENCES [dbo].[DimFechaNacimiento] ([IdFechaNacimiento])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimFechaNacimiento]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimFechaRenovacion] FOREIGN KEY([IdFechaRenovacion])
REFERENCES [dbo].[DimFechaRenovacion] ([IdFechaRenovacion])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimFechaRenovacion]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimMoneda] FOREIGN KEY([IdMoneda])
REFERENCES [dbo].[DimMoneda] ([IdMoneda])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimMoneda]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimPlan] FOREIGN KEY([IdPlan])
REFERENCES [dbo].[DimPlan] ([IdPlan])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimPlan]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimPoliza] FOREIGN KEY([IdPoliza])
REFERENCES [dbo].[DimPoliza] ([IdPoliza])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimPoliza]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimSocio] FOREIGN KEY([IdSocio])
REFERENCES [dbo].[DimSocio] ([IdSocio])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimSocio]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimSucursal] FOREIGN KEY([IdSucursal])
REFERENCES [dbo].[DimSucursal] ([IdSucursal])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimSucursal]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimTer] FOREIGN KEY([IdTer])
REFERENCES [dbo].[DimTer] ([IdTer])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimTer]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimUbicacionGeograficaCliente] FOREIGN KEY([IdUbicacionGeograficaCliente])
REFERENCES [dbo].[DimUbicacionGeograficaCliente] ([IdUbicacionGeograficaCliente])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimUbicacionGeograficaCliente]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimUbicacionGeograficaSucursal] FOREIGN KEY([IdUbicacionGeograficaSucursal])
REFERENCES [dbo].[DimUbicacionGeograficaSucursal] ([IdUbicacionGeograficaSucursal])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimUbicacionGeograficaSucursal]
GO
ALTER TABLE [dbo].[FactPoliza]  WITH CHECK ADD  CONSTRAINT [FK_FactPoliza_DimUsuarios] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[DimUsuarios] ([IdUsuario])
GO
ALTER TABLE [dbo].[FactPoliza] CHECK CONSTRAINT [FK_FactPoliza_DimUsuarios]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimCia] FOREIGN KEY([IdCia])
REFERENCES [dbo].[DimCia] ([IdCia])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimCia]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimFechaAnulacionRecibo] FOREIGN KEY([IdFechaAnulacionRecibo])
REFERENCES [dbo].[DimFechaAnulacionRecibo] ([IdFechaAnulacionRecibo])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimFechaAnulacionRecibo]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimFechaCobroRecibo] FOREIGN KEY([IdFechaCobroRecibo])
REFERENCES [dbo].[DimFechaCobroRecibo] ([IdFechaCobroRecibo])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimFechaCobroRecibo]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimFechaVencimientoRecibo] FOREIGN KEY([IdFechaVencimientoRecibo])
REFERENCES [dbo].[DimFechaVencimientoRecibo] ([IdFechaVencimientoRecibo])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimFechaVencimientoRecibo]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimMoneda] FOREIGN KEY([IdMoneda])
REFERENCES [dbo].[DimMoneda] ([IdMoneda])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimMoneda]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimPlan] FOREIGN KEY([IdPlan])
REFERENCES [dbo].[DimPlan] ([IdPlan])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimPlan]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimPoliza] FOREIGN KEY([IdPoliza])
REFERENCES [dbo].[DimPoliza] ([IdPoliza])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimPoliza]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimRecibo] FOREIGN KEY([IdRecibo])
REFERENCES [dbo].[DimRecibo] ([IdRecibo])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimRecibo]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimSocio] FOREIGN KEY([IdSocio])
REFERENCES [dbo].[DimSocio] ([IdSocio])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimSocio]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimSucursal] FOREIGN KEY([IdSucursal])
REFERENCES [dbo].[DimSucursal] ([IdSucursal])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimSucursal]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimTer] FOREIGN KEY([IdTer])
REFERENCES [dbo].[DimTer] ([IdTer])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimTer]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimUbicacionGeograficaCliente] FOREIGN KEY([IdUbicacionGeograficaCliente])
REFERENCES [dbo].[DimUbicacionGeograficaCliente] ([IdUbicacionGeograficaCliente])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimUbicacionGeograficaCliente]
GO
ALTER TABLE [dbo].[FactRecibo]  WITH CHECK ADD  CONSTRAINT [FK_FactRecibo_DimUbicacionGeograficaSucursal] FOREIGN KEY([IdUbicacionGeograficaSucursal])
REFERENCES [dbo].[DimUbicacionGeograficaSucursal] ([IdUbicacionGeograficaSucursal])
GO
ALTER TABLE [dbo].[FactRecibo] CHECK CONSTRAINT [FK_FactRecibo_DimUbicacionGeograficaSucursal]
GO
USE [master]
GO
ALTER DATABASE [DW_SAS] SET  READ_WRITE 
GO
