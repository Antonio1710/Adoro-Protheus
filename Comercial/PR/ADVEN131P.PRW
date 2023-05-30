#Include "Rwmake.ch"
#Include 'AP5mail.ch'
#Include "Protheus.ch"
#include 'Fileio.ch'
#Include 'Totvs.ch'
#Include 'Topconn.ch'

/*/{Protheus.doc} User Function ADVEN131P 
	Job para processamento de pedidos de venda incluídos pela rotina ADVEN118P MVC.
    Chamado 91301.
	@type  Function
	@author Everson
	@since 29/05/2023
	@version 01
/*/
User Function ADVEN131P(aXEmpFil) // U_ADVEN131P()

	//Variáveis.
	Local cDiaS		:= ""
	Local cHDe		:= ""
	Local cHAt		:= ""
	Local lAutoJob  := .T.
	local cRobo		:= "A"
	Local nCiclos	:= 0
	Local nCount 	:= 0
	Local cEmp		:= ""
	Local cFil		:= ""

	Default aXEmpFil:= {"13", "01"}

	cEmp := aXEmpFil[1]
	cFil := aXEmpFil[2]
	
	If Select("SX6") == 0
		lAutoJob  := .T.

	Else
		lAutoJob  := .F.

	EndIf

	If lAutoJob
		RPCClearEnv()
		RPCSetType(3)
		RpcSetEnv(cEmp,cFil,,,,GetEnvServer(),{})

	Else
		MsgInfo("Modo debug Início", "Função ADVEN131P(ADVEN131P)")

	EndIf

		Conout(DToC(Date()) + " " + Time() + " ADVEN131P - Início inclusão/atualização/exclusão de pedido de venda SalesForce.")

		nCiclos := GetMV("MV_#VEN903",,100)

		While (nCount <= nCiclos)
		
			cDiaS := Alltrim(cValToChar(GetMv("MV_#SFDSEM")))
			cHDe  := Alltrim(cValToChar(GetMv("MV_#SFHDE")))
			cHAt  := Alltrim(cValToChar(GetMv("MV_#SFHATE")))
			
			If (cValToChar(DOW(Date()))) $cDiaS
				
				logZBN("1")

					U_ADVE1270(cRobo)

				logZBN("2")

			EndIf

			nCount++

			Conout(DToC(Date()) + " " + Time() + " ADVEN131P - Ciclos " + cValToChar(nCount))

		End
		
		Conout(DToC(Date()) + " " + Time() + " ADVEN131P - Fim inclusão/atualização/exclusão de pedido de venda SalesForce.")

	RpcClearEnv()

	If lAutoJob
		RpcClearEnv()

	Else
		MsgInfo("Modo debug Término", "Função ADVEN131P(ADVEN131P)")

	EndIf

Return Nil
/*/{Protheus.doc} logZBN
	Gera log na ZBN.
	@type  Static Function
	@author Everson
	@since 29/05/2023
	@version 01
/*/
Static Function logZBN(cStatus)

    //Variáveis.
	Local aArea	:= GetArea()

	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(FWxFilial("ZBN") + "ADVEN131P"))

		RecLock("ZBN",.F.)

		ZBN_FILIAL  := FWxFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= "ADVEN131P"
		ZBN_STATUS	:= cStatus

		MsUnlock() 

	Else

		RecLock("ZBN",.T.)

		ZBN_FILIAL  := FWxFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= "ADVEN131P"
		ZBN_STATUS	:= cStatus

		MsUnlock() 	

	EndIf

	ZBN->(dbCloseArea())

	RestArea(aArea)

Return Nil
