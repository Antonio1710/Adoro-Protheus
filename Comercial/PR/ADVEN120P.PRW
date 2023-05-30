#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static cTbMast := "ZJD"
Static cTitulo := "Parametrização de Pedidos"
Static cTiMast := "Dados da parametrização de pedidos"

/*/{Protheus.doc} User Function ADVEN120P
    Parametrização de Pedidos.
    Chamado 91301.
    @type  Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
User Function ADVEN120P() // U_ADVEN120P()

    //Variáveis.
    Local oBrowse := FwLoadBrw("ADVEN120P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
Static Function BrowseDef()

    //Variáveis.
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetDescription(cTitulo)

    oBrowse:SetMenuDef("ADVEN120P")

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
	Local aRotina 	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PesqBrw"          	OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.ADVEN120P" 	OPERATION MODEL_OPERATION_VIEW      ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" 	    ACTION "VIEWDEF.ADVEN120P" 	OPERATION MODEL_OPERATION_INSERT    ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.ADVEN120P" 	OPERATION MODEL_OPERATION_UPDATE    ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" 	    ACTION "VIEWDEF.ADVEN120P" 	OPERATION MODEL_OPERATION_DELETE    ACCESS 0

Return aRotina
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
Static Function ModelDef()
    
    //Variáveis.
    Local bPre      := {|| .T. }
    Local bPost     := {|| .T. }
    Local bCancel   := {|| .T. }
    Local oModel    := MPFormModel():New("ADVE120", bPre, bPost, /*bCommit*/, bCancel)
    Local oStrMast  := FwFormStruct(1, cTbMast)                                                
     
    oModel:AddFields("MD_MASTER", Nil, oStrMast)

    oModel:SetPrimaryKey({})

    oModel:SetDescription(cTitulo)

    oModel:GetModel("MD_MASTER"):SetDescription(cTiMast)

Return oModel
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
Static Function ViewDef()
    
    //Variáveis.
    Local oView     := FwFormView():New()
    Local oModel    := FwLoadModel("ADVEN120P")
    Local oStrMast  := FwFormStruct(2, cTbMast)

    oView:SetModel(oModel)

    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")

Return oView
/*/{Protheus.doc} ADVE120
    Ponto de entrada.
    @type  User Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
User Function ADVE120()

    //Variáveis.
    Local aArea     := GetArea()
	Local aParam	:= PARAMIXB
	Local xRet 		:= .T.
	Local oObj 		:= ""
	Local cIdPonto 	:= ""
	Local cIdModel 	:= ""
    Local oModelx   := Nil
    Local nOperation:= 0
    Local cNumero   := ""
    Local cAtivo    := ""

	If aParam <> Nil

		oObj 	    := aParam[1]
		cIdPonto    := aParam[2]
		cIdModel    := aParam[3]
        nOperation  := oObj:GetOperation()

		If cIdPonto == "MODELCOMMITNTTS"

            oModelx := FWModelActive()
            cNumero := oModelx:GetValue("MD_MASTER", "ZJD_COD")
            cAtivo  := oModelx:GetValue("MD_MASTER", "ZJD_ATIVO")

            If nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE .And. cAtivo == "1"

                TcSqlExec(" UPDATE " + RetSqlName("ZJD") + " SET ZJD_ATIVO = '2' WHERE ZJD_COD <> '" + cNumero + "' AND D_E_L_E_T_ = '' ")

            EndIf

		EndIf

	EndIf

    RestArea(aArea)

Return xRet
/*/{Protheus.doc} User Function ADVE121
    Posiciona no registro ativo.
    @type  Function
    @author Everson
    @since 19/04/2023
    @version 01
/*/
User Function ADVE1201()

    //Variáveis.

    DbSelectArea("ZJD")
    ZJD->(DbSetOrder(2))
    ZJD->(DbGoTop())
    
Return ZJD->(DbSeek(FWxFilial("ZJD") + "1"))
