DECLARE @fechaInicio datetime;
DECLARE @fechaInicioIncripcion int;
DECLARE @fechaFinInscripcion int;
DECLARE @fechaFinRecibos int;
DECLARE @MesesAnalisis int;
DECLARE @IdCia int;
DECLARE @IdSocio int;
DECLARE @CodigoRamo varchar(50);
DECLARE @CodigoProducto varchar(50);


SET  @fechaInicio=getdate();
SET @MesesAnalisis=12;



--********************************************************************************************
--********************************************************************************************
--Calcular la Fecha de Inscripcion de polizas
SET  @fechaInicioIncripcion = CONVERT(int, (LEFT(CONVERT(VARCHAR(10),  DATEADD(Month,-@MesesAnalisis,@fechaInicio),112),6) + '01')	);
SET  @fechaFinInscripcion =   CONVERT(VARCHAR(10),DATEADD(day,-1,CONVERT(datetime,CONVERT(VARCHAR(10),@fechaInicioIncripcion))),112)
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
SELECT [IdSocio]
FROM [dbo].[DimSocio] as sci
INNER JOIN 	[dbo].[DimCia]	as cia
	ON cia.[IdCia]=@IdCia 
	AND sci.[CodigoCIA] = cia.[CodigoCIA]
WHERE ([IdSocio]=@IdSocio OR @IdSocio=-1);

--Consultar polizas que fueron dadas de alta en el periodo indicado.
CREATE TABLE #tmpPolizasInscritas (idpoliza int,
                                   idFechaBaja int);


--********************************************************************************************
--********************************************************************************************
--Insertar la polizas que fueron inscritas en el periodo definido.
INSERT INTO #tmpPolizasInscritas (idpoliza,idFechaBaja)
SELECT 	[IdPoliza],
        [IdFechaBaja]
FROM  [dbo].[FactPoliza] as pol
INNER JOIN 	  #tmpFiltroSocio as soc
	ON pol.[IdSocio]= soc.IdSocio
INNER JOIN #tmpFiltroPlan as pln
	ON pol.IdPlan=pln.IdPlan
WHERE pol.[IdCia]=@IdCia  
AND pol.[IdFechaInscripcion]  BETWEEN 	@fechaInicioIncripcion AND	 @fechaFinInscripcion;

--Insertar recibos que aplican en el periodo
 SELECT  [IdPoliza],
         [MontoDolares],
		 [IdFechaCobroRecibo] 
 FROM [dbo].[FactRecibo] as rcb
 INNER JOIN #tmpPolizasInscritas as tmp
 	ON 	 rcb.[IdPoliza]=tmp.idpoliza
WHERE  [IdFechaCobroRecibo]	  BETWEEN @fechaInicioIncripcion AND  @fechaFinRecibos
AND  [IdFechaAnulacionRecibo]  = -1



--********************************************************************************************
--********************************************************************************************
--Generar resultado query de matrix.

--Variables de proceso.
DECLARE @contador int;
DECLARE @year varchar(4);
DECLARE @mes int;


--Iniciando variables de proceso
SET @contador = 1; 


--Generar Meses 
CREATE TABLE #Meses (IdMes int,
                     MesYear int,
					 DescripcionMesYear varchar(50));

--Insertar Historial
WHILE  @contador<=@MesesAnalisis
BEGIN
       
	    SET @year=left(@fechaInicioIncripcion,4);
		SET @mes =right(left(@fechaInicioIncripcion,6),2); 

		INSERT INTO  #Meses (idMes, MesYear,DescripcionMesYear)
		SELECT 	IdMes=@contador,
		        MesYear = CONVERT(int,LEFT(@fechaInicioIncripcion,6)),
				DescripcionMesYear = CASE @mes
											    WHEN '01' THEN	 'Enero-'      +  @year 
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
	 SET @contador = @contador +1;
	 SET @fechaInicioIncripcion = CONVERT(int, dateadd(MONTH,1,CONVERT(datetime, CONVERT(varchar(10),@fechaInicioIncripcion),112));
		        
END



								