
#Include "Protheus.ch"

/*/{Protheus.doc} User Function MT500APO
    Ponto de entrada executado ap�s a elimina��o de res�duo do pedido de venda.
    Ticket 91301.
    @type  Function
    @author Everson
    @since 24/05/2023
    @version 01
/*/
User Function MT500APO()

    //Vari�veis.
    Local aArea := GetArea()

	If SC5->(FieldPos("C5_XGERSF")) > 0 .And. SC5->C5_XGERSF == "3"
	    U_ADV1180J(SC5->C5_NUM) //Elimina��o de res�duo do pedido de venda.

	EndIf

    RestArea(aArea)

Return Nil
