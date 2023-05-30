/*/{Protheus.doc} User Function MNTA420P
    Ponto de Entrada - MNTA420P – Chamado após a inclusão, alteração ou o cancelamento de uma O.S.
    Ticket 88099 - Adicionado logs.
    @type  Function
    @author Everson
    @since 21/02/2023
    @version 01
/*/
User Function MNTA420P() 

    //Variáveis.
    Local aArea     := GetArea()
    Local nOpc      := ParamIxb[1]
    Local cNumOS 	:= STJ->TJ_ORDEM
   
    If nOpc == 3 
        U_ADMNT220("", cNumOS, "INCLUSÃO OS", "")

    ElseIf nOpc == 4 
        U_ADMNT220("", cNumOS, "ALTERAÇÃO OS", "")

    ElseIf nOpc == 5 
        U_ADMNT220("", cNumOS, "EXCLUSÃO OS", "")

    EndIf 

    RestArea(aArea)

Return .T.
