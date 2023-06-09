#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static cTbMast := "ZIC"
Static cTitulo := "Motivo de Pesagem Manual"
Static cTiMast := "Dados do motivo de pesagem manual"

/*/{Protheus.doc} User Function ADFAT022P
    Motivo de Pesagem Manual.
    Cad Mot Pes Manual
    Chamado 18465.
    @type  Function
    @author Everson
    @since 29/11/2021
    @version 01
    /*/
User Function ADFAT022P() // U_ADFAT022P()

    //Vari�veis.
    Local oBrowse := FwLoadBrw("ADFAT022P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 29/11/2021
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
    @since 29/11/2021
    @version 01
/*/
Static Function MenuDef()
Return (FwMVCMenu("ADFAT022P"))
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 29/11/2021
    @version 01
/*/
Static Function ModelDef()
    
    //Vari�veis.
    Local bPre      := {|oModel| vldPre(oModel)}
    Local bPost     := {|oModel| vldPos(oModel)}
    Local bCancel   := {|| .T. }
    Local oModel    := MPFormModel():New("ADFAT22", bPre, bPost, /*bCommit*/, bCancel)
    Local oStrMast  := FwFormStruct(1, cTbMast)                                                
     
    //AddFields(<cId >, <cOwner >, <oModelStruct >, <bPre >, <bPost >, <bLoad >)
    oModel:AddFields("MD_MASTER", Nil, oStrMast)

    oModel:SetPrimaryKey({})

    oModel:SetDescription(cTitulo)

    oModel:GetModel("MD_MASTER"):SetDescription(cTiMast)

Return oModel
/*/{Protheus.doc} vldPre
    P�s valida��o.
    @type  Static Function
    @author Everson
    @since 29/11/2021
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
    @since 29/11/2021
    @version 01
/*/
Static Function vldPos(oModel)

    //Vari�veis.
    Local lRet       := .T.
  
Return lRet
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 29/11/2021
    @version 01
/*/
Static Function ViewDef()
    
    //Vari�veis.
    Local oView     := FwFormView():New()
    Local oModel    := FwLoadModel("ADFAT022P")
    Local oStrMast  := FwFormStruct(2, cTbMast)

    oView:SetModel(oModel)

    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")

Return oView
