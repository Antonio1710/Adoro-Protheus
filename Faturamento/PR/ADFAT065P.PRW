#Include "Protheus.ch"
#Include "Restful.ch"
#Include "Topconn.ch"

Static xPula := Chr(13) + Chr(10)

/*/{Protheus.doc} User Function ADFAT065P
    Api para comunicação com o ChatGuru.
    @type  Function
    @author Everson
    @since 12/12/2022
    @version 01
    @history ticket  83060 - Jonathan Carvalho - 26/01/2023 - Inclusão do campo de NOMEGRANJA
    @history ticket  83060 - Jonathan Carvalho - 29/01/2023 - Inclusão da Opção de Informação da Granja
    @history ticket  83060 - Jonathan Carvalho - 30/01/2023 - Alteração no texto de envio, feito alteração na localização.
/*/
User Function ADFAT065P(aEmpFil)

    //Variáveis.
    Default aEmpFil := {"01", "03"}

	RpcSetEnv(aEmpFil[1], aEmpFil[2],,,,GetEnvServer(),{ })

        U_ADFAT65A()

    RpcClearEnv()

Return Nil
/*/{Protheus.doc} User Function ADFAT65A
    Processa Job.
    @type  Function
    @author user
    @since 12/12/2022
    @version 01
/*/
User Function ADFAT65A()

    //Variáveis.
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local cMsgError := ""
    Local oJson     := Nil
    Local cJson     := ""
    Local lRetEnv   := .F.
    Local cUrl      := Alltrim(cValToChar(GetMV("MV_#VEN640",,"https://s17.chatguru.app")))
    Local cKey      := Alltrim(cValToChar(GetMV("MV_#VEN641",,"0IU2JJ5ONN9USMZ61VPARBFMKTEEPLXCLCXUTE2YJC6S8GZ3112FDPLF45JG3Y9U")))
    Local cAccount  := Alltrim(cValToChar(GetMV("MV_#VEN642",,"638127f539f56a731664c748")))
    Local cPhoneId  := Alltrim(cValToChar(GetMV("MV_#VEN643",,"6381f2c13598c1bcd170286d")))
    Local cServico  := "/api/v1"
    Local cBody     := ""
    //Local cGranja   := ""
    Local cOrdem    := ""
    Local cURA      := ""
    Local cTexto    := ""
    Local cPhone    := ""
    Local cId       := ""
    Local cOperac   := ""
    Local cAlias    := GetNextAlias()

    cQuery += " SELECT  " 
        cQuery += " ZIQ_UUID, "
        cQuery += " ZIQ_OPERAC, "
        cQuery += " R_E_C_N_O_ AS RECNO "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("ZIQ") + " (NOLOCK) AS ZIQ  " 
    cQuery += " WHERE  " 
        cQuery += " ZIQ_FILIAL = '" + FWxFilial("ZIQ") + "'  " 
        cQuery += " AND ZIQ_TIPO = 'W' " 
        cQuery += " AND ZIQ_TOPICO IN('status_programacao_chatguru', 'info_granja_chatguru')  " 
        cQuery += " AND ZIQ_SISGER = 'CHATGURU' " 
        cQuery += " AND ZIQ_PROCES = '2' " 
        cQuery += " AND ZIQ.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY RECNO " 

    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
    (cAlias)->(DbGoTop())

    DbSelectArea("ZIQ")
    ZIQ->(DbSetOrder(1))

    While ! (cAlias)->(Eof())

        ZIQ->(DbGoto((cAlias)->RECNO))
        
        cMsgError := ""
        
        cId       := Alltrim(cValToChar(ZIQ->ZIQ_UUID))
        cOperac   := (cAlias)->ZIQ_OPERAC 
        cJson     := ZIQ->ZIQ_DADOS
        oJson     := getJson(cJson)

        If ValType(oJson) == "U"
            cMsgError := "Não foi possível converter a string para objeto json. " + cId
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT065P(ADFAT065P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAlias)->(DbSkip())
            Loop

        EndIf

        If ValType(oJson['dados']) == "U"
            cMsgError := "Objeto json não possui a chave dados " + cId
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT065P(ADFAT065P)", Nil, "Erro no processamento ChatGuru " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAlias)->(DbSkip())
            Loop

        EndIf

        cURA    := Alltrim(cValToChar(oJson['dados']['bot_context']['URA'])) 
        cPhone  := Alltrim(cValToChar(oJson['dados']['celular']))        
        cOrdem  := Alltrim(CValToChar(oJson['dados']['texto_mensagem']))

        //cURA = 1 -> Status da Ordem de Carregamento
        If cURA == '1'
            cTexto := U_ADFAT651(cPhone)
        //cURA = 2.1 -> Info da Granja
        ElseIf cURA == '2.1'
            cTexto := U_ADFAT652(cOrdem)
        
        Else 
            cTexto := "Opção não encontrada"

        EndIf
        
        //If ! Empty(cGranja)
		//    cTexto  := U_ADFAT651(cGranja)

        //Else
        //    cTexto  := "Granja nao informada"

        //EndIf

        cTexto := Escape(cTexto)

        FreeObj(oJson)
        oJson := Nil

        lRetEnv := U_ADFAT642(cUrl, cServico, cKey, cAccount, cPhoneId, cBody, cTexto, cPhone, @cMsgError)

        If ! lRetEnv
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Função ADFAT065P(ADFAT065P)", Nil, "Erro no processamento ChatGuru x Protheus " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        Else
            U_ADFAT643(cPhone, @cMsgError) //Encerra o atendimento.

            U_ADFAT29D(cId, "1", "")

        EndIf

        (cAlias)->(DbSkip())
  
    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function nomeFunction
    Texto de resposta para o tópico status_programacao_chatguru.
    @type  Function
    @author Everson
    @since 13/12/2022
    @version 01
/*/
User Function ADFAT651(cPhone)

    //Variáveis.
    Local aArea     := GetArea()
    Local cTexto    := ""
    Local cStatus   := ""
    Local cContMot  := ""
    Local cQuery    := ""
    Local cAlias    := GetNextAlias()

    //Default cGranja := ""

    //If Empty(cGranja)
    //    RestArea(aArea)
    //    Return "Granja não informada"

    //EndIf

    Default cPhone := "" //Jonathan 26/01/2023

    If Empty(cPhone)
        RestArea(aArea)
        Return "Telefone não informada"

    EndIf

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " ZIR_NUMERO, "
        cQuery += " ZIR_INTCOD, "  
        cQuery += " ZIR_QUANT, " 
        cQuery += " ZIR_DTCAR, " 
        cQuery += " ZIF_NUMERO, " 
        cQuery += " ISNULL(ZIG_PESOLI,0) AS ZIG_PESOLI, " 
        cQuery += " ZIM_SGPSAG, " 
        cQuery += " ZIG_INICIA, " 
        cQuery += " ZIR_PLACA, " 
        cQuery += " ZVC_MOTORI, " 
        cQuery += " ZVC_TELPRI, " 
        cQuery += " ZV4_CPF, " 
        cQuery += " C5_NUM, " 
        cQuery += " C5_NOTA, " 
        cQuery += " C5_SERIE, F2_EMISSAO, F2_HORA " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZIR") + " (NOLOCK) AS ZIR " 
        cQuery += " INNER JOIN " 
        cQuery += " " + RetSqlName("ZIM") + " (NOLOCK) AS ZIM ON " 
        cQuery += " ZIR_PRDSAG = ZIM_PRDSAG " 
        cQuery += " AND ZIM.D_E_L_E_T_ = '' " 
        cQuery += " LEFT OUTER JOIN " 
        cQuery += " " + RetSqlName("ZIF") + " (NOLOCK) AS ZIF ON " 
        cQuery += " ZIR_FILIAL = ZIF_FILIAL " 
        cQuery += " AND ZIR_NUMERO = ZIF_ORDRAC " 
        cQuery += " LEFT OUTER JOIN " 
        cQuery += " " + RetSqlName("ZIG") + " (NOLOCK) AS ZIG ON " 
        cQuery += " ZIF_FILIAL = ZIG_FILIAL " 
        cQuery += " AND ZIF_NUMERO = ZIG_ORDEM " 
        cQuery += " AND ZIG.D_E_L_E_T_ = '' " 
        cQuery += " LEFT OUTER JOIN " 
        cQuery += " " + RetSqlName("SC5") + " (NOLOCK) AS SC5 ON " 
        cQuery += " ZIF_FILIAL = C5_FILIAL " 
        cQuery += " AND ZIF_NUMERO = C5_XORDPES " 
        cQuery += " AND SC5.D_E_L_E_T_ = '' " 
        cQuery += " LEFT OUTER JOIN " 
        cQuery += " " + RetSqlName("ZV4") + " (NOLOCK) AS ZV4 ON " 
        cQuery += " ZIR_PLACA = ZV4_PLACA " 
        cQuery += " AND ZV4.D_E_L_E_T_ = '' "
        cQuery += " LEFT OUTER JOIN " 
        cQuery += " " + RetSqlName("ZVC") + " (NOLOCK) AS ZVC ON " 
        cQuery += " ZV4_CPF = ZVC_CPF " 
        cQuery += " AND ZVC_CPF <> '' " 
        cQuery += " AND ZVC.D_E_L_E_T_ = '' " 
        cQuery += " LEFT OUTER JOIN "
        cQuery += " " + RetSqlName("SF2") + " (NOLOCK) AS SF2 ON "
        cQuery += " C5_FILIAL = F2_FILIAL "
        cQuery += " AND C5_NOTA = F2_DOC "
        cQuery += " AND C5_SERIE = F2_SERIE "
        cQuery += " AND SF2.D_E_L_E_T_ = '' "        
    cQuery += " WHERE " 
        //cQuery += " ZIR_INTCOD = '" + cGranja + "' " 
        cQuery += " ZIR_INTCOD IN (SELECT A2_NREDUZ FROM SA2010 WHERE A2_XWHATS = '" + cPhone + "')" //Jonathan 26/01/2023
        cQuery += " AND CAST(ZIR_DTCAR AS DATE) >= CAST(GETDATE() AS DATE) " 
        cQuery += " AND ZIR.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY ZIR_NUMERO " 

    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
    (cAlias)->(DbGoTop())

    If (cAlias)->(Eof())
        (cAlias)->(DbCloseArea())
        RestArea(aArea)
        Return "Aguardando programacao"

    EndIf

    While ! (cAlias)->(Eof())

        If ! Empty((cAlias)->C5_NOTA)
            cStatus := "Faturada"

        ElseIf Empty(cValToChar((cAlias)->ZIF_NUMERO))
            cStatus := "Programada"

        ElseIf Alltrim(cValToChar((cAlias)->ZIG_INICIA)) == "1"
            cStatus := "Aguardando carregamento"

        ElseIf Alltrim(cValToChar((cAlias)->ZIG_INICIA)) == "2"
            cStatus := "Carregando"

        ElseIf Alltrim(cValToChar((cAlias)->ZIG_INICIA)) == "3"
            cStatus := "Aguardando faturamento"

        Else
            cStatus := "XXXXXXXXXXX"

        EndIf

        cContMot := Alltrim(cValToChar((cAlias)->ZVC_MOTORI)) + "  Tel: " + Alltrim(cValToChar((cAlias)->ZVC_TELPRI))

        cTexto := "Status: "                   + cStatus + "%0A"
        cTexto += "Granja: "                   + Alltrim(cValToChar((cAlias)->ZIR_INTCOD)) + "%0A"
        //cTexto += "Data carregamento: "        + DToC(SToD((cAlias)->ZIR_DTCAR)) + "%0A"
        cTexto += "Ordem de Carregamento: "    + Alltrim(cValToChar((cAlias)->ZIR_NUMERO)) + "%0A"
        //cTexto += "Qtd. Ordem Carregamento: "  + Alltrim(cValToChar(Transform((cAlias)->ZIR_QUANT, "@E 999,999,999")))  + "%0A"
        cTexto += "Carregado (Kg): "  + Alltrim(cValToChar(Transform((cAlias)->ZIG_PESOLI, "@E 999,999,999"))) + "%0A"
        cTexto += "Fase: "                     + Alltrim(cValToChar((cAlias)->ZIM_SGPSAG)) + "%0A"
        cTexto += "Placa: "                    + Alltrim(cValToChar((cAlias)->ZIR_PLACA))  + "%0A"
        cTexto += "Contato do Motorista: "     + Alltrim(cValToChar(cContMot)) + "%0A"
        cTexto += "Nota Fiscal: "              + Alltrim(cValToChar((cAlias)->C5_NOTA)) + " " + (cAlias)->C5_SERIE + "%0A"
        cTexto += "Data/Hora de Faturamento: " + DToC(SToD((cAlias)->F2_EMISSAO)) + " " + (cAlias)->F2_HORA + "%0A"
        cTexto += "-------------------------------------------------------" + "%0A%0A"

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)

Return cTexto

/*/{Protheus.doc} User Function nomeFunction
    Texto de resposta para o tópico info_granja_chatguru.
    @type  Function
    @author Jonathan
    @since 29/01/2022
    @version 02
/*/

User Function ADFAT652(cOrdem)
//Variáveis.
    Local aArea     := GetArea()
    Local cTexto    := ""
    Local cQuery    := ""
    Local cAlias    := GetNextAlias()
    Local cLocal    := "https://www.google.com/maps/place/"
    Local cLongi    := ""
    Local cLatit    := ""

    Default cOrdem := ""

    If Empty(cOrdem)
        RestArea(aArea)
        Return "Granja não informada"

    EndIf   

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " ZIR_INTCOD, " 
        cQuery += " A2_NOME, " 
        cQuery += " REPLACE(A2_END,'/','') AS A2_END , " 
        cQuery += " A2_NR_END, " 
        cQuery += " A2_BAIRRO, " 
        cQuery += " A2_CEP, " 
        cQuery += " A2_MUN, " 
        cQuery += " A2_DDD, " 
        cQuery += " A2_TEL, " 
        cQuery += " A2_XWHATS, "
        cQuery += " REPLACE(RTRIM(REPLACE(A2_END,'/',''))+'+'+RTRIM(A2_BAIRRO)+'+'+RTRIM(A2_MUN)+'/@', ' ','+') AS LOCALIZACAO, "
        cQuery += " ZF3_LATITU, "
        cQuery += " ZF3_LONGIT "
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZIR") + " (NOLOCK) AS ZIR " 
        cQuery += " LEFT OUTER JOIN " 
        cQuery += " " + RetSqlName("SA2") + " (NOLOCK) AS SA2 ON "
        cQuery += " SA2.A2_COD = ZIR.ZIR_FORNEC "
        cQuery += " AND SA2.A2_LOJA = ZIR.ZIR_LOJA "
        cQuery += " LEFT OUTER JOIN " 
        cQuery += " " + RetSqlName("ZF3") + " (NOLOCK) AS ZF3 ON "
        cQuery += " ZF3.ZF3_FORCOD = ZIR.ZIR_FORNEC "
        cQuery += " AND ZF3.ZF3_FORLOJ = ZIR.ZIR_LOJA"
    cQuery += " WHERE " 
        cQuery += " ZIR_NUMERO = REPLICATE('0', 10 - LEN('"+cOrdem+"')) + RTrim('"+cOrdem+"') " 
        cQuery += " AND CAST(ZIR_DTCAR AS DATE) >= CAST(GETDATE()-3 AS DATE) " 
        cQuery += " AND ZIR.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY ZIR_NUMERO " 

    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
    (cAlias)->(DbGoTop())

    If (cAlias)->(Eof())
        (cAlias)->(DbCloseArea())
        RestArea(aArea)
        Return "Granja Não Localizada"

    EndIf

    While ! (cAlias)->(Eof())   

        //cLongi := Alltrim(cValToChar((cAlias)->ZF3_LONGIT))
        //cLongi := StrTran(cLongi, "°", "")
        //cLongi := StrTran(cLongi, "'", "&apos")
        //cLongi := StrTran(cLongi, '"', '&quot')

        //cLatit := Alltrim(cValToChar((cAlias)->ZF3_LATITU))
        //cLatit := StrTran(cLatit, "°", "")
        //cLatit := StrTran(cLatit, "'", "&apos")
        //cLatit := StrTran(cLatit, '"', '&quot')


        cTexto := "Granja: "                   + Alltrim(cValToChar((cAlias)->ZIR_INTCOD)) + "%0A"
        cTexto += "Granjeiro: "                + Alltrim(cValToChar((cAlias)->A2_NOME)) + "%0A"
        cTexto += "Endereco: "                 + Alltrim(cValToChar((cAlias)->A2_END)) + "%0A"
        cTexto += "Numero: "                   + Alltrim(cValToChar((cAlias)->A2_NR_END)) + "%0A"
        cTexto += "Bairro: "                   + Alltrim(cValToChar((cAlias)->A2_BAIRRO)) + "%0A"
        cTexto += "Cep: "                      + Alltrim(cValToChar((cAlias)->A2_CEP)) + "%0A"
        cTexto += "Municipio: "                + Alltrim(cValToChar((cAlias)->A2_MUN))  + "%0A"
        cTexto += "Localizacao: "              + cLocal + REPLACE(Alltrim(cValToChar((cAlias)->LOCALIZACAO)),',','') + "%0A"
        cTexto += "Telefone: "                 + "(" +Alltrim(cValToChar((cAlias)->A2_DDD)) + ")" + " " + Alltrim(cValToChar((cAlias)->A2_TEL)) + "%0A"
        cTexto += "WhatsApp: "                 + Alltrim(cValToChar((cAlias)->A2_XWHATS)) + "%0A"
        cTexto += "-------------------------------------------------------" + "%0A%0A"

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)
Return cTexto

WsRestFul chatguru Description "Serviço REST para processamento de requisições do ChatGuru."

	WsMethod Post Description "Consulta de programação."  WsSyntax "/programacaoracao"

End WsRestFul

WsMethod Post WsService chatguru

    //Variáveis.
	Local aArea		:= GetArea()
	Local cBody		:= Self:GetContent()
	Local cMsgError := ""

    conout(cBody)

	Self:SetContentType("application/json")

    U_GrLogZBE(Date(), Time(), cUserName, "REQUISIÇÃO CHATGURU", "FATURAMENTO", "ADFAT650", "", ComputerName(), LogUserName())

	If ! U_ADFAT650(cBody, @cMsgError)
		SetRestFault(400, EncodeUtf8(cMsgError))
		RestArea(aArea)
		Return .F.

	EndIf

	RestArea(aArea)

Return .T.
/*/{Protheus.doc} ADFAT650
	Processa requisições.
	@type  Function
	@author Everson
	@since 12/12/2022
	@version 01
/*/
User Function ADFAT650(cJson, cMsgError)

	//Variáveis.
	Local aArea  	:= GetArea()
	Local oJsonD   	:= Nil
    Local oJson     := Nil
    Local cDados    := ""
	Local cTopico 	:= ""
	Local cId     	:= FWUUIDV1(.T.)
	Local cData     := DToS(Date())
    Local cHora     := Time()

	oJsonD := getJson(cJson)

	If ValType(oJsonD) == "U"
		cMsgError := "Não foi possível converter a string para objeto json."
		U_GrLogZBE(Date(), Time(), cUserName, "ERRO - REQUISIÇÃO CHATGURU", "FATURAMENTO", "ADFAT650", cMsgError, ComputerName(), LogUserName())
		RestArea(aArea)
		Return .F.

	EndIf

	cTopico := Alltrim(cValToChar(oJsonD['campanha_id']))

    If Empty(cTopico)
        cTopico := "ND"

    EndIf

    oJson   := JsonObject():New()

    U_ADFAT270(oJson, cData, cHora, cId, cTopico, "I")

    oJson['dados'] := oJsonD

    cDados := oJson:toJson()

    FreeObj(oJson)
    FreeObj(oJsonD)

	If ! U_ADFAT27B("I", cTopico, cId, cDados, cData, cHora, "W", , , , "CHATGURU")
		cMsgError := "Não foi possível salvar a requisição."
		U_GrLogZBE(Date(), Time(), cUserName, "ERRO - REQUISIÇÃO CHATGURU", "FATURAMENTO", "ADFAT650", cMsgError, ComputerName(), LogUserName())
		RestArea(aArea)
		Return .F.

	EndIf

	RestArea(aArea)

Return .T.
/*/{Protheus.doc} getJson
    Converte string json para objeto json.
    @type  Function
    @author Everson
    @since 12/12/2022
    @version 01
/*/
Static Function getJson(cJson)

    //Variáveis.
    Local oJson := JsonObject():New()
    Local xRet  := oJson:FromJson(cJson)

    If ! ValType(xRet) == "U"
        Return Nil

    EndIf

Return oJson
