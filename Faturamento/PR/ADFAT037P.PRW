#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static cTbMast  := "ZIX"
Static cTitulo  := "Cadastro de Caixas de Ve�culo"
Static cTiMast  := "Dados do cadastro de caixas de ve�culo"

/*/{Protheus.doc} User Function ADFAT037P
    Cadastro de caixas de ve�culo.
    Cad Caixas Veiculo
    Chamado 18465.
    @type  Function
    @author Everson
    @since 28/02/2022
    @version 01
    /*/
User Function ADFAT037P() // U_ADFAT037P()

    //Vari�veis.
    Local oBrowse := FwLoadBrw("ADFAT037P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 28/02/2022
    @version 01
/*/
Static Function BrowseDef()

    //Vari�veis.
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetDescription(cTitulo)

Return oBrowse
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 28/02/2022
    @version 01
/*/
Static Function MenuDef()
Return (FwMVCMenu("ADFAT037P"))
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 28/02/2022
    @version 01
/*/
Static Function ModelDef()
    
    //Vari�veis.
    Local oModel    := Nil
    Local oStrMast  := FWFormStruct(1, cTbMast, {|cCampo| AllTRim(cCampo) $ "ZIX_FILIAL;ZIX_PLACA;"})
    Local oStrGrid  := FWFormStruct(1, cTbMast)
    Local bPost     := Nil

    bPost := {|oModel| vldPos(oModel)}

    oModel := MPFormModel():New("ADFAT37", /*bPreValidacao*/, bPost, /*bCommit*/, /*bCancel*/ )
    
    //AddFields(<cId >, <cOwner >, <oModelStruct >, <bPre >, <bPost >, <bLoad >)
    oModel:AddFields("MD_MASTER", Nil, oStrMast)
    oModel:AddGrid("MD_GRID", "MD_MASTER", oStrGrid,,,,,)
 
    oModel:SetRelation("MD_GRID", {;
            {"ZIX_FILIAL", 'FWxFilial("' + cTbMast + '")'},;
            {"ZIX_PLACA", "ZIX_PLACA"};
        }, (cTbMast)->(IndexKey(1)))

    oModel:GetModel("MD_GRID")
    oModel:SetDescription(cTiMast)
    oModel:SetPrimaryKey({})

    oModel:GetModel("MD_GRID"):SetOptional(.T.)

Return oModel
/*/{Protheus.doc} vldPre
    P�s valida��o.
    @type  Static Function
    @author Everson
    @since 28/02/2022
    @version 01
/*/
Static Function vldPre(oModel)

    //Vari�veis.
    Local lRet       := .T.

Return lRet
/*/{Protheus.doc} vldPos
    P�s valida��o.
    @type  Static Function
    @author Everson
    @since 28/02/2022
    @version 01
/*/
Static Function vldPos(oModel)

    //Vari�veis.
    Local aArea      := GetArea()
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
    Local cPlaca     := oModel:GetValue("MD_MASTER", "ZIX_PLACA")

    If lRet .And. nOperation == MODEL_OPERATION_INSERT

        If Empty(cPlaca)
            lRet := .F.
            Help(Nil, Nil, "Fun��o vldPos(ADFAT037P)", Nil, "Necess�rio informar a placa do ve�culo.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

    EndIf

    RestArea(aArea)
  
Return lRet
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 28/02/2022
    @version 01
/*/
Static Function ViewDef()
    
    //Vari�veis.
    Local oModel    := FWLoadModel("ADFAT037P")
    Local oView     := Nil
    Local cCampos   := "ZIX_FILIAL;ZIX_PLACA;"
    Local oStrMast  := FWFormStruct(2, cTbMast, {|cCampo| AllTRim(cCampo) $ cCampos})
    Local oStrGrid  := FWFormStruct(2, cTbMast, {|cCampo| !(Alltrim(cCampo) $ cCampos)})

    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")
    oView:AddGrid("VW_GRID",    oStrGrid, "MD_GRID")
 
    oView:CreateHorizontalBox("MAIN", 25)
    oView:CreateHorizontalBox("GRID", 75)

    oView:SetOwnerView("VW_MASTER", 'MAIN')
    oView:SetOwnerView("VW_GRID", 'GRID')
    oView:EnableControlBar(.T.)

    oView:AddIncrementField("VW_GRID", "ZIX_NUMERO")

Return oView
/*/{Protheus.doc} ADFAT37A
    Chamada de inclus�o ou altera��o.
    @type  User Function
    @author Everson
    @since 18/03/2022
    @version 01
/*/
User Function ADFAT37A()

    //Vari�veis.
    Local aArea  := GetArea()
    Local cPlaca := ZV4->ZV4_PLACA
    Local aEnableButtons := {;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.T., NIL},;
                            {.F., NIL};
                            }

    DbSelectArea("ZIX")
    ZIX->( DbSetOrder(1) )
    If ZIX->( DbSeek( FWxFilial("ZIX") + cPlaca ) )
        FWExecView("Alterar Caixas de Transporte",   "ADFAT037P", 4,,,,,aEnableButtons)

    Else
        FWExecView("Adicionar Caixas de Transporte", "ADFAT037P", 3,,,,,aEnableButtons)

    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADFAT37B
    inicializa��o de placa.
    @type  User Function
    @author Everson
    @since 18/03/2022
    @version 01
/*/
User Function ADFAT37B() // U_ADFAT37B()

    //Vari�veis.

Return ZV4->ZV4_PLACA
/*/{Protheus.doc} ADFAT37A
    Valida placa.
    @type  User Function
    @author Everson
    @since 18/03/2022
    @version 01
/*/
User Function ADFAT37C() //U_ADFAT37C()

    //Vari�veis.

    FWFldPut("ZIX_PLACA", "")
    FWFldPut("ZIX_PLACA", ZV4->ZV4_PLACA)

Return .T.

