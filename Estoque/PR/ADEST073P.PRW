#Include "Totvs.ch"
#Include "FWMVCDef.ch"
#Include "Topconn.ch"

Static cTbMast := "ZIL"
Static cTitulo := "Confer�ncia de Produtos Ensacados" 
Static cTiMast := "Dados da confer�ncia de produtos ensacados"
Static xPula   := Chr(13) + Chr(10)

/*/{Protheus.doc} User Function ADEST073P
    Confer�ncia de Produtos Ensacados
    Cad Conf Prd Ensacados
    Chamado 18465.
    @type  Function
    @author Everson
    @since 05/04/2022
    @version 01
    @history, Everson, 26/01/2023, ticket 18465 - Corrigido totalizador por ordem/produto.
    @history, Everson, 01/02/2023, ticket 18465 - Tratamento para envio das informa��es ao barramento.
/*/
User Function ADEST073P() // U_ADEST073P()

    //Vari�veis.
    Local oBrowse := FwLoadBrw("ADEST073P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function BrowseDef()

    //Vari�veis.
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast) 
    oBrowse:SetDescription(cTitulo)

    oBrowse:AddLegend("ZIL_PESADO = '1' ","BR_VERMELHO" , "Pesado")
    oBrowse:AddLegend("ZIL_PESADO = '2' ","BR_VERDE"    , "Aberto")

    oBrowse:SetFilterDefault(" " + cTbMast + "_FILIAL = '" + FWxFilial(cTbMast) + "' ")

Return oBrowse
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function MenuDef()

    //Vari�veis.
	Local aRotina 	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PesqBrw"          	OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.ADEST073P" 	OPERATION MODEL_OPERATION_VIEW     ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" 	    ACTION "VIEWDEF.ADEST073P" 	OPERATION MODEL_OPERATION_INSERT   ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"      ACTION "U_ADEST734(4)" 	    OPERATION MODEL_OPERATION_UPDATE   ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" 	    ACTION "U_ADEST734(5)" 	    OPERATION MODEL_OPERATION_DELETE   ACCESS 0

Return aRotina
/*/{Protheus.doc} ADEST734
    Valida��o para altera��o e exclus�o de registro.
    @type  User Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
User Function ADEST734(nOpc)

    //Vari�veis.
    Local aArea     := GetArea()

    If ZIL->ZIL_PESADO == "1" .And. ! FWIsAdmin()
        MsgInfo("Ordem com peso final. Opera��o n�o permitida.","Fun��o ADEST734(ADEST073P)")
        RestArea(aArea)
        Return Nil

    EndIf

    FWExecView("", "ADEST073P", nOpc)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function ModelDef()
    
    //Vari�veis.
    Local oModel    := Nil
    Local oStrMast  := FWFormStruct(1, cTbMast, {|cCampo| AllTRim(cCampo) $ getCmps()})
    Local oStrGrid  := FWFormStruct(1, cTbMast)
    Local bPost     := Nil

    bPost := {|oModel| vldPos(oModel)}

    oModel := MPFormModel():New("ADEST73", /*bPreValidacao*/, bPost, /*bCommit*/, /*bCancel*/ )
    
    //AddFields(<cId >, <cOwner >, <oModelStruct >, <bPre >, <bPost >, <bLoad >)
    oModel:AddFields("MD_MASTER", Nil, oStrMast)
    oModel:AddGrid("MD_GRID", "MD_MASTER", oStrGrid,,,,,)
    oModel:GetModel("MD_GRID"):SetNoDeleteLine(.T.)
    oModel:GetModel("MD_GRID"):SetNoInsertLine(.T.)
 
    oModel:SetRelation("MD_GRID", {;
            {"ZIL_FILIAL", 'FWxFilial("' + cTbMast + '")'},;
            {"ZIL_PLACA", "ZIL_PLACA"},;
            {"ZIL_AGRUPA", "ZIL_AGRUPA"},;
            {"ZIL_CTPATI", "ZIL_CTPATI"},;
            {"ZIL_TPENSA", "ZIL_TPENSA"},;
            {"ZIL_PESADO", "ZIL_PESADO"},;
            {"ZIL_SEQUEN", "ZIL_SEQUEN"};
        }, (cTbMast)->(IndexKey(1)))

    oModel:GetModel("MD_GRID")
    oModel:SetDescription(cTiMast)
    oModel:SetPrimaryKey({})

    oModel:AddCalc("ADEST73TOT", "MD_MASTER", "MD_GRID", "ZIL_PESBRU", "ZIL_QTDTOT", "SUM", { | oFW | .T. },,"Quantidade Total")

Return oModel
/*/{Protheus.doc} getCmps
    Retorna campos do cabe�alho.
    @type  Static Function
    @author Everson
    @since 30/01/2023
    @version 01
/*/
Static Function getCmps()
Return "ZIL_FILIAL;ZIL_PLACA;ZIL_ORDEM;ZIL_AGRUPA;ZIL_CTPATI;ZIL_TPENSA;ZIL_PESADO;ZIL_SEQUEN;"
/*/{Protheus.doc} vldPos
    P�s valida��o.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function vldPos(oModel)

    //Vari�veis.
    Local aArea      := GetArea()
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
    Local cCP        := oModel:GetValue("MD_MASTER", "ZIL_CTPATI")
    Local cNmOrdem   := oModel:GetValue("MD_MASTER", "ZIL_ORDEM")
    Local cPlaca     := oModel:GetValue("MD_MASTER", "ZIL_PLACA")
    Local cPesado    := oModel:GetValue("MD_MASTER", "ZIL_PESADO")
    Local cSeqAtu    := oModel:GetValue("MD_MASTER", "ZIL_SEQUEN")
    Local cTpPesa    := oModel:GetValue("MD_MASTER", "ZIL_TPENSA")
    Local nPesoLiq   := 0
    Local nPLiqT     := 0
    Local cPrdPro    := ""
    Local cPrdSag    := ""
    Local cProduto   := ""
    Local aDdSeq     := {}
    Local cEntSai    := ""
    Local oGrid      := oModel:GetModel("MD_GRID")
    Local nLength    := oGrid:length()
    Local nAux       := 1
    Local nQtdOrd    := 0
    Local cQtdOrd    := ""
    Local aDSeqP     := {}
    Local cTktNv     := ""

    If lRet .And. ! IsInCallStack("U_ADEST735") .And. cPesado <> "2"
        lRet := .F.
        Help(Nil, Nil, "Fun��o vldPos(ADEST073P)",,"A��o n�o permitida, ordem de pesagem j� est� pesada.", 1, 0 )

    EndIf

    If lRet .And. ( nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE ) .And. ! IsInCallStack("U_ADEST735")
        
        aDSeqP  := U_ADEST736(cCP)

        cTktNv  := aDSeqP[1]
        cSeqAtu := aDSeqP[2]

        //Ajusta sequ�ncia de pesagem de ordem de pesagem n�o agrupada.
        lRet := U_ADFAT192(cCP, cNmOrdem, cTktNv, cSeqAtu)
            
        If lRet
            oModel:SetValue("MD_MASTER","ZIL_SEQUEN", cSeqAtu)

        EndIf

        If lRet .And. cTpPesa == "S"
            lRet := U_ADEST737(oModel, cTktNv) //Valida a quantidade e ajusta a quantidade da ordem de pesagem.

        EndIf

        If lRet .And. cTpPesa == "E"

            For nAux := 1 To nLength
                
                oGrid:GoLine(nAux)

                nPesoLiq    := oGrid:GetValue("ZIL_PESLIQ", nAux)
                nPLiqT      += nPesoLiq
                cPrdPro     := oGrid:GetValue("ZIL_PRDPRO", nAux) 
                cPrdSag     := oGrid:GetValue("ZIL_PRDSAG", nAux) 
                cProduto    +=  Alltrim(cValToChar(cPrdPro)) + Space(1) + Alltrim(cValToChar(U_ADFAT176(cPrdSag,""))) + Space(1)

                If nLength > 1
                    nQtdOrd  := U_ADEST730(cNmOrdem, cPrdPro) //Posicione("ZIF", 6, FWxFilial("ZIF") + cNmOrdem + cPrdPro,"ZIF_QUANT")
                    cQtdOrd  := Alltrim(cValToChar(Transform(nQtdOrd, "999,999,999.999")))
                    cProduto += "Qtd.: " + Alltrim(cValToChar(Transform(nPesoLiq, "999,999,999.999"))) + " Ordem:" + cQtdOrd + " Dif: " + Alltrim(cValToChar(Transform(nPesoLiq - nQtdOrd, "999,999,999.999"))) + xPula

                EndIf

            Next nAux
            
            lRet := vldPeso(cNmOrdem, nPLiqT, @aDdSeq, @cEntSai)

            If ! lRet
                lRet := U_ADEST733(aDdSeq, cEntSai, nPLiqT, cNmOrdem, cPlaca, cProduto)

            EndIf

        EndIf

    EndIf

    If lRet .And. nOperation == MODEL_OPERATION_DELETE
        lRet := U_ADEST743(cNmOrdem)

    EndIf
    
    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADEST730
    Obt�m peso da ordem de pesagem.
    @type  Function
    @author Everson
    @since 26/01/2023
    @version 01
/*/
User Function ADEST730(cNmOrdem, cPrdPro)

    //Vari�veis.
    Local aArea     := GetArea()
    Local nPeso     := 0
    Local cQuery    := " SELECT SUM(ZIF_QUANT) AS ZIF_QUANT FROM " + RetSqlName("ZIF") +  " (NOLOCK) AS ZIF WHERE ZIF_FILIAL = '" + FWxFilial("ZIF") + "' AND ZIF_PRDPRO = '" + cPrdPro + "' AND (ZIF_NUMERO = '" + cNmOrdem + "' OR ZIF_AGRUPA = '" + cNmOrdem + "') AND D_E_L_E_T_ = '' "
    Local cAlias    := GetNextAlias()

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), cAlias,.T.,.T.)
    (cAlias)->(DbGoTop())

        nPeso := Val(cValToChar((cAlias)->ZIF_QUANT))

    (cAlias)->(DbCloseArea())

    RestArea(aArea)

Return nPeso
/*/{Protheus.doc} ADEST736
    Obt�m sequ�ncia de pesagem. 
    de produtos ensacados.
    @type  User Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
User Function ADEST736(cCP)
    //Vari�veis.
    Local aArea     := GetArea()
    Local cSeq      := ""
    Local cTicket   := ""
    Local cQuery    := ""

    //Ticket que est� com pesagem inicial.
    cQuery := ""
    cQuery += " SELECT  " 
    cQuery += " MIN(ZIG_NUMERO) AS ZIG_NUMERO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIG") + " (NOLOCK) AS ZIG  " 
    cQuery += " WHERE  " 
    cQuery += " ZIG_FILIAL = '" + FWxFilial("ZIG") + "'  " 
    cQuery += " AND ZIG_CTPATI = '" + cCP + "'  " 
    cQuery += " AND ZIG_INICIA IN ('2','4') " //Peso inicial, pesagem sequestrada.
    cQuery += " AND ZIG.D_E_L_E_T_ = '' " 

    If Select("D_TKT") > 0
        D_TKT->(DbCloseArea())

    EndIf

    TcQuery cQuery New Alias "D_TKT"
    DbSelectArea("D_TKT")

        cTicket   := D_TKT->ZIG_NUMERO

    D_TKT->(DbCloseArea())

    //Menor sequ�ncia de pesagem dispon�vel
    cQuery := ""
    cQuery += " SELECT  " 
    cQuery += " MIN(ZIG_SEQTKT) AS ZIG_SEQTKT "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIG") + " (NOLOCK) AS ZIG  " 
    cQuery += " WHERE  " 
    cQuery += " ZIG_FILIAL = '" + FWxFilial("ZIG") + "'  " 
    cQuery += " AND ZIG_CTPATI = '" + cCP + "'  " 
    cQuery += " AND ZIG_INICIA IN ('1', '2', '4') " //Pesagem n�o iniciada, Peso inicial, sequestrada.
    cQuery += " AND ZIG.D_E_L_E_T_ = '' " 

    If Select("D_SEQ") > 0
        D_SEQ->(DbCloseArea())

    EndIf

    TcQuery cQuery New Alias "D_SEQ"
    DbSelectArea("D_SEQ")

        cSeq := D_SEQ->ZIG_SEQTKT

    D_SEQ->(DbCloseArea())

    RestArea(aArea)

Return {cTicket, cSeq}
/*/{Protheus.doc} vldPeso
    Valida peso informado na confer�ncia 
    de produtos ensacados.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function vldPeso(cNmOrdem, nPesoLiq, aDdSeq, cEntSai)

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local lLib      := .F.

    DbSelectArea("ZIG")
    ZIG->(DbSetOrder(2))
    ZIG->(DbGoTop())
    If ! ZIG->( DbSeek( FWxFilial("ZIG") + cNmOrdem ) )
        Help(Nil, Nil, "Fun��o vldPeso(ADEST073P)",,"Ordem de pesagem/agrupador " + cNmOrdem + " n�o localizada.", 1, 0 )
        RestArea(aArea)
        Return .F.
        
    EndIf

    If ZIG->ZIG_AGRUPA == "1"
        U_ADFAT16F(cNmOrdem)

    Else
        U_ADFAT16A(cNmOrdem)

    EndIf

    cRoteiro := Posicione("ZIB", 1, FWxFilial("ZIB") + ZIF->ZIF_CTPATI, "ZIB_CODROT")
    cProdSAG := ZIF->ZIF_PRDSAG   
    cEntSai  := ZIF->ZIF_TPMOVI

    //U_ADFAT177(cRoteiro, ZIF->ZIF_CTPATI, cProdSAG, ZIG->ZIG_PESORD, nPesoLiq, @aDdSeq)

    lLib := ZIG->ZIG_PESORD == nPesoLiq

    Aadd(aDdSeq, { lLib, "R", "KG", 0, (nPesoLiq - ZIG->ZIG_PESORD), Iif(ZIG->ZIG_PESORD <= 0, 0, ((nPesoLiq - ZIG->ZIG_PESORD)/ZIG->ZIG_PESORD)) * 100, "", ZIG->ZIG_PESORD })

    If Len(aDdSeq) > 0
        lRet := aDdSeq[1][1]

    Else
        Help(Nil, Nil, "Fun��o vldPeso(ADEST073P)",,"N�o foi poss�vel validar a quebra de peso.", 1, 0)

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function ViewDef()
    
    //Vari�veis.
    Local oModel    := FWLoadModel("ADEST073P")
    Local oView     := Nil
    Local cCampos   := getCmps()
    Local oStrMast  := FWFormStruct(2, cTbMast, {|cCampo| AllTRim(cCampo) $ cCampos})
    Local oStrGrid  := FWFormStruct(2, cTbMast, {|cCampo| !(Alltrim(cCampo) $ cCampos)})
    Local oStrTotal := FWCalcStruct( oModel:GetModel("ADEST73TOT") )

    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")
    oView:AddGrid("VW_GRID",    oStrGrid, "MD_GRID")
    oView:AddField("VW_CALC",   oStrTotal,"ADEST73TOT")
 
    oView:CreateHorizontalBox("MAIN", 25)
    oView:CreateHorizontalBox("GRID", 60)
    oView:CreateHorizontalBox("CALC", 15)

    oView:SetOwnerView("VW_MASTER", 'MAIN')
    oView:SetOwnerView("VW_GRID", 'GRID')
    oView:SetOwnerView("VW_CALC", "CALC")

    oView:EnableControlBar(.T.)

    oView:AddUserButton("Carregar Ordens","",{|oView| U_ADEST731(oView) } ,"",, {MODEL_OPERATION_INSERT} , .T. )   
 
    oView:AddIncrementField("VW_GRID", "ZIL_ITEM")

Return oView
/*/{Protheus.doc} ADEST731
    Consulta padr�o customizada.
    @type  User Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
User Function ADEST731(oView)

    //Vari�veis.
    Local aArea     := GetArea()
    Local oModal    := Nil
    Local oContainer:= Nil
    Local oOrdens   := Nil
    Local aOrdens   := {}
    Local oCabec    := oView:GetModel("MD_MASTER")
    Local cPlaca    := Alltrim(cValToChar(oCabec:GetValue("ZIL_PLACA")))

    If Empty(cPlaca)
        Help(,,"Fun��o ADEST731(ADEST073P)",,"Informe a placa do ve�culo.", 1, 0 )
        RestArea(aArea)
        Return Nil

    EndIf

    carOrdEn(@aOrdens, cPlaca)

    If Len(aOrdens) <= 0
        Help(,,"Fun��o ADEST731(ADEST073P)",,"N�o h� ordens de pesagem de ensacados para o ve�culo " + cPlaca + ".", 1, 0 )
        RestArea(aArea)
        Return Nil

    EndIf

    oModal := FWDialogModal():New() 
    oModal:SetBackground( .T. ) 
	oModal:setTitle("Selecionar ordem de pesagem/agrupador")
	oModal:setSize( 150 , 350 )
    oModal:EnableFormBar( .T. )
    oModal:SetEscClose(.F.)
	oModal:createDialog()
    oModal:CreateFormBar()

    oModal:AddButton( "Confirmar", {|| Iif(! prcOrd(aOrdens, cPlaca), Nil, oModal:DeActivate()) }, "Confirmar", , .T., .F., .T., )
    oModal:AddButton( "Cancelar" , {|| oModal:DeActivate() }   , "Cancelar" , , .T., .F., .T., )

        oContainer := TPanel():New(025,,, oModal:getPanelMain())
        oContainer:Align := CONTROL_ALIGN_ALLCLIENT

        oOrdens := FwBrowse():New()
        oOrdens:setOwner(oContainer)
        oOrdens:setDataArray()
        oOrdens:setArray(aOrdens)
        oOrdens:disableConfig()
        oOrdens:disableReport()
    
        oOrdens:AddMarkColumns({|| Iif(aOrdens[oOrdens:nAt,01], "LBOK", "LBNO")},;
                                {|| selecOrd(oOrdens, @aOrdens)},;
                                {|| /*selecTAgr(oOrdens, @aOrdens, @lMarker)*/ })
    
        oOrdens:addColumn({"N�mero"          , {||aOrdens[oOrdens:nAt,02]}, "C", "", 1, 015 , , .T. , , .F.,, "aOrdens[oOrdPes:nAt,02]",, .F., .T., , "ID02" })
        oOrdens:addColumn({"Ordem/Agrupador" , {||aOrdens[oOrdens:nAt,05]}, "C", "", 1, 015 , , .T. , , .F.,, "aOrdens[oOrdPes:nAt,05]",, .F., .T., , "ID05" })
        oOrdens:addColumn({"Tp Ordem"        , {||aOrdens[oOrdens:nAt,03]}, "C", "", 1, 010 , , .T. , , .F.,, "aOrdens[oOrdPes:nAt,03]",, .F., .T., , "ID03" })
        oOrdens:addColumn({"Produto"         , {||aOrdens[oOrdens:nAt,04]}, "C", "", 1, 060 , , .T. , , .F.,, "aOrdens[oOrdPes:nAt,04]",, .F., .T., , "ID04" })
       
        oOrdens:Activate()

	oModal:Activate()

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} selecOrd
    Marca registro.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function selecOrd(oBrowse, aArquivo)

    //Vari�veis.
    Local nLinha    := oBrowse:nAt
    Local cNmOrdem  := aArquivo[nLinha,02]
    Local nAux      := 1

    For nAux := 1 To Len(aArquivo)

        If aArquivo[nAux,02] == cNmOrdem
            aArquivo[nAux,01] := ! aArquivo[nAux,01]

        Else
            aArquivo[nAux,01] := .F.

        EndIf

    Next nAux

    oBrowse:Refresh()

Return Nil
/*/{Protheus.doc} carOrdEn
    Carrega dados das ordens de pesagem.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function carOrdEn(aOrdens, cPlaca)

    //Vari�veis.
    Local aArea      := GetArea()
    Local cQuery     := ""
    Local cDescProd  := ""

    cQuery += " SELECT  DISTINCT " 
        cQuery += " CASE WHEN ZIF_AGRUPA <> '' THEN ZIF_AGRUPA ELSE ZIF_NUMERO END AS ORDEM, " 
        cQuery += " CASE WHEN ZIF_TPMOVI = 'E' THEN 'Entrada' ELSE 'Sa�da' END AS ENT_SAI, " 
        cQuery += " ZIF_TPMOVI, " 
        cQuery += " ZIF_PRDPRO, " 
        cQuery += " ZIF_PRDSAG, " 
        cQuery += " ZIF_STATUS, " 
        cQuery += " ZIF_STATLA, " 
        cQuery += " ZIF_CTPATI, " 
        cQuery += " CASE WHEN ZIF_AGRUPA <> '' THEN 'Agrupador' ELSE 'Ordem' END AS AGR_ORD, ZIB_CODROT " 
    cQuery += " FROM  " 
        cQuery += " " + RetSqlName("ZIF") + " (NOLOCK) AS ZIF  "
        cQuery += " INNER JOIN "  
        cQuery += " " + RetSqlName("ZIB") + " (NOLOCK) AS ZIB ON " 
        cQuery += " ZIF_FILIAL = ZIB_FILIAL " 
        cQuery += " AND ZIF_CTPATI = ZIB_NUMERO " 

    cQuery += " WHERE  " 
        cQuery += " ZIF_FILIAL = '" + FWxFilial("ZIF") + "'  " 
        cQuery += " AND ZIF_PLACA = '" + cPlaca + "'  " 
        cQuery += " AND ZIB_STATUS IN ('4') " 
        cQuery += " AND ZIB_TPMOVI IN ('E','S') " 
        cQuery += " AND ZIF.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY ORDEM " 

    If Select("D_DORD") > 0
        D_DORD->(DbCloseArea())

    EndIf

    DbSelectArea("ZIL")
    ZIL->(DbSetOrder(3))
    ZIL->(DbGoTop())

    DbSelectArea("ZIG")
    ZIG->(DbSetOrder(2))
    ZIG->(DbGoTop())

    TcQuery cQuery New Alias "D_DORD"
    DbSelectArea("D_DORD")
    While ! D_DORD->(Eof())

        If ! vldPesAbt(D_DORD->ZIF_CTPATI)
            D_DORD->(Dbskip())
            Loop

        EndIf

        If (D_DORD->ZIF_STATUS $"5/7" .And. D_DORD->ZIF_TPMOVI == "S");       //Ordem de pesagem de sa�da encerrada/Sequestrada e liberada.
           .Or. (D_DORD->ZIF_STATUS $"11/13" .And. D_DORD->ZIF_TPMOVI == "E") //Ordem de pesagem de entrada encerrada/Sequestrada e liberada.
            D_DORD->(Dbskip())
            Loop

        EndIf

        If ZIL->( DbSeek( FWxFilial("ZIL") + D_DORD->ORDEM ) ) //Ordem de pesagem que j� tenha apontamento de ensacado.
            D_DORD->(Dbskip())
            Loop

        EndIf

        If ! U_ADFAT15B(D_DORD->ZIB_CODROT) //Posiciona no cadastro de roteiro.
            D_DORD->(Dbskip())
            Loop

        EndIf

        If ZI9->ZI9_ENSACA <> "1" //Valida se o roteiro � de produtos ensacados.
            D_DORD->(Dbskip())
            Loop
            
        EndIf

        If ZIG->( DbSeek( FWxFilial("ZIG") + D_DORD->ORDEM ) )
            If ZIG->ZIG_INICIA $"3" //N�o carrega ordens de pesagem com peso final.
                D_DORD->(Dbskip())
                Loop

            EndIf

        EndIf

        cDescProd := Alltrim(Posicione("ZIM",1, FWxFilial("ZIM") + D_DORD->ZIF_PRDSAG, "ZIM_DESSAG"))
        Aadd(aOrdens,{.F., D_DORD->ORDEM, D_DORD->ENT_SAI, cDescProd, D_DORD->AGR_ORD, D_DORD->ZIF_TPMOVI, D_DORD->ZIF_CTPATI, D_DORD->ZIF_PRDSAG, D_DORD->ZIF_PRDPRO})
        
        D_DORD->(Dbskip())

    End

    D_DORD->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} vldPesAbt
    Valida apontamento de ensacado lan�ado mas n�o pesado.
    @type  Static Function
    @author Everson
    @since 22/06/2022
    @version 01
/*/
Static Function vldPesAbt(cCP)

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cQuery    := ""

    cQuery := ""
    cQuery += " SELECT " 
        cQuery += " ZIL_ORDEM " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZIL") + " (NOLOCK) AS ZIL " 
        cQuery += " INNER JOIN " 
        cQuery += " " + RetSqlName("ZIG") + " (NOLOCK) AS ZIG ON " 
        cQuery += " ZIL_FILIAL = ZIG_FILIAL " 
        cQuery += " AND ZIL_ORDEM = ZIG_ORDEM " 
    cQuery += " WHERE " 
        cQuery += " ZIL_FILIAL = '" + FWxFilial("ZIL") + "' " 
        cQuery += " AND ZIG_CTPATI = '" + cCP + "' " 
        cQuery += " AND ZIL.D_E_L_E_T_ = '' " 
        cQuery += " AND ZIL_PESADO = '2' " 

    If Select("D_VLPABT") > 0
        D_VLPABT->(DbCloseArea())

    EndIf

    TcQuery cQuery New Alias "D_VLPABT"
    DbSelectArea("D_VLPABT")

        lRet := D_VLPABT->(Eof())

    D_VLPABT->(DbCloseArea())

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} prcOrd
    Processa ordens selecionadas.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function prcOrd(aOrdens, cPlaca)

    //Vari�veis.
    Local aArea     := GetArea()
    Local nAux      := 1
    Local oView     := FWViewActive()
    Local oGrid     := oView:GetModel("MD_GRID")
    Local cNmOrdem  := ""
    Local cCP       := ""
    Local cEntSai   := ""
    Local cPrdPro   := ""
    Local cPrdSAG   := ""
    Local cDesProd  := ""
    Local lAgrupa   := .F.

    oGrid:setNoInsertLine(.F.)
    oGrid:setNoDeleteLine(.F.)

    U_ADEST732() //Apaga grid.

    For nAux := 1 To Len(aOrdens)

        If ! aOrdens[nAux][1]
            Loop

        EndIf

        If Empty(cNmOrdem)
            cNmOrdem := aOrdens[nAux,2]
            cCP      := aOrdens[nAux,7]
            cEntSai  := aOrdens[nAux,6]

            If U_ADFAT16F(cNmOrdem)
                lAgrupa := .T.

            EndIf

            FWFldPut("ZIL_ORDEM",cNmOrdem)
            FWFldPut("ZIL_CTPATI",cCP)
            FWFldPut("ZIL_TPENSA",cEntSai)
            FWFldPut("ZIL_PESADO","2")
            FWFldPut("ZIL_AGRUPA",Iif(lAgrupa,"1","2"))

        EndIf

        If nAux > 1
            oGrid:addLine()

        EndIf
        
        cPrdPro   := aOrdens[nAux,9]  
        cPrdSAG   := aOrdens[nAux,8]
        cDesProd  := aOrdens[nAux,4]

        oGrid:loadValue("ZIL_PLACA",  cPlaca)
        oGrid:loadValue("ZIL_ORDEM",  cNmOrdem)
        oGrid:loadValue("ZIL_CTPATI", cCP)
        oGrid:loadValue("ZIL_TPENSA", cEntSai)
        oGrid:loadValue("ZIL_PRDPRO", cPrdPro)
        oGrid:loadValue("ZIL_PRDSAG", cPrdSAG)
        oGrid:loadValue("ZIL_DESPRO", cDesProd)
        oGrid:loadValue("ZIL_PESADO", "2")

    Next nAux

    oGrid:setNoInsertLine(.T.)
    oGrid:setNoDeleteLine(.T.)

    oGrid:goLine(1)

    oView:refresh()

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} ADEST732
    Apaga dados da grid.
    @type  User Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
User Function ADEST732() // U_ADEST732()

    //Vari�veis.
    Local oView  := FWViewActive()
    Local oGrid  := Nil

    oGrid := oView:GetModel("MD_GRID")
    oGrid:ClearData(.F.,.T.)

    oGrid:goLine(1)

    oView:refresh()

Return oGrid:length() == 1
/*/{Protheus.doc} ADEST733
    Interface de contrassenha.
    @type  User Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
User Function ADEST733(aDdSeq, cEntSai, nPesoLiq, cNmOrdem, cPlaca, cProduto)

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local oModal    := Nil
    Local oContainer:= Nil
    Local cCodSol   := Alltrim(cValToChar(__cUserID))
    Local cSolic    := UsrFullName(__cUserID)
    Local cMotivo   := Space(100)
    Local nValor    := nPesoLiq
    Local nLimite   := aDdSeq[1][8]
    Local nDife     := aDdSeq[1][5]
    Local cNumLib   := ""
    Local cMsg      := ""

    If U_ADEST745(cNmOrdem)
        If ZID->ZID_STATUS == "1"
            excLib("", ZID->ZID_NUMERO)

        EndIf

    EndIf

    oModal := FWDialogModal():New() 
    oModal:SetBackground( .T. ) 
	oModal:setTitle("Ordens de Carregamento - " + cPlaca)
	oModal:setSize( 150 , 350 )
    oModal:EnableFormBar( .T. )
    oModal:SetEscClose(.F.)
	oModal:createDialog()
    oModal:CreateFormBar()
    oModal:addCloseButton(Nil, "Cancelar")

    oModal:AddButton( "Solicitar", {|| solicLib("", cNmOrdem, nValor, nLimite, nDife, @cNumLib, cPlaca, cProduto, cMotivo) }, "Confirmar", , .T., .F., .T., )
    oModal:AddButton( "Verificar" , {|| Iif(! verifLib(@lRet, cNumLib), Nil, oModal:DeActivate()) }  , "Solicitar" , , .T., .F., .T., )

        oContainer := TPanel():New(025,,, oModal:getPanelMain())
        oContainer:Align := CONTROL_ALIGN_ALLCLIENT
        TGet():New(010,010,{|u|If(PCount() == 0,cCodSol,cCodSol := u)}  ,oContainer,125,015,"",,0,16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"cCodSol",,,,.T.,,,"Cod. Solicitante",1)
        TGet():New(010,140,{|u|If(PCount() == 0,cSolic ,cSolic := u)}   ,oContainer,125,015,"",,0,16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"cSolic",,,,.T.,,,"Solicitante",1) 

        TGet():New(040,010,{|u|If(PCount() == 0,cMotivo,cMotivo := u)}  ,oContainer,255,015,"",,0,16777215,,.F.,,.T.,,.F.,{|| Empty(cNumLib) },.F.,.F.,,.F.,.F. ,,"cMotivo",,,,.T.,,,"Motivo",1)  
        
        TGet():New(070,010,{|u|If(PCount() == 0,cNumLib,cNumLib := u)}  ,oContainer,125,015,"",,0,16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"cNumLib",,,,.T.,,,"Solicita��o",1)  

    oModal:Activate()
    
    cMsg := "A confer�nca de ensacados n�o p�de ser salva, pois a quebra de peso necessita de aprova��o."

    If ! Empty(cNumLib) 
    
        If excLib("", cNumLib)
            Help(Nil, Nil, "Fun��o ADEST733(ADEST073P)", Nil, cMsg, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

    Else
        Help(Nil, Nil, "Fun��o ADEST733(ADEST073P)", Nil, cMsg, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
    
    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} solicLib
    Solicita��o de aprova��o de libera��o de produtos ensacados.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function solicLib(cMsgError, cNmOrdem, nValor, nLimite, nDife, cNumLib, cPlaca, cProduto, cMotivo)

    //Vari�veis.
    Local aArea := GetArea()

    Default cMsgError := ""

    If ! Empty(cNumLib)
        MsgInfo("J� h� a solicita��o " + cNumLib + ".", "Fun��o solicLib(ADEST073P)")
        RestArea(aArea)
        Return Nil  

    EndIf

    If Empty(cMotivo)
        MsgInfo("Necess�rio informar o motivo.", "Fun��o solicLib(ADEST073P)")
        RestArea(aArea)
        Return Nil  

    EndIf

    If U_ADEST745(cNmOrdem)
        If ZID->ZID_STATUS == "1"
            excLib("", ZID->ZID_NUMERO)

        EndIf

    EndIf

    U_ADEST746(cPlaca, cNmOrdem, cProduto, nValor, nLimite, nDife, cMotivo, @cNumLib, @cMsgError)

Return Nil
/*/{Protheus.doc} excLib
    Exclui a solicita��o de aprova��o de libera��o de produtos ensacados.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function excLib(cMsgError, cNumLib)

    //Vari�veis.
    Local aArea := GetArea()
    Local lRet  := .F.
    Local oSolic:= Nil

    Default cMsgError := ""

    DbSelectArea("ZID")
    ZID->(DbSetOrder(1))
    If ! ZID->(DbSeek( FWxFilial("ZID") + cNumLib ))
        RestArea(aArea)
        Return .F.

    EndIf

    If ZID->ZID_STATUS <> "1"
        RestArea(aArea)
        Return .F.

    EndIf

    oSolic := FwLoadModel("ADEST074P")

    oSolic:SetOperation(MODEL_OPERATION_DELETE)
    oSolic:Activate() 

    Begin Transaction

        If oSolic:VldData()
            oSolic:CommitData()
            lRet := .T.

        Else
            aError := oSolic:GetErrorMessage()
            cMsgError := Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))

        EndIf

    End Transaction

    oSolic:DeActivate()
    oSolic:Destroy()
    oSolic := Nil

    If ! Empty(cMsgError)
        Help(Nil, Nil, "Fun��o excLib(ADEST073P)", Nil, "Erro na exclus�o do registro de solicita��o de libera��o." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} verifLib
    Verifica a solicita��o de aprova��o de libera��o de produtos ensacados.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function verifLib(lRet, cNumLib)

    //Vari�veis.
    Local aArea := GetArea()

    lRet := .F.

    If Empty(cNumLib)
        MsgInfo("Necess�rio gerar a solicita��o de libera��o.","Fun��o verifLib(ADEST073P)")
        RestArea(aArea)
        Return .F.

    EndIF

    DbSelectArea("ZID")
    ZID->(DbSetOrder(1))
    If  ! ZID->(DbSeek( FWxFilial("ZID") + cNumLib ))
        MsgInfo("Solicita��o de libera��o " + cNumLib + " n�o localizada.","Fun��o verifLib(ADEST073P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If ZID->ZID_STATUS == "1"
        MsgInfo("Solicita��o de libera��o " + cNumLib + " n�o passou pelo processo de aprova��o.","Fun��o verifLib(ADEST073P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If ZID->ZID_STATUS == "2"
        lRet := .T.
        MsgInfo("Solicita��o de libera��o " + cNumLib + " aprovada.","Fun��o verifLib(ADEST073P)")
        RestArea(aArea)
        Return .T.

    EndIf

    If ZID->ZID_STATUS == "3"
        lRet := .F.
        MsgInfo("Solicita��o de libera��o " + cNumLib + " reprovada.","Fun��o verifLib(ADEST073P)")
        RestArea(aArea)
        Return .T.

    EndIf

    RestArea(aArea)

Return .F.
/*/{Protheus.doc} ADEST735
    Atualiza.
    @type  User Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
User Function ADEST735(cNmOrdem, nIndex, cCampo, xValor, cMsgError, lExibe)

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local oModel    := Nil
    
    Default cMsgError := ""
    Default lExibe    := .F.
    
    DbSelectArea("ZIL")
    ZIL->(DbSetOrder(nIndex))
    If ! ZIL->(DbSeek( FWxFilial("ZIL") + cNmOrdem ))
        cMsgError := "Registro " + cNmOrdem + " n�o encontrado. N�o h� apontamento de ensacados."

        If lExibe
            Help(Nil, Nil, "Fun��o ADEST735(ADFAT017P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

        RestArea(aArea)
        Return lRet

    EndIf

    oModel := FwLoadModel("ADEST073P")
    oModel:SetOperation(MODEL_OPERATION_UPDATE)
    oModel:Activate()
    oModel:SetValue("MD_MASTER", cCampo, xValor)
    oModel:SetValue("MD_GRID", cCampo, xValor)

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

    If ! Empty(cMsgError) .And. lExibe
        Help(Nil, Nil, "Fun��o ADEST735(ADEST073P)", Nil, "Erro na atualiza��o de registro de confer�ncia de ensacado " + cNmOrdem + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADEST737
    Valida quantidade de sa�da.
    @type  User Function
    @author Everson
    @since 20/06/2022
    @version 01
/*/
User Function ADEST737(oModel, cTicket)

    //Vari�veis.
    Local aArea    := GetArea()
    Local lRet     := .T.
    Local oGrid    := oModel:GetModel("MD_GRID")
    Local nLength  := oGrid:length()
    Local nAux     := 1
    Local cNmOrdem := oGrid:GetValue("ZIL_ORDEM")
    Local cAgrupa  := oGrid:GetValue("ZIL_AGRUPA")
    Local nPesLiq  := 0
    Local nPesoTot := 0
    Local cProdSAG := ""
    Local cMsgError:= ""

    DbSelectArea("ZIF")

    If cAgrupa == "1"
        ZIF->(DbSetOrder(5))

    Else
        ZIF->(DbSetOrder(2))

    EndIf

    ZIF->(DbGoTop())

    Begin Transaction

        For nAux := 1 To nLength

            oGrid:GoLine(nAux)

            nPesLiq  := oGrid:GetValue("ZIL_PESLIQ")
            cProdSAG := oGrid:GetValue("ZIL_PRDSAG")

            nPesoTot += nPesLiq
            
            If nPesLiq <= 0
                cMsgError := "Produto " + cProdSAG + " est� com peso inv�lido."
                lRet := .F.
                DisarmTransaction()
                Break

            EndIf
            
            aRet := getPOrd(cNmOrdem, cProdSAG)

            If nPesLiq > aRet[2]
                cMsgError := "Produto " + cProdSAG + " est� com apontamento de peso maior que o pedido de sa�da."
                lRet := .F.
                DisarmTransaction()
                Break

            EndIf

            If ! U_ADFAT165(aRet[1], "ZIF_QUANT", nPesLiq) //Ajusta quantidade da ordem de pesagem.
                lRet := .F.
                DisarmTransaction()
                Break

            EndIf

        Next nAux

        If ! U_ADFAT191(cTicket, "ZIG_PESORD", nPesoTot, @cMsgError) //Altera a quantidade da ordem no ticket de pesagem.
            DisarmTransaction()
            Break

        EndIf

    End Transaction
    
    If ! Empty(cMsgError)
        Help(Nil, Nil, "Fun��o ADEST737(ADEST073P)",, cMsgError, 1, 0)

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} getPOrd
    Valida quantidade.
    @type  Static Function
    @author Everson
    @since 20/06/2022
    @version 01
/*/
Static Function getPOrd(cNmOrdem, cProdSAG)

    //Vari�veis.
    Local aArea     := GetArea()
    Local nPeso     := 0
    Local cOrdem    :=  ""
    Local lAgrupa   := .F.
    Local cQuery    := ""

    If U_ADFAT16F(cNmOrdem)
        lAgrupa := .T.

    EndIf

    cQuery := ""
    cQuery += " SELECT " 
        cQuery += " ZIF_NUMERO, SUM(C6_UNSVEN) AS C6_UNSVEN " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZIF") + " (NOLOCK) AS ZIF " 
        cQuery += " INNER JOIN "
        cQuery += " " + RetSqlName("SC6") + " (NOLOCK) AS SC6 ON "
        cQuery += " ZIF_FILIAL = C6_FILIAL "
        cQuery += " AND ZIF_NUMERO = C6_XORDPES "

    cQuery += " WHERE " 
        cQuery += " ZIF_FILIAL = '" + FWxFilial("ZIF") + "' " 
        cQuery += " AND ZIF_PRDSAG = '" + cProdSAG + "' "

        If ! lAgrupa
            cQuery += " AND ZIF_NUMERO = '" + cNmOrdem + "' "

        Else 
            cQuery += " AND ZIF_AGRUPA = '" + cNmOrdem + "' " 

        EndIf

        cQuery += " AND ZIF.D_E_L_E_T_ = '' " 
        cQuery += " AND SC6.D_E_L_E_T_ = '' " 

    cQuery += " GROUP BY ZIF_NUMERO " 

    TcQuery cQuery New Alias "QTD_ORD"
    DbSelectArea("QTD_ORD")

        cOrdem   := QTD_ORD->ZIF_NUMERO
        nPeso    := Val(cValToChar(QTD_ORD->C6_UNSVEN))

    QTD_ORD->(DbCloseArea())

    RestArea(aArea)

Return {cOrdem, nPeso}
/*/{Protheus.doc} ADEST738
    Posiciona no registro pela ordem/agrupamento.
    @type  User Function
    @author Everson
    @since 21/06/2022
    @version 01
/*/
User Function ADEST738(cNmOrdem)

    DbSelectArea("ZIL")
    ZIL->(DbSetOrder(3))
    If ! ZIL->( DbSeek( FWxFilial("ZIL") + cNmOrdem))
        Return .F.

    EndIf

Return .T.
/*/{Protheus.doc} ADEST738
    Abre registro.
    @type  User Function
    @author Everson
    @since 22/07/2022
    @version 01
/*/
User Function ADEST739(cNmOrdem, cMsgError)

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.

    Default cMsgError := ""

    If ! U_ADEST738(cNmOrdem)
        RestArea(aArea)
        Return .T.

    EndIf

    If ZIL->ZIL_PESADO == "2"
        RestArea(aArea)
        Return .T.

    EndIf

    lRet := U_ADEST735(cNmOrdem, 3, "ZIL_PESADO", "2", @cMsgError, .F.)

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADEST73
    Ponto de entrada.
    @type  User Function
    @author Everson
    @since 28/01/2023
    @version 01
/*/
User Function ADEST73()

    //Vari�veis.
    Local aArea     := GetArea()
	Local aParam	:= PARAMIXB
	Local xRet 		:= .T.
	Local oObj 		:= ""
	Local cIdPonto 	:= ""
	Local cIdModel 	:= ""
    Local nOperation:= 0
    Local cNmOrdem   := ""

	If aParam <> Nil

		oObj 	    := aParam[1]
		cIdPonto    := aParam[2]
		cIdModel    := aParam[3]
        nOperation  := oObj:GetOperation()

		If cIdPonto == "MODELCOMMITNTTS"

            cNmOrdem := oObj:GetValue("MD_MASTER", "ZIL_ORDEM")

            If nOperation == MODEL_OPERATION_INSERT
                cOperacao := "I"

            ElseIf nOperation == MODEL_OPERATION_UPDATE
                cOperacao := "A"

            ElseIf nOperation == MODEL_OPERATION_DELETE
                cOperacao := "D"

            EndIf

            If ! Empty(cOperacao) .And. ! Empty(cNmOrdem)
                grvBarr(cOperacao, cNmOrdem)

            EndIf

		EndIf

	EndIf

    RestArea(aArea)

Return xRet
/*/{Protheus.doc} grvBarr
    Salva o registro para enviar ao barramento.
    @type  Static Function
    @author Everson
    @since 28/01/2023
    @version 01
/*/
Static Function grvBarr(cOperacao, cNmOrdem)
    
    //Vari�veis.
    Local aArea   := GetArea()
    Local cFilter := " ZIL_FILIAL ='" + FWxFilial("ZIL") + "' .And. ZIL_ORDEM = '" + cNmOrdem + "' "
    Local cTopico := "conferencia_ensacados_protheus"
    Local cCmp    := getCmps()

    U_ADFAT27D("ZIL", 3, FWxFilial("ZIL") + cNmOrdem,;
        "ZIL", 5, FWxFilial("ZIL") + cNmOrdem, "ZIL_ITEM", cFilter,;
        cTopico, cOperacao,;
        .T., .T., .T.,;
        cCmp) 

    RestArea(aArea)

Return Nil
