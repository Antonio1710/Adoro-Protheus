#Include "Protheus.ch"
#Include "Restful.ch"
#Include "Topconn.ch"
#Include "MNTA280.ch"

Static cFormatRet := "application/json"
/*/{Protheus.doc} ADMNT021P
    Serviço Rest para abertura de solicitação de serviço.
    @type  Function
    @author Everson
    @since 05/09/2022
    @version 01
    @history Everson, 14/03/2023 - ticket 18465 - Adicionada validação na empresa/filial para validar se possui manutenção de ativos.
*/
User Function ADMNT021P
Return Nil
WsRestFul solicitacaodeservico Description "Abertura de solicitação de serviço"

	WsMethod Post Description "Efetua login no sistema/cria solicitação de serviço."  WsSyntax "/{resource}"
	WsMethod Get  Description "Obtém as ordens de serviço pendentes de avaliação."  WsSyntax "/{resource}" //Não foi possível utilizar o ID para haver métodos repetidos.
	WsMethod Put  Description "Avalia ordens de serviço." WsSyntax "/{id}"

End WsRestFul
/*/{Protheus.doc} Post
    Método post para validação de acesso.
    @type  Static Function
    @author Everson
    @since 05/09/2022
    @version 01
    /*/
WsMethod Post WsService solicitacaodeservico

    //Variáveis.
    Local cBody 	    := Self:GetContent()
    Local aParametros	:= Self:aURLParms
    Local cRecurso      := "" 
    Local cJsonResp     := ""
    Local cErro         := ""
    Local cNumSS        := ""
    Local cMsgError     := ""

    Self:SetContentType(cFormatRet)

    If Len(aParametros) > 0
        cRecurso := aParametros[1]

    EndIf

    If cRecurso == "login"

        cJsonResp := U_ADMNT210(@cMsgError)

        If ! Empty(cJsonResp)
            Self:SetResponse(cJsonResp)
            Return .T.

        Else
            SetRestFault(401,EncodeUTF8(cMsgError),.T.)
            Return .F.

        EndIf

    ElseIf cRecurso == ""

        If ! U_ADMNT216(cBody, @cErro, @cNumSS)
            SetRestFault(404,EncodeUTF8(cErro),.T.)
            Return .F.

        EndIf

        cJsonResp := '{"number":"'+ Alltrim(cValToChar(cNumSS)) + '"}'

        Self:SetResponse(cJsonResp)

        Return .T.

    Else
        SetRestFault(404,EncodeUTF8("Recurso " + cRecurso + " não encontrado."),.T.)
        Return .F.

    EndIf

Return Nil
/*/{Protheus.doc} obtLogin
    (long_description)
    @type  User Function
    @author Everson
    @since 05/09/2022
    @version 01
/*/
User Function ADMNT210(cMsgError)

    //Variáveis.
    Local aArea     := GetArea()
    Local cDados    := ""
    Local oJson     := Nil
    Local cQuery    := "SELECT TOP 1 H7_CODIGO FROM " + RetSqlName("SH7") + " (NOLOCK) SH7 WHERE H7_FILIAL = '" + FWxFilial("SH7") + "' AND SH7.D_E_L_E_T_ = ''"
    Local cAliasQry := GetNextAlias()
    Local lLoga     := .F.

    logZBE("Login", "Usuário " + cValToChar(__cUserId) + " " + UsrRetName(__cUserId), "")

    DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasQry , .T. , .F.)
    (cAliasQry)->(DbGoTop())

        lLoga := ! (cAliasQry)->(Eof())

    (cAliasQry)->(DbCloseArea())

    If ! lLoga
        cMsgError := "Filial não possui manutenção de ativos."
        RestArea(aArea)
        Return ""

    EndIf

    oJson := JsonObject():New()
    oJson['userID']       := Alltrim(cValToChar(__cUserId))
    oJson['userName']     := Alltrim(cValToChar(UsrRetName(__cUserId)))
    oJson['userFullName'] := Alltrim(cValToChar(UsrFullName(__cUserId)))
    oJson['email']        := Alltrim(cValToChar(UsrRetMail(__cUserId)))

    cDados := oJson:toJson() 

    FreeObj(oJson)
    oJson := Nil

    RestArea(aArea)

Return cDados
/*/{Protheus.doc}
    Metódo Get retorna dados da SS, que estão pendentes de avaliação.
    @type  Static Function
    @author Everson
    @since 05/09/2022
    @version 01
/*/
WsMethod Get WsService solicitacaodeservico

    //Variáveis.
    Local aParametros	:= Self:aURLParms
    Local cJsonResp     := ""
    Local cRecurso      := ""

    Self:SetContentType(cFormatRet)

    If Len(aParametros) <= 0
        SetRestFault(400,EncodeUTF8("Dados inválidos."),.T.)
        Return .F.

    EndIf

    cRecurso := Alltrim(aParametros[1])

    logZBE("Obter dados", "Usuário " + cValToChar(__cUserId) + " " + UsrRetName(__cUserId) + " Recurso " + cRecurso, "")

    If cRecurso == "bens"
        cJsonResp := U_ADMNT213()

    ElseIf cRecurso == "tiposdeservico"
        cJsonResp := U_ADMNT214()

    ElseIf cRecurso == "sspendentes"
        cJsonResp := U_ADMNT211()

    ElseIf cRecurso == "ssabertas"
        cJsonResp := U_ADMNT217()

    Else
        logZBE("Erro Obter dados", "Usuário " + cValToChar(__cUserId) + " " + UsrRetName(__cUserId) + " Recurso " + cRecurso, "")
        SetRestFault(404,EncodeUTF8("Recurso " + cRecurso + " não encontrado."),.T.)
        Return .F.

    EndIf

    logZBE("Ret Obter dados", "Usuário " + cValToChar(__cUserId) + " " + UsrRetName(__cUserId) + " Recurso " + cRecurso, cJsonResp)

    Self:SetResponse(cJsonResp)

Return Nil
/*/{Protheus.doc} User Function ADMNT213
    Retorna os bens.
    @type  Function
    @author Everson
    @since 06/09/2022
    @version 01
/*/
User Function ADMNT213()

    //Variáveis.
    Local aArea     :=  GetArea()
    Local cQuery    :=  ""
    Local cNewAlias :=  GetNextAlias()
    Local aDados    :=  {}
    Local JsonE     :=  Nil
    Local JsonR     :=  Nil
    Local cJson     := ""

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " T9_CODBEM, RTRIM(LTRIM(T9_NOME)) AS T9_NOME, T9_CCUSTO, RTRIM(LTRIM(CTT_DESC01)) AS  CTT_DESC01 " 
    cQuery += " FROM  " 
        cQuery += " " + RetSqlName("ST9") + " (NOLOCK) AS ST9  " 
        cQuery += " INNER JOIN " 
        cQuery += " " + RetSqlName("CTT") + " (NOLOCK) AS CTT ON " 
        cQuery += " T9_CCUSTO =  CTT_CUSTO " 
        cQuery += " AND CTT.D_E_L_E_T_ = '' " 
    cQuery += " WHERE  " 
        cQuery += " T9_FILIAL = '" + FWxFilial("ST9") + "'  " 
        cQuery += " AND ST9.D_E_L_E_T_ = '' "
        cQuery += " AND T9_DTBAIXA = '' " 
    cQuery += " ORDER "
        cQuery += " BY T9_CODBEM " 

    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNewAlias, .F., .T.)

    (cNewAlias)->(DbGoTop())

    While ! (cNewAlias)->(Eof())

        JsonE := JsonObject():New()

        JsonE['code']           := Alltrim(cValToChar((cNewAlias)->T9_CODBEM))
        JsonE['description']    := Alltrim(cValToChar((cNewAlias)->T9_NOME))
        JsonE['costCenter']     := Alltrim(cValToChar((cNewAlias)->T9_CCUSTO))
        JsonE['descCostCenter'] := Alltrim(cValToChar((cNewAlias)->CTT_DESC01))

        Aadd(aDados, JsonE)

        FreeObj(JsonE)
        JsonE := Nil

        (cNewAlias)->(DbSkip())

    End

    JsonR := JsonObject():New()
    JsonR['count'] := Len(aDados)
    JsonR['items'] := aDados
    cJson := JsonR:toJson()

    FreeObj(JsonR)
    JsonR := Nil

    (cNewAlias)->(DbCloseArea())

    RestArea(aArea)

Return cJson
/*/{Protheus.doc} User Function ADMNT214
    Retorna os tipos de serviço.
    @type  Function
    @author Everson
    @since 06/09/2022
    @version 01
/*/
User Function ADMNT214()

    //Variáveis.
    Local aArea     := GetArea()
    Local cQuery    := " SELECT TQ3_CDSERV, TQ3_NMSERV FROM " + RetSqlName("TQ3") + " (NOLOCK) AS TQ3 WHERE TQ3_FILIAL = '" + FWxFilial("TQ3") + "' AND TQ3.D_E_L_E_T_ = '' ORDER BY TQ3_CDSERV "
    Local cNewAlias :=  GetNextAlias()
    Local aDados    :=  {}
    Local JsonE     :=  Nil
    Local JsonR     :=  Nil
    Local cJson     := ""

    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNewAlias, .F., .T.)

    (cNewAlias)->(DbGoTop())

    While ! (cNewAlias)->(Eof())

        JsonE := JsonObject():New()

        JsonE['code']           := Alltrim(cValToChar((cNewAlias)->TQ3_CDSERV))
        JsonE['description']    := Alltrim(cValToChar((cNewAlias)->TQ3_NMSERV))

        Aadd(aDados, JsonE)

        FreeObj(JsonE)
        JsonE := Nil

        (cNewAlias)->(DbSkip())

    End

    JsonR := JsonObject():New()
    JsonR['count'] := Len(aDados)
    JsonR['items'] := aDados
    cJson := JsonR:toJson()

    FreeObj(JsonR)
    JsonR := Nil

    (cNewAlias)->(DbCloseArea())

    RestArea(aArea)

Return cJson
/*/{Protheus.doc} ADMNT211
    Obtém solicitação de serviço sem avaliação.
    @type  Function
    @author Everson
    @since 05/09/2022
    @version 01
/*/
User Function ADMNT211(cCodUsrSS, lJson)

    //Variáveis.
    Local aArea         := GetArea()
	Local cCondic       := ""
    Local cAddFiltro    := ""
	Local lFacilit      := MNTINTFAC()
    Local aDados        :=  {}
    Local JsonE         :=  Nil
    Local JsonR         :=  Nil
    Local cJson         := ""
    Local cBem          := ""
    Local cServico      := ""
    Local cDepart       := ""
    Local cSolicitacao  := ""
    Local cSolucao      := ""

	Default cCodUsrSS   := RetCodUsr()
	Default lJson       := .T.

	DbSelectArea("TQB")
	TQB->(DbSetOrder(10))

	TQB->(DbSeek(FWxFilial("TQB") + cCodUsrSS))

	If !lFacilit
		cCondic := 'TQB->TQB_SOLUCA == "E" .And. (Empty(TQB->TQB_PSAP) .Or. Empty(TQB->TQB_PSAN)) .And. MNT305CHKP()'

	Else
		cCondic := 'TQB->TQB_SOLUCA == "E" .and. !Empty(TQB->TQB_SEQQUE) .and. TQB->TQB_SATISF == "2"'

	EndIf

	If ExistBlock("MNTA2804")
		
        cAddFiltro := ExecBlock("MNTA2804",.F.,.F.)

		If !Empty(cAddFiltro)
			cCondic += ' .And. ('+cAddFiltro+')'

		EndIf

	EndIf

	While !TQB->(Bof()) .And. TQB->TQB_FILIAL == FWxFilial("TQB") .And. Alltrim(TQB->TQB_CDSOLI) == Alltrim(cCodUsrSS)

		If &cCondic

            If ! lJson
                RestArea(aArea)
                Return .T.

            EndIf

            cBem     := Alltrim(cValToChar(TQB->TQB_CODBEM)) + " - " + Alltrim(cValToChar( Posicione("ST9", 1, FWxFilial("ST9") + TQB->TQB_CODBEM, "T9_NOME") ))
            cServico := Alltrim(cValToChar(TQB->TQB_CDSERV)) + " - " + Alltrim(cValToChar( Posicione("TQ3", 1, FWxFilial("TQ3") + TQB->TQB_CDSERV, "TQ3_NMSERV") ))
            cDepart  := Alltrim(cValToChar(TQB->TQB_CCUSTO)) + " - " + Alltrim(cValToChar( Posicione("CTT", 1, FWxFilial("TQB_CCUSTO") + TQB->TQB_CCUSTO, "CTT_DESC01") ))

            JsonE := JsonObject():New()

            JsonE['number']       := TQB->TQB_SOLICI
            JsonE['openingDate']  := DToC(TQB->TQB_DTABER)
            JsonE['closingDate']  := DToC(TQB->TQB_DTFECH)
            JsonE['closingTime']  := TQB->TQB_HOFECH
            JsonE['duration']     := TQB->TQB_TEMPO
            JsonE['asset']        := cBem
            JsonE['serviceType']  := cServico
            JsonE['department']   := cDepart
            JsonE['request']      := u_FIN064A0(MSMM(TQB->TQB_CODMSS,80))
            JsonE['solution']     := u_FIN064A0(MSMM(TQB->TQB_CODMSO,80))

            Aadd(aDados, JsonE)

            FreeObj(JsonE)
            JsonE := Nil

		EndIf

		TQB->(dbSkip())

	End

    If lJson
        oJson := JsonObject():New()
        oJson['items'] := aDados
        cJson := oJson:toJson() 

        FreeObj(oJson)
        oJson := Nil

        RestArea(aArea)

        Return cJson

    EndIf

    RestArea(aArea)

Return .F.
/*/{Protheus.doc} ADMNT217
    Obtém solicitação de serviço aberta.
    @type  Function
    @author Everson
    @since 10/09/2022
    @version 01
/*/
User Function ADMNT217()
    
    //Variáveis.
    Local aArea      := GetArea()
    Local cQuery     := " SELECT * FROM " + RetSqlName("TQB") + " (NOLOCK) AS TQB WHERE TQB_FILIAL = '" + FWxFilial("TQB") + "' AND TQB_SOLUCA IN ('A', 'D') AND TQB_CDSOLI = ? AND TQB.D_E_L_E_T_ = '' ORDER BY TQB_SOLICI "
    Local cNewAlias  :=  GetNextAlias()
    Local aDados     :=  {}
    Local JsonE      :=  Nil
    Local JsonR      :=  Nil
    Local cJson      := ""
    Local oStatement := FWPreparedStatement():New()
    Local cBem       := ""
    Local cServico   := ""
    Local cDepart    := ""
    Local cExecutante:= ""

    oStatement:SetQuery(cQuery)
    oStatement:SetString(1, __cUserId)
    cQuery := oStatement:getFixQuery()

    cQuery := ChangeQuery(cQuery)

    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNewAlias, .F., .T.)

    (cNewAlias)->(DbGoTop())

    While ! (cNewAlias)->(Eof())

        JsonE := JsonObject():New()

        cBem     := Alltrim(cValToChar((cNewAlias)->TQB_CODBEM)) + " - " + Alltrim(cValToChar( Posicione("ST9", 1, FWxFilial("ST9") + (cNewAlias)->TQB_CODBEM, "T9_NOME") ))
        cServico := Alltrim(cValToChar((cNewAlias)->TQB_CDSERV)) + " - " + Alltrim(cValToChar( Posicione("TQ3", 1, FWxFilial("TQ3") + (cNewAlias)->TQB_CDSERV, "TQ3_NMSERV") ))
        cDepart  := Alltrim(cValToChar((cNewAlias)->TQB_CCUSTO)) + " - " + Alltrim(cValToChar( Posicione("CTT", 1, FWxFilial("TQB_CCUSTO") + (cNewAlias)->TQB_CCUSTO, "CTT_DESC01") ))

        cExecutante := Alltrim(cValToChar( Posicione("ST1", 1, FWxFilial("ST1") + (cNewAlias)->TQB_CDEXEC, "T1_NOME") ))

        JsonE := JsonObject():New()

        JsonE['number']       := (cNewAlias)->TQB_SOLICI
        JsonE['status']       := Iif((cNewAlias)->TQB_SOLUCA == "A", "Aguardando Análise", "Distribuída")
        JsonE['openingDate']  := DToC(SToD((cNewAlias)->TQB_DTABER))
        JsonE['closingDate']  := DToC(SToD((cNewAlias)->TQB_DTFECH))
        JsonE['closingTime']  := (cNewAlias)->TQB_HOFECH
        JsonE['duration']     := (cNewAlias)->TQB_TEMPO
        JsonE['asset']        := cBem
        JsonE['serviceType']  := cServico
        JsonE['department']   := cDepart
        JsonE['request']      := u_FIN064A0(MSMM((cNewAlias)->TQB_CODMSS,80))
        JsonE['performer']    := Alltrim(cValToChar(Iif(Empty(cExecutante), (cNewAlias)->TQB_CDEXEC,cExecutante)))

        Aadd(aDados, JsonE)

        FreeObj(JsonE)
        JsonE := Nil

        (cNewAlias)->(DbSkip())

    End

    JsonR := JsonObject():New()
    JsonR['count'] := Len(aDados)
    JsonR['items'] := aDados
    cJson := JsonR:toJson()

    FreeObj(JsonR)
    JsonR := Nil

    (cNewAlias)->(DbCloseArea())

    RestArea(aArea)

Return cJson
/*/{Protheus.doc}
    Metódo Put para encerramento de OS.
    @type  Static Function
    @author Everson
    @since 05/09/2022
    @version 01
/*/
WsMethod Put WsService solicitacaodeservico

    //Variáveis.
    Local cBody 	    := Self:GetContent()
    Local aParametros	:= Self:aURLParms
    Local cSS           := ""
    Local cErro         := ""

    Self:SetContentType(cFormatRet)

    If Empty(cBody) .Or. Len(aParametros) <= 0
        SetRestFault(400,EncodeUTF8("Dados inválidos."),.T.)
        Return .F.

    EndIf

    cSS := Alltrim(cValToChar(aParametros[1]))

    If ! U_ADMNT215(cSS, cBody, @cErro)
        SetRestFault(400,EncodeUTF8(cErro),.T.)
        Return .F.

    EndIf

    Self:SetResponse("")

Return .T.
/*/{Protheus.doc} ADMNT215
    Processa a avaliação da SS.
    @type  Function
    @author Everson
    @since 08/09/2022
    @version 01
/*/
User Function ADMNT215(cCodSS, cBody, cErro)

    //Variáveis.
    Local aArea     := GetArea()
    Local oJson     := JsonObject():New()
    Local xRet      := Nil
    Local oTQB      := Nil
    Local nCont     := 1
    Local c_PSAP    := ""
    Local c_PSAN    := ""
    Local c_Obs1    := ""
    Local c_Obs2    := ""
    Local a_CPOS    := {}
    Local a_CNTD    := {}

    Default cErro   := ""

    logZBE("Avaliação SS", "Usuário " + cValToChar(__cUserId) + " " + UsrRetName(__cUserId) + " SS " + cValToChar(cCodSS), cBody)

    xRet := oJson:fromJson(cBody)

    If ValType(xRet) <> "U"
        cErro := "Erro Parser Json"
        logZBE("Erro Parser - Avaliação SS", "Usuário " + cValToChar(__cUserId) + " " + UsrRetName(__cUserId) + " SS " + cValToChar(cCodSS), cBody)
        RestArea(aArea)
        Return .F.

    EndIf

    DbSelectArea("TQB")
    TQB->(DbSetOrder(1))
    TQB->(DbGoTop())
    If ! TQB->( DbSeek( FWxFilial("TQB") + cCodSS ) )
        cErro := "SS " + cCodSS + " não localizada"
        logZBE("SS não localizada - Avaliação SS", "Usuário " + cValToChar(__cUserId) + " " + UsrRetName(__cUserId) + " SS " + cValToChar(cCodSS), cBody)
        RestArea(aArea)
        Return .F.

    EndIf

    If TQB->TQB_SOLUCA <> "E"
        cErro := "SS " + cCodSS + " está encerrada"
        logZBE("SS não está encerrada - Avaliação SS", "Usuário " + cValToChar(__cUserId) + " " + UsrRetName(__cUserId) + " SS " + cValToChar(cCodSS), cBody)
        RestArea(aArea)
        Return .F.

    EndIf

    oTQB := MntSR():New()

    // Determina que a operação selecionada será alteração.
    oTQB:setOperation(4)

    // Não será apresentando as mensagens.
    oTQB:setAsk(.F.)

    // Posiciona no registro utilizado.
    oTQB:Load({ FWxFilial("TQB") + cCodSS })

    c_PSAP := oJson['levelDeadline']
    c_PSAN := oJson['levelQuality']
    c_Obs1 := oJson['deadlineSatisfaction']
    c_Obs2 := oJson['qualitySatisfaction']

    If ExistBlock("MNTW0351")
        a_CPOS :=  ACLONE(ExecBlock("MNTW0351",.F.,.F.))

    EndIf

    If Len(a_CPOS) > 0
        a_CNTD := Array(Len(a_CPOS))

        For nCont := 1 To Len(a_CPOS)
            a_CNTD[nCont] := oProcess:oHtml:RetByName(a_CPOS[nCont][1])

        Next

    EndIf

    If Len(a_CPOS) > 0

        For nCont := 1 To Len(a_CPOS)
            oTQB:setValue(a_CPOS[nCont][2], SubStr(a_CNTD[nCont], 1,1))

        Next

    EndIf

    // Define os valores necessários para permitir o Resposta da Satisfação da S.S.
    oTQB:setValue("TQB_PSAP", Substr(c_PSAP, 1,1))
    oTQB:setValue("TQB_PSAN", Substr(c_PSAN, 1,1))

    If NGCADICBASE("TQB_OBSPRA","A","TQB",.F.) .And. !Empty(c_Obs1)
        oTQB:setValue("TQB_OBSPRA", c_Obs1)

    ElseIf !Empty(c_Obs1)
        NGWFLog(STR0044+" '"+STR0045+"'. "+STR0046) //"Erro ao receber a Observacao"###"Prazo"###"Campo nao existe no dicionario/base"
        cErro := STR0044+" '"+STR0045+"'. "+STR0046

        oTQB:Free()
        RestArea(aArea)
        Return .F.

    EndIf

    If NGCADICBASE("TQB_OBSATE","A","TQB",.F.) .And. !Empty(c_Obs2)
        oTQB:setValue("TQB_OBSATE", c_Obs2)

    ElseIf !Empty(c_Obs2)
        NGWFLog(STR0044+" '"+STR0047+"'. "+STR0046) //"Erro ao receber a Observacao"###"Necessidade"###"Campo nao existe no dicionario/base"
        cErro := STR0044+" '"+STR0047+"'. "+STR0046

        oTQB:Free()
        RestArea(aArea)
        Return .F.

    EndIf

    // Verifica se o registro é válido para o fechamento.
    If oTQB:valid()

        // Realiza o fechamento da solicitação.
        oTQB:upsert()

    Else
    
        If Len(oTQB:oError:aError) > 0
            cErro := oTQB:oError:aError[1]

        Else
            cErro := "Erro de validação(ADMNT215)"

        EndIf

        oTQB:Free()
        RestArea(aArea)
        Return .F.

    EndIf

    // Fecha o objeto.
    oTQB:Free()

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} ADMNT216
    Criar SS.
    @type  Function
    @author Everson
    @since 08/09/2022
    @version 01
/*/
User Function ADMNT216(cBody, cErro, cNumSS)

    //Variáveis.
    Local aArea         := GetArea()
    Local Json          := JsonObject():New()
    Local xRet          := Nil
    Local aSolic        := {}
    Local lPesqSat      := GetMv("MV_NGPSATI",.F.,"N") == "S"
    Local cTexto        := ""

    Private lMSHelpAuto := .T.
    Private lMSErroAuto := .F.

    Default cErro       := ""
    Default cNumSS      := ""

    logZBE("Criar SS", "Usuário " + cValToChar(__cUserId) + " " + UsrRetName(__cUserId), cBody)

    //Pesquisa de satisfação.
    If lPesqSat .And. ! NG280SAT()
        cErro := "Há SS com pendência de avaliação"
        logZBE("Error Pesq Satisf - Criar SS", "Usuário " + cValToChar(__cUserId) + " " + UsrRetName(__cUserId), cBody)
        RestArea(aArea)
        Return .F.
        
    EndIf

    xRet := Json:fromJson(cBody)

    If ValType(xRet) <> "U"
        cErro := "Erro Parser Json"
        logZBE("Erro Parser - Criar SS", "Usuário " + cValToChar(__cUserId) + " " + UsrRetName(__cUserId), cBody)
        RestArea(aArea)
        Return .F.

    EndIf

    DbSelectArea("ST9")
    ST9->(DbSetOrder(1))
    ST9->(DbGoTop())
    If ! ST9->(DbSeek( FWxFilial("ST9") + Json['asset']  ))
        cErro := "Bem " + cValToChar(Json['asset']) + " não localizado"
        logZBE("Bem não localizado - Criar SS", "Usuário " + cValToChar(__cUserId) + " " + UsrRetName(__cUserId) + " Bem " + cValToChar(Json['asset']), cBody)
        RestArea(aArea)
        Return .F.

    EndIf

    cTexto := Json['solicitation']
    cTexto := Alltrim(cValToChar(DecodeUTF8(cTexto)))

    If Empty(cTexto)
        cTexto := Json['solicitation']

    EndIf

    aSolic := {;
               {"TQB_TIPOSS", "B"                     ,Nil},;        
               {"TQB_CODBEM", Json['asset']           ,Nil},;        
               {"TQB_DTABER", Date()                  ,Nil},;        
               {"TQB_HOABER", Time()                  ,Nil},;        
               {"TQB_RAMAL" , Json['extensionNumber'] ,Nil},;
               {"TQB_DESCSS", cTexto                  ,Nil},;
               {"TQB_CDSOLI", __cUserId               ,Nil},;
               {"TQB_CDSERV", Json['serviceType']     ,Nil},;
               {"TQB_CODMSS", cTexto                  ,Nil};
              }

    FreeObj(Json)
    Json := Nil

    aSolic := FWVetByDic(aSolic, "TQB")

    MSExecAuto( {|x,z,y,w| MNTA280(x,z,y,w)}, , , aSolic, 3)

    If lMsErroAuto
        cErro := Mostraerro()
        RestArea(aArea)
        Return .F.

    EndIf

    cNumSS := TQB->TQB_SOLICI

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} logZBE
    Gera log na ZBE.
    @type  Static Function
    @author Everson
    @since 08/09/2022
    @version 01
/*/
Static Function logZBE(cMsg, cParam, cLog)

    //Variáveis.
    Default cMsg   := ""
    Default cParam := ""
    Default cLog   := ""

    RecLock("ZBE", .T.)
		Replace ZBE_FILIAL 	   	With FWxFilial("ZBE")
		Replace ZBE_DATA 	   	With Date()
		Replace ZBE_HORA 	   	With Time()
		Replace ZBE_USUARI	    With Upper(Alltrim(cUserName))
		Replace ZBE_LOG	        With cMsg
		Replace ZBE_PARAME	    With cParam
        Replace ZBE_LOGMEM	    With cLog
		Replace ZBE_MODULO	    With "MANUTENCAO"
		Replace ZBE_ROTINA	    With "ADMNT021P" 
    ZBE->(MsUnlock())

Return Nil
