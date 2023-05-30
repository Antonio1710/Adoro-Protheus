#Include "Protheus.ch"
#Include "Topconn.ch"

Static cTopico  := "text_whats_protheus"

Static xPula    := Chr(13) + Chr(10)

/*/{Protheus.doc} User Function ADFAT064P
    Job para envio de mensagem de texto para o ChatGuru.
    @type  Function
    @author Everson
    @since 09/12/2022 
    @version 01
    @history ticket  83060 - Jonathan Carvalho - 26/01/2023 - Inclusão do campo A2_XWHATS para envio de NF faturadas 
    @history ticket  83060 - Jonathan Carvalho - 29/01/2023 - Inclusão da opção de informação da Granja
    @history ticket  83060 - Jonathan Carvalho - 30/01/2023 - Inclusão das informações da Granja apos o Faturamento
    @history ticket  83060 - Everson - 20/03/2023 - Adicionado link para acessar o mapa.
    @history Ticket  83060 - Jonathan Carvalho - 23/03/2023 - Inclusão do nome da Granja nas mensagens. 
    @history Ticket  83060 - Jonathan Carvalho - 24/03/2023 - Inclusão de telefone para granja HH
    @history Everson, 27/03/2023, ticket 83060 - Alterada a busco do código da granja da tabela SA2 para tabela ZIR.
    @history ticket  83060 - Jonathan Carvalho - 03/04/2023 - Ajuste no condigo da granja ZIR dbselect 
    @history ticket  83060 - Jonathan Carvalho - 04/04/2023 - Tratamento para as granjas HH
    @history Ticket  83060 - Jonathan Carvalho - 08/04/2023 - Includo relatorio de envios para Tecnicos
    @history Ticket  83060 - Jonathan Carvalho - 11/04/2023 - Correção no endereço das granjas da HH
    @history Ticket  83060 - Jonathan Carvalho - 20/04/2023 - Tratamento para não trazes os registros da SGPED010
    @history Ticket  83060 - Jonathan Carvalho - 28/04/2023 - Tratamento para não enviar refaturamento 
    @history Ticket  83060 - Jonathan Carvalho - 24/05/2023 - Inclusão da Rotina de Devolução
/*/
User Function ADFAT064P(aEmpFil)

    //Variáveis.
    Default aEmpFil := {"01", "03"}

	RpcSetEnv(aEmpFil[1], aEmpFil[2],,,,GetEnvServer(),{ })

        U_ADFAT64B() //Envio de cadastro.

        U_ADFAT64A() //Envio de faturamento.

        //U_ADFAT64C() //Envio de Faturamento Relatorio. Ticket 83060 - Jonathan 08/04/2023 

    RpcClearEnv()

Return Nil
/*/{Protheus.doc} User Function ADFAT64A
    Processa Job para envio de faturamento.
    @type  Function
    @author user
    @since 12/12/2022
    @version 01
/*/
User Function ADFAT64A()

    //Variáveis.
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local cMsgError := ""
    Local oJson     := Nil
    Local cJson     := ""
    Local lRetEnv   := .F.
    Local lRetCad   := .F.
    Local cUrl      := Alltrim(cValToChar(GetMV("MV_#VEN640",,"https://s17.chatguru.app")))
    Local cKey      := Alltrim(cValToChar(GetMV("MV_#VEN641",,"0IU2JJ5ONN9USMZ61VPARBFMKTEEPLXCLCXUTE2YJC6S8GZ3112FDPLF45JG3Y9U")))
    Local cAccount  := Alltrim(cValToChar(GetMV("MV_#VEN642",,"638127f539f56a731664c748")))
    Local cPhoneId  := Alltrim(cValToChar(GetMV("MV_#VEN643",,"6381f2c13598c1bcd170286d")))
    Local cServico  := "/api/v1"
    Local cBody     := ""
    Local cTexto    := ""
    Local cNome     := ""
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
        cQuery += " AND ZIQ_TOPICO IN('text_whats_protheus_relatorio', 'text_whats_protheus') " 
        //cQuery += " AND ZIQ_TOPICO = '" + cTopico + "' " 
        cQuery += " AND ZIQ_SISGER = 'PROTHEUS' " 
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
            Help(Nil, Nil, "Funcao ADFAT064P(ADFAT064P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAlias)->(DbSkip())
            Loop

        EndIf

        If ValType(oJson['dados']) == "U"
            cMsgError := "Objeto json não possui a chave dados " + cId
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Funcao ADFAT064P(ADFAT064P)", Nil, "Erro no processamento ChatGuru " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAlias)->(DbSkip())
            Loop

        EndIf

        cTexto  := Alltrim(cValToChar(oJson['dados']['texto']))
        cPhone  := Alltrim(cValToChar(oJson['dados']['telefone']))
        cNome   := Alltrim(cValToChar(oJson['dados']['nome']))

        FreeObj(oJson)
        oJson := Nil

        lRetEnv := U_ADFAT642(cUrl, cServico, cKey, cAccount, cPhoneId, cBody, cTexto, cPhone, @cMsgError)

        If ! lRetEnv
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Funcao ADFAT064P(ADFAT064P)", Nil, "Erro no processamento ChatGuru x Protheus " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            
            //Força o envio do cadastro no ChatGuru
            lRetCad := U_ADFAT644(cPhone, 'Integracao', 'Cadastro Realizado no Chat Adoro')
            If ! lRetCad
                U_ADFAT29D(cId, "2", cMsgError)
                Help(Nil, Nil, "Funcao ADFAT064P(ADFAT064P)", Nil, "Erro no Cadastro ChatGuru x Protheus " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            EndIf
            
        Else
            U_ADFAT29D(cId, "1", "")

        EndIf

        (cAlias)->(DbSkip())
  
    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} getJson
    Converte string json para objeto json.
    @type  Function
    @author Everson
    @since 09/12/2022
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
/*/{Protheus.doc} ADFAT642
    Envia requisição.
    @type  User Function
    @author Everson
    @since 09/12/2022
    @version 01
/*/
User Function ADFAT642(cUrl, cServico, cKey, cAccount, cPhoneId, cBodyRq, cTexto, cPhone, cMsg)

    //Variáveis.
	Local aArea 		:= GetArea()
	Local lRet			:= .T.
    Local cPostParams   := ""
    Local cErro         := ""
    Local aHeader	    := {}

	Default cMsg		:= ""

    Aadd(aHeader, "Content-Type: application/json")

    cPostParams := EncodeUTF8("key=" + cKey + "&account_id=" + cAccount + "&phone_id=" + cPhoneId + "&chat_number=" + cPhone + "&action=message_send&text=" + cTexto)

    sPostRet := HttpPost(cUrl + cServico, cPostParams, cBodyRq, 120, aHeader, @cMsg)

    If ! ("HTTP/1.1 200 OK" $cMsg)

        cMsg += "URL: "        + cUrl + xPula
        cMsg += "Parâmetros: " + cPostParams + xPula
        cMsg += "EndPoint: "   + cServico + xPula
        cMsg += "Body: "       + xPula + cValToChar(cBodyRq) + xPula
        cMsg += "Resp: "       + xPula + cValToChar(sPostRet) + xPula
        cMsg += "Erro: "       + xPula + cValToChar(HTTPGetStatus(@cErro)) + " " + cValToChar(cErro) + xPula
        
        lRet := .F.

	EndIf

	RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT643
    Encerrar atendimento ChatGuru.
    @type  User Function
    @author Everson
    @since 13/12/2022
    @version 01
/*/
User Function ADFAT643(cPhone, cMsg)

    //Variáveis.
	Local aArea 		:= GetArea()
    Local cBodyRq       := ""
	Local lRet			:= .T.
    Local cPostParams   := ""
    Local cErro         := ""
    Local aHeader	    := {}
    Local cDialogId     := Alltrim(cValToChar(GetMV("MV_#VEN645",,"63812842bfbaa29b3fd4ad13")))
    Local cUrl          := Alltrim(cValToChar(GetMV("MV_#VEN640",,"https://s17.chatguru.app")))
    Local cKey          := Alltrim(cValToChar(GetMV("MV_#VEN641",,"0IU2JJ5ONN9USMZ61VPARBFMKTEEPLXCLCXUTE2YJC6S8GZ3112FDPLF45JG3Y9U")))
    Local cAccount      := Alltrim(cValToChar(GetMV("MV_#VEN642",,"638127f539f56a731664c748")))
    Local cPhoneId      := Alltrim(cValToChar(GetMV("MV_#VEN643",,"6381f2c13598c1bcd170286d")))
    Local cServico      := "/api/v1"

	Default cMsg		:= ""

    Aadd(aHeader, "Content-Type: application/json")

    cPostParams := EncodeUTF8("key=" + cKey + "&account_id=" + cAccount + "&phone_id=" + cPhoneId + "&chat_number=" + cPhone + "&action=dialog_execute&dialog_id=" + cDialogId)

    sPostRet := HttpPost(cUrl + cServico, cPostParams, cBodyRq, 120, aHeader, @cMsg)

    If ! ("HTTP/1.1 200 OK" $cMsg)

        cMsg += "URL: "        + cUrl + xPula
        cMsg += "Parâmetros: " + cPostParams + xPula
        cMsg += "EndPoint: "   + cServico + xPula
        cMsg += "Body: "       + xPula + cValToChar(cBodyRq) + xPula
        cMsg += "Resp: "       + xPula + cValToChar(sPostRet) + xPula
        cMsg += "Erro: "       + xPula + cValToChar(HTTPGetStatus(@cErro)) + " " + cValToChar(cErro) + xPula
        
        lRet := .F.

	EndIf

	RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADFAT640
    Envio de mensagem de faturamento.
    @type  Function
    @author Everson
    @since 12/12/2022
    @version 01
/*/
User Function ADFAT640(cNF, cSerie, cCod, cLoja)

    //Variáveis.
    Local aArea     := GetArea()
    Local cTexto    := ""
    Local c2Texto   := ""
    Local cTelefone := ""
    Local cContMot  := ""
    Local cTeleMot  := ""
    //Local cLocaliz  := ""
    Local cSigUrl   := ""
    Local cDevolu   := .F.
    //@history Ticket  83060 - Jonathan Carvalho - 24/05/2023
    Local cGranja   := ""   

    DbSelectArea("ZHR")
    ZHR->(DbSetOrder(4))
    ZHR->(DbGoTop())
    If ZHR->( DbSeek( FWxFilial("ZHR") + cNF + cSerie ) )
        cDevolu := .T.
        //RestArea(aArea)
        //Return Nil

    EndIf

    If cDevolu
    
        DbSelectArea("SF1")
        SF1->(DbSetOrder(1))
        SF1->(DbGoTop())
        If ! SF1->(DbSeek( FWxFilial("SF1") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA ))
            U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "NF nao localizada " + cNF + cSerie, ComputerName(), LogUserName())
            RestArea(aArea)
            Return Nil

        EndIf
        

        DbSelectArea("SB1")
        SB1->(DbSetOrder(1))
        SB1->(DbGoTop())
        If ! SB1->(DbSeek( FWxFilial("SB1") + SD1->D1_COD ))
            U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "Item NF nao localizada " + cNF + cSerie, ComputerName(), LogUserName())
            RestArea(aArea)
            Return Nil

        EndIf


        //Ticket 83060 Inclusão do Fone para filial HH
        If cCod == '247011' .And. cLoja == '00'  
            //Ticket 83060 - 24/03/2023
            DbSelectArea("SA1")
            SA1->(DbSetOrder(1))
            SA1->(DbGoTop())

            If ! SA1->(DbSeek( FWxFilial("SA1") + cCod + cLoja ))
                U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "Cliente (SA1) nao localizado " + cCod + cLoja, ComputerName(), LogUserName())
                RestArea(aArea)
                Return Nil

            EndIf

            cGranja   := Alltrim(cValToChar(SA1->A1_NOME))
            cTelefone := "55" + Alltrim(cValToChar(SA1->A1_XTELCON))

        Else

            DbSelectArea("SA2")
            SA2->(DbSetOrder(1))
            SA2->(DbGoTop())

            If ! SA2->(DbSeek( FWxFilial("SA2") + cCod + cLoja ))
                U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "Fornecedor (SA2) nao localizado " + cCod + cLoja, ComputerName(), LogUserName())
                RestArea(aArea)
                Return Nil

            EndIf

            cGranja   := Alltrim(cValToChar(SA2->A2_NREDUZ))
            cTelefone := Alltrim(cValToChar(SA2->A2_XWHATS)) 

        EndIf

        If Empty(cTelefone) 
            // cTelefone := "5516997976498"
            cTelefone := Alltrim(cValToChar(GetMV("MV_#VEN644",,"5512991560289")))

        EndIf

        cTexto := "Registro de Devolucao total de Nota Fiscal" + "%0A"
        cTexto += "Granja: "                   + cGranja + "%0A"
        cTexto += "Produto: "                  + Alltrim(cValToChar(SB1->B1_DESC)) +" - "+ Alltrim(cValToChar(Transform(ZHR->ZHR_QTDORI, "@E 999,999,999")))+" (kg)" + "%0A"
        cTexto += "Nota Fiscal de Origem: "    + cNF + " " + cSerie + "%0A"
        cTexto += "Nota Fiscal de Devolucao: " + Alltrim(cValToChar(SF1->F1_DOC)) + " " + SF1->F1_SERIE + "%0A"
        cTexto += "Data/Hora da Devolucao: "   + DToC(SF1->F1_EMISSAO) + " " + SF1->F1_HORA + "%0A"

    Else

        DbSelectArea("SF2")
        SF2->(DbSetOrder(1))
        SF2->(DbGoTop())
        If ! SF2->(DbSeek( FWxFilial("SF2") + cNF + cSerie + cCod + cLoja ))
            U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "NF nao localizada " + cNF + cSerie, ComputerName(), LogUserName())
            RestArea(aArea)
            Return Nil

        EndIf

        DbSelectArea("SD2")
        SD2->(DbSetOrder(3))
        SD2->(DbGoTop())
        If ! SD2->(DbSeek( FWxFilial("SD2") + cNF + cSerie + cCod + cLoja ))
            U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "Item NF nao localizada " + cNF + cSerie, ComputerName(), LogUserName())
            RestArea(aArea)
            Return Nil

        EndIf

        DbSelectArea("SC5")
        SC5->(DbSetOrder(1))
        SC5->(DbGoTop())
        If ! SC5->(DbSeek( FWxFilial("SC5") + SD2->D2_PEDIDO ))
            U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "Pedido de venda nao localizado " + SD2->D2_PEDIDO, ComputerName(), LogUserName())
            RestArea(aArea)
            Return Nil

        EndIf

        //Jonathan Carvalho 20/04/2023
        If Alltrim(SC5->C5_PEDSAG) == 'INTPROT' .And. Alltrim(SC5->C5_TABEGEN) == 'PO16MVES'
            RestArea(aArea)
            Return Nil

        EndIf

        //Jonathan Carvalho 26/01/2023
        If SC5->C5_TIPO == "B"

            DbSelectArea("SA2")
            SA2->(DbSetOrder(1))
            SA2->(DbGoTop())

            If ! SA2->(DbSeek( FWxFilial("SA2") + cCod + cLoja ))
                U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "Fornecedor (SA2) nao localizado " + cCod + cLoja, ComputerName(), LogUserName())
                RestArea(aArea)
                Return Nil

            EndIf

            cTelefone := Alltrim(cValToChar(SA2->A2_XWHATS)) 

        EndIf
        
        //Ticket 83060 Inclusão do Fone para filial HH
        If cCod == '247011' .And. cLoja == '00'  
            //Ticket 83060 - 24/03/2023
            DbSelectArea("SA1")
            SA1->(DbSetOrder(1))
            SA1->(DbGoTop())

            If ! SA1->(DbSeek( FWxFilial("SA1") + cCod + cLoja ))
                U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "Cliente (SA1) nao localizado " + cCod + cLoja, ComputerName(), LogUserName())
                RestArea(aArea)
                Return Nil

            EndIf

            cTelefone := "55" + Alltrim(cValToChar(SA1->A1_XTELCON))

        EndIf

        If Empty(cTelefone) 
            // cTelefone := "5516997976498"
            cTelefone := Alltrim(cValToChar(GetMV("MV_#VEN644",,"5512991560289")))

        EndIf

        If ! U_ADFAT16A(SC5->C5_XORDPES)
            U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "Ordem de pesagem nao localizada " + SC5->C5_XORDPES, ComputerName(), LogUserName())
            RestArea(aArea)
            Return Nil

        EndIf

        If ! U_ADFAT196(ZIF->ZIF_NUMERO)
            U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "Ticket de pesagem vinculado a ordem de pesagem " + ZIF->ZIF_NUMERO + " não localizado", ComputerName(), LogUserName())
            RestArea(aArea)
            Return Nil

        EndIf

        /*
        //Tkt 83060 - 28/04/2023 - Tratamento para não mandar Refaturamento
        DbSelectArea("ZHR")
        ZHR->(DbSetOrder(5))
        ZHR->(DbGoTop())
        If ZHR->( DbSeek( FWxFilial("ZHR") + ZIF->ZIF_ORDRAC ) )
            cDevolu := .T.
            //RestArea(aArea)
            //Return Nil

        EndIf
        */

        If ZIF->ZIF_TPMOVI <> "R"
            U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "Tipo de movimento de ordem de pesagem diferente de racao - " + ZIF->ZIF_TPMOVI, ComputerName(), LogUserName())
            RestArea(aArea)
            Return Nil

        EndIf

        If ! U_ADFAT20B(ZIF->ZIF_PRDSAG)
            U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "Produto SAG nao localizado" + ZIF->ZIF_PRDSAG + " nao localizado", ComputerName(), LogUserName())
            RestArea(aArea)
            Return Nil

        EndIf

        DbSelectArea("ZV4")
        ZV4->(DbSetOrder(1))
        If ZV4->(DbSeek(FwxFilial("ZV4") + Alltrim(ZIG->ZIG_PLACA)))

            If ! Empty(ZV4->ZV4_CPF)
                DbselectArea("ZVC")
                ZVC->(DbSetOrder(1))
                If ZVC->(DbSeek(FwxFilial("ZVC") + ZV4->ZV4_CPF))

                    If Empty(Alltrim(cValToChar(ZVC->ZVC_TELPRI)))
                        cContMot := Alltrim(cValToChar(ZVC->ZVC_MOTORI)) + "%0A" +"  Contato: 01621063500"

                    Else 
                        cContMot := Alltrim(cValToChar(ZVC->ZVC_MOTORI)) + "%0A" +"  Contato: " + Alltrim(cValToChar(ZVC->ZVC_TELPRI))
                        cTeleMot := "55" + Alltrim(cValToChar(ZVC->ZVC_TELPRI)) //Tratamento para mandar para os motoristas
                    
                    EndIf
                    
                EndIf

            EndIf

        EndIf

        //Tkt 83060 - Jonathan Carvalho 03/04/2023
        DbSelectArea("ZIR")
        ZIR->(DbSetOrder(1))
        ZIR->(DbGoTop())
        If ! ZIR->(DbSeek( FWxFilial("ZIR") + alltrim(ZIF->ZIF_ORDRAC) ))
            U_GrLogZBE(Date(), Time(), cUserName, "ERRO - ENVIO DE MENSAGEM PARA O WHATSAPP", "FATURAMENTO", "ADFAT640", "Granja nao localizada", ComputerName(), LogUserName())
            RestArea(aArea)
            Return Nil

        EndIf

    
        cTexto := "Granja: "                   + Alltrim(cValToChar(ZIR->ZIR_INTCOD)) + "%0A"
        cTexto += "Ordem de Carregamento: "    + Alltrim(cValToChar(Val(ZIF->ZIF_ORDRAC))) + "%0A"
        //cTexto += "Qtd. Ordem Carregamento: "  + Alltrim(cValToChar(Transform(ZIF->ZIF_QUANT, "@E 999,999,999")))  + "%0A"
        //cTexto += "Total Carregado (Kg): "           + Alltrim(cValToChar(Transform(ZIG->ZIG_PESOLI, "@E 999,999,999"))) + "%0A"
        cTexto += "Fase: "                     + Alltrim(cValToChar(ZIM->ZIM_SGPSAG)) +" - "+ Alltrim(cValToChar(Transform(ZIG->ZIG_PESOLI, "@E 999,999,999")))+" (kg)" + "%0A"
        cTexto += "Placa: "                    + Alltrim(cValToChar(ZIG->ZIG_PLACA))  + "%0A"
        cTexto += "Motorista: "                + Alltrim(cValToChar(cContMot)) + "%0A"
        cTexto += "Nota Fiscal: "              + Alltrim(cValToChar(SD2->D2_DOC)) + " " + SD2->D2_SERIE + "%0A"
        cTexto += "Data/Hora de Faturamento: " + DToC(SF2->F2_EMISSAO) + " " + SF2->F2_HORA + "%0A"  

    EndIf  
    
    cTexto := Escape(cTexto)

    U_ADFAT641(cTexto, cTelefone)

    /*
    DbSelectArea("ZF3")
    ZF3->(DbSetOrder(1))
    ZF3->(DbGoTop())
    ZF3->(DbSeek( FWxFilial("ZF3") + cCod + cLoja ))
       
    Inclusão da Localização GoogleMap
    cLocaliz := REPLACE(Alltrim(cValToChar(SA2->A2_END)),",","")
    cLocaliz += " " + Alltrim(cValToChar(SA2->A2_NR_END))
    cLocaliz += " " + Alltrim(cValToChar(SA2->A2_BAIRRO))
    cLocaliz += " " + Alltrim(cValToChar(SA2->A2_MUN))
    cLocaliz += REPLACE(cLocaliz, " ", "+")
    cLocaliz += "/@" + Alltrim(CValToChar(ZF3->ZF3_LATITU)) //Jonathan 01/02/2023
    cLocaliz += "," + Alltrim(cValToChar(ZF3->ZF3_LONGIT))
    */

    c2Texto := "Granja: "         + Alltrim(cValToChar(ZIR->ZIR_INTCOD)) + "%0A"

    //Ticket 83060 - Jonathan Carvalho - 11/04/2023
    If cCod == '247011' .And. cLoja == '00' 

        c2Texto += "Granjeiro: "      + Alltrim(cValToChar(SA1->A1_NOME)) + "%0A"
        //c2Texto += "Endereco: "       + Alltrim(cValToChar(SA1->A1_END)) + "," 
        //c2Texto += " - Bairro: "      + Alltrim(cValToChar(SA1->A1_BAIRRO)) + "%0A"
        //c2Texto += "Municipio: "      + Alltrim(cValToChar(SA1->A1_MUN))  + "%0A"
        c2Texto += "Telefone: "       + Alltrim(cValToChar(SA1->A1_TEL)) + "%0A"
        c2Texto += "WhatsApp: "       + Alltrim(cValToChar(SA1->A1_XTELCON)) + "%0A"

    Else
    
        c2Texto += "Granjeiro: "      + Alltrim(cValToChar(SA2->A2_NOME)) + "%0A"
        //c2Texto += "Endereco: "       + Alltrim(cValToChar(SA2->A2_END)) + "," + Alltrim(cValToChar(SA2->A2_NR_END))
        //c2Texto += " - Bairro: "      + Alltrim(cValToChar(SA2->A2_BAIRRO)) + "%0A"
        //c2Texto += "Cep: "            + Alltrim(cValToChar(SA2->A2_CEP)) + "%0A"
        //c2Texto += "Municipio: "      + Alltrim(cValToChar(SA2->A2_MUN))  + "%0A"
        //c2Texto += "Localizacao: "    + "https://www.google.com/maps/place/" + cLocaliz + "%0A"
        c2Texto += "Telefone: "       + Alltrim(cValToChar(SA2->A2_DDD)) + " " + SA2->A2_TEL + "%0A"
        c2Texto += "WhatsApp: "       + Alltrim(cValToChar(SA2->A2_XWHATS)) + "%0A"
    
    EndIf
    
    //Everson - 27/03/2023 - ticket 83060.
    //Everson - 20/03/2023 - ticket 83060. 
    cSigUrl := "https://mapa-granjas.s3.us-east-2.amazonaws.com/" + Alltrim(cValToChar(ZIR->ZIR_INTCOD)) + ".pdf" //U_ADFAT648(Alltrim(cValToChar(SA2->A2_NREDUZ)))
   
    c2Texto += "Mapa "+ cSigUrl
    
    c2Texto := Escape(c2Texto)

    //Caso seja os motoristas selecionados
    If !Empty(cTeleMot)
        
        U_ADFAT641(c2Texto, cTeleMot)
    
    EndIf  

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADFAT640
    Envio de mensagem de faturamento para os Tecnicos Relatorio de envio
    @type  Function
    @author Jonathan
    @since 08/04/2023
    @version 01
/*/

User Function ADFAT64C()

    //Variáveis.
    Local aArea     := GetArea()
    Local cTexto    := ""
    Local cQuery    := ""
    Local cTel      := ""
    Local cData     := ""
    //Local cAlia2    := GetNextAlias()
    Local cTelOld   := ""
    Local cLote     := ""
    Local cFase     := ""
    Local cPeso     := ""
    
    cTopico  := "text_whats_protheus_relatorio"

    cQuery += " SELECT " 
        cQuery += " Lote, "
        cQuery += " Fase, "
        cQuery += " Peso, "
        cQuery += " Celular, "
        cQuery += " CONVERT(DATE, Data_Pesagem) AS Data_Pesagem"
    cQuery += " FROM "
	cQuery += " SCSRV03.ADORO.dbo.R_TECN_CHATGURU "
    cQuery += " WHERE  " 
        cQuery += " Data_Pesagem = CONVERT(DATE, GETDATE()-1) " 
    cQuery += " ORDER BY Celular "

    /*
    cQuery += " SELECT " 
        cQuery += " SF2.F2_DOC AS Nota, "
        cQuery += " SF2.F2_SERIE AS Serie, "
        cQuery += " SF2.F2_CLIENTE AS Cliente, "
        cQuery += " SF2.F2_LOJA AS Loja, "
        cQuery += " SA2.A2_XWHATS AS Telefone,"
        cQuery += " CONVERT(VARCHAR(10), getdate()-1,103) AS DataEnvio, "
        cQuery += " CASE WHEN CONVERT(TIME, GETDATE()) > '06:00:00' THEN 1 ELSE 0 END AS Hora, "
        cQuery += " (SELECT COUNT(*) FROM ZIQ010 WHERE ZIQ_TOPICO = 'text_whats_protheus_relatorio' AND ZIQ_DTGRV = CONVERT(DATE, GETDATE())) AS Processado "
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("SF2") + " (NOLOCK) AS SF2  " 
    cQuery += " INNER JOIN  " + RetSqlName("SA2") + " (NOLOCK) AS SA2 " 
    cQuery += " ON SA2.A2_COD = SF2.F2_CLIENTE AND SA2.A2_LOJA = SF2.F2_LOJA   " 
    cQuery += " INNER JOIN  " + RetSqlName("SC5") + " (NOLOCK) AS SC5 " 
    cQuery += " ON SC5.C5_CLIENTE = SF2.F2_CLIENTE AND SC5.C5_LOJACLI = SF2.F2_LOJA AND SC5.C5_FILIAL = SF2.F2_FILIAL AND SF2.F2_DOC = SC5.C5_NOTA    " 
    cQuery += " WHERE  " 
        cQuery += " SF2.F2_FILIAL = '" + FWxFilial("SF2") + "'  " 
        cQuery += " AND SA2.A2_XTIPO = 2 " 
        cQuery += " AND F2_EMISSAO = CONVERT(DATE, GETDATE()-1) " 
        cQuery += " AND C5_XORDPES <> '' " 
        cQuery += " AND SA2.A2_XWHATS  <> '' "
        cQuery += " AND SF2.D_E_L_E_T_ = '' "
        cQuery += " AND SC5.D_E_L_E_T_ = '' "
        cQuery += " AND SA2.D_E_L_E_T_ = '' "
    cQuery += " ORDER BY Telefone, Nota " 


    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlia2, .F., .T.)
    (cAlia2)->(DbGoTop())
    
    While !(cAlia2)->(Eof()) 

    
    */

    If Select("RELSAG") > 0
        RELSAG->(DbCloseArea())
        
    EndIf
    
    //
    TcQuery cQuery NEW Alias "RELSAG"

    //
    While RELSAG->(!Eof())   
    
        cLote  := Alltrim(cValToChar(RELSAG->Lote))
        cFase  := Alltrim(cValToChar(RELSAG->Fase))
        cPeso  := RELSAG->Peso
        cTel   := Alltrim(cValToChar(RELSAG->Celular))
        cData  := Alltrim(cValToChar(RELSAG->Data_Pesagem))

        //Limpando a variavel cTel
        cTel   := REPLACE(cTel, "(0","")
        cTel   := REPLACE(cTel, ")","")
        cTel   := REPLACE(cTel, "-","")
        cTel   := "55" + cTel
       
        If Empty(cTelOld)

            cTexto := "Racoes enviadas no dia " + cData + "%0A"   
            cTexto += "Granja                Fase       Peso(Kg)%0A"  
            cTexto += Alltrim(cValTochar(cLote))+"       "+Alltrim(cValToChar(cFase))+"      "+ Alltrim(cValToChar(Transform(cPeso, "@E 999,999,999")))+ "%0A"
        
        Elseif cTelOld == cTel

            //cTexto += "Granja: " + Alltrim(cValToChar(cLote))
            //cTexto += ", Fase: " + Alltrim(cValToChar(cFase)) +" - "+ Alltrim(cValToChar(Transform(cPeso, "@E 999,999,999")))+" (kg)" + "%0A"
            cTexto += Alltrim(cValTochar(cLote))+"       "+Alltrim(cValToChar(cFase))+"      "+ Alltrim(cValToChar(Transform(cPeso, "@E 999,999,999")))+ "%0A"

        Else

            cTexto := Escape(cTexto)
            U_ADFAT641(cTexto, cTelOld) 

            cTexto := "Racoes enviadas no dia " + cData + "%0A"   
            cTexto += "Granja                Fase       Peso(Kg)%0A"  
            cTexto += Alltrim(cValTochar(cLote))+"       "+Alltrim(cValToChar(cFase))+"      "+ Alltrim(cValToChar(Transform(cPeso, "@E 999,999,999")))+ "%0A"
            //cTexto := "Racoes enviadas no dia %0A"
            //cTexto += "Granja: " + Alltrim(cValToChar(cLote))
            //cTexto += ", Fase: " + Alltrim(cValToChar(cFase)) +" - "+ Alltrim(cValToChar(Transform(cPeso, "@E 999,999,999")))+" (kg)" + "%0A"

        EndIf
        
       
        cTelOld := cTel
        RELSAG->(DbSkip())

    Enddo

    If !Empty(cTexto)
        cTexto := Escape(cTexto)
        U_ADFAT641(cTexto, cTelOld) 
    EndIf

    //(cAlia2)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADFAT641
    Salva registro de faturamento na tabela ZIQ.
    @type  Function
    @author Everson
    @since 12/12/2022
    @version 01
/*/
User Function ADFAT641(cTexto, cTelefone)
    
    //Variáveis.
    Local aArea     := GetArea()
    Local oJson     := JsonObject():New()
    Local oJsonD    := JsonObject():New()
    Local cData     := DToS(Date())
    Local cHora     := Time()
    Local cId       := FWUUIDV1(.T.)
    Local cOperacao := "I"
    Local cDados    := ""

    U_ADFAT270(oJson, cData, cHora, cId, cTopico, cOperacao)

    oJsonD['texto']    := cTexto
    oJsonD['telefone'] := cTelefone

    oJson['dados'] := oJsonD

    cDados := oJson:toJson()

    FreeObj(oJson)
    FreeObj(oJsonD)

    lRet := U_ADFAT27B(cOperacao, cTopico, cId, cDados, cData, cHora, "W")

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADFAT644
    Cadastra contato no ChatGuru.
    @type  Function
    @author Everson
    @since 13/12/2022
    @version 01
/*/
User Function ADFAT644(cPhone, cNome, cMsg)

    //Variáveis.
	Local aArea 		:= GetArea()
	Local lRet			:= .T.
    Local cPostParams   := ""
    Local cErro         := ""
    Local cUrl          := Alltrim(cValToChar(GetMV("MV_#VEN640",,"https://s17.chatguru.app")))
    Local cKey          := Alltrim(cValToChar(GetMV("MV_#VEN641",,"0IU2JJ5ONN9USMZ61VPARBFMKTEEPLXCLCXUTE2YJC6S8GZ3112FDPLF45JG3Y9U")))
    Local cAccount      := Alltrim(cValToChar(GetMV("MV_#VEN642",,"638127f539f56a731664c748")))
    Local cPhoneId      := Alltrim(cValToChar(GetMV("MV_#VEN643",,"6381f2c13598c1bcd170286d")))
    Local cServico      := "/api/v1"
    Local cDialogId     := Alltrim(cValToChar(GetMV("MV_#VEN646",,"63812842bfbaa29b3fd4ad20")))
    Local cTexto        := Alltrim(cValToChar(GetMV("MV_#VEN648",,"Cadastro ChatGuru")))
	Local cBodyRq		:= ""
    Local aHeader	    := {}
    Local oJson         := Nil

    //Default cGranja     := "" Jonathan Carvalho 29/01/2023
	Default cMsg		:= ""

    Aadd(aHeader, "Content-Type: application/json")

    cTexto  := Escape(cTexto)

    cNome   := Escape(cNome)

    cPostParams := EncodeUTF8("key=" + cKey + "&account_id=" + cAccount + "&phone_id=" + cPhoneId + "&chat_number=" + cPhone + "&action=chat_add&dialog_id=" + cDialogId + "&name=" + cNome + "&text=" + cTexto)

    sPostRet := HttpPost(cUrl + cServico, cPostParams, cBodyRq, 120, aHeader, @cMsg)

    If ! ("HTTP/1.1 200 OK" $cMsg)

        cMsg += "URL: "        + cUrl + xPula
        cMsg += "Parâmetros: " + cPostParams + xPula
        cMsg += "EndPoint: "   + cServico + xPula
        cMsg += "Body: "       + xPula + cValToChar(cBodyRq) + xPula
        cMsg += "Resp: "       + xPula + cValToChar(sPostRet) + xPula
        cMsg += "Erro: "       + xPula + cValToChar(HTTPGetStatus(@cErro)) + " " + cValToChar(cErro) + xPula
        
        lRet := .F.

    Else

        oJson   := getJson(sPostRet)

        cChatId := Alltrim(cValToChar(oJson['chat_add_id']))

        //Verifica status do cadastro, envia código da granja e encerra o atendimento.
        cMsg := ""
        lRet := lRet .And. U_ADFAT645(cPhone, cChatId, @cMsg)
        //lRet := lRet .And. U_ADFAT646(cPhone, cGranja, @cMsg)
        lRet := lRet .And. U_ADFAT643(cPhone, @cMsg)

	EndIf

	RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADFAT645
    Checa status de cadastro no ChatGuru.
    @type  Function
    @author Everson
    @since 13/12/2022
    @version 01
/*/
User Function ADFAT645(cPhone, cChatId, cMsg)

    //Variáveis.
    Local aArea         := GetArea()
    Local lRet          := .F.
    Local cBodyRq       := ""
    Local aHeader       := {}
    Local cPostParams   := ""
    Local cStatus       := "fetched"
    Local oJson         := Nil
    Local cUrl          := Alltrim(cValToChar(GetMV("MV_#VEN640",,"https://s17.chatguru.app")))
    Local cKey          := Alltrim(cValToChar(GetMV("MV_#VEN641",,"0IU2JJ5ONN9USMZ61VPARBFMKTEEPLXCLCXUTE2YJC6S8GZ3112FDPLF45JG3Y9U")))
    Local cAccount      := Alltrim(cValToChar(GetMV("MV_#VEN642",,"638127f539f56a731664c748")))
    Local cPhoneId      := Alltrim(cValToChar(GetMV("MV_#VEN643",,"6381f2c13598c1bcd170286d")))
    Local cServico      := "/api/v1"

    Aadd(aHeader, "Content-Type: application/json")

    cPostParams := EncodeUTF8("key=" + cKey + "&account_id=" + cAccount + "&phone_id=" + cPhoneId + "&action=chat_add_status&chat_add_id=" + cChatId)

    While cStatus $"fetched/pending"

        sPostRet := HttpPost(cUrl + cServico, cPostParams, cBodyRq, 120, aHeader, @cMsg)

        If ! ("HTTP/1.1 200 OK" $cMsg)

            cStatus := "Erro"

            cMsg += "URL: "        + cUrl + xPula
            cMsg += "Parâmetros: " + cPostParams + xPula
            cMsg += "EndPoint: "   + cServico + xPula
            cMsg += "Body: "       + xPula + cValToChar(cBodyRq) + xPula
            cMsg += "Resp: "       + xPula + cValToChar(sPostRet) + xPula
            cMsg += "Erro: "       + xPula + cValToChar(HTTPGetStatus(@cErro)) + " " + cValToChar(cErro) + xPula

        Else

            oJson := getJson(sPostRet)

            cStatus := Alltrim(cValToChar(oJson['chat_add_status']))

            If cStatus == "done"
                lRet := .T.
                Exit

            EndIf

        EndIf

    End

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADFAT646
    Cadastra código da granja.
    @type  Function
    @author Everson
    @since 13/12/2022
    @version 01
/*/
/*/User Function ADFAT646(cPhone, cGranja, cMsg)

    //Variáveis.
    Local aArea         := GetArea()
    Local cBodyRq       := ""
    Local lRet          := .T.
    Local aHeader       := {}
    Local cPostParams   := ""
    Local cUrl          := Alltrim(cValToChar(GetMV("MV_#VEN640",,"https://s17.chatguru.app")))
    Local cKey          := Alltrim(cValToChar(GetMV("MV_#VEN641",,"0IU2JJ5ONN9USMZ61VPARBFMKTEEPLXCLCXUTE2YJC6S8GZ3112FDPLF45JG3Y9U")))
    Local cAccount      := Alltrim(cValToChar(GetMV("MV_#VEN642",,"638127f539f56a731664c748")))
    Local cPhoneId      := Alltrim(cValToChar(GetMV("MV_#VEN643",,"6381f2c13598c1bcd170286d")))
    Local cServico      := "/api/v1"

    Default cMsg        := ""

    Aadd(aHeader, "Content-Type: application/json")

    cPostParams := EncodeUTF8("key=" + cKey + "&account_id=" + cAccount + "&phone_id=" + cPhoneId + "&action=chat_update_custom_fields&chat_number=" + cPhone + "&field__Granja=" + cGranja)

    sPostRet := HttpPost(cUrl + cServico, cPostParams, cBodyRq, 120, aHeader, @cMsg)

    If ! ("HTTP/1.1 200 OK" $cMsg)

        lRet := .F.

        cMsg += "URL: "        + cUrl + xPula
        cMsg += "Parâmetros: " + cPostParams + xPula
        cMsg += "EndPoint: "   + cServico + xPula
        cMsg += "Body: "       + xPula + cValToChar(cBodyRq) + xPula
        cMsg += "Resp: "       + xPula + cValToChar(sPostRet) + xPula
        cMsg += "Erro: "       + xPula + cValToChar(HTTPGetStatus(@cErro)) + " " + cValToChar(cErro) + xPula

    EndIf

    RestArea(aArea)

Return lRet
/*/
/*/{Protheus.doc} User Function ADFAT64B
    Processa Job para envio de cadastros.
    @type  Function
    @author Everson
    @since 13/12/2022
    @version 01
/*/
User Function ADFAT64B()

    //Variáveis.
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local cMsgError := ""
    Local oJson     := Nil
    Local cJson     := ""
    Local lRetEnv   := .F.
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
        cQuery += " AND ZIQ_TOPICO = 'cadastro_chatguru_protheus' " 
        cQuery += " AND ZIQ_SISGER = 'PROTHEUS' " 
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
            cMsgError := "Nao foi possível converter a string para objeto json. " + cId
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Funcao ADFAT64B(ADFAT064P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAlias)->(DbSkip())
            Loop

        EndIf

        If ValType(oJson['dados']) == "U"
            cMsgError := "Objeto json não possui a chave dados " + cId
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Funcao ADFAT64B(ADFAT064P)", Nil, "Erro no processamento ChatGuru " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            (cAlias)->(DbSkip())
            Loop

        EndIf

        cPhone  := Alltrim(cValToChar(oJson['dados']['telefone']))
        cNome   := Alltrim(cValToChar(oJson['dados']['nome']))
        //cGranja := Alltrim(cValToChar(oJson['dados']['granja'])) Jonathan Carvalho 29/01/2023

        FreeObj(oJson)
        oJson := Nil

        //lRetEnv := U_ADFAT644(cPhone, cNome, cGranja, @cMsgError)
        lRetEnv := U_ADFAT644(cPhone, cNome, @cMsgError)

        If ! lRetEnv
            U_ADFAT29D(cId, "2", cMsgError)
            Help(Nil, Nil, "Funcao ADFAT64B(ADFAT064P)", Nil, "Erro no processamento ChatGuru x Protheus " + cId + "." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        Else
            U_ADFAT29D(cId, "1", "")

        EndIf

        (cAlias)->(DbSkip())
  
    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADFAT647
    Salva registro de cadastro de granja na tabela ZIQ.
    @type  Function
    @author Everson
    @since 13/12/2022
    @version 01
/*/
User Function ADFAT647(cTelefone, cNome)
    
    //Variáveis.
    Local aArea     := GetArea()
    Local oJson     := JsonObject():New()
    Local oJsonD    := JsonObject():New()
    Local cData     := DToS(Date())
    Local cHora     := Time()
    Local cId       := FWUUIDV1(.T.)
    Local cTopico   := "cadastro_chatguru_protheus"
    Local cOperacao := "I"
    Local cDados    := ""

    U_ADFAT270(oJson, cData, cHora, cId, cTopico, cOperacao)

    oJsonD['telefone'] := cTelefone
    oJsonD['nome']     := cNome
    //oJsonD['granja']   := cGranja Jonathan Carvalho 29/01/2023

    oJson['dados'] := oJsonD

    cDados := oJson:toJson()

    FreeObj(oJson)
    FreeObj(oJsonD)

    lRet := U_ADFAT27B(cOperacao, cTopico, cId, cDados, cData, cHora, "W")

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADFAT648
    Retorna a url assinada.
    @type  Function
    @author Everson
    @since 16/03/2023
    @version 01
/*/
User Function ADFAT648(cGranja)

    //Variáveis.
    Local aArea         := GetArea()
    Local oRestClient   := Nil
    Local oObjJ         := Nil
    Local xRet          := Nil
    Local cSigUrl       := ""
    Local cChave        := Alltrim(cValToChar(GetMv("MV_#VEN647",, "4wV4QLUNjW8xGBIWVr1Hf78HPVCUsCKN9mDSpgzQ")))
    Local cHoras        := Alltrim(cValToChar(GetMv("MV_#VEN649",, "1")))
    Local cUrl          := Alltrim(cValToChar(GetMv("MV_#VEN64B",, "https://4j1y0pc2t8.execute-api.us-east-2.amazonaws.com/prod/mapas-granja?file=" + cGranja + ".pdf&hours=" + cHoras)))
    Local aHeader       := {}

    Aadd(aHeader, "Content-Type: application/json")
    Aadd(aHeader, "x-api-key: " + cChave)

    oRestClient := FWRest():New(cUrl)
    oRestClient:SetPath("")

    If ! oRestClient:Get(aHeader)
        RestArea(aArea)
        Return ""

    Endif

    cJson := oRestClient:GetResult()

    oObjJ := JsonObject():New()
    xRet := oObjJ:FromJson(cJson)
    If ! ValType(xRet) == "U"
        RestArea(aArea)
        Return ""

    EndIf

    cSigUrl := oObjJ['body']

    FreeObj(oObjJ)

    RestArea(aArea)

Return cSigUrl
