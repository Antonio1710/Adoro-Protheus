#include "protheus.ch"

#define MSG_MAX 12
#define MSG_INFORMATION 0
#define MSG_WARNING 1
#define MSG_ERROR 2

User Function JobTest() // U_JobTest()

    RPCClearEnv()
	RPCSetType(3)
	RpcSetEnv("01","02",,,,GetEnvServer(),{ })

		U_ADV1180B('9BTATB', 'ABC1234')

		// &("STATICCALL(M460FIM, blqPedMVC, '9BTATB', '000001', '01 ')")


		// lret := startjob("u_inijob",getenvserver(),.T.)


		// U_ADFAT17M()

		// aRetPed := StartJob("U_ADFAT17M",getenvserver(),.T.,"01", "03")


		// nValor := &("STATICCALL(ADVEN118P, obtFrete, 'SP', '50308')")

		// conout(nValor)

		// nValor := &("STATICCALL(ADVEN118P, obtDesc,'000050', '00', '128270 ')")

		// conout(nValor)

		// nValor := &("STATICCALL(ADVEN118P, obtVlrIp,'100024   ')")

		// conout(nValor)

		// nValor := &("STATICCALL(ADVEN118P, obtPrcMax,'100024   ')")

		// conout(nValor)

		// dData = Date() + 1

		// dData++

		// conout(dData)

		X31UpdTable("ZJA")

		CHKFILE("ZJA")

		DBSELECTAREA("ZJA")

		// X31UpdTable("ZJB")

		// CHKFILE("ZJB")

		// DBSELECTAREA("ZJB")

		// X31UpdTable("ZJB")

		// CHKFILE("ZJB")

		// DBSELECTAREA("ZJB")

	RpcClearEnv()

		// X31UpdTable("ZJC")

		// CHKFILE("ZJC")

		// DBSELECTAREA("ZJC")

		// // Local cMsg := ""
		// Local nAux := 1

		// For nAux := 1 To 5
		// 	U_ADFAT647("5512991560289", "EVERSON", "FFFFFF")

		// nEXT N

		// U_ADFAT064P()

		// U_ADFAT646("5512991560289", "AAAAAA", @cMsg)

		// U_ADFAT644("5512991560289", "EVERSON", @cMsg)

		// U_ADFAT651("F1432")

		// Local cMsgError := ""

		// cJson := '{'
		// cJson += '  "campanha_id": "status_programacao_chatguru ",'
		// cJson += '  "campanha_nome": "",'
		// cJson += '  "origem": "status_programacao_chatguru ",'
		// cJson += '  "email": "5516997976498@c.us",'
		// cJson += '  "nome": "Jonathan",'
		// cJson += '  "tags": [],'
		// cJson += '  "texto_mensagem": "2",'
		// cJson += '  "campos_personalizados": {'
		// cJson += '    "Granja": "A1319",'
		// cJson += '    "Horario_de_Atendimento": "18:00"'
		// cJson += '  },'
		// cJson += '  "bot_context": {'
		// cJson += '    "Timer": false,'
		// cJson += '    "URA": "2"'
		// cJson += '  },'
		// cJson += '  "responsavel_nome": "",'
		// cJson += '  "responsavel_email": "",'
		// cJson += '  "link_chat": "https://s17.chatguru.app/chats#638bb801a10512f91b366b11",'
		// cJson += '  "celular": "5516997976498",'
		// cJson += '  "phone_id": "6381f2c13598c1bcd170286d",'
		// cJson += '  "chat_id": "638bb801a10512f91b366b11",'
		// cJson += '  "chat_created": "2022-12-03 20:56:33.140000",'
		// cJson += '  "datetime_post": "2022-12-12 18:01:31.481953"'
		// cJson += '}'


		// U_ADFAT650(cJson, @cMsgError)

		// U_ADFAT065P()

		// U_ADFAT640("000876313", "01 ", "030060", "01")

		// U_ADFAT064P()

	// Local cUrl      := Alltrim(cValToChar(GetMV("MV_#VEN640",,"https://s17.chatguru.app"))) + "/api/v1"
	// Local cServico  := ""
    // Local cMetodo   := "Post"
    // Local cKey      := Alltrim(cValToChar(GetMV("MV_#VEN641",,"0IU2JJ5ONN9USMZ61VPARBFMKTEEPLXCLCXUTE2YJC6S8GZ3112FDPLF45JG3Y9U")))
    // Local cAccount  := Alltrim(cValToChar(GetMV("MV_#VEN642",,"638127f539f56a731664c748 ")))
    // Local cPhoneId  := Alltrim(cValToChar(GetMV("MV_#VEN643",,"6381f2c13598c1bcd170286d ")))
	// Local cBodyRq	:= ""
	// Local cTexto    := "Teste TI"
	// Local cPhone	:= "5512991560289"
	// Local cMsg		:= ""

	// U_ADFAT642(cUrl, cServico, cMetodo, cKey, cAccount, cPhoneId, cBodyRq, cTexto, cPhone, cMsg)

	// U_ADFAT640("123456789", "01 ")

	// U_ADFAT064P()

	// U_ADMNT151("010711", SToD( Year2Str(Date()) + Month2Str(Date()) + "01" ), Date())

	// U_ADVEN070P()

	// lret := CHKFILE("ZIO", .T.)

	// X31UpdTable("ZIO")

	// CHKFILE("ZIO")

	// DBSELECTAREA("ZIO")

	// cRet := U_ADMNT15A("01", "02", "serviceOrders", "015746", "")

	// cNumPed := "10702"
	// cFilPed := "01"

	// cUpdt := " UPDATE " + RetSqlName("ZFK") + " SET ZFK_PEDCOM = '' WHERE ZFK_FILIAL = '" + cFilPed + "' AND ZFK_PEDCOM = '" + cNumPed + "' AND D_E_L_E_T_ = '' "
	// TCSqlExec(cUpdt)
		
	// cUpdt := " UPDATE " + RetSqlName("ZFA") + " SET ZFA_PEDADT = '' WHERE ZFA_FILIAL = '" + cFilPed + "' AND ZFA_PEDADT = '" + cNumPed + "' AND D_E_L_E_T_ = '' "
	// TCSqlExec(cUpdt)

	// cJson := ' {
	// cJson += ' "return": {
	// cJson += ' "current_page": 1,
	// cJson += ' "data": [{
	// cJson += ' "RequisicaoNumero": 13085,
	// cJson += ' "Uuid": "dfe46cd0-a108-4018-91e7-ae0aec841bb3",
	// cJson += ' "Status": "Finalizado",
	// cJson += ' "CriadaEm": "2022-11-25 10:46:10",
	// cJson += ' "EntregueEm": "2022-11-25 10:46:10",
	// cJson += ' "CentroCustoCodigo": "MX01",
	// cJson += ' "CentroCustoNome": "centro de custo Primordial",
	// cJson += ' "CentroCustoResponsavel": null,
	// cJson += ' "CentroCustoUnidadeId": 1,
	// cJson += ' "CentroCustoUnidade": "Unidade 1",
	// cJson += ' "SolicitanteId": 387,
	// cJson += ' "SolicitanteNome": "FKennedy Martinez",
	// cJson += ' "SolicitanteSap": "8080",
	// cJson += ' "SolicitanteEmail": "kennedymartinez@outlook.com.br.d",
	// cJson += ' "SolicitanteFuncao": "Vendedor",
	// cJson += ' "SolicitanteCargo": null,
	// cJson += ' "SolicitanteDataAdmissao": "2001-01-02 04:06:46",
	// cJson += ' "SolicitanteDataDesligamento": null,
	// cJson += ' "CriacaoNome": "tablet 02",
	// cJson += ' "CriacaoSap": "tablet_02",
	// cJson += ' "CriacaoEmail": "tablet_02@multpex.com.br",
	// cJson += ' "CriacaoAutenticacaoTipo": "token",
	// cJson += ' "CriacaoData": "2022-11-25 10:46:10",
	// cJson += ' "AprovacaoNome": "sistema",
	// cJson += ' "AprovacaoSap": "sistema",
	// cJson += ' "AprovacaoEmail": "sistema@multpex.com.br",
	// cJson += ' "AprovacaoAutenticacaoTipo": "token",
	// cJson += ' "AprovacaoData": "2022-11-25 10:46:10",
	// cJson += ' "FinalizacaoNome": "tablet 02",
	// cJson += ' "FinalizacaoSap": "tablet_02",
	// cJson += ' "FinalizacaoEmail": "tablet_02@multpex.com.br",
	// cJson += ' "FinalizacaoAutenticacaoTipo": "token",
	// cJson += ' "FinalizacaoData": "2022-11-25 10:46:10",
	// cJson += ' "RetiradoPorNome": "FKennedy Martinez",
	// cJson += ' "RetiradoPorSap": "8080",
	// cJson += ' "RetiradoPorEmail": "kennedymartinez@outlook.com.br.d",
	// cJson += ' "RetiradoPorAutenticacaoTipo": "token",
	// cJson += ' "RetiradoPorData": "2022-11-25 10:46:10",
	// cJson += ' "RequisicaoNome": "FKennedy Martinez",
	// cJson += ' "RequisicaoSap": "8080",
	// cJson += ' "RequisicaoEmail": "kennedymartinez@outlook.com.br.d",
	// cJson += ' "RequisicaoAutenticacaoTipo": "token",
	// cJson += ' "RequisicaoData": "2022-11-25 10:46:10",
	// cJson += ' "EntregaUnidadeId": 1,
	// cJson += ' "EntregaUnidadeNome": "Unidade 1",
	// cJson += ' "ItemId": 24,
	// cJson += ' "ItemCodigo": "0002",
	// cJson += ' "ItemNome": "Luva de Latex Amarela Tam. 7 NOME",
	// cJson += ' "ItemQuantidade": "1,0000",
	// cJson += ' "ItemNomeContrato": "Luva de Latex Amarela Tam. 7 Wellington",
	// cJson += ' "ItemCategoriaCodigo": "W",
	// cJson += ' "ItemCategoriaDescricao": null,
	// cJson += ' "ItemGrupoId": 2,
	// cJson += ' "ItemGrupoNome": "CALÇADO DE SEGURANÇA BICO COMPOSITE",
	// cJson += ' "ItemGrupoDescricao": "CALÇADO DE SEGURANÇA BICO COMPOSITE",
	// cJson += ' "ItemPreco": "2,2103",
	// cJson += ' "ItemIcms": "0,1800",
	// cJson += ' "ItemPis": "0,0300",
	// cJson += ' "ItemCofins": "10,0000",
	// cJson += ' "ItemCfop": null,
	// cJson += ' "ItemPartNumber": null,
	// cJson += ' "ItemFabricante": null,
	// cJson += ' "ItemCaCodigo": "1001",
	// cJson += ' "ItemCaValidade": "2022-12-31 10:42:04",
	// cJson += ' "ItemEpi": 1,
	// cJson += ' "ItemCondicaoRetirada": "na_regra_acima_prazo_max",
	// cJson += ' "ItemRegraDescricao": "regra função Vendedor",
	// cJson += ' "ItemRegraPrazoMinimo": 1,
	// cJson += ' "ItemRegraPrazoMaximo": 1,
	// cJson += ' "ItemRegraQuantidadeMaxima": "90,0000",
	// cJson += ' "ItemRegraDataMinima": null,
	// cJson += ' "ItemRegraDataMaxima": null,
	// cJson += ' "IntegracaoEnviado": 0,
	// cJson += ' "IntegracaoDataEnvio": null,
	// cJson += ' "IntegracaoNumeroErros": null,
	// cJson += ' "IntegracaoMessagem": null,
	// cJson += ' "slot": null,
	// cJson += ' "OsUuid": null,
	// cJson += ' "OsNumero": null,
	// cJson += ' "TotalItemVoucher": "2,2103",
	// cJson += ' "regiao": "ABC",
	// cJson += ' "EnderecoProduto": "M21",
	// cJson += ' "numero_SC": null
	// cJson += ' },
	// cJson += ' {
	// cJson += ' "RequisicaoNumero": 13082,
	// cJson += ' "Uuid": "fc54f0a2-65ba-4643-bcf7-d2573c4483a0",
	// cJson += ' "Status": "Finalizado",
	// cJson += ' "CriadaEm": "2022-11-24 15:17:15",
	// cJson += ' "EntregueEm": "2022-11-24 11:18:56",
	// cJson += ' "CentroCustoCodigo": "MX01",
	// cJson += ' "CentroCustoNome": "centro de custo Primordial",
	// cJson += ' "CentroCustoResponsavel": null,
	// cJson += ' "CentroCustoUnidadeId": 1,
	// cJson += ' "CentroCustoUnidade": "Unidade 1",
	// cJson += ' "SolicitanteId": 26,
	// cJson += ' "SolicitanteNome": "Kennedy Sobrenome",
	// cJson += ' "SolicitanteSap": "0808",
	// cJson += ' "SolicitanteEmail": "kennedy@multpex.com.br",
	// cJson += ' "SolicitanteFuncao": "TESTE EXCLUSÃO",
	// cJson += ' "SolicitanteCargo": "Jornalista",
	// cJson += ' "SolicitanteDataAdmissao": "2016-05-01 21:29:08",
	// cJson += ' "SolicitanteDataDesligamento": null,
	// cJson += ' "CriacaoNome": "tablet 02",
	// cJson += ' "CriacaoSap": "tablet_02",
	// cJson += ' "CriacaoEmail": "tablet_02@multpex.com.br",
	// cJson += ' "CriacaoAutenticacaoTipo": "token",
	// cJson += ' "CriacaoData": "2022-11-24 11:17:25",
	// cJson += ' "AprovacaoNome": "sistema",
	// cJson += ' "AprovacaoSap": "sistema",
	// cJson += ' "AprovacaoEmail": "sistema@multpex.com.br",
	// cJson += ' "AprovacaoAutenticacaoTipo": "token",
	// cJson += ' "AprovacaoData": "2022-11-24 15:17:15",
	// cJson += ' "FinalizacaoNome": "tablet 02",
	// cJson += ' "FinalizacaoSap": "tablet_02",
	// cJson += ' "FinalizacaoEmail": "tablet_02@multpex.com.br",
	// cJson += ' "FinalizacaoAutenticacaoTipo": "token",
	// cJson += ' "FinalizacaoData": "2022-11-24 11:18:56",
	// cJson += ' "RetiradoPorNome": "Kennedy Sobrenome",
	// cJson += ' "RetiradoPorSap": "0808",
	// cJson += ' "RetiradoPorEmail": "kennedy@multpex.com.br",
	// cJson += ' "RetiradoPorAutenticacaoTipo": "token",
	// cJson += ' "RetiradoPorData": "2022-11-24 11:18:56",
	// cJson += ' "RequisicaoNome": "Kennedy Sobrenome",
	// cJson += ' "RequisicaoSap": "0808",
	// cJson += ' "RequisicaoEmail": "kennedy@multpex.com.br",
	// cJson += ' "RequisicaoAutenticacaoTipo": "token",
	// cJson += ' "RequisicaoData": "2022-11-24 15:17:15",
	// cJson += ' "EntregaUnidadeId": 1,
	// cJson += ' "EntregaUnidadeNome": "Unidade 1",
	// cJson += ' "ItemId": 60,
	// cJson += ' "ItemCodigo": "1162035",
	// cJson += ' "ItemNome": "CALÇA JEANS UNIFORME OPERACIONAL TAM G",
	// cJson += ' "ItemQuantidade": "1,0000",
	// cJson += ' "ItemNomeContrato": "CALÇA JEANS UNIFORME OPERACIONAL TAM G",
	// cJson += ' "ItemCategoriaCodigo": null,
	// cJson += ' "ItemCategoriaDescricao": null,
	// cJson += ' "ItemGrupoId": 11,
	// cJson += ' "ItemGrupoNome": "CALÇA JEANS UNIFORME",
	// cJson += ' "ItemGrupoDescricao": "CALÇA JEANS UNIFORME",
	// cJson += ' "ItemPreco": "50,9155",
	// cJson += ' "ItemIcms": "0,1800",
	// cJson += ' "ItemPis": "0,0300",
	// cJson += ' "ItemCofins": "0,0100",
	// cJson += ' "ItemCfop": null,
	// cJson += ' "ItemPartNumber": null,
	// cJson += ' "ItemFabricante": null,
	// cJson += ' "ItemCaCodigo": "876543",
	// cJson += ' "ItemCaValidade": "2020-09-12 03:00:00",
	// cJson += ' "ItemEpi": 1,
	// cJson += ' "ItemCondicaoRetirada": "fora_regra",
	// cJson += ' "ItemRegraDescricao": null,
	// cJson += ' "ItemRegraPrazoMinimo": 170,
	// cJson += ' "ItemRegraPrazoMaximo": 180,
	// cJson += ' "ItemRegraQuantidadeMaxima": "1,0000",
	// cJson += ' "ItemRegraDataMinima": null,
	// cJson += ' "ItemRegraDataMaxima": null,
	// cJson += ' "IntegracaoEnviado": 0,
	// cJson += ' "IntegracaoDataEnvio": null,
	// cJson += ' "IntegracaoNumeroErros": null,
	// cJson += ' "IntegracaoMessagem": null,
	// cJson += ' "slot": null,
	// cJson += ' "OsUuid": null,
	// cJson += ' "OsNumero": null,
	// cJson += ' "TotalItemVoucher": "50,9155",
	// cJson += ' "regiao": "ABC",
	// cJson += ' "EnderecoProduto": null,
	// cJson += ' "numero_SC": null
	// cJson += ' },
	// cJson += ' {
	// cJson += ' "RequisicaoNumero": 13078,
	// cJson += ' "Uuid": "76c1c43e-5a56-4c43-9d95-ce2686cc12d7",
	// cJson += ' "Status": "Finalizado",
	// cJson += ' "CriadaEm": "2022-11-24 15:05:57",
	// cJson += ' "EntregueEm": "2022-11-24 11:07:19",
	// cJson += ' "CentroCustoCodigo": "MX01",
	// cJson += ' "CentroCustoNome": "centro de custo Primordial",
	// cJson += ' "CentroCustoResponsavel": null,
	// cJson += ' "CentroCustoUnidadeId": 1,
	// cJson += ' "CentroCustoUnidade": "Unidade 1",
	// cJson += ' "SolicitanteId": 26,
	// cJson += ' "SolicitanteNome": "Kennedy Sobrenome",
	// cJson += ' "SolicitanteSap": "0808",
	// cJson += ' "SolicitanteEmail": "kennedy@multpex.com.br",
	// cJson += ' "SolicitanteFuncao": "TESTE EXCLUSÃO",
	// cJson += ' "SolicitanteCargo": "Jornalista",
	// cJson += ' "SolicitanteDataAdmissao": "2016-05-01 21:29:08",
	// cJson += ' "SolicitanteDataDesligamento": null,
	// cJson += ' "CriacaoNome": "tablet 02",
	// cJson += ' "CriacaoSap": "tablet_02",
	// cJson += ' "CriacaoEmail": "tablet_02@multpex.com.br",
	// cJson += ' "CriacaoAutenticacaoTipo": "token",
	// cJson += ' "CriacaoData": "2022-11-24 11:06:09",
	// cJson += ' "AprovacaoNome": "sistema",
	// cJson += ' "AprovacaoSap": "sistema",
	// cJson += ' "AprovacaoEmail": "sistema@multpex.com.br",
	// cJson += ' "AprovacaoAutenticacaoTipo": "token",
	// cJson += ' "AprovacaoData": "2022-11-24 15:05:57",
	// cJson += ' "FinalizacaoNome": "tablet 02",
	// cJson += ' "FinalizacaoSap": "tablet_02",
	// cJson += ' "FinalizacaoEmail": "tablet_02@multpex.com.br",
	// cJson += ' "FinalizacaoAutenticacaoTipo": "token",
	// cJson += ' "FinalizacaoData": "2022-11-24 11:07:19",
	// cJson += ' "RetiradoPorNome": "Kennedy Sobrenome",
	// cJson += ' "RetiradoPorSap": "0808",
	// cJson += ' "RetiradoPorEmail": "kennedy@multpex.com.br",
	// cJson += ' "RetiradoPorAutenticacaoTipo": "token",
	// cJson += ' "RetiradoPorData": "2022-11-24 11:07:19",
	// cJson += ' "RequisicaoNome": "Kennedy Sobrenome",
	// cJson += ' "RequisicaoSap": "0808",
	// cJson += ' "RequisicaoEmail": "kennedy@multpex.com.br",
	// cJson += ' "RequisicaoAutenticacaoTipo": "token",
	// cJson += ' "RequisicaoData": "2022-11-24 15:05:57",
	// cJson += ' "EntregaUnidadeId": 1,
	// cJson += ' "EntregaUnidadeNome": "Unidade 1",
	// cJson += ' "ItemId": 227,
	// cJson += ' "ItemCodigo": "01020304",
	// cJson += ' "ItemNome": "AREIA",
	// cJson += ' "ItemQuantidade": "1,0000",
	// cJson += ' "ItemNomeContrato": "AREIA",
	// cJson += ' "ItemCategoriaCodigo": null,
	// cJson += ' "ItemCategoriaDescricao": null,
	// cJson += ' "ItemGrupoId": 10,
	// cJson += ' "ItemGrupoNome": "CAMISA BRANCA UNIFORME",
	// cJson += ' "ItemGrupoDescricao": "CAMISA BRANCA UNIFORME",
	// cJson += ' "ItemPreco": "1,0000",
	// cJson += ' "ItemIcms": "0,1800",
	// cJson += ' "ItemPis": "0,0300",
	// cJson += ' "ItemCofins": "0,0100",
	// cJson += ' "ItemCfop": null,
	// cJson += ' "ItemPartNumber": null,
	// cJson += ' "ItemFabricante": null,
	// cJson += ' "ItemCaCodigo": null,
	// cJson += ' "ItemCaValidade": null,
	// cJson += ' "ItemEpi": 0,
	// cJson += ' "ItemCondicaoRetirada": "fora_regra",
	// cJson += ' "ItemRegraDescricao": null,
	// cJson += ' "ItemRegraPrazoMinimo": 21,
	// cJson += ' "ItemRegraPrazoMaximo": 45,
	// cJson += ' "ItemRegraQuantidadeMaxima": "3,0000",
	// cJson += ' "ItemRegraDataMinima": null,
	// cJson += ' "ItemRegraDataMaxima": null,
	// cJson += ' "IntegracaoEnviado": 0,
	// cJson += ' "IntegracaoDataEnvio": null,
	// cJson += ' "IntegracaoNumeroErros": null,
	// cJson += ' "IntegracaoMessagem": null,
	// cJson += ' "slot": null,
	// cJson += ' "OsUuid": null,
	// cJson += ' "OsNumero": null,
	// cJson += ' "TotalItemVoucher": "1,0000",
	// cJson += ' "regiao": "ABC",
	// cJson += ' "EnderecoProduto": null,
	// cJson += ' "numero_SC": null
	// cJson += ' }
	// cJson += ' ],
	// cJson += ' "first_page_url": "http:\/\/staging-multpex.staging-voucher-api.multpex.com.br\/api\/ficha-epi\/consumo?dataInicial=22%2F11%2F2022&page=1",
	// cJson += ' "from": 1,
	// cJson += ' "last_page": 1,
	// cJson += ' "last_page_url": "http:\/\/staging-multpex.staging-voucher-api.multpex.com.br\/api\/ficha-epi\/consumo?dataInicial=22%2F11%2F2022&page=1",
	// cJson += ' "next_page_url": null,
	// cJson += ' "path": "http:\/\/staging-multpex.staging-voucher-api.multpex.com.br\/api\/ficha-epi\/consumo",
	// cJson += ' "per_page": 15,
	// cJson += ' "prev_page_url": null,
	// cJson += ' "to": 3,
	// cJson += ' "total": 3,
	// cJson += ' "highlights": {
	// cJson += ' "ValorTotal": "54.12580000",
	// cJson += ' "QuantidadeTotal": "3.0000",
	// cJson += ' "NumeroItens": 3,
	// cJson += ' "NumeroAtendimentos": 3,
	// cJson += ' "TicketMedio": 18.041933333333333,
	// cJson += ' "PrecoMedioItem": 18.041933333333333
	// cJson += ' }
	// cJson += ' }
	// cJson += ' }

	// oJson := JsonObject():new()

	// ret := oJson:FromJson(cJson)

	// conout(ret)

		// U_ADLOG087P("018435", "01")

		// lretf := U_ADMNT150("478560")

		// PARAMIXB := {.T.}

		// DbSelectArea("SF1")
		// SF1->(DbGoTo(1880916))

		// U_MT116OK()

		// INCLUI := .T.

		// aHeader := {}
		
		// Aadd(aHeader, {"000007730", "D1_DOC"})
		// Aadd(aHeader, {"1  ", "D1_SERIE"})
		// Aadd(aHeader, {"801607", "D1_COD"})
		// Aadd(aHeader, {1000, "D1_TOTAL"})
		// Aadd(aHeader, {"", "D1_PEDIDO"})
		// Aadd(aHeader, {"", "D1_ITEMPC"})
		
		// aCols	:= {}

		// Aadd(aCols, {"000007730", "1  ", "801607", 1000, "", ""})

		// U_DbSelArea("RECNFCTE", .F., 1 )
		// DbSeek( "52221130456082000144570010000076981000169266" )

		// U_MT116TOK()

		// U_MT116T3("A055JU", "0001", "029439", "01", "000007730", "1  ", 3, 4, 5, 6)

		// U_MT116O1("A055JU", "0001", "028222", "01", "000007698", "1  ")

		// U_MT116T1("52221130456082000144570010000076981000169266", "029439", "01", "000007698", "1  ", 0, 0, 0, 0)

		// U_MT116T2(cPedido, cItem, cForn, cLoja, cNum, cSerie, "I", nRecOri)

		// nQuant := U_MT1161("028222", "01", "000007730", "1")

		// U_ADFAT63I("35171018184642000153570010000003461020870902")

        // INCLUI := .T.
        // U_ADFAT632("35171203475263000145550010000005131000005136")

        // aFiliais := FWLoadSM0()

        // nPos := Ascan(aFiliais, {|x| x[01] == cEmpAnt .And. Alltrim(x[02]) == cFilAnt })

        // cCGC := aFiliais[nPos][18]

        // cChave := "50221160498706029481550500004982781027828672"

        // cQuery := " SELECT FONTE.XML_CHAVE, FONTE.XML_EMIT, FONTE.XML_NUMNF, FONTE.XML_EMISSA, FONTE.REC, RTRIM(FONTE.XML_ARQ) AS XML_ARQ FROM ("

        // cQuery += " SELECT  " 
        //     cQuery += " XML_CHAVE, XML_EMIT, XML_NUMNF, XML_EMISSA, R_E_C_N_O_ AS REC, ISNULL(CAST(CAST(XML_ARQ AS VARBINARY(MAX)) AS VARCHAR(MAX)),'') + '' AS XML_ARQ " 
        // cQuery += " FROM RECNFXML (NOLOCK)  " 
        // cQuery += " WHERE " 
        //     cQuery += " XML_CHAVE = '" + cChave + "' AND XML_ARQCAN IS NULL" 
        //     cQuery += " AND D_E_L_E_T_=''  "  

        // cQuery += " ) AS FONTE "

        // cNewAlias := GetNextAlias()
        // DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cNewAlias, .T., .T.)

        // (cNewAlias)->(DbGoTop())

        // Local cXML := ""

        // U_ADFAT637("001434", "94", cXML)

        // //Variáveis.
        // Local cUrl      := Alltrim(cValToChar(GetMV("MV_#URLABM",,"https://abmbus.com.br:8181/api")))
        // Local cChave    := Alltrim(cValToChar(GetMV("MV_#CHVABM",,"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG9yb19hcGlAYWJtcHJvdGVnZS5jb20uYnIiLCJleHAiOjE3NTY5NTkxMTJ9.vH0awO8mbiyWeqbzjVEClDePtC95qeOX8T-2w6LiNA_HJt1I-DCLEX1EPjRRMxZyKB68qb8ZhuT8eUQa3J1wzA")))
        // Local nCodEmp   := GetMV("MV_#EMPABM",,3528804)
        // Local cUsrPai   := GetMV("MV_#USRABM",,95)
        // Local aRotas := {}

        // Aadd(aRotas, {"123", "tst789"})
        // Aadd(aRotas, {"456", "tst788"})

        // U_ADGPE900(nCodEmp, cUsrPai, cUrl, cChave, aRotas)

        // U_ADFIN301()

        // U_ADLOG411("0000000233", "DJF9959", 95, SToD("20221122"), "N", "1")

        // lret := U_ADCOM42C("000002", "01")

        // aRet := (FWSM0Util():GetSM0Data( "01" , "05", {"M0_CGC"}))[1]

		// DbSelectArea("ZHR")
		// aStru := ZHR->(DbStruct())

		// aX3 := FWSX3Util():GetListFieldsStruct("ZHR")

		// nTopErr := 0
		// lAlt := TCAlter( 1, aStru, aX3, @nTopErr)

		// msgOut := ""
		// ret := TCCheckup(@msgOut)

		// lret := CHKFILE("ZHR", .T.)

        // __cUserID := "001284"

        // Local aNumPed   := 'A052YT'

        // U_ADCOM420(aNumPed)

        // nRes := (SC7->C7_QUANT * MV_PAR01)/100

        // If (SC7->C7_QUANT - SC7->C7_QUJE <= nRes .And. SC7->C7_QUANT > SC7->C7_QUJE)

        //     cUltSC7 := SC7->C7_NUM

        //     aNumPed	:= {}
        //     Aadd(aNumPed,{xFilial("SC7"),SC7->C7_NUM,'PC'})	
        //     If MA235PA(aNumPed,.T.)

        //         Ma235ElRes(@nNaoProc,aRefImp,aRecSC7)

        //         Aadd(aTNumPed,{xFilial("SC7"),SC7->C7_NUM,'PC'})
    
        //         MA235EPC(C7_FILIAL,C7_NUM)


        //     EndIf

        // EndIf

        // U_ADVEN050P("",.T.,," AND C5_NUM IN ('9BFDU9') ",,,,,,,1)

        // FOR nCont3 := 1 TO 2
        //     STATICCALL(ADLOG006P,CRIAWEBSERVICE)
        // NEXT nCont3

        // cFilter := " D2_FILIAL ='" + FWxFilial("SD2") + "' .And. D2_DOC = '000059405' .And. D2_SERIE = '01 ' .And. D2_CLIENTE = '052250' .And. D2_LOJA = '00' "

        // 	U_ADFAT27D(;
		// 	   "SF2", 1, FWxFilial("SF2") + "00005940501 05225000",;
		// 	   "SD2", 3, FWxFilial("SD2") +  "00005940501 05225000", "D2_COD+D2_ITEM",cFilter,;
		// 	   "documentos_de_saida_protheus", "I",;
		// 	   .T., .T.,.T., Nil)

        // DbSelectArea("SF2")
        // SF2->(DbSetOrder(1))
        // SF2->(DbSeek( FWxFilial("SF2") +   "00005940501 05225000") )

        // DbSelectArea("SD2")
        // SD2->(DbSetOrder(3))
        // SD2->(DbSeek( FWxFilial("SD2") + "00005940501 "))

        // STATICCALL(M460FIM, grvBarr,"I",  "00005940501 05225000", "000059405", "01 ")


    

Return Nil

static Function X31Updc(cChave,cEmp,aErase)
Local aArqStru
Local aSX3Stru
Local cDriver := X31Driver(cChave)
Local lNeedTruncate
Local cArquivo
Local cX2Arq
Local cArqBackup
Local cArqMemoCDX
Local cFileNoExt
Local cSvAlias := Alias()
Local cX2Alias := "SX2"
Local cX3Alias := "SX3"

DEFAULT cEmp := cEmpAnt
DEFAULT aErase := {}

If cEmp <> cEmpAnt
	cX2Alias += cEmp + "0"
	cX3Alias += cEmp + "0"
EndIf

DbSelectArea(cX2Alias)
DbSetOrder(1)
DbSeek(cChave)

cX2Arq := AllTrim(SX2->X2_PATH) + AllTrim(SX2->X2_ARQUIVO)
cArquivo := RetArq(cDriver,cX2Arq,.T.)
cFileNoExt := FileNoExt(cArquivo)
cArqMemoCDX	:= ""

If MsFile(cArquivo,,cDriver)
	X31Message("Comparando estrutura da tabela "+cChave) //"Comparando estrutura da tabela "
	
	If X31OpenDbf(cDriver,cArquivo,"TMPX31",.F.,.F.)
		//monta estrutura baseado no SX3
		aSX3Stru := {}
		DbSelectArea(cX3Alias)
		DbSetOrder(1)
		DbSeek(cChave)
		While !Eof() .and. (cX3Alias)->X3_ARQUIVO == cChave
			If (cX3Alias)->X3_CONTEXT <> "V"
				Aadd(aSX3Stru,{AllTrim((cX3Alias)->X3_CAMPO),(cX3Alias)->X3_TIPO,(cX3Alias)->X3_TAMANHO,(cX3Alias)->X3_DECIMAL})
			EndIf
			DbSkip()
		End

		//guarda estrutura atual do arquivo
		DbSelectArea("TMPX31")
		aArqStru := DbStruct()
        
		//compara estruturas e verifica se precisa truncar algum campo
		If X31CompStru(aSX3Stru,aArqStru,@lNeedTruncate,cDriver == "TOPCONN")
		
			If cDriver == "TOPCONN" .and. TCSRVTYPE() <> "AS/400"
				DbSelectArea("TMPX31")
				DbCloseArea()
				If !TcAlter(cArquivo,aArqStru,aSX3Stru)
					X31Message("Não foi possível criar a nova estrutura da tabela "+cChave,MSG_ERROR) //"Não foi possível criar a nova estrutura da tabela "
					__lError := .T.
				EndIf
			Else
				X31Message("Preparando backup "+cChave) //"Preparando backup "

				//deleta indice e fecha o arquivo
				DbSelectArea("TMPX31")
				X31IndErase(cChave,cX2Arq,cDriver,"TMPX31")

				//apaga backup anterior
				cArqBackup := cFileNoExt + ".#DB"
				cArqBackup := RetArq(cDriver,cArqBackup,.F.)
				If MsFile(cArqBackup,,cDriver)
					__lError := !X31Erase(cArqBackup,cDriver)
				EndIf

				If __lError
					X31Message("Não foi possível apagar o backup anterior da tabela "+cChave,MSG_ERROR) //"Não foi possível apagar o backup anterior da tabela "
				Else
					//backup do arquivo .FPT
					If !("TOP" $ cDriver ) .and. !("BTV" $ cDriver)
						If File(cFileNoExt + ".#FP")
							X31Erase(cFileNoExt + ".#FP",cDriver)
						EndIf
						If File(cFileNoExt + ".FPT")
							If X31CopyFile(cFileNoExt + ".FPT",cFileNoExt + ".#FP")
								cArqMemoCDX	:= FileNoExt(AllTrim(SX2->X2_PATH) + CriaTrab(,.F.))
							EndIf
						EndIf
					EndIf

					If X31CopyFile(cArquivo,cArqBackup,cDriver)

						//se tiver Memo e for CDX copia para um arquivo de trabalho
						If !Empty(cArqMemoCDX)
							If X31CopyFile(cFileNoExt + ".DBF",cArqMemoCDX + ".DBF")
								X31CopyFile(cFileNoExt + ".FPT",cArqMemoCDX + ".FPT")
								cArqBackup := cArqMemoCDX + ".DBF"
							EndIf
						EndIf

						//deleta arquivo atual
						If X31Erase(cArquivo,cDriver)
							//delete .FPT
							If !Empty(cArqMemoCDX)
								__lError := !X31Erase(cFileNoExt + ".FPT")
								If __lError
									X31Message("Não foi possível apagar "+cFileNoExt + ".FPT",MSG_ERROR) //"Não foi possível apagar "
								EndIf
							EndIf
						Else
							X31Message("Não foi possível apagar "+cArquivo,MSG_ERROR) //"Não foi possível apagar "
							__lError := .T.
						EndIf

						If !__lError
							//cria arquivo com a nova estrutura
							If MsCreate(cArquivo,aSX3Stru,cDriver)
								X31Message("Recriando tabela "+cChave) //"Recriando tabela "
								X31Append(cArquivo,cArqBackup,cDriver,lNeedTruncate,aArqStru,aSX3Stru, cChave)

								If !__lError
									X31Message("Finalizado atualização da tabela "+cChave) //"Finalizado atualização da tabela "
									DbCommitAll()

									If __lInX31
										//apagar backup ao fim da atualizacao
										If !Empty(cArqMemoCDX)
											Aadd(aErase,{FileNoExt(cArqBackup) + '.DBF',NIL})
											Aadd(aErase,{FileNoExt(cArqBackup) + '.FPT',NIL})
											cArqBackup := FileNoExt(cArquivo) + '.#DB'
											cArqBackup := RetArq(cDriver,cArqBackup,.F.)
										EndIf
						
										Aadd(aErase,{cArqBackup,cDriver})
										If !Empty(cArqMemoCDX)
											Aadd(aErase,{FileNoExt(cArqBackup) + '.#FP',cDriver})
										EndIf
									EndIf
								EndIf						
							Else
								X31Message("Não foi possível criar a nova estrutura da tabela " +cChave,MSG_ERROR) //"Não foi possível criar a nova estrutura da tabela "
								__lError := .T.
							EndIf
						EndIf
					Else
						X31Message("Não foi possível gerar o backup da tabela "+cChave,MSG_ERROR) //"Não foi possível gerar o backup da tabela "
						__lError := .T.
					EndIf
				EndIf
			EndIf
		Else
			X31Message("Não foi necessário alterar a estrutura da tabela "+cChave) //"Não foi necessário alterar a estrutura da tabela "
		EndIf

		If Select("TMPX31") > 0
			DbSelectArea("TMPX31")
			DbCloseArea()
		EndIf
	EndIf
EndIf

If !Empty(cSvAlias)
	DbSelectArea(cSvAlias)
EndIf
Return

Static Function X31OpenDbf(cDriver,cArq,cAlias,lShared,lReadOnly,lHelp)
Local lRet

DEFAULT lHelp := .T.

lRet := MsOpenDbf(.T.,cDriver,cArq,cAlias,lShared,lReadOnly,.F.,.F.)
If !lRet .and. lHelp
	__lError := .T.
	X31Message("Não foi possível abrir" + Upper(cArq) + If(lShared," ."," exclusivo."),MSG_ERROR) //"Não foi possível abrir "###" exclusivo."
EndIf
Return lRet

Static Function X31Message(cMsg,nType,lTrace)
	conout(cMsg)
return 

user function inijob (cTxt)
  conout(cTxt)
return cTxt
