



SELECT [CodigoCia]=pol.[cdgocia]
      ,[DescripcionRamo]=ramo.[nombramo]
      ,[Certificado]=pol.[numecert]    
	  ,[CodigoPoliza]=pol.[id]   
      ,[Poliza]=pol.[numepoli]
      ,[EstadoPoliza]=ESTADOPOL.desccodi
	  ,[DescripcionTipoPoliza]=ISNULL(tipopol.desccodi,'NO APLICA')
      ,[DescripcionFormaDePago]=ISNULL(FormPago.desccodi,'NO APLICA')
      ,[DescripcionMotivoCancelacion] =ISNULL(BajaPol.desccodi, 'NO APLICA')
      ,[DescripcionTipoCuenta] =ISNULL(TipoCTA.desccodi,'NO APLICA')
      ,[DescripcionTipoTarjeta]= CASE LEFT (numecta,1)  
	                                    WHEN '3' THEN 'AMERICAN EXPRESS'
										WHEN '4' THEN 'VISA'
										WHEN '5' THEN 'MASTER CARD'
										WHEN '6' THEN 'DINERS CLUB'
										ELSE 'OTRAS' END
	  ,[IdSistema]=2
FROM [dbo].[master_pol] as pol
INNER JOIN [dbo].[master_cod] as tipopol
	ON pol.[id_tipopol]=tipopol.id 
	AND tipopol.sinonimo = 'TIPOPOL'
	AND tipopol.desccodi='Individual'
LEFT JOIN [dbo].[master_cod] as EstadoPol
	ON pol.[id_estado]=EstadoPol.id
	AND EstadoPol.sinonimo = 'ESTADOPOL'
LEFT JOIN [dbo].[master_cod] as FormPago
	ON pol.[id_formpago]=FormPago.id 
	AND FormPago.sinonimo = 'FORMPAGO'
LEFT JOIN [dbo].[master_cod] as BajaPol
	ON pol.[id_causbaja]=BajaPol.id 
	AND BajaPol.sinonimo = 'CAUSBAJAPOL'
LEFT JOIN [dbo].[master_cod] as TipoCTA
	ON pol.[id_tipocta]=TipoCTA.id 
	AND TipoCTA.sinonimo = 'TIPOCTA'
LEFT JOIN [dbo].[ramo] as ramo
	ON pol.[cdgoramo]=ramo.[cdgoramo]
	AND pol.[cdgocia]=ramo.[cdgocia]
UNION
SELECT 
       [CodigoCia]=pol.[cdgocia]
      ,[DescripcionRamo]=ramo.[nombramo]
      ,[Certificado]=pol.[numecert]    
	  ,[CodigoPoliza]=pol.[id]   
      ,[Poliza]=pol.[numepoli]
      ,[EstadoPoliza]=ESTADOPOL.desccodi
	  ,[DescripcionTipoPoliza]=ISNULL(tipopol.desccodi,'NO APLICA')
      ,[DescripcionFormaDePago]=ISNULL(FormPago.desccodi,'NO APLICA')
      ,[DescripcionMotivoCancelacion] =ISNULL(BajaPol.desccodi, 'NO APLICA')
      ,[DescripcionTipoCuenta] =ISNULL(TipoCTA.desccodi,'NO APLICA')
      ,[DescripcionTipoTarjeta]= CASE LEFT (numecta,1)  
	                                    WHEN '3' THEN 'AMERICAN EXPRESS'
										WHEN '4' THEN 'VISA'
										WHEN '5' THEN 'MASTER CARD'
										WHEN '6' THEN 'DINERS CLUB'
										ELSE 'OTRAS' END
	  ,[IdSistema]=2
FROM [dbo].[master_pol] as pol
INNER JOIN [dbo].[master_cod] as tipopol
	ON pol.[id_tipopol]=tipopol.id 
	AND tipopol.sinonimo = 'TIPOPOL'
	AND tipopol.desccodi='Colectiva'
LEFT JOIN [dbo].[master_cod] as EstadoPol
	ON pol.[id_estado]=EstadoPol.id
	AND EstadoPol.sinonimo = 'ESTADOPOL'
LEFT JOIN [dbo].[master_cod] as FormPago
	ON pol.[id_formpago]=FormPago.id 
	AND FormPago.sinonimo = 'FORMPAGO'
LEFT JOIN [dbo].[master_cod] as BajaPol
	ON pol.[id_causbaja]=BajaPol.id 
	AND BajaPol.sinonimo = 'CAUSBAJAPOL'
LEFT JOIN [dbo].[master_cod] as TipoCTA
	ON pol.[id_tipocta]=TipoCTA.id 
	AND TipoCTA.sinonimo = 'TIPOCTA'
LEFT JOIN [dbo].[ramo] as ramo
	ON pol.[cdgoramo]=ramo.[cdgoramo]
	AND pol.[cdgocia]=ramo.[cdgocia]
WHERE pol.[numecert] <> '0' AND pol.[numecert] is not null

