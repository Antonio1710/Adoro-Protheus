/*/{Protheus.doc} User Function MNTA420P
    Ponto de Entrada - MNTA420P � Chamado ap�s a inclus�o, altera��o ou o cancelamento de uma O.S.
    Ticket 88099 - Adicionado logs.
    @type  Function
    @author Everson
    @since 21/02/2023
    @version 01
/*/
User Function MNTA420P() 

    //Vari�veis.
    Local aArea     := GetArea()
    Local nOpc      := ParamIxb[1]
    Local cNumOS 	:= STJ->TJ_ORDEM
   
    If nOpc == 3 
        U_ADMNT220("", cNumOS, "INCLUS�O OS", "")

    ElseIf nOpc == 4 
        U_ADMNT220("", cNumOS, "ALTERA��O OS", "")

    ElseIf nOpc == 5 
        U_ADMNT220("", cNumOS, "EXCLUS�O OS", "")

    EndIf 

    RestArea(aArea)

Return .T.
