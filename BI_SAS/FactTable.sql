
SELECT  [IdCia]	  = isnull(cia.IdCia,-1),
        [IdFechaBaja] = isnull(baja.IdFechaBaja,-1),
		[IdFechaFinVigencia] = 	 isnull(FinVigencia.IdFechaFinVigencia,-1),
        [IdFechaInicioVigencia]=  isnull(InicioVigencia.IdFechaInicioVigencia,-1),
		[IdFechaInscripcion]= isnull(Inscripcion.IdFechaInscripcion,-1),
		[IdFechaNacimiento]	= isnull(ter.[IdFechaNacimiento],-1),
		[IdFechaRenovacion]=isnull(renovacion.IdFechaRenovacion,-1),
		[IdMoneda] = isnull(moneda.IdMoneda,-1),
		[IdPlan]=isnull([Plan].IdPlan ,-1),
		[IdPoliza]=isnull(Dpol.[IdPoliza],-1),
		[IdSocio]= isnull(soc.[IdSocio],-1),
		[IdSucursal]= isnull(suc.[IdSucursal],-1),
		[IdTer]=isnull(ter.IdTer,-1),
		[IdUbicacionGeograficaCliente]=-1,
		[IdUbicacionGeograficaSucursal]= isnull(UbiSuc.[IdUbicacionGeograficaSucursal],-1),
		[IdUsuario] = isnull(usr.[IdUsuario], -1),
		[MontoSumaAseguradaDolares]=isnull(pol.sumaaseg,0) * isnull(factor.[factor],0),
		[MontoSumaFacturadaDolares]=isnull(pol.sumafact,0) * isnull(factor.[factor],0),
		[MontoPrimaAseguradaDolares]=isnull(pol.prmaaseg,0) * isnull(factor.[factor],0),
		[MontoSumaAsegurada]=isnull(pol.sumaaseg,0),
		[MontoSumaFacturada]=isnull(pol.sumafact,0),
		[MontoPrimaAsegurada]=isnull(pol.prmaaseg,0),
		[TasaDeCambio]=isnull(factor.[factor],0)										
FROM [ST_SAS].[dbo].[ST_master_pol] as pol
INNER JOIN [dbo].[DimPoliza] as Dpol
	ON cast(pol.cdgocia as varchar(5)) =Dpol.[CodigoCia]
	AND cast(pol.id as varchar(150)) =Dpol.CodigoPoliza
	AND Dpol.IdSistema=2
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
	ON ISNULL(CAST(pol.cdgomone as VARCHAR(50)),'No Definido')=moneda.CodigoMoneda
LEFT JOIN  [dbo].[DimPlan] as [Plan]
	ON 	ISNULL(CAST(pol.planid as VARCHAR(50)),'No Definido')=[Plan].CodigoPlan	
LEFT JOIN [dbo].[DimSocio] AS soc
	ON cast(pol.[initialid] as varchar(150)) = soc.[CodigoSocio]
LEFT JOIN  [dbo].[DimSucursal]	as suc
	ON cast(pol.cdgosucu as varchar(150))= suc.[CodigoSucursal] 
	AND	   cast(pol.cdgocia as varchar(150))= suc.CodigoCia
	AND cast(pol.initialid as varchar(150))= suc.CodigoSocio  
LEFT JOIN [dbo].[DimUsuarios] as usu
	ON 	pol.ejecutivo  = usu.CodigoUsuario
LEFT JOIN  [dbo].[DimUbicacionGeograficaSucursal] UbiSuc
	ON suc.[CodigoUbicacionGeografica]=UbiSuc.[CodigoUbicacionGeografica]
LEFT JOIN [dbo].[DimUsuarios] as usr
	ON 	pol.ejecutivo=usr.CodigoUsuario
LEFT JOIN 	[ST_SAS].[dbo].[ST_moneda_fac]   as factor
	ON pol.cdgocia=factor.[cdgocia]
	AND pol.cdgomone=factor.[cdgomone] 
	AND  pol.fechinsc	 between  [fechdesde] and isnull([fechhasta], GETDATE())
