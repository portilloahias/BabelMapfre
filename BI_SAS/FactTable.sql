/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [IdCia]	  = isnull(cia.IdCia,-1),
        [IdFechaBaja] = isnull(baja.IdFechaBaja,-1),
		[IdFechaFinVigencia] = 	 isnull(FinVigencia.IdFechaFinVigencia,-1),
        [IdFechaInicioVigencia]=  isnull(InicioVigencia.IdFechaInicioVigencia,-1),
		[IdFechaInscripcion]= isnull(Inscripcion.IdFechaInscripcion,-1),
		[IdTer]=isnull(ter.IdTer,-1),
		[IdFechaNacimiento]	= isnull(ter.[IdFechaNacimiento],-1),
		[IdFechaRenovacion]=isnull(renovacion.IdFechaRenovacion,-1),
		[IdMoneda] = isnull(moneda.IdMoneda,-1)

FROM [ST_SAS].[dbo].[ST_master_pol] as pol
LEFT JOIN [dbo].[DimCia] as cia
	ON ISNULL(cast(pol.cdgocia as varchar(5)),'N/D')=cia.[CodigoCia]
LEFT JOIN  [dbo].[DimFechaBaja]	 as baja
	ON ISNULL(CAST(CONVERT(VARCHAR(10),pol.fechbaja, 112) as int),-1) =baja.[IdFechaBaja]
LEFT JOIN [dbo].[DimFechaFinVigencia] 	 as FinVigencia
	ON ISNULL(CAST(CONVERT(VARCHAR(10),pol.fechvenc, 112) as int),-1) =FinVigencia.[IdFechaFinVigencia]
LEFT JOIN	[dbo].[DimFechaInicioVigencia] as InicioVigencia
	ON ISNULL(CAST(CONVERT(VARCHAR(10),pol.fechinic, 112) as int),-1) =InicioVigencia.[IdFechaInicioVigencia]
LEFT JOIN	[dbo].[DimFechaInscripcion] as Inscripcion
	ON ISNULL(CAST(CONVERT(VARCHAR(10),pol.fechinsc, 112) as int),-1) =Inscripcion.[IdFechaInscripcion]
LEFT JOIN  [dbo].[DimTer]  as Ter
	ON ISNULL(CAST(pol.terceroid as VARCHAR(50)),'No Definido') =ter.IdSistemaTer 
	AND  ter.IdSistema=2
LEFT JOIN	[dbo].[DimFechaRenovacion] as Renovacion
	ON ISNULL(CAST(CONVERT(VARCHAR(10),pol.fechreno, 112) as int),-1) =Renovacion.[IdFechaRenovacion]
LEFT JOIN [dbo].[DimMoneda]	  as moneda
	ON ISNULL(CAST(pol.cdgomone as VARCHAR(50)),'No Definido')=   moneda.CodigoMoneda
LEFT JOIN  [dbo].[DimPlan] as [Plan]
	ON 	ISNULL(CAST(pol.planid as VARCHAR(50)),'No Definido')	 =	 [Plan]
	gg
--SELECT convert(varchar(10),null,112)