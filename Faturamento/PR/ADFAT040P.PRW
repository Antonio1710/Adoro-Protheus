#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static cTbMast := "ZIY"
Static cTitulo := "Cadastro de Apontamento de Silo"
Static cTiMast := "Dados do apontamento de silo"

/*/{Protheus.doc} User Function ADFAT040P
    Cadastro de Apontamento de silo.
    Cad Apt Silo
    Chamado 18465.
    @type  Function
    @author Everson
    @since 02/03/2022
    @version 01
    @history, Everson, 02/06/2022, ticket 18645 - removida valida��o para quando o registro vem do Job.
    /*/
User Function ADFAT040P() // U_ADFAT040P()

    //Vari�veis.
    Local oBrowse := FwLoadBrw("ADFAT040P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 02/03/2022
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
    @since 02/03/2022
    @version 01
/*/
Static Function MenuDef()
Return (FwMVCMenu("ADFAT040P"))
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 02/03/2022
    @version 01
/*/
Static Function ModelDef()
    
    //Vari�veis.
    Local bPre      := {|oModel| vldPre(oModel)}
    Local bPost     := {|oModel| vldPos(oModel)}
    Local bCancel   := {|| .T. }
    Local oModel    := MPFormModel():New("ADFAT40", bPre, bPost, /*bCommit*/, bCancel)
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
    @since 02/03/2022
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
    @since 02/03/2022
    @version 01
/*/
Static Function vldPos(oModel)

    //Vari�veis.
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
    Local cSilo      := oModel:GetValue("MD_MASTER", "ZIY_SILO")

    If lRet .And. nOperation == MODEL_OPERATION_INSERT

        If ! IsInCallStack("U_ADFAT049P") //Everson - 02/06/2022. Chamado 18465.

            DbSelectArea("ZIW")
            ZIW->(DbSetOrder(1))
            ZIW->(DbGoTop())
            If ! ZIW->( DbSeek( FwxFilial("ZIW") + cSilo ) )
                lRet := .F.
                Help(Nil, Nil, "Fun��o vldPos(ADFAT040P)", Nil, "Silo " + cSilo + " n�o localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

            EndIf

        EndIf
            
    EndIf
  
Return lRet
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 02/03/2022
    @version 01
/*/
Static Function ViewDef()
    
    //Vari�veis.
    Local oView     := FwFormView():New()
    Local oModel    := FwLoadModel("ADFAT040P")
    Local oStrMast  := FwFormStruct(2, cTbMast)

    oView:SetModel(oModel)

    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")

Return oView
/*/{Protheus.doc} User Function ADFAT38A
    Gera apontamento de silo.
    @type  Function
    @author Everson
    @since 02/03/2022
    @version 01
    /*/
User Function ADFAT40A(cCP, cRoteiro, cOrdem, cPlaca, cSilo, cMsgError)

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local oModel    := Nil
    Local aError    := {}
    
    Default cMsgError := ""

    oModel := FwLoadModel("ADFAT040P")
    oModel:SetOperation(MODEL_OPERATION_INSERT)
    oModel:Activate() 

    oModel:SetValue("MD_MASTER","ZIY_CTPATI" ,cCP)
    oModel:SetValue("MD_MASTER","ZIY_ROTEIR" ,cRoteiro)
    oModel:SetValue("MD_MASTER","ZIY_ORDEM"  ,cOrdem)
    oModel:SetValue("MD_MASTER","ZIY_PLACA"  ,cPlaca)
    oModel:SetValue("MD_MASTER","ZIY_SILO"   ,cSilo)

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
        Help(Nil, Nil, "Fun��o ADFAT40A(ADFAT040P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADFAT40B
    Exclu� apontamento de silo.
    @type  Function
    @author Everson
    @since 02/03/2022
    @version 01
    /*/
User Function ADFAT40B(cRoteiro, cPlaca, cOrdem, cSilo, cMsgError)

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local oModel    := Nil
    Local aError    := {}
    
    Default cMsgError := ""

    DbSelectArea("ZIY")
    ZIY->(DbSetOrder(1))
    ZIY->(DbGoTop())
    If ! ZIY->( DbSeek( FwxFilial("ZIY") + cRoteiro + cPlaca + cOrdem + cSilo ) )
        cMsgError := "Silo " + cSilo + " n�o localizado."
        Help(Nil, Nil, "Fun��o ADFAT40B(ADFAT040P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .T.

    EndIf

    oModel := FwLoadModel("ADFAT040P")
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
        Help(Nil, Nil, "Fun��o ADFAT40B(ADFAT040P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT40
    Ponto de entrada.
    @type  User Function
    @author Everson
    @since 19/05/2022
    @version 01
/*/
User Function ADFAT40()

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
            cNumero := oModelx:GetValue("MD_MASTER", "ZIY_ROTEIR") +;
                       oModelx:GetValue("MD_MASTER", "ZIY_PLACA") +;
                       oModelx:GetValue("MD_MASTER", "ZIY_ORDEM") +;
                       oModelx:GetValue("MD_MASTER", "ZIY_SILO")

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

	U_ADFAT27C(cTbMast, 1, "silos_de_racao_protheus", cOperacao, FWxFilial(cTbMast) + cNumero)

    RestArea(aArea)

Return Nil
