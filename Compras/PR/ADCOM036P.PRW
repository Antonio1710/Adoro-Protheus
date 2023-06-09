#Include "Protheus.ch"
/*/{Protheus.doc} User Function ADCOM036P
    Valida o armaz�m selecionado. Chamado 057152.
    Utilizado em valida��o de usu�rio (campo).
    @type  Function
    @author Everson
    @since 14/04/2020
    @version 01
    /*/
User Function ADCOM036P(cCodArm)
	
    //���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.                                           //
	//�����������������������������������������������������������������������	
    Local aArea     := GetArea()
    Local lVldArmz  := GetMv("MV_#VLARMZ",,.F.)
    Default cCodArm := ""

    //
    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Valida armaz�m selecionado (NNR).')
 
    //
    If !lVldArmz .Or. Empty(cCodArm)
        RestArea(aArea)
        Return .T.

    EndIf

    //
    DbSelectArea("NNR")
    NNR->(DbSetOrder(1))
    NNR->(DbGoTop())
    If ! NNR->( DbSeek( FWxFilial("NNR") + cCodArm ) )
        Aviso("Fun��o ADCOM036P","Armaz�m " + cCodArm + " inv�lido.", {"Fechar"}, 1)
        RestArea(aArea)
        Return .F.

    Else
 
        //
        If Alltrim(cValToChar(NNR->NNR_MSBLQL)) <> "2"
            Aviso("Fun��o ADCOM036P","Armaz�m " + cCodArm + " n�o liberado.", {"Fechar"}, 1)
            RestArea(aArea)
            Return .F.

        EndIf

    EndIf

    //
    RestArea(aArea)

Return .T.