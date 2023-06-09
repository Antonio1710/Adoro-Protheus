
#Include "Protheus.ch"

/*/{Protheus.doc} User Function MTA105MNU
    Ponto de entrada pra adicionar novas op��es ao menu da rotina de solicita��o ao armaz�m.
    Ticket 84724
    @type  Function
    @author Everson
    @since 08/02/2023
    @version 01
    @history Everson, 08/02/2023 - Ticket 84724 - Fun��o para altera��o de item de estudo.
/*/
User Function MTA105MNU()

    //Vari�veis.
    Local aArea     := GetArea()
    Local cItemUsr  := GetMv("MV_#120BR1",,"")

	//Everson - 08/02/2023.
	If FWIsAdmin() .Or. __cUserId $cItemUsr
		aadd(aRotina, {"Atl Item Estudo", "U_M120BRW1('SCP')", 0, 10, 0, Nil})

	EndIf

    RestArea(aArea)

Return Nil
