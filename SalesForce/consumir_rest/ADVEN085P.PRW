#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
#Include 'AP5mail.ch'
/*/{Protheus.doc} User Function ADVEN085P
	(Chamado 035024 - Job para envio de registros de PABX.)
	@type  Function
	@author Everson
	@since 21/03/2018
	@version 1.0
	@history Leon - 21/07/2020 - Comentar LockByName para contornar falta de execu��o de rotinas de agendamento;
	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	/*/
User Function ADVEN085P() //U_ADVEN085P()
	//Declara��o de vari�vies
	Local cEmp 		:= "01"
	Local cFil 		:= "02"
	
	//Inicia o ambiente.
	RPCClearEnv()
	RPCSetType(3)
	RpcSetEnv(cEmp,cFil,,,,GetEnvServer(),{ })
		
	// Garanto uma �nica thread sendo executada - // Adoro - Chamado n. 050729 || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE - fwnm - 29/06/2020
	// If !LockByName("ADVEN085P", .T., .F.)
	// 	ConOut("[ADVEN085P] - Existe outro processamento sendo executado! Verifique...")
	// 	RPCClearEnv()
	// 	Return
	// EndIf

	// @history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	//FWMonitorMsg(ALLTRIM(PROCNAME()))

	conout("In�cio pausas PABX SalesForce")
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Job para envio de registros de PABX')
	logZBN("1") //Log in�cio.
	
	U_ADVEN054P(DToS(Date()-1),.T.)
	
	logZBN("2") //Log fim.
	conout("Fim pausas PABX SalesForce")

	//Destrava a rotina para o usu�rio
	// UnLockByName("ADVEN085P")

	//Fecha o ambiente.
	RpcClearEnv()
Return Nil

/*/{Protheus.doc} logZBN
	(Chamado 035024 - Gera log na ZBN)
	@type  Static Function
	@author Everson
	@since 30/05/2017
	@version 1.0
	/*/
Static Function logZBN(cStatus)
	//Declara��o de vari�vies
	Local aArea	:= GetArea()
	
	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADVEN083P'))
		RecLock("ZBN",.F.)
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_DATA    := Date()
			ZBN_HORA    := cValToChar(Time())
			ZBN_ROTINA	:= 'ADVEN083P'
			ZBN_STATUS	:= cStatus
		MsUnlock() 
	Else
		RecLock("ZBN",.T.)
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_DATA    := Date()
			ZBN_HORA    := cValToChar(Time())
			ZBN_ROTINA	:= 'ADVEN083P'
			ZBN_STATUS	:= cStatus
		MsUnlock() 	
	EndIf
	
	ZBN->(dbCloseArea())
		
	RestArea(aArea)
Return Nil
