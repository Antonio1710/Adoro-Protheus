#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static xPula        := Chr(13) + Chr(10)
Static cTitulo      := "Aprovação de Pedidos Rede"
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
Static cCmpOrd      := "ZJA_CODRED"
Static cAscDesc     := "ASC"

/*/{Protheus.doc} User Function ADVEN124P
    Aprovação de pedidos de venda varejo.
    Chamado 91301.
    @type  Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
User Function ADVEN124P()

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
        MsgInfo("Necessário preencher todos os parâmetros da pergunta.", "Função ADVEN124P(ADVEN124P)")
        Return Nil

    EndIf

    cTempTable := U_ADVE1241(@oTempTable) //Criar tabela temporária.

    U_ADVE1242() //Carrega dados na tabela temporária.

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
    @since 12/05/2023
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
    @since 12/05/2023
    @version 01
/*/
Static Function MenuDef()
    
    //Variáveis.
    Local aRotina := {}

    ADD OPTION aRotina TITLE "Atualizar"  ACTION "MsAguarde({|| U_ADVE1242(), oBrowse:GoTop() }, 'Aguarde', 'Processando...')"   OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Aprovar"    ACTION "MsAguarde({|| U_ADVE1240('3') }, 'Aguarde', 'Processando...')"   OPERATION 10 ACCESS 0
    ADD OPTION aRotina TITLE "Reprovar"   ACTION "MsAguarde({|| U_ADVE1240('4') }, 'Aguarde', 'Processando...')"   OPERATION 11 ACCESS 0

Return aRotina
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 12/05/2023
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
    @since 12/05/2023
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
    @since 12/05/2023
    @version 01
/*/
Static Function ordena(oObj, nCol)

    //Variáveis.
    Local aCampos    := getCmps()

    If nCol == 1
        oBrowse:AllMark()
        
    Else
        U_ADVE1242(aCampos[nCol])

    EndIf

    oBrowse:Refresh()

Return Nil
/*/{Protheus.doc} User Function ADVE1241
    Cria tabela temporária.
    @type  Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
User Function ADVE1241(oTempTable)

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
/*/{Protheus.doc} User Function ADVE1241
    Carrega dados na tabela temporária.
    @type  Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
User Function ADVE1242(cOrdem)

    //Variáveis.
    Local aArea   := GetArea()
    Local cAlias  := GetNextAlias()
    Local aCampos := getCmps()
    Local nAux    := 1
    Local xValor  := Nil
    Local cQuery  := ""

    Default cOrdem := ""

    cQuery  := scriptSql(dDtEntDe, dDtEntAte, cOrdem, .F.)

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

                    If aCampos[nAux] $"ZJA_RIT/ZJA_RIP"
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
/*/{Protheus.doc} scriptSql
    Script Sql com os registros para aprovação.
    @type  Static Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
Static Function scriptSql(dDtEntDe, dDtEntAte, cOrdem, lApprc, cIdProcR)

    //Variáveis.
    Local cQuery    := ""
    Local cCodSup   := ""

    Default cOrdem    := ""
    Default lApprc    := .F. 
    Default cIdProcR  := ""

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

        If lApprc
            cQuery += " DISTINCT ZJA_IDPRED, ZJA_NUM, ZJA_LOCEXP, ZJA_CONDPA " 

        Else

            cQuery += " DISTINCT  ZJA_DTENTR, ZJA_CODRED, ZJA_IDPRED, ZJA_STATUS, ZJA_RVOL, ZJA_RVALOR, ZJA_REM, ZJA_RIT, ZJA_RIP, ZJA_NMSUPE, ZJA_NMDIRE, ZJA_LOCEXP, RTRIM(LTRIM(A1_NOME)) AS A1_NOME " 

        EndIf

    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZJA") + " (NOLOCK) AS ZJA " 
        cQuery += " INNER JOIN " 
        cQuery += " " + RetSqlName("SA1") + " (NOLOCK) AS SA1 ON " 
        cQuery += " ZJA_CODRED = A1_COD AND A1_LOJA = '00' AND SA1.D_E_L_E_T_ = '' " 

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
        cQuery += " AND ZJA_STATUS = '3' " //Pendente aprovação rede.
        cQuery += " AND ZJA_DTPRED <> '' "
        cQuery += " AND ZJA_IDPRED <> '' "
        cQuery += " AND ZJA_CODRED <> '' "
        cQuery += " AND ZJA.D_E_L_E_T_ = '' " 
    
    If lApprc
        cQuery += " AND ZJA_IDPRED = '" + cIdProcR + "' "
        cQuery += " ORDER BY ZJA_NUM "

    Else
        cQuery += " ORDER BY " + cCmpOrd + " " + cAscDesc

    EndIf

Return cQuery
/*/{Protheus.doc} getCmps
    Retorna os campos utilizados.
    @type  Static Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
Static Function getCmps()
Return {"ZJA_OK", "ZJA_DTENTR", "ZJA_CODRED", "A1_NOME", "ZJA_IDPRED", "ZJA_RVOL", "ZJA_RVALOR", "ZJA_REM", "ZJA_RIT", "ZJA_RIP", "ZJA_NMSUPE", "ZJA_NMDIRE", "ZJA_LOCEXP"}
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
Static Function ModelDef()
Return FWLoadModel("ADVEN118P")
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
Static Function ViewDef()
Return FWLoadView("ADVEN118P")
/*/{Protheus.doc} ADVE1240
    Aprovar pedidos de venda.
    @type  Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
User Function ADVE1240(cOpc)

    //Variáveis.
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local cAlias    := ""
    Local cMarca    := oMark:Mark()
    Local cPedido   := ""
    Local cMsgError := ""
    Local aError    := {}
    Local oPedido   := Nil
    Local lPendDir  := .F.
    Local cMsgPer   := Iif(cOpc == "3", "Deseja APROVAR os registros selecionados?", "Deseja REPROVAR os registros selecionados?")
    Local nCount    := 0
    Local cIdProcR  := ""
    Local lRetProc  := .T. 
    Local lMkRepCn  := .F.
    Local cLocExp   := ""

    If ! MsgYesNo(cMsgPer, "Função ADVE1240(ADVEN124P)")
        RestArea(aArea)
        Return Nil

    EndIf

    (cTempTable)->(DbGoTop())
    While ! (cTempTable)->(Eof())

        If oMark:IsMark(cMarca)
            
            lRetProc := .T.
            lMkRepCn := .F.
            
            nCount++
            cIdProcR := (cTempTable)->ZJA_IDPRED
            cQuery   := scriptSql(dDtEntDe, dDtEntAte, "", .T., cIdProcR)

            cAlias := GetNextAlias()

            DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
            (cAlias)->(DbGoTop())

            If (cAlias)->(Eof())
                (cAlias)->(DbCloseArea())
                (cTempTable)->(DbSkip())
                Loop

            EndIf

            Begin Transaction

                While ! (cAlias)->(Eof())

                    cPedido := (cAlias)->ZJA_NUM
                    cLocExp := (cAlias)->ZJA_LOCEXP

                    If ! U_ADVE1182(cPedido, cLocExp)
                        lRetProc := .F.
                        cMsgError += cIdProcR + " - " + cPedido + " pedido não localizado " + xPula
                        DisarmTransaction()
                        Break

                    EndIf

                    If ZJA->ZJA_STATUS <> "3"
                        lRetProc := .F.
                        cMsgError += cIdProcR + " - " + cPedido + " pedido não está com status 'Pendente aprovação rede' " + xPula
                        DisarmTransaction()
                        Break

                    EndIf

                    If cOpc == "4" .And. U_ADVE118Y((cAlias)->ZJA_CONDPA)
                    
                        If !lMkRepCn .And. ! MsgYesNo("Pedido " + cPedido + " possui condição de pagamento antecipado. Deseja prosseguir com a reprovação do mesmo?", "Função ADVE1240(ADVEN124P)")
                            lRetProc := .F.
                            DisarmTransaction()
                            Break

                        Else
                            lMkRepCn := .T.

                        EndIf

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

                        Else
                            lRetProc := .F.
                            aError := oPedido:GetErrorMessage()
                            cMsgError +=  cIdProcR + " - " + cPedido + " " + Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE])) + xPula

                        EndIf

                    oPedido:DeActivate()
                    oPedido:Destroy()
                    oPedido := Nil

                    If ! lRetProc
                        DisarmTransaction()
                        Break

                    EndIf

                    (cAlias)->(DbSkip())

                End

            End Transaction

            (cAlias)->(DbCloseArea())
        
            If lRetProc
                RecLock(cTempTable, .F.)
                    &("(cTempTable)->APROV := 'X'")
                (cTempTable)->(MsUnlock())

            EndIf

        EndIf

        (cTempTable)->(DbSkip())
    
    End

    If nCount <= 0
        MsgInfo("Não há registro selecionado.", "Função ADVE1240(ADVEN124P)")
        RestArea(aArea)
        Return Nil

    EndIf

    U_ADVE1242()
    
    oBrowse:GoTop()

    If ! Empty(cMsgError)
        cMsgError := "Os registros abaixo apresentaram erro: " + xPula + cMsgError
        Help(Nil, Nil, "Função ADVE1240(ADVEN124P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    Else
        MsgInfo("Processo finalizado.", "Função ADVE1240(ADVEN124P)")

    EndIf

    RestArea(aArea)

Return Nil
