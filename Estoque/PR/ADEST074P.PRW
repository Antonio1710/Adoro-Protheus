#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static cTbMast := "ZID"
Static cTitulo := "Solicita��o de Libera��o de Pesagem de Ensacados"
Static cTiMast := "Dados da solicita��o de libera��o de pesagem de ensacados"
Static xPula   := Chr(13) + Chr(10)

/*/{Protheus.doc} User Function ADEST074P
    Solicita��o de Libera��o de Pesagem de Ensacado.
    Cad Lib Pes Ensacados
    Chamado 18465.
    @type  Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
User Function ADEST074P() // U_ADEST074P()

    //Vari�veis.
    Local oBrowse := FwLoadBrw("ADEST074P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function BrowseDef()

    //Vari�veis.
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetDescription(cTitulo)

    oBrowse:SetMenuDef("ADEST074P")
    oBrowse:AddLegend("ZID_STATUS = '1'" ,"BLUE"  ,"Pendente")
	oBrowse:AddLegend("ZID_STATUS = '2'" ,"GREEN" ,"Aprovada")
	oBrowse:AddLegend("ZID_STATUS = '3'" ,"RED"	  ,"Reprovada")

    oBrowse:SetFilterDefault(" " + cTbMast + "_FILIAL = '" + FWxFilial(cTbMast) + "' ")

Return oBrowse
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function MenuDef()

    //Vari�veis.
	Local aRotina 	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PesqBrw"          	OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.ADEST074P" 	OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"      ACTION "U_ADEST741()" 	    OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD OPTION aRotina TITLE "Legenda"      ACTION "U_ADEST742()"       OPERATION 10  ACCESS 0

Return aRotina
/*/{Protheus.doc} ADEST741
    Altera��o.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
User Function ADEST741()

    If ZID->ZID_STATUS <> "1"
        Help(Nil, Nil, "Fun��o ADEST741(ADEST074P)", Nil, "Registro j� passou por processo de aprova��o.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        Return Nil

    EndIf

	FWExecView("", "ADEST074P", 4)

Return Nil
/*/{Protheus.doc} ADEST742
    Legenda.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
User Function ADEST742()

	//Vari�veis.
	Local aLegenda := {}

	Aadd(aLegenda,{"BR_AZUL"    ,"Pendente" })
	Aadd(aLegenda,{"BR_VERDE"   ,"Liberada"})
	Aadd(aLegenda,{"BR_VERMELHO","Reprovada"})

	BrwLegenda("Solic. Pesagem Manual","Legenda",aLegenda)

Return Nil
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function ModelDef()
    
    //Vari�veis.
    Local bPre      := {|oModel| vldPre(oModel)}
    Local bPost     := {|oModel| vldPos(oModel)}
    Local bCancel   := {|| .T. }
    Local oModel    := MPFormModel():New("ADEST74", bPre, bPost, /*bCommit*/, bCancel)
    Local oStrMast  := FwFormStruct(1, cTbMast)                                                
     
    //AddFields(<cId >, <cOwner >, <oModelStruct >, <bPre >, <bPost >, <bLoad >)
    oModel:AddFields("MD_MASTER", Nil, oStrMast)

    oModel:SetPrimaryKey({})

    //oModel:SetDescription(cTitulo)

    oModel:GetModel("MD_MASTER"):SetDescription(cTiMast)

Return oModel
/*/{Protheus.doc} vldPre
    P�s valida��o.
    @type  Static Function
    @author Everson
    @since 05/04/2022
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
    @since 05/04/2022
    @version 01
/*/
Static Function vldPos(oModel)

    //Vari�veis.
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
    Local cStatus    := oModel:GetValue("MD_MASTER", "ZID_STATUS")

    If lRet .And. nOperation == MODEL_OPERATION_UPDATE

        If cStatus $"2/3"
            oModel:SetValue("MD_MASTER","ZID_DTAPRO", Date())
            oModel:SetValue("MD_MASTER","ZID_HRAPRO", Time())
            oModel:SetValue("MD_MASTER","ZID_APROVA", __cUserID)
            oModel:SetValue("MD_MASTER","ZID_NMAPRV", cUserName)

        EndIf

    EndIf

Return lRet
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function ViewDef()
    
    //Vari�veis.
    Local oView     := FwFormView():New()
    Local oModel    := FwLoadModel("ADEST074P")
    Local oStrMast  := FwFormStruct(2, cTbMast)

    oView:SetModel(oModel)

    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")

Return oView
/*/{Protheus.doc} ADEST743
    Exclus�o de solicita��o de libera��o de pesagem de produtos ensacados.
    @type  User Function
    @author Everson
    @since 22/12/2021
    @version 01
/*/
User Function ADEST743(cNmOrdem, cMsgError)

    //Vari�veis.
    Local aArea := GetArea()
    Local lRet  := .F.
    Local oSolic:= Nil

    Default cMsgError := ""

    DbSelectArea("ZID")
    ZID->(DbSetOrder(2))
    If ! ZID->( DbSeek( FWxFilial("ZID") + cNmOrdem ) )
        RestArea(aArea)
        Return .T.

    EndIf

    oSolic := FwLoadModel("ADEST074P")

    oSolic:SetOperation(MODEL_OPERATION_DELETE)
    oSolic:Activate() 

    If oSolic:VldData()
        oSolic:CommitData()

        lRet := .T.
        
    Else
        aError := oSolic:GetErrorMessage()
        cMsgError := Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))

    EndIf

    oSolic:DeActivate()
    oSolic:Destroy()
    oSolic := Nil

    If ! Empty(cMsgError)
        Help(Nil, Nil, "Fun��o ADEST743(ADEST074P)", Nil, "Erro na exclus�o na solicita��o de libera��o de pesagem de produtos ensacados." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADEST744
	Posiciona no registro.
	@type  User Function
	@author Everson
	@since 22/07/2022
	@version 01
/*/
User Function ADEST744(cNumero)

    //Vari�veis.

    DbSelectArea("ZID")
    ZID->(DbSetOrder(1))
    ZID->(DbGoTop())
    If ! ZID->( DbSeek( FWxFilial("ZID") + cNumero ) )
        Return .F.

    EndIf

Return .T.
/*/{Protheus.doc} ADEST745
	Posiciona no registro pela ordem.
	@type  User Function
	@author Everson
	@since 22/07/2022
	@version 01
/*/
User Function ADEST745(cNmOrdem)

    //Vari�veis.

    DbSelectArea("ZID")
    ZID->(DbSetOrder(2))
    ZID->(DbGoTop())
    If ! ZID->( DbSeek( FWxFilial("ZID") + cNmOrdem ) )
        Return .F.

    EndIf

Return .T.
/*/{Protheus.doc} ADEST745
	Cria solicita��o.
	@type  User Function
	@author Everson
	@since 22/07/2022
	@version 01
/*/
User Function ADEST746(cPlaca, cNmOrdem, cProduto, nValor, nLimite, nDife, cMotivo, cNumLib, cMsgError)

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local oSolic    := Nil
    Local aError    := {}

    Default cMsgError   := ""

    oSolic := FwLoadModel("ADEST074P")

    oSolic:SetOperation(MODEL_OPERATION_INSERT)
    oSolic:Activate() 

    oSolic:SetValue("MD_MASTER","ZID_DATA"  ,Date())
    oSolic:SetValue("MD_MASTER","ZID_HORA"  ,Time())
    oSolic:SetValue("MD_MASTER","ZID_PLACA" ,cPlaca)
    oSolic:SetValue("MD_MASTER","ZID_ORDEM" ,cNmOrdem)
    oSolic:SetValue("MD_MASTER","ZID_MEMPRO",cProduto)
    oSolic:SetValue("MD_MASTER","ZID_VALOR" ,nValor)
    oSolic:SetValue("MD_MASTER","ZID_LIMITE",nLimite)
    oSolic:SetValue("MD_MASTER","ZID_DIFERE",nDife)
    oSolic:SetValue("MD_MASTER","ZID_MOTIVO",cMotivo)
    oSolic:SetValue("MD_MASTER","ZID_SOLIC" ,__cUserID)
    oSolic:SetValue("MD_MASTER","ZID_NMSOLI",cUserName)

    Begin Transaction

        If oSolic:VldData()
            oSolic:CommitData()
            lRet := .T.
            cNumLib := ZID->ZID_NUMERO

        Else
            aError := oSolic:GetErrorMessage()
            cMsgError := Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))

        EndIf

    End Transaction

    oSolic:DeActivate()
    oSolic:Destroy()
    oSolic := Nil

    If ! Empty(cMsgError)
        Help(Nil, Nil, "Fun��o ADEST746(ADEST074P)", Nil, "Erro na gera��o de registro de solicita��o de libera��o." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    Else
        Help(Nil, Nil, "Fun��o ADEST746(ADEST074P)", Nil, "Solicita��o gerada " + cNumLib + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)

Return lRet
