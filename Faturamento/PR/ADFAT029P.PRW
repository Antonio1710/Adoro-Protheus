#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "FWMVCDef.ch"

Static xPula        :=  Chr(13) + Chr(10) 

/*/{Protheus.doc} ADFAT029P
    Job para processamento de registros recebidos do barramento.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 08/02/2022
    @version 01
    @history Everson, 21/03/2022, Chamado 18465. Adicionado validação para geração de pedido de saída entre filiais e inclusão de item de roteiro de pesagem.
    @history Everson, 25/03/2022, Chamado 18465. Removido o RPCSetType.
    @history Everson, 22/09/2022, Chamado 18465. Tratamento para alteração de lote e análise laboratorial.
    @history Everson, 10/10/2022, Chamado 18465. Tratamento para bloqueio de fornecedor pela qualidade.
    @history Everson, 03/01/2023, Chamado 18465. Tratamento para alteração do status do controle de pátio quando houver a aprovação pelo laboratório.
    @history Everson, 24/01/2023, Chamado 18465. Removido o fechamento do registro por erro de conversão de string para json para pesagem do Guardian.
    @history Everson, 06/02/2023, ticket 18465 - Tratamento para enviar ao barramento comunicação do job com a balança.
    @history Everson, 06/02/2023, ticket 18465 - Tratamento para vincular ticket de pesagem Guardian ao ticket do Protheus.
    @history Everson, 17/02/2023, Chamado 18465. Removido o fechamento do registro por erro de conversão de string para json.
    @history Everson, 16/03/2023, Chamado 18465. Adicionado agrupamento para pesagem na atualização de roteiro.
    @history Everson, 02/05/2023, ticket 92178 - Alterado o processamento de geração de pedido de venda em outra filial(transferência).
    @history Everson, 24/05/2023, ticket TI    - Tratamento para errorlog.
/*/
User Function ADFAT029P() // U_ADFAT029P() //Everson, 16/03/2023, Chamado 18465.

    //Variáveis.

	// RPCSetType(3)
	RpcSetEnv("01", "03",,,,GetEnvServer(),{ })

        U_ADFAT29A()

    RpcClearEnv()

Return Nil
/*/{Protheus.doc} ADFAT29A
    Processa integração.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 16/03/2022
    @version 01
/*/
User Function ADFAT29A()

    //Variáveis.
    Local aEmpFil   := deParaSAG(cEmpAnt, cFilAnt)

    If Len(aEmpFil) <= 0
        Help(Nil, Nil, "Função ADFAT29A(ADFAT029P)", Nil, "Filial não possui configuração.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        Return Nil

    EndIf

    //Processa registros lidos por outros sistemas.
    // U_ADFAT29L()

    //Produtos.
    U_ADFAT29B()

    //Lotes de produtos.
    U_ADFAT29C()
    
    //Análise laboratorial.
    U_ADFAT29K()

    //Granjada.
    U_ADFAT29E()

    //Fornecedor.
    U_ADFAT29N()

    //Pedido de saída entre filiais.
    //U_ADFAT29F()

    // //Processar ticket de pesagem.
    // U_ADFAT29H()

    // //Consumo de ração.
    // U_ADFAT29I()

Return Nil
/*/{Protheus.doc} ADFAT29B
    Processa registros do cadastro de produtos SAG.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 08/02/2022
    @version 01
/*/
User Function ADFAT29B()

    //Variáveis.
    Local aArea     := GetArea()
    Local cAliasAux := GetNextAlias()
    Local cQuery    := ""
    Local aError    := {}
    Local cMsgError := ""
    Local cJson     := ""
    Local oJson     := Nil
    Local cId       := ""
    Local cProdSAG  := ""
    Local cDescSAG  := ""
    Local cProdProt := ""
    Local cDescProt := ""
    Local cGrpSAG   := ""
    Local cSGrpSAG  := ""
    Local oModel    := Nil
    Local cAtivo    := ""
    Local cRoteiro  := ""
    Local nToleran  := 0
    Local aEmpFil   := deParaSAG(cEmpAnt, cFilAnt)
    Local cOperac   := ""
    Local envBar    := ""
    Local cTpEmp    := ""    
    Local cAgrupa   := ""

    cQuery += " SELECT  " 
    cQuery += " ZIQ_UUID, "
    cQuery += " ZIQ_OPERAC, "
    cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
    cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
    cQuery += " AND ZIQ_TIPO = 'E' " 
    cQuery += " AND ZIQ_TOPICO = 'cadastro_de_produtos_sag' " 
    cQuery += " AND ZIQ_SISGER = 'SAG' " 
    cQuery += " AND ZIQ_PROCES = '2' " 
    cQuery += " AND ZIQ_EMPRES = '" + aEmpFil[1][1] + "' " 
    cQuery += " AND ZIQ_FILINT = '" + aEmpFil[1][2] + "' " 
    cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    // cQuery += " AND ZIQ_UUID = '3C5FE566-999A-404F-996E-9542C154083B' " 
    cQuery += " ORDER BY RECNO " 

    DbSelectArea("ZIM")
    ZIM->(DbSetOrder(1))
    ZIM->(DbGoTop())

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbGoTop())

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasAux, .F., .T.)
    (cAliasAux)->(DbGoTop())

    While ! (cAliasAux)->(Eof())

        ZIQ->(DbGoto((cAliasAux)->RECNO))
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))
        cOperac   := (cAliasAux)->ZIQ_OPERAC 
        cMsgError := ""
        cJson     := ZIQ->ZIQ_DADOS
        oJson     := getJson(cJson)

        If ValType(oJson) == "U"
            cMsgError := "Não foi possível converter a string para objeto json. " + cId
            //U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29B(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        If ValType(oJson['dados']) == "U"
            cMsgError := "Objeto json não possui a chave dados " + cId
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29B(ADFAT029P)", Nil, "Erro no processamento de registro de produto SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        cProdSAG  := Alltrim(cValToChar(oJson['dados']['codSag']))
        cDescSAG  := Alltrim(cValToChar(oJson['dados']['descSag']))
        cProdProt := Alltrim(cValToChar(oJson['dados']['prdProth']))
        cDescProt := Posicione("SB1", 1, FWxFilial("SB1") + cProdProt, "B1_DESC")
        cGrpSAG   := Alltrim(cValToChar(oJson['dados']['grupoSag']))
        cSGrpSAG  := Alltrim(cValToChar(oJson['dados']['SGrupoSag']))
        cAtivo    := Alltrim(cValToChar(oJson['dados']['ativSag']))
        cRoteiro  := Alltrim(cValToChar(oJson['dados']['roteiro']))
        nToleran  := Val(cValToChar(oJson['dados']['tolerancia']))
        envBar    := Alltrim(cValToChar(oJson['dados']['envBarra']))
        cTpEmp    := Alltrim(cValToChar(oJson['dados']['tpPrdSag']))
        cAgrupa   := Alltrim(cValToChar(oJson['dados']['agrupa'])) ////Everson, 16/03/2023, Chamado 18465.

        If cAtivo == "0"
            cAtivo := "2"
            
        EndIf

        If ! ZIM->(DbSeek( FWxFilial("ZIM") + cProdSAG ))

            If cOperac == "D"
                cMsgError := "Não foi possível localizar o produto " + cProdSAG + "."
                U_ADFAT29D(cId, "2", cMsgError)
                Help(Nil, Nil, "Função ADFAT29B(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                (cAliasAux)->(DbSkip())
                Loop

            EndIf

            If cOperac == "A"
                cOperac := "I"

            EndIf

        Else

            If cOperac == "I"
                cOperac := "A"

            EndIf

        EndIf

        If ! SB1->( DbSeek( FWxFilial("SB1") + cProdProt))
            cMsgError := "Produto não localizado na SB1 " + cProdProt + "."
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29B(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        oModel := FwLoadModel("ADFAT020P")

        If cOperac == "I"
            oModel:SetOperation(MODEL_OPERATION_INSERT)

        ElseIf cOperac == "A"
            oModel:SetOperation(MODEL_OPERATION_UPDATE)

        ElseIf cOperac == "D"
            oModel:SetOperation(MODEL_OPERATION_DELETE)

        Else
            cMsgError := "Operação não definida"
            DisarmTransaction()
            Break

        EndIf

        oModel:Activate()

        If cOperac == "I" .Or. cOperac == "A"
            oModel:SetValue("MD_MASTER", "ZIM_PRDSAG", cProdSAG)
            oModel:SetValue("MD_MASTER", "ZIM_DESSAG", cDescSAG)
            oModel:SetValue("MD_MASTER", "ZIM_PRDPRO", cProdProt)
            oModel:SetValue("MD_MASTER", "ZIM_DESCPR", cDescProt)
            oModel:SetValue("MD_MASTER", "ZIM_GRPSAG", cGrpSAG)
            oModel:SetValue("MD_MASTER", "ZIM_SGPSAG", cSGrpSAG)
            oModel:SetValue("MD_MASTER", "ZIM_ATIVO" , cAtivo)
            oModel:SetValue("MD_MASTER", "ZIM_TPEMB" , cTpEmp)

        EndIf

        Begin Transaction

            If oModel:VldData()
                oModel:CommitData()

            Else
                aError := oModel:GetErrorMessage()
                cMsgError := Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))

            EndIf

            oModel:DeActivate()
            oModel:Destroy()
            oModel := Nil

            If ! Empty(cRoteiro) .And. ! U_ADFAT29G(cOperac, cRoteiro, cProdSAG, nToleran, "PC", envBar, cAgrupa, @cMsgError) //Everson, 16/03/2023, Chamado 18465.
                DisarmTransaction()
                Break

            EndIf

        End Transaction

        If ! Empty(cMsgError)
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29B(ADFAT029P)", Nil, "Erro no processamento de registro de produto SAG x Protheus " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        Else
            U_ADFAT29D(cId, "1", "")

        EndIf

        FreeObj(oJson)
        oJson := Nil

        (cAliasAux)->(DbSkip())

    End

    (cAliasAux)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADFAT29C
    Processa registros de lote de produtos SAG.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 08/02/2022
    @version 01
/*/
User Function ADFAT29C()

    //Variáveis.
    Local aArea     := GetArea()
    Local cAliasAux := GetNextAlias()
    Local cQuery    := ""
    Local aError    := {}
    Local cMsgError := ""
    Local cJson     := ""
    Local oJson     := Nil
    Local cId       := ""
    Local cCdLote   := ""
    Local cDesLote  := ""
    Local cCodProt  := ""
    Local cProdSAG  := ""
    Local cStatus   := ""
    Local cDtIni    := ""
    Local cDtFim    := ""
    Local cAuto     := ""
    Local nSaldo    := 0
    Local nCusto    := 0
    Local oModel    := Nil
    Local aEmpFil   := deParaSAG(cEmpAnt, cFilAnt)
    Local cDesPrd   := ""
    Local cOperac   := ""

    cQuery += " SELECT  " 
    cQuery += " ZIQ_UUID, "
    cQuery += " ZIQ_OPERAC, "
    cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
    cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
    cQuery += " AND ZIQ_TIPO = 'E' " 
    cQuery += " AND ZIQ_TOPICO = 'cadastro_de_lotes_de_produtos_sag' " 
    cQuery += " AND ZIQ_PROCES = '2' " 
    cQuery += " AND ZIQ_SISGER = 'SAG' " 
    cQuery += " AND ZIQ_EMPRES = '" + aEmpFil[1][1] + "' " 
    cQuery += " AND ZIQ_FILINT = '" + aEmpFil[1][2] + "' " 
    cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY RECNO "

    DbSelectArea("ZI8")
    ZI8->(DbSetOrder(1))
    ZI8->(DbGoTop())

    DbSelectArea("ZIM")
    ZIM->(DbSetOrder(1))
    ZIM->(DbGoTop())

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasAux, .F., .T.)
    (cAliasAux)->(DbGoTop())

    While ! (cAliasAux)->(Eof())

        ZIQ->(DbGoto((cAliasAux)->RECNO))
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))
        cOperac   := (cAliasAux)->ZIQ_OPERAC 
        cMsgError := ""
        cJson     := ZIQ->ZIQ_DADOS
        oJson     := getJson(cJson)

        If ValType(oJson) == "U"
            cMsgError := "Não foi possível converter a string para objeto json. " + cId
            //U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29C(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        If ValType(oJson['dados']) == "U"
            cMsgError := "Objeto json não possui a chave dados " + cId
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29C(ADFAT029P)", Nil, "Erro no processamento de registro de lote SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        cCdLote  := Alltrim(cValToChar(oJson['dados']['lotSag']))
        cDesLote := Alltrim(cValToChar(oJson['dados']['descSag']))
        cProdSAG := Alltrim(cValToChar(oJson['dados']['codSag']))
        cCodProt := Alltrim(cValToChar(oJson['dados']['prdProth']))
        cStatus  := Alltrim(cValToChar(oJson['dados']['situacao']))
        cDtIni   := Alltrim(cValToChar(oJson['dados']['inicio']))
        cDtFim   := Alltrim(cValToChar(oJson['dados']['dataFinal']))
        cAuto    := Alltrim(cValToChar(oJson['dados']['automatico']))
        nSaldo   := Val(cValToChar(oJson['dados']['saldo']))
        nCusto   := Val(cValToChar(oJson['dados']['custo']))

        If ! ZIM->(DbSeek( FWxFilial("ZIM") + cProdSAG ))
            cMsgError := "Produto não localizado na tabela ZIM " + cProdSAG + "."
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29C(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        cDesPrd  := Alltrim(cValToChar(ZIM->ZIM_DESSAG))

        If ! ZI8->(DbSeek( FWxFilial("ZI8") + cCdLote ))

            If cOperac == "D"
                cMsgError := "Não foi possível localizar o lote " + cDesLote + "."
                U_ADFAT29D(cId, "2", cMsgError)
                Help(Nil, Nil, "Função ADFAT29C(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                (cAliasAux)->(DbSkip())
                Loop

            EndIf

            If cOperac == "A"
                cOperac := "I"

            EndIf

        Else

            If cOperac == "I"
                cOperac := "A"

            EndIf

        EndIf

        If cStatus == "ABER"
            cStatus := "1"

        ElseIf cStatus == "EUSO"
            cStatus := "2"
        
        ElseIf cStatus == "AGEN"
            cStatus := "3"

        ElseIf cStatus == "ENCE"
            cStatus := "4"

        Else
            cStatus := ""

        Endif

        oModel := FwLoadModel("ADFAT018P")

        If cOperac == "I"
            oModel:SetOperation(MODEL_OPERATION_INSERT)

        ElseIf cOperac == "A"
            oModel:SetOperation(MODEL_OPERATION_UPDATE)

        ElseIf cOperac == "D"
            oModel:SetOperation(MODEL_OPERATION_DELETE)

        Else
            cMsgError := "Operação não definida"
            DisarmTransaction()
            Break

        EndIf

        oModel:Activate()

        If cOperac == "I" .Or. cOperac == "A"
            oModel:SetValue("MD_MASTER", "ZI8_FILIAL", FWxFilial("ZI8"))
            oModel:SetValue("MD_MASTER", "ZI8_CDLOTE", cCdLote)
            oModel:SetValue("MD_MASTER", "ZI8_DESLOT", cDesLote)
            oModel:SetValue("MD_MASTER", "ZI8_PRDPRT", cCodProt)
            oModel:SetValue("MD_MASTER", "ZI8_PRDSAG", cProdSAG)
            oModel:SetValue("MD_MASTER", "ZI8_STATUS", cStatus)
            oModel:SetValue("MD_MASTER", "ZI8_DTINIC", SToD(cDtIni))
            oModel:SetValue("MD_MASTER", "ZI8_DESPRD", cDesPrd)

            If ! Empty(cDtFim)
                oModel:SetValue("MD_MASTER", "ZI8_DTFINA", SToD(cDtFim))

            EndIf

            oModel:SetValue("MD_MASTER", "ZI8_LAUTO", cAuto)
            oModel:SetValue("MD_MASTER", "ZI8_LTSALD", nSaldo)

            If cStatus <> "4"
                oModel:SetValue("MD_MASTER", "ZI8_LTCUST", nCusto)

            EndIf

        EndIf

        If oModel:VldData()
            oModel:CommitData()

        Else
            aError := oModel:GetErrorMessage()
            cMsgError := Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))

        EndIf

        oModel:DeActivate()
        oModel:Destroy()
        oModel := Nil

        If ! Empty(cMsgError)
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29C(ADFAT029P)", Nil, "Erro no processamento de registro de lote de produto SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        Else
            U_ADFAT29D(cId, "1", "")

        EndIf

        FreeObj(oJson)
        oJson := Nil

        (cAliasAux)->(DbSkip())

    End

    (cAliasAux)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADFAT29E
    Processa registros de granjada do SAG.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 14/03/2022
    @version 01
/*/
User Function ADFAT29E()
 
    //Variáveis.
    Local aArea     := GetArea()
    Local cAliasAux := GetNextAlias()
    Local cQuery    := ""
    Local aError    := {}
    Local cMsgError := ""
    Local cJson     := ""
    Local oJson     := Nil
    Local cId       := ""
    Local cCodGrj   := ""
    Local cDCodGrj  := ""
    Local cDtAloja  := ""
    Local cDtFim    := ""
    Local nQtdAv    := 0
    Local cGranja   := ""
    Local cFornece  := ""
    Local cLoja     := ""
    Local cNomeF    := ""
    Local cAtivo    := ""
    Local cGranjada := ""
    Local oModel    := Nil
    Local aEmpFil   := deParaSAG(cEmpAnt, cFilAnt)
    Local cTipo     := ""
    Local cCliForn  := ""
    Local cOperac   := ""
    Local cTbcons   := ""

    cQuery += " SELECT  " 
    cQuery += " ZIQ_UUID, "
    cQuery += " ZIQ_OPERAC, "
    cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
    cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
    cQuery += " AND ZIQ_TIPO = 'E' " 
    cQuery += " AND ZIQ_TOPICO = 'cadastro_de_granjadas_sag' " 
    cQuery += " AND ZIQ_PROCES = '2' " 
    cQuery += " AND ZIQ_SISGER = 'SAG' " 
    cQuery += " AND ZIQ_EMPRES = '" + aEmpFil[1][1] + "' " 
    cQuery += " AND ZIQ_FILINT = '" + aEmpFil[1][2] + "' " 
    cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY RECNO "

    DbSelectArea("ZIS")
    ZIS->(DbSetOrder(2))
    ZIS->(DbGoTop())

    DbSelectArea("SA2")
    SA2->(DbSetOrder(1))
    SA2->(DbGoTop())

    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))
    SA1->(DbGoTop())

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasAux, .F., .T.)
    (cAliasAux)->(DbGoTop())

    While ! (cAliasAux)->(Eof())

        ZIQ->(DbGoto((cAliasAux)->RECNO))
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))
        cOperac   := (cAliasAux)->ZIQ_OPERAC
        cCliForn  := ""
        cMsgError := ""
        cJson     := ZIQ->ZIQ_DADOS
        oJson     := getJson(cJson)

        If ValType(oJson) == "U"
            cMsgError := "Não foi possível converter a string para objeto json. " + cId
            //U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29E(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        If ValType(oJson['dados']) == "U"
            cMsgError := "Objeto json não possui a chave dados " + cId
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29E(ADFAT029P)", Nil, "Erro no processamento de registro de granjada SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        cCodGrj  := Alltrim(cValToChar(oJson['dados']['codGjada']))
        cDCodGrj := Alltrim(cValToChar(oJson['dados']['desGjada']))
        cDtAloja := Alltrim(cValToChar(oJson['dados']['aloGjada']))
        cDtFim   := Alltrim(cValToChar(oJson['dados']['encGjada']))
        nQtdAv   := Val(cValToChar(oJson['dados']['aveGjada']))
        cGranja  := Alltrim(cValToChar(oJson['dados']['codGranj']))
        cFornece := Alltrim(cValToChar(oJson['dados']['forProth']))
        cLoja    := Alltrim(cValToChar(oJson['dados']['lojProth']))
        cNomeF   := Alltrim(cValToChar(oJson['dados']['nomGranj']))
        cAtivo   := Alltrim(cValToChar(oJson['dados']['atiGranj']))
        cGranjada:= Alltrim(cValToChar(oJson['dados']['granjada']))
        cTipo    := Alltrim(cValToChar(oJson['dados']['tipo']))
        cTbcons  := Alltrim(cValToChar(oJson['dados']['tbConsumo']))

        If ! Empty(cTbcons) .And. ! U_ADFAT43B(cTbcons)
            cMsgError := "Tabela de consumo não localizada " + cTbcons + "."
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29E(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf
 
        If cAtivo == "0"
            cAtivo := "2"

        EndIf

        If ! ZIS->(DbSeek( FWxFilial("ZIS") + cCodGrj ))

            If cOperac == "D"
                cMsgError := "Não foi possível localizar o lote " + cDCodGrj + "."
                U_ADFAT29D(cId, "2", cMsgError)
                Help(Nil, Nil, "Função ADFAT29E(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                (cAliasAux)->(DbSkip())
                Loop

            EndIf

            If cOperac == "A"
                cOperac := "I"

            EndIf

        Else

            If cOperac == "I"
                cOperac := "A"

            EndIf

        EndIf

        If ! SA2->( DbSeek( FWxFilial("SA2") + cFornece + cLoja ) )

            cCliForn := "C"


        Else
            cCliForn := "F"

        EndIf

        Begin Transaction

            oModel := FwLoadModel("ADLFV022P")

            If cOperac == "I"
                oModel:SetOperation(MODEL_OPERATION_INSERT)

            ElseIf cOperac == "A"
                oModel:SetOperation(MODEL_OPERATION_UPDATE)

            ElseIf cOperac == "D"
                oModel:SetOperation(MODEL_OPERATION_DELETE)

            Else
                cMsgError := "Operação não definida"
                DisarmTransaction()
                Break

            EndIf

            oModel:Activate()

            If cOperac == "I" .Or. cOperac == "A"
                oModel:SetValue("MD_MASTER", "ZIS_FILIAL" , FWxFilial("ZIS"))
                oModel:SetValue("MD_MASTER", "ZIS_NUMSAG" , cCodGrj)
                oModel:SetValue("MD_MASTER", "ZIS_DESC"   , cDCodGrj)
                oModel:SetValue("MD_MASTER", "ZIS_TIPO"   , cTipo)
                oModel:SetValue("MD_MASTER", "ZIS_DTALOJ" , SToD(cDtAloja))

                If ! Empty(cDtFim)
                    oModel:SetValue("MD_MASTER", "ZIS_DTENCE", SToD(cDtFim))

                EndIf

                oModel:SetValue("MD_MASTER", "ZIS_QTD"    , nQtdAv)
                oModel:SetValue("MD_MASTER", "ZIS_GRANJA" , cGranja)
                oModel:SetValue("MD_MASTER", "ZIS_FORNEC" , cFornece)
                oModel:SetValue("MD_MASTER", "ZIS_LOJA"   , cLoja)
                oModel:SetValue("MD_MASTER", "ZIS_NMGRAN" , cNomeF)
                oModel:SetValue("MD_MASTER", "ZIS_GRAJDA" , cGranjada)
                oModel:SetValue("MD_MASTER", "ZIS_CLIFOR" , cCliForn)
                oModel:SetValue("MD_MASTER", "ZIS_ATIVO"  , cAtivo)

                If ! Empty(cTbcons)
                    oModel:SetValue("MD_MASTER", "ZIS_TPCONS" , ZIV->ZIV_NUMERO)

                EndIf

            EndIf

            If oModel:VldData()
                oModel:CommitData()

            Else
                aError := oModel:GetErrorMessage()
                cMsgError := Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))

            EndIf

            oModel:DeActivate()
            oModel:Destroy()
            oModel := Nil

            If ! Empty(cMsgError)
                U_ADFAT29D(cId, "2", cMsgError)
                Help(Nil, Nil, "Função ADFAT29E(ADFAT029P)", Nil, "Erro no processamento de registro de granjada SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

            Else
                U_ADFAT29D(cId, "1", "")

            EndIf

        End Transaction

        FreeObj(oJson)
        oJson := Nil

        (cAliasAux)->(DbSkip())

    End

    (cAliasAux)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADFAT29F
    Processa registros de pedidos de saída entre filiais.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 17/03/2022
    @version 01 
/*/
User Function ADFAT29F(aPedidos, cUUids)

    //Variáveis.
    Local aArea     := GetArea()
    Local cAliasAux := GetNextAlias()
    Local cQuery    := ""
    Local cMsgError := ""
    Local cJson     := ""
    Local oJson     := Nil
    Local cId       := ""
    Local cEmpD     := ""
    Local cFilD     := ""
    Local cEmpO     := ""
    Local cFilO     := ""
    Local cTpPed    := ""
    Local cFornece  := ""
    Local cLjForn   := ""
    Local aCampo    := ""
    Local cMemNf2   := ""
    Local cGranja   := ""
    Local cGranjada := ""
    Local cTpFrt    := ""
    Local cPlaca    := ""
    Local nPesoLiq  := 0
    Local cProduto  := ""
    Local nVlrUnit  := 0
    Local nTotal    := 0
    Local cTes      := ""
    Local cNmOrdem  := ""
    Local cTabGene  := ""
    Local aRetPed   := {}
    Local pedPrinc  := ""

    Default aPedidos := {}
    Default cUUids   := ""

    cQuery += " SELECT  TOP 1 " 
    cQuery += " ZIQ_UUID, "
    cQuery += " ZIQ_OPERAC, "
    cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
    cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
    cQuery += " AND ZIQ_TIPO = 'E' " 
    cQuery += " AND ZIQ_TOPICO = 'pedidos_de_saida_entre_filiais_protheus' " 
    cQuery += " AND ZIQ_PROCES = '2' " 
    cQuery += " AND ZIQ_SISGER = 'PROTHEUS' " 
    cQuery += " AND ZIQ_EMPRES = '" + cEmpAnt + "' " 
    cQuery += " AND ZIQ_FILINT = '" + cFilAnt + "' " 

    If ! Empty(cUUids)
        cQuery += " AND ZIQ_UUID IN (" + cUUids + ")" 

    EndIf

    cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY RECNO "

    DbSelectArea("ZIS")
    ZIS->(DbSetOrder(2))
    ZIS->(DbGoTop())

    DbSelectArea("SA2")
    SA2->(DbSetOrder(1))
    SA2->(DbGoTop())

    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))
    SA1->(DbGoTop())

    DbSelectArea("SC5")
    SC5->(DbSetOrder(1))
    SC5->(DbGoTop())

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasAux, .F., .T.)
    (cAliasAux)->(DbGoTop())

    If ! (cAliasAux)->(Eof())

        ZIQ->(DbGoto((cAliasAux)->RECNO))
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))
        cMsgError := ""
        cJson     := ZIQ->ZIQ_DADOS
        oJson     := getJson(cJson)

        If ValType(oJson) == "U"
            cMsgError := "Não foi possível converter a string para objeto json. " + cId
            //U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29E(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            // (cAliasAux)->(DbSkip())
            // Loop

            Return Nil

        EndIf

        cEmpD       := oJson['EmpDes']
        cFilD       := oJson['filDes']
        cEmpO       := oJson['empOri']
        cFilO       := oJson['filOr']
        cTpPed      := oJson['tpPed']
        cFornece    := oJson['forne']
        cLjForn     := oJson['loja']
        aCampo      := oJson['ddForn']
        cMemNf2     := oJson['msgNota']
        cGranja     := oJson['granja']
        cGranjada   := oJson['grjada']
        cTpFrt      := oJson['tipoFrt']
        cPlaca      := oJson['placa']
        nPesoLiq    := Val(cValToChar(oJson['pesLiq']))
        cProduto    := oJson['produto']
        nVlrUnit    := Val(cValToChar(oJson['vlrUnit']))
        nTotal      := Val(cValToChar(oJson['vlrTotal']))
        cTes        := oJson['tes']
        cNmOrdem    := oJson['ordPes']
        cTabGene    := oJson['tabGene']
        pedPrinc    := oJson['pedPrinc']

        If ! SC5->( DbSeek( FWxFilial("SC5") + pedPrinc ))
            cMsgError := "Pedido principal não localizado - " + pedPrinc
            U_ADFAT29D(cId, "2", cMsgError)
            Conout("ADFAT029P - ADFAT29F - " + cMsgError)
            // (cAliasAux)->(DbSkip())
            // Loop

            Return Nil

        Else

            If SC5->C5_NOTA == "XXXXXXXXX"
                cMsgError := "Pedido principal eliminado - " + pedPrinc
                U_ADFAT29D(cId, "2", cMsgError)
                Conout("ADFAT029P - ADFAT29F - Pedido não faturado " + pedPrinc)
                // (cAliasAux)->(DbSkip())
                // Loop

                Return Nil

            EndIf

            If Empty(SC5->C5_NOTA)
                Conout("ADFAT029P - ADFAT29F - Pedido não faturado " + pedPrinc)
                // (cAliasAux)->(DbSkip())
                // Loop

                Return Nil

            EndIf

        EndIf

        //Pedido gerado em outra filial.
        aRetPed := U_ADFAT17M(cEmpD, cFilD, cEmpO, cFilO, cTpPed, cFornece, cLjForn, aCampo, cMemNf2, cGranja, cGranjada, cTpFrt,;
                                                            cPlaca, nPesoLiq, cProduto, nVlrUnit, nTotal, cTes, cNmOrdem, cTabGene, .T.)

        cMsgError := aRetPed[3]

        If ! Empty(cMsgError) .Or. ! aRetPed[1]
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29E(ADFAT029P)", Nil, "Erro no processamento de registro de granjada SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        Else
            Aadd(aPedidos, cValToChar(aRetPed[2]) + " empresa/filial " + cEmpD + "/" + cFilD )
            U_ADFAT29D(cId, "1", "")

        EndIf

        FreeObj(oJson)
        oJson := Nil

        // (cAliasAux)->(DbSkip())

    EndIf

    // (cAliasAux)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADFAT29G
    Adiciona produto ao cadastro de item do roteiro.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 21/03/2022
    @version 01
/*/
            //ADFAT29G(cRoteiro, cProdSAG, nToleran, "PC", @cMsgError)
User Function ADFAT29G(cOper, cRoteiro, cProduto, nToleran, cUNTole, envBar, cAgrupa, cMsgError) //Everson, 16/03/2023, Chamado 18465.

    //Variáveis.
    Local aArea := GetArea()

    Default cMsgError := ""

    DbSelectArea("ZIM")
    ZIM->(DbSetOrder(1))
    If ! ZIM->(DbSeek( FWxFilial("ZIM") + cProduto))
        cMsgError := "Produto " + cProduto + " não localizado(tabela ZIM)."
        Help(Nil, Nil, "Função ADFAT29G(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    U_ADFAT15A(cOper, cRoteiro, cProduto, nToleran, cUNTole, envBar, cAgrupa, @cMsgError) //Everson, 16/03/2023, Chamado 18465.

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} getJson
    Converte string json para objeto json.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 08/02/2022
    @version 01
/*/
Static Function getJson(cJson)

    //Variáveis.
    Local oJson := JsonObject():New()
    Local xRet  := oJson:FromJson(cJson)

    If ! ValType(xRet) == "U"
        Return Nil

    EndIf

Return oJson
/*/{Protheus.doc} ADFAT29D
    Salva resultado do processamento no registro do barramento.
    Chamado 18465.
    @type  User Function
    @author Everson
    @since 08/02/2022
    @version 01
/*/
User Function ADFAT29D(cId, cResult, cObserv, cMsgError, lEncerra)

    //Variáveis.
    Local aArea     := GetArea()
    Local oModel    := Nil
    Local lRet      := .F.
    Local aError    := {}
    Local cEmilErr  := GetMv("MV_#FAT291",,"everson.silva@adoro.com.br;wagner.moro@adoro.com.br;jonathan.carvalho@adoro.com.br")
    
    Default cMsgError := ""
    Default lEncerra  := .T.

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))
    If ! ZIQ->(DbSeek( FWxFilial("ZIQ") + cId ))
        cMsgError := "ADFAT29D - Id não encontrado " + cId
        U_GrLogZBE (;
            Date(),;
            Time(),;
            cUserName,;
            "ADFAT29D - Id não encontrado " + cId,;
            "FATURAMENTO",;
            "ADFAT029P",;
            cId,;
            ComputerName(),;
            LogUserName();
        )

        RestArea(aArea)
        Return Nil

    EndIf

    oModel := FwLoadModel("ADFAT027P")
    oModel:SetOperation(MODEL_OPERATION_UPDATE)

    oModel:Activate()

    If lEncerra
        oModel:SetValue("MD_MASTER", "ZIQ_PROCES", "1")

    EndIf

    oModel:SetValue("MD_MASTER", "ZIQ_DTPROC", Date())
    oModel:SetValue("MD_MASTER", "ZIQ_HRPROC", Time())
    oModel:SetValue("MD_MASTER", "ZIQ_STATPR", cResult)
    oModel:SetValue("MD_MASTER", "ZIQ_OBS", cObserv)

    If oModel:VldData()
        oModel:CommitData()
        lRet := .T.

    Else
        aError := oModel:GetErrorMessage()
        cMsgError := Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))

    EndIf

    oModel:DeActivate()
    oModel:Destroy()
    oModel := Nil

    If ! Empty(cMsgError)
        Help(Nil, Nil, "Função ADFAT29D(ADFAT029P)", Nil, "Erro na atualização de registro de barramento " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    If cResult == "2"
        U_EnviaEmail(GetMv("MV_RELFROM"), cEmilErr, cObserv + xPula + cMsgError, "Erro Processamento Barramento " + cId,"")

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} deParaSAG
    Executa de para de empresa filial SAG x Protheus.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 08/02/2022
    @version 01
/*/
Static Function deParaSAG(cEmp, cFil)

    //Variáveis.
    Local aRet := {}

    //Empresa Ad'oro.
    If cEmp == "01" .And. cFil == "03"
        Aadd(aRet,{"01", "E01"})

    ElseIf cEmp == "01" .And. cFil == "05"
        Aadd(aRet,{"01", "E02"})

    EndIf

Return aRet
/*/{Protheus.doc} ADFAT29H
    Processa registros de ticket de pesagem.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 29/03/2022
    @version 01
/*/
User Function ADFAT29H() // U_ADFAT029P("01", "03")

    //Variáveis.
    Local aArea     := GetArea()
    Local cAliasAux := GetNextAlias()
    Local cQuery    := ""
    Local cMsgError := ""
    Local cJson     := ""
    Local oJson     := Nil
    Local cId       := ""
    Local cTickProth:= ""
    Local cTktGuad  := ""
    Local cTag      := ""
    Local cFluxo    := ""
    Local cDTPesa   := ""
    Local cHrPesa   := ""
    Local cCodigo   := ""
    Local cTpOp     := ""
    Local cPlaca    := ""
    Local cCodSitu  := ""
    Local nPeso     := 0
    Local nPesoLiq  := 0
    Local aEmpFil   := deParaSAG(cEmpAnt, cFilAnt)
    Local aDados    := {}
    Local lSlvReg   := .F.

    cQuery += " SELECT  " 
    cQuery += " ZIQ_UUID, "
    cQuery += " ZIQ_OPERAC, "
    cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
    cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
    cQuery += " AND ZIQ_TIPO = 'E' " 
    cQuery += " AND ZIQ_TOPICO = 'pesagens_guardian' " 
    cQuery += " AND ZIQ_SISGER = 'SAG' " 
    cQuery += " AND ZIQ_PROCES = '2' " 
    cQuery += " AND ZIQ_EMPRES = '" + aEmpFil[1][1] + "' " 
    cQuery += " AND ZIQ_FILINT = '" + aEmpFil[1][2] + "' " 
    cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY RECNO " 

    DbSelectArea("ZIM")
    ZIM->(DbSetOrder(1))
    ZIM->(DbGoTop())

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbGoTop())

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasAux, .F., .T.)
    (cAliasAux)->(DbGoTop())

    While ! (cAliasAux)->(Eof())

        ZIQ->(DbGoto((cAliasAux)->RECNO))
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))
        aDados    := {}
        cMsgError := ""
        cJson     := ZIQ->ZIQ_DADOS
        oJson     := getJson(cJson)

        If ValType(oJson) == "U"
            cMsgError := "Não foi possível converter a string para objeto json. " + cId
            //Everson, 24/01/2023, Chamado 18465
            //U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29H(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        cTickProth  := Alltrim(cValToChar(oJson['dados']['coinTkgd']))
        cTktGuad    := Alltrim(cValToChar(oJson['dados']['cogdtkgd']))
        cTag        := Alltrim(cValToChar(oJson['dados']['tag']))
        cFluxo      := Alltrim(cValToChar(oJson['dados']['fluxtkgd']))
        cDTPesa     := Alltrim(cValToChar(oJson['dados']['dtpeOptg']))
        cHrPesa     := Alltrim(cValToChar(oJson['dados']['hopeOptg']))
        cCodigo     := Alltrim(cValToChar(oJson['dados']['cdgdOptg']))
        cTpOp       := Alltrim(cValToChar(oJson['dados']['opcdOptg']))
        cPlaca      := StrTran(Alltrim(cValToChar(oJson['dados']['plactkgd'])),"-","")
        cCodSitu    := Alltrim(cValToChar(oJson['dados']['situOptg']))
        nPeso       := Val(cValToChar(oJson['dados']['pesoOptg']))
        nPesoLiq    := Val(cValToChar(oJson['dados']['peliOptg']))

        If U_ADFAT195(cTickProth)

            Aadd(aDados,{cTickProth, cTktGuad, cTag, cFluxo, cDTPesa, cHrPesa, cCodigo, cTpOp, cPlaca, cCodSitu, nPeso, nPesoLiq})

            lSlvReg := U_ADFAT24G(aDados, @cMsgError)

        Else

            lSlvReg := .T.

        EndIf

        If ! lSlvReg
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29H(ADFAT029P)", Nil, "Erro no processamento de registro de pesagem Guardian " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        Else
            U_ADFAT29D(cId, "1", "")

        EndIf

        FreeObj(oJson)
        oJson := Nil

        (cAliasAux)->(DbSkip())

    End

    (cAliasAux)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADFAT29I
    Processa registros de consumo de ração.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 04/04/2022
    @version 01
/*/
User Function ADFAT29I()

    //Variáveis.
    Local aArea     := GetArea()
    Local cAliasAux := GetNextAlias()
    Local cQuery    := ""
    Local aError    := {}
    Local cMsgError := ""
    Local cJson     := ""
    Local oJson     := Nil
    Local cId       := ""
    Local cNmTab    := ""
    Local cGrpSAG   := ""
    Local cSGrpSAG  := ""
    Local nInicial  := 0
    Local nFinal    := 0
    Local oModel    := Nil
    Local aEmpFil   := deParaSAG(cEmpAnt, cFilAnt)
    Local cOperac   := ""

    cQuery += " SELECT  " 
    cQuery += " ZIQ_UUID, "
    cQuery += " ZIQ_OPERAC, "
    cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
    cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
    cQuery += " AND ZIQ_TIPO = 'E' " 
    cQuery += " AND ZIQ_TOPICO = 'cadastro_de_consumo_de_racao_sag' " 
    cQuery += " AND ZIQ_SISGER = 'SAG' " 
    cQuery += " AND ZIQ_PROCES = '2' " 
    cQuery += " AND ZIQ_EMPRES = '" + aEmpFil[1][1] + "' " 
    cQuery += " AND ZIQ_FILINT = '" + aEmpFil[1][2] + "' " 
    cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY RECNO " 

    DbSelectArea("ZIV")
    ZIV->(DbSetOrder(1))
    ZIV->(DbGoTop())

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasAux, .F., .T.)
    (cAliasAux)->(DbGoTop())

    While ! (cAliasAux)->(Eof())

        ZIQ->(DbGoto((cAliasAux)->RECNO))
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))
        cOperac   := (cAliasAux)->ZIQ_OPERAC 
        cMsgError := ""
        cJson     := ZIQ->ZIQ_DADOS
        oJson     := getJson(cJson)

        If ValType(oJson) == "U"
            cMsgError := "Não foi possível converter a string para objeto json. " + cId
            //U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29I(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        cNmTab    := Alltrim(cValToChar(oJson['dados']['nomeTab']))
        cGrpSAG   := Alltrim(cValToChar(oJson['dados']['grupoSag']))
        cSGrpSAG  := Alltrim(cValToChar(oJson['dados']['SGrupoSag']))
        nInicial  := Val(cValToChar(oJson['dados']['inicial']))
        nFinal    := Val(cValToChar(oJson['dados']['final']))

        cGrpSAG   := cGrpSAG  + Space(TamSX3("ZIV_GRUPO")[1]  - Len(cGrpSAG))
        cSGrpSAG  := cSGrpSAG + Space(TamSX3("ZIV_SGRUPO")[1] - Len(cSGrpSAG))

        If ! ZIV->(DbSeek( FWxFilial("ZIV") + cGrpSAG + cSGrpSAG ))

            If cOperac == "D"
                cMsgError := "Não foi possível localizar o grupo/subgrupo " + cGrpSAG + cSGrpSAG + "."
                U_ADFAT29D(cId, "2", cMsgError)
                Help(Nil, Nil, "Função ADFAT29I(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                (cAliasAux)->(DbSkip())
                Loop

            EndIf

            If cOperac == "A"
                cOperac := "I"

            EndIf

        Else

            If cOperac == "I"
                cOperac := "A"

            EndIf

        EndIf

        oModel := FwLoadModel("ADFAT043P")

        If cOperac == "I"
            oModel:SetOperation(MODEL_OPERATION_INSERT)

        ElseIf cOperac == "A"
            oModel:SetOperation(MODEL_OPERATION_UPDATE)

        ElseIf cOperac == "D"
            oModel:SetOperation(MODEL_OPERATION_DELETE)

        Else
            cMsgError := "Operação não definida"
            DisarmTransaction()
            Break

        EndIf

        oModel:Activate()

        If cOperac == "I" .Or. cOperac == "A"
            oModel:SetValue("MD_MASTER", "ZIV_TPTAB" , cNmTab)
            oModel:SetValue("MD_MASTER", "ZIV_GRUPO" , cGrpSAG)
            oModel:SetValue("MD_MASTER", "ZIV_SGRUPO", cSGrpSAG)
            oModel:SetValue("MD_MASTER", "ZIV_INICIA", nInicial)
            oModel:SetValue("MD_MASTER", "ZIV_FINAL" , nFinal)

        EndIf

        Begin Transaction

            If oModel:VldData()
                oModel:CommitData()

            Else
                aError := oModel:GetErrorMessage()
                cMsgError := Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))

            EndIf

            oModel:DeActivate()
            oModel:Destroy()
            oModel := Nil

        End Transaction

        If ! Empty(cMsgError)
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29I(ADFAT029P)", Nil, "Erro no processamento de registro de consumo de ração " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        Else
            U_ADFAT29D(cId, "1", "")

        EndIf

        FreeObj(oJson)
        oJson := Nil

        (cAliasAux)->(DbSkip())

    End

    (cAliasAux)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADFAT29J
    Processa registros de carregamento do Gemba.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 10/05/2022
    @version 01
/*/
User Function ADFAT29J() // U_ADFAT29J("01", "03")

    //Variáveis.
    Local aArea       := GetArea()
    Local cAliasAux   := GetNextAlias()
    Local cQuery      := ""
    Local cMsgError   := ""
    Local cJson       := ""
    Local oJson       := Nil
    Local cId         := ""
    Local cPlaca      := ""
    Local nPeso       := 0
    Local aEmpFil     := deParaSAG(cEmpAnt, cFilAnt)
    Local aDados      := {}
    Local lSlvReg     := .F.
    Local cAgrupador  := ""
    Local cOrdem      := ""
    Local cIntegrado  := ""
    Local cGranjada   := ""
    Local cLacres     := ""
    Local cProduto    := ""
    Local cSilos      := ""
    Local cCaixas     := ""

    cQuery += " SELECT  " 
    cQuery += " ZIQ_UUID, "
    cQuery += " ZIQ_OPERAC, "
    cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
    cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
    cQuery += " AND ZIQ_TIPO = 'E' " 
    cQuery += " AND ZIQ_TOPICO = 'retornos_de_carregamento_gemba' " 
    cQuery += " AND ZIQ_SISGER = 'SAG' " 
    cQuery += " AND ZIQ_PROCES = '2' " 
    cQuery += " AND ZIQ_EMPRES = '" + aEmpFil[1][1] + "' " 
    cQuery += " AND ZIQ_FILINT = '" + aEmpFil[1][2] + "' " 
    cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY RECNO " 

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasAux, .F., .T.)
    (cAliasAux)->(DbGoTop())

    While ! (cAliasAux)->(Eof())

        ZIQ->(DbGoto((cAliasAux)->RECNO))
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))
        aDados    := {}
        cMsgError := ""
        cJson     := ZIQ->ZIQ_DADOS
        oJson     := getJson(cJson)

        If ValType(oJson) == "U"
            cMsgError := "Não foi possível converter a string para objeto json. " + cId
            //U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29H(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        cAgrupador  := Alltrim(cValToChar(oJson['dados']['nr_bill_request'])) //Roteiro.
        cOrdem      := Alltrim(cValToChar(oJson['dados']['ds_code_order_loading'])) //Número da ordem de carregamento.
        cPlaca      := StrTran(Alltrim(cValToChar(oJson['dados']['nr_plate'])),"-","") //Placa do veículo.
        cIntegrado  := Alltrim(cValToChar(oJson['dados']['ds_code_customer'])) //Código do integrado.
        cGranjada   := Alltrim(cValToChar(oJson['dados']['ds_code_shed'])) //Nome da granjada.
        cLacres     := Alltrim(cValToChar(oJson['dados']['ds_seal'])) //Lacres.
        cProduto    := Alltrim(cValToChar(oJson['dados']['ds_code_product'])) //Código do produto.
        nPeso       := Val(cValToChar(oJson['dados']['ps_slide'])) //Peso carregado.
        cSilos      := Alltrim(cValToChar(oJson['dados']['nm_silo'])) //Silo.
        cCaixas     := Alltrim(cValToChar(oJson['dados']['ds_box'])) //Caixas do veículo.

        If U_ADFAT16A(cOrdem)

            Aadd(aDados,{cAgrupador, cOrdem, cPlaca, cIntegrado, cGranjada, cLacres, cProduto, nPeso, cSilos, cCaixas})

            lSlvReg := U_ADFAT50C(aDados, @cMsgError)

        Else

            lSlvReg := .T.

        EndIf

        If ! lSlvReg
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29H(ADFAT029P)", Nil, "Erro no processamento de registro de carregamento Gemba " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        Else
            U_ADFAT29D(cId, "1", "")

        EndIf

        FreeObj(oJson)
        oJson := Nil

        (cAliasAux)->(DbSkip())

    End

    (cAliasAux)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADFAT29K
    Processa registros de análise laboratorial.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 18/07/2022
    @version 01
/*/
User Function ADFAT29K()

    //Variáveis.
    Local aArea     := GetArea()
    Local cAliasAux := GetNextAlias()
    Local cQuery    := ""
    Local cMsgError := ""
    Local cJson     := ""
    Local oJson     := Nil
    Local cId       := ""
    Local aEmpFil   := deParaSAG(cEmpAnt, cFilAnt)
    Local cOperac   := ""
    Local cOperacao := ""
    Local cNmOrdem  := ""
    Local cSituacao := ""
    Local cPrdSAG   := ""
    Local cLote     := ""
    Local cQuery2   := ""
    Local cNewAlias := ""

    cQuery := ""
    cQuery += " SELECT  " 
    cQuery += " ZIQ_UUID, "
    cQuery += " ZIQ_OPERAC, "
    cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
    cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
    cQuery += " AND ZIQ_TIPO = 'E' " 
    cQuery += " AND ZIQ_TOPICO = 'resultado_analise_laboratorial' " 
    
    cQuery += " AND ZIQ_PROCES = '2' " 

    //cQuery += " AND ZIQ_UUID IN ('4003e31c-8fae-4ace-84aa-16ebc78f2acd') " 
    
    cQuery += " AND ZIQ_EMPRES = '" + aEmpFil[1][1] + "' " 
    cQuery += " AND ZIQ_FILINT = '" + aEmpFil[1][2] + "' " 
    cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY RECNO "

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasAux, .F., .T.)
    (cAliasAux)->(DbGoTop())

    While ! (cAliasAux)->(Eof())

        ZIQ->(DbGoto((cAliasAux)->RECNO))
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))
        cOperac   := (cAliasAux)->ZIQ_OPERAC 
        cMsgError := ""
        cJson     := ZIQ->ZIQ_DADOS
        oJson     := getJson(cJson)

        If ValType(oJson) == "U"
            cMsgError := "Não foi possível converter a string para objeto json. " + cId
            //U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29C(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        If ValType(oJson['dados']) == "U"
            cMsgError := "Objeto json não possui a chave dados " + cId
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29C(ADFAT029P)", Nil, "Erro no processamento de registro de lote SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        cOperacao  := Alltrim(cValToChar(oJson['operacao']))
        cNmOrdem   := Alltrim(cValToChar(oJson['dados']['ordPesagem']))
        cSituacao  := Alltrim(cValToChar(oJson['dados']['situacao']))
        cPrdSAG    := Alltrim(cValToChar(oJson['dados']['prdSag']))
        cLote      := Alltrim(cValToChar(oJson['dados']['lote']))

        If U_ADFAT196(cNmOrdem) .And. ZIG->ZIG_INICIA <> "1" //Everson, 22/09/2022, Chamado 18465. Tratamento para alteração de lote e análise laboratorial.

            cMsgError := "Pesagem iniciada, ordem/agrupador " + cNmOrdem + "."
            U_ADFAT173("Atribuição de lote : " + cMsgError + " - ordem de pesagem/agrupador " + cNmOrdem, cNmOrdem, "", "PROTHEUS")
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29C(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        If cOperacao == "D"
            cSituacao := "2"

        Else
            cSituacao := Iif(cSituacao == "A", "3", "4")

        EndIf

        //Atualização de ordem de pesagem.
        If U_ADFAT16A(cNmOrdem)

            Begin Transaction //Everson, 22/09/2022, Chamado 18465. Tratamento para alteração de lote e análise laboratorial.

                //Everson - 03/01/2023 - ticket 18465.
                //Atualiza status do controle de pátio.
                If ! U_ADFAT174(ZIF->ZIF_CTPATI, "ZIB_STATUS", "2", @cMsgError)
                    DisarmTransaction()
                    Break

                EndIf
                //

                //Valida lote.
                If ! U_ADFAT18D(cLote, cPrdSAG, "", @cMsgError)
                    DisarmTransaction()
                    Break

                EndIf

                //Status do laboratório.
                If ! U_ADFAT165(cNmOrdem, "ZIF_STATLA", cSituacao, @cMsgError)
                    DisarmTransaction()
                    Break
                    
                EndIf

                //Status da ordem de pesagem.
                If ! U_ADFAT165(cNmOrdem, "ZIF_STATUS", cSituacao, @cMsgError)
                    DisarmTransaction()
                    Break

                EndIf

                //Lote da ordem de pesagem.
                If ! U_ADFAT165(cNmOrdem, "ZIF_LOTE", cLote, @cMsgError)
                    DisarmTransaction()
                    Break

                EndIf

            End Transaction

        //Atualização de agrupador de ordem de pesagem.
        ElseIf U_ADFAT16F(cNmOrdem) 

            cQuery2 := " SELECT ZIF_NUMERO, ZIF_STATUS, ZIF_STATLA, ZIF_PRDSAG, ZIF_CTPATI FROM " + RetSqlName("ZIF") + " (NOLOCK) AS ZIF WHERE ZIF_FILIAL = '" + FWxFilial("ZIF") + "' AND ZIF_AGRUPA = '" + cNmOrdem + "' AND ZIF.D_E_L_E_T_ = '' " //Everson - 03/01/2023 - ticket 18465.

            cNewAlias := GetNextAlias()

            DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery2), cNewAlias, .F., .T.)

            (cNewAlias)->(DbGoTop())

            Begin Transaction //Everson, 22/09/2022, Chamado 18465. Tratamento para alteração de lote e análise laboratorial.

                While ! (cNewAlias)->(Eof())

                    cNmOrdem := (cNewAlias)->ZIF_NUMERO

                    //Everson - 03/01/2023 - ticket 18465.
                    //Atualiza status do controle de pátio.
                    If ! U_ADFAT174((cNewAlias)->ZIF_CTPATI, "ZIB_STATUS", "2", @cMsgError)
                        DisarmTransaction()
                        Break

                    EndIf
                    //

                    //Valida lote.
                    If ! U_ADFAT18D(cLote, (cNewAlias)->ZIF_PRDSAG, "", @cMsgError)
                        DisarmTransaction()
                        Break

                    EndIf

                    //Status do laboratório.
                    If ! U_ADFAT165((cNewAlias)->ZIF_NUMERO, "ZIF_STATLA", cSituacao, @cMsgError)
                        DisarmTransaction()
                        Break
                        
                    EndIf

                    //Status da ordem de pesagem.
                    If ! U_ADFAT165((cNewAlias)->ZIF_NUMERO, "ZIF_STATUS", cSituacao, @cMsgError)
                        DisarmTransaction()
                        Break

                    EndIf

                    //Lote da ordem de pesagem.
                    If ! U_ADFAT165((cNewAlias)->ZIF_NUMERO, "ZIF_LOTE", cLote, @cMsgError)
                        DisarmTransaction()
                        Break

                    EndIf

                    (cNewAlias)->(DbSkip())

                End

            End Transaction

            (cNewAlias)->(DbCloseArea())

        Else
            cMsgError := "Ordem de pesagem/agrupador " + cNmOrdem + " não localizado."

        EndIf

        If ! Empty(cMsgError)
            cMsgError += " - ordem de pesagem " + cNmOrdem
            U_ADFAT173("Atribuição de lote : " + cMsgError, cNmOrdem, "", "PROTHEUS")

            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29C(ADFAT029P)", Nil, "Erro no processamento de registro de lote de produto SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        Else

            U_ADFAT173("Atribuição de lote : sucesso", cNmOrdem, "", "PROTHEUS")

            U_ADFAT29D(cId, "1", "")

        EndIf

        FreeObj(oJson)
        oJson := Nil

        (cAliasAux)->(DbSkip())

    End

    (cAliasAux)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADFAT29L
    Marca registros como processados.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 08/02/2022
    @version 01
/*/
User Function ADFAT29L() // U_ADFAT29L()

    //Variáveis.

    RPCClearEnv()
	RPCSetType(3)
	RpcSetEnv("01","03",,,,GetEnvServer(),{ })

        U_ADFAT29M()

    RpcClearEnv()

Return Nil
/*/{Protheus.doc} ADFAT29L
    Processa marca registros como processados.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 08/02/2022
    @version 01
/*/
User Function ADFAT29M() // U_ADFAT29M()

    //Variáveis.
    Local aArea     := ""
    Local cAliasAux := ""
    Local cQuery    := ""
    Local cIdProc   := ""
    Local cId       := ""
    // Local aEmpFil   := deParaSAG(cEmpAnt, cFilAnt)

    aArea     := GetArea()
    cAliasAux := GetNextAlias()

    cQuery += " SELECT  " 
    cQuery += " ZIQ_UUID, "
    cQuery += " ZIQ_OPERAC, "
    cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
    cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
    cQuery += " AND ZIQ_TIPO = 'E' " 
    cQuery += " AND ZIQ_TOPICO = 'marcar_registro_processado' " 
    cQuery += " AND ZIQ_SISGER = 'PROTHEUS' " 
    cQuery += " AND ZIQ_PROCES = '2' " 
    cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY RECNO " 

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasAux, .F., .T.)
    (cAliasAux)->(DbGoTop())

    While ! (cAliasAux)->(Eof())

        ZIQ->(DbGoto((cAliasAux)->RECNO))

        cIdProc   := Alltrim(cValToChar(ZIQ->ZIQ_DADOS))
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))

        TcSqlExec("UPDATE " + RetSqlName("ZIQ") + " SET ZIQ_PROCES = '1', ZIQ_STATPR = '1' WHERE ZIQ_UUID = '" + cIdProc + "'")

        TcSqlExec("UPDATE " + RetSqlName("ZIQ") + " SET ZIQ_PROCES = '1', ZIQ_STATPR = '1' WHERE ZIQ_UUID = '" + cId + "'")

        (cAliasAux)->(DbSkip())

    End

    (cAliasAux)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADFAT29N
    (long_description)
    @type  Function
    @author Everson
    @since 10/10/2022
    @version 01
/*/
User Function ADFAT29N()

    //Variáveis.
    Local aArea     := GetArea()
    Local cAliasAux := GetNextAlias()
    Local cQuery    := ""
    Local cMsgError := ""
    Local cJson     := ""
    Local oJson     := Nil
    Local cId       := ""
    Local aEmpFil   := deParaSAG(cEmpAnt, cFilAnt)
    Local cOperac   := ""
    Local cCodigo   := ""
    Local cLoja     := ""
    Local cStatus   := ""

    cQuery := ""
    cQuery += " SELECT  " 
    cQuery += " ZIQ_UUID, "
    cQuery += " ZIQ_OPERAC, "
    cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
    cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
    cQuery += " AND ZIQ_TIPO = 'E' " 
    cQuery += " AND ZIQ_TOPICO = 'bloqueio_fornecedor_sag' " 
    
    cQuery += " AND ZIQ_PROCES = '2' " 

    //cQuery += " AND ZIQ_UUID IN ('4003e31c-8fae-4ace-84aa-16ebc78f2acd') " 
    
    cQuery += " AND ZIQ_EMPRES = '" + aEmpFil[1][1] + "' " 
    cQuery += " AND ZIQ_FILINT = '" + aEmpFil[1][2] + "' " 
    cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY RECNO "

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))

    DbSelectArea("SA2")
    SA2->(DbSetOrder(1))

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasAux, .F., .T.)
    (cAliasAux)->(DbGoTop())

    While ! (cAliasAux)->(Eof())

        ZIQ->(DbGoto((cAliasAux)->RECNO))
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))
        cOperac   := (cAliasAux)->ZIQ_OPERAC 
        cMsgError := ""
        cJson     := ZIQ->ZIQ_DADOS
        oJson     := getJson(cJson)

        If ValType(oJson) == "U"
            cMsgError := "Não foi possível converter a string para objeto json. " + cId
            //U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29N(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        If ValType(oJson['dados']) == "U"
            cMsgError := "Objeto json não possui a chave dados " + cId
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29N(ADFAT029P)", Nil, "Erro no processamento de registro de lote SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        cCodigo    := Alltrim(cValToChar(oJson['dados']['codigo']))
        cLoja      := Alltrim(cValToChar(oJson['dados']['loja']))
        cStatus    := Alltrim(cValToChar(oJson['dados']['status']))

        SA2->(DbGoTop())
        If SA2->(DbSeek( FWxFilial("SA2") + cCodigo + cLoja ))

            If FieldPos("A2_XBLQUAL") > 0

                RecLock("SA2", .F.)
                    SA2->A2_XBLQUAL := cStatus
                MsUnlock()

            Else
                cMsgError := "Campo A2_XBLQUAL não localizado."

            EndIf


        Else
            cMsgError := "Fornecedor " + cCodigo + "/" + cLoja + "não localizado."

        EndIf

        If ! Empty(cMsgError)
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT29N(ADFAT029P)", Nil, "Erro no processamento de registro de fornecedor SAG x Protheus " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        Else
            U_ADFAT29D(cId, "1", "")

        EndIf

        (cAliasAux)->(DbSkip())

    End

    (cAliasAux)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADFAT29N
    Processa envio de requisições ao WS da balança (Guardian).
    @type  Function
    @author Everson
    @since 10/10/2022
    @version 01
/*/
User Function ADFAT29O()

    //Variáveis.
    Local aArea         := GetArea()
    Local cAliasAux     := GetNextAlias()
    Local cQuery        := ""
    Local cMsgError     := ""
    Local cJson         := ""
    Local oJson         := Nil
    Local cId           := ""
    Local lEncerra      := .T.
    Local nSleep        := GetMv("MV_#FAT290",,10000)
    Local nTentativas   := GetMv("MV_#FAT293",,10) //Everson - 24/05/2023 - ticket TI.
    Local cTxtErrorB    := Alltrim(cValToChar(GetMv("MV_#FAT292",,"Connection refused")))
    Local nCountTent    := 1
    Local cOperac       := ""
    Local cTpEnvio      := ""
    Local cUrl          := ""
    Local cPtControle   := ""
    Local nPosicao      := ""
    Local cMsgDisplay   := ""
    Local nTempo        := 0
    Local cTktProtheus  := ""
    Local cBalanca      := ""
    Local cTktGuardian  := ""  
    Local cFluxo        := ""
    Local nOperacao     := 0
    Local oRetSolic     := Nil
    Local cNmOrdem      := ""
    Local cTpOrdem      := ""
    Local cPlcFmt       := ""  
    Local cPlcVeic      := ""  
    Local cTag          := ""             
    Local nPesIni       := ""   
    Local cOpIni        := ""
    Local cPerPesIni    := ""
    Local lRet          := .F.
    Local cEmilErr      := GetMv("MV_#FAT291",,"everson.silva@adoro.com.br;wagner.moro@adoro.com.br")

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " ZIQ_UUID, "
        cQuery += " ZIQ_OPERAC, "
        cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
        cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
        cQuery += " AND ZIQ_TIPO = 'B' " 
        cQuery += " AND ZIQ_TOPICO = 'comunicacao_balanca' " 
        cQuery += " AND ZIQ_SISGER = 'PROTHEUS' " 
        cQuery += " AND ZIQ_PROCES = '2' " 

        cQuery += " AND ZIQ_EMPRES = '" + cEmpAnt + "' " 
        cQuery += " AND ZIQ_FILINT = '" + cFilAnt + "' " 

        cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY ZIQ_DTORIG, ZIQ_HRORIG " 

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasAux, .F., .T.)
    (cAliasAux)->(DbGoTop())

    While ! (cAliasAux)->(Eof())

        ZIQ->(DbGoto((cAliasAux)->RECNO))
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))
        cOperac   := (cAliasAux)->ZIQ_OPERAC 
        cMsgError := ""
        cJson     := ZIQ->ZIQ_DADOS
        oJson     := getJson(cJson)

        If ValType(oJson) == "U"
            cMsgError := "Não foi possível converter a string para objeto json. " + cId
            Help(Nil, Nil, "Função ADFAT29N(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        If ValType(oJson['dados']) == "U"
            cMsgError := "Objeto json não possui a chave dados " + cId
            Help(Nil, Nil, "Função ADFAT29N(ADFAT029P)", Nil, "Erro no processamento de registro de lote SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        cTpEnvio := Alltrim(cValToChar(oJson['dados']['tipoDeEnvio']))

        cTktProtheus := Alltrim(cValToChar(oJson['dados']['tktProtheus'])) 

        If ! Empty(cTktProtheus)
            cBalanca     := Posicione("ZIG", 1, FWxFilial("ZIG") + cTktProtheus, "ZIG_BALANC")
            cUrl         := Alltrim(cValToChar(Posicione("DX5" , 1, FwxFilial("DX5") + cBalanca, "DX5_URL")))

        EndIf

        If cTpEnvio == "MENSAGEM DISPLAY"

            cPtControle  := oJson['dados']['ptControle']
            nPosicao     := oJson['dados']['posicao']
            cMsgDisplay  := oJson['dados']['msgDisplay']
            nTempo       := oJson['dados']['tempo']

            U_ADFAT248(cUrl, 0, @cMsgError, cPtControle, nPosicao, cMsgDisplay, nTempo)

        ElseIf cTpEnvio == "REMONTA FLUXO"

            cTktGuardian := oJson['dados']['tktGuardian']
            cFluxo       := oJson['dados']['fluxo']

            U_ADFAT245(cUrl, 0, @cMsgError, cTktGuardian, cFluxo)

        ElseIf cTpEnvio == "ENCERRA TICKET"

            cTktGuardian := oJson['dados']['tktGuardian']  
            nOperacao    := oJson['dados']['operacao']  

            U_ADFAT249(cUrl, @cMsgError, cTktGuardian, nOperacao)

        ElseIf cTpEnvio == "CADASTRA TICKET"

            oRetSolic   := Nil
            cNmOrdem    := oJson['dados']['ordemPesagem']
            cTpOrdem    := oJson['dados']['tpOrdemPesagem']
            cPlcFmt     := oJson['dados']['placaCarreta']  
            cPlcVeic    := oJson['dados']['placaVeiculo']  
            cTag        := oJson['dados']['tag']           
            cFluxo      := oJson['dados']['fluxo']         
            nPesIni     := oJson['dados']['pesoInicial']   
            cOpIni      := oJson['dados']['opPesoInicial'] 
            cPerPesIni  := oJson['dados']['perPesoInicial']

            lRet := U_ADFAT241(cUrl, @oRetSolic, @cMsgError, cPlcFmt, cPlcVeic, cTag, cFluxo, cTktProtheus, nPesIni, cOpIni, cPerPesIni)

            If lRet 
            
                If ValType(oRetSolic) == "O"
                    cTktGuardian := cValToChar(oRetSolic:cCodigo)

                    FreeObj(oRetSolic)
                    oRetSolic := Nil

                    U_ADFAT17Z(cNmOrdem, cTpOrdem, cTktGuardian, cTktProtheus, nPesIni, "Envio Balança Job: ", @cMsgError)

                Else
                    cMsgError := "Variável oRetSolic não é objeto "

                EndIf
            
            ElseIf ! lRet .And. "existe um Ticket aberto para esta placa ou TAG!" $cMsgError

                cTktGuardian := U_ADFAT291(cUrl, cTktProtheus, @cMsgError)

                If ! Empty(cTktGuardian)

                    cMsgError := ""

                    U_ADFAT17Z(cNmOrdem, cTpOrdem, cTktGuardian, cTktProtheus, nPesIni, "Envio Balança Job: ", @cMsgError)

                EndIf

            EndIf

        ElseIf cTpEnvio == "GERA PV RACAO"
            cNmOrdem := oJson['dados']['ordemPesagem']
            U_ADFAT170(cNmOrdem)

        EndIf

        If ! Empty(cMsgError)

            lEncerra := ! (cTxtErrorB $Alltrim(cValToChar(cMsgError)))
        
            U_ADFAT29D(cId, "2", cMsgError, Nil, lEncerra)
        
            Help(Nil, Nil, "Função ADFAT29N(ADFAT029P)", Nil, "Erro no processamento de registro de fornecedor SAG x Protheus " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

            If ! lEncerra

            	U_GrLogZBE(Date(), Time(), cUserName, "Erro Comunicação Balança " + cId, "FATURAMENTO", "ADFAT029P",;
					       cMsgError, ComputerName(), LogUserName())

                U_EnviaEmail(GetMv("MV_RELFROM"), cEmilErr, "Tentativa " + cValToChar(nCountTent) + xPula + cMsgError, "Erro Comunicação Balança " + cId,"")
                
                //Everson - 24/05/2023 - ticket TI.
                If nCountTent > nTentativas
                    (cAliasAux)->(DbCloseArea())
                    RestArea(aArea)
                    Return Nil

                EndIf

                nCountTent++
                
                Sleep(nSleep)
                
                Loop

            EndIf

        Else
            nCountTent := 0
            U_ADFAT29D(cId, "1", "")

        EndIf

        (cAliasAux)->(DbSkip())

    End

    (cAliasAux)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADFAT291
    Obtém ticket já cadastrado no Guardian.
    @type  Function
    @author Everson
    @since 06/02/2023
    @version 01
/*/
User Function ADFAT291(cUrl, cTktProt, cMsgError) // U_ADFAT291(, "0024297")

    //Variáveis.
    Local aArea         := GetArea()
    Local cTktGuard     := ""
    Local oRetSolic		:= Nil
    Local dDataIni      := Date()-1
    Local cdataInicial	:= Year2Str(dDataIni) + "-" + Month2Str(dDataIni) + "-" +  Day2Str(dDataIni) + "T00:00:00"
    Local cdataFinal	:= Year2Str(Date())   + "-" + Month2Str(Date())   + "-" +  Day2Str(Date())   + "T23:59:00"
    Local nAux          := 1

    Default cMsgError   := ""

    If ! U_ADFAT24L(cUrl, @oRetSolic, @cMsgError, cdataInicial, cdataFinal)
        cMsgError += "ADFAT291 - " + cMsgError
        RestArea(aArea)
        Return "" 

    EndIf

    If ValType(oRetSolic) <> "O"
        cMsgError += "ADFAT291 - Variável oRetSolic não é objeto"
        RestArea(aArea)
        Return "" 

    EndIf
    
    aTickets := oRetSolic:OWSTICKET

    If ValType(aTickets) <> "A"
        cMsgError += "ADFAT291 - Variável aTickets não é array"
        FreeObj(oRetSolic)
        oRetSolic := Nil
        RestArea(aArea)
        Return "" 

    EndIf

    For nAux := 1 To Len(aTickets)

        If Alltrim(cValToChar(aTickets[nAux]:CREFERENCIAINTEGRACAO)) == Alltrim(cValToChar(cTktProt))
            cTktGuard := Alltrim(cValToChar(aTickets[nAux]:CCODIGO))
            Exit
            
        EndIf

    Next nAux

    FreeObj(oRetSolic)
    oRetSolic := Nil

    RestArea(aArea)

Return cTktGuard
/*/{Protheus.doc} User Function ADFAT292
    Processa inclusão de controle de pátio.
    @type  Function
    @author Everson
    @since 07/03/2023
    @version 01
/*/
User Function ADFAT292()

    //Variáveis.
    Local aArea     := GetArea()
    Local cAliasAux := GetNextAlias()
    Local cQuery    := ""
    Local aError    := {}
    Local cMsgError := ""
    Local cJson     := ""
    Local oJson     := Nil
    Local cId       := ""
    Local oModel    := Nil
    Local aEmpFil   := deParaSAG(cEmpAnt, cFilAnt)
    Local cOperac   := ""
    Local cCpSAG    := ""
    Local cTpMov    := ""
    Local cRoteiro  := ""
    Local cObs      := ""
    Local cPlaca    := ""
    Local cTag      := ""
    Local cData     := ""
    Local cHora     := ""
    Local cMotori   := ""
    Local cTransp   := ""
    Local cLoja     := ""

    cQuery += " SELECT  " 
    cQuery += " ZIQ_UUID, "
    cQuery += " ZIQ_OPERAC, "
    cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
    cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
    cQuery += " AND ZIQ_TIPO = 'E' " 
    cQuery += " AND ZIQ_TOPICO = 'controle_de_patio_sag' " 
    cQuery += " AND ZIQ_SISGER = 'SAG' " 
    cQuery += " AND ZIQ_PROCES = '2' " 
    cQuery += " AND ZIQ_EMPRES = '" + aEmpFil[1][1] + "' " 
    cQuery += " AND ZIQ_FILINT = '" + aEmpFil[1][2] + "' " 
    cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY RECNO " 

    DbSelectArea("ZIB")
    ZIB->(DbSetOrder(1))
    ZIB->(DbGoTop())

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))

    DbSelectArea("ZV4")
    ZV4->(DbSetOrder(1))

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasAux, .F., .T.)
    (cAliasAux)->(DbGoTop())

    While ! (cAliasAux)->(Eof())

        cMotori   := ""
        cTransp   := ""
        cLoja     := ""

        ZIQ->(DbGoto((cAliasAux)->RECNO))
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))
        cOperac   := (cAliasAux)->ZIQ_OPERAC 
        cMsgError := ""
        cJson     := ZIQ->ZIQ_DADOS
        oJson     := getJson(cJson)

        If ValType(oJson) == "U"
            cMsgError := "Não foi possível converter a string para objeto json. " + cId
            //U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT292(ADFAT029P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        If ValType(oJson['dados']) == "U"
            cMsgError := "Objeto json não possui a chave dados " + cId
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT292(ADFAT029P)", Nil, "Erro no processamento de registro de produto SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        cRoteiro  := Alltrim(cValToChar(oJson['dados']['cod_roteiro']))
        cData     := Alltrim(cValToChar(oJson['dados']['data']))
        cHora     := Alltrim(cValToChar(oJson['dados']['hora']))
        cPlaca    := Alltrim(cValToChar(oJson['dados']['placa']))
        cTag      := Alltrim(cValToChar(oJson['dados']['tag']))
        cObs      := Alltrim(cValToChar(oJson['dados']['obs']))
        cCpSAG    := Alltrim(cValToChar(oJson['dados']['codisag']))
        cTpMov    := Alltrim(cValToChar(oJson['dados']['tp_ordem']))

        If Empty(cCpSAG)
            cMsgError := "Código externo não informado"
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT292(ADFAT029P)", Nil, "Erro no processamento de registro de produto SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        If ! U_ADFAT15B(cRoteiro)
            cMsgError := "Roteiro não encontrado " + cRoteiro
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT292(ADFAT029P)", Nil, "Erro no processamento de registro de produto SAG " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAliasAux)->(DbSkip())
            Loop

        EndIf

        If ZV4->(DbSeek(FWxFilial("ZV4") + cPlaca))
            cMotori   := Alltrim(cValToChar(ZV4->ZV4_CPF))
            cTransp   := Alltrim(cValToChar(ZV4->ZV4_FORNEC))
            cLoja     := Alltrim(cValToChar(ZV4->ZV4_LOJFOR))

        EndIf

        oModel := FwLoadModel("ADFAT017P")

        If cOperac == "I"
            oModel:SetOperation(MODEL_OPERATION_INSERT)

        ElseIf cOperac == "A"
            oModel:SetOperation(MODEL_OPERATION_UPDATE)

        ElseIf cOperac == "D"
            oModel:SetOperation(MODEL_OPERATION_DELETE)

        Else
            cMsgError := "Operação não definida"
            DisarmTransaction()
            Break

        EndIf

        oModel:Activate()

        If cOperac == "I" .Or. cOperac == "A"
            oModel:SetValue("MD_MASTER", "ZIB_FILIAL" , FWxFilial("ZIB"))
            oModel:SetValue("MD_MASTER", "ZIB_TPMOVI" , cTpMov)
            oModel:SetValue("MD_MASTER", "ZIB_CODROT" , cRoteiro)
            oModel:SetValue("MD_MASTER", "ZIB_DATA"   , SToD(cData))
            oModel:SetValue("MD_MASTER", "ZIB_HORA"   , cHora)
            oModel:SetValue("MD_MASTER", "ZIB_PLACA"  , cPlaca)
            oModel:SetValue("MD_MASTER", "ZIB_TAG"    , cTag)
            oModel:SetValue("MD_MASTER", "ZIB_STATUS" , "1")
            oModel:SetValue("MD_MASTER", "ZIB_OBSERV" , Substr(cObs, 1, 100))

            oModel:SetValue("MD_MASTER", "ZIB_MOTORI" , cMotori)
            oModel:SetValue("MD_MASTER", "ZIB_TRANSP" , cTransp)
            oModel:SetValue("MD_MASTER", "ZIB_LOJA"   , cLoja)

            //oModel:SetValue("MD_MASTER", "ZIP_CODEXT" , cCpSAG)

        EndIf

        Begin Transaction

            If oModel:VldData()
                oModel:CommitData()

            Else
                aError := oModel:GetErrorMessage()
                cMsgError := Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))

            EndIf

            oModel:DeActivate()
            oModel:Destroy()
            oModel := Nil

        End Transaction

        If ! Empty(cMsgError)
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT292(ADFAT029P)", Nil, "Erro no processamento de registro de controle de pátio " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        Else
            U_ADFAT29D(cId, "1", "")

        EndIf

        FreeObj(oJson)
        oJson := Nil

        (cAliasAux)->(DbSkip())

    End

    (cAliasAux)->(DbCloseArea())

    RestArea(aArea)

Return Nil
