#Include "Totvs.ch"
#Include "FWMVCDef.ch"
#Include "Topconn.ch"

Static cTbMast := "ZHY"
Static cTitulo := "Cadastro Roteiro"
Static cTiMast := "Dados do cadastro roteiro"

Static xPula := Chr(13) + Chr(10)

/*/{Protheus.doc} User Function ADVEN110P
    Visita Programada Promotor
    @type  Function
    @author Everson
    @since 31/07/2022
/*/
User Function ADVEN110P() // U_ADVEN110P()

    //Vari�veis
    Local oBrowse := FwLoadBrw("ADVEN110P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
Static Function BrowseDef()

    //Vari�veis
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetDescription(cTitulo)

    oBrowse:SetMenuDef("ADVEN110P")

    oBrowse:SetFilterDefault(" " + cTbMast + "_FILIAL = '" + FWxFilial(cTbMast) + "' ")

Return oBrowse
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
Static Function MenuDef()

    //Vari�veis
	Local aRotina 	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PesqBrw"          	OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.ADVEN110P" 	OPERATION MODEL_OPERATION_VIEW      ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" 	    ACTION "U_ADVN1105()" 	    OPERATION MODEL_OPERATION_INSERT    ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"      ACTION "U_ADVN1103(4)" 	    OPERATION MODEL_OPERATION_UPDATE    ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" 	    ACTION "U_ADVN1103(5)" 	    OPERATION MODEL_OPERATION_DELETE    ACCESS 0
    ADD OPTION aRotina TITLE "Env. Cliente" ACTION "U_ADVN1106()"       OPERATION 10  ACCESS 0
    // ADD OPTION aRotina TITLE "Proc Integr." ACTION "U_ADVN1101(.F.)"    OPERATION 11  ACCESS 0

Return aRotina
/*/{Protheus.doc} User Function ADVN1105
    Inclus�o.
    @type  Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
User Function ADVN1105()

    //Vari�veis
    Local aArea  := GetArea()
    
    DbSelectArea("ZHY")
    ZHY->(DbSetOrder(3))
    ZHY->(DbGoTop())
    If ZHY->( DbSeek( FWxFilial("ZHY") + "1" ) )
        MsgInfo("J� h� o registro " + ZHY->ZHY_NUMERO + " do tipo 'Programada'.", "Fun��o ADVN1105(ADVEN110P)")
        RestArea(aArea)
        Return Nil

    EndIf

    DbSelectArea("ZHY")
    ZHY->(DbSetOrder(3))
    ZHY->(DbGoTop())
    If ZHY->( DbSeek( FWxFilial("ZHY") + "2" ) )
        FWExecView("", "ADVEN110P", 9)

    Else
        FWExecView("", "ADVEN110P", 3)

    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADVN1103
    Altera��o e exclus�o.
    @type  Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
User Function ADVN1103(nOPc)

    //Vari�veis
    Local aArea := GetArea()

    If ZHY->ZHY_TIPO == "2"
        MsgInfo("Opera��o n�o permitida.", "Fun��o ADVN1103(ADVEN110P)")
        RestArea(aArea)
        Return Nil

    EndIf
    
    FWExecView("", "ADVEN110P", nOPc)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
Static Function ModelDef()
    
    //Vari�veis
    Local oModel    := Nil
    Local oStrMast  := FWFormStruct(1, cTbMast, {|cCampo| AllTRim(cCampo) $ getCmps()})
    Local oStrGrid  := FWFormStruct(1, cTbMast)
 
    oModel := MPFormModel():New("ADVN110", /*bPreValidacao*/, , /*bCommit*/, /*bCancel*/ )
 
    oModel:AddFields("MD_MASTER", NIL, oStrMast)
    oModel:AddGrid("MD_GRID", "MD_MASTER", oStrGrid, ,)
 
    oModel:SetRelation("MD_GRID", {;
            {"ZHY_FILIAL", 'FWxFilial("' + cTbMast + '")'},;
            {"ZHY_NUMERO", "ZHY_NUMERO"},;
            {"ZHY_DESC"  , "ZHY_DESC"},;
            {"ZHY_DTINI" , "ZHY_DTINI"},;
            {"ZHY_TIPO"  , "ZHY_TIPO"};
        }, (cTbMast)->(IndexKey(1)))

    oModel:GetModel("MD_GRID"):SetUniqueLine({"ZHY_PROMOT", "ZHY_CLIENT", "ZHY_LOJA"})

    oModel:SetDescription(cTiMast)
    oModel:SetPrimaryKey({})

Return oModel
/*/{Protheus.doc} User Function ADVN110
    Ponto de entrada.
    @type  Function
    @author Everson
    @since 01/08/2022
    @version 01
/*/
User Function ADVN110()

    //Vari�veis.
    Local aParam    := PARAMIXB 
    Local xRet      := .T. 
    Local oObj      := "" 
    Local cIdPonto  := "" 
    Local cIdModel  := "" 
    Local oModelX   := nil
    Local oView     := Nil

    If aParam <> NIL
    
        oObj     := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
    
        If cIdPonto == "BUTTONBAR"
    
            oModelX := FwModelActive()
        
            If oModelX:IsCopy()

                FWFldPut("ZHY_TIPO","1")
                FWFldPut("ZHY_NUMERO",GetSXENum("ZHY","ZHY_NUMERO"))
                FWFldPut("ZHY_DTINI",Date()+1)
                
                oView := FWViewActive()
                oView:Refresh()
                oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZHY_DTINI"):OCtrl:SetFocus()
            
            EndIf
        
        EndIf
    
    EndIf

Return xRet
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
Static Function ViewDef()
    
    //Vari�veis
    Local oView     := Nil
    Local oModel    := FWLoadModel("ADVEN110P")
    Local cCampos   := getCmps()
    Local oStrMast  := FWFormStruct(2, cTbMast, {|cCampo| AllTRim(cCampo) $ cCampos})
    Local oStrGrid  := FWFormStruct(2, cTbMast, {|cCampo| !(Alltrim(cCampo) $ cCampos)})

    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")
    oView:AddGrid("VW_GRID",    oStrGrid, "MD_GRID",,{|| gridFocus(oView) })
 
    oView:CreateHorizontalBox("MAIN", 20)
    oView:CreateHorizontalBox("GRID", 80)

    oView:SetOwnerView("VW_MASTER", "MAIN")
    oView:SetOwnerView("VW_GRID", "GRID")
    oView:EnableControlBar(.T.)
 
    oView:AddIncrementField("VW_GRID", "ZHY_ITEM")

    oView:SetViewProperty( "VW_GRID" , "ENABLENEWGRID" ) 
    // oView:SetViewProperty( "VW_GRID", "GRIDNOORDER")
    oView:SetViewProperty( "VW_GRID", "GRIDFILTER", {.T.}) 
    oView:SetViewProperty( "VW_GRID", "GRIDSEEK", {.T.})

    oView:AddUserButton("Carga Inicial","",{|oView| MsAguarde({|| carProd() }, "Aguarde", "Processando...") } ,"",, {MODEL_OPERATION_INSERT} , .T. ) 

Return oView
/*/{Protheus.doc} gridFocus
    Fun��o executada quando a grid ganha foco.
    @type  Static Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
Static Function gridFocus(oView)

    //Vari�veis
    Local aArea   := GetArea()
    Local oModel  := oView:GetModel()
    Local cDesc   := oModel:GetValue("MD_MASTER","ZHY_DESC")
    Local dDtIni  := oModel:GetValue("MD_MASTER","ZHY_DTINI")

    If Empty(cDesc)
        Help(Nil, Nil, "Fun��o gridFocus(ADVEN110P)", Nil, "Necess�rio informar a descri��o.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZHY_DESC"):OCtrl:SetFocus()

    ElseIf Empty(dDtIni)
        Help(Nil, Nil, "Fun��o gridFocus(ADVEN110P)", Nil, "Necess�rio informar a data de in�cio.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZHY_DTINI"):OCtrl:SetFocus()

    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} getCmps
    Retorna campos do cabe�alho.
    @type  Static Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
Static Function getCmps()
Return "ZHY_FILIAL;ZHY_NUMERO;ZHY_DESC;ZHY_DTINI;ZHY_TIPO;"
/*/{Protheus.doc} ADVN1101
    Integra registros de visitas.
    @type  Static Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
User Function ADVN1101(lAut)

    //Vari�veis
    Local aArea     := GetArea()
    Local lReRest   := .F.
    Local cUrl      := Alltrim(cValToChar(GetMV("MV_#VEN591",,"http://3.23.20.133:8082/api")))
    Local cToken    := ""
    Local cMsgError := ""
    Local cQuery    := ""
    Local data      := ""
    Local portfolio := ""
    Local cCliente  := ""
    Local cLoja     := ""
    Local cTopico   := ""
    Local cTipo     := ""
    Local cHInicio  := ""
    Local cHFim     := ""
    Local cDiaSema  := ""
    Local cData     := ""
    Local lRetEnv   := .F.
    Local dData     := Date()+1

    Default lAut    := .T.

    If ! lAut

        If ! Pergunte("ADVEN1101")
            RestArea(aArea)
            Return Nil

        EndIf

        If Empty(MV_PAR01)
            RestArea(aArea)
            Return Nil

        EndIF

        dData := MV_PAR01

    EndIf

    cQuery:= ""
    cQuery += " SELECT " 
        cQuery += " * " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZHY") + " (NOLOCK) AS ZHY " 
    cQuery += " WHERE " 
    cQuery += " ZHY_FILIAL = '" + FWxFilial("ZHY") + "' " 
    cQuery += " AND ZHY_TIPO = '1' " 
    cQuery += " AND ZHY_DTINI = '" + DToS(dData) + "' " 
    cQuery += " AND D_E_L_E_T_ = '' " 

    If Select("D_CHANGE") > 0
        D_CHANGE->(DbCloseArea())

    EndIf

    TcQuery cQuery New Alias "D_CHANGE"
    DbSelectArea("D_CHANGE")
    If ! D_CHANGE->(Eof())

        TcSqlExec(" UPDATE " + RetSqlName("ZHY") + " SET ZHY_TIPO = '2' WHERE ZHY_FILIAL = '" + FWxFilial("ZHY") + "' AND ZHY_NUMERO = '" + D_CHANGE->ZHY_NUMERO + "' AND D_E_L_E_T_ = '' ")
   
        TcSqlExec(" UPDATE " + RetSqlName("ZHY") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE ZHY_FILIAL = '" + FWxFilial("ZHY") + "' AND ZHY_NUMERO <> '" + D_CHANGE->ZHY_NUMERO + "' AND D_E_L_E_T_ = '' ")

    EndIf
    D_CHANGE->(DbCloseArea())

    MsAguarde({|| lReRest := U_ADVEN592(cUrl, @cToken, @cMsgError) }, "Fun��o ADVN1101(ADVEN110P)", "Efetuando login...")

	If ! lReRest
		MsgInfo("N�o foi poss�vel efetuar login " + xPula + cMsgError, "Fun��o ADVN1101(ADVEN110P)")
		RestArea(aArea)
		Return Nil

	EndIf

    cDiaSema := cValToChar(Dow(dData))

    cQuery := ""
    cQuery += " SELECT *, " 


    If cDiaSema == "2"
        cQuery += " ZHY_SEGUND AS HORARIO " 

    ElseIf cDiaSema == "3"
        cQuery += " ZHY_TERCA AS HORARIO " 

    ElseIf cDiaSema == "4"
        cQuery += " ZHY_QUARTA AS HORARIO " 

    ElseIf cDiaSema == "5"
        cQuery += " ZHY_QUINTA AS HORARIO " 

    ElseIf cDiaSema == "6"
        cQuery += " ZHY_SEXTA AS HORARIO " 

    ElseIf cDiaSema == "7"
        cQuery += " ZHY_SABADO AS HORARIO " 

    EndIf

    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZHY") + " (NOLOCK) AS ZHY " 
    cQuery += " WHERE " 
        cQuery += " ZHY_FILIAL = '" + FWxFilial("ZHY") + "' " 
        cQuery += " AND ZHY_TIPO = '2' " 

    If cDiaSema == "2"
        cQuery += " AND ZHY_SEGUND <> '' " 

    ElseIf cDiaSema == "3"
        cQuery += " AND ZHY_TERCA <> '' " 

    ElseIf cDiaSema == "4"
        cQuery += " AND ZHY_QUARTA <> '' " 

    ElseIf cDiaSema == "5"
        cQuery += " AND ZHY_QUINTA <> '' " 

    ElseIf cDiaSema == "6"
        cQuery += " AND ZHY_SEXTA <> '' " 

    ElseIf cDiaSema == "7"
        cQuery += " AND ZHY_SABADO <> '' " 

    EndIf

    cQuery += " AND D_E_L_E_T_ = '' " 

	If Select("D_VISPRO") > 0
		D_VISPRO->(DbCloseArea())

	EndIf

    DbSelectArea("ZHY")
    ZHY->(DbSetOrder(1))
    ZHY->(DbGoTop())

	TcQuery cQuery New Alias "D_VISPRO"
	DbSelectArea("D_VISPRO")
	D_VISPRO->(DbGoTop())

    While ! D_VISPRO->(Eof())

        lRetEnv  := .F.
        cData    := DToS(dData)

        data      := SubStr(cData, 1, 4) + "-" + Padl(SubStr(cData, 5, 2), 2, "0") + "-" + Padl(SubStr(cData, 7, 2), 2, "0")
        portfolio := Alltrim(cValToChar(D_VISPRO->ZHY_PROMOT))
        cCliente  := Alltrim(cValToChar(D_VISPRO->ZHY_CLIENT))
        cLoja     := Alltrim(cValToChar(D_VISPRO->ZHY_LOJA))
        cTopico   := "Visita de Rotina"
        cTipo     := "programed"
        cHInicio  := U_ADVN113(D_VISPRO->HORARIO)
        cHFim     := U_ADVN113(cValToChar(Val(D_VISPRO->HORARIO)+1))

        MsAguarde({|| U_ADVN1092(.F., cUrl, cToken,;
                                 data, portfolio, cCliente, cLoja, cTopico, cTipo, cHInicio, cHFim, @lRetEnv) }, "Fun��o ADVN1101(ADVEN110P)", "Enviando visitas...")

        If lRetEnv .And. ZHY->( DbSeek( FWxFilial("ZHY") + D_VISPRO->ZHY_NUMERO + D_VISPRO->ZHY_ITEM ) )

            RecLock("ZHY", .F.)
                ZHY->ZHY_DTULTA := Date()+1
            MsUnlock()

        EndIf

        D_VISPRO->(DbSkip())

	End

	D_VISPRO->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} U_ADVN113
    Retorna hor�rio.
    @type  User Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
User Function ADVN113(cOpc)

    //Vari�veis.
    Local cHorario := "00:00"

    If cOpc == "1"
        cHorario := "08:00"

    ElseIf cOpc == "2"
        cHorario := "09:00"

    ElseIf cOpc == "3"
        cHorario := "10:00"

    ElseIf cOpc == "4"
        cHorario := "11:00"

    ElseIf cOpc == "5"
        cHorario := "12:00"

    ElseIf cOpc == "6"
        cHorario := "13:00"

    ElseIf cOpc == "7"
        cHorario := "14:00"

    ElseIf cOpc == "8"
        cHorario := "15:00"

    ElseIf cOpc == "9"
        cHorario := "16:00"

    EndIf

Return cHorario
/*/{Protheus.doc} ADVN1102
    Job para integrar registros de visitas.
    @type  Static Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
User Function ADVN1102() // U_ADVN1102()

    RPCSetType(3)
	RpcSetEnv("01","02",,,,GetEnvServer(),{ })

        U_ADVN1101()

	RpcClearEnv()

Return Nil
/*/{Protheus.doc} carProd
    Carrega produtos do cliente.
    @type  Static Function
    @author Everson
    @since 03/08/2022
    @version 01
/*/
Static Function carProd()

    //Vari�veis.
    Local aArea     := GetArea()
    Local oView     := FWViewActive()
    Local oHeader   := oView:GetModel("MD_MASTER")
    Local oGrid     := oView:GetModel("MD_GRID")
    Local cQuery    := ""
    Local cNumero   := oHeader:GetValue("ZHY_NUMERO")
    Local cDesc     := oHeader:GetValue("ZHY_DESC")
    Local dDtIni    := oHeader:GetValue("ZHY_DTINI")
    Local cTipo     := oHeader:GetValue("ZHY_TIPO")

    If Empty(cDesc) .Or. Empty(dDtIni)
        MsgInfo("Necess�rio informar a descri��o e a data inicial.", "Fun��o carProd(ADVEN110P)")
        RestArea(aArea)
        Return Nil

    EndIf

    cQuery := ""
    cQuery += " SELECT " 
        cQuery += " A1_XPROMOT, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_REDE, A1_VEND " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("SA1") + " (NOLOCK) AS SA1 " 
    cQuery += " WHERE " 
        cQuery += " A1_FILIAL = '" + FWxFilial("SA1") + "' " 
        cQuery += " AND A1_MSBLQL = '2' " 
        cQuery += " AND A1_XPROMOT <> '' " 
        cQuery += " AND SA1.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY A1_XPROMOT, A1_REDE, A1_COD, A1_LOJA " 

    If Select("D_PROMOT") > 0
        D_PROMOT->(DbCloseArea())

    EndIf

    TcQuery cQuery New Alias "D_PROMOT"
    DbSelectArea("D_PROMOT")

    U_ADVN1104()

    If ! D_PROMOT->(Eof())

        FWFldPut("ZHY_NUMERO" , cNumero)
        FWFldPut("ZHY_DESC"   , cDesc)
        FWFldPut("ZHY_DTINI"  , dDtIni)
        FWFldPut("ZHY_TIPO"   , cTipo)

        oGrid:setValue("ZHY_FILIAL", FWxFilial("ZHY"))
        oGrid:setValue("ZHY_NUMERO", cNumero)
        oGrid:setValue("ZHY_DESC"  , cDesc)
        oGrid:setValue("ZHY_DTINI" , dDtIni)
        oGrid:setValue("ZHY_TIPO"  , cTipo)

        cNmPromot := Posicione("ZC4", 1, FWxFilial("ZC4") + D_PROMOT->A1_XPROMOT, "ZC4_NREDUZ")

        oGrid:setValue("ZHY_PROMOT", D_PROMOT->A1_XPROMOT)
        oGrid:setValue("ZHY_NMPROT", cNmPromot)
        oGrid:setValue("ZHY_CLIENT", D_PROMOT->A1_COD)
        oGrid:setValue("ZHY_LOJA"  , D_PROMOT->A1_LOJA)
        oGrid:setValue("ZHY_NOME"  , D_PROMOT->A1_NREDUZ)
        oGrid:setValue("ZHY_REDE"  , D_PROMOT->A1_REDE)
        oGrid:setValue("ZHY_VEND"  , D_PROMOT->A1_VEND)

        oGrid:setValue("ZHY_SEGUND"  , Space(TamSX3("ZHY_SEGUNDA")[1]))
        oGrid:setValue("ZHY_TERCA"   , Space(TamSX3("ZHY_TERCA")[1]))
        oGrid:setValue("ZHY_QUARTA"  , Space(TamSX3("ZHY_QUARTA")[1]))
        oGrid:setValue("ZHY_QUINTA"  , Space(TamSX3("ZHY_QUINTA")[1]))
        oGrid:setValue("ZHY_SEXTA"   , Space(TamSX3("ZHY_SEXTA")[1]))
        oGrid:setValue("ZHY_SABADO"  , Space(TamSX3("ZHY_SABADO")[1]))

        While ! D_PROMOT->(Eof())

            oGrid:addLine()

            oGrid:setValue("ZHY_FILIAL", FWxFilial("ZHY"))
            oGrid:setValue("ZHY_NUMERO", cNumero)
            oGrid:setValue("ZHY_DESC"  , cDesc)
            oGrid:setValue("ZHY_DTINI" , dDtIni)
            oGrid:setValue("ZHY_TIPO"  , cTipo)

            oGrid:setValue("ZHY_PROMOT", D_PROMOT->A1_XPROMOT)
            oGrid:setValue("ZHY_CLIENT", D_PROMOT->A1_COD)
            oGrid:setValue("ZHY_LOJA"  , D_PROMOT->A1_LOJA)
            oGrid:setValue("ZHY_NOME"  , D_PROMOT->A1_NREDUZ)
            oGrid:setValue("ZHY_REDE"  , D_PROMOT->A1_REDE)
            oGrid:setValue("ZHY_VEND"  , D_PROMOT->A1_VEND)

            oGrid:setValue("ZHY_SEGUND"  , Space(TamSX3("ZHY_SEGUNDA")[1]))
            oGrid:setValue("ZHY_TERCA"   , Space(TamSX3("ZHY_TERCA")[1]))
            oGrid:setValue("ZHY_QUARTA"  , Space(TamSX3("ZHY_QUARTA")[1]))
            oGrid:setValue("ZHY_QUINTA"  , Space(TamSX3("ZHY_QUINTA")[1]))
            oGrid:setValue("ZHY_SEXTA"   , Space(TamSX3("ZHY_SEXTA")[1]))
            oGrid:setValue("ZHY_SABADO"  , Space(TamSX3("ZHY_SABADO")[1]))

            D_PROMOT->(DbSkip())

        End

    Else
        oGrid:addLine()

    EndIf

    D_PROMOT->(DbCloseArea())

    oGrid:goLine(1)

    oView:refresh()

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADVN1104
    Apaga dados da grid.
    @type  User Function
    @author Everson
    @since 03/08/2022
    @version 01
/*/
User Function ADVN1104()

    //Vari�veis.
    Local oView  := FWViewActive()
    Local oGrid  := Nil

    oGrid := oView:GetModel("MD_GRID")
    oGrid:ClearData()

    oView:refresh()

Return oGrid:length() == 1
/*/{Protheus.doc} User Function ADVN1106
    Envia cadastro de cliente para AWS.
    @type  Function
    @author Everson
    @since 24/08/2022
    @version 01
/*/
User Function ADVN1106()

    //Vari�veis.
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local lReRest   := .F.
    Local cMsgError := ""
    Local oJson     := Nil
    Local nPosVirg  := 0
    Local cEnd      := ""
    Local cNumero   := ""
    Local lRetEnv   := .F.
    Local cUrl      := Alltrim(cValToChar(GetMV("MV_#VEN591",,"http://3.23.20.133:8082/api")))
    Local cServico  := "/accounts"
    Local cMetodo   := "Post"
    Local cToken    := ""
    Local cBody     := ""
    Local cMsg      := ""

    If ! Pergunte("ADVEN1102", .T.)
        RestArea(aArea)
        Return Nil

    EndIf

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " * " 
    cQuery += " FROM  " 
        cQuery += " " + RetSqlName("SA1") + " (NOLOCK) AS SA1 " 
    cQuery += " WHERE " 
        cQuery += " A1_FILIAL = '" + FWxFilial("SA1") + "' " 
        cQuery += " AND A1_COD BETWEEN '" +  MV_PAR01+ "' AND '" + MV_PAR03 + "' " 
        cQuery += " AND A1_LOJA BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR04 + "' " 
        cQuery += " AND A1_XPROMOT BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " 
        cQuery += " AND A1_XPROMOT <> '' " 
        cQuery += " AND SA1.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY " 
    cQuery += " A1_COD, A1_LOJA "

    If Select("D_CLIENTE") > 0
		D_CLIENTE->(DbCloseArea())

	EndIf 

    TcQuery cQuery New Alias "D_CLIENTE"
	DbSelectArea("D_CLIENTE")
	D_CLIENTE->(DbGoTop())

    If D_CLIENTE->(Eof())
        D_CLIENTE->(DbCloseArea())
        MsgInfo("N�o h� dados para os par�metros informados.", "Fun��o ADVN1106(ADVEN110P)")
        RestArea(aArea)
        Return Nil

    EndIf

    MsAguarde({|| lReRest := U_ADVEN592(cUrl, @cToken, @cMsgError) }, "Fun��o ADVN1106(ADVEN110P)", "Efetuando login...")

    If ! lReRest
		MsgInfo("N�o foi poss�vel efetuar login " + xPula + cMsgError, "Fun��o ADVN1106(ADVEN110P)")
		RestArea(aArea)
		Return Nil

	EndIf

    While ! D_CLIENTE->(Eof())

        oJson := JsonObject():new()

        nPosVirg :=  At(",", Alltrim(cValToChar(D_CLIENTE->A1_END)))
        
        If nPosVirg > 0
            cEnd    := Substr(Alltrim(cValToChar(D_CLIENTE->A1_END)), 1, nPosVirg -1)
            cNumero := Substr(Alltrim(cValToChar(D_CLIENTE->A1_END)), nPosVirg + 1, 1000)

        EndIf

        oJson['name'] := Alltrim(cValToChar(D_CLIENTE->A1_NREDUZ))
        oJson['portfolio'] := Alltrim(cValToChar(D_CLIENTE->A1_XPROMOT))
        oJson['sa1'] := Alltrim(cValToChar(D_CLIENTE->A1_COD)) + Alltrim(cValToChar(D_CLIENTE->A1_LOJA))
        oJson['cnpj'] := Alltrim(cValToChar(D_CLIENTE->A1_CGC))
        oJson['street'] := Iif(Empty(cEnd), Alltrim(cValToChar(D_CLIENTE->A1_END)), cEnd)
        oJson['streetNumber'] := cNumero
        oJson['district'] := Alltrim(cValToChar(D_CLIENTE->A1_BAIRRO))
        oJson['city'] := Alltrim(cValToChar(D_CLIENTE->A1_MUN))
        oJson['region'] := Alltrim(cValToChar(D_CLIENTE->A1_EST))
        oJson['contactName'] := Alltrim(cValToChar(D_CLIENTE->A1_CONTATO))
        oJson['contactEmail'] := Alltrim(cValToChar(D_CLIENTE->A1_EMAICO))
        oJson['contactPhone'] := Alltrim(cValToChar(D_CLIENTE->A1_DDD)) + Alltrim(cValToChar(D_CLIENTE->A1_TEL))
        oJson['contactCel'] := Alltrim(cValToChar(D_CLIENTE->A1_TEL5))
        oJson['category'] := ""

        If !Empty(D_CLIENTE->A1_XLATITU) .And. !Empty(D_CLIENTE->A1_XLONGIT)
            oJson['latitude']  := StrTran(Alltrim(cValToChar(D_CLIENTE->A1_XLATITU)), ",", ".")
            oJson['longitude'] := StrTran(Alltrim(cValToChar(D_CLIENTE->A1_XLONGIT)), ",", ".")

        EndIf

        cBody := AnsiToOem(oJson:toJSON())
        cMsg  := ""

        MsAguarde({|| lRetEnv := U_ADVEN593(cUrl, cServico, cMetodo, cToken, cBody, @cMsg) }, "Aguarde", "Enviando " + Alltrim(cValToChar(D_CLIENTE->A1_COD)) + Alltrim(cValToChar(D_CLIENTE->A1_LOJA)) + " " + Alltrim(cValToChar(D_CLIENTE->A1_NREDUZ)))

        If ! lRetEnv
            U_TExTelaMen("Erro - Cadastro Cliente " + Alltrim(cValToChar(D_CLIENTE->A1_COD)) + Alltrim(cValToChar(D_CLIENTE->A1_LOJA)) , cMsg, "Arial",10,,.F.,.F.)


        EndIf

        FreeObj(oJson)
        oJson := Nil

        D_CLIENTE->(DbSkip())
  
    End

    D_CLIENTE->(DbCloseArea())

    MsgInfo("Processo finalizado", "Fun��o ADVN1106(ADVEN110P)")

    RestArea(aArea)

Return Nil
