#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static xPula   := Chr(13) + Chr(10)
Static cTbMast := "ZJF"
Static cTitulo := "Corte de Pedido de Venda"
Static cTiMast := "Dados do corte de pedido de venda"
Static cCodUsr := ""
Static lAdm    := .F.
Static lBack   := .F.
Static lVend   := .F.
Static lSuperv := .F.
Static lDiret  := .F.

/*/{Protheus.doc} User Function ADVEN122P
    Cortes de pedidos de venda.
    Chamado 91301.
    @type  Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
User Function ADVEN122P() // U_ADVEN122P()

    //Variáveis.
    Local oBrowse := Nil

    carVariaveis()

    If ! (lAdm .Or. lBack .Or. lSuperv .Or. lDiret)
        Return Nil

    EndIf

    oBrowse := FwLoadBrw("ADVEN122P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} carVariaveis
    Carrega variáveis estáticas.
    @type  Static Function
    @author Everson
    @since 09/05/2023
    @version 01
/*/
Static Function carVariaveis()

    //Variáveis.
    Local aArea     := GetArea()

    U_ADVE118Q(@cCodUsr, @lAdm, @lBack, @lVend, @lSuperv, @lDiret)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
Static Function BrowseDef()

    //Variáveis.
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetDescription(cTitulo)

    If ! lAdm .And. ! lBack .And. ! lDiret
        oBrowse:SetFilterDefault("ZJF_USUARI = '" + cCodUsr + "' ")

    EndIf

    oBrowse:AddLegend("ZJF->ZJF_STATUS = '1'", "BR_VERDE"     , "Pendente")
    oBrowse:AddLegend("ZJF->ZJF_STATUS = '2'", "BR_VERMELHO"  , "Executado")

    oBrowse:SetMenuDef("ADVEN122P")

Return oBrowse
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
Static Function MenuDef()

    //Variáveis.
	Local aRotina 	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"      ACTION "PesqBrw"            OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.ADVEN122P"  OPERATION MODEL_OPERATION_VIEW ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" 	      ACTION "U_ADVE1220(3)" 	  OPERATION MODEL_OPERATION_INSERT    ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"        ACTION "U_ADVE1220(4)" 	  OPERATION MODEL_OPERATION_UPDATE    ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" 	      ACTION "U_ADVE1220(5)" 	  OPERATION MODEL_OPERATION_DELETE    ACCESS 0
	ADD OPTION aRotina TITLE "Efetuar Corte"  ACTION "MsAguarde({|| U_ADVE1223() }, 'Aguarde', 'Processando...')" 	  OPERATION 10    ACCESS 0

Return aRotina
/*/{Protheus.doc} User Function ADVE1210
    CRUD.
    @type  Function
    @author Everson
    @since 03/04/2023
    @version 01
/*/
User Function ADVE1220(nOpc)

    //Variáveis.
    Local aArea   := GetArea()
    Local cAcao   := ""
    Local aButtons:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T., Nil},{.T., Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

    If (nOpc == 4 .Or. nOpc == 5) .And. ZJF->ZJF_STATUS == "2"
        Help(Nil, Nil, "Função ADVE1220(ADVEN122P)", Nil, "Registro já encerrado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return Nil

    EndIf

    If nOpc == 3
        cAcao := "Incluir"

    ElseIf nOpc == 4
        cAcao := "Alterar"

    ElseIf nOpc == 5
        cAcao := "Excluir"

    EndIf

    FWExecView(cAcao, "ADVEN122P", nOpc, , , , , aButtons)

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
Static Function ModelDef()
    
    //Variáveis.
    Local oModel    := Nil
    Local oStrMast  := FWFormStruct(1, cTbMast, {|cCampo| Alltrim(cCampo) $ getCmps()})
    Local oStrGrid  := FWFormStruct(1, cTbMast)
    Local bPost     := {|oModel| vldPos(oModel) }

    oModel := MPFormModel():New("ADVE122", /*bPreValidacao*/, bPost, /*bCommit*/, /*bCancel*/ )
 
    oModel:AddFields("MD_MASTER", NIL, oStrMast)
    oModel:AddGrid("MD_GRID", "MD_MASTER", oStrGrid)
    oModel:GetModel("MD_GRID"):SetNoDeleteLine(.T.)
    oModel:GetModel("MD_GRID"):SetNoInsertLine(.T.)
 
    oModel:SetRelation("MD_GRID", {;
            {"ZJF_FILIAL", 'FWxFilial("' + cTbMast + '")'},;
            {"ZJF_CODIGO", "ZJF_CODIGO"},;
            {"ZJF_SUPERV", "ZJF_SUPERV"},;
            {"ZJF_NMSUP" , "ZJF_NMSUP"},;
            {"ZJF_CODPRD", "ZJF_CODPRD"},;
            {"ZJF_DESPRD", "ZJF_DESPRD"},;
            {"ZJF_DTENDE", "ZJF_DTENDE"},;
            {"ZJF_DTENAT", "ZJF_DTENAT"},;
            {"ZJF_STATUS", "ZJF_STATUS"},;
            {"ZJF_LOCEXP", "ZJF_LOCEXP"},;
            {"ZJF_QTDVD" , "ZJF_QTDVD"},;
            {"ZJF_QTDSM" , "ZJF_QTDSM"},;
            {"ZJF_QTDCT" , "ZJF_QTDCT"},;
            {"ZJF_DTCRT" , "ZJF_DTCRT"},;
            {"ZJF_HRCRT" , "ZJF_HRCRT"},;
            {"ZJF_USUARI", "ZJF_USUARI"};
        }, (cTbMast)->(IndexKey(1)))

    oModel:SetPrimaryKey({})

    oModel:AddCalc("ADVE122T", "MD_MASTER", "MD_GRID", "ZJF_QTDCAX" , "TT_VEND"  ,  "SUM", { || .T. },, "Qtd Cx Vendida")
    oModel:AddCalc("ADVE122T", "MD_MASTER", "MD_GRID", "ZJF_QTDCRT" , "TT_CORT"  ,  "SUM", { || .T. },, "Qtd Cx Corte")
    oModel:AddCalc("ADVE122T", "MD_MASTER", "MD_GRID", "ZJF_QTDFIM" , "TT_SALD"  ,  "SUM", { || .T. },, "Qtd Cx Vendida - Qtd Cx Corte")

Return oModel
/*/{Protheus.doc} getCmps
    Campos do cabeçalho do pedido de venda.
    @type  Static Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
Static Function getCmps()
Return "ZJF_FILIAL;ZJF_CODIGO;ZJF_SUPERV;ZJF_NMSUP;ZJF_CODPRD;ZJF_DESPRD;ZJF_DTENDE;ZJF_DTENAT;ZJF_STATUS;ZJF_QTDVD;ZJF_QTDSM;ZJF_QTDCT;ZJF_DTCRT;ZJF_HRCRT;ZJF_USUARI;ZJF_LOCEXP;"
/*/{Protheus.doc} vldPos
    Pós validação.
    @type  Static Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
Static Function vldPos(oModel)

    //Variáveis.
    Local aArea      := GetArea()
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
    Local nQtdCrt    := oModel:GetValue("ADVE122T", "TT_CORT")

    If lRet .And. (nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE)

        oModel:SetValue("MD_MASTER", "ZJF_DTCRT" , Date())
        oModel:SetValue("MD_MASTER", "ZJF_HRCRT" , Time())
        oModel:SetValue("MD_MASTER", "ZJF_USUARI", cCodUsr)
        
        If nQtdCrt <= 0
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADVEN122P)", Nil, "Não há quantidade de corte.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

    EndIf
    
    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
Static Function ViewDef()
    
    //Variáveis.
    Local oView     := Nil
    Local oModel    := FWLoadModel("ADVEN122P")
    Local cCampos   := getCmps()
    Local oStrMast  := FWFormStruct(2, cTbMast, {|cCampo| AllTRim(cCampo)   $ cCampos})
    Local oStrGrid  := FWFormStruct(2, cTbMast, {|cCampo| !(Alltrim(cCampo) $ cCampos)})
    Local oStrTot   := FWCalcStruct(oModel:GetModel("ADVE122T"))

    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    oView:AddField("VW_MASTER" , oStrMast, "MD_MASTER")
    oView:AddGrid("VW_GRID"    , oStrGrid, "MD_GRID",,{|| gridFocus() })
    oView:AddField("VW_TOT"    , oStrTot,  "ADVE122T")
 
    oView:CreateHorizontalBox("MAIN", 40)
    oView:CreateHorizontalBox("GRID", 50)
    oView:CreateHorizontalBox("BASE", 10)

    oView:SetOwnerView("VW_MASTER", 'MAIN')
    oView:SetOwnerView("VW_GRID", 'GRID')
    oView:SetOwnerView("VW_TOT"  , "BASE")
    oView:EnableControlBar(.T.)

    oView:SetViewProperty("VW_GRID" , "ENABLENEWGRID") 

    oView:AddUserButton("Carregar Dados","",{|oView| MsAguarde({|| U_ADVE1222() }, "Aguarde", "Processando...") } ,"",, {MODEL_OPERATION_INSERT} , .T.) 

    // oView:AddUserButton("Efetuar Corte" ,"",{|oView| MsAguarde({|| U_ADVE1223() }, "Aguarde", "Processando...") } ,"",, {MODEL_OPERATION_UPDATE} , .T.) 

Return oView
/*/{Protheus.doc} gridFocus
    Função executada quando a grid ganha foco.
    @type  Static Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
Static Function gridFocus()

    //Variáveis.

Return .T.
/*/{Protheus.doc} ADVE122
    Ponto de entrada.
    @type  User Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
User Function ADVE122()

    //Variáveis.
    Local aArea     := GetArea()
	Local aParam	:= PARAMIXB
	Local xRet 		:= .T.
	Local oObj 		:= ""
	Local cIdPonto 	:= ""
	Local cIdModel 	:= ""
    Local oModelx   := Nil
    Local nOperation:= 0

	If aParam <> Nil

		oObj 	    := aParam[1]
		cIdPonto    := aParam[2]
		cIdModel    := aParam[3]
        nOperation  := oObj:GetOperation()

		If cIdPonto == "MODELCOMMITNTTS"

            oModelx := FWModelActive()

		EndIf

	EndIf

    RestArea(aArea)

Return xRet
/*/{Protheus.doc} User Function ADVE1220
    Posiciona no registro pelo código.
    @type  Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
User Function ADVE1221(cCodigo)

    //Variáveis.

    DbSelectArea("ZJF")
    ZJF->(DbSetOrder(1))
    ZJF->(DbGoTop())

Return ZJF->(DbSeek(FWxFilial("ZJF") + cCodigo))
/*/{Protheus.doc} User Function ADVE1222
    Carrega dados de pedidos de venda.
    @type  Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
User Function ADVE1222()

    //Variáveis.
    Local aArea     := GetArea()
    Local nAux      := 1
    Local oView     := FWViewActive()
    Local oCabec    := oView:GetModel("MD_MASTER")
    Local oGrid     := oView:GetModel("MD_GRID")
    Local oTotal    := oView:GetModel("ADVE122T")
    Local cCodigo   := oCabec:GetValue("ZJF_CODIGO")
    Local cQuery    := ""
    Local cCodSup   := ""
    Local cNmSup    := ""
    Local cCodPrd   := ""
    Local cDesPrd   := ""
    Local cPedido   := ""
    Local cCodVend  := ""
    Local cNmVend   := ""
    Local cCodCli   := ""
    Local cLojaCli  := ""
    Local cNmCli    := ""
    Local nVlrTPd   := 0
    Local nTotCxPd  := 0
    Local nITPed    := 0
    Local nEMPed    := 0
    Local nPreco    := 0
    Local nQtdCx    := 0
    Local dDtInc    := Nil
    Local cLocExp   := ""
    Local dDtEntDe  := Nil
    Local dDtEntAte := Nil
    Local nQtdVd    := 0
    Local nQtdSM    := 0
    Local nQtdCT    := 0
    Local cAlias    := ""

    If ! lSuperv

        If ! Pergunte("ADVEN1221", .T.)
            RestArea(aArea)
            Return Nil

        EndIf

        cCodSup   := MV_PAR01
        dDtEntDe  := MV_PAR02
        dDtEntAte := MV_PAR03 
        cCodPrd   := MV_PAR04
        cLocExp   := Iif(MV_PAR05 == 1, "0102", Iif(MV_PAR05 == 2, "010B", ""))

    Else

        If ! Pergunte("ADVEN1222", .T.)
            RestArea(aArea)
            Return Nil

        EndIf

        cCodSup  := Posicione("SA3", 7, FWxFilial("SA3") + cCodUsr, "A3_COD")
        dDtEntDe := MV_PAR01
        dDtEntAte:= MV_PAR02
        cCodPrd  := MV_PAR03
        cLocExp  := Iif(MV_PAR04 == 1, "0102", Iif(MV_PAR04 == 2, "010B", ""))

    EndIf

    If Empty(cCodSup) .Or. Empty(dDtEntDe) .Or. Empty(dDtEntAte) .Or. Empty(cCodPrd) .Or. Empty(cLocExp)
        MsgInfo("Necessário informar todos os parâmetros da pergunta.", "Função ADVE1222(ADVEN122)")
        RestArea(aArea)
        Return Nil

    EndIf

    cNmSup := Posicione("SA3", 1 , FWxFilial("SA3") + cCodSup, "A3_NOME")

    oTotal:SetValue("TT_VEND", 0)
    oTotal:SetValue("TT_CORT", 0)
    oTotal:SetValue("TT_SALD", 0)

    carCabec()
    U_ADEST732()

    oView:refresh()

    cQuery := scpSqlC(cCodSup, dDtEntDe, dDtEntAte, cCodPrd, cCodUsr, cLocExp)
    
    cAlias := GetNextAlias()
    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    If (cAlias)->(Eof())
        MsgInfo("Não há dados para os parâmetros informados.", "Função ADVE1222(ADVEN122P)")
        (cAlias)->(DbCloseArea())
        RestArea(aArea)
        Return Nil

    EndIf

    oGrid:setNoInsertLine(.F.)
    oGrid:setNoDeleteLine(.F.)

    While ! (cAlias)->(Eof())

        If nAux > 1
            oGrid:addLine()

        EndIf

        cCodPrd  := (cAlias)->ZJB_PRODUT
        cDesPrd  := (cAlias)->ZJB_DESCRI
        cPedido  := (cAlias)->ZJA_NUM
        cCodVend := (cAlias)->A3_COD
        cNmVend  := (cAlias)->A3_NOME
        cCodCli  := (cAlias)->ZJA_CLIENT
        cLojaCli := (cAlias)->ZJA_LOJACL
        cNmCli   := (cAlias)->ZJA_NOMECL
        nVlrTPd  := (cAlias)->ZJA_VALOR
        nTotCxPd := (cAlias)->ZJA_VOL
        nITPed   := (cAlias)->ZJA_IT
        nEMPed   := (cAlias)->ZJA_EM
        nPreco   := (cAlias)->ZJB_CIFSFR
        nQtdCx   := (cAlias)->ZJB_UNSVEN
        dDtInc   := SToD((cAlias)->ZJA_DTINC)
        
        carCabec(cCodigo, cCodSup, cNmSup, cCodPrd, cDesPrd, dDtEntDe, dDtEntAte, nQtdVd, nQtdSM, nQtdCT, cLocExp)

        oGrid:setValue("ZJF_PEDIDO" , cPedido)
        oGrid:setValue("ZJF_DTINC"  , dDtInc)
        oGrid:setValue("ZJF_CODVEN" , cCodVend)
        // oGrid:setValue("ZJF_NMVEND" , cNmVend)
        oGrid:setValue("ZJF_CODCLI" , cCodCli)
        oGrid:setValue("ZJF_LOJACL" , cLojaCli)
        oGrid:setValue("ZJF_NMCLI"  , cNmCli) 

        oGrid:setValue("ZJF_VLRPED" , nVlrTPd) 
        oGrid:setValue("ZJF_TOTCAX" , nTotCxPd) 
        oGrid:setValue("ZJF_ITPED"  , nITPed) 
        oGrid:setValue("ZJF_EMPED"  , nEMPed) 
        oGrid:setValue("ZJF_PRECO"  , nPreco) 
        oGrid:setValue("ZJF_QTDCAX" , nQtdCx) 

        oGrid:setValue("ZJF_QTDFIM" , nQtdCx) 

        oGrid:setValue("ZJF_VLPAJT" , nVlrTPd) 
        oGrid:setValue("ZJF_TTCAJT" , nTotCxPd) 

        (cAlias)->(DbSkip())

        nAux++

    End

    (cAlias)->(DbCloseArea())

    oGrid:setNoInsertLine(.T.)
    oGrid:setNoDeleteLine(.T.)

    oGrid:goLine(1)
        
    RestArea(aArea)

Return Nil
/*/{Protheus.doc} obtCodSup
    Obtém todos os códigos de supervisor.
    @type  Static Function
    @author Everson
    @since 10/05/2023
    @version 01
/*/
Static Function obtCodSup(cCodUsr)

    //Variáveis.
    Local aArea     := GetArea()
    Local cCodigos  := ""

    DbSelectArea("SA3")
    SA3->(DbSetOrder(7))
    SA3->(DbGoTop())
    If ! SA3->(DbSeek( FWxFilial("SA3") + cCodUsr ))
        RestArea(aArea)
        Return ""

    EndIf

    While ! SA3->(Eof()) .And. SA3->A3_FILIAL == FWxFilial("SA3") .And. SA3->A3_CODUSR == cCodUsr
        
        cCodigos += "'" + SA3->A3_COD + "',"

        SA3->(DbSkip())

    End

    cCodigos := Substr(cCodigos, 1, Len(cCodigos) - 1)

    RestArea(aArea)
    
Return cCodigos
/*/{Protheus.doc} carCabec
    (long_description)
    @type  Static Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
Static Function carCabec(cCodigo, cCodSup, cNmSup, cCodPrd, cDesPrd, dDtEntDe, dDtEntAte, nQtdVd, nQtdSM, nQtdCT, cLocExp)

    //Variáveis.
    Default cCodigo   := ""
    Default cCodSup   := ""
    Default cNmSup    := ""
    Default cCodPrd   := ""
    Default cDesPrd   := ""
    Default dDtEntDe  := CToD(" / / ")
    Default dDtEntAte := CToD(" / / ")
    Default nQtdVd    := 0
    Default nQtdSM    := 0
    Default nQtdCT    := 0
    Default cLocExp   := ""

    // FWFldPut("ZJF_CODIGO" , cCodigo)
    FWFldPut("ZJF_SUPERV" , cCodSup)
    FWFldPut("ZJF_NMSUP"  , cNmSup)
    FWFldPut("ZJF_CODPRD" , cCodPrd)
    FWFldPut("ZJF_DESPRD" , cDesPrd)
    FWFldPut("ZJF_DTENDE" , dDtEntDe)
    FWFldPut("ZJF_DTENAT" , dDtEntAte)
    FWFldPut("ZJF_QTDVD"  , nQtdVd)
    FWFldPut("ZJF_QTDSM"  , nQtdSM)
    FWFldPut("ZJF_QTDCT"  , nQtdCT)
    FWFldPut("ZJF_LOCEXP" , cLocExp)

Return Nil
/*/{Protheus.doc} scpSqlC
    Retorna script sql.
    @type  Static Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
Static Function scpSqlC(cCodSup, dDtEntr, dDtEntAte, cCodPrd, cCodUsr, cLocExp)

    //Variáveis.
    Local cQuery := ""

    Default cCodUsr := ""

    cQuery += " SELECT " 
        cQuery += " ZJB_PRODUT, " 
        cQuery += " ZJB_DESCRI, " 
        cQuery += " ZJA_NUM, " 
        cQuery += " A3_COD, " 
        cQuery += " A3_NOME, " 
        cQuery += " ZJA_CLIENT, " 
        cQuery += " ZJA_LOJACL, " 
        cQuery += " ZJA_NOMECL, " 
        cQuery += " ZJA_VALOR, " 
        cQuery += " ZJA_VOL, " 
        cQuery += " ZJA_IT, " 
        cQuery += " ZJA_EM, " 
        cQuery += " ZJB_PRCVEN, ZJB_CIFSFR, " 
        cQuery += " ZJB_UNSVEN, " 
        cQuery += " A3_SUPER, " 
        cQuery += " ZJA_DTINC " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZJA") + " (NOLOCK) AS ZJA " 
        cQuery += " INNER JOIN " 
        cQuery += " " + RetSqlName("ZJB") + " (NOLOCK) AS ZJB ON " 
        cQuery += " ZJA_FILIAL = ZJB_FILIAL " 
        cQuery += " AND ZJA_LOCEXP = ZJB_LOCEXP " 
        cQuery += " AND ZJA_NUM = ZJB_NUM " 
        cQuery += " AND ZJA_LOCEXP = ZJB_LOCEXP " 
        cQuery += " AND ZJB.D_E_L_E_T_ = '' " 

        cQuery += " INNER JOIN " 
        cQuery += " " + RetSqlName("SA3") + " (NOLOCK) AS SA3 ON " 
        cQuery += " ZJA_CODVEN = A3_COD " 
        cQuery += " AND SA3.D_E_L_E_T_ = '' " 

        cQuery += " INNER JOIN " 
        cQuery += " " + RetSqlName("SE4") + " (NOLOCK) AS SE4 ON " 
        cQuery += " ZJA_CONDPA = E4_CODIGO " 
        cQuery += " AND SE4.D_E_L_E_T_ = '' " 

    cQuery += " WHERE " 
        cQuery += " ZJA_FILIAL = '" + FWxFilial("ZJA") + "' " 
        cQuery += " AND ZJA_DTENTR BETWEEN '" + DToS(dDtEntr) + "' AND '" + DToS(dDtEntAte) + "' " 
        cQuery += " AND ZJB_PRODUT = '" + cCodPrd + "' " 

        If ! lSuperv
            cQuery += " AND A3_SUPER = '" + cCodSup + "' " 

        Else
            cQuery += " AND A3_SUPER IN (" + cCodSup + ") " 

        EndIf

        cQuery += " AND ZJA_LOCEXP = '" + cLocExp + "' " 
        cQuery += " AND ZJA_STATUS IN ('1', '2', '3') "
        cQuery += " AND ZJA_TPPED NOT IN ('7', '8') "
        cQuery += " AND E4_CTRADT <> '1' "
        cQuery += " AND ZJA.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY " 
    cQuery += " ZJA_NUM " 

Return cQuery
/*/{Protheus.doc} User Function ADVE1223
    Executa o corte.
    @type  Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
User Function ADVE1223()

    //Variáveis.
    Local aArea      := GetArea()
    Local oPedido    := Nil
    Local oGrid      := Nil
    Local cCodigo    := ZJF->ZJF_CODIGO
    Local cLocExp    := ZJF->ZJF_LOCEXP
    Local nOperation := MODEL_OPERATION_UPDATE
    Local aError     := {}
    Local cMsgError  := ""
    Local cPedido    := ""
    Local cProduto   := ""
    Local nQtdFim    := 0
    Local lContinua  := .T.

    If ZJF->ZJF_STATUS <> "1"
        MsgInfo("Registro de corte " + cCodigo + " já processado.", "Função ADVE1223(ADVEN122P)")
        RestArea(aArea)
        Return Nil   

    EndIf

    If ! MsgYesNo("Deseja processar o corte " + cCodigo + "?", "Função ADVE1223(ADVEN122P)")
        RestArea(aArea)
        Return Nil

    EndIf

    While ! ZJF->(Eof()) .And. ZJF->ZJF_FILIAL == FWxFilial("ZJF") .And. ZJF->ZJF_CODIGO == cCodigo

        If ZJF->ZJF_QTDCRT == 0
            ZJF->(DbSkip())
            Loop

        EndIf

        lContinua  := .T.
        nOperation := MODEL_OPERATION_UPDATE
        cPedido    := ZJF->ZJF_PEDIDO
        cProduto   := ZJF->ZJF_CODPRD
        nQtdFim    := ZJF->ZJF_QTDFIM 

        //Localiza pedido.
        If ! U_ADVE1182(cPedido, cLocExp)
            cMsgError += cPedido + " pedido não localizado " + xPula
            ZJF->(DbSkip())
            Loop

        EndIf

        If ZJA->ZJA_VOL <= ZJF->ZJF_QTDCRT .Or. ZJA->ZJA_VOL < nQtdFim
            nOperation := MODEL_OPERATION_DELETE

        EndIf

        oPedido := FWLoadModel("ADVEN118P")
        oPedido:SetOperation(nOperation)
        oPedido:Activate()

        oGrid := oPedido:GetModel("MD_GRID")

        If nOperation == MODEL_OPERATION_UPDATE

            If oGrid:SeekLine( {{"ZJF_CODPRD", cProduto}}, .F./*lDeleted*/, .T. /*lLocate*/ )

                If nQtdFim == 0
                    oGrid:DeleteLine()

                Else
                    oGrid:SetValue("ZJB_UNSVEN", nQtdFim)

                EndIf

            Else
                cMsgError += cPedido + " produto " + cProduto + " não localizado " + xPula
                lContinua := .F.

            EndIf

        EndIf

        If lContinua

            If oPedido:VldData()
                oPedido:CommitData()

            Else
                aError := oPedido:GetErrorMessage()
                cMsgError += cPedido + " " + Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE])) + xPula

            EndIf

        EndIf

        oPedido:DeActivate()
        oPedido:Destroy()
        oPedido := Nil

        ZJF->(DbSkip())

    End

    If ! Empty(cMsgError)
        cMsgError := "Os pedidos abaixo apresentaram erro: " + xPula + cMsgError
        Help(Nil, Nil, "Função ADVE1223(ADVEN122P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    TcSqlExec( " UPDATE " + RetSqlName("ZJF") + " SET ZJF_STATUS = '2' WHERE ZJF_FILIAL = '" + FWxFilial("ZJF") + "' AND ZJF_CODIGO = '" + cCodigo + "' AND D_E_L_E_T_ = '' " )

    MsgInfo("Processo finalizado.", "Função ADVE1223(ADVEN122P)")
    
    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADVE1224
    Gatilho ajuste valor do pedido.
    @type  Function
    @author Everson
    @since 11/04/2023
    @version 01
/*/
User Function ADVE1224(cPedido, nVlrTPed, nQtdFim) // U_ADVE1224(M->ZJF_PEDIDO, M->ZJF_VLRPED, M->ZJF_QTDFIM)

    //Variáveis.
    Local aArea    := GetArea()
    Local nVlr     := 0
    Local nConv    := 0
    Local oModel   := FWModelActive()
    Local cProduto := oModel:GetValue("MD_MASTER", "ZJF_CODPRD")

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbGoTop())

    If ! SB1->(DbSeek(FWxFilial("SB1") + cProduto))
        RestArea(aArea)
        Return 0

    EndIf

    DbSelectArea("ZJB")
    ZJB->(DbSetOrder(2))
    ZJB->(DbGoTop())

    If ! ZJB->(DbSeek(FWxFilial("ZJB") + cPedido + cProduto))
        RestArea(aArea)
        Return 0

    EndIf

    If SB1->B1_TIPCONV == "D"
        nConv := ZJB->ZJB_QTDVEN/ZJB->ZJB_UNSVEN
        nVlr  := nVlrTPed - ZJB->ZJB_VALOR
        nVlr  += ZJB->ZJB_PRCVEN * (nConv * nQtdFim)

    ElseIf SB1->B1_TIPCONV == "M"
        nConv := ZJB->ZJB_QTDVEN*ZJB->ZJB_UNSVEN
        nVlr  := nVlrTPed - ZJB->ZJB_VALOR
        nVlr  += ZJB->ZJB_PRCVEN * (nConv * nQtdFim)

    Else
        nConv := 1
        nVlr  := nVlrTPed - ZJB->ZJB_VALOR
        nVlr  += ZJB->ZJB_PRCVEN * (nConv * nQtdFim)

    EndIf

    RestArea(aArea)

Return nVlr
/*/{Protheus.doc} User Function ADVE1225
    Valida valor final do pedido de venda.
    @type  Function
    @author Everson
    @since 10/05/2023
    @version 01
/*/
User Function ADVE1225(nVlrTot) // U_ADVE1225(M->ZJF_VLPAJT)

    //Variáveis.
    Local aArea   := GetArea()
    Local nVlrMin := 0

    If ! U_ADVE1201()
        Help(Nil, Nil, "Função ADVE1225(ADVEN122P)", Nil, "Não há parametrização de pedido ativa.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    nVlrMin := ZJD->ZJD_VLRCOR

    If nVlrTot < nVlrMin
        MsgInfo("O pedido ficará abaixo do mínimo " + Alltrim(Transform(nVlrMin, pesqPict("ZJD","ZJD_VLRCOR"))) + ".", "Função ADVE1225(ADVEN122P)")

    EndIf

    RestArea(aArea)
    
Return .T.
