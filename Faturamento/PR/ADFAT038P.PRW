#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static cTbMast := "ZIT"
Static cTitulo := "Cadastro de Apontamento de Lacre"
Static cTiMast := "Dados do cadastro de apontamento de lacre"

/*/{Protheus.doc} User Function ADFAT038P
    Cadastro de Apontamento de lacre.
    Cad Apt Lacre
    Chamado 18465.
    @type  Function
    @author Everson
    @since 01/03/2022
    @version 01
    /*/
User Function ADFAT038P() // U_ADFAT038P()

    //Vari�veis.
    Local oBrowse := FwLoadBrw("ADFAT038P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 01/03/2022
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
    @since 01/03/2022
    @version 01
/*/
Static Function MenuDef()
Return (FwMVCMenu("ADFAT038P"))
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 01/03/2022
    @version 01
/*/
Static Function ModelDef()
    
    //Vari�veis.
    Local bPre      := {|oModel| vldPre(oModel)}
    Local bPost     := {|oModel| vldPos(oModel)}
    Local bCancel   := {|| .T. }
    Local oModel    := MPFormModel():New("ADFAT38", bPre, bPost, /*bCommit*/, bCancel)
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
    @since 01/03/2022
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
    @since 01/03/2022
    @version 01
/*/
Static Function vldPos(oModel)

    //Vari�veis.
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
    // Local cRoteiro   := oModel:GetValue("MD_MASTER", "ZIT_ROTEIR")
    // Local cPlaca     := oModel:GetValue("MD_MASTER", "ZIT_PLACA")
    // Local cLacre     := oModel:GetValue("MD_MASTER", "ZIT_LACRE")

    If lRet .And. nOperation == MODEL_OPERATION_INSERT

        // DbSelectArea("ZIT")
        // ZIT->(DbSetOrder(6))
        // ZIT->(DbGoTop())
        // If ZIT->( DbSeek( FwxFilial("ZIT") + cRoteiro + cPlaca + cLacre ) )
        //     lRet := .F.
        //     Help(Nil, Nil, "Fun��o vldPos(ADFAT038P)", Nil, "Lacre " + cLacre + " j� utilizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        // EndIf
            
    EndIf
  
Return lRet
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 01/03/2022
    @version 01
/*/
Static Function ViewDef()
    
    //Vari�veis.
    Local oView     := FwFormView():New()
    Local oModel    := FwLoadModel("ADFAT038P")
    Local oStrMast  := FwFormStruct(2, cTbMast)

    oView:SetModel(oModel)

    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")

Return oView
/*/{Protheus.doc} User Function ADFAT38A
    Gera apontamento de lacre.
    @type  Function
    @author Everson
    @since 01/03/2022
    @version 01
    /*/
User Function ADFAT38A(cCP, cRoteiro, cOrdem, cPlaca, cLacre, cMsgError)

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local oModel    := Nil
    Local aError    := {}
    
    Default cMsgError := ""

    oModel := FwLoadModel("ADFAT038P")
    oModel:SetOperation(MODEL_OPERATION_INSERT)
    oModel:Activate() 

    oModel:SetValue("MD_MASTER","ZIT_CTPATI" ,cCP)
    oModel:SetValue("MD_MASTER","ZIT_ROTEIR" ,cRoteiro)
    oModel:SetValue("MD_MASTER","ZIT_ORDEM"  ,cOrdem)
    oModel:SetValue("MD_MASTER","ZIT_PLACA"  ,cPlaca)
    oModel:SetValue("MD_MASTER","ZIT_LACRE"  ,cLacre)

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

    If ! Empty(cMsgError)
        Help(Nil, Nil, "Fun��o ADFAT38A(ADFAT038P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADFAT38B
    Exclu� apontamento de lacre.
    @type  Function
    @author Everson
    @since 01/03/2022
    @version 01
    /*/
User Function ADFAT38B(cRoteiro, cPlaca, cLacre, cNmOrdem, cMsgError)

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local oModel    := Nil
    Local aError    := {}
    
    Default cMsgError := ""

    DbSelectArea("ZIT")
    ZIT->(DbSetOrder(7))
    ZIT->(DbGoTop())
    If ! ZIT->( DbSeek( FwxFilial("ZIT") + cRoteiro + cPlaca + cLacre + cNmOrdem ) )
        cMsgError := "Lacre " + cLacre + " n�o localizado."
        Help(Nil, Nil, "Fun��o ADFAT38B(ADFAT038P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .T.

    EndIf

    oModel := FwLoadModel("ADFAT038P")
    oModel:SetOperation(MODEL_OPERATION_DELETE)
    oModel:Activate() 

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

    If ! Empty(cMsgError)
        Help(Nil, Nil, "Fun��o ADFAT38B(ADFAT038P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT38
    Ponto de entrada.
    @type  User Function
    @author Everson
    @since 19/05/2022
    @version 01
/*/
User Function ADFAT38()

    //Vari�veis.
    Local aArea       := GetArea()
	Local aParam	  := PARAMIXB
	Local xRet 		  := .T.
	Local oObj 		  := ""
	Local cIdPonto 	  := ""
	Local cIdModel 	  := ""
    Local oModelx     := Nil
    Local nOperation  := 0
    Local cNumero     := ""
    
	If aParam <> Nil

		oObj 	    := aParam[1]
		cIdPonto    := aParam[2]
		cIdModel    := aParam[3]
        nOperation  := oObj:GetOperation()

		If cIdPonto == "MODELCOMMITNTTS"

            oModelx := FWModelActive()
            cNumero := oModelx:GetValue("MD_MASTER", "ZIT_ROTEIR") +;
                       oModelx:GetValue("MD_MASTER", "ZIT_PLACA") +;
                       oModelx:GetValue("MD_MASTER", "ZIT_LACRE") +;
                       oModelx:GetValue("MD_MASTER", "ZIT_ORDEM")

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
    @type  User Function
    @author Everson
    @since 19/05/2022
    @version 01
/*/
Static Function grvBarr(cOperacao, cNumero)

    //Vari�veis.
    Local aArea := GetArea()

	U_ADFAT27C(cTbMast, 7, "lacres_de_racao_protheus", cOperacao, FWxFilial(cTbMast) + cNumero)

    RestArea(aArea)

Return Nil
