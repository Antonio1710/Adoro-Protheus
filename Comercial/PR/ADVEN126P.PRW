#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static xPula        := Chr(13) + Chr(10)
Static cCodUsr      := ""
Static lAdm         := .F.
Static lBack        := .F.
Static lVend        := .F.
Static lSuperv      := .F.
Static lDiret       := .F.

/*/{Protheus.doc} User Function ADVEN126P
    Processamento de pedidos de venda de rede.
    @type  Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
User Function ADVEN126P()

    //Variáveis.
    Local aArea      := GetArea()
    Local oModal     := Nil
    Local oContainer := Nil
    Local lRetP      := .F.
    Local dDtEntDe   := Date()+1
    Local dDtEntAt   := Date()+1
    Local oSuperv    := Nil
    Local cSuperv    := ""
    Local oRede      := Nil
    Local aRedes     := {}
    Local cRede      := ""
    Local oDtIni     := Nil
    Local oDtFim     := Nil

    carVariaveis()

    If ! (lAdm .Or. lBack .Or. lDiret)
        RestArea(aArea)
        Return Nil

    EndIf

    oModal := FWDialogModal():New() 
    oModal:SetBackground(.T.) 
	oModal:setTitle("Processamento de Redes")
	oModal:setSize(280, 200)
    oModal:EnableFormBar(.T.)
    oModal:SetEscClose(.F.)
	oModal:createDialog()
    oModal:CreateFormBar()

        oModal:AddButton("Confirmar", {|| MsAguarde({|| lRetP := U_ADVE1261(dDtEntDe, dDtEntAt, cSuperv, cRede) }, "Aguarde", "Processando..."), Iif(lRetP, oModal:DeActivate(), Nil) } , "Confirmar", , .T., .F., .T., )
        oModal:AddButton("Cancelar" , {|| oModal:DeActivate() } , "Cancelar" , , .T., .F., .T., )

       	oContainer := TPanel():New( ,,, oModal:getPanelMain() )
	    oContainer:Align := CONTROL_ALIGN_ALLCLIENT

        oDtIni := TGet():New(010, 010, {|u| If(PCount() == 0, dDtEntDe, dDtEntDe := u)}, oContainer, 100, 010, "@D",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtEntDe",,,,.T.,,,"Data início",1) 
        oDtIni:bChange := {|| secRede(oRede, aRedes, dDtEntDe, dDtEntAt) }
        
        oDtFim := TGet():New(035, 010, {|u| If(PCount() == 0, dDtEntAt, dDtEntAt := u)}, oContainer, 100, 010, "@D",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtEntAt",,,,.T.,,,"Data fim",   1) 
        oDtFim:bChange := {|| secRede(oRede, aRedes, dDtEntDe, dDtEntAt) }

        oSuperv := TMultiGet():new(080, 010, {|u| If( pCount() > 0, cSuperv := u, cSuperv )}, oContainer, 180, 060,,,,,,.T.,,,,,,,,,,,,"Filtro de Supervisores", 1)
        oSuperv:bGotFocus := {|| secSupe(oSuperv, @cSuperv) }

        oRede := TComboBox():New(160, 010,{|u|If(PCount() > 0, cRede := u, cRede)},;
        aRedes,180, 25, oContainer,,{||};
        ,,,,.T.,,,,,,,,,'cRede')

        secRede(oRede, aRedes, dDtEntDe, dDtEntAt)

    oModal:Activate()

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} carVariaveis
    Carrega variáveis estáticas.
    @type  Static Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
Static Function carVariaveis()

    //Variáveis.
    Local aArea     := GetArea()

    U_ADVE118Q(@cCodUsr, @lAdm, @lBack, @lVend, @lSuperv, @lDiret)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} secVend
    Função para selecionar supervisores.
    @type  Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
Static Function secSupe(oSuperv, cSuperv)

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
	
        cSuperv := cMvPar
        oSuperv:Refresh()

    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} secRede
    Função para selecionar redes.
    @type  Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
Static Function secRede(oRede, aRedes, dDtEntDe, dDtEntAt)

    //Variáveis.
    Local aArea      := GetArea()
    Local cQuery     := ""
    Local cAlias     := GetNextAlias()

    aRedes := {}

    If Empty(dDtEntDe) .Or. Empty(dDtEntAt)
        MsgInfo("Necessário informar as datas de entrega.", "Função secRede(ADVEN126P)")
        RestArea(aArea)
        Return Nil

    EndIf

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " DISTINCT ZJA_CODRED, ZJA_IDPRED " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZJA") + " (NOLOCK) AS ZJA " 
    cQuery += " WHERE " 
        cQuery += " ZJA_FILIAL = '" + FWxFilial("ZJA") + "' " 
        cQuery += " AND ZJA_DTENTR BETWEEN '" + DToS(dDtEntDe) + "' AND '" + DToS(dDtEntAt) + "' " 
        cQuery += " AND ZJA_CODRED <> '' " 
        cQuery += " AND ZJA_STATUS = '3' " 
        cQuery += " AND ZJA_DTPRED = ''  " 
        cQuery += " AND ZJA_IDPRED <> '' " 
        cQuery += " AND ZJA.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY ZJA_CODRED " 

    DbUseArea( .T. , "TOPCONN" , TcGenQry(,, cQuery) , cAlias, .T. , .F.)
    (cAlias)->(DbGoTop())

    Aadd(aRedes, "TODAS=TODAS")

    While ! (cAlias)->(Eof())

        cNmRede := Alltrim(Posicione("SA1", 1, FWxFilial("SA1") + (cAlias)->ZJA_CODRED + "00", "A1_NOME"))
        
        Aadd(aRedes, Alltrim(cValToChar((cAlias)->ZJA_IDPRED)) + "=" + cNmRede)

        (cAlias)->(DbSkip())

    End

    oRede:SetItems(aRedes)
    oRede:Refresh()

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADVE1261
    Executa processamento de rede.
    @type  Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
User Function ADVE1261(dDtEntDe, dDtEntAt, cSuperv, cRede)

    //Variáveis.
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local aCodSup   := Separa(Alltrim(cSuperv), ",", .F.)
    Local cCodSFor  := ""
    Local nAux      := 1
    Local cAlias    := ""
    Local cIdProcR  := ""
    Local cMsgError := ""

    If Empty(dDtEntDe) .Or. Empty(dDtEntAt) .Or. Empty(cRede)
        MsgInfo("Necessário informar as datas de entrega e redes.", "Função ADVE1261(ADVEN126P)")
        RestArea(aArea)
        Return .F.

    EndIf

    For nAux := 1 To Len(aCodSup)
        If ! Empty(aCodSup[nAux] )
            cCodSFor += "'" + aCodSup[nAux] + "',"

        EndIf

    Next nAux

    cCodSFor := Iif(Empty(cCodSFor), "", Substr(cCodSFor, 1, Len(cCodSFor)-1))

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " ZJA_IDPRED, " 
        cQuery += " SUM(ZJB_IT * ZJB_QTDVEN) / SUM(ZJB_QTDVEN) /100 AS RIT, " 
        cQuery += " SUM(ZJB_EM * ZJB_QTDVEN) / SUM(ZJB_QTDVEN) /100 AS REMR, " 
        cQuery += " SUM(ZJB_IP * ZJB_QTDVEN) / SUM(ZJB_QTDVEN) /100 AS RIP, " 
        cQuery += " SUM(ZJA_VALOR) AS RVALOR, " 
        cQuery += " SUM(ZJA_PESL) AS RPESL, " 
        cQuery += " SUM(ZJA_VOL) AS RVOL " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZJA") + " (NOLOCK) AS ZJA  " 
        cQuery += " INNER JOIN " 
        cQuery += " " + RetSqlName("ZJB") + " (NOLOCK) AS ZJB ON " 
        cQuery += " ZJA_FILIAL = ZJB_FILIAL " 
        cQuery += " AND ZJA_LOCEXP = ZJB_LOCEXP " 
        cQuery += " AND ZJA_NUM = ZJB_NUM " 
        cQuery += " AND ZJA_LOCEXP = ZJB_LOCEXP " 
        cQuery += " AND ZJB.D_E_L_E_T_ = '' " 
    cQuery += " WHERE " 
        cQuery += " ZJA_FILIAL = '" + FWxFilial("ZJA") + "' " 
        cQuery += " AND ZJA_DTENTR BETWEEN '" + DToS(dDtEntDe) + "' AND '" + DToS(dDtEntAt) + "' " 
        cQuery += " AND ZJA_STATUS = '3' "
        cQuery += " AND ZJA_DTPRED = ''  "  
        cQuery += " AND ZJA_IDPRED <> '' " 
        cQuery += " AND ZJA_CODRED <> '' " 

        If ! Empty(cCodSFor)
            cQuery += " AND ZJA_APRSUP IN (" + cCodSFor + ") " 

        EndIf

        If cRede <> "TODAS"
            cQuery += " AND ZJA_IDPRED = '" + cRede + "' " 

        EndIf

        cQuery += " AND ZJA.D_E_L_E_T_ = '' " 
    cQuery += " GROUP BY ZJA_IDPRED " 

    cAlias := GetNextAlias()
    
    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    If (cAlias)->(Eof())
        (cAlias)->(DbCloseArea())
        MsgInfo("Não há dados para os parâmetros informados.", "Função ADVE1261(ADVEN126P)")
        RestArea(aArea)
        Return .F.

    EndIf

    nTotaReg := Contar(cAlias, "!Eof()")

    (cAlias)->(DbGoTop())

    If ! MsgYesNo("Há " + cValToChar(nTotaReg) + " registro(s), para processamento. Deseja prosseguir?", "Função ADVE1261(ADVEN126P)")
        (cAlias)->(DbCloseArea())
        RestArea(aArea)
        Return .F.

    EndIf

    While ! (cAlias)->(Eof())

        cIdProcR := (cAlias)->ZJA_IDPRED
        nIT      := (cAlias)->RIT
        nEM      := (cAlias)->REMR
        nIP      := (cAlias)->RIP
        nValor   := (cAlias)->RVALOR
        nPesl    := (cAlias)->RPESL
        nVol     := (cAlias)->RVOL

        U_ADVE1262(cRede, cIdProcR, nIT, nEM, nIP, nValor, nPesl, nVol, @cMsgError)

        (cAlias)->(DbSkip())

    End

    If ! Empty(cMsgError)
        cMsgError := "Os registros abaixo apresentaram erro: " + xPula + cMsgError
        Help(Nil, Nil, "Função ADVE1261(ADVEN126P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    Else
        MsgInfo("Processo finalizado.", "Função ADVE1261(ADVEN126P)")

    EndIf

    (cAlias)->(DbCloseArea())

    RestArea(aArea)
    
Return .T.
/*/{Protheus.doc} User Function ADVE1262
    Aprova os pedidos da rede ou os envia para aprovação.
    @type  Function
    @author Everson
    @since 12/05/2023
    @version 01
/*/
User Function ADVE1262(cRede, cIdProcR, nIT, nEM, nIP, nValor, nPesl, nVol, cMsgError)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .T.
    Local aAprov    := U_ADVE118F(nIT, nEM, nIP, "")
    Local lPAprS    := aAprov[2] //Pendente aprovação supervisor.
    Local lPAprD    := aAprov[3] //Pendente aprovação diretor.
    Local oPedido   := Nil
    Local aError    := {}
    Local cPedido   := ""
    Local cLocExp   := ""
    Local cQuery    := ""
    Local cAlias    := ""

    If ! U_ADVE118Z(cIdProcR, "")
        cMsgError += cRede + " Id de processamento de rede não encontrado " + cIdProcR + xPula
        RestArea(aArea)
        Return .F.

    EndIf

    cQuery := " SELECT ZJA_NUM, ZJA_TPPED, ZJA_LOCEXP, ZJA_STATUS FROM " + RetSqlName("ZJA") + " (NOLOCK) AS ZJA WHERE ZJA_FILIAL = '" + FWxFilial("ZJA") + "' AND ZJA_IDPRED = '" + cIdProcR + "' AND ZJA_TPPED NOT IN ('7', '8') AND ZJA_STATUS = '3' AND ZJA.D_E_L_E_T_ = '' ORDER BY ZJA_NUM "
    cAlias := GetNextAlias()
    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)

    Begin Transaction

        While ! (cAlias)->(Eof())

            cPedido := (cAlias)->ZJA_NUM
            cLocExp := (cAlias)->ZJA_LOCEXP

            If ! U_ADVE1182(cPedido, cLocExp)
                cMsgError += cRede + " " + "Pedido " + cPedido + " não localizado." + xPula
                (cAlias)->(DbSkip())
                Loop

            EndIf

            If (cAlias)->ZJA_STATUS <> "3"
                (cAlias)->(DbSkip())
                Loop

            EndIf

            oPedido := FWLoadModel("ADVEN118P")
            oPedido:SetOperation(MODEL_OPERATION_UPDATE)
            oPedido:Activate()

                oPedido:SetValue("MD_MASTER", "ZJA_RIT"   , nIT) 
                oPedido:SetValue("MD_MASTER", "ZJA_REM"   , nEM)
                oPedido:SetValue("MD_MASTER", "ZJA_RIP"   , nIP) 
                oPedido:SetValue("MD_MASTER", "ZJA_RVALOR", nValor)
                oPedido:SetValue("MD_MASTER", "ZJA_RPESL" , nPesl) 
                oPedido:SetValue("MD_MASTER", "ZJA_RVOL"  , nVol)
                oPedido:SetValue("MD_MASTER", "ZJA_DTPRED", Date()) 
                oPedido:SetValue("MD_MASTER", "ZJA_HRPRED", Time())
            
                If ! lPAprS .And. ! lPAprD //Não necessita de aprovação.

                    oPedido:SetValue("MD_MASTER", "ZJA_STATUS" , "1")  //Aprovado comercial.
                    oPedido:SetValue("MD_MASTER", "ZJA_STATPA" , "4")  //Pedido liberado.

                    oPedido:SetValue("MD_MASTER", "ZJA_PARSUP", "2") 
                    oPedido:SetValue("MD_MASTER", "ZJA_PARDIR", "2")
                    
                    oPedido:ClearField("MD_MASTER", "ZJA_APRSUP")  
                    oPedido:ClearField("MD_MASTER", "ZJA_NMSUPE")  
                    oPedido:ClearField("MD_MASTER", "ZJA_USRSUP")  
                    
                    oPedido:ClearField("MD_MASTER", "ZJA_APRDIR")
                    oPedido:ClearField("MD_MASTER", "ZJA_NMDIRE")  
                    oPedido:ClearField("MD_MASTER", "ZJA_USRDIR")  

                Else 

                    If lPAprS //Aprovação supervisor.
                        oPedido:SetValue("MD_MASTER", "ZJA_PARSUP" , "1") 

                    EndIf

                    If lPAprD //Aprovação diretor.
                        oPedido:SetValue("MD_MASTER", "ZJA_PARDIR" , "1")  

                    EndIf

                EndIf

                If oPedido:VldData()
                    oPedido:CommitData()

                Else
                    aError := oPedido:GetErrorMessage()
                    cMsgError += cRede + " " + Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE])) + xPula

                EndIf

            oPedido:DeActivate()
            oPedido:Destroy()
            oPedido := Nil

            (cAlias)->(DbSkip())

        End

    End Transaction

    (cAlias)->(DbCloseArea())

    RestArea(aArea)
    
Return lRet
