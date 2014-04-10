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
SET @MesesAnalisis=5;
SET @IdCia=	2;
SET @IdSocio=-1;
SET @CodigoRamo='ND';
SET @CodigoProducto='ND';


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

 --select * from #tmpFiltroPlan;



--Filtrar los socios
CREATE TABLE #tmpFiltroSocio (IdSocio int);
INSERT INTO #tmpFiltroSocio( IdSocio)
SELECT [IdSocio]
FROM [dbo].[DimSocio] as sci
INNER JOIN 	[dbo].[DimCia]	as cia
	ON cia.[IdCia]=@IdCia 
	AND sci.[CodigoCIA] = cia.[CodigoCIA]
WHERE ([IdSocio]=@IdSocio OR @IdSocio=-1);


--SELECT * FROM #tmpFiltroSocio;

--********************************************************************************************
--********************************************************************************************


--Consultar polizas que fueron dadas de alta en el periodo indicado.
CREATE TABLE #tmpPolizasInscritas (idpoliza int,
                                   idFechaBaja int);

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

--SELECT @fechaInicioIncripcion,@fechaFinInscripcion;
--SELECT idpoliza FROM #tmpPolizasInscritas;


 --Consultar Recibos
 CREATE TABLE #tmpRecibos (MontoDolares decimal(24,4),
						   IdFechaCobroRecibo int);

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


 

--SELECT * FROM #tmpRecibos;
--********************************************************************************************
--********************************************************************************************
--Generar resultado query de matrix.

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




SELECT 	m.IdMes,
		m.MesYear,
		m.DescripcionMesYear,
		PolizasActivas= SUM( CASE WHEN pol.[IdFechaBaja]=-1 THEN 1
									--WHEN    convert(int,m.MesYear) < pol.[IdFechaBaja] THEN 1
									ELSE 0 END)	,
	    PolizasActivas2= SUM( CASE WHEN    convert(int,m.MesYear) < convert(int,left(pol.[IdFechaBaja],6))   THEN 1
									ELSE 0 END)
FROM #Meses as M
CROSS JOIN  #tmpPolizasInscritas as pol
GROUP BY   m.IdMes,
			m.MesYear,
			m.DescripcionMesYear

--Generar producto final
SELECT PolizasVigentesPorMes.IdMes,
       PolizasVigentesPorMes.MesYear,
	   PolizasVigentesPorMes.DescripcionMesYear,
	   PolizasVigentesPorMes.PolizasActivas,
	   rcb.MontoDolares
FROM (
		SELECT 	m.IdMes,
				m.MesYear,
				m.DescripcionMesYear,
				PolizasActivas= SUM( CASE WHEN pol.[IdFechaBaja]=-1 THEN 1
										  WHEN    convert(int,m.MesYear) < convert(int,left(pol.[IdFechaBaja],6))  THEN 1
										  ELSE 0 END)
		FROM #Meses as M
		CROSS JOIN  #tmpPolizasInscritas as pol
		GROUP BY   m.IdMes,
				   m.MesYear,
				   m.DescripcionMesYear
	) PolizasVigentesPorMes
LEFT JOIN  #tmpRecibos rcb
	ON 	PolizasVigentesPorMes.MesYear=left(rcb.IdFechaCobroRecibo,6)
		   
	
 select * from #tmpRecibos;



 DROP TABLE #tmpFiltroPlan;
 DROP TABLE #tmpFiltroSocio
 DROP TABLE #tmpPolizasInscritas	
 DROP TABLE #Meses;	
 DROP TABLE #tmpRecibos;	
 
 
 --SELECT CONVERT(int, dateadd(MONTH,1,CONVERT(datetime, CONVERT(varchar(10),20000101),112)));	
 
 --SELECT CONVERT(int,CONVERT(varchar(10),DATEADD(MONTH,1,CONVERT(datetime,CONVERT(varchar(10),20000101),112)),112))				