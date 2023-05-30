#Include "Protheus.ch"
#Include "Topconn.ch" 
#Include "Apwizard.ch" 
#Include "Fileio.ch"  
#Include "Tbiconn.ch"

/*/{Protheus.doc} User Function ADFIS042P
	Lançamento de documento de entrada (CT-e) por xml - Ceres.
	@type  Function
	@author Everson
	@since 30/11/2022
	@version 01
/*/
User Function ADFIS042P() // U_ADFIS042P()

	//Declaracao de Variaveis.
	Local cEmail:= ""
	Local aXEmpFil :={ "02", "01" }

	RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv(aXEmpFil[1],aXEmpFil[2],,,,GetEnvServer(),{ })

		U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Lançamento de documento de entrada (CT-e) por xml Ceres')
		
		logZBN("1")

			cEmail	:= GetMv("MV_#AUTCTE",,"")
			
			Conout( DToC(Date()) + " " + Time() + " ADFIS042P - Início " + cFilAnt )

				u_FIS032A1( cEmail )

			Conout( DToC(Date()) + " " + Time() + " ADFIS042P - Fim " + cFilAnt )
		
		logZBN("2")

	RpcClearEnv()

Return Nil
/*/{Protheus.doc} logZBN
	Gera log na ZBN.
	@type  Static Function
	@author Everson
	@since 30/11/2022
	@version 01
/*/
Static Function logZBN(cStatus)

	//Declaração de variávies
	Local aArea	:= GetArea()
	
	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADFIS042P'))
		RecLock("ZBN",.F.)
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_DATA    := Date()
			ZBN_HORA    := cValToChar(Time())
			ZBN_ROTINA	:= 'ADFIS042P'
			ZBN_STATUS	:= cStatus
		MsUnlock() 
	Else
		RecLock("ZBN",.T.)
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_DATA    := Date()
			ZBN_HORA    := cValToChar(Time())
			ZBN_ROTINA	:= 'ADFIS042P'
			ZBN_STATUS	:= cStatus
		MsUnlock() 	
	EndIf
	
	ZBN->(dbCloseArea())
	
	RestArea(aArea)
Return Nil
