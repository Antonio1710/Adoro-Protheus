#Include "Protheus.ch"
/*/{Protheus.doc} User Function M185VLDEXC
    Ponto de entrada valida exclus�o de pr�-requisi��o.
    https://tdn.totvs.com/display/public/PROT/M185VLDEXC.
    @type  Function
    @author Everson
    @since 16/06/2020
    @version 01
    /*/
User Function M185VLDEXC()

    //Vari�veis.
    Local aArea := GetArea()
    Local lRet  := .T.

    //
    If ! Empty(Alltrim(SCP->CP_XCOMBUS)) 
        MsgStop("Registro lan�ado por processo autom�tico n�o pode ser exclu�do.","Fun��o M185VLDEXC(M185VLDEXC)")
        lRet := .F.

    EndIf

    //
    RestArea(aArea)

Return lRet