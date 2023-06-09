#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static cTbMast := "ZIM"
Static cTitulo := "Produto SAG x Produto Protheus"
Static cTiMast := "Dados Produto SAG x Produto Protheus"

/*/{Protheus.doc} User Function ADFAT020P
    Cadastro de Produto SAG x Produto Protheus.
    Cad Prd SAG x Prd Protheus
    Chamado 18465.
    @type  Function
    @author Everson
    @since 25/11/2021
    @version 01
    /*/
User Function ADFAT020P() // U_ADFAT020P()

    //Vari�veis.
    Local oBrowse := FwLoadBrw("ADFAT020P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 25/11/2021
    @version 01
/*/
Static Function BrowseDef()

    //Vari�veis.
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetDescription(cTitulo)

    oBrowse:SetMenuDef("ADFAT020P")

Return oBrowse
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 25/11/2021
    @version 01
/*/
Static Function MenuDef()

    //Vari�veis.
	Local aRotina 	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PesqBrw"          	OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.ADFAT020P" 	OPERATION MODEL_OPERATION_VIEW      ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" 	    ACTION "VIEWDEF.ADFAT020P" 	OPERATION MODEL_OPERATION_INSERT    ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.ADFAT020P" 	OPERATION MODEL_OPERATION_UPDATE    ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" 	    ACTION "VIEWDEF.ADFAT020P" 	OPERATION MODEL_OPERATION_DELETE    ACCESS 0
    ADD OPTION aRotina TITLE "Proc Integr." ACTION "U_ADFAT20A()"       OPERATION 10  ACCESS 0

Return aRotina
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 25/11/2021
    @version 01
/*/
Static Function ModelDef()
    
    //Vari�veis.
    Local bPre      := {|| .T. }
    Local bPost     := {|oModel| vldPos(oModel) }
    Local bCancel   := {|| .T. }
    Local oModel    := MPFormModel():New("ADFAT20", bPre, bPost, /*bCommit*/, bCancel)
    Local oStrMast  := FwFormStruct(1, cTbMast)                                                
     
    //AddFields(<cId >, <cOwner >, <oModelStruct >, <bPre >, <bPost >, <bLoad >)
    oModel:AddFields("MD_MASTER", Nil, oStrMast)

    oModel:SetPrimaryKey({})

    oModel:SetDescription(cTitulo)

    oModel:GetModel("MD_MASTER"):SetDescription(cTiMast)

Return oModel
/*/{Protheus.doc} vldPos
    P�s valida��o.
    @type  Static Function
    @author Everson
    @since 25/11/2021
    @version 01
/*/
Static Function vldPos(oModel)

    //Vari�veis.
    Local aArea      := GetArea()
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
    //Local cPrdSAG    := oModel:GetValue("MD_MASTER", "ZIM_PRDSAG")

    If lRet .And. nOperation == MODEL_OPERATION_DELETE
    
        // If ExistCpo("ZI8", cPrdSAG, 3)
        //     lRet := .F.
        //     Help(Nil, Nil, "Fun��o vldPos(ADFAT020P)", Nil, "H� registro de lote vinculado ao produto.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        // EndIf

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 25/11/2021
    @version 01
/*/
Static Function ViewDef()
    
    //Vari�veis.
    Local oView     := FwFormView():New()
    Local oModel    := FwLoadModel("ADFAT020P")
    Local oStrMast  := FwFormStruct(2, cTbMast)

    oView:SetModel(oModel)

    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")

Return oView
/*/{Protheus.doc} ADFAT20A
    Processa registros pendentes de integra��o vindos do barramento.
    @type  Static Function
    @author Everson
    @since 09/02/2022
    @version 01
/*/
User Function ADFAT20A()

    //Vari�veis.
    Local aArea := GetArea()

    MsAguarde({|| U_ADFAT29B() }, "Aguarde", "Processando...", .F.)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADFAT20B
    Posiciona no produto pelo c�digo do SAG.
    @type  Function
    @author user
    @since 13/05/2022
    @version 01
    /*/
User Function ADFAT20B(cProdSAG)

    DbSelectArea("ZIM")
    ZIM->(DbSetOrder(1))
    If ! ZIM->( DbSeek( FWxFilial("ZIM") + cProdSAG) )
        Return .F.

    EndIf

Return .T.
/*/{Protheus.doc} User Function ADFAT20B
    Posiciona no produto pelo c�digo do Protheus.
    @type  Function
    @author Everson
    @since 22/07/2022
    @version 01
    /*/
User Function ADFAT20C(cProdPro)

    DbSelectArea("ZIM")
    ZIM->(DbSetOrder(2))
    If ! ZIM->( DbSeek( FWxFilial("ZIM") + cProdPro) )
        Return .F.

    EndIf

Return .T.
