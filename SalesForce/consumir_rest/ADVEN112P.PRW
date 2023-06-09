#Include "Rwmake.ch"
#Include 'AP5mail.ch'
#Include "Protheus.ch"
#include 'Fileio.ch'
#Include 'Totvs.ch'
#Include 'Topconn.ch'

Static cEmp := "01"
Static cFil := "02"

/*/{Protheus.doc} User Function ADVEN112P 
	Segundo Job para processamento de altera��o de pedido de venda SalesForce.
	@type  Function
	@author Everson
	@since 09/05/2018
	@version 01
/*/
User Function ADVEN112P(aXEmpFil) // U_ADVEN112P()

	//Declara��o de vari�vies
	Local cDiaS		:= ""
	Local cHDe		:= ""
	Local cHAt		:= ""
	Local lAutoJob  := .T.
	local cRobo		:= "B"
    Local lRobo     := .F.
	Local cEmp	    := ""
	Local cFil	    := ""
	Local nCiclos	:= 0
	Local nCount 	:= 0

	Default aXEmpFil := {"01", "02"}

	cEmp := aXEmpFil[1]
	cFil := aXEmpFil[2]

	//Inicia o ambiente.
	If Select("SX6") == 0
		lAutoJob  := .T.

	Else
		lAutoJob  := .F.

	EndIf


	if lAutoJob
		RPCClearEnv()
		RPCSetType(3)
		RpcSetEnv(cEmp, cFil,,,,GetEnvServer(),{})

	Else
		MsgInfo("Modo debug In�cio", "Modo Debug")

	EndIf

		Conout(DToC(Date()) + " " + Time() + " ADVEN112P - In�cio inclus�o/atualiza��o/exclus�o de pedido de venda SalesForce.")

		nCiclos := GetMV("MV_#VN1121",,100)
		
		While (nCount <= nCiclos)
			
			lRobo := GetMv("MV_#VEN901",,.F.)
		
			cDiaS := Alltrim(cValToChar(GetMv("MV_#SFDSEM")))
			cHDe  := Alltrim(cValToChar(GetMv("MV_#SFHDE")))
			cHAt  := Alltrim(cValToChar(GetMv("MV_#SFHATE")))
		
			If lRobo .And. (cValToChar(DOW(Date()))) $cDiaS //.And. Time() >= cHDe .And. Time() <= cHAt
				
				logZBN("1") //Log in�cio.

					U_ADVEN90A(cRobo)

				logZBN("2") //Log in�cio.

			EndIf

			nCount++

			Conout(DToC(Date()) + " " + Time() + " ADVEN090P - Ciclos " + cValToChar(nCount))

		End
		
		Conout(DToC(Date()) + " " + Time() + " ADVEN112P - Fim inclus�o/atualiza��o/exclus�o de pedido de venda SalesForce.")

	RpcClearEnv()

	if lAutoJob
		RpcClearEnv()

	Else
		MsgInfo("Modo debug T�rmino", "Modo Debug")

	EndIf

Return Nil
/*/{Protheus.doc} logZBN
	Gera log na ZBN.
	@type  Static Function
	@author Everson
	@since 10/08/2020
	@version 01
/*/
Static Function logZBN(cStatus)

    //Vari�veis.
	Local aArea	:= GetArea()

	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADVEN112P'))

		RecLock("ZBN",.F.)

		ZBN_FILIAL  := xFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= 'ADVEN112P'
		ZBN_STATUS	:= cStatus

		MsUnlock() 

	Else

		RecLock("ZBN",.T.)

		ZBN_FILIAL  := xFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= 'ADVEN112P'
		ZBN_STATUS	:= cStatus

		MsUnlock() 	

	EndIf

	ZBN->(dbCloseArea())

	RestArea(aArea)

Return Nil
