#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} User Function MTA140MNU
	Faz validacao referente usuarios que poder�o incluir alterar e excluir na pr�-nota de entrada.
	@type  Function
	@author EVERALDO CASAROLI
	@since 07/07/2008
	@version 01
	@history chamado 044314 - Everson       - 05/08/2019 - Tratamento para Inclus�o de CT-e por Job.
	@history chamado 999    - William Costa - 10/09/2020 - Retirado o If da empresa 01 e filial 02, pois para as outras empresas e filiais estava aparecendo o bot�o de incluir e alterar onde n�o pode.
	@history Chamado 1860   - Everson       - 18/09/2020 - Tratamento para inclus�o autom�tica de CT-e na empresa 07.
	@history Chamado 8566 	- Andr� Mendes 	- 29/04/2021 - Transfer�ncia entre Filiais
	@history Chamado 75965  - Everson 		- 12/07/2022 - Adicionado MV MV_XUSER2.
	@history ticket TI    - Everson - 30/11/2022 - Inclus�o de CT-e pela Ceres.
/*/

USER FUNCTION MTA140MNU()

	Local _aArea	:= {}

   // ticket 84085 - 01/12/2022 - Fernando Macieira - TRANSFERENCIA DE ATIVO IMOBILIZADO nota fiscal n�o aparece no Faturamento
	If AllTrim(FUNNAME())=="ATFA060" .or. IsInCallStack("ATFA060")
		Return
	EndIf

	_aArea	:= GetArea()

	IF (!alltrim(__CUSERID) $ GETMV("MV_XUSER",,"") .And. !alltrim(__CUSERID) $ GETMV("MV_XUSER2",,""))  .And. ! IsInCallStack("U_ADFIS032P") .And.; //Everson - 05/08/2019. Chamado 044314. //Everson - 12/07/2022. Chamado 75965.
		! IsInCallStack("U_ADFIS039P") .And. ! IsInCallStack("U_ADFIS040P") ;//Chamado 1860   - Everson       - 18/09/2020
		.And. ! IsInCallStack("MATA310") .And. !IsInCallStack("U_ADFIS042P")//Chamado 8566 	- Andr� Mendes 	- 29/04/2021 - Transfer�ncia entre Filiais //Everson - 30/11/2022 - ticket TI.
		aRotina		:= {}
		aAdd(aRotina,{"Pesquisar", "AxPesqui"   , 0 , 1, 0, .F.}) 	//"Pesquisar"
		aAdd(aRotina,{"Visualizar", "A140NFiscal", 0 , 2, 0, .F.}) //"Visualizar"  
		aAdd(aRotina,{ "Imprimir"	,"A140Impri"  	, 0 , 4, 0, .F.})//"Imprimir"
		aAdd(aRotina,{"Legenda", "A103Legenda", 0 , 2, 0, .F.})		//"Legenda"
	
	ELSE //ADICIONAR ESSA ROTINA DE REFATURAMENTO, PARA ENVIO DE EMAIL WILLIAM COSTA - TI 11/11/2014 
	
		aAdd(aRotina,{"REFATURAMENTO", "U_ADCOM004P"   , 0 , 1, 0, .F.}) 		//"REFATURAMENTO"
		
	ENDIF         
	
	RestArea( _aArea )

RETURN()
