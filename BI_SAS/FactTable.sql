/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [IdCia]	  = cia.IdCia,
        [IdFechaBaja] = baja.IdFechaBaja,
		[IdFechaFinVigencia] = 	 FinVigencia.IdFechaFinVigencia,
        [IdFechaInicioVigencia]=  InicioVigencia.IdFechaInicioVigencia,
		[IdFechaInscripcion]= Inscripcion.IdFechaInscripcion,

		   *
FROM [ST_SAS].[dbo].[ST_master_pol] as pol
LEFT JOIN [dbo].[DimCia] as cia
	ON isnull(cast(pol.cdgocia as varchar(5)),-1)=cia.[CodigoCia]
LEFT JOIN  [dbo].[DimFechaBaja]	 as baja
	ON 	 ISNULL(CAST(CONVERT(VARCHAR(10),pol.fechbaja, 112) as int),-1) =baja.[IdFechaBaja]
LEFT JOIN [dbo].[DimFechaFinVigencia] 	 as FinVigencia
	ON 	 ISNULL(CAST(CONVERT(VARCHAR(10),pol.fechvenc, 112) as int),-1) =FinVigencia.[IdFechaFinVigencia]
LEFT JOIN	[dbo].[DimFechaInicioVigencia] as InicioVigencia
	ON 	 ISNULL(CAST(CONVERT(VARCHAR(10),pol.fechinic, 112) as int),-1) =InicioVigencia.[IdFechaInicioVigencia]
LEFT JOIN	[dbo].[DimFechaInscripcion] as Inscripcion
	ON 	 ISNULL(CAST(CONVERT(VARCHAR(10),pol.fechinsc, 112) as int),-1) =Inscripcion.[IdFechaInscripcion]
LEFT JOIN 
LEFT JOIN	[dbo].[DimFechaNacimiento] as Nacimiento
	ON 	 ISNULL(CAST(CONVERT(VARCHAR(10),pol.f, 112) as int),-1) =Inscripcion.[IdFechaInscripcion]


--SELECT convert(varchar(10),null,112)