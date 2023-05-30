#Include "Protheus.ch"

/*/{Protheus.doc} User Function ADMNT022P
    Ticket 88406. - Valida utilização de OS pelo tipo de serviço.
    @type  Function
    @author Everson
    @since 10/02/2023
    @version 01
    @history Everson, 13/02/2023, ticket 87842 - Validação de encerramento de OS.
    @history Everson, 16/02/2023, ticket 88099 - Adicionado log para Op/Os. 
/*/
/*
    U_ADMNT022P(SC7->C7_OP, "")
    U_ADMNT022P(SC1->C1_OP, "")
    U_ADMNT022P(SCP->CP_OP, "")
*/
User Function ADMNT022P(cOp, cOS) // U_ADMNT022P()

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .T.
    Local cTpSrv    := ""
    Local cTpBlq    := Alltrim(cValToChar(GetMv("MV_#DMT221",,"SC0001,SC0002")))
    Local cUserLib  := Alltrim(cValToChar(GetMv("MV_#DMT222",, "")))
    Local lValida   := GetMv("MV_#DMT223",, .F.)

    Default cOp     := ""
    Default cOS     := ""

    If ! lValida
        RestArea(aArea)
        Return .T.
        
    EndIf

    If Empty(cOp) .And. Empty(cOS)
        RestArea(aArea)
        Return .T.

    EndIf

    If ! Empty(cOp) 

        DbSelectArea("SC2")
        SC2->(DbSetOrder(1))
        SC2->(DbGoTop())
        If ! SC2->(DbSeek( FWxFilial("SC2") + cOp ))
            RestArea(aArea)
            Return .T.

        EndIf

        If Alltrim(cValToChar(SC2->C2_ITEM)) <> "OS"
            RestArea(aArea)
            Return .T.

        EndIf
        
        cOS := SC2->C2_NUM

    EndIf

    cTpSrv := Alltrim(cValToChar(Posicione("STJ", 1, FWxFilial("STJ") + cOS, "TJ_SERVICO")))

    If (cTpSrv $cTpBlq) .And. !(__cUserId $cUserLib)
        lRet := .F.
        Help(Nil, Nil, "Função ADMNT022P(ADMNT022P)", Nil, "Usuário não autorizado a utilizar a OS " + cOS + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADMNT220
    Gera log de OS de manutenção.
    @type  Function
    @author Everson
    @since 16/02/2023
    @version 01
/*/
User Function ADMNT220(cOp, cOs, cLog, cMemo)

    //Variáveis.
    Local aArea := GetArea()

    Default cOp     := ""
    Default cOs     := ""
    Default cLog    := ""
    Default cMemo   := ""

    If Empty(cOp) .And. Empty(cOS)
        RestArea(aArea)
        Return Nil

    EndIf

    If ! Empty(cOp) 

        DbSelectArea("SC2")
        SC2->(DbSetOrder(1))
        SC2->(DbGoTop())
        If ! SC2->(DbSeek( FWxFilial("SC2") + cOp ))
            RestArea(aArea)
            Return Nil

        EndIf

        If Alltrim(cValToChar(SC2->C2_ITEM)) <> "OS"
            RestArea(aArea)
            Return Nil

        EndIf
        
        cOS := SC2->C2_NUM

    EndIf

	U_GrLogZBE(Date(), Time(), cUserName, cLog, "MANUTENCAO", "ADMNT220",;
			   cOs, ComputerName(), LogUserName(), cMemo)

    RestArea(aArea)    

Return Nil
