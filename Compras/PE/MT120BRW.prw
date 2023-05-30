#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} User Function MT120BRW
	Ponto Entrada para chamar conteudo do campo memo
	@type  Function
	@author William Costa
	@since 27/12/2017
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@Chamado 038389
	@Chamado 043195 - Abel Babini Filho - 23/09/2019 - Cria rotina de solicitacao de PA no menu
	@Chamado 053357 - FWNM              - 18/11/2019 - Chamada da rotina ADCOM032P que visa acertar PC encerrados mesmo qdo NF estornadas/excluidas
	@history Everson, 05/01/2022 - Ticket 18465 - Adicionada a opção de impressão de relatório de matéria-prima.
	@history Everson, 08/02/2023 - Ticket 84724 - Função para alteração de item de estudo.
/*/
User Function MT120BRW()

	// Chamado n. 053357 || OS 054728 || FISCAL || ELIZABETE || 8424 || PEDIDO COM SALDO
	Local lUsrAut  := GetMV("MV_#ATVUSR",,.t.) // Ativa controle de usuarios autorizados
	Local cUsrAut  := GetMV("MV_#USRAUT",,"000000") // Usuarios autorizados
	Local cItemUsr := GetMv("MV_#120BR1",,"")
	//	

	aadd(aRotina,{"Ver Memo"				,"U_ADCOM018P()", 0 , 6,0,NIL})
	aadd(aRotina,{"Solicita PA"				,"U_ADFIN081P()", 0 , 6,0,NIL}) //Ch.043195 - 23/09/2019 - Abel Babini Filho|Apenas validar parametro de usuário caso o mesmo n
	
	// Chamado n. 053357 || OS 054728 || FISCAL || ELIZABETE || 8424 || PEDIDO COM SALDO
	If lUsrAut
		If AllTrim(RetCodUsr()) $ AllTrim(cUsrAut)
			aAdd(aRotina,{"PCs Encerrados x NFs "   ,"U_ADCOM032P()", 0 , 6,0,NIL}) 
		EndIf
	EndIf
	//

	If cFilAnt $"03/05"
		aadd(aRotina, {"Imprimir Ped MP", "U_ADCOM046R()", 0, 10, 0, Nil})

	EndIf

	//Everson - 08/02/2023.
	If FWIsAdmin() .Or. __cUserId $cItemUsr
		aadd(aRotina, {"Atl Item Estudo", "U_M120BRW1('SC7')", 0, 11, 0, Nil})

	EndIf

Return
/*/{Protheus.doc} User Function M120BRW1
	Altera item do pedido.
	@type  Function
	@author Everson
	@since 08/02/2023
	@version 01
/*/
User Function M120BRW1(cAlias)

	//Variáveis.
	Local aArea := GetArea()
	Local cItem	:= ""
	Local cLog	:= ""

	If Empty(cAlias)
		RestArea(aArea)
		Return Nil

	EndIf

	If ! Pergunte("M120BRW1", .T.)
		RestArea(aArea)
		Return Nil

	EndIf

	cItem := Alltrim(cValToChar(MV_PAR01))

	If Empty(cItem) .And. ! MsgYesNo("Não foi informado o item de estudo. Deseja prosseguir com a atualização?", "Função M120BRW1(MT120BRW)")
		RestArea(aArea)
		Return Nil

	EndIf

	If cAlias == "SC7"

		DbSelectArea("SC7")
		SC7->(RecLock("SC7", .F.))
			SC7->C7_XITEMST := cItem
		SC7->(MsUnlock())

		cLog := "PC " + SC7->C7_NUM + " " + SC7->C7_ITEM + " " + cItem

	ElseIf cAlias == "SCP"
		
		DbSelectArea("SCP")
		SCP->(RecLock("SCP", .F.))
			SCP->CP_XITEMST := cItem
		SCP->(MsUnlock())

		cLog := "SA " + SCP->CP_NUM + " " + SCP->CP_ITEM + " " + cItem

	ElseIf cAlias == "SC1"
		
		DbSelectArea("SC1")
		SC1->(RecLock("SC1", .F.))
			SC1->C1_XITEMST := cItem
		SC1->(MsUnlock())

		cLog := "SC " + SC1->C1_NUM + " " + SC1->C1_ITEM + " " + cItem

	Else
		MsgInfo("Não foi possível atualizar o registro.", "Função M120BRW1(MT120BRW)")
		RestArea(aArea)
		Return Nil

	EndIf

	U_GrLogZBE(Date(), Time(), cUserName, "ALTERAÇÃO ITEM DE ESTUDO " + cAlias, "COMPRAS","M120BRW1",;
				cLog, ComputerName(), LogUserName())

	MsgInfo("Registro atualizado.", "Função M120BRW1(MT120BRW)")

	RestArea(aArea)

Return Nil
