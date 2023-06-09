#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
#Include 'AP5mail.ch'

/*/{Protheus.doc} User Function ADVEN101P
	(Chamado 037261 - Job para solicita��o de pedido com erro de integra��o ao Salesforce)
	@type  Function
	@author Everson
	@since 22/11/2018
	@version 1.0
	@history 21/07/2020, Leon, Comentar LockByName para contornar falta de execu��o de rotinas de agendamento;
	@history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	/*/
User Function ADVEN101P() //U_ADVEN101P()
	//Declara��o de vari�vies
	Local cEmp 		:= "01"
	Local cFil 		:= "02"
	
	//Inicia o ambiente.
	RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv(cEmp,cFil,,,,GetEnvServer(),{ })
		
	// Garanto uma �nica thread sendo executada - // Adoro - Chamado n. 050729 || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE - fwnm - 30/06/2020
	// If !LockByName("ADVEN101P", .T., .F.)
	// 	ConOut("[ADVEN101P] - Existe outro processamento sendo executado! Verifique...")
	// 	RPCClearEnv()
	// 	Return
	// EndIf

	// @history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	//FWMonitorMsg(ALLTRIM(PROCNAME()))

	conout("ADVEN101P - In�cio solicita��o de erro de integra��o Salesforce")
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Job para solicita��o de pedido com erro de integra��o ao Salesforce.')
	logZBN("1") //Log in�cio.
	
	processar()
	
	logZBN("2") //Log fim.
	conout("ADVEN101P - Fim solicita��o de erro de integra��o Salesforce")

	//Destrava a rotina para o usu�rio
	// UnLockByName("ADVEN101P")

	//Fecha o ambiente.
	RpcClearEnv()
Return Nil

/*/{Protheus.doc} processar
	(Chamado 037261 - Processa os registros)
	@type  Static Function
	@author Everson
	@since 10/05/2018
	@version 1.0
	/*/
Static Function processar()
	//Declara��o de vari�vies
	Local aArea		:= GetArea()
	Local oPJsonPV	:= Nil
	Local lRetPV	:= .F.
	Local aDadosPV	:= {}
	Local oPJsonBV	:= Nil
	Local lRetBV	:= .F.
	Local cQuery	:= ""
	Local cPedProth	:= ""
	Local nPosSF	:= 0
	Local aDadosSF	:= {}
	Local cJson		:= ""
	Local lErro		:= .F.
	Local i			:= 1
	
	//
	MV_PAR01 := Date() + 1
	MV_PAR02 := Date() + 5
	
	//Obt�m pedidos com bandeira vermelha.
	Conout("ADVEN101P - Solicita��o de bandeira vermelha ao Salesforce acessaSF")
	//If Static Call(ADVEN097P,acessaSF,@oPJsonBV,@lRetBV,2,.T.) //Obt�m pedidos Salesforce com bandeira vermelha.
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	If u_VEN097A0( @oPJsonBV,@lRetBV,2,.T. )//Obt�m pedidos Salesforce com bandeira vermelha.
		For i := 1 To Len(oPJsonBV:records)			
			Aadd(aDadosPV,oPJsonBV:records[i]:Id)
		Next i
		
		//Envia solicita��o ao Salesforce.
		If Len(aDadosPV) > 0
			Conout("ADVEN101P - Envio de solicita��o de bandeira vermelha ao Salesforce")
			VarInfo("",aDadosPV)
			cJson := FWJsonSerialize(aDadosPV,.F.,.F.)
			//Static Call(ADVEN097P,envSolic,cJson)
			//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
			u_VEN097A1(cJson)
		Else	
			Conout("ADVEN101P - N�o h� pedidos com bandeira vermelha Salesforce")
		EndIf
		
	Else
		Conout("ADVEN101P - N�o foi poss�vel obter os registros de pedidos com bandeira vermelha no Salesforce")
	EndIF
	
	//Obt�m Ids pedidos pedidos Salesforce.
	Conout("ADVEN101P - Solicita��o de pedidos ao Salesforce acessaSF")
	aDadosPV := {}
	//If Static Call(ADVEN097P,acessaSF,@oPJsonPV,@lRetPV,1,.T.) //Obt�m pedidos Salesforce.
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	If u_VEN097A0(@oPJsonPV,@lRetPV,1,.T.) //Obt�m pedidos Salesforce.
		For i := 1 To Len(oPJsonPV:records)
			If ! (Empty(Alltrim(cValToChar(oPJsonPV:records[i]:Codigo_Protheus__c)))) .Or.;
			   ( Empty(Alltrim(cValToChar(oPJsonPV:records[i]:Codigo_Protheus__c))) .And. Upper(Alltrim(cValToChar(DecodeUTF8(oPJsonPV:records[i]:Status)))) <> "CANCELADO" .And. Upper(Alltrim(cValToChar(DecodeUTF8(oPJsonPV:records[i]:Status)))) <> "COTA��O" )
				Aadd(aDadosSF,{;
							"",;
							oPJsonPV:records[i]:Codigo_Protheus__c,;
							oPJsonPV:records[i]:OrderNumber,;
							StrTran(cValToChar(oPJsonPV:records[i]:Data__c),"-",""),;
							DecodeUTF8(oPJsonPV:records[i]:Status),;
							oPJsonPV:records[i]:Codigo_Cliente__c,;
							oPJsonPV:records[i]:Rede__c,;
							oPJsonPV:records[i]:Volume_total_de_Caixas__c,;
							oPJsonPV:records[i]:TotalAmount,;
							oPJsonPV:records[i]:Id;
						})
			EndIf
		Next i
		
		//
		//cQuery := Static Call(ADVEN097P,sqlSC5)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		cQuery := u_VEN097A2()
		If Select("DADOS_SC5") > 0
			DADOS_SC5->(DbCloseArea())
		EndIf
		
		//
		TcQuery cQuery New Alias "DADOS_SC5"
		DbSelectArea("DADOS_SC5")
		DADOS_SC5->(DbGoTop())
		While ! DADOS_SC5->(Eof())
			//
			cPedProth := Alltrim(cValToChar(DADOS_SC5->C5_NUM))
		
			//
			nPosSF := 0
			nPosSF := Ascan(aDadosSF,{|x| AllTrim(cValToChar(x[2])) == cPedProth })
			
			lErro := .F.
			If nPosSF > 0
				//
				If Val(cValToChar(DADOS_SC5->VALOR)) <> Round(Val(cValToChar(aDadosSF[nPosSF][9])),2)
					If (Val(cValToChar(DADOS_SC5->VALOR)) - Round(Val(cValToChar(aDadosSF[nPosSF][9])),2)) > 0.01 .Or.;
					   (Val(cValToChar(DADOS_SC5->VALOR)) - Round(Val(cValToChar(aDadosSF[nPosSF][9])),2)) < -0.01
						lErro := .T.
					EndIf
				ElseIf Alltrim(cValToChar(DADOS_SC5->ENTREGA)) <> Alltrim(cValToChar(aDadosSF[nPosSF][4]))
					lErro := .T.
				ElseIf (Alltrim(cValToChar(DADOS_SC5->LIB)) == "N") .And. ("PENDENTE" $(Upper(Alltrim(cValToChar(aDadosSF[nPosSF][5])))) )
					lErro := .T.
				//ElseIf (Alltrim(cValToChar(DADOS_SC5->LIB)) == "S") .And. ("APROVADO" $( Upper(Alltrim(cValToChar(aDadosSF[nPosSF][5]))) ) )
					//lErro := .T.
				ElseIf ("COTA" $( Upper(Alltrim(cValToChar(aDadosSF[nPosSF][5]))) ) )
					lErro := .T.
				Else
					lErro := .F.
				EndIf
				
				//
				If lErro
					Conout("ADVEN101P - Pedido erro de integra��o " + cPedProth)
					Aadd(aDadosPV,Alltrim(cValToChar(aDadosSF[nPosSF][10])))
				EndIf
			EndIf
			DADOS_SC5->(DbSkip())
		EndDo
		
		DADOS_SC5->(DbCloseArea())

		//Envia solicita��o ao Salesforce.
		If Len(aDadosPV) > 0
			Conout("ADVEN101P - Envio de solicita��o de pedido ao Salesforce")
			VarInfo("",aDadosPV)
			cJson := FWJsonSerialize(aDadosPV,.F.,.F.)
			//Static Call(ADVEN097P,envSolic,cJson)
			//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
			u_VEN097A1(cJson)
		Else
			Conout("ADVEN101P - N�o h� pedidos com erros Salesforce")
		EndIf
	Else
		Conout("ADVEN101P - N�o foi poss�vel obter os registros de pedidos no Salesforce.")
	EndIF
	
	//
	RestArea(aArea)
Return Nil

/*/{Protheus.doc} logZBN
	(Chamado 037261 - Gera log na ZBN)
	@type  Static Function
	@author Everson
	@since 22/11/2018
	@version 1.0
	/*/
Static Function logZBN(cStatus)
	//Declara��o de vari�vies
	Local aArea	:= GetArea()

	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADVEN101P'))
		RecLock("ZBN",.F.)
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_DATA    := Date()
			ZBN_HORA    := cValToChar(Time())
			ZBN_ROTINA	:= 'ADVEN101P'
			ZBN_STATUS	:= cStatus
		MsUnlock() 
	Else
		RecLock("ZBN",.T.)
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_DATA    := Date()
			ZBN_HORA    := cValToChar(Time())
			ZBN_ROTINA	:= 'ADVEN101P'
			ZBN_STATUS	:= cStatus
		MsUnlock() 	
	EndIf

	ZBN->(dbCloseArea())

	RestArea(aArea)
Return Nil
