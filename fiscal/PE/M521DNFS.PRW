#Include 'Totvs.ch'
#Include 'Topconn.ch'

/*/{Protheus.doc} User Function nomeFunction
	Ponto de entrada na exclusใo do documento de saํda
	@type  Function
	@author Everson
	@since 26/03/2018
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	Everson 20/11/2018 chamado 045271. Tratamento para remover flag no banco integra็ใo Protheus x SAG para que o SAG possa reprocessar o regitro.
	Everson 14/05/2019 chamado 044314. Tratamento para estorno de frete
	@history Everson, 07/12/2022, ticket TI - removido envio de dados ao Salesforce.
	@history ticket 89880 - 27/03/2023 - Fernando Macieira - Transfer๊ncia entre Filiais
	@history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 02/06/2023 - Valida็ใo Ajuste Nova Empresa
/*/
User Function M521DNFS()

	Local aArea	:= GetArea()
    Local _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 26/05/2023	
	
	//Everson - 07/12/2022 - ticket TI.
	// If FindFunction("U_ADVEN074P") .And. cEmpAnt = "01"
	// 	If !Empty(Alltrim(cValToChar(SF2->F2_XSALES)))
	// 		U_ADVEN074P(cEmpAnt,cFilAnt,Alltrim(cValToChar(SF2->F2_DOC)) + Alltrim(cValToChar(SF2->F2_SERIE)) ,.F.,"",.T.)
	// 	EndIf
	// EndIf
	
	//Everson - 20/11/2018.
	If alltrim(cEmpAnt) $ _cEmpAt1 //ticket TI - Antonio Domingos - 02/06/2023 
		flagSag(Alltrim(cValToChar(SF2->F2_DOC)),Alltrim(cValToChar(SF2->F2_SERIE)))
		
		//Everson 14/05/2019 chamado 044314.
		If ! Empty(SF2->F2_PLACA)
			estFrt(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
		EndIf
		//
		
	EndIf
	
	// @history ticket 89880 - 27/03/2023 - Fernando Macieira - Transfer๊ncia entre Filiais
	If !Empty(SF2->F2_FILDEST) .and. !Empty(SF2->F2_FORDES) .and. !Empty(SF2->F2_LOJADES)
		DelEntrada() 
	EndIf

	RestArea(aArea)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณflagSag   บAutor  ณEverson             บ Data ณ  20/11/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTratamento para retirar marca็ใo de integra็ใo no banco     บฑฑ
ฑฑบDesc.     ณintermediแrio Protheus x SAG.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Chamado 045271.                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function flagSag(cNf,cSerie)
	
	/*
	
		************* Fun็ใo tamb้m utilizada no fonte MT100AGR ***********
	
	*/

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	Local aArea	    := GetArea()
	Local nTcProth  := 0
	Local cBdTanq   := ""
	Local cSrvTanq  := ""
	Local cPortTanq := 0
	Local nTcTanq   := 0
	Local cPedido	:= ""
	Local cPedSAg	:= ""
	Local cUpdate	:= ""
	
	//
	SET DELETED OFF
		cPedido	:= Posicione("SD2",3,xFilial("SD2") + cNf + cSerie,"D2_PEDIDO")
		cPedSAg	:= Alltrim(cValToChar(Posicione("SC5",1,xFilial("SC5") + cPedido     ,"C5_PEDSAG")))
	SET DELETED ON
	
	//
	If Empty(cPedSAg)
		RestArea(aArea)		
		Return Nil
			
	EndIf

	// //
	// nTcProth  := advConnection()
	// cBdTanq   := GetPvProfString("INTSAGBD","BCO2","ERROR",GetADV97())
	// cSrvTanq  := GetPvProfString("INTSAGBD","SRV2","ERROR",GetADV97())
	// cPortTanq := Val(GetPvProfString("INTSAGBD","PRT2","ERROR",GetADV97()))

	//
	// If (nTcTanq := TcLink(cBdTanq,cSrvTanq,cPortTanq)) < 0
	// 	Aviso("Nใo foi possํvel  conectar ao banco integra็ใo, verifique com administrador","ERROR")
	// 	RestArea(aArea)		
	// 	Return Nil
		
	// EndIf
	
	//
	//TcSetConn(nTcTanq)
	
	cUpdate := "UPDATE SGPED010 SET STATUS_INT='', STATUS_PRC = '', MENSAGEM_INT = '' WHERE C5_FILIAL ='" + cFilAnt + "' AND C5_NUM='" + cPedSAg + "' "
	If TcSqlExec(cUpdate) < 0
		MsgAlert("Ocorreu erro na atualiza็ใo do registro no banco integra็ใo Protheus x SAG. " + Chr(13) + Chr(10) + TCSQLError(),"Fun็ใo flagSag (M521DNFS)")
	
	EndIf
	
	//
	//TcSetConn(nTcProth)
	
	//
	RestArea(aArea)
	
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณestFrt    บAutor  ณEverson             บ Data ณ  14/05/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEstorna lan็amento de frete.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Chamado 044314.                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function estFrt(F2DOC,F2SERIE,F2CLIENTE,F2LOJA)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	Local aArea	    := GetArea()
	Local cPedido	:= ""
	
	//
	SET DELETED OFF
		cPedido	:= Posicione("SD2",3,xFilial("SD2") + F2DOC + F2SERIE,"D2_PEDIDO")
	SET DELETED ON
	
	//
	DbSelectArea("ZBE")
	RecLock("ZBE",.T.)
		Replace ZBE_FILIAL 	   	With xFilial("ZBE")
		Replace ZBE_DATA 	   	With dDataBase
		Replace ZBE_HORA 	   	With Time()
		Replace ZBE_USUARI	    With Upper(Alltrim(cUserName))
		Replace ZBE_LOG	        With "Estorno de frete"
		Replace ZBE_PARAME      With "Filial/Empresa/NF/Serie/Cliente/Loja/Pedido " + cValToChar(cEmpAnt) + " " + cValToChar(cFilAnt) + " " + cValToChar(F2DOC) + " " + cValToChar(F2SERIE) + " " + cValToChar(F2CLIENTE) + " " + cValToChar(F2LOJA) + " " + cValToChar(cPedido)
		Replace ZBE_MODULO	    With "LOGISTICA"
		Replace ZBE_ROTINA	    With "M521DNFS" 
	MsUnlock()
	
	//
	If ! Empty(cPedido)
		U_ADLOG042P( cEmpAnt , cFilAnt , F2DOC , F2SERIE , F2CLIENTE , F2LOJA  , cPedido , "3" )
	
	EndIf
	
	//
	RestArea(aArea)
	
Return Nil

/*/{Protheus.doc} u_21DNFSA0
Ticket 70142 - Substituicao de funcao Static Call por User Function MP 12.1.33
@type function
@version 1.0
@author Edvar   / Flek Solution
@since 16/03/2022
@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
/*/
Function u_21DNFSA0( uPar1, uPar2 )
Return( flagSag( uPar1, uPar2 )  )


/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author FWNM
	@since 27/03/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 89880 - 27/03/2023 - Fernando Macieira - Transfer๊ncia entre Filiais
/*/
Static Function DelEntrada()

	Local aCabec   := {}
	Local aItens   := {}
	Local aLinha   := {}
	Local lClassif := .T.
	Local cBkpFil  := cFilAnt

	cFilAnt := SF2->F2_FILDEST
	
	Aadd(aCabec,{"F1_FILIAL" 	, FWxFilial("SF1")	, Nil})
	Aadd(aCabec,{"F1_TIPO"   	, SF2->F2_TIPO		, Nil})
	Aadd(aCabec,{"F1_FORMUL" 	, SF2->F2_FORMDES   , Nil})
	Aadd(aCabec,{"F1_DOC"    	, SF2->F2_DOC		, Nil})
	Aadd(aCabec,{"F1_SERIE"  	, SF2->F2_SERIE		, Nil})
	Aadd(aCabec,{"F1_EMISSAO"	, SF2->F2_EMISSAO	, Nil})
	Aadd(aCabec,{"F1_FORNECE"	, SF2->F2_FORDES	, Nil})
	Aadd(aCabec,{"F1_LOJA"   	, SF2->F2_LOJADES 	, Nil})
	Aadd(aCabec,{"F1_ESPECIE"	, SF2->F2_ESPECIE	, Nil})

	SD1->( dbSetOrder(1) )
	If SD1->( dbSeek(FWxFilial("SD1")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_FORDES+SF2->F2_LOJADES) )

		Do While SD1->( !EOF() ) .and. SD1->D1_FILIAL==FWxFilial("SD1") .and. SD1->D1_DOC==SF2->F2_DOC .and. SD1->D1_SERIE==SF2->F2_SERIE .and. SD1->D1_FORNECE=SF2->F2_FORDES .and. SD1->D1_LOJA=SF2->F2_LOJADES

			If Empty(SD1->D1_TES)
				lClassif := .F.
			EndIf

			aadd(aItens,{"D1_FILIAL"	,SD1->D1_FILIAL		, Nil})
			aadd(aItens,{"D1_ITEM"		,SD1->D1_ITEM		, Nil})
			aadd(aItens,{"D1_COD"		,SD1->D1_COD		, Nil})
			aadd(aItens,{"D1_UM"		,SD1->D1_UM			, Nil})
			aadd(aItens,{"D1_QUANT"		,SD1->D1_QUANT		, Nil})
			aadd(aItens,{"D1_VUNIT"		,SD1->D1_VUNIT		, Nil})
			aadd(aItens,{"D1_TOTAL"		,SD1->D1_TOTAL		, Nil})
			aadd(aItens,{"D1_CF"		,SD1->D1_CF			, Nil})
			aadd(aItens,{"D1_DESC"		,SD1->D1_DESC		, Nil})
			aadd(aItens,{"D1_FORNECE"	,SD1->D1_FORNECE	, Nil})
			aadd(aItens,{"D1_LOJA"		,SD1->D1_LOJA		, Nil})
			aadd(aItens,{"D1_LOCAL"		,SD1->D1_LOCAL		, Nil})
			aadd(aItens,{"D1_DOC"		,SD1->D1_DOC		, Nil})
			aadd(aItens,{"D1_EMISSAO"	,SD1->D1_EMISSAO	, Nil})
			aadd(aItens,{"D1_DTDIGIT"	,SD1->D1_DTDIGIT	, Nil})
			aadd(aItens,{"D1_TIPO"		,SD1->D1_TIPO		, Nil})
			aadd(aItens,{"D1_SERIE"		,SD1->D1_SERIE		, Nil})
			aadd(aItens,{"D1_TP"		,SD1->D1_TP			, Nil})
			aadd(aItens,{"D1_TES"		,SD1->D1_TES		, Nil})
			aAdd(aLinha,aItens)

			SD1->( dbSkip() )
		
		EndDo

		lMsErroAuto := .f.
		
		If lClassif
        	msExecAuto({|x, y, z  | MATA103(x,y,z)    }, aCabec, aLinha, 5)
        Else                    
			msExecAuto({|x,y,z,a,b| MATA140(x,y,z,a,b)}, aCabec, aLinha, 5,,)
		EndIf

		If lMsErroAuto
			MostraErro()
		Else
			msgInfo("Nota Fiscal de entrada excluํda com sucesso! Verifique...")
		Endif

	EndIf

	cFilAnt := cBkpFil

Return
