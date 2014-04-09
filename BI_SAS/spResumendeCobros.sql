DECLARE @fechaInicio datetime;
DECLARE @fechaInicioIncripcion int;
DECLARE @fechaFinInscripcion int;
DECLARE @MesesAnalisis int;
DECLARE @Cia int;
DECLARE @Socio int;
DECLARE @Ramo int;
DECLARE @Producto int;


SET  @fechaInicio=getdate();
SET @MesesAnalisis=12;



--********************************************************************************************
--********************************************************************************************
--Calcular la Fecha de Inscripcion de polizas
SET  @fechaInicioIncripcion = CONVERT(int, (LEFT(CONVERT(VARCHAR(10),  DATEADD(Month,-@MesesAnalisis,@fechaInicio),112),6) + '01')	);
SET  @fechaFinInscripcion =   CONVERT(VARCHAR(10),DATEADD(day,-1,CONVERT(datetime,CONVERT(VARCHAR(10),@fechaInicioIncripcion))),112)

--Definir Filtros de Poliza por CIA, SOCIO, Ramo, Producto
CREATE TABLE #tmpFiltros (IdCia int,
                          IdSocio int,
						  IdPlan int);



--Consultar polizas que fueron dadas de alta en el periodo indicado.
CREATE TABLE #tmpPolizasInscritas (idpoliza int,
                                   idFechaBaja int);

--Insertar la polizas que fueron inscritas en el periodo definido.
INSERT INTO #tmpPolizasInscritas (idpoliza,idFechaBaja)
SELECT 
FROM  [dbo].[FactPoliza] as pol
INNER JOIN




select 	 @fechaInicioIncripcion,@fechaFinInscripcion;

--Calcular fecha de inicio de polizas a analizar.
--SELECT 
--FROM [dbo].[FactPoliza]
--WHERE 
