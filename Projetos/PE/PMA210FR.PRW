#include "protheus.ch"

/*/{Protheus.doc} User Function PMA210FR
	Ponto Entrada na finaliza��o na finaliza��o da revis�o do projeto (AF8 e AFE ja est�o posicionados)
	@type  Function
	@author Fernando Macieira
	@since 12/08/2017
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@chamado TI
	@history Chamado 047440 - FWNM       - 22/04/2019 - || OS 048708 || FINANCEIRO || REGINALDO || 8451 || APROVACAO PROJETOS
	@history Chamado 051828 - Everson    - 16/09/2019 - Adicionado log
	@history Chamado 056937 - FWNM       - 26/03/2020 - || OS 058425 || CONTROLADORIA || DAIANE || (16)99701-3500 || REVISAO PROJETO
/*/
User Function PMA210FR()

	Local lContinua := PARAMIXB[1]
	Local cNewFase  := GetMV("MV_PRJINIC",,"05")
	
	Local aAreaAF8  := AF8->( GetArea() )
	Local aAreaAFE  := AFE->( GetArea() )
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'P.E. finaliza��o da revis�o do projeto')

	
	If lContinua

		// Popula a central de aprova�ao
		ZC7->( dbSetOrder(3) ) // ZC7_FILIAL, ZC7_PROJET, ZC7_REVPRJ
		If ZC7->( !dbSeek(FWxFilial("ZC7")+AFE->(AFE_PROJET+AFE_REVISA)) ) // Chamado n. 056937 || OS 058425 || CONTROLADORIA || DAIANE || (16)99701-3500 || REVISAO PROJETO - FWNM - 26/03/2020
			
			u_GeraZC7(1,AFE->AFE_XVLRNV) // Chamado n. 047440 || OS 048708 || FINANCEIRO || REGINALDO || 8451 || APROVACAO PROJETOS - FWNM - 22/04/2019

			RecLock("AFE", .F.)
				AFE->AFE_XVLROR := AF8->AF8_XVALOR
			AFE->( msUnLock() )

			RecLock("ZBE", .T.)
				ZBE->ZBE_FILIAL := FWxFilial("ZBE")
				ZBE->ZBE_DATA 	:= msDate()
				ZBE->ZBE_HORA 	:= Time()
				ZBE->ZBE_USUARI	:= Upper(Alltrim(cUserName))
				ZBE->ZBE_LOG	:= "2-Gerou ZC7 Central Aprovacao"
				ZBE->ZBE_PARAME := "AFE_PROJET/AFE_REVISA " + Alltrim(cValToChar(AFE->AFE_PROJET)) +"/"+ Alltrim(cValToChar(AFE->AFE_REVISA)) + " AF8_PROJET/REVISA " + Alltrim(cValToChar(AF8->AF8_PROJET)) +"/"+ Alltrim(cValToChar(AF8->AF8_REVISA))
				ZBE->ZBE_MODULO	:= "PROJETO"
				ZBE->ZBE_ROTINA	:= "PMA210FR" 
			ZBE->( msUnlock() )

		EndIf

		// Faz o rateio automatico do projeto
		u_ADPMS002P(AF8->AF8_PROJET, AF8->AF8_REVISA, (AF8->AF8_XVALOR + AFE->AFE_XVLRNV))
	
		Aviso("PMA210FR-01", "Projeto suplementado! " + chr(13) + chr(10) + "Revis�o necessita de aprova��o (Central de Aprova��o) para poder ser utilizado...", {"OK"}, 3, "Suplementa��o - Projetos Investimentos")
	
	EndIf
		
	RestArea( aAreaAF8 )
	RestArea( aAreaAFE )

Return