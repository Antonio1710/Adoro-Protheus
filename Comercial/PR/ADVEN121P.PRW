#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static cTbMast := "ZJE"
Static cTitulo := "Preços mínimos"
Static cTiMast := "Dados do preço mínimo"
Static cCodUsr := ""
Static lAdm    := .F.
Static lBack   := .F.
Static lVend   := .F.
Static lSuperv := .F.
Static lDiret  := .F.
Static xPula   := Chr(13) + Chr(10)

/*/{Protheus.doc} User Function ADVEN121P
    Preços mínimos.
    Chamado 91301.
    @type  Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
User Function ADVEN121P() // U_ADVEN121P()

    //Variáveis.
    Local oBrowse := Nil

    carVariaveis() 

    If ! (lAdm .Or. lBack .Or. lVend .Or. lSuperv .Or. lDiret)
        Return Nil

    EndIf

    oBrowse := FwLoadBrw("ADVEN121P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} carVariaveis
    Carrega variáveis estáticas.
    @type  Static Function
    @author Everson
    @since 08/05/2023
    @version 01
/*/
Static Function carVariaveis()

    //Variáveis.
    Local aArea := GetArea()

    U_ADVE118Q(@cCodUsr, @lAdm, @lBack, @lVend, @lSuperv, @lDiret)
    
    RestArea(aArea)

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

    If ! lAdm .And. ! lBack .And. ! lDiret
        oBrowse:SetFilterDefault("ZJE_USUARI = '" + cCodUsr + "' ")

    EndIf

    oBrowse:AddLegend("ZJE->ZJE_ATIVO = '1'", "BR_VERDE"   , "Ativo")
    oBrowse:AddLegend("ZJE->ZJE_ATIVO = '2'", "BR_VERMELHO", "Inativo")

    oBrowse:SetMenuDef("ADVEN121P")

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

	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"            OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.ADVEN121P"  OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" 	  ACTION "U_ADVE1210(3)"      OPERATION MODEL_OPERATION_INSERT ACCESS 0
	// ADD OPTION aRotina TITLE "Alterar"    ACTION "U_ADVE1210(4)"   	  OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Inativar"   ACTION "U_ADVE1210(11)"   	  OPERATION 11 ACCESS 0
	// ADD OPTION aRotina TITLE "Excluir" 	    ACTION "U_ADVE1210(5)" 	OPERATION MODEL_OPERATION_DELETE    ACCESS 0

Return aRotina
/*/{Protheus.doc} User Function ADVE1210
    CRUD.
    @type  Function
    @author Everson
    @since 03/04/2023
    @version 01
/*/
User Function ADVE1210(nOpc)

    //Variáveis.
    Local aArea     := GetArea()
    Local cAcao     := "Altera"
    Local cStatus   := ""
    Local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T., Nil},{.T., Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

    If (nOpc == 4 .Or. nOpc == 11) .And. ZJE->ZJE_ATIVO == "2"
        Help(Nil, Nil, "Função ADVE1210(ADVEN121P)", Nil, "Registro já inativado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return Nil

    EndIf

    If nOpc == 11

        If ! MsgYesNo("Deseja inativar o registro?", "Função ADVE1210(ADVEN121P)")
            RestArea(aArea)
            Return Nil

        EndIf

        RecLock("ZJE", .F.)
            ZJE->ZJE_ATIVO := "2"
        ZJE->(MsUnlock())

        MsgInfo("Processo finalizado.", "Função ADVE1210(ADVEN121P)")

    Else

        FWExecView(cAcao + cStatus, "ADVEN121P", nOpc, , , , , aButtons)

    EndIf

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
Static Function ModelDef()
    
    //Variáveis.
    Local bPre      := {|| .T. }
    Local bPost     := {|oModel| vldPos(oModel) }
    Local bCancel   := {|| .T. }
    Local oModel    := MPFormModel():New("ADVE121", bPre, bPost, /*bCommit*/, bCancel)
    Local oStrMast  := FwFormStruct(1, cTbMast)                                               
     
    oModel:AddFields("MD_MASTER", Nil, oStrMast)

    oModel:SetPrimaryKey({})

    oModel:SetDescription(cTitulo)

    oModel:GetModel("MD_MASTER"):SetDescription(cTiMast)

Return oModel
/*/{Protheus.doc} vldPos
    Pós validação.
    @type  Static Function
    @author Everson
    @since 10/04/2023
    @version 01
/*/
Static Function vldPos(oModel)

    //Variáveis.
    Local aArea      := GetArea()
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
    Local cProduto   := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZJE_PRODUT")))
    Local cSuperv    := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZJE_SUPERV")))
    Local cVended    := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZJE_VENDED")))

    If lRet .And. (nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE)

        If lRet .And. lSuperv .And. Empty(cVended)
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADVEN121P)", Nil, "Necessário selecionar ao menos um vendedor.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

        If lRet .And. (lAdm .Or. lSuperv) .And. ! Empty(cVended) .And. chkVend(cProduto, cVended)
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADVEN121P)", Nil, "Já há preço mínimo cadastrado para o vendedor x produto.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

        If lRet .And. lBack .And. Empty(cSuperv)
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADVEN121P)", Nil, "Necessário selecionar ao menos um supervisor.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

        If lRet .And. (lAdm .Or. lBack) .And. ! Empty(cSuperv) .And. chkSup(cProduto, cSuperv)
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADVEN121P)", Nil, "Já há preço mínimo cadastrado para o supervisor x produto.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

    EndIf
    
    RestArea(aArea)

Return lRet
/*/{Protheus.doc} chkVend
    Verifica se já há preço mínimo para o produto x vendedor.
    @type  Static Function
    @author Everson
    @since 08/05/2023
    @version 01
/*/
Static Function chkVend(cProduto, cVended)

    //Variáveis.
    Local aArea  := GetArea()
    Local lRet   := .F.
    Local cQuery := ""
    Local cAlias := GetNextAlias()
    Local aVend  := Separa(cVended, xPula, .F.)
    Local nAux   := 1

    cQuery := " SELECT R_E_C_N_O_ AS REC "
        cQuery += " FROM " + RetSqlName("ZJE") + " (NOLOCK) AS ZJE "
    cQuery += " WHERE "
        cQuery += " ZJE_FILIAL = '" + FWxFilial("ZJE") + "' "
        cQuery += " AND ZJE_ATIVO = '1' "
        cQuery += " AND ZJE_USUARI = '" + cCodUsr  + "' "
        cQuery += " AND ZJE_PRODUT = '" + cProduto + "' "
        cQuery += " AND ZJE_VENDED IS NOT NULL "
        cQuery += " AND ZJE.D_E_L_E_T_ = '' "
    cQuery += " ORDER BY ZJE_TOTVEN "

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    While (cAlias)->(!Eof()) .And. ! lRet

        ZJE->(DbGoTo(Val(cValToChar((cAlias)->REC))))

        If ZJE->ZJE_TOTVEN == "1"
            lRet := .T.
            Exit

        EndIf

        For nAux := 1 To Len(aVend)
        
            If aVend[nAux] $Alltrim(cValToChar(ZJE->ZJE_VENDED))
                lRet := .T.
                Exit

            EndIf

        Next nAux

        (cAlias)->(dbSkip())

    End

    (cAlias)->(DbCloseArea())
    
    RestArea(aArea)
    
Return lRet
/*/{Protheus.doc} chkVend
    Verifica se já há preço mínimo para o produto x supervisor.
    @type  Static Function
    @author Everson
    @since 08/05/2023
    @version 01
/*/
Static Function chkSup(cProduto, cSuperv)

    //Variáveis.
    Local aArea  := GetArea()
    Local lRet   := .F.
    Local cQuery := ""
    Local cAlias := GetNextAlias()
    Local aSuper := Separa(cSuperv, xPula, .F.)
    Local nAux   := 1

    cQuery := " SELECT R_E_C_N_O_ AS REC "
        cQuery += " FROM " + RetSqlName("ZJE") + " (NOLOCK) AS ZJE "
    cQuery += " WHERE "
        cQuery += " ZJE_FILIAL = '" + FWxFilial("ZJE") + "' "
        cQuery += " AND ZJE_ATIVO = '1' "
        cQuery += " AND ZJE_PRODUT = '" + cProduto + "' "
        cQuery += " AND ZJE_SUPERV IS NOT NULL "
        cQuery += " AND ZJE.D_E_L_E_T_ = '' "
    cQuery += " ORDER BY ZJE_TOTVEN "

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    While (cAlias)->(!Eof()) .And. ! lRet

        ZJE->(DbGoTo(Val(cValToChar((cAlias)->REC))))

        If ZJE->ZJE_TOTSUP == "1"
            lRet := .T.
            Exit

        EndIf

        For nAux := 1 To Len(aSuper)
        
            If aSuper[nAux] $Alltrim(cValToChar(ZJE->ZJE_SUPERV))
                lRet := .T.
                Exit

            EndIf

        Next nAux

        (cAlias)->(dbSkip())

    End

    (cAlias)->(DbCloseArea())
    
    RestArea(aArea)
    
Return lRet
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
Static Function ViewDef()
    
    //Variáveis.
    Local oView     := FwFormView():New()
    Local oModel    := FwLoadModel("ADVEN121P")
    Local oStrMast  := FwFormStruct(2, cTbMast)

    oView:SetModel(oModel)

    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")

    If lAdm .Or. lSuperv
	    oView:AddUserButton("Vendedores"  ,"",{|oView| secVend(oView) } ,"",, {MODEL_OPERATION_INSERT} , .T.)   

    EndIf

    If lAdm .Or. lBack
	    oView:AddUserButton("Supervisores","",{|oView| secSupe(oView) } ,"",, {MODEL_OPERATION_INSERT} , .T.)   

    EndIf

    If lSuperv
        oStrMast:RemoveField("ZJE_SUPERV")
        oStrMast:RemoveField("ZJE_TOTSUP")

    EndIf

    If lBack
        oStrMast:RemoveField("ZJE_VENDED")
        oStrMast:RemoveField("ZJE_TOTVEN")

    EndIf

Return oView
/*/{Protheus.doc} secVend
    Função para selecionar vendedores.
    @type  Function
    @author Everson
    @since 10/04/2023
    @version 01
/*/
Static Function secVend(oView)

    //Variáveis.
    Local aArea      := GetArea()
    Local cTitulo    := "Vendedores"
	Local cMvPar     := ""
	Local cMvParDef  := ""
	Local aVend      := {}
    Local cQuery     := ""
    Local cAlias     := GetNextAlias()
    Local nLen       := 0
    Local nX         := 1
    Local nTam       := 6
    Local nTotReg    := 0
    Local nTotSec    := 0

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " A3_COD, A3_NOME, A3_CODUSR  " 
    cQuery += " FROM  " 
        cQuery += " " + RetSqlName("SA3") + " (NOLOCK) AS SA3 " 
    cQuery += " WHERE  " 
        cQuery += " A3_FILIAL = '" + FWxFilial("SA3") + "' " 

        If ! lAdm .And. ! lBack
            cQuery += " AND A3_SUPER IN ( " 
            cQuery += " SELECT A3_COD FROM " + RetSqlName("SA3") + " (NOLOCK) AS SA3 WHERE A3_FILIAL = '" + FWxFilial("SA3") + "' AND A3_CODUSR = '" + cCodUsr + "' " 
            cQuery += " )  " 

        EndIf

        cQuery += " AND D_E_L_E_T_ = ''  " 
    cQuery += " ORDER BY A3_COD " 

    DbUseArea( .T. , "TOPCONN" , TcGenQry(,, cQuery) , cAlias, .T. , .F.)
    (cAlias)->(DbGoTop())

    While ! (cAlias)->(Eof())

        Aadd(aVend, (cAlias)->A3_COD + "-" + Alltrim((cAlias)->A3_NOME))
        cMvParDef += Alltrim(cValToChar((cAlias)->A3_COD))

        nTotReg++

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    If f_Opcoes(@cMvPar, cTitulo, aVend, cMvParDef, 12, 49, .F., 6, Len(aVend))

        cMvPar := StrTran(cMvPar, "*", "")
        nLen := Len(cMvPar)-1

        For nX := 0 To nLen Step nTam
		    cMvPar := SubStr(cMvPar, 1, nX+nTam+Int(nX/nTam)) + "," + SubStr(cMvPar, nX+nTam+Int(nX/nTam)+1, Len(cMvPar))

            nTotSec++

	    Next nX	

        cMvPar := StrTran(cMvPar,",", xPula)	

        FWFldPut("ZJE_VENDED", cMvPar)	
        FWFldPut("ZJE_TOTVEN", Iif(nTotReg == nTotSec, "1", "2"))	

        oView:lModify := .T.
        oView:Refresh()
	
    EndIf

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} secVend
    Função para selecionar supervisores.
    @type  Function
    @author Everson
    @since 10/04/2023
    @version 01
/*/
Static Function secSupe(oView)
    //Variáveis.
    Local aArea      := GetArea()
    Local cTitulo    := "Supervisores"
	Local cMvPar     := ""
	Local cMvParDef  := ""
	Local aSupe      := {}
    Local cQuery     := ""
    Local cAlias     := GetNextAlias()
    Local nLen       := 0
    Local nX         := 1
    Local nTam       := 6
    Local nTotReg    := 0
    Local nTotSec    := 0

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " A3_COD, A3_NOME, A3_CODUSR, A3_SUPER  " 
    cQuery += " FROM  " 
        cQuery += " " + RetSqlName("SA3") + " (NOLOCK) AS SA3 " 
    cQuery += " WHERE  " 
        cQuery += " A3_FILIAL = '" + FWxFilial("SA3") + "' " 
        cQuery += " AND A3_COD = A3_SUPER  " 
        cQuery += " AND D_E_L_E_T_ = ''  " 
    cQuery += " ORDER BY A3_SUPER " 

    DbUseArea( .T. , "TOPCONN" , TcGenQry(,, cQuery) , cAlias, .T. , .F.)
    (cAlias)->(DbGoTop())

    While ! (cAlias)->(Eof())

        Aadd(aSupe, (cAlias)->A3_SUPER + "-" + Alltrim((cAlias)->A3_NOME))
        cMvParDef += Alltrim(cValToChar((cAlias)->A3_SUPER))

        nTotReg++

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    If f_Opcoes(@cMvPar, cTitulo, aSupe, cMvParDef, 12, 49, .F., 6, Len(aSupe))

        cMvPar := StrTran(cMvPar, "*", "")
        nLen := Len(cMvPar)-1

        For nX := 0 To nLen Step nTam
		    cMvPar := SubStr(cMvPar, 1, nX+nTam+Int(nX/nTam)) + "," + SubStr(cMvPar, nX+nTam+Int(nX/nTam)+1, Len(cMvPar))

            nTotSec++

	    Next nX	

        cMvPar := StrTran(cMvPar,",", xPula)	

        FWFldPut("ZJE_SUPERV", cMvPar)	
        FWFldPut("ZJE_TOTSUP", Iif(nTotReg == nTotSec, "1", "2"))
        
        oView:lModify := .T.
        oView:Refresh()
	
    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADVE121
    Ponto de entrada.
    @type  User Function
    @author Everson
    @since 06/04/2023
    @version 01
/*/
User Function ADVE121()

    //Variáveis.
    Local aArea     := GetArea()
	Local aParam	:= PARAMIXB
	Local xRet 		:= .T.
	Local oObj 		:= ""
	Local cIdPonto 	:= ""
	Local cIdModel 	:= ""
    Local oModelx   := Nil
    Local nOperation:= 0

	If aParam <> Nil

		oObj 	    := aParam[1]
		cIdPonto    := aParam[2]
		cIdModel    := aParam[3]
        nOperation  := oObj:GetOperation()

		If cIdPonto == "MODELCOMMITNTTS"
            oModelx := FWModelActive()

		EndIf

	EndIf

    RestArea(aArea)

Return xRet
/*/{Protheus.doc} User Function ADVE1211
    Job para Verificar se há registro para ser inativado.
    @type  Function
    @author Everson
    @since 10/04/2023
    @version 01
/*/
User Function ADVE1211(aXEmpFil) // U_ADVE1211()
    
    //Variáveis.

    Default aXEmpFil:= {"01", "02"}

    RPCSetType(3)
	RpcSetEnv(aXEmpFil[1], aXEmpFil[2],,,,GetEnvServer(),{ })

        U_ADVE1212()

	RpcClearEnv()

Return Nil
/*/{Protheus.doc} User Function ADVE1212
    Processa fechamento de registro.
    @type  Function
    @author Everson
    @since 10/04/2023
    @version 01
/*/
User Function ADVE1212()

    //Variaveis.
    Local aArea     := GetArea()
    Local cQuery    := " SELECT ZJE_CODIGO FROM " + RetSqlName("ZJE") + " (NOLOCK) AS ZJE WHERE ZJE_FILIAL = '" + FWxFilial("ZJE") + "' AND ZJE_ATIVO = '1' AND ZJE.D_E_L_E_T_ = '' ORDER BY ZJE_CODIGO "
    Local cAlias    := GetNextAlias()

    DbUseArea( .T. , "TOPCONN" , TcGenQry(,, cQuery) , cAlias, .T. , .F.)
    (cAlias)->(DbGoTop())

    While ! (cAlias)->(Eof())

        If ! U_ADVE1213((cAlias)->ZJE_CODIGO)
            (cAlias)->(DbSkip())
            Loop

        EndIf

        If ZJE->ZJE_PRAZO == "1"     //Dia todo.

            If Time() < "23:00:00" .And. ZJE->ZJE_DATA >= Date()
                Loop
                (cAlias)->(DbSkip())

            EndIf

        ElseIf ZJE->ZJE_PRAZO == "2" //10 minutos.

            If ElapTime(ZJE->ZJE_HORA, Time()) < "00:10:00" .And. ZJE->ZJE_DATA >= Date()
                Loop
                (cAlias)->(DbSkip())

            EndIf

        ElseIf ZJE->ZJE_PRAZO == "3" //20 minutos.

            If ElapTime(ZJE->ZJE_HORA, Time()) < "00:20:00" .And. ZJE->ZJE_DATA >= Date()
                Loop
                (cAlias)->(DbSkip())

            EndIf

        ElseIf ZJE->ZJE_PRAZO == "4" //30 minutos.

            If ElapTime(ZJE->ZJE_HORA, Time()) < "00:30:00" .And. ZJE->ZJE_DATA >= Date()
                Loop
                (cAlias)->(DbSkip())

            EndIf

        ElseIf ZJE->ZJE_PRAZO == "5" //60 minutos.

            If ElapTime(ZJE->ZJE_HORA, Time()) < "01:00:00" .And. ZJE->ZJE_DATA >= Date()
                Loop
                (cAlias)->(DbSkip())

            EndIf

        EndIf

        RecLock("ZJE", .F.)
            ZJE->ZJE_ATIVO = "2"
        ZJE->(MsUnLock())

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} User Function ADVE1213
    Posiciona no registro pelo código.
    @type  Function
    @author Everson
    @since 10/04/2023
    @version 01
/*/
User Function ADVE1213(cCodigo)

    //Variáveis.

    DbSelectArea("ZJE")
    ZJE->(DbSetOrder(1))
    ZJE->(DbGoTop())

Return ZJE->(DbSeek(FWxFilial("ZJE") + cCodigo))
