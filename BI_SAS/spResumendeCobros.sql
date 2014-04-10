DECLARE @fechaInicio datetime;
DECLARE @fechaInicioIncripcion int;
DECLARE @fechaFinInscripcion int;
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

--



											