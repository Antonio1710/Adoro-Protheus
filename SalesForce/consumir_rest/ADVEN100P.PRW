#Include "Protheus.ch"
#Include 'Topconn.ch'
/*/{Protheus.doc} User Function ADVEN100P
	(Chamado 044154 - Job para envio de status de clientes ao Salesforce)
	@type  Function
	@author Everson
	@since 05/11/2018
	@version 1.0
	@history 21/07/2020, Leon, Comentar LockByName para contornar falta de execu��o de rotinas de agendamento;
	@history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	/*/
User Function ADVEN100P()  // U_ADVEN100P()
	//Declara��o de vari�vies
	Local cEmp 		:= "01"
	Local cFil 		:= "02"
	
	//Inicia o ambiente.
	RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv(cEmp,cFil,,,,GetEnvServer(),{ })

	// Garanto uma �nica thread sendo executada - // Adoro - Chamado n. 050729 || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE - fwnm - 30/06/2020
	// If !LockByName("ADVEN100P", .T., .F.)
	// 	ConOut("[ADVEN100P] - Existe outro processamento sendo executado! Verifique...")
	// 	RPCClearEnv()
	// 	Return
	// EndIf

	// @history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	//FWMonitorMsg(ALLTRIM(PROCNAME()))
	
	conout("CHSTATUS In�cio envio status de clientes SalesForce")
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Job para envio de status de clientes ao Salesforce')
	logZBN("1") //Log in�cio.
	
	processar()
	
	logZBN("2") //Log fim.
	conout("CHSTATUS Fim envio status de clientes SalesForce")
	
	//Destrava a rotina para o usu�rio
	// UnLockByName("ADVEN100P")

	//Fecha o ambiente.
	RpcClearEnv()
Return Nil

/*/{Protheus.doc} processar
	(Chamado 044154 - Processamento)
	@type  Static Function
	@author Everson
	@since 05/11/2018
	@version 1.0
	/*/
Static Function processar()
	//Declaracao de Variaveis
	Local aArea		:= GetArea()
	Local cServTab  := Nil
	Local oParseJSON:= Nil
	Local aParse	:= {}
	Local lRetSF	:= .F.
	Local i			:= 1
	Local x			:= 1
	Local nTotCliSF	:= 0
	Local aClientes	:= {}
	Local lDone		:= .F.
	Local nAux		:= 1
	Local cExpSql	:= ""
	
	//
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	
	//
	While ! lDone .Or. nAux > 10
		oParseJSON := Nil
		If ! acessaSF(@oParseJSON,@lRetSF,cServTab)
			RestArea(aArea)
			Return Nil
		EndIf
		
		Conout("CHSTATUS Chamada " + cValToChar(nAux) + " - Qtd. Reg: " + cValToChar(Len(oParseJSON:records)) + " done: " + cValToChar(oParseJSON:done) )
		nAux++
		lDone := oParseJSON:done
		If ! lDone
			cServTab := Alltrim(cValToChar(oParseJSON:nextRecordsUrl))
			Conout("CHSTATUS Pr�xima Url: " + cServTab )
		EndIf
		
		//
		If ValType(oParseJSON) == "O"
			Aadd(aParse,oParseJSON)
		EndIf
	End
	
	//
	Conout("CHSTATUS Tamanho array aParse: " + cValToChar(Len(aParse)) )
	
	//
	For x := 1 To Len(aParse)
		
		//
		oParseJSON := aParse[x]
		nTotCliSF := Len(oParseJSON:records)
		Conout("CHSTATUS Total clientes Salesforce " + cValToChar(nTotCliSF))
		For i := 1 To Len(oParseJSON:records)
			If SA1->(DbSeek( xFilial("SA1") + Alltrim(cValToChar(oParseJSON:records[i]:Codigo_SA1__c)) + Alltrim(cValToChar(oParseJSON:records[i]:Loja_SA1__c)) ))
				If (Alltrim(cValToChar(DecodeUTF8(oParseJSON:records[i]:Status__c))) = 'Aprovado' .And. Alltrim(cValToChar(SA1->A1_MSBLQL)) <> '2') .Or.;
				    (Alltrim(cValToChar(DecodeUTF8(oParseJSON:records[i]:Status__c))) = 'Bloqueado Financeiro' .And. Alltrim(cValToChar(SA1->A1_MSBLQL)) <> '1')
					Aadd(aClientes,{Alltrim(cValToChar(oParseJSON:records[i]:Codigo_SA1__c)),Alltrim(cValToChar(oParseJSON:records[i]:Loja_SA1__c))})
					Conout("CHSTATUS Cliente para reenvio " + Alltrim(cValToChar(oParseJSON:records[i]:Codigo_SA1__c)) + Alltrim(cValToChar(oParseJSON:records[i]:Loja_SA1__c)) )
				EndIf
			Else
				Conout("CHSTATUS Cliente n�o encontrado " + Alltrim(cValToChar(oParseJSON:records[i]:Codigo_SA1__c)) + Alltrim(cValToChar(oParseJSON:records[i]:Loja_SA1__c)) )
			EndIf
			
			Conout("CHSTATUS Total de clientes processados: " + cValToChar(i) + "/" + cValToChar(nTotCliSF) )
		Next i
	Next x
	
	//
	Conout("CHSTATUS Total de status de clientes a serem reenviados " + cValToChar(Len(aClientes)))
	
	//
	For i := 1 To Len(aClientes)
		Conout("CHSTATUS reenviando status cliente " +  cValToChar(aClientes[i][1]) + cValToChar(aClientes[i][2]) )
		U_ADVEN076P(cValToChar(aClientes[i][1]) + cValToChar(aClientes[i][2]),cValToChar(aClientes[i][1]) + cValToChar(aClientes[i][2]),.T.,"","BLQFN",.F.,"")
	Next i
	
	//
	RestArea(aArea)
Return Nil

/*/{Protheus.doc} acessaSF
	(Chamado 044154 - Rotina para obter dados no SalesForce)
	@type  Static Function
	@author Everson
	@since 05/11/2018
	@version 1.0
	/*/
Static Function acessaSF(oParseJSON,lRetSF,cServTab)
	//Declaracao de Variaveis
	Local aArea			:= GetArea()
	Local aResponse		:= {}
	Local cMsg			:= ""
	Local lLogin		:= .F.
	Local lAut			:= .F.
	Local cqueryPVSF	:= ""
	
	//
	If cServTab = Nil
		cqueryPVSF := "SELECT+Codigo_SA1__c,+Loja_SA1__c,+Status__c+FROM+Account+WHERE+Codigo_SA1__c+<>+''+AND+IsDeleted+=+false"
	EndIf
	
	Default cServTab	:= "/services/data/v41.0/query?q="

	//Efetura login no SalesForce.
	//lLogin := Static Call(ADVEN075P,loginSF,@aResponse,@cMsg,lAut)
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
    lLogin := u_VEN075A1(@aResponse,@cMsg,lAut)

	//
	If ! lLogin
		Conout("CHSTATUS N�o foi poss�vel efetuar login no SalesForce.")
		RestArea(aArea)
		lRetSF := .F.
		Return lRetSF
	EndIf
	
	//
	If ! U_ADVEN075P(cServTab + cqueryPVSF,"GET","",@cMsg,aResponse)
		cMsg :=  Alltrim(cValToChar(cMsg))
		Conout("CHSTATUS Ocorreu erro na consulta no SalesForce:" + Chr(13) + Chr(10) + cMsg)
		RestArea(aArea)
		lRetSF := .F.
		Return lRetSF
	EndIf
	
	//
	If ! FWJsonDeserialize(cMsg, @oParseJSON)
		cMsg := "Ocorreu erro na desserializa��o do json com os dados de login (Fun��o acessaSF - ADVEN097P)." + Chr(13) + Chr(10) + "Json: " + Chr(13) + Chr(10) + cMsg
		Conout("CHSTATUS Consulta SalesForce - acessaSF - ADVEN097P" + cValToChar(cMsg))
		RestArea(aArea)
		lRetSF := .F.
		Return lRetSF
	EndIf

	//
	RestArea(aArea)
	
	//
	lRetSF := .T.
Return lRetSF

/*/{Protheus.doc} logZBN
	(Chamado 044154 - Gera log na ZBN)
	@type  Static Function
	@author Everson
	@since 05/11/2018
	@version 1.0
	/*/
Static Function logZBN(cStatus)
	//Declara��o de vari�vies
	Local aArea	:= GetArea()

	DbSelectArea("ZBN")
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop())
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADVEN100P'))
		RecLock("ZBN",.F.)
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_DATA    := Date()
			ZBN_HORA    := cValToChar(Time())
			ZBN_ROTINA	:= 'ADVEN100P'
			ZBN_STATUS	:= cStatus
		MsUnlock() 
	Else
		RecLock("ZBN",.T.)
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_DATA    := Date()
			ZBN_HORA    := cValToChar(Time())
			ZBN_ROTINA	:= 'ADVEN100P'
			ZBN_STATUS	:= cStatus
		MsUnlock() 	
	EndIf

	ZBN->(dbCloseArea())

	RestArea(aArea)
Return Nil
