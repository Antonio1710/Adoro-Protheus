#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static cTbMast := "ZJC"
Static cTitulo := "Grupos de Cond de Pagamento"
// Static xPula   :=  Chr(13) + Chr(10)

/*/{Protheus.doc} User Function ADVEN119P
    Cadastro grupo de condições de pagamento.
    Chamado 91301.
    @type  Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
User Function ADVEN119P()

    //Variáveis.

    oBrowse := FwLoadBrw("ADVEN119P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 06/04/2022
    @version 01
/*/
Static Function BrowseDef()

    //Variáveis.
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetDescription(cTitulo)

    oBrowse:SetFilterDefault(" " + cTbMast + "_FILIAL = '" + FWxFilial(cTbMast) + "' ")

Return oBrowse
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
Static Function MenuDef()

    //Variáveis.
    Local aRotina := {}

    ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          	OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.ADVEN119P" 	OPERATION MODEL_OPERATION_VIEW      ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" 	  ACTION "VIEWDEF.ADVEN119P" 	OPERATION MODEL_OPERATION_INSERT    ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.ADVEN119P"   	OPERATION MODEL_OPERATION_UPDATE    ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" 	  ACTION "VIEWDEF.ADVEN119P"   	OPERATION MODEL_OPERATION_DELETE    ACCESS 0

Return aRotina
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
Static Function ModelDef()
    
    //Variáveis.
    Local oModel    := Nil
    Local oStrMast  := FWFormStruct(1, cTbMast, {|cCampo| Alltrim(cCampo) $ getCmps()})
    Local oStrGrid  := FWFormStruct(1, cTbMast)

    oModel := MPFormModel():New("ADVE119", /*bPreValidacao*/, /*bPost*/, /*bCommit*/, /*bCancel*/ )
 
    oModel:AddFields("MD_MASTER", NIL, oStrMast)
    oModel:AddGrid("MD_GRID", "MD_MASTER", oStrGrid)
 
    oModel:SetRelation("MD_GRID", {;
            {"ZJC_FILIAL", 'FWxFilial("' + cTbMast + '")'},;
            {"ZJC_CODP"  , "ZJC_CODP"},;
            {"ZJC_DESCP" , "ZJC_DESCP"};
        }, (cTbMast)->(IndexKey(2)))

    oModel:GetModel("MD_GRID"):SetUniqueLine({"ZJC_FILIAL", "ZJC_CODF"}) 

    oModel:SetPrimaryKey({})

Return oModel
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
Static Function ViewDef()
    
    //Variáveis.
    Local oView     := Nil
    Local oModel    := FWLoadModel("ADVEN119P")
    Local cCampos   := getCmps()
    Local oStrMast  := FWFormStruct(2, cTbMast, {|cCampo| AllTRim(cCampo)   $ cCampos})
    Local oStrGrid  := FWFormStruct(2, cTbMast, {|cCampo| !(Alltrim(cCampo) $ cCampos)})

    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")
    oView:AddGrid("VW_GRID",    oStrGrid, "MD_GRID",,{|| gridFocus() })
 
    oView:CreateHorizontalBox("MAIN", 20)
    oView:CreateHorizontalBox("GRID", 80)

    oView:SetOwnerView("VW_MASTER", 'MAIN')
    oView:SetOwnerView("VW_GRID", 'GRID')
    oView:EnableControlBar(.T.)
 
    oView:AddIncrementField("VW_GRID", "ZJC_ITEM")

    oView:SetViewProperty( "VW_GRID" , "ENABLENEWGRID" ) 

    oView:SetViewProperty( "VW_GRID", "GRIDFILTER", {.T.}) 
    oView:SetViewProperty( "VW_GRID", "GRIDSEEK", {.T.})

Return oView
/*/{Protheus.doc} getCmps
    (long_description)
    @type  Static Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
Static Function getCmps()
Return "ZJC_FILIAL;ZJC_CODP;ZJC_DESCP"
/*/{Protheus.doc} gridFocus
    Função executada quando a grid ganha foco.
    @type  Static Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
Static Function gridFocus()

    //Variáveis.
    Local aArea     := GetArea()
    Local oModel    := FWModelActive()
    Local oView     := FWViewActive()
    Local cCodP     := oModel:GetValue("MD_MASTER","ZJC_CODP")
    Local cDescP    := oModel:GetValue("MD_MASTER","ZJC_DESCP")

    If Empty(cCodP) .Or. Empty(cDescP)
        Help(Nil, Nil, "Função gridFocus(ADVEN119P)", Nil, "Necessário preencher os dados do cabeçalho.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        
        If ValType(oView) == "O"
            oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZJC_CODP"):OCtrl:SetFocus()

        EndIf

        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADVE118D
    (long_description)
    @type  Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
User Function ADVE1190(cCondPag, lCabec) // U_ADVE1190(M->ZJC_CODP)

    //Variáveis.
    Local aArea := GetArea()

    Default lCabec := .F.

    DbSelectArea("ZJC")
    ZJC->(DbSetOrder(1))
    ZJC->(DbGoTop())

    DbSelectArea("SE4")
    SE4->(DbSetOrder(1))
    SE4->(DbGoTop())
    If ! SE4->(DbSeek(FWxFilial("SE4") + cCondPag))
        Help(Nil, Nil, "Função ADVE1190(ADVEN119P)", Nil, "Condição de pagamento " + cCondPag + " não localizada.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf
   
    If lCabec .And. ZJC->(DbSeek(FWxFilial("ZJC") + cCondPag))
        Help(Nil, Nil, "Função ADVE1190(ADVEN119P)", Nil, "Condição de pagamento " + cCondPag + " já cadastrada.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If ! lCabec .And. cCondPag == M->ZJC_CODP
        Help(Nil, Nil, "Função ADVE1190(ADVEN119P)", Nil, "Condição de pagamento " + cCondPag + " já informada no cabeçalho.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)

Return .T.
