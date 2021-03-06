USE [DW_SAS]
GO
/****** Object:  Table [dbo].[DimCia]    Script Date: 3/18/2014 3:58:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCia](
	[IdCia] [int] NOT NULL,
	[NombreCia] [nchar](10) NULL,
 CONSTRAINT [PK_DimCia] PRIMARY KEY CLUSTERED 
(
	[IdCia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DimFechaBaja]    Script Date: 3/18/2014 3:58:21 PM ******/
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
 CONSTRAINT [PK_DimFechaBaja] PRIMARY KEY CLUSTERED 
(
	[IdFechaBaja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaFinVigencia]    Script Date: 3/18/2014 3:58:21 PM ******/
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
 CONSTRAINT [PK_DimFechaFinVigencia] PRIMARY KEY CLUSTERED 
(
	[IdFechaFinVigencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaInicioVigencia]    Script Date: 3/18/2014 3:58:21 PM ******/
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
 CONSTRAINT [PK_DimFechaInicioVigencia] PRIMARY KEY CLUSTERED 
(
	[IdFechaInicioVigencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaInscripcion]    Script Date: 3/18/2014 3:58:21 PM ******/
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
 CONSTRAINT [PK_DimFechaInscripcion] PRIMARY KEY CLUSTERED 
(
	[IdFechaInscripcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaNacimiento]    Script Date: 3/18/2014 3:58:21 PM ******/
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
 CONSTRAINT [PK_DimFechaNacimiento] PRIMARY KEY CLUSTERED 
(
	[IdFechaNacimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimFechaRenovacion]    Script Date: 3/18/2014 3:58:21 PM ******/
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
 CONSTRAINT [PK_DimFechaRenovacion] PRIMARY KEY CLUSTERED 
(
	[IdFechaRenovacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimMoneda]    Script Date: 3/18/2014 3:58:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimMoneda](
	[IdMoneda] [int] NOT NULL,
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
/****** Object:  Table [dbo].[DimPais]    Script Date: 3/18/2014 3:58:21 PM ******/
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
/****** Object:  Table [dbo].[DimPlan]    Script Date: 3/18/2014 3:58:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimPlan](
	[IdPlan] [int] NOT NULL,
	[CodigoRamo] [varchar](50) NULL,
	[DescripcionRamo] [varchar](50) NULL,
	[CodigoProducto] [varchar](50) NULL,
	[DescripcionProducto] [varchar](50) NULL,
	[CodigoPlan] [varchar](50) NULL,
	[DescripcionPlan] [varchar](50) NULL,
 CONSTRAINT [PK_DimPlan] PRIMARY KEY CLUSTERED 
(
	[IdPlan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimPoliza]    Script Date: 3/18/2014 3:58:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimPoliza](
	[IdPoliza] [bigint] NOT NULL,
	[IdPolizaPadre] [bigint] NULL,
	[Certificado] [varchar](50) NULL,
	[Poliza] [varchar](50) NULL,
	[EstadoPoliza] [varchar](50) NULL,
	[DescripcionFormaDePago] [varchar](100) NULL,
 CONSTRAINT [PK_DimPoliza] PRIMARY KEY CLUSTERED 
(
	[IdPoliza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimPolizaPadre]    Script Date: 3/18/2014 3:58:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimPolizaPadre](
	[IdPolizaPadre] [bigint] NOT NULL,
	[Certificado] [varchar](50) NULL,
	[Poliza] [varchar](50) NULL,
	[EstadoPoliza] [varchar](50) NULL,
	[DescripcionFormaDePago] [varchar](100) NULL,
 CONSTRAINT [PK_DimPolizaPadre] PRIMARY KEY CLUSTERED 
(
	[IdPolizaPadre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimSucursal]    Script Date: 3/18/2014 3:58:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimSucursal](
	[IdSucursal] [int] NOT NULL,
	[CodigoSucursal] [varchar](50) NULL,
	[NombreSucursal] [varchar](50) NOT NULL,
	[IdUbicacionGeograficaSucursal] [int] NULL,
 CONSTRAINT [PK_DimSucursal] PRIMARY KEY CLUSTERED 
(
	[IdSucursal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimTer]    Script Date: 3/18/2014 3:58:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimTer](
	[IdTer] [bigint] NOT NULL,
	[IdSistemaTer] [varchar](50) NULL,
	[TipoDocumento] [varchar](50) NULL,
	[NumeroDocumento] [varchar](50) NULL,
	[NombreBase1] [varchar](50) NULL,
	[NombreBase2] [varchar](50) NULL,
	[Apellido1] [varchar](50) NULL,
	[Apellido2] [varchar](50) NULL,
	[ApellidoCasada] [varchar](50) NULL,
	[CodigoSexo] [varchar](50) NULL,
	[DescripcionSexo] [varchar](50) NULL,
	[CodigoEstadoCivil] [varchar](50) NULL,
	[DescripcionEstadoCivil] [varchar](50) NULL,
	[IdSistema] [smallint] NULL,
 CONSTRAINT [PK_DimTer] PRIMARY KEY CLUSTERED 
(
	[IdTer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimUbicacionGeograficaCliente]    Script Date: 3/18/2014 3:58:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimUbicacionGeograficaCliente](
	[IdUbicacionGeograficaCliente] [int] NOT NULL,
	[IdPais] [int] NULL,
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
/****** Object:  Table [dbo].[DimUbicacionGeograficaSucursal]    Script Date: 3/18/2014 3:58:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimUbicacionGeograficaSucursal](
	[IdUbicacionGeograficaSucursal] [int] NOT NULL,
	[IdPais] [int] NULL,
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
/****** Object:  Table [dbo].[FactPoliza]    Script Date: 3/18/2014 3:58:21 PM ******/
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
