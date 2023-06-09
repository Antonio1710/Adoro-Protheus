#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static cTbMast := "ZHU"
Static cTitulo := "Tipo An�lise Laboratorial"
Static cTiMast := "Dados do Tipo de An�lise Laboratorial"

Static cTipoD  := "1"

/*/{Protheus.doc} User Function ADQUA005P
    Item An�lise laboratorial
    Chamado 18465.
    @type  Function
    @author Everson
    @since 25/07/2022
    @version 01
/*/
User Function ADQUA005P() // U_ADQUA005P()

    //Vari�veis.
    Local oBrowse := FwLoadBrw("ADQUA005P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 25/07/2022
    @version 01
/*/
Static Function BrowseDef()

    //Vari�veis.
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetDescription(cTitulo)

    // oBrowse:SetFilterDefault(" " + cTbMast + "_FILIAL = '" + FWxFilial(cTbMast) + "' ")

Return oBrowse
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 25/07/2022
    
    @version 01
/*/
Static Function MenuDef()

    //Vari�veis
    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.ADQUA005P" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"    ACTION "U_ADQUA51()"       OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"    ACTION "U_ADQUA52(4)"      OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"    ACTION "U_ADQUA52(5)"      OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.ADQUA005P" OPERATION 8 ACCESS 0

Return aRotina
/*/{Protheus.doc} User Function ADQUA51
    Inclus�o de item de an�lise.
    @type  Function
    @author Everson
    @since 25/07/2022
    @version 01
/*/
User Function ADQUA51()

    //Vari�veis.
    Local aArea := GetArea()
    
    //Tipo de dado.
    If ! Pergunte("ADQUA0051",.T.)
        RestArea(aArea)
        Return Nil

    EndIf

    cTipoD := Alltrim(cValToChar(MV_PAR01))

    If Empty(cTipoD)
        RestArea(aArea)
        Return Nil

    EndIF

    FWExecView("", "ADQUA005P", 3)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADQUA52
    Altera��o de item de an�lise.
    @type  Function
    @author Everson
    @since 25/07/2022
    @version 01
/*/
User Function ADQUA52(nOPc)

    //Vari�veis.
    Local aArea := GetArea()

    cTipoD := ZHU->ZHU_TPDADO

    FWExecView("", "ADQUA005P", nOPc)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADQUA53
    Tipo de dado.
    @type  Function
    @author Everson
    @since 25/07/2022
    @version 01
/*/
User Function ADQUA53()
Return cTipoD
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 25/07/2022
    @version 01
/*/
Static Function ModelDef()
    
    //Vari�veis.
    Local oModel    := Nil
    Local oStrMast  := FWFormStruct(1, cTbMast, {|cCampo| AllTRim(cCampo) $ getCmps()})
    Local oStrGrid  := FWFormStruct(1, cTbMast)
 
    oModel := MPFormModel():New("ADQUA5", /*bPreValidacao*/, /*{|oModel| fValidGrid(oModel)}*/, /*bCommit*/, /*bCancel*/ )
 
    oModel:AddFields("MD_MASTER", NIL, oStrMast)
    oModel:AddGrid("MD_GRID", "MD_MASTER", oStrGrid, ,)
 
    oModel:SetRelation("MD_GRID", {;
            {"ZHU_FILIAL", 'FWxFilial("' + cTbMast + '")'},;
            {"ZHU_NUMERO", "ZHU_NUMERO"},;
            {"ZHU_NOME"  , "ZHU_NOME"},;
            {"ZHU_TPDADO", "ZHU_TPDADO"},;
            {"ZHU_UN"    , "ZHU_UN"};
        }, (cTbMast)->(IndexKey(1)))

    oModel:SetPrimaryKey({"ZHU_FILIAL","ZHU_NUMERO"})

Return oModel
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 25/07/2022
    @version 01
/*/
Static Function ViewDef()
    
    //Vari�veis.
    Local oView     := Nil
    Local oModel    := FWLoadModel("ADQUA005P")
    Local cCampos   := getCmps()
    Local oStrMast  := FWFormStruct(2, cTbMast, {|cCampo| AllTRim(cCampo) $ cCampos})
    Local oStrGrid  := FWFormStruct(2, cTbMast, {|cCampo| !(Alltrim(cCampo) $ cCampos)})

    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")
    oView:AddGrid("VW_GRID",    oStrGrid, "MD_GRID",,{|| gridFocus(oView) })
 
    oView:CreateHorizontalBox("MAIN", 25)
    oView:CreateHorizontalBox("GRID", 75)

    oView:SetOwnerView("VW_MASTER", 'MAIN')
    oView:SetOwnerView("VW_GRID", 'GRID')
    oView:EnableControlBar(.T.)
 
    oView:AddIncrementField("VW_GRID", "ZHU_ITEM")

    oStrGrid:RemoveField("ZHU_UN")

    If cTipoD == "1"
        oStrGrid:RemoveField("ZHU_MINIMO")
        oStrGrid:RemoveField("ZHU_MAXIMO")
        
    ElseIf cTipoD == "2"
        oStrGrid:RemoveField("ZHU_VLRTXT")

    EndIf

Return oView
/*/{Protheus.doc} gridFocus
    Fun��o executada quando a grid ganha foco.
    @type  Static Function
    @author Everson
    @since 25/07/2022
    @version 01
/*/
Static Function gridFocus(oView)

    //Vari�veis.
    Local aArea   := GetArea()
    Local oModel  := oView:GetModel()
    Local cNome   := oModel:GetValue("MD_MASTER","ZHU_NOME")

    If Empty(cNome)
        Help(Nil, Nil, "Fun��o gridFocus(ADQUA005P)", Nil, "Necess�rio informar o nome do item.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZHU_NOME"):OCtrl:SetFocus()
    
    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} getCmps
    Retorna campos do cabe�alho.
    @type  Static Function
    @author Everson
    @since 25/07/2022
    @version 01
/*/
Static Function getCmps()
Return "ZHU_FILIAL;ZHU_NUMERO;ZHU_NOME;ZHU_TPDADO;ZHU_UN;"
/*/{Protheus.doc} ADQUA5
    Ponto de entrada.
    @type  User Function
    @author Everson
    @since 26/07/2022
    @version 01
/*/
User Function ADQUA5()

    //Vari�veis.
    Local aArea     := GetArea()
	Local aParam	:= PARAMIXB
	Local xRet 		:= .T.
	Local oObj 		:= ""
	Local cIdPonto 	:= ""
	Local cIdModel 	:= ""
    Local oModelx   := Nil
    Local nOperation:= 0
    Local cNumero   := ""

	If aParam <> Nil

		oObj 	    := aParam[1]
		cIdPonto    := aParam[2]
		cIdModel    := aParam[3]
        nOperation  := oObj:GetOperation()

		If cIdPonto == "MODELCOMMITNTTS"

            oModelx := FWModelActive()
            cNumero := oModelx:GetValue("MD_MASTER", "ZHU_NUMERO")

            If nOperation == MODEL_OPERATION_INSERT
                cOperacao := "I"

            ElseIf nOperation == MODEL_OPERATION_UPDATE
                cOperacao := "A"

            ElseIf nOperation == MODEL_OPERATION_DELETE
                cOperacao := "D"

            EndIf

            If ! Empty(cOperacao) .And. ! Empty(cNumero)
                grvBarr(cOperacao, cNumero)

            EndIf

		EndIf

	EndIf

    RestArea(aArea)

Return xRet
/*/{Protheus.doc} grvBarr
    Salva o registro para enviar ao barramento.
    @type  Static Function
    @author Everson
    @since 26/07/2022
    @version 01
/*/
Static Function grvBarr(cOperacao, cNumero)

    //Vari�veis.
    Local aArea     := GetArea()
    Local cFilter   := ""
    Local cCmp      := getCmps()
    Local cTopico   := "tipo_analise_laboratorio_protheus"

    
    cFilter := " ZHU_FILIAL ='" + FWxFilial("ZHU") + "' .And. ZHU_NUMERO = '" + cNumero + "' "

    U_ADFAT27D("ZHU", 1, FWxFilial("ZHU") + cNumero,;
        "ZHU", 3, FWxFilial("ZHU") + cNumero, "ZHU_ITEM", cFilter,;
        cTopico, cOperacao,;
        .T., .T., .T.,;
        cCmp) 

    RestArea(aArea)

Return Nil
