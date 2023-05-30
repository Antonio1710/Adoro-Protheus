#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static cTbMast  := "ZIP"
Static cTitulo  := "Programação de Recebimento de MP"
Static cTiMast  := "Dados da programação de recebimento de MP"
Static xPula    := Chr(13) + Chr(10)

/*/{Protheus.doc} User Function ADCOM045P
    Programação de Recebimento de MP.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 29/12/2022
    @version 01
    @history Everson, 09/01/2023 - ticket 18465 - Envio de registro para o barramento.
    @history Everson, 18/01/2023 - ticket 18465 - Adicionado campo de bloqueio de entrada de matéria-prima.
    @history Everson, 09/03/2023 - ticket 18465 - Alterada validação de bloqueio de quantiade para pedido.
    @history Everson, 09/03/2023 - ticket 18465 - Adicionada função para inclusão de registros em lote.
/*/
User Function ADCOM045P() // U_ADCOM045P()

    //Variáveis.
    Local oBrowse := FwLoadBrw("ADCOM045P")

    oBrowse:Activate() 

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 29/12/2022
    @version 01
/*/
Static Function BrowseDef()

    //Variáveis.
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetDescription(cTitulo)

    oBrowse:SetMenuDef("ADCOM045P")

    oBrowse:SetFilterDefault(" " + cTbMast + "_FILIAL = '" + FWxFilial(cTbMast) + "' ")

Return oBrowse
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 29/12/2022
    @version 01
/*/
Static Function MenuDef()

    //Variáveis.
	Local aRotina 	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PesqBrw"          	OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.ADCOM045P" 	OPERATION MODEL_OPERATION_VIEW      ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" 	    ACTION "VIEWDEF.ADCOM045P" 	OPERATION MODEL_OPERATION_INSERT    ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.ADCOM045P" 	OPERATION MODEL_OPERATION_UPDATE    ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" 	    ACTION "VIEWDEF.ADCOM045P" 	OPERATION MODEL_OPERATION_DELETE    ACCESS 0

	ADD OPTION aRotina TITLE "Gerar Lote" 	ACTION "U_ADCOM454()" 	    OPERATION 11    ACCESS 0

    ADD OPTION aRotina TITLE "Env Barramento" ACTION 'MsAguarde({|| U_ADCOM453() }, "Aguarde", "Enviando...")'       OPERATION 13  ACCESS 0

Return aRotina
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 07/12/2021
    @version 01
/*/
Static Function ModelDef()
    
    //Variáveis.
    Local oModel    := Nil
    Local oStrMast  := FWFormStruct(1, cTbMast, {|cCampo| AllTRim(cCampo) $ getCmps()})
    Local oStrGrid  := FWFormStruct(1, cTbMast)
    Local bPost     := {|oModel| vldPos(oModel) }
    Local bLinhaOk  := {|oModel| fValidGrid(oModel) }
 
    oModel := MPFormModel():New("ADCOM45", /*bPreValidacao*/, bPost, /*bCommit*/, /*bCancel*/ )
 
    oModel:AddFields("MD_MASTER", NIL, oStrMast)
    oModel:AddGrid("MD_GRID", "MD_MASTER", oStrGrid,, bLinhaOk)
 
    oModel:SetRelation("MD_GRID", {;
            {"ZIP_FILIAL", 'FWxFilial("' + cTbMast + '")'},;
            {"ZIP_PEDIDO", "ZIP_PEDIDO"},;
            {"ZIP_ITMPED", "ZIP_ITMPED"},;
            {"ZIP_PRODUT", "ZIP_PRODUT"},;
            {"ZIP_DESPRT", "ZIP_DESPRT"},;
            {"ZIP_QTDPED", "ZIP_QTDPED"},;
            {"ZIP_BLQENT", "ZIP_BLQENT"}; //Everson, 18/01/2023 - ticket 18465.
        }, (cTbMast)->(IndexKey(2)))

    oModel:SetPrimaryKey({})

    oModel:SetDescription(cTitulo)

    oModel:GetModel("MD_MASTER"):SetDescription(cTiMast)

    oModel:AddCalc("ADCOM045TOT", "MD_MASTER", "MD_GRID", "ZIP_QUANT", "ZIP_QTDTOT", "SUM", { | oFW | .T. },,"Qtd Total")
    oModel:AddCalc("ADCOM045TOT", "MD_MASTER", "MD_GRID", "ZIP_QUANT", "ZIP_PERTOT", "FORMULA", { || .T. },,"% Total", {|oModel| calcPer(oModel) })

Return oModel
/*/{Protheus.doc} gridFocus
    Função executada quando a grid ganha foco.
    @type  Static Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
Static Function gridFocus(oView)

    //Variáveis.
    Local aArea   := GetArea()
    Local oModel  := oView:GetModel()
    Local cPedido := oModel:GetValue("MD_MASTER", "ZIP_PEDIDO")
    Local nQtd    := oModel:GetValue("MD_MASTER", "ZIP_QTDPED")
    Local cBlq    := Alltrim(cValToChar(oModel:GetValue("MD_MASTER","ZIP_BLQENT"))) //Everson - 18/01/2023 - Ticket 18465.
    Local nOperation := oModel:GetOperation()

    //Everson - 18/01/2023 - Ticket 18465.
    If (nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE) .And. Empty(cBlq)
        Help(Nil, Nil, "Função gridFocus(ADCOM045P)", Nil, "Necessário definir se a programação de entrega irá bloquear a entrada de matéria-prima.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZIP_PEDIDO"):OCtrl:SetFocus()
        Restarea(aArea)
        Return .F.
        
    EndIf

    If Empty(cPedido)
        Help(Nil, Nil, "Função gridFocus(ADCOM045P)", Nil, "Necessário selecionar o pedido.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZIP_PEDIDO"):OCtrl:SetFocus()
        Restarea(aArea)
        Return .F.

    EndIf

    If nOperation == MODEL_OPERATION_INSERT .And. U_ADCOM452(cPedido)
        Help(Nil, Nil, "Função gridFocus(ADCOM045P)", Nil, "Já há programação de entrega para o pedido de compra " + cPedido + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZIP_PEDIDO"):OCtrl:SetFocus()
        Restarea(aArea)
        Return .F.
        
    EndIf

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    SC7->(DbGoTop())
    If ! SC7->(DbSeek( FWxFilial("SC7") + cPedido ))
        Help(Nil, Nil, "Função gridFocus(ADCOM045P)", Nil, "Pedido não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZIP_PEDIDO"):OCtrl:SetFocus()
        Restarea(aArea)
        Return .F.

    EndIf

    If nQtd <= 0
        Help(Nil, Nil, "Função gridFocus(ADCOM045P)", Nil, "Pedido sem quantidade.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZIP_PEDIDO"):OCtrl:SetFocus()
        Restarea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} calcPer
    (long_description)
    @type  Static Function
    @author Everson
    @since 05/01/2023
    @version 01
/*/
Static Function calcPer(oModel)

    //Variáveis.
    Local nPerc   := 0
    Local nQtdPed := Val(cValToChar(oModel:GetValue("MD_MASTER","ZIP_QTDPED")))
    Local nQtd    := Val(cValToChar(oModel:GetValue("ADCOM045TOT","ZIP_QTDTOT")))

    If nQtdPed > 0
        nPerc := 100*(nQtd/nQtdPed)

    EndIf

Return nPerc
/*/{Protheus.doc} getCmps
    Retorna campos do cabeçalho.
    @type  Static Function
    @author Everson
    @since 04/01/2023
    @version 01
/*/
Static Function getCmps()
Return "ZIP_FILIAL;ZIP_PEDIDO;ZIP_ITMPED;ZIP_PRODUT;ZIP_DESPRT;ZIP_QTDPED;ZIP_BLQENT;" //Everson, 18/01/2023 - ticket 18465.
/*/{Protheus.doc} vldPos
    Pós validação.
    @type  Static Function
    @author Everson
    @since 29/12/2022
    @version 01
/*/
Static Function vldPos(oModel)

    //Variáveis.
    Local aArea      := GetArea()
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
    // Local cPedido    := oModel:GetValue("MD_MASTER", "ZIP_PEDIDO")
    // Local cItem      := oModel:GetValue("MD_MASTER", "ZIP_ITMPED")
    Local nQtdPed    := Val(cValToChar(oModel:GetValue("MD_MASTER","ZIP_QTDPED")))
    Local nQtd       := Val(cValToChar(oModel:GetValue("ADCOM045TOT","ZIP_QTDTOT")))
    Local cBlq       := Alltrim(cValToChar(oModel:GetValue("MD_MASTER","ZIP_BLQENT")))

    If lRet .And. (nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE)

        If lRet .And. nQtd > nQtdPed
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADCOM045P)", Nil, "Quantidade programada é maior que a quantidade do pedido.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

        //Everson, 18/01/2023 - ticket 18465.
        If lRet .And. Empty(cBlq)
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADCOM045P)", Nil, "Necessário definir se a programação de entrega irá bloquear a entrada de matéria-prima.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

        // If (obtQtdUs(nOperation, cPedido, cItem) - nQuant) < 0
        //     lRet := .F.
        //     Help(Nil, Nil, "Função vldPos(ADCOM045P)", Nil, "Não há saldo suficiente no pedido de compra para agendamento.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        // EndIf

    EndIf
    
    RestArea(aArea)

Return lRet
/*/{Protheus.doc} obtQtdUs
    Retorna saldo disponível do pedido de compra.
    @type  Static Function
    @author Everson
    @since 29/12/2022
    @version 01
/*/
Static Function obtQtdUs(nOperation, cPedido, cItem)

    //Variáveis.
    Local aArea         := GetArea()
    Local nSaldo        := 0
    Local cQuery        := ""
    Local cNextAlias    := GetNextAlias()

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    SC7->(DbGoTop())
    If ! SC7->(DbSeek( FWxFilial("SC7") ))
        Help(Nil, Nil, "Função vldPos(ADCOM045P)", Nil, "Pedido/item não localizado " + cPedido + cItem + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return 0

    EndIf

    nSaldo := SC7->C7_QUANT
    
    cQuery := " SELECT "
        cQuery += " SUM(ZIP_QUANT) AS ZIP_QUANT "
    cQuery += " FROM "
        cQuery += " " + RetSqlName("ZIP") + " (NOLOCK) AS ZIP "
    cQuery += " WHERE "
        cQuery += " ZIP_FILIAL = '" + FWxFilial("ZIP") + "' "
        cQuery += " AND ZIP_PEDIDO = '" + cPedido + "' "
        cQuery += " AND ZIP_ITMPED = '" + cItem + "' "

        If nOperation ==  MODEL_OPERATION_UPDATE
            cQuery += " AND ZIP.R_E_C_N_O_ <> " + cValToChar(ZIP->(Recno())) + " "

        EndIf

        cQuery += " AND ZIP.D_E_L_E_T_ = '' "

    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNextAlias, .F., .T.)
    (cNextAlias)->(DbGoTop())

        nSaldo -= Val(cValToChar((cNextAlias)->ZIP_QUANT))

    (cNextAlias)->(DbCloseArea())

    RestArea(aArea)

Return nSaldo
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 29/12/2022
    @version 01
/*/
Static Function ViewDef()
    
    //Variáveis.
    Local oView     := Nil
    Local oModel    := FWLoadModel('ADCOM045P')
    Local cCampos   := getCmps()
    Local oStrMast  := FWFormStruct(2, cTbMast, {|cCampo| AllTRim(cCampo)   $ cCampos})
    Local oStrGrid  := FWFormStruct(2, cTbMast, {|cCampo| !(Alltrim(cCampo) $ cCampos)})
    Local oQtdTotal := FWCalcStruct( oModel:GetModel("ADCOM045TOT") )

    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")
    oView:AddGrid("VW_GRID",    oStrGrid, "MD_GRID",,{|| gridFocus(oView) })
    oView:AddField("VW_CALC",   oQtdTotal,"ADCOM045TOT")
 
    oView:CreateHorizontalBox("MAIN", 20)
    oView:CreateHorizontalBox("GRID", 65)
    oView:CreateHorizontalBox("CALC", 15)

    oView:SetOwnerView("VW_MASTER", 'MAIN')
    oView:SetOwnerView("VW_GRID", 'GRID')
    oView:SetOwnerView("VW_CALC", "CALC")

    oView:EnableControlBar(.T.)
 
    oView:AddIncrementField("VW_GRID", "ZIO_ITEM")

    oView:SetViewProperty( "VW_GRID" , "ENABLENEWGRID" )
    oView:SetViewProperty( "VW_GRID", "GRIDFILTER", {.T.}) 
    oView:SetViewProperty( "VW_GRID", "GRIDSEEK", {.T.})

    oView:AddIncrementField("VW_GRID", "ZIP_ITEM")

Return oView
/*/{Protheus.doc} fValidGrid
    Valida linha.
    @type  Static Function
    @author Everson
    @since 04/01/2023
    @version 01
/*/
Static Function fValidGrid(oModelGRID)

    //Variáveis.
    Local lRet       := .T.
 
Return lRet
/*/{Protheus.doc} User Function ADCOM450
    Retorna se há programação e a quatidade programada a ser recebida de determinado produto em uma data.
    @type  Function
    @author Everson
    @since 29/12/2022
    @version 01
/*/
User Function ADCOM450(cData, cPedido, cItem, cProduto, nQtdPrg)

    //Variáveis.
    Local aArea         := GetArea()
    Local cQuery        := ""
    Local cNextAlias    := GetNextAlias()

    cQuery := " SELECT "
        cQuery += " SUM(ZIP_QUANT) AS ZIP_QUANT "
    cQuery += " FROM "
        cQuery += " " + RetSqlName("ZIP") + " (NOLOCK) AS ZIP "
    cQuery += " WHERE "
        cQuery += " ZIP_FILIAL = '" + FWxFilial("ZIP") + "' "
        cQuery += " AND ZIP_DTENTR = '" + cData + "' "
        cQuery += " AND ZIP_PEDIDO = '" + cPedido + "' "
        cQuery += " AND ZIP_ITMPED = '" + cItem + "' "
        cQuery += " AND ZIP_PRODUT = '" + cProduto + "' "
        cQuery += " AND ZIP_BLQENT = '1' " //Everson, 18/01/2023 - ticket 18465.
        cQuery += " AND ZIP.D_E_L_E_T_ = '' "

    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNextAlias, .F., .T.)
    (cNextAlias)->(DbGoTop())

    If (cNextAlias)->(Eof()) .Or. Val(cValToChar((cNextAlias)->ZIP_QUANT)) == 0
        (cNextAlias)->(DbCloseArea())
        RestArea(aArea)
        Return .F.

    EndIf

    nQtdPrg := Val(cValToChar((cNextAlias)->ZIP_QUANT))

    (cNextAlias)->(DbCloseArea())

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADCOM451
    Valida percentual.
    @type  Function
    @author Everson
    @since 05/01/2023
    @version 01
/*/
User Function ADCOM451(nQtd) //U_ADCOM451(M->ZIP_QUANT)

    //Variáveis.
    Local aArea    := GetArea()
    Local nPerc    := 0
    Local oModel   := FWModelActive()
    Local nTotPed  := oModel:GetValue("MD_MASTER", "ZIP_QTDPED")

    If nTotPed > 0
        nPerc := (nQtd/nTotPed)*100

    EndIf
    
    RestArea(aArea)

Return nPerc
/*/{Protheus.doc} ADCOM45
    Ponto de entrada.
    @type  User Function
    @author Everson
    @since 09/01/2022
    @version 01
/*/
User Function ADCOM45()

    //Variáveis.
    Local aArea     := GetArea()
	Local aParam	:= PARAMIXB
	Local xRet 		:= .T.
	Local oObj 		:= ""
	Local cIdPonto 	:= ""
	Local cIdModel 	:= ""
    Local oModelx   := Nil
    Local nOperation:= 0
    Local cPedido   := ""
    Local cItem     := ""

	If aParam <> Nil

		oObj 	    := aParam[1]
		cIdPonto    := aParam[2]
		cIdModel    := aParam[3]
        nOperation  := oObj:GetOperation()

		If cIdPonto == "MODELCOMMITNTTS"

            oModelx := FWModelActive()

            If ValType(oModelx) == "O"

                cPedido := oModelx:GetValue("MD_MASTER", "ZIP_PEDIDO")
                cItem   := oModelx:GetValue("MD_MASTER", "ZIP_ITMPED")

                If nOperation == MODEL_OPERATION_INSERT
                    cOperacao := "I"

                ElseIf nOperation == MODEL_OPERATION_UPDATE
                    cOperacao := "A"

                ElseIf nOperation == MODEL_OPERATION_DELETE
                    cOperacao := "D"

                EndIf

                If ! Empty(cOperacao) .And. ! Empty(cPedido)
                    grvBarr(cOperacao, cPedido, cItem)

                EndIf

            EndIf

		EndIf

	EndIf

    RestArea(aArea)

Return xRet
/*/{Protheus.doc} grvBarr
    Salva o registro para enviar ao barramento.
    @type  Static Function
    @author Everson
    @since 09/01/2023
    @version 01
/*/
Static Function grvBarr(cOperacao, cPedido, cItem)

    //Variáveis.
    Local aArea     := GetArea()
    Local cFilter   := ""
    Local cCmp      := getCmps()
    Local cTopico   := "programacao_recebimento_protheus"

    cFilter := " ZIP_FILIAL ='" + FWxFilial("ZIP") + "' .And. ZIP_PEDIDO = '" + cPedido + "' .And. ZIP_ITMPED = '" + cItem + "' "

    U_ADFAT27D("ZIP", 1, FWxFilial("ZIP") + cPedido + cItem,;
               "ZIP", 6, FWxFilial("ZIP") + cPedido + cItem, "ZIP_ITMPED", cFilter,;
               cTopico, cOperacao,;
               .T., .T., .T.,;
               cCmp) 

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADCOM452
    Posiciona no registro pelo pedido de compra.
    @type  Function
    @author Everson
    @since 09/01/2023
    @version 01
/*/
User Function ADCOM452(cPedido)

    //Variáveis.
    DbSelectArea("ZIP")
    ZIP->(DbSetOrder(1))
    ZIP->(DbGoTop())

Return ZIP->( DbSeek( FWxFilial("ZIP") + cPedido ) )
/*/{Protheus.doc} User Function ADCOM453
    Envia manualmente para o barramento.
    @type  Function
    @author Everson
    @since 09/01/2023
    @version 01
/*/
User Function ADCOM453()

    //Variáveis.
    Local aArea     := GetArea()
    Local cPedido   := ZIP->ZIP_PEDIDO
    Local cItem     := ZIP->ZIP_ITMPED

    If ! MsgYesNo("Deseja enviar para o barramento?", "Função ADCOM453(ADCOM045P)")
        RestArea(aArea)
        Return Nil

    EndIf

    grvBarr("A", cPedido, cItem)

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} User Function ADCOM454
    Gera preenchimento em lote.
    @type  Function
    @author Everson
    @since 09/03/2023
    @version 01
/*/
User Function ADCOM454()

    //Variáveis.
    Local aArea     := GetArea()
    Local cPerg     := "ADCOM454"
    Local cPedido   := ""
    Local cItem     := ""
    Local dDtIni    := Nil
    Local dDtFim    := Nil
    Local nTotDia   := 0
    Local nTotPed   := 0
    Local nTotReg   := 0
    Local nAux      := 1
    Local lInc      := .F.
    Local cChave    := ""
    Local cBloqueia := ""
    Local cProduto  := ""
    Local cDescri   := ""

    If ! Pergunte(cPerg, .T.)
        RestArea(aArea)
        Return .F.

    EndIf

    cPedido  := MV_PAR01
    cItem    := MV_PAR02
    dDtIni   := MV_PAR03
    dDtFim   := MV_PAR04
    nTotDia  := Val(cValToChar(MV_PAR05))
    cBloqueia:= Alltrim(cValToChar(MV_PAR06))

    If Empty(cPedido) .Or. Empty(dDtIni) .Or. Empty(dDtFim) .Or. nTotDia <= 0 .Or. Empty(cBloqueia)
        MsgInfo("É necessário informar o pedido, item, data inicial, data final, quantidade diária e bloqueio.", "Função ADCOM454(ADCOM045P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If dDtIni > dDtFim
        MsgInfo("Data inicial não pode ser maior que a data final.", "Função ADCOM454(ADCOM045P)")
        RestArea(aArea)
        Return .F.

    EndIf

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    SC7->(DbGoTop())
    If ! SC7->(DbSeek( FWxFilial("SC7") + cPedido + cItem ))
        MsgInfo("Pedido/item " + cPedido + "/" + cItem + " não localizado.", "Função ADCOM454(ADCOM045P)")
        RestArea(aArea)
        Return .F.

    EndIf

    cProduto := SC7->C7_PRODUTO
    cDescri  := SC7->C7_DESCRI
    nTotPed  := SC7->C7_QUANT

    If nTotPed <= 0
        MsgInfo("Pedido/item " + cPedido + "/" + cItem + " não possui quantidade.", "Função ADCOM454(ADCOM045P)")
        RestArea(aArea)
        Return .F.

    EndIf

    nTotReg := DateDiffDay(dDtIni, dDtFim)+1

    If (nTotReg * nTotDia) > nTotPed
        MsgInfo("Quantidade total solicitada não pode ser maior que a quantidade do pedido." + xPula + xPula +;
                "Qtd. Pedido: " + Transform(nTotPed, "@E 999,999,999.999") + xPula + xPula +;
                "Qtd. Total Solicitada : " + Transform(nTotReg * nTotDia, "@E 999,999,999.999"), "Função ADCOM454(ADCOM045P)")
        RestArea(aArea)
        Return .F.

    EndIf

    DbSelectArea("ZIP")
    ZIP->(DbSetOrder(3))
    ZIP->(DbGoTop())

    Begin Transaction

        For nAux := 1 To nTotReg

            If dDtIni > dDtFim
                Exit

            EndIf

            cChave := cPedido + DToS(dDtIni) + cItem

            lInc := !(ZIP->(DbSeek( FWxFilial("ZIP") + cChave )))

            RecLock("ZIP", lInc)
                ZIP->ZIP_FILIAL := FWxFilial("ZIP")
                ZIP->ZIP_PEDIDO := cPedido
                ZIP->ZIP_ITMPED := cItem
                ZIP->ZIP_PRODUT := cProduto
                ZIP->ZIP_DESPRT := cDescri
                ZIP->ZIP_QTDPED := nTotPed
                ZIP->ZIP_BLQENT := cBloqueia
                ZIP->ZIP_ITEM   := Padl(cValToChar(nAux), 3, "0")
                ZIP->ZIP_DTENTR := dDtIni
                ZIP->ZIP_QUANT  := nTotDia
                ZIP->ZIP_PERCEN := Round(nTotDia/nTotPed,2)
            ZIP->(MsUnlock())

            dDtIni++

        Next nAux

    End Transaction

    grvBarr("A", cPedido, cItem)

    MsgInfo("Processo finalizado", "Função ADCOM454(ADCOM045P)")

    RestArea(aArea)
    
Return Nil
