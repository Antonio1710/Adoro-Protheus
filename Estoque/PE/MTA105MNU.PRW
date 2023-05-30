
#Include "Protheus.ch"

/*/{Protheus.doc} User Function MTA105MNU
    Ponto de entrada pra adicionar novas opções ao menu da rotina de solicitação ao armazém.
    Ticket 84724
    @type  Function
    @author Everson
    @since 08/02/2023
    @version 01
    @history Everson, 08/02/2023 - Ticket 84724 - Função para alteração de item de estudo.
/*/
User Function MTA105MNU()

    //Variáveis.
    Local aArea     := GetArea()
    Local cItemUsr  := GetMv("MV_#120BR1",,"")

	//Everson - 08/02/2023.
	If FWIsAdmin() .Or. __cUserId $cItemUsr
		aadd(aRotina, {"Atl Item Estudo", "U_M120BRW1('SCP')", 0, 10, 0, Nil})

	EndIf

    RestArea(aArea)

Return Nil
