#Include "Protheus.ch"
#Include "Restful.ch"
#Include "Topconn.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} User Function ADFAT028P
    Api Rest para integra��o de dados do barramento.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 10/02/2022
    @version 01
    @history, Everson, 06/06/2022, ticket 18645 - tratamento para reclock.
/*/
User Function ADFAT028P()                                    
Return Nil

WsRestFul barramento Description "Servi�o REST para inclus�o de registros vindos do barramento."

	WsMethod Post Description "Inclui de registros vindos do barramento."    WsSyntax "/registros"
	WsMethod Get  Description "Obt�m registros n�o enviados ao barramento."  WsSyntax "/registros"
	WsMethod Put  Description "Marca registro como j� processado"            WsSyntax "/registros/{uuid}"

End WsRestFul
/*/{Protheus.doc} User Function Post
	M�todo Post
	@type  Function
	@author Everson
	@since 10/02/2022
	@version 01
/*/
WsMethod Post WsService barramento

    //Vari�veis.
    Local lRet      := .F.
    Local lLock     := .F.
    Local cBody     := Self:GetContent()
    Local aRetErro  := {}
    Local nCodErro  := 0
    Local cMsgErro  := ""

    logZBE("In�cio POST", "", cBody)

    Self:SetContentType("application/json")

    While ! lRet .And. ! lLock
        
        lRet := U_ADFAT28A(cBody, @aRetErro, @lLock)

    End

    If ! lRet .Or. Len(aRetErro) > 0
        nCodErro := aRetErro[1][1]
        cMsgErro := aRetErro[1][2]
        SetRestFault(nCodErro,EncodeUtf8(cMsgErro))
        Return .F.

    EndIf

Return lRet
/*/{Protheus.doc} ADFAT28A
    Processa requisi��es Post.
    @type  Static Function
    @author Everson
    @since 10/02/2022
    @version 01
/*/
User Function ADFAT28A(cBody, aRetErro, lLock)

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local oModel    := Nil
    Local aError    := {}
    Local cMsgError := ""
    Local cEmpOrg   := ""
    Local cFilOrg   := ""
    Local cDtOrig   := ""
    Local cHrOrig   := ""
    Local cOperacao := ""
    Local cSisGer   := ""
    Local cTopico   := ""
    Local cId       := ""
    Local cDados    := ""
    Local oJson     := Nil
    Local xRet      := Nil
    Local cHash     := ""


    If ! LockByName("ADFAT28A", .T., .F.)
		RestArea(aArea)
		Conout( DToC(Date()) + " " + Time() + " ADFAT028P - ADFAT28A - fun��o j� est� sendo utilizada")
		Return .F.

	EndIf

        bError := ErrorBlock( {|e| cError := e:Description, aRetErro := {}, Aadd(aRetErro, {400, cError}), Conout(cError) })

        lLock := .T.
        
        Begin Sequence


            oJson := JsonObject():New()

            xRet  := oJson:FromJson(cBody)

            If ! ValType(xRet) == "U"
                cMsgError := "N�o foi poss�vel converter a string json para objeto json."
                logZBE("ADFAT28A", cMsgError, cBody)
                Aadd(aRetErro, {400, cMsgError})
                UnLockByName("ADFAT28A")
                RestArea(aArea)
                Return .F.

            EndIf

            cId := Alltrim(cValToChar(oJson['uuid']))

            If Empty(cId)
                cMsgError := "N�o foi poss�vel obter o uuid."
                logZBE("ADFAT28A", cMsgError, cBody)
                Aadd(aRetErro, {400, cMsgError})
                UnLockByName("ADFAT28A")
                RestArea(aArea)
                Return .F.

            EndIf

            DbselectArea("ZIQ")
            ZIQ->(DbSetOrder(1))
            If ZIQ->( DbSeek(FWxFilial("ZIQ") + cId) )
                cMsgError := "Id " + cId + " j� recebido."
                logZBE("ADFAT28A", cMsgError, cBody)
                Aadd(aRetErro, {400, cMsgError})
                UnLockByName("ADFAT28A")
                RestArea(aArea)
                Return .F.

            EndIf

            cEmpOrg     := Alltrim(cValToChar(oJson['empresa']))
            cFilOrg     := Alltrim(cValToChar(oJson['filial']))
            cDtOrig     := Alltrim(cValToChar(oJson['data']))
            cHrOrig     := Alltrim(cValToChar(oJson['hora']))
            cOperacao   := Alltrim(cValToChar(oJson['operacao']))
            cSisGer     := Alltrim(cValToChar(oJson['sistGera']))
            cTopico     := Alltrim(cValToChar(oJson['topico']))
            cDados      := Alltrim(cValToChar(cBody))
            cHash       := SHA1(cEmpOrg + cFilOrg + cDtOrig + cHrOrig + Alltrim(cValToChar(oJson['dados'])))

            DbselectArea("ZIQ")
            ZIQ->(DbSetOrder(2))
            If ZIQ->( DbSeek(FWxFilial("ZIQ") + cHash) )
                cMsgError := "Hash " + cHash + " j� recebido."
                logZBE("ADFAT28A", cMsgError, cBody)
                Aadd(aRetErro, {400, cMsgError})
                FreeObj(oJson)
                oJson := Nil
                UnLockByName("ADFAT28A")
                RestArea(aArea)
                Return .F.

            EndIf

            oModel := FwLoadModel("ADFAT027P")
            oModel:SetOperation(MODEL_OPERATION_INSERT)
            oModel:Activate()

            oModel:SetValue("MD_MASTER", "ZIQ_TIPO"  , "E")
            oModel:SetValue("MD_MASTER", "ZIQ_EMPRES", cEmpOrg)
            oModel:SetValue("MD_MASTER", "ZIQ_FILINT", cFilOrg)
            oModel:SetValue("MD_MASTER", "ZIQ_OPERAC", cOperacao)
            oModel:SetValue("MD_MASTER", "ZIQ_DTORIG", SToD(cDtOrig))
            oModel:SetValue("MD_MASTER", "ZIQ_HRORIG", cHrOrig)
            oModel:SetValue("MD_MASTER", "ZIQ_DTGRV" , Date())
            oModel:SetValue("MD_MASTER", "ZIQ_HRGRV" , Time())
            oModel:SetValue("MD_MASTER", "ZIQ_SISGER", cSisGer)
            oModel:SetValue("MD_MASTER", "ZIQ_TOPICO", cTopico)
            oModel:SetValue("MD_MASTER", "ZIQ_UUID"  , cId)
            oModel:SetValue("MD_MASTER", "ZIQ_DADOS" , cDados)
            oModel:SetValue("MD_MASTER", "ZIQ_PROCES", "2")
            oModel:SetValue("MD_MASTER", "ZIQ_HASH"  , cHash)

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
                Aadd(aRetErro, {400, cMsgError})

            EndIf

            FreeObj(oJson)
            oJson := Nil

        Recover
            ErrorBlock( bError )
            Break

        End Sequence

    UnLockByName("ADFAT28A")
        
    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function Get
	M�todo Get
	@type  Function
	@author Everson
	@since 14/03/2022
	@version 01
/*/
WsMethod Get WsService barramento

    //Vari�veis.
    Local lRet      := .F.
    Local cJson     := ""

    logZBE("In�cio GET", "", "")

    Self:SetContentType("application/json")

    lRet := U_ADFAT28B(@cJson)

    Self:SetResponse(cJson)

Return lRet
/*/{Protheus.doc} ADFAT28B
    Obt�m registros de sa�da faltantes de processamento.
    @type  Static Function
    @author Everson
    @since 14/03/2022
    @version 01
/*/
User Function ADFAT28B(cJson)

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local aDados    := {}
    Local oJsonLn   := Nil
    Local oJson     := Nil
    Local cQtdReg   := Alltrim(cValToChar(GetMv("MV_#FAT281",,"25")))
    Local nTmpSleep := Val(cValToChar(GetMv("MV_#FAT282",,3)))
    Local cQuery    := " SELECT TOP " + cValToChar(cQtdReg) + " R_E_C_N_O_ AS RECNO FROM " + RetSqlName("ZIQ") + " AS ZIQ WHERE ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "' AND ZIQ_TIPO = 'S' AND ZIQ_PROCES = '2' AND ZIQ.D_E_L_E_T_ = '' ORDER BY ZIQ_DTGRV, ZIQ_HRGRV, R_E_C_N_O_ "

    If Select("D_ZIQS") > 0
        D_ZIQS->(DbCloseArea())

    EndIf

    Sleep(Random(0, nTmpSleep)*1000) //Everson - 06/06/2022.

    TcQuery cQuery New Alias "D_ZIQS"
    DbSelectArea("D_ZIQS")
    D_ZIQS->(DbGoTop())
    If D_ZIQS->(Eof())
        cJson := "[]"
        D_ZIQS->(DbCloseArea())
        RestArea(aArea)
        Return .T.
    EndIf

    oJson := JsonObject():New()

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))
    ZIQ->(DbGoTop())

    While ! D_ZIQS->(Eof())

        ZIQ->(DbGoTo(D_ZIQS->RECNO))

        oJsonLn := JsonObject():New()
        oJsonLn:FromJSON( ZIQ->ZIQ_DADOS )

        Aadd(aDados, oJsonLn)

        FreeObj(oJsonLn)
        oJsonLn := Nil

        D_ZIQS->(Dbskip())

    End

    oJson["dados"] := aDados

    cJson := oJson:toJSON()

    FreeObj(oJson)
    oJson := Nil

    lRet := .T.

    D_ZIQS->(DbCloseArea())

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function Get
	M�todo Get
	@type  Function
	@author Everson
	@since 14/03/2022
	@version 01
/*/
WsMethod Put WsService barramento

    //Vari�veis.
    Local lRet          := .F.
    Local aRetErro      := {}
    Local nCodErro      := 0
    Local cMsgErro      := ""
    Local aParametros	:= Self:aURLParms

    logZBE("In�cio PUT", "", "")

    Self:SetContentType("application/json")

    lRet := U_ADFAT28C(aParametros, @aRetErro)

    If ! lRet .Or. Len(aRetErro) > 0
        nCodErro := aRetErro[1][1]
        cMsgErro := aRetErro[1][2]
        SetRestFault(nCodErro,EncodeUtf8(cMsgErro))
        Return .F.

    EndIf

Return lRet
/*/{Protheus.doc} ADFAT28B
    Marca registro como j� processado.
    @type  Static Function
    @author Everson
    @since 14/03/2022
    @version 01
/*/
User Function ADFAT28C(aParametros, aRetErro)

    //Vari�veis.
    Local aArea     := GetArea()
    Local cUuid     := ""
    // Local cMsgError := ""
    Local nTmpSleep := Val(cValToChar(GetMv("MV_#FAT284",,0)))
    Local cQuery    := ""

    If Len(aParametros) == 0
        Aadd(aRetErro, {400, EncodeUtf8("Necess�rio informar o uuid do registro.")})
        RestArea(aArea)
        Return .F.

    EndIf

    cUuid := Alltrim(cValToChar(aParametros[2]))
    
    Sleep(Random(0, nTmpSleep)*1000) //Everson - 06/06/2022.

    // TcSqlExec("UPDATE " + RetSqlName("ZIQ") + " SET ZIQ_PROCES = '1' WHERE ZIQ_UUID = '" + cUuid + "'")

    cQuery := " SELECT ZIQ_EMPRES, ZIQ_FILINT, ZIQ_PROCES FROM " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ WHERE ZIQ_FILIAL = '" + FWxfilial("ZIQ") + "' AND ZIQ_UUID = '" + cUuid + "'  AND ZIQ.D_E_L_E_T_ = '' "

    If Select("D_CHECK") > 0
        D_CHECK->(DbCloseArea())

    EndIf

    TcQuery cQuery New Alias "D_CHECK"
    DbSelectArea("D_CHECK")

    If D_CHECK->(Eof())
        Aadd(aRetErro, {404, EncodeUtf8("Id " + cUuid + " n�o localizado")})
        D_CHECK->(DbCloseArea())
        Return .F.

    EndIf

    If D_CHECK->ZIQ_PROCES == "1"
        D_CHECK->(DbCloseArea())
        RestArea(aArea)
        Return .T.

    EndIf

    U_ADFAT27B("I", "marcar_registro_processado", FWUUIDV1(.T.), cUuid, DToS(Date()), Time(), "E", "", D_CHECK->ZIQ_EMPRES, D_CHECK->ZIQ_FILINT)

    D_CHECK->(DbCloseArea())

    // If ! U_ADFAT29D(cUuid, "1", "", @cMsgError)
    //     Aadd(aRetErro, {400, cMsgError})

    // Else
    //     lRet := .T.

    // EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} logZBE
    Gera log ZBE.
    @type  Static Function
    @author Everson
    @since 15/02/2022
    @version 01
/*/
Static Function logZBE(cLog, cParam, cLogMemo)
    
    //Vari�veis.
	Local aArea := GetArea()

    Default cLog    := ""
    Default cParam  := ""
    Default cLogMemo:= ""

	DbSelectArea("ZBE")
	RecLock("ZBE",.T.)
        Replace ZBE_FILIAL 	   	WITH xFilial("ZBE")
        Replace ZBE_DATA 	   	WITH dDataBase
        Replace ZBE_HORA 	   	WITH Time()
        Replace ZBE_USUARI	    WITH Upper(Alltrim(cUserName))
        Replace ZBE_LOG	        WITH cLog
        Replace ZBE_MODULO	    WITH "FATURAMENTO"
        Replace ZBE_ROTINA	    WITH "ADFAT028P" 
        Replace ZBE_PARAME      WITH cParam
        Replace ZBE_LOGMEM      WITH cLogMemo
	ZBE->( MsUnLock())

	RestArea(aArea)

Return Nil
