#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static xPula        := Chr(13) + Chr(10)
Static cTitulo      := "Aprovação de Pedidos Varejo"
Static cCarteiras   := ""
Static cCodUsr      := ""
Static lAdm         := .F.
Static lBack        := .F.
Static lVend        := .F.
Static lSuperv      := .F.
Static lDiret       := .F.
Static dDtEntDe     := Nil
Static dDtEntAte    := Nil
Static cTempTable   := ""
Static oTempTable   := Nil
Static cCmpOrd      := "ZJA_NUM"
Static cAscDesc     := "ASC"

/*/{Protheus.doc} User Function ADVEN123P
    Aprovação de pedidos de venda varejo.
    Chamado 91301.
    @type  Function
    @author Everson
    @since 13/04/2023
    @version 01
/*/
User Function ADVEN123P()

    //Variáveis.
    Private oBrowse   := Nil
    Private aRotina   := {}

    carVariaveis()

    If ! (lAdm .Or. lBack .Or. lSuperv .Or. lDiret)
        Return Nil

    EndIf

    aRotina := MenuDef()

    If ! Pergunte("ADVEN1231", .T.)
        Return Nil

    EndIf

    dDtEntDe  := MV_PAR01
    dDtEntAte := MV_PAR02

    If Empty(dDtEntDe) .Or. Empty(dDtEntAte)
        MsgInfo("Necessário preencher todos os parâmetros da pergunta.", "Função ADVEN123P(ADVEN123P)")
        Return Nil

    EndIf

    cTempTable := U_ADVE1231(@oTempTable) //Criar tabela temporária.

    U_ADVE1232() //Carrega dados na tabela temporária.

    oBrowse := BrowseDef(cTempTable)

    oBrowse:Activate()

    oBrowse:DeActivate()
    oTempTable:Delete()
    FreeObj(oTempTable)
    FreeObj(oBrowse)

Return Nil
/*/{Protheus.doc} carVariaveis
    Carrega variáveis estáticas.
    @type  Static Function
    @author Everson
    @since 19/04/2023
    @version 01
/*/
Static Function carVariaveis()

    //Variáveis.
    Local aArea     := GetArea()

    U_ADVE118Q(@cCodUsr, @lAdm, @lBack, @lVend, @lSuperv, @lDiret)
    
    If lAdm .Or. lBack .Or. lDiret
        RestArea(aArea)
        Return Nil

    EndIf
    
    cCarteiras := U_ADVE118G()  

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 13/04/2023
    @version 01
/*/
Static Function MenuDef()
    
    //Variáveis.
    Local aRotina := {}

    ADD OPTION aRotina TITLE "Atualizar"  ACTION "MsAguarde({|| U_ADVE1232(), oBrowse:GoTop() }, 'Aguarde', 'Processando...')"   OPERATION 3 ACCESS 0
    // ADD OPTION aRotina TITLE "Visualizar" ACTION "MsAguarde({|| U_ADVE1234()    }, 'Aguarde', 'Processando...')"      OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Aprovar"    ACTION "MsAguarde({|| U_ADVE1230('3') }, 'Aguarde', 'Processando...')"   OPERATION 10 ACCESS 0
    ADD OPTION aRotina TITLE "Reprovar"   ACTION "MsAguarde({|| U_ADVE1230('4') }, 'Aguarde', 'Processando...')"   OPERATION 11 ACCESS 0

Return aRotina
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 10/05/2023
    @version 01
/*/
Static Function BrowseDef(cTempTable)

    //Variáveis.
    Local oMark    := FWMarkBrowse():New()
    Local aColumns := fBuildColumns()

    oMark := FWMarkBrowse():New()
    oMark:SetAlias(cTempTable)
    oMark:DisableReport()
    oMark:SetTemporary(.T.)
    oMark:SetDescription(cTitulo)
    oMark:SetFieldMark("ZJA_OK")
    oMark:SetFilterDefault("Empty(APROV)")
    oMark:oBrowse:SetUseFilter(.F.)
    aColumns := fBuildColumns(oMark)
    oMark:SetColumns(aColumns)
    oMark:oBrowse:SetIniWindow({|| oBrowse:oBrowse:oBrowse:SetHEADERCLICK({|oObj, nCol| ordena(oObj, nCol)}) })

Return oMark
/*/{Protheus.doc} fBuildColumns
    Gera colunas para o Browse.
    @type  Static Function
    @author Everson
    @since 11/05/2023
    @version 01
/*/
Static Function fBuildColumns(oMark)
    
    //Variáveis.
    Local aArea     := GetArea()
    Local aCampos   := getCmps()
    Local aColumns  := {}
    Local aStruct   := {}
    Local nAux      := 1
    Local oColumn   := Nil

    For nAux := 1 To Len(aCampos)
        Aadd(aStruct, {aCampos[nAux], GetSx3Cache(aCampos[nAux],"X3_TITULO"), GetSx3Cache(aCampos[nAux],"X3_TAMANHO"), GetSx3Cache(aCampos[nAux],"X3_DECIMAL")})
    
    Next nAux
             
    For nAux := 2 To Len(aStruct)

        oColumn := FWBrwColumn():New()

        Aadd(aColumns, oColumn)

        aColumns[Len(aColumns)]:SetData( &("{||" + aStruct[nAux][1] + "}") )
        aColumns[Len(aColumns)]:SetTitle(aStruct[nAux][2])
        aColumns[Len(aColumns)]:SetSize(aStruct[nAux][3])
        aColumns[Len(aColumns)]:SetDecimal(aStruct[nAux][4])
        aColumns[Len(aColumns)]:SetPicture(pesqPict("ZJA", aStruct[nAux][1]) )

    Next nAux

    RestArea(aArea)

Return aColumns
/*/{Protheus.doc} ordena
    Ordenação da coluna.
    @type  Static Function
    @author Everson
    @since 11/05/2023
    @version 01
/*/
Static Function ordena(oObj, nCol)

    //Variáveis.
    Local aCampos    := getCmps()

    If nCol == 1
        oBrowse:AllMark()
        
    Else
        U_ADVE1232(aCampos[nCol])

    EndIf

    oBrowse:Refresh()

Return Nil
/*/{Protheus.doc} User Function ADVE1231
    Cria tabela temporária.
    @type  Function
    @author Everson
    @since 11/05/2023
    @version 01
/*/
User Function ADVE1231(oTempTable)

    //Variáveis.
    Local aArea      := GetArea() 
    Local cAliasTemp := GetNextAlias()
    Local aCampos    := getCmps()
    Local aFields    := {}
    Local nAux       := 1

    For nAux := 1 To Len(aCampos)
        Aadd(aFields, {aCampos[nAux], GetSx3Cache(aCampos[nAux],"X3_TIPO"), GetSx3Cache(aCampos[nAux],"X3_TAMANHO"), GetSx3Cache(aCampos[nAux],"X3_DECIMAL")})

    Next nAux

    Aadd(aFields, {"APROV", "C", 1, 0})
         
    oTempTable:= FWTemporaryTable():New(cAliasTemp)
    oTemptable:SetFields(aFields)

    // For nAux := 2 To Len(aCampos)
    //     oTempTable:AddIndex(aCampos[nAux], {aCampos[nAux]} )    

    // Next nAux
        
    oTempTable:Create()   

    RestArea(aArea)
    
Return oTempTable:GetAlias()
/*/{Protheus.doc} User Function ADVE1231
    Carrega dados na tabela temporária.
    @type  Function
    @author Everson
    @since 11/05/2023
    @version 01
/*/
User Function ADVE1232(cOrdem)

    //Variáveis.
    Local aArea   := GetArea()
    Local cAlias  := GetNextAlias()
    Local aCampos := getCmps()
    Local nAux    := 1
    Local xValor  := Nil
    Local cQuery  := ""

    Default cOrdem := ""

    cQuery  := scriptSql(dDtEntDe, dDtEntAte, cOrdem)

    oTempTable:Zap()

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    If (cAlias)->(Eof())
        (cAlias)->(DbCloseArea())
        RestArea(aArea)
        Return Nil

    EndIf

    While ! (cAlias)->(Eof())

        If RecLock(cTempTable, .T.)  

            For nAux := 2 To Len(aCampos)

                If GetSx3Cache(aCampos[nAux],"X3_TIPO") == "D"
                    xValor := SToD(&("(cAlias)->"+aCampos[nAux]))

                Else
                    xValor := &("(cAlias)->"+aCampos[nAux])

                    If aCampos[nAux] $"ZJA_IT/ZJA_IP"
                        xValor := xValor * 100

                    EndIf

                EndIf
                
                &("(cTempTable)->"+aCampos[nAux]+" := xValor ")

            Next nAux

            (cTempTable)->(MsUnLock())

        EndIf

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 11/05/2023
    @version 01
/*/
Static Function scriptSql(dDtEntDe, dDtEntAte, cOrdem)

    //Variáveis.
    Local cQuery   := ""
    Local cCodSup  := ""

    Default cOrdem := ""

    If ! Empty(cOrdem)
    
        If cCmpOrd == cOrdem
            cAscDesc := Iif(cAscDesc == "ASC", "DESC", "ASC")

        Else
            cAscDesc := "ASC"

        EndIf
        
        cCmpOrd := cOrdem

    EndIf
    
    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " * " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZJA") + " (NOLOCK) AS ZJA " 
    cQuery += " WHERE " 
        cQuery += " ZJA_FILIAL = '" + FWxFilial("ZJA") + "' " 
        cQuery += " AND ZJA_DTENTR BETWEEN '" + DToS(dDtEntDe) + "' AND '" + DToS(dDtEntAte) + "' " 

        If lDiret //Diretor.
            cQuery += " AND ZJA_PARDIR = '1' AND ZJA_PARSUP = '3' " //Já aprovado pelo supervisor.

        ElseIf lSuperv //Supervisor.
            cCodSup := Posicione("SA3", 7, FWxFilial("SA3") + cCodUsr, "A3_SUPER")
            cQuery += " AND ZJA_APRSUP = '" + cCodSup + "' AND ZJA_PARSUP = '1' "

        Else
            cQuery += " AND (ZJA_PARDIR = '1' OR ZJA_PARSUP = '1') " 

        EndIf
            
        cQuery += " AND ZJA_TPPED NOT IN ('7', '8') " 
        cQuery += " AND ZJA_STATUS = '2' " //Pendente comercial.
        cQuery += " AND ZJA_CODRED = '' "
        cQuery += " AND ZJA.D_E_L_E_T_ = '' " 
    
    cQuery += " ORDER BY " + cCmpOrd + " " + cAscDesc

Return cQuery
/*/{Protheus.doc} getCmps
    Retorna os campos utilizados.
    @type  Static Function
    @author Everson
    @since 11/05/2023
    @version 01
/*/
Static Function getCmps()
Return {"ZJA_OK", "ZJA_NUM", "ZJA_CLIENT", "ZJA_LOJACL", "ZJA_NOMECL", "ZJA_DTENTR", "ZJA_CONDPA", "ZJA_IT", "ZJA_EM", "ZJA_IP", "ZJA_VALOR", "ZJA_PESL", "ZJA_VOL", "ZJA_NMSUPE", "ZJA_NMDIRE", "ZJA_LOCEXP"}
/*/{Protheus.doc} User Function ADVE1234
    CRUD.
    @type  Function
    @author Everson
    @since 11/05/2023
    @version 01
/*/
User Function ADVE1234()

    //Variáveis.
    Local aArea   := GetArea()
    Local cPedido := (cTempTable)->ZJA_NUM
    Local cLocExp := (cTempTable)->ZJA_LOCEXP

    If ! U_ADVE1182(cPedido, cLocExp)
        Help(Nil, Nil, "Função ADVE1234(ADVEN123P)", Nil, "Pedido " + cPedido + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return Nil

    EndIf

    FWExecView("Visualizar", "ADVEN118P", 1)

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 13/04/2023
    @version 01
/*/
Static Function ModelDef()
Return FWLoadModel("ADVEN118P")
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 13/04/2023
    @version 01
/*/
Static Function ViewDef()
Return FWLoadView("ADVEN118P")
/*/{Protheus.doc} ADVE1230
    Aprovar pedidos de venda.
    @type  Function
    @author Everson
    @since 13/04/2023
    @version 01
/*/
User Function ADVE1230(cOpc)

    //Variáveis.
    Local aArea     := GetArea()
    Local cMarca    := oMark:Mark()
    Local cPedido   := ""
    Local cLocExp   := ""
    Local cMsgError := ""
    Local aError    := {}
    Local oPedido   := Nil
    Local lPendDir  := .F.
    Local cMsgPer   := Iif(cOpc == "3", "Deseja APROVAR os registros selecionados?", "Deseja REPROVAR os registros selecionados?")
    Local nCount    := 0

    If ! MsgYesNo(cMsgPer, "Função ADVE1230(ADVEN123P)")
        RestArea(aArea)
        Return Nil

    EndIf

    (cTempTable)->(DbGoTop())
    While ! (cTempTable)->(Eof())
        
        If oMark:IsMark(cMarca)
            
            nCount++
            cPedido := (cTempTable)->ZJA_NUM
            cLocExp := (cTempTable)->ZJA_LOCEXP

            If ! U_ADVE1182(cPedido, cLocExp)
                cMsgError += cPedido + " pedido não localizado " + xPula
                (cTempTable)->(DbSkip())
                Loop

            EndIf

            If ZJA->ZJA_STATUS <> "2"
                cMsgError += cPedido + " pedido não está com status 'Pendente comercial' " + xPula
                (cTempTable)->(DbSkip())
                Loop

            EndIf

            If cOpc == "4" .And. U_ADVE118Y((cTempTable)->ZJA_CONDPA) .And. ! MsgYesNo("Pedido " + cPedido + " possui condição de pagamento antecipado. Deseja prosseguir com a reprovação do mesmo?", "Função ADVE1230(ADVEN123P)")
                (cTempTable)->(DbSkip())
                Loop

            EndIf

            oPedido := FWLoadModel("ADVEN118P")
            oPedido:SetOperation(MODEL_OPERATION_UPDATE)
            oPedido:Activate()

                If lSuperv .Or. lAdm
                    oPedido:SetValue("MD_MASTER", "ZJA_PARSUP", cOpc)
                    oPedido:SetValue("MD_MASTER", "ZJA_DTASUP", Date())
                    oPedido:SetValue("MD_MASTER", "ZJA_HRASUP", Time())

                EndIf

                If lDiret .Or. lAdm
                    oPedido:SetValue("MD_MASTER", "ZJA_PARDIR", cOpc)
                    oPedido:SetValue("MD_MASTER", "ZJA_DTADIR", Date())
                    oPedido:SetValue("MD_MASTER", "ZJA_HRADIR", Time())

                EndIf

                lPendDir := oPedido:GetValue("MD_MASTER", "ZJA_PARDIR") == "1"

                If cOpc == "3" .And. ((lSuperv .And. ! lPendDir) .Or. (lAdm .Or. lDiret))
                    oPedido:SetValue("MD_MASTER", "ZJA_STATUS" , "1")  //Aprovado comercial.
                    oPedido:SetValue("MD_MASTER", "ZJA_STATPA" , "4")  //Pedido liberado.

                ElseIf cOpc == "4"
                    oPedido:SetValue("MD_MASTER", "ZJA_STATUS" , "7")  //Reprovado comercial.
                    oPedido:SetValue("MD_MASTER", "ZJA_STATPA" , "6")  //Pedido cancelado.

                    If lSuperv
                        oPedido:SetValue("MD_MASTER", "ZJA_PARDIR" , "2")  //Remove o pedido da alçada do diretor.

                    EndIf

                EndIf

                If oPedido:VldData()
                    oPedido:CommitData()

                    RecLock(cTempTable, .F.)
                        &("(cTempTable)->APROV := 'X'")
                    (cTempTable)->(MsUnlock())

                Else
                    aError := oPedido:GetErrorMessage()
                    cMsgError += cPedido + " " + Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE])) + xPula

                EndIf

            oPedido:DeActivate()
            oPedido:Destroy()
            oPedido := Nil    
        
        EndIf

        (cTempTable)->(DbSkip())
    
    End

    If nCount <= 0
        MsgInfo("Não há registro selecionado.", "Função ADVE1230(ADVEN123P)")
        RestArea(aArea)
        Return Nil

    EndIf

    U_ADVE1232()
    
    oBrowse:GoTop()

    If ! Empty(cMsgError)
        cMsgError := "Os pedidos abaixo apresentaram erro: " + xPula + cMsgError
        Help(Nil, Nil, "Função ADVE1230(ADVEN123P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    Else
        MsgInfo("Processo finalizado.", "Função ADVE1230(ADVEN123P)")

    EndIf

    RestArea(aArea)

Return Nil
