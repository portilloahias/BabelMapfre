



SELECT    *
FROM [dbo].[master_pol] as pol
INNER JOIN [dbo].[master_cod] as codTip
	ON pol.[id_tipopol]=codTip.id 
	AND codTip.sinonimo = 'TIPOPOL'
	AND codTip.desccodi='Individual'
LEFT JOIN [dbo].[master_cod] as codForPa
	ON pol.[id_formpago]=codTip.id 
	AND codTip.sinonimo = 'FORMPAGO'
LEFT JOIN [dbo].[master_cod] as codCTA
	ON pol.[id_tipocta]=codCTA.id 
	AND codCTA.sinonimo = 'TIPOCTA'




SELECT *
FROM  [dbo].[master_cod]
where sinonimo like '%TIPOCTA%'

select *
from [dbo].[master_pol]
where numecta is not null


select *
FROM  [dbo].[master_cod]
where sinonimo like '%pag%'


 

SELECT   distinct [numecert]
         ,[parentid]
FROM [dbo].[master_pol]
WHERE [parentid] is  not null
order by [parentid] desc


SELECT [id]
      ,[cdgocia]
      ,[cdgoramo]
      ,[numepoli]
      ,[id_tipopol]
      ,[numecert]
      ,[parentid]
      ,[terceroid]
      ,[grupo_id]
      ,[id_estado]
      ,[fechinsc]
      ,[fechorig]
      ,[fechbaja]
      ,[id_causbaja]
      ,[fechinic]
      ,[fechvenc]
      ,[fechreno]
      ,[planid]
      ,[cdgomone]
      ,[sumaaseg]
      ,[sumafact]
      ,[id_formpago]
      ,[prmaaseg]
      ,[id_tipotasa]
      ,[tasaaseg]
      ,[id_tipocta]
      ,[numecta]
      ,[fechvctocta]
      ,[titularcta]
      ,[initialid]
      ,[cdgosucu]
      ,[ejecutivo]
      ,[fechultm]
      ,[userultm]
      ,[cdgoprod]
  FROM [dbo].[master_pol]
GO


