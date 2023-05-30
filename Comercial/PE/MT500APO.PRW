
#Include "Protheus.ch"

/*/{Protheus.doc} User Function MT500APO
    Ponto de entrada executado após a eliminação de resíduo do pedido de venda.
    Ticket 91301.
    @type  Function
    @author Everson
    @since 24/05/2023
    @version 01
/*/
User Function MT500APO()

    //Variáveis.
    Local aArea := GetArea()

	If SC5->(FieldPos("C5_XGERSF")) > 0 .And. SC5->C5_XGERSF == "3"
	    U_ADV1180J(SC5->C5_NUM) //Eliminação de resíduo do pedido de venda.

	EndIf

    RestArea(aArea)

Return Nil
