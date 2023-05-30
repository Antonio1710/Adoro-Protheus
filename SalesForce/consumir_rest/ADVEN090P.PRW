#Include "Rwmake.ch"
#Include 'AP5mail.ch'
#Include "Protheus.ch"
#include 'Fileio.ch'
#Include 'Totvs.ch'
#Include 'Topconn.ch'

Static cEmp := "01"
Static cFil := "02"
Static aRegLock := {}

/*/{Protheus.doc} User Function ADVEN090P 
	Job para processamento de alteração de pedido de venda SalesForce. Chamado 037261.
	@type  Function
	@author Everson
	@since 09/05/2018
	@version 01
	@history 06/02/2019, Fernando, ERRO LOG - ALIAS NÃO EXISTE "CI" alterado para ZCI - Chamado TI.
	@history 25/09/2019, Everson,  Chamado T.I. Tratamento para error log.
	@history 25/09/2019, Everson,  Chamado T.I. Tratamento para error log.
	@history 30/10/2019, Everson, Chamado 052760. Validação Sintegra.
	@history 27/12/2019, Everson, Chamado TI. Tratamento para data incorreta enviada pelo Salesforce.
	@history chamado 056247 - FWNM     - 22/04/2020 - || OS 057671 || FINANCEIRO || LUIZ || 8451 || BOLETO BRADESCO WS
	@history chamado 050729 - FWNM     - 30/06/2020 - || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE
	@history 21/07/2020, Leon, Comentar LockByName para contornar falta de execução de rotinas de agendamento;
	@history 21/07/2020, Leon, Comentar LockByName para contornar falta de execução de rotinas de agendamento;
	@Ticket 11762, Data 05/04/2021, Leonardo P. Monteiro, Adição do tipo do cliente na inclusão ou alteração;
	@Ticket TI   , Data 28/12/2021, Everson, Tratamento para data incorreta enviada pelo Salesforce.
	@history Chamado 66524 - Leonardo P. Monteiro  - 11/01/2022 - Correção na função comparaCab responsável pela comparação do cabeçalho dos PVs. Tratamento dos campos de mensagens C5_MENNOTA para a correta decodificação.
	@history Chamado T.I  - Leonardo P. Monteiro   - 15/01/2022 - Inclusão data, hora e quantidade de processamentos.
	@history Chamado T.I  - Leonardo P. Monteiro   - 27/01/2022 - Correção na rotina comparacab e comparaitem e reformulação das rotinas de reprocessamento.
	@history Chamado 69520 - Leonardo P. Monteiro   - 17/03/2022 - Ajuste na ordenação do processamento para priorizar os PVs por data de entrega e condições de pagamento que geram boletos ou PIX.
<<<<<<< HEAD
	@history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	@history Chamado 69520 - Leonardo P. Monteiro   - 17/03/2022 - Preparação da rotina para integrações de diferentes Empresas/Filiais com a entrada da nova filial de Itupeva.
	
=======
<<<<<<< HEAD
	@history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
=======
	@history Chamado 69520 - Leonardo P. Monteiro   - 17/03/2022 - Preparação da rotina para integrações de diferentes Empresas/Filiais com a entrada da nova filial de Itupeva.
	
>>>>>>> master
>>>>>>> 22b14a347bdb762f804252d2045c7cbdd575a5d7
	@history Ticket TI - Everson - 08/09/2022 - Preparação para filial de Itapira.
	@history Ticket TI - Everson - 05/01/2023 - Tratamento para não retornar falso quando for travar o registro, se não encontrar o registro.
	@history Ticket 18465 - Everson - 25/01/2023 - Alterada função static funcion para user function.
	@history Ticket TI - Everson - 15/03/2023 - Tratamento para caracter especial no campo C6_PEDCLI.
	@history Ticket TI - Everson - 22/03/2023 - Tratamento para caracter especial no campo C6_PEDCLI.
/*/
User Function ADVEN090P(aXEmpFil) // U_ADVEN090P() //Ticket TI - Everson - 08/09/2022.

	//Declaração de variávies
	Local cDiaS		:= ""
	Local cHDe		:= ""
	Local cHAt		:= ""
	Local lAutoJob  := .T.
	local cRobo		:= "A"
	Local nCiclos	:= 0
	Local nCount 	:= 0

	//Ticket TI - Everson - 08/09/2022
	Local cEmp		:= ""
	Local cFil		:= ""

	Default aXEmpFil:= {"01", "02"}

	cEmp := aXEmpFil[1]
	cFil := aXEmpFil[2]
	//
	
	If Select("SX6") == 0
		lAutoJob  := .T.

	Else
		lAutoJob  := .F.

	EndIf

	If lAutoJob
		RPCClearEnv()
		RPCSetType(3)
		RpcSetEnv(cEmp,cFil,,,,GetEnvServer(),{})

	Else
		MsgInfo("Modo debug Início", "Modo Debug")

	EndIf

		Conout(DToC(Date()) + " " + Time() + " ADVEN090P - Início inclusão/atualização/exclusão de pedido de venda SalesForce.")

		nCiclos := GetMV("MV_#VEN903",,100)

		While (nCount <= nCiclos)
		
			cDiaS := Alltrim(cValToChar(GetMv("MV_#SFDSEM")))
			cHDe  := Alltrim(cValToChar(GetMv("MV_#SFHDE")))
			cHAt  := Alltrim(cValToChar(GetMv("MV_#SFHATE")))
			
			If (cValToChar(DOW(Date()))) $cDiaS
				
				logZBN("1") //Log início.

					U_ADVEN90A(cRobo)

				logZBN("2") //Log início.

			EndIf

			nCount++

			Conout(DToC(Date()) + " " + Time() + " ADVEN090P - Ciclos " + cValToChar(nCount))

		End
		
		Conout(DToC(Date()) + " " + Time() + " ADVEN090P - Fim inclusão/atualização/exclusão de pedido de venda SalesForce.")

	RpcClearEnv()

	If lAutoJob
		RpcClearEnv()

	Else
		MsgInfo("Modo debug Término", "Modo Debug")

	EndIf

Return Nil
/*/{Protheus.doc} ADVEN90A
	Obtém registros de pedidos de venda pendentes de alteração. Chamado 037261.
	@type  User Function
	@author Everson
	@since 09/05/2018
	@version 01
/*/
User Function ADVEN90A(cRobo)

	//Declaracao de Variaveis
	Local cQuery 	:= ""
	Local nTotThe	:= Val(cValToChar(GetMv("MV_#SFQTHR",,1)))
	Local nRePThe	:= Val(cValToChar(GetMv("MV_#SFRTHR",,1000)))
	Local cRecnos	:= ""
	
	Local nAux	 	:= 0
	Local nTotG	 	:= 0
	Local cJobAux	:= ""
	Local i		 	:= 1
	Local lCont	 	:= .T.
	Local nRecErro 	:= 0
	Local cGrvErro	:= ""

	Private nTotal 	:= 0

	Conout(DToC(Date()) + " " + Time() + " ADVEN090P - INÍCIO da consulta aos registros.")

	If Select("A_REG") > 0
		A_REG->(DbCloseArea())

	EndIf

	cQuery := sqlTScript(nRePThe, nTotThe, cRobo)

	TcQuery cQuery New Alias "A_REG"
	DbSelectArea("A_REG")
	A_REG->(DbGoTop())
	nTotal := Contar("A_REG","!Eof()")
	Conout(DToC(Date()) + " " + Time() + " ADVEN090P - obterReg - TOTAL DE REGISTROS " + cValToChar(nTotal) )
	A_REG->(DbGoTop())

	Conout(DToC(Date()) + " " + Time() + " ADVEN090P - TÉRMINO da consulta aos registros.")

	While ! A_REG->(Eof())	.And. lCont

		aRegLock := {}
		nAux++
		nTotG++
		cRecnos += Alltrim(cValToChar( A_REG->REC )) + ","

		If nAux == nRePThe .Or. nAux == nTotal .Or. nTotG == nTotal
	
			cRecnos := Substr(cRecnos,1,Len(cRecnos) -1)
			i++

			//Gera log na tabela ZBE.
			logZBE("Início Processamento JOB " + Iif(Empty(cJobAux),"_ERRO",cValToChar(cJobAux)),"RECNOS " + cValToChar(cRecnos))

			Conout(DToC(Date()) + " " + Time() + " ADVEN090P - INÍCIO do Execproc.")

			//Everson - 25/09/2019. Chamado T.I.
			nRecErro := 0
			cGrvErro := ""

			lCont := execProc(cRecnos,@nRecErro,@cGrvErro)
			
			If nRecErro > 0
				StartJob("U_ADVEN901",getenvserver(),.F., cEmpAnt, cFilAnt, nRecErro,cGrvErro)
				nRecErro := 0

			EndIf
			//

			//Gera log na tabela ZBE.
			logZBE("Fim processamento JOB " + Iif(Empty(cJobAux),"_ERRO",cValToChar(cJobAux)),"RECNOS " + cValToChar(cRecnos))
			
			cRecnos := ""
			nAux := 0
			cJobAux := ""

		EndIf

		A_REG->(DbSkip())

	End

Return Nil
/*/{Protheus.doc} sqlTScript
	Script sql para processamento de registros.
	@type  Static Function
	@author user
	@since 28/10/2021
	@version 01
/*/
Static Function sqlTScript(nRePThe, nTotThe, cRobo)

	//Variáveis.
	Local cQuery 	:= ""
	Local cEOL		:= Chr(13)+chr(10)
	Local nTotReg	:= nRePThe * nTotThe
	Local lRobo 	:= GetMv("MV_#VEN901",,.F.)

	//Inclusão de pedido de venda.
	cQuery += " SELECT TOP " + cValToChar(nTotReg) + " * FROM ( " +cEOL

	cQuery += " SELECT ZCI_FILIAL, ZCI_NUMP, MIN(ZCI.ZCI_ANTECI) ANTECI, MAX(ZCI.ZCI_DTENTR) DTENTR, MAX(R_E_C_N_O_) AS REC, ZCI_ROBO "  +cEOL
	cQuery += " FROM " + RetSqlName("ZCI") + " (NOLOCK) ZCI "  +cEOL
	cQuery += " WHERE D_E_L_E_T_ = '' AND ZCI_FILIAL='"+ FWxFilial("ZCI") +"' "  +cEOL
	//cQuery += " AND R_E_C_N_O_ = '5920829' "  +cEOL
	cQuery += " AND ZCI_TMPR = 'PENDPROC' "  +cEOL
	cQuery += " AND ZCI_METD = 'POST' "  +cEOL
	cQuery += " GROUP BY ZCI_FILIAL, ZCI_NUMP, ZCI_ROBO "  +cEOL

	cQuery += " UNION ALL " +cEOL

	//Exclusão de pedido de venda.
	cQuery += " SELECT ZCI.ZCI_FILIAL, ZCI.ZCI_NUMP, MIN(ZCI.ZCI_ANTECI) ANTECI, MAX(ZCI.ZCI_DTENTR) DTENTR, MAX(R_E_C_N_O_) AS REC, ZCI_ROBO   "  +cEOL
	cQuery += " FROM  " + RetSqlName("ZCI") + " (NOLOCK)  AS ZCI "  +cEOL
	cQuery += " INNER JOIN "  +cEOL
	cQuery += " (SELECT ZCI_FILIAL, ZCI_NUMP FROM " + RetSqlName("ZCI") + " AS ZCI WHERE ZCI_METD = 'POST' AND ZCI_TPALT = '5' AND ZCI.D_E_L_E_T_ = ''  ) AS POST "  +cEOL
	cQuery += " ON ZCI.ZCI_FILIAL=POST.ZCI_FILIAL AND ZCI.ZCI_NUMP = POST.ZCI_NUMP "  +cEOL
	cQuery += " WHERE D_E_L_E_T_ = '' AND ZCI.ZCI_FILIAL='"+ FWxFilial("ZCI") +"' "  +cEOL
	cQuery += " AND ZCI.ZCI_TMPR = 'PENDPROC'   "  +cEOL
	cQuery += " AND ZCI.ZCI_METD = 'DELETE'   "  +cEOL
	cQuery += " GROUP BY ZCI.ZCI_FILIAL, ZCI.ZCI_NUMP, ZCI_ROBO "  +cEOL

	cQuery += " UNION ALL " +cEOL

	//Alteração de pedido de venda.
	cQuery += " SELECT ZCI.ZCI_FILIAL, ZCI.ZCI_NUMP, MIN(ZCI.ZCI_ANTECI) ANTECI, MAX(ZCI.ZCI_DTENTR) DTENTR, MAX(R_E_C_N_O_) AS REC, ZCI_ROBO   "  +cEOL
	cQuery += " FROM   "  +cEOL
	cQuery += " " + RetSqlName("ZCI") + " (NOLOCK)  AS ZCI "  +cEOL
	cQuery += " INNER JOIN "  +cEOL
	cQuery += " (SELECT ZCI_FILIAL, ZCI_NUMP FROM " + RetSqlName("ZCI") + " AS ZCI WHERE ZCI_METD = 'POST' AND ZCI_TPALT = '5' AND ZCI.D_E_L_E_T_ = ''  ) AS POST "  +cEOL
	cQuery += " ON ZCI.ZCI_FILIAL=POST.ZCI_FILIAL AND ZCI.ZCI_NUMP = POST.ZCI_NUMP "  +cEOL
	cQuery += " WHERE D_E_L_E_T_ = '' AND ZCI.ZCI_FILIAL='"+ FWxFilial("ZCI") +"' "  +cEOL
	cQuery += " AND ZCI.ZCI_TMPR = 'PENDPROC'   "  +cEOL
	cQuery += " AND ZCI.ZCI_METD = 'PUT'   "  +cEOL
	cQuery += " GROUP BY ZCI.ZCI_FILIAL, ZCI.ZCI_NUMP, ZCI_ROBO "  +cEOL

	cQuery += " ) AS FONTE " +cEOL

	If lRobo .And. cRobo == "A"
		cQuery += " WHERE FONTE.ZCI_ROBO IN ('A', '') "  +cEOL

	ElseIf lRobo .And. cRobo == "B"
		cQuery += " WHERE FONTE.ZCI_ROBO = 'B' "  +cEOL

	EndIF
	
	cQuery += " ORDER BY FONTE.ANTECI, FONTE.DTENTR, FONTE.ZCI_NUMP, FONTE.REC "

Return cQuery
/*/{Protheus.doc} User Function ADVEN901
	Job para processar os registros. Chamado T.I.
	@type  Function
	@author Everson
	@since 25/05/2018
	@version 01
	@history 21/07/2020, Leon, Comentar LockByName para contornar falta de execução de rotinas de agendamento;
/*/
User Function ADVEN901(cEmpAtu, cFilAtu, nRecErro, cGrvErro)

	//Variáveis.
	Default cGrvErro := ""

	RPCClearEnv()
	RPCSetType(3)
	RpcSetEnv(cEmpAtu,cFilAtu,,,,GetEnvServer(),{ })

		Conout( DToC(Date()) + " " + Time() +  " ADVEN090P - ADVEN901 - nRecErro / cGrvErro " + cValToChar(nRecErro) + " / " + cValToChar(cGrvErro) )

		grvResult(nRecErro, cGrvErro, "")

	RpcClearEnv()

Return Nil
/*/{Protheus.doc} execProc
	Executa processamento de alteração de pedidos. Chamado 037261.
	@type  Static Function
	@author Everson
	@since 09/05/2018
	@version 01
/*/
Static Function execProc(cRecnos,nRecGetErr,cGrvErro) //Everson - 25/09/2019. Chamado T.I.
	
	//Variáveis.
	Local aArea	 	 := GetArea()
	Local cQuery 	 := ""
	Local oParseJSON := Nil
	Local cErro		 := ""
	Local cFlagApr	 := ""
	Local cErroPE	 := ""
	Local cHoraExec	 := Time()
	Local cPed		 := ""
	Local cFil		 := ""
	Local nTpOp		 := 0
	Local lPedBloq	 := .F.
	Local lProcess	 := .F.
	Local lRetCheck	 := .F.
	Local cHoraAnt	 := ""
	Local lErro		 := .T.
	Local nAux		 := 0
	Local i			 := 0
	Local cCliente   := ""
	Local cLoja	     := ""
	Local cError	 := ""
	
	//Everson - 25/09/2019. Chamado T.I.
	Local lContinua	 := .T. 
	Local nRecErro	 := ""
	//

	//Everson - 11/08/2022. Chamado T.I.
	Local lTrava	 := .F. 
	Local cMetodo	 := ""
	Local cSintegra	 := ""
	//

	Private aPedidos := {}

	Default cRecnos	 := ""

	If Empty(cRecnos)
		RestArea(aArea)
		Return Nil

	EndIf

	//Everson - 25/09/2019. Chamado T.I.
	bError := ErrorBlock( {|e| cError := e:Description ,cGrvErro := cError, nRecGetErr := nRecErro, lContinua := .F., Conout( DToC(Date()) + " " + Time() + " ADVEN090P - RESTEXECUTE - lContinua/nRecErro/ERRO - " +; 
							   cValToChar(lContinua) + " " + cValToChar(nRecErro) + " " + cError) } )

	DbSelectArea("ZCI")

	Begin Sequence

		cQuery := csqlScript(cRecnos)

		If Select("A_PROC") > 0
			A_PROC->(DbCloseArea())

		EndIf

		TcQuery cQuery New Alias "A_PROC"
		DbSelectArea("A_PROC")
		A_PROC->(DbGoTop())

		While ! A_PROC->(Eof()) .And. lContinua
		
			cHoraAnt  := Time()
			lRetCheck := .F.
			lProcess  := .F.
			lTrava    := .F.
			cHoraExec := ""
			aPedidos  := {}
			lPedBloq  := .F.
			cErro     := ""
			lErro 	  := .T.
			cErroPE   := ""
			nAux++
			
			nRecErro := Val(cValToChar(A_PROC->REC))
			
			ZCI->(DbGoTo(nRecErro))
			
			cFil	   := FwxFilial("SC5")
			cPed 	   := Alltrim(cValToChar(ZCI->ZCI_NUMP))
			cMetodo	   := Alltrim(cValToChar(ZCI->ZCI_METD))
			cSintegra  := Alltrim(cValToChar(A_PROC->ZCI_CONSIN))
			
			Conout(DToC(Date()) + " " + Time() + " ADVEN090P - execProc - PROCESSANDO ZCI " + cValToChar(nRecErro) + " METODO " + cMetodo + " - " + cValToChar(nAux) + " de " + cValToChar(nTotal) + " Robo " + cValToChar(ZCI->ZCI_ROBO))

			If cMetodo <> "DELETE" .And. ! FWJsonDeserialize(ZCI->ZCI_JSON, @oParseJSON)
				
				grvResult(nRecErro, "Json não pode ser desserializado.", "")

				A_PROC->(DbSkip())
				Loop

			EndIf

			If cMetodo <> "DELETE"
				cFlagApr := Alltrim(cValToChar(oParseJSON:CABECALHO:C5_BLQ))
				lPedBloq := Iif(Upper(Alltrim(cValToChar(oParseJSON:CABECALHO:C5_BLQ))) == "S", .T., .F.)
				cCliente := Alltrim(cValToChar(oParseJSON:CABECALHO:C5_CLIENTE))
				cLoja	 := Alltrim(cValToChar(oParseJSON:CABECALHO:C5_LOJACLI))

			EndIf

			//Executa a inclusão do pedido de venda.
			If cMetodo == "POST"

				Conout(DToC(Date()) + " " + Time() + " ADVEN090P - execProc - POST " + cFil + "-" + cPed)
				
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				If SC5->( DbSeek( cFil + cPed ) )

					grvResult(nRecErro, "Pedido já processado.", "", "5")

					updStPut(cPed,cValToChar(nRecErro))

					Conout(DToC(Date()) + " " + Time() + " ADVEN090P - execProc - POST - Pedido já processado " + cFil + "-" + cPed)

					A_PROC->(DbSkip())
					Loop

				EndIf

				If RESTEXECUTE(@lTrava, oParseJSON, @cErro, cPed, cFlagApr, nRecErro, 3, cSintegra)
					
					Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - OK - POST " + cFil + "-" + cPed)

					grvResult(nRecErro, "", ElapTime(cHoraAnt, Time()), "5")

					updStPut(cPed,cValToChar(nRecErro))

				Else

					If lTrava
						
						For i := 1 To Len(aPedidos)
							cErroPE += aPedidos[i][1] + " / "

						Next i

						grvResult(nRecErro, Iif(Empty(cErroPE),cErro,cErroPE), "")

						Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - POST - ERRO " + cFil + "-" + cPed + " " + Iif(Empty(cErroPE),cErro,cErroPE))

					EndIf
				
				EndIf

				Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - POST - TÉRMINO " + cFil + "-" + cPed + " " + ElapTime(cHoraAnt, Time()))

			EndIf

			//Exclusão de pedido de venda.
			If cMetodo == "DELETE"

				Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - DELETE " + cFil + "-" + cPed)
			
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				If ! SC5->( DbSeek( cFil + cPed ) )

					grvResult(nRecErro, "Exclusão já processada.", "", "6")

					updStPut(cPed,cValToChar(nRecErro))

					Conout(DToC(Date()) + " " + Time() + " ADVEN090P - execProc - DELETE - Pedido já processado " + cFil + "-" + cPed)

					A_PROC->(DbSkip())
					Loop

				EndIf
				
				If RESTEXECUTE(@lTrava, oParseJSON, @cErro, cPed, cFlagApr, nRecErro, 5)
					
					Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - OK - DELETE " + cFil + "-" + cPed)

					grvResult(nRecErro, "", ElapTime(cHoraAnt, Time()), "6")

					updStPut(cPed,cValToChar(nRecErro))

				Else

					If lTrava

						For i := 1 To Len(aPedidos)
							cErroPE += aPedidos[i][1] + " / "

						Next i

						grvResult(nRecErro, Iif(Empty(cErroPE),cErro,cErroPE), "")

						Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - DELETE - ERRO " + cFil + "-" + cPed + " " + Iif(Empty(cErroPE),cErro,cErroPE))

					EndIf

				EndIf

				Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - DELETE - TÉRMINO " + cFil + "-" + cPed + " " + ElapTime(cHoraAnt, Time()))

			EndIf

			//Alteração pedido de venda.
			If cMetodo == "PUT"

				Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - PUT - " + cFil + "-" + cPed)
				
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				If ! SC5->( DbSeek( cFil + cPed ))

					grvResult(nRecErro, "Pedido não encontrado no Protheus.", "")

					updStPut(cPed,cValToChar(A_PROC->REC))

					Conout(DToC(Date()) + " " + Time() + " ADVEN090P - execProc - PUT - Pedido não encontrado no Protheus " + cFil + "-" + cPed)

					A_PROC->(DbSkip())
					Loop

				EndIf

				If Alltrim(cValToChar(A_PROC->ZCI_TPALT)) == "R"
					nTpOp := 1

				Else
					nTpOp := checkProc(oParseJSON,cPed) //Obtém tipo de alteração.

				EndIf

				If nTpOp == 1 //Executa Execauto.

					Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - PUT 1 (EXECAUTO) - INÍCIO - " + cFil + "-" + cPed)

					If RESTEXECUTE(@lTrava, oParseJSON, @cErro, cPed, cFlagApr, nRecErro, 4)
						
						Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc  - OK - PUT 1 (EXECAUTO) " + cFil + "-" + cPed)

						grvResult(nRecErro, , ElapTime(cHoraAnt, Time()), cValToChar(nTpOp))

						Conout("ADVEN090P - execProc - Atualiza PUT 1 (EXECAUTO) sucesso "+ cFil +"-" + cPed + " RECNO " + cValToChar(nRecErro))

						updStPut(cPed,cValToChar(nRecErro))

					Else

						If lTrava

							For i := 1 To Len(aPedidos)
								cErroPE += aPedidos[i][1] + " / "

							Next i

							grvResult(nRecErro, Iif(Empty(cErroPE),cErro,cErroPE), "")
							
							Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - PUT 1 (EXECAUTO) - ERRO " + cFil + "-" + cPed + " " + Iif(Empty(cErroPE),cErro,cErroPE))
		
						EndIf

					EndIf
					
					Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - PUT 1 (EXECAUTO)  - TÉRMINO " + cFil + "-" + cPed + " " + ElapTime(cHoraAnt, Time()))
				
				ElseIf nTpOp == 2 //Executa liberação do pedido.
					
					Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - PUT 2 (SEM EXECAUTO) - " + cFil + "-" + cPed)

					lErro    := .T.

					Begin transaction

						//Verifica e há mudança de status no pedido.
						If (lPedBloq .And. Alltrim(cValToChar( SC5->C5_BLQ )) == "1") .Or. (! lPedBloq .And. Empty(Alltrim(cValToChar( SC5->C5_BLQ ))))

							Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - OK - PUT 2 (SEM EXECAUTO) - " + cFil + "-" + cPed)

							grvResult(nRecErro, , ElapTime(cHoraAnt, Time()), cValToChar(nTpOp))

							//Executa update nos registros pendentes.
							updStPut(cPed,cValToChar(nRecErro))	

							Conout("ADVEN090P - execProc - Atualiza PUT 2 (SEM EXECAUTO) sucesso " + cFil + "-" + cPed + " RECNO " + cValToChar(nRecErro))

						Else

							Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - OK - PUT 2 (SEM EXECAUTO) - " + cFil + "-" + cPed)

							lTrava := .F.
							lRetCheck := chkLiber(cPed, lPedBloq, , @lProcess, @cErro, @lTrava)
		
							//Desarma transação se houve erro na liberação/bloqueio do pedido de venda.
							If !lRetCheck .Or. !lProcess
								Conout("ADVEN090P - execProc - PUT 2 (SEM EXECAUTO) - DisarmTransaction " + cFil + "-" + cPed)
								DisarmTransaction()
								Break

							Else
								Conout("ADVEN090P - execProc - Atualiza PUT 2 (SEM EXECAUTO) sucesso " + cFil + "-" + cPed + " RECNO " + cValToChar(nRecErro))

							EndIf

							grvResult(nRecErro, , ElapTime(cHoraAnt, Time()), cValToChar(nTpOp))
			
							//Executa update nos registros pendentes.	
							updStPut(cPed,cValToChar(nRecErro))

						EndIf

						lErro := .F.

					End Transaction

					unlockAll()

					If lErro .And. lTrava

						grvResult(nRecErro, "Erro transação possível SC6 x SC9 Tipo 2", "")

						Conout(DToC(Date()) + " " + Time() + " ADVEN090P - execProc - PUT 2 (SEM EXECAUTO) - Erro Transação " + cFil + "-" + cPed)

					EndIf

					Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - PUT 2 (SEM EXECAUTO) - TÉRMINO " + cFil + "-" + cPed + " " + ElapTime(cHoraAnt, Time()))

				ElseIf nTpOp == 3 //Altera quantidades do pedido de venda.

					Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - PUT 3 (SEM EXECAUTO - CORTE) - " + cFil + "-" + cPed)

					Begin transaction

						If procCorte(oParseJSON,cPedido,lPedBloq)

							Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - OK - PUT 3 (SEM EXECAUTO) - " + cFil + "-" + cPed)

							lTrava := .F.
							lRetCheck := chkLiber(cPed, lPedBloq, , @lProcess, @cErro, @lTrava)

							//Desarma transação se houve erro na liberação/bloqueio do pedido de venda.
							If !lRetCheck .Or. !lProcess
								Conout("ADVEN090P - execProc - PUT 3 (SEM EXECAUTO - CORTE) - DisarmTransaction " + cFil + "-" + cPed)
								DisarmTransaction()
								Break

							Else
								Conout("ADVEN090P - execProc - Atualiza PUT 3 (SEM EXECAUTO - CORTE) sucesso " + cFil + "-" + cPed + " RECNO " + cValToChar(nRecErro))

							EndIf

							grvResult(nRecErro, , ElapTime(cHoraAnt, Time()), cValToChar(nTpOp))

							//Executa update nos registros pendentes.
							updStPut(cPed,cValToChar(A_PROC->REC))

						EndIf

						lErro := .F.

					End Transaction

					unlockAll()

					If lErro .And. lTrava

						grvResult(nRecErro, "Erro transação possível SC6 x SC9 Tipo 3", "")

						Conout(DToC(Date()) + " " + Time() + " ADVEN090P - execProc - PUT 3 (SEM EXECAUTO - CORTE) - Erro Transação " + cFil + "-" + cPed)

					EndIf

					Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - PUT 3 (SEM EXECAUTO - CORTE) - TÉRMINO " + cFil + "-" + cPed + " " + ElapTime(cHoraAnt, Time()))

				EndIf

			EndIf
			
			If cMetodo <> "DELETE"

				Conout( DToC(Date()) + " " + Time() + " ADVEN090P - execProc - Início check financeiro - u_LIBPEDA0 " + cFil + "-" + cPed)

				u_LIBPEDA0( cCliente, cLoja, cPed)

			EndIf

			//Grava a data, hora e a quantidade de processamentos do registro.
			RecLock("ZCI",.F.)
				If Empty(ZCI->ZCI_DTPROC)
					ZCI->ZCI_DTPROC	:= Date()
					ZCI->ZCI_HRPROC	:= Time()
				EndIf

				ZCI->ZCI_QTPROC := ZCI->ZCI_QTPROC+1
			ZCI->(MsUnlock())

			A_PROC->(DbSkip())

		EndDo

	Recover //Everson - 25/09/2019. Chamado T.I.
		ErrorBlock( bError )
		Break

	End Sequence

	A_PROC->(DbCloseArea())

	RestArea(aArea)

Return .T.
/*/{Protheus.doc} grvResult
	Grava resultado do processamento.
	@type  Static Function
	@author Everson
	@since 11/08/2022
	@version 01
/*/
Static Function grvResult(nRecErro, cErro, cHrExec, cTpExec)

	//Variaveis.
	Local aArea	:= GetArea()

	Default cErro   := ""
	Default cHrExec := ""
	Default cTpExec := ""

	DbSelectArea("ZCI")
	ZCI->(DbGoTo(nRecErro))
	If ! ZCI->(Eof())
		RecLock("ZCI",.F.)
			ZCI->ZCI_ERRO  := cErro
			ZCI->ZCI_TMPR  := cHrExec
			ZCI->ZCI_TPALT := Iif(!Empty(cTpExec), cTpExec, ZCI->ZCI_TPALT)
		ZCI->(MsUnlock())	
	EndIf

	RestArea(aArea)

Return Nil
/*/{Protheus.doc} RESTEXECUTE
	Altera pedido de venda. Chamado 037261.
	@type  Static Function
	@author Everson
	@since 09/05/2018
	@version 01
/*/
Static Function RESTEXECUTE(lTrava, oParseJSON,cErro,cNumPed,cFlagApr,nRecno,nOpc,cSintegra) //Everson - 30/10/2019. Chamado 052760.
	
	//Variáveis.
	Local aArea			:= GetArea()
	Local lRet			:= .F.	
	Local aCabec		:= {}
	Local aItens		:= {}
	Local aItem			:= {}
	Local aErroLog		:= {}
	Local k				:= 1
	Local i				:= 1
	Local nAuxInvalido	:= 0
	Local cProduto		:= ""
	Local nVlTot		:= 0
	Local lPedBloq		:= .F.
	Local cItemPed		:= ""
	Local nItemPed 		:= obtSeqSC6(cNumPed)
	Local cVendCdCli	:= ""
	Local cContaC		:= ""
	Local cItemContaC	:= ""
	Local cUsrVend		:= ""
	Local cBckUsr	    := __CUSERID
	Local cObrPdCp		:= ""
	Local cPedidoPC		:= ""
	Local cRedeOP		:= GetMV("MV_#REDEOP")
	Local lRedeOp		:= .F.
	Local cPedVendOrd	:= ""
	Local cTesCod		:= ""
	Local cTipCli		:= ""
	Local aTravaSB2		:= {}
	Local cHrIni		:= ""
	// Local cEmail		:= Alltrim(cValToChar(GetMv("MV_#VEN902",,"sistemas@adoro.com.br")))
	Local cPrdBlq		:= ""
	Local nQtdSC6 		:= 0
	Local nQtdSC9 		:= 0

	//Everson - 29/10/2021. Chamado 63090.
	Local cNmBlq		:= ""
	//

	Local nCount		:= GetMv("MV_#VEN900",,1)
	Local nAux			:= 0

    Private lMsErroAuto    := .F.
    // Private lMsHelpAuto    := .T.
    // Private lAutoErrNoFile := .F.

	Default cErro		:= ""
	Default nOpc		:= 4
	Default cSintegra	:= "" //Everson - 30/10/2019. Chamado 052760.
	Default lTrava		:= .F.

	//Exclusão do pedido de venda.
	If nOpc == 5
		lTrava := .T.
		Conout( DToC(Date()) + " " + Time() + " ADVEN090P - RESTEXECUTE >>>> " + cNumPed + " OPCAO " + cValToChar(nOpc) )
		SetFunName("U_RESTEXECUTE")
		lTrava := .F.
		lRet := U_ADVEN902(@cErro, cNumPed, @lTrava)
		Conout( DToC(Date()) + " " + Time() + " ADVEN090P - RESTEXECUTE >>>> " + cNumPed )
		RestArea(aArea)
		Return lRet

	EndIf

	//Verifica se o pedido está bloqueado.
	lPedBloq 	:= Iif(Upper(Alltrim(cValToChar(oParseJSON:CABECALHO:C5_BLQ))) == "S",.T.,.F.)

	cVendCdCli 	:= Posicione("SA1",1,FWxFilial("SA1") + Alltrim(cValToChar(oParseJSON:CABECALHO:C5_CLIENTE)) + Alltrim(cValToChar(oParseJSON:CABECALHO:C5_LOJACLI)),"A1_VEND")

	cUsrVend   	:= Posicione("SA3",1, FWxFilial("SA3") + cVendCdCli , "A3_CODUSR" )

	cObrPdCp   	:= Posicione("SA1",1,FWxFilial("SA1") + Alltrim(cValToChar(oParseJSON:CABECALHO:C5_CLIENTE)) + Alltrim(cValToChar(oParseJSON:CABECALHO:C5_LOJACLI)),"A1_XOBRPC")

	lRedeOp    	:= Iif( Posicione("SA1",1, FWxFilial("SA1") + Alltrim(cValToChar(oParseJSON:CABECALHO:C5_CLIENTE)) + Alltrim(cValToChar(oParseJSON:CABECALHO:C5_LOJACLI)),"A1_REDE") $cRedeOp,.T.,.F.)

	cTipCli		:= Posicione("SA1",1,FWxFilial("SA1") + Alltrim(cValToChar(oParseJSON:CABECALHO:C5_CLIENTE)) + Alltrim(cValToChar(oParseJSON:CABECALHO:C5_LOJACLI)),"A1_TIPO")

	Aadd(aCabec,{"C5_FILIAL", FWxFilial("SC5"), Nil}) 

	If nOpc == 4
		Aadd(aCabec,{"C5_NUM", oParseJSON:CABECALHO:C5_NUM, Nil})
		cNmBlq := oParseJSON:CABECALHO:C5_NUM

	Else
		Aadd(aCabec,{"C5_NUM", cNumPed, Nil})
		cNmBlq := cNumPed

	EndIf

	Aadd(aCabec,{"C5_TIPO"   ,oParseJSON:CABECALHO:C5_TIPO          ,Nil}) 
	Aadd(aCabec,{"C5_CLIENTE",oParseJSON:CABECALHO:C5_CLIENTE       ,Nil})
	Aadd(aCabec,{"C5_LOJACLI",oParseJSON:CABECALHO:C5_LOJACLI       ,Nil})
	Aadd(aCabec,{"C5_XPEDSAL",oParseJSON:CABECALHO:C5_XPEDSAL       ,Nil})
	Aadd(aCabec,{"C5_XPEDSAL",oParseJSON:CABECALHO:C5_XPEDSAL       ,Nil})
	Aadd(aCabec,{"C5_CONDPAG",oParseJSON:CABECALHO:C5_CONDPAG       ,Nil})
	
	//Everson - 27/12/2019 - Chamado T.I.
	If (SToD(oParseJSON:CABECALHO:C5_DTENTR) - dDataBase) > 20
		cData := Substr(DToS(dDataBase),1,4)+Substr(oParseJSON:CABECALHO:C5_DTENTR,5,10)

	Else
		cData := oParseJSON:CABECALHO:C5_DTENTR

	EndIf

	Aadd(aCabec,{"C5_VEND1"  ,cVendCdCli                            ,Nil}) 
	Aadd(aCabec,{"C5_DTENTR" ,SToD( cData )  						,Nil})
	Aadd(aCabec,{"C5_MOEDA"  ,oParseJSON:CABECALHO:C5_MOEDA         ,Nil})
	//Tkt 11762 - Adição do tipo do cliente na inclusão ou alteração.
	Aadd(aCabec,{"C5_TIPOCLI",cTipCli						        ,Nil})
	
	//Valida a remessa de venda a ordem na ZCI.
	If ! Empty(Alltrim(cValToChar(oParseJSON:cabecalho:C5_XPEDORD)))
		If Len(Alltrim(cValToChar(oParseJSON:cabecalho:C5_XPEDORD))) == 18
			cPedVendOrd := Alltrim(cValToChar(Posicione("ZCI",1,FWxFilial("ZCI") + Alltrim(cValToChar(oParseJSON:cabecalho:C5_XPEDORD)), "ZCI_NUMP")))
		Else
			cPedVendOrd := Alltrim(cValToChar(Posicione("ZCI",2,FWxFilial("ZCI") + Alltrim(cValToChar(oParseJSON:cabecalho:C5_XPEDORD)), "ZCI_NUMP")))
		EndIf
	Else
		cPedVendOrd := ""
	EndIf
			
	Aadd(aCabec,{"C5_XPEDORD",cPedVendOrd                          ,Nil})

	Aadd(aCabec,{"C5_OPLOG"  ,oParseJSON:CABECALHO:C5_OPLOG         ,Nil})
	Aadd(aCabec,{"C5_TABELA" ,oParseJSON:CABECALHO:C5_TABELA        ,Nil})
	Aadd(aCabec,{"C5_TPFRETE",oParseJSON:CABECALHO:C5_TPFRETE       ,Nil})

	Aadd(aCabec,{"C5_FRETAPV",oParseJSON:CABECALHO:C5_FRETAPV ,0 , Nil })
	Aadd(aCabec,{"C5_XIPTAB" ,oParseJSON:CABECALHO:C5_XIPTAB  ,0 , Nil })
	Aadd(aCabec,{"C5_TOTDIG" ,oParseJSON:CABECALHO:C5_TOTDIG  ,0 , Nil })
	Aadd(aCabec,{"C5_TOTTAB" ,oParseJSON:CABECALHO:C5_TOTTAB  ,0 , Nil })
	Aadd(aCabec,{"C5_DESCTBP",oParseJSON:CABECALHO:C5_DESCTBP ,0 , Nil })
	Aadd(aCabec,{"C5_VALORNF",oParseJSON:CABECALHO:C5_VALORNF ,0 , Nil })

	Aadd(aCabec,{"C5_MENNOTA",DecodeUTF8(Alltrim(cValToChar(oParseJSON:CABECALHO:C5_MENNOTA)))       ,Nil})
	Aadd(aCabec,{"C5_MENNOT2",DecodeUTF8(Alltrim(cValToChar(oParseJSON:CABECALHO:C5_MENNOT2)))       ,Nil})
	Aadd(aCabec,{"C5_MENNOT3",DecodeUTF8(Alltrim(cValToChar(oParseJSON:CABECALHO:C5_MENNOT3)))       ,Nil})
	Aadd(aCabec,{"C5_MENNOT4",DecodeUTF8(Alltrim(cValToChar(oParseJSON:CABECALHO:C5_MENNOT4)))       ,Nil})
	Aadd(aCabec,{"C5_MENNOT5",DecodeUTF8(Alltrim(cValToChar(oParseJSON:CABECALHO:C5_MENNOT5)))       ,Nil})
	//
	Aadd(aCabec,{"C5_XREDE" , oParseJSON:CABECALHO:C5_XREDE  ,Nil})
	Aadd(aCabec,{"C5_CODRED", oParseJSON:CABECALHO:C5_CODRED ,Nil})

	cRoteiro := ""
	Aadd(aCabec,{"C5_ROTEIRO ",  cRoteiro ,Nil})
	//
	Aadd(aCabec,{"C5_XEMSF", Val(cValToChar(oParseJSON:CABECALHO:C5_XEMSF))    ,0 , Nil })
	Aadd(aCabec,{"C5_XITSF", Val(cValToChar(oParseJSON:CABECALHO:C5_XITSF))    ,0 , Nil })

	Aadd(aCabec,{"C5_PBRUTO"  , Val(cValToChar(oParseJSON:CABECALHO:C5_PBRUTO))   ,0 , Nil })
	Aadd(aCabec,{"C5_PESOL"   , Val(cValToChar(oParseJSON:CABECALHO:C5_PESOL))    ,0 , Nil })
	Aadd(aCabec,{"C5_VOLUME1" , Val(cValToChar(oParseJSON:CABECALHO:C5_VOLUME1))  ,0 , Nil })

	Aadd(aCabec,{"C5_XTOTPED" , Val(cValToChar(oParseJSON:CABECALHO:C5_VALORNF))  ,0 , Nil })
	Aadd(aCabec,{"C5_XGERSF"  , "2"                              ,Nil})
	Aadd(aCabec,{"C5_XSFPED"  , oParseJSON:CABECALHO:C5_XSFPED 	 ,Nil})
	Aadd(aCabec,{"C5_XSFTP "  , Alltrim(cValToChar(oParseJSON:CABECALHO:tpSaida ))  ,Nil})

	//Everson - 30/10/2019. Chamado 052760.
	If nOpc == 3
		Aadd(aCabec,{"C5_XCONSIN "  ,cSintegra  ,Nil})

	EndIf 

	For i := 1 To Len(oParseJSON:ITENS)

		aItem    := {}         
		cProduto := Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_PRODUTO ))             	      
		nVlTot	 := (oParseJSON:ITENS[i]:C6_QTDVEN * oParseJSON:ITENS[i]:C6_PRCVEN)

		//Exclusão de item do pedido.
		If Upper(Alltrim(cValToChar(oParseJSON:ITENS[i]:excluir))) == "S" .Or. Val(cValToChar(oParseJSON:ITENS[i]:C6_UNSVEN)) <= 0 .Or. Val(cValToChar(oParseJSON:ITENS[i]:C6_QTDVEN)) <= 0 .And.!Empty(cValToChar(oParseJSON:ITENS[i]:C6_ITEM))			
			Loop

		Else

			If Alltrim(cValToChar(oParseJSON:CABECALHO:tpSaida )) $("VE|EF") //Venda e venda com data de entrega futura.
				//Aadd(aItem,{"C6_XOPSF", ""   , Nil })

			ElseIf Alltrim(cValToChar(oParseJSON:CABECALHO:tpSaida )) == "BO" //Bonificação.
				Aadd(aItem,{"C6_XOPSF", "04"   , Nil })

			ElseIf Alltrim(cValToChar(oParseJSON:CABECALHO:tpSaida )) == "VO" //Venda ordem.
				Aadd(aItem,{"C6_XOPSF", "X" , Nil }) 

			ElseIf Alltrim(cValToChar(oParseJSON:CABECALHO:tpSaida )) == "RO" //Remessa de venda ordem.
				Aadd(aItem,{"C6_XOPSF", "Y" , Nil })

			EndIf

			cItemPed := StrZero(nItemPed,2)

			If nOpc == 4
				Aadd(aItem,{"AUTDELETA","N", Nil}) 

			EndIf

			Aadd(aItem,{"C6_FILIAL" , FWxFilial("SC6")                , Nil}) 

			If nOpc == 4
				Aadd(aItem,{"C6_NUM"    , oParseJSON:CABECALHO:C5_NUM , Nil}) 

			Else
				Aadd(aCabec,{"C5_NUM"    ,cNumPed                     , Nil})

			EndIf

			Aadd(aItem,{"C6_ITEM"   , Padr(cItemPed,TamSX3("C6_ITEM")[1]," ") 	 , Nil })
			Aadd(aItem,{"C6_PRODUTO", Padr(cProduto,TamSX3("C6_PRODUTO")[1]," ") , Nil })
			Aadd(aItem,{"C6_UNSVEN" , oParseJSON:ITENS[i]:C6_UNSVEN  ,0       	 , Nil })
			Aadd(aItem,{"C6_PRCVEN" , oParseJSON:ITENS[i]:C6_PRCVEN  ,0       	 , Nil })
			Aadd(aItem,{"C6_VALOR"  , nVlTot                         ,0       	 , Nil }) 
			
			cTesCod := Alltrim(cValToChar(Posicione("SB1",1,FWxFilial("SB1") +  Padr(cProduto,TamSX3("C6_PRODUTO")[1]," "), "B1_TS" )))

			Conout( DToC(Date()) + " " + Time() + " ADVEN090P - RESTEXECUTE - cTesCod >>>>>>>>>>>> " + cTesCod)

			If ! Empty(cTesCod)
				Aadd(aItem,{"C6_TES",  cTesCod , Nil })

			EndIf
			
			Aadd(aItem,{"C6_QTDLIB"  , 0                         ,0       , Nil })			
			Aadd(aItem,{"C6_QTDEMP"  , 0                         ,0       , Nil })			
			Aadd(aItem,{"C6_QTDLIB2" , 0                         ,0       , Nil })
			Aadd(aItem,{"C6_QTDEMP2" , 0                         ,0       , Nil })

			Aadd(aItem,{"C6_QTDVEN" , oParseJSON:ITENS[i]:C6_QTDVEN  ,0   , Nil })		
			Aadd(aItem,{"C6_NFORI"  , oParseJSON:ITENS[i]:C6_NFORI   ,    , Nil })
			Aadd(aItem,{"C6_SERIORI", oParseJSON:ITENS[i]:C6_SERIORI ,    , Nil })			

			cPedidoPC := Iif( Empty(Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_PEDCLI ))), Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_NUMPCOM )) ,Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_PEDCLI )) )

			cPedidoPC := FwNoAccent( Substr( DecodeUTF8(Alltrim(cValToChar(cPedidoPC))) ,1, TamSX3("C6_PEDCLI")[1] ) ) //Everson - 15/03/2023. Ticket TI.

			If lRedeOp .And. cObrPdCp <> "1"
				Aadd(aItem,{"C6_PEDCLI" , cPedidoPC  ,  , Nil })
				Aadd(aItem,{"C6_NUMPCOM", "",  , Nil })
				Aadd(aItem,{"C6_ITEMPC" , ""  ,  , Nil })

			ElseIf cObrPdCp == "1" .And. ! lRedeOp
				Aadd(aItem,{"C6_NUMPCOM", cPedidoPC ,  , Nil })
				Aadd(aItem,{"C6_ITEMPC" , Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_ITEMPC))  ,  , Nil })			
				Aadd(aItem,{"C6_PEDCLI" , "" ,  , Nil })

			ElseIf cObrPdCp == "1" .And. lRedeOp
				Aadd(aItem,{"C6_NUMPCOM", cPedidoPC ,  , Nil })
				Aadd(aItem,{"C6_ITEMPC" , Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_ITEMPC))  ,  , Nil })			
				Aadd(aItem,{"C6_PEDCLI" , cPedidoPC ,  , Nil })

			Else
				Aadd(aItem,{"C6_PEDCLI" , cPedidoPC                      ,  , Nil }) //Everson - 22/03/2023 - ticket TI.
				Aadd(aItem,{"C6_NUMPCOM", oParseJSON:ITENS[i]:C6_NUMPCOM ,  , Nil })
				Aadd(aItem,{"C6_ITEMPC" , oParseJSON:ITENS[i]:C6_ITEMPC  ,  , Nil })

			EndIf

			Aadd(aItem,{"C6_VEND"   , cVendCdCli                     ,  , Nil })	

			//Everson - 24/09/2019. Chamado T.I.
			Aadd(aItem,{"C6_XIPTAB" , Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_XIPTAB),1,TamSX3("C6_XIPTAB")[1] )) ,0 , Nil })
			Aadd(aItem,{"C6_TOTDIG" , Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_TOTDIG),1,TamSX3("C6_TOTDIG")[1] )) ,0 , Nil })
			Aadd(aItem,{"C6_TOTTAB" , Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_TOTTAB),1,TamSX3("C6_TOTTAB")[1] )) ,0 , Nil })

			Aadd(aItem,{"C6_PRTABV" , Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_PRTABV),1,5 ))  ,0 , Nil })
			Aadd(aItem,{"C6_PBTTV"  , Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_PBTTV) ,1,5 ))  ,0 , Nil })
			Aadd(aItem,{"C6_PLTTV"  , Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_PLTTV) ,1,5 ))  ,0 , Nil })
			Aadd(aItem,{"C6_PLTVD"  , Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_PLTVD) ,1,5 ))  ,0 , Nil })
			Aadd(aItem,{"C6_PLTSP"  , Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_PLTSP) ,1,5 ))  ,0 , Nil }) 
			Aadd(aItem,{"C6_PLTAB"  , Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_PLTAB) ,1,5 ))  ,0 , Nil })

			cContaC     := Posicione("SB1",1,FWxFilial("SB1") + Alltrim(cValToChar(cProduto)),"B1_CONTA" )		
			cItemContaC := Posicione("SB1",1,FWxFilial("SB1") + Alltrim(cValToChar(cProduto)),"B1_ITEMCC" )

			// @history ticket 71057 - Fernando Macieira - 08/04/2022 - Item contábil Lançamentos da Filial 0B - Itapira
			If AllTrim(cEmpAnt) == "01" .and. AllTrim(cFilAnt) == "0B"
				cItemContaC := AllTrim(GetMV("MV_#ITACTD",,"125"))
			EndIf
			//

			Aadd(aItem,{"C6_CONTA"   , cContaC     ,0 , Nil })
			Aadd(aItem,{"C6_ITEMCTA" , cItemContaC ,0 , Nil })

			cLocPad := Iif(!RetArqProd(cProduto),POSICIONE("SBZ",1,FWxFilial("SBZ")+cProduto,"BZ_LOCPAD"),POSICIONE("SB1",1,FWxFilial("SB1")+cProduto,"B1_LOCPAD"))
		
			cPrdBlq := cLocPad + Alltrim(cValToChar(cProduto))

			Aadd(aTravaSB2, cPrdBlq)

			nItemPed++

		EndIf

		//Adiciona item ao vetor de itens.
		aAdd(aItens,aItem)

	Next i

	If nOpc == 3
		aSort(aItens, , , {|x, y| x[3][2] < y[3][2] })

	ElseIf nOpc == 4
		aSort(aItens, , , {|x, y| x[5][2] < y[5][2] })
		
	EndIf

	If nOpc == 4

		TCSqlExec(" UPDATE " + RetSqlName("SC9") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE C9_FILIAL = '" + FWxFilial("SC9") + "' AND C9_PEDIDO = '" + cNmBlq + "' AND D_E_L_E_T_ = '' ")
	
		//Marca todos os itens existentes para excluir.
		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		SC6->(DbGoTop())
		If SC6->(DbSeek( FWxFilial("SC6") + cNumPed ))

			While ! SC6->(Eof()) .And. SC6->C6_FILIAL == FWxFilial("SC6") .And. SC6->C6_NUM == cNumPed

				aItem := {} 
				Aadd(aItem,{"LINPOS","C6_ITEM",SC6->C6_ITEM})
				Aadd(aItem,{"AUTDELETA","S", Nil})        
				Aadd(aItem,{"C6_FILIAL" , FWxFilial("SC6") , Nil})  
				Aadd(aItem,{"C6_NUM"    , cNumPed        , Nil})          	      
				Aadd(aItem,{"C6_ITEM"   , SC6->C6_ITEM   , Nil})
				Aadd(aItem,{"C6_PRODUTO", SC6->C6_PRODUTO, Nil})
				Aadd(aItem,{"C6_QTDVEN" , SC6->C6_QTDVEN ,0 , Nil})
				Aadd(aItem,{"C6_PRCVEN" , SC6->C6_PRCVEN ,0 , Nil})
				Aadd(aItem,{"C6_VALOR"  , SC6->C6_VALOR  ,0 , Nil}) 
				Aadd(aItem,{"C6_UNSVEN" , SC6->C6_UNSVEN ,0 , Nil})

				aAdd(aItens,aItem)

				cLocPad := Iif(!RetArqProd(SC6->C6_PRODUTO),POSICIONE("SBZ",1,FWxFilial("SBZ")+SC6->C6_PRODUTO,"BZ_LOCPAD"),POSICIONE("SB1",1,FWxFilial("SB1")+SC6->C6_PRODUTO,"B1_LOCPAD"))

				cPrdBlq := cLocPad + Alltrim(cValToChar(SC6->C6_PRODUTO))

				If Ascan(aTravaSB2, cPrdBlq) <= 0
					Aadd(aTravaSB2, cPrdBlq)

				EndIf

				SC6->(DbSkip())

			EndDo

		EndIf

	EndIf

	//Ordena os campos conforme dicionário de dados.
	aCabec := FWVetByDic(aCabec,"SC5",.F.,1)

	If nOpc == 3
		aItens := FWVetByDic(aItens,"SC6",.T.,1)
		
	EndIf

	Asort(aTravaSB2)

	cErro := ""
	lMsErroAuto := .F.

	While ! lTrava .And. nAux < nCount

		lTrava := U_ADVEN900(aTravaSB2, oParseJSON:CABECALHO:C5_CLIENTE, oParseJSON:CABECALHO:C5_LOJACLI, Iif(nOpc == 4, cNmBlq, "")) 

		Conout( DToC(Date()) + " " + Time() + " ADVEN090P - RESTEXECUTE - " + cValToChar(cNmBlq) + " lTrava " + cValToChar(lTrava) )

		If ! lTrava
			cErro := "Não foi possível realizar MultLock"
			// U_ENVIAEMAIL(GetMv("MV_RELFROM"), cEmail, cErro + " Pedido " + cValToChar(cNmBlq), "Erro MultLock - RESTEXECUTE", "")
			Conout( DToC(Date()) + " " + Time() + " ADVEN090P - RESTEXECUTE - " + cValToChar(cNmBlq) + " " + cErro + cValToChar(nOpc) + " nAux " + cValToChar(nAux) )
			Sleep(300)
			// RestArea(aArea)
			// Return .F.

		Else
			Exit

		EndIf

		nAux++

	End

	If ! lTrava
		RestArea(aArea)
		Return .F.

	EndIf
	
	Begin Transaction //Transação existe por conta da validação de ZCI_NUMP X C5_NUM

		__CUSERID := cUsrVend
		Conout( DToC(Date()) + " " + Time() + " ADVEN090P - RESTEXECUTE - INÍCIO EXECAUTO >>>> " + cNumPed + " OPCAO " + cValToChar(nOpc) + " " + Time() )
		SetFunName("U_RESTEXECUTE")
		cHrIni := Time()
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, nOpc) 
		Conout( DToC(Date()) + " " + Time() + " ADVEN090P - RESTEXECUTE - FIM EXECAUTO >>>> " + cNumPed + " " + Time() +  " Tempo: " + ElapTime(cHrIni, Time()))
		__CUSERID := cBckUsr

		If lMsErroAuto    

			// cErro += MostraErro()


			lRet := .F.
			
			aErroLog := GetAutoGrLog()

			If Len(aErroLog) > 0
				cErro += EncodeUtf8(StrTran(StrTran(Alltrim(cValToChar(aErroLog[1])),Chr(13),""),Chr(10),""))

			EndIf

			nAuxInvalido := 0	

			For k := 1 to Len(aErroLog)

				If "INVALIDO" $ UPPER (aErroLog[k])
					cErro += EncodeUtf8(StrTran(StrTran(Alltrim(cValToChar(aErroLog[k])),Chr(13),""),Chr(10),""))
					nAuxInvalido++

				EndIf

			Next

			If nAuxInvalido == 0
				For k := 2 to Len(aErroLog)
					cErro += EncodeUtf8(StrTran(StrTran(Alltrim(cValToChar(aErroLog[k])),Chr(13),""),Chr(10),""))

				Next			

			EndIf

		Else

			DbSelectArea("SC6")
			SC6->(DbSetOrder(12))
			SC6->(DbGoTop())
			If SC6->(DbSeek( FWxFilial("SC6") + cNumPed ))

				i := 1
				While ! SC6->(Eof()) .And. SC6->C6_FILIAL == FWxFilial("SC6") .And. SC6->C6_NUM == cNumPed

					RecLock("SC6",.F.)
						SC6->C6_ITEM := StrZero(i,2)
					MsUnlock()

					SC6->(DbSkip())

					i++

				End

			EndIf

			If nOpc == 3 .And. cNumPed <> Alltrim(cValToChar(SC5->C5_NUM)) //Valida o número gerado.
				cErro += "Numeração divergente ZCI: " + cNumPed + " SC5: " + Alltrim(cValToChar(SC5->C5_NUM)) + "."
				DisarmTransaction()
				Break

			EndIf

			If lPedBloq

				TCSqlExec(" UPDATE " + RetSqlName("SC9") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE C9_FILIAL = '" + FWxFilial("SC9") + "' AND C9_PEDIDO = '" + cNmBlq + "' AND D_E_L_E_T_ = '' ")
				
				//Força bloqueio do pedido.
				RecLock("SC5",.F.)
					SC5->C5_BLQ     := "1"
					SC5->C5_LIBEROK := " "
				SC5->(MsUnlock())

			Else

				libPed(cNmBlq, @nQtdSC6, @nQtdSC9)

				//Valida quantidade SC6 e SC9.
				If nQtdSC9 <> nQtdSC6 
					cErro := "SC9 divergente de SC6"
					DisarmTransaction()
					Break

				EndIf

			EndIf

			lRet := .T.

		EndIf

	End Transaction 

	unlockAll()

	RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADVEN900
	Realiza lock virtual do registro e no banco.
	@type  Static Function
	@author Everson
	@since 11/08/2022
	@version 01
/*/
User Function ADVEN900(aTravaSB2, cCliente, cLoja, cNumPed)

    //Variáveis.
    Local aArea  := GetArea()
	Local lRet	 := .T.
	Local lLock	 := GetMv("MV_#VEN904",,.T.)

	If lLock .And. ! LockByName("ADVEN900", .T., .T.)
		RestArea(aArea)
		Conout( DToC(Date()) + " " + Time() + " ADVEN090P - ADVEN900 - função já está sendo utilizada")
		Return .F.

	EndIf


		If lRet .And. Len(aTravaSB2) > 0
			lRet := procLockar("SB2", aTravaSB2, 2)

		EndIf

		If lRet .And. ! Empty(cCliente) .And. ! Empty(cLoja)
			lRet := procLockar("SA1", { cCliente + cLoja }, 1) 

		EndIf
		
		If lRet .And. ! Empty(cNumPed)
			lRet := procLockar("SC5", { cNumPed }, 1)

		EndIf

	If lLock
		UnLockByName("ADVEN900", .T., .T.)

	EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} procLockar
	Processa lock virtual no registro.
	@type  Static Function
	@author Everson
	@since 11/08/2022
	@version 01
/*/
Static Function procLockar(cAlias, aChave, nOrd)

	//Variável.
    Local aArea  := GetArea()
    Local ni     := 0
    Local nj     := 0
    Local cPart1 := RetSqlname(cAlias) + FWxFilial(cAlias)
	Local lLock	 := .F.

	DbSelectArea(cAlias)
	(cAlias)->(DbSetOrder(nOrd))
	(cAlias)->(DbGoTop())
	
	For ni := 1 to Len(aChave)

		If ! (cAlias)->(DbSeek( FWxFilial(cAlias) + aChave[ni] ))
			Conout( DToC(Date()) + " " + Time() + " ADVEN090P - procLockar - chave não localizada " + FWxFilial(cAlias) + aChave[ni] )
			unlockAll()
			RestArea(aArea)
			//Return .F.
			Return .T. //Everson - 05/01/2023 - ticket TI.

		EndIf

		For nj := 1 to 3

			lLock := TCVLOCK(cPart1+aChave[ni]) .And. SimpleLock()

			If lLock
				__TTSPush := If(__TTSPush==nil,{},__TTSPush)
				Aadd(aRegLock, {cAlias, (cAlias)->( Recno())})
				PushRec(cAlias)
				Exit

			Else
				Conout( DToC(Date()) + " " + Time() + " ADVEN090P - procLockar - Não foi possivel locar " + cPart1+aChave[ni] )
				unlockAll()
				RestArea(aArea)
				Return .F.

			EndIf

		Next nj
		
	Next ni

Return .T.
/*/{Protheus.doc} unlockAll
	Desbloqueia registros.
	@type  Static Function
	@author Everson
	@since 27/02/2018
	@version 01
/*/
Static Function unlockAll()

	//Variáveis.
	Local aArea	 := GetArea()
	Local nAux   := 1
	Local cAlias := ""
	Local nRecno := ""

	If ! InTransact() .And. ! FwInTTSBreak()

		For nAux := 1 To Len(aRegLock)

			cAlias 	:= aRegLock[nAux][1]
			nRecno	:= aRegLock[nAux][2]

			DbSelectArea(cAlias)
			(cAlias)->(DbGoTop())
			(cAlias)->(DbGoTo(nRecno))

			MsrUnlock((cAlias)->(Recno()))

		Next nAux

		DBUnlockAll()

	EndIf
	
	aRegLock := {}
	
	MsUnlockAll()

	RestArea(aArea)

Return Nil
/*/{Protheus.doc} obtSeqSC6
	(long_description)
	@type  Static Function
	@author Everson
	@since 27/02/2018
	@version 01
/*/
Static Function obtSeqSC6(cPedido)

	//Variáveis.	
	Local cQuery := ""
	Local nSeq   := ""

	cQuery := ""
	cQuery += " SELECT"
	cQuery += " MAX(C6_ITEM) AS C6_ITEM"
	cQuery += " FROM"
	cQuery += " " + RetSqlName("SC6") + " AS SC6 (NOLOCK)"
	cQuery += " WHERE"
	cQuery += " C6_FILIAL = '" + FWxFilial("SC6") + "'"
	cQuery += " AND C6_NUM = '" + cPedido + "'"

	If Select("SEQ_SC6") > 0
		SEQ_SC6->(DbCloseArea())

	EndIf

	TcQuery cQuery New Alias "SEQ_SC6"
	DbSelectArea("SEQ_SC6")
	nSeq := Val(cValToChar(SEQ_SC6->C6_ITEM)) + 1
	SEQ_SC6->(DbCloseArea())

Return nSeq
/*/{Protheus.doc} chkLiber
	Efetua a liberação/bloqueio do pedido de venda. Chamado 037261.
	@type  Static Function
	@author Everson
	@since 09/05/2018
	@version 01
/*/
Static Function chkLiber(cNumPed, lPedBloq, lBlq, lProcessa, cErro, lTrava)

	//Variáveis.
	Local aArea 	:= GetArea()
	Local lRet		:= .F.
	Local nQtdSC6	:= 0
	Local nQtdSC9	:= 0
	Local aTravaSB2	:= {}
	Local cCliente 	:= ""
	Local cLoja	 	:= ""
	Local cHrIni	:= Time()
	Local nCount	:= GetMv("MV_#VEN900",,1)
	Local nAux		:= 0
	Local lLock		:= GetMv("MV_#VEN904",,.T.)

	Private lNvLib	 := GetMv("MV_#SFNVPR",,.F.)

	Default lBlq	 := .T.
	Default lProcessa:= .F.
	Default cErro	 := ""
	Default lTrava	 := .T.

	If lLock .And. ! LockByName("chkLiber", .T., .T.)
		RestArea(aArea)
		Conout( DToC(Date()) + " " + Time() + " ADVEN090P - chkLiber - função já está sendo utilizada")
		Return .F.

	EndIf

		Conout( DToC(Date()) + " " + Time() + " ADVEN090P - chkLiber - Início Liberação " + FWxFilial("SC5") + "-" + cNumPed)

		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		SC6->(DbGoTop())
		If SC6->(DbSeek(FWxFilial("SC6") + cNumPed))
			
			Aadd(aTravaSB2, SC6->C6_LOCAL + SC6->C6_PRODUTO)

			cCliente 	:= SC6->C6_CLI
			cLoja	 	:= SC6->C6_LOJA
		
		EndIf

		If ! lTrava 

			Asort(aTravaSB2)
		
			While ! lTrava .And. nAux < nCount

				lTrava := U_ADVEN900(aTravaSB2, cCliente, cLoja, cNumPed)

				Conout( DToC(Date()) + " " + Time() + " ADVEN090P - chkLiber - " + cValToChar(cNumPed) + " lTrava " + cValToChar(lTrava) )

				If ! lTrava
					cErro := "Não foi possível realizar MultLock"
					// U_ENVIAEMAIL(GetMv("MV_RELFROM"), cEmail, cErro + " Pedido " + cValToChar(cNumPed), "Erro MultLock - chkLiber", "")
					Conout( DToC(Date()) + " " + Time() + " ADVEN090P - chkLiber - " + cValToChar(cNumPed) + " " + cErro + " nAux " + cValToChar(nAux))
					// UnLockByName("chkLiber", .T., .T.)
					Sleep(300)
					// RestArea(aArea)
					// Return .F.

				Else
					Exit

				EndIf

				nAux++

			End

			If ! lTrava

				If lLock
					UnLockByName("chkLiber", .T., .T.)

				EndIf

				RestArea(aArea)
				Return .F.

			EndIf

		EndIf

		//Localiza pedido na tabela SC5.
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		SC5->(DbGoTop())
		If ! SC5->(DbSeek(FWxFilial("SC5") + cNumPed))
			cErro := "Liberação Não localizou o pedido " + cNumPed
			lProcessa := .F.

			If lLock
				UnLockByName("chkLiber", .T., .T.)

			EndIf

			// unlockAll()
			RestArea(aArea)
			Return .F.

		EndIf

		Begin Transaction

			If lPedBloq

				Conout(DToC(Date()) + " " + Time() + " ADVEN090P - chkLiber - Bloqueado " + FWxFilial("SC5") + "-" + cNumPed)

				TCSqlExec(" UPDATE " + RetSqlName("SC9") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE C9_FILIAL = '" + FWxFilial("SC9") + "' AND C9_PEDIDO = '" + cNumPed + "' AND D_E_L_E_T_ = '' ")

				//Força bloqueio do pedido.
				RecLock("SC5",.F.)
					SC5->C5_BLQ     := "1"
					SC5->C5_LIBEROK := " "
				SC5->(MsUnlock())

				lProcessa := .T.
				lRet := .T.

			Else

				libPed(cNumPed, @nQtdSC6, @nQtdSC9)

				//Valida quantidade SC6 e SC9.
				If nQtdSC9 <> nQtdSC6 
					cErro := "SC9 divergente de SC6"
					lProcessa := .F.
					lRet := .F.
					DisarmTransaction()
					Break

				EndIf

				lProcessa := .T.
				lRet := .T.

			EndIf

		End Transaction

		// unlockAll()

		Conout( DToC(Date()) + " " + Time() + " ADVEN090P - chkLiber - Liberação " + FWxFilial("SC5") + "-" + cNumPed + " Tempo " + ElapTime(cHrIni, Time()))

	If lLock
		UnLockByName("chkLiber", .T., .T.)

	EndIf

	RestArea(aArea)

Return lRet
/*/{Protheus.doc} libPed
	Processa liberaçã do pedido de venda.
	@type  Static Function
	@author Everson
	@since 15/08/2022
	@version 01
/*/
Static Function libPed(cNumPed, nQtdSC6, nQtdSC9)

	//Variáveis.
	Local nQtdLiber := 0
	Local lCredito  := .F.
	Local lEstoque  := .F.
	Local lAvCred   := .T.
	Local lAvEst    := .F.
	Local lLiber    := .F.
	Local lTrans    := .F.

	Conout( DToC(Date()) + " " + Time() + " ADVEN090P - libPed - Liberado " + FWxFilial("SC5") + "-" + cNumPed)

	//Força liberação do pedido.
	RecLock("SC5",.F.)
		SC5->C5_BLQ     := " "
		SC5->C5_LIBEROK := "S"
	SC5->(MsUnlock())

	TCSqlExec(" UPDATE " + RetSqlName("SC9") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE C9_FILIAL = '" + FWxFilial("SC9") + "' AND C9_PEDIDO = '" + cNumPed + "' AND D_E_L_E_T_ = '' ")

	nQtdSC6 := 0
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(DbGoTop())

	If  SC6->( DbSeek(FWxFilial("SC6") + cNumPed) )

		While ! SC6->(Eof()) .And. SC6->C6_FILIAL ==  FWxFilial("SC6") .And. SC6->C6_NUM == cNumPed

			nQtdLiber := SC6->C6_QTDVEN

			logZBE("Início MaLibDoFat - Liberação SC6 pedido " + cValToChar(SC6->C6_NUM), "Pedido " + cValToChar(SC6->C6_NUM) + " Recno " + cValToChar(SC6->( Recno())))

				RecLock("SC6")
					MaLibDoFat( SC6->( Recno() ), @nQtdLiber, @lCredito, @lEstoque, lAvCred, lAvEst, lLiber, lTrans )
				SC6->(MsUnLock())

			logZBE("Fim MaLibDoFat - Liberação SC6 pedido " + cValToChar(SC6->C6_NUM), "Pedido " + cValToChar(SC6->C6_NUM) + " Recno " + cValToChar(SC6->( Recno())))

			nQtdSC6++
			SC6->(DbSkip())

		End

	EndIf

	nQtdSC9 := 0
	DbSelectArea("SC9")
	SC9->(DbSetOrder(1))
	If SC9->( DbSeek( xfilial("SC9") + cNumPed) )
		While ! SC9->(Eof()) .And. SC9->C9_FILIAL == FWxFilial("SC9") .And. Alltrim(cValToChar(SC9->C9_PEDIDO)) == cNumPed

			Reclock("SC9",.F.)
				SC9->C9_ROTEIRO := SC5->C5_ROTEIRO
				SC9->C9_VEND1   := SC5->C5_VEND1
				SC9->C9_DTENTR  := SC5->C5_DTENTR
			SC9->(Msunlock())

			//Gera log na tabela ZBE.
			logZBE("Roteiro SC9 pedido " + cValToChar(SC9->C9_PEDIDO) , "Pedido " + cValToChar(SC9->C9_PEDIDO) + " Recno " + cValToChar(SC9->(Recno())))

			nQtdSC9++
			SC9->(Dbskip())

		Enddo
	EndIf

	//Gera log na tabela ZBE.
	logZBE("Quantidade SC6 ("+ cValToChar(nQtdSC6) +") x SC9 (" + cValToChar(nQtdSC9) + ") - SC5 pedido " + cNumPed, "Pedido " + cNumPed)

Return Nil
/*/{Protheus.doc} ³logZBN
	Gera log na ZBN. Chamado 037261;
	@type  Static Function
	@author Everson
	@since 09/05/2018
	@version 01
/*/
Static Function logZBN(cStatus)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaração de variávies.
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea	:= GetArea()

	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(FWxFilial("ZBN") + 'ADVEN090P'))

		RecLock("ZBN",.F.)

		ZBN_FILIAL  := FWxFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= 'ADVEN090P'
		ZBN_STATUS	:= cStatus

		MsUnlock() 

	Else

		RecLock("ZBN",.T.)

		ZBN_FILIAL  := FWxFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= 'ADVEN090P'
		ZBN_STATUS	:= cStatus

		MsUnlock() 	

	EndIf

	ZBN->(dbCloseArea())

	RestArea(aArea)

Return Nil
/*/{Protheus.doc} ³procCorte
	Efetua corte no pedido de venda. Chamado 037261.
	@type  Static Function
	@author Everson
	@since 11/05/2018
	@version 01
/*/
Static Function procCorte(oParseJSON, cPedido, lPedBloq)

	//Variáveis.
	Local aArea	:= GetArea()
	Local lRet	:= .T.
	Local i 	:= 1

	Begin transaction

		For i := 1 To Len(oParseJSON:ITENS)

			If Upper(Alltrim(cValToChar(oParseJSON:ITENS[i]:excluir))) == "S" .Or. Val(cValToChar(oParseJSON:ITENS[i]:C6_UNSVEN)) <= 0 .Or. Val(cValToChar(oParseJSON:ITENS[i]:C6_QTDVEN)) <= 0 .And.!Empty(cValToChar(oParseJSON:ITENS[i]:C6_ITEM))			
				Loop

			Else

				If ! SC6->( DbSeek( FWxFilial("SC6") + Alltrim(cValToChar( oParseJSON:ITENS[i]:C6_ITEM )) ) )
					lRet := .F.
					DisarmTransaction()
					RestArea(aArea)
					Break
					//Return lRet

				EndIf

				//Altera os dados.
				Reclock("SC6",.F.)

					SC6->C6_QTDVEN  := Val(cValToChar(oParseJSON:ITENS[i]:C6_QTDVEN))
					SC6->C6_UNSVEN  := Val(cValToChar(oParseJSON:ITENS[i]:C6_UNSVEN))
					SC6->C6_PRCVEN	:= Val(cValToChar(oParseJSON:ITENS[i]:C6_PRCVEN))
					SC6->C6_VALOR   := Val(cValToChar(oParseJSON:ITENS[i]:C6_QTDVEN)) * Val(cValToChar(oParseJSON:ITENS[i]:C6_PRCVEN))
					SC6->C6_QTDLIB  := 0
					SC6->C6_QTDLIB2 := 0
					SC6->C6_QTDEMP  := 0
					SC6->C6_QTDEMP2 := 0
					SC6->C6_PEDCLI  := FwNoAccent( Substr( DecodeUTF8(Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_PEDCLI))) ,1, TamSX3("C6_PEDCLI")[1] ) ) //Everson - 22/03/2023 - ticket TI.
					SC6->C6_NFORI   := Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_NFORI))
					SC6->C6_SERIORI	:= Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_SERIORI))	
					SC6->C6_NUMPCOM := Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_NUMPCOM))	
					SC6->C6_ITEMPC  := Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_ITEMPC))	

					SC6->C6_XIPTAB  := Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_XIPTAB),1,TamSX3("C6_XIPTAB ")[1]))
					SC6->C6_TOTDIG  := Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_TOTDIG),1,TamSX3("C6_TOTDIG")[1] ))
					SC6->C6_TOTTAB  := Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_TOTTAB),1,TamSX3("C6_TOTTAB")[1]))

					SC6->C6_PRTABV  := Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_PRTABV),1,5))
					SC6->C6_PBTTV   := Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_PBTTV) ,1,5))
					SC6->C6_PLTTV   := Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_PLTTV) ,1,5))
					SC6->C6_PLTVD   := Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_PLTVD) ,1,5))
					SC6->C6_PLTSP   := Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_PLTSP) ,1,5))
					SC6->C6_PLTAB   := Val( Substr(cValToChar(oParseJSON:ITENS[i]:C6_PLTAB) ,1,5))

				SC6->(Msunlock())

			EndIf

		Next i

	End Transaction

	RestArea(aArea)

Return lRet
/*/{Protheus.doc} checkProc
	Checa qual processamento deve ser executado para o pedido.
	1- Execauto de alteração, 2-Liberação comercial 3-Corte
	@type  Static Function
	@author Everson
	@since 11/05/2018
	@version 01
/*/
Static Function checkProc(oParseJSON,cPedido)

	//Variáveis.	
	Local aArea	:= GetArea()
	Local nRet	:= 0
	Local lCab	:= .F.
	Local nItens:= 0

	//Verifica se o cabeçalho recebido é igual ao que consta no Protheus.	
	lCab := comparaCab(oParseJSON,cPedido)
	If ! lCab
		nRet := 1
		RestArea(aArea)
		Return nRet

	EndIf

	//Verifica se os itens recebidos são iguais aos que constam no Protheus.	
	nItens := comparaItens(oParseJSON,cPedido)

	//Valida se é liberação de pedido de venda.
	If lCab .And. nItens == 1
		nRet := 2

	EndIf

	//Valida se é ajuste na quantidade do pedido de venda.
	If lCab .And. nItens == 2
		nRet := 3

	EndIf	

	If nRet == 0
		nRet := 1

	EndIf

	RestArea(aArea)

Return nRet
/*/{Protheus.doc} comparaCab
	Compara json do cabeçalho do pedido de venda. Chamado 037261.
	@type  Static Function
	@author Everson
	@since 10/05/2018
	@version 01
/*/
Static Function comparaCab(oParseJSON,cPedido)

	//Variáveis.
	Local aArea	  := GetArea()
	Local cJsonSF := ""
	Local cJsonPr := ""
	Local lRet    := .F.
	Local cData	  := "" //Everson - 28/12/2019 - Chamado T.I.

	//Monta string do SalesForce.
	cJsonSF += Alltrim(cValToChar(oParseJSON:CABECALHO:C5_TIPO)) +"_"

	cJsonSF += Alltrim(cValToChar(oParseJSON:CABECALHO:C5_CLIENTE)) +"_"

	cJsonSF += Alltrim(cValToChar(oParseJSON:CABECALHO:C5_LOJACLI)) +"_"

	//Everson - 28/12/2019 - Chamado T.I.
	If (SToD(oParseJSON:CABECALHO:C5_DTENTR) - dDataBase) > 20
		cData := Substr(DToS(dDataBase),1,4)+Substr(oParseJSON:CABECALHO:C5_DTENTR,5,10)

	Else
		cData := oParseJSON:CABECALHO:C5_DTENTR

	EndIf

	cJsonSF += DToS(SToD(Alltrim(cValToChar(cData)))) +"_"

	cJsonSF += Alltrim(cValToChar(oParseJSON:CABECALHO:C5_MOEDA)) +"_"

	cJsonSF += Alltrim(cValToChar(oParseJSON:CABECALHO:C5_XPEDORD)) +"_"

	cJsonSF += Alltrim(cValToChar(oParseJSON:CABECALHO:C5_OPLOG)) +"_"

	cJsonSF += Alltrim(cValToChar(oParseJSON:CABECALHO:C5_TPFRETE)) +"_"

	cJsonSF += Alltrim(cValToChar(oParseJSON:CABECALHO:C5_FRETAPV)) +"_"

	cJsonSF += Alltrim(cValToChar( Round(oParseJSON:CABECALHO:C5_VALORNF,2) )) +"_"
	
	cJsonSF += FwNoAccent( Substr( DecodeUTF8(Alltrim(cValToChar(oParseJSON:CABECALHO:C5_MENNOTA))) ,1, TamSX3("C5_MENNOTA")[1] ) ) +"_"

	cJsonSF += FwNoAccent( Substr( DecodeUTF8(Alltrim(cValToChar(oParseJSON:CABECALHO:C5_MENNOT2)))  ,1, TamSX3("C5_MENNOT2")[1] ) )  +"_"

	cJsonSF += FwNoAccent( Substr( DecodeUTF8(Alltrim(cValToChar(oParseJSON:CABECALHO:C5_MENNOT3)))  ,1, TamSX3("C5_MENNOT3")[1] ) )  +"_"

	cJsonSF += FwNoAccent( Substr( DecodeUTF8(Alltrim(cValToChar(oParseJSON:CABECALHO:C5_MENNOT4)))  ,1, TamSX3("C5_MENNOT4")[1] ) )  +"_"

	cJsonSF += FwNoAccent( Substr( DecodeUTF8(Alltrim(cValToChar(oParseJSON:CABECALHO:C5_MENNOT5)))  ,1, TamSX3("C5_MENNOT5")[1] ) )  +"_"
	cJsonSF += Alltrim(cValToChar(oParseJSON:CABECALHO:C5_XREDE)) +"_"

	cJsonSF += Alltrim(cValToChar(oParseJSON:CABECALHO:C5_CODRED)) +"_"

	cJsonSF += Alltrim(cValToChar( Round(oParseJSON:CABECALHO:C5_VALORNF,2) )) +"_"

	cJsonSF += Alltrim(cValToChar(oParseJSON:CABECALHO:C5_CONDPAG)) +"_"

	//Monta string do Protheus
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek( FWxFilial("SC5") + cPedido))
		cJsonPr += Alltrim(cValToChar(SC5->C5_TIPO)) +"_"

		cJsonPr += Alltrim(cValToChar(SC5->C5_CLIENTE)) +"_"

		cJsonPr += Alltrim(cValToChar(SC5->C5_LOJACLI)) +"_"

		cJsonPr += Alltrim(cValToChar(DToS(SC5->C5_DTENTR))) +"_"

		cJsonPr += Alltrim(cValToChar(SC5->C5_MOEDA)) +"_"

		cJsonPr += Alltrim(cValToChar(SC5->C5_XPEDORD)) +"_"

		cJsonPr += Alltrim(cValToChar(SC5->C5_OPLOG)) +"_"

		cJsonPr += Alltrim(cValToChar(SC5->C5_TPFRETE)) +"_"

		cJsonPr += Alltrim(cValToChar(SC5->C5_FRETAPV)) +"_"

		cJsonPr += Alltrim(cValToChar(SC5->C5_VALORNF)) +"_"

		cJsonPr += FwNoAccent( Substr( Alltrim(cValToChar(SC5->C5_MENNOTA)) ,1, TamSX3("C5_MENNOTA")[1] ) ) +"_"

		cJsonPr += FwNoAccent( Substr( Alltrim(cValToChar(SC5->C5_MENNOT2)) ,1, TamSX3("C5_MENNOT2")[1] ) ) +"_"

		cJsonPr += FwNoAccent( Substr( Alltrim(cValToChar(SC5->C5_MENNOT3)) ,1, TamSX3("C5_MENNOT3")[1] ) ) +"_"

		cJsonPr += FwNoAccent( Substr( Alltrim(cValToChar(SC5->C5_MENNOT4)) ,1, TamSX3("C5_MENNOT4")[1] ) ) +"_"

		cJsonPr += FwNoAccent( Substr( Alltrim(cValToChar(SC5->C5_MENNOT5)) ,1, TamSX3("C5_MENNOT5")[1] ) ) +"_"

		cJsonPr += Alltrim(cValToChar(SC5->C5_XREDE)) +"_"

		cJsonPr += Alltrim(cValToChar(SC5->C5_CODRED)) +"_"

		cJsonPr += Alltrim(cValToChar(SC5->C5_VALORNF)) +"_"

		cJsonPr += Alltrim(cValToChar(SC5->C5_CONDPAG)) +"_"

	EndIf

	//Verifica se o cabeçalho recebido é igual ao que consta no Protheus.	
	If cJsonPr == cJsonSF
		lRet := .T.

	Else

		logZBE("CABECALHO DIVERGE " + cPedido, "PRO: " + cJsonPr)
		logZBE("CABECALHO DIVERGE " + cPedido, "SFC: " + cJsonSF)

	EndIf

	cJsonPr := ""
	cJsonSF := ""

	RestArea(aArea)

Return lRet
/*/{Protheus.doc} comparaItens
	Compara json dos itens do pedido de venda. Chamado 037261.
	@type  Static Function
	@author Everson
	@since 11/05/2018 
	@version 01
/*/
Static Function comparaItens(oParseJSON,cPedido)

	//Variáveis.	
	Local aArea		:= GetArea()
	Local nRet		:= 0
	Local i			:= 1
	Local cJsonSF	:= ""
	Local cJsonPr	:= ""

	DbSelectArea("SC6")
	SC6->(DbSetOrder(12))
	SC6->(DbGoTop())

	For i := 1 To Len(oParseJSON:ITENS)

		If Upper(Alltrim(cValToChar(oParseJSON:ITENS[i]:excluir))) == "S" .Or. Val(cValToChar(oParseJSON:ITENS[i]:C6_UNSVEN)) <= 0 .Or. Val(cValToChar(oParseJSON:ITENS[i]:C6_QTDVEN)) <= 0 .And.!Empty(cValToChar(oParseJSON:ITENS[i]:C6_ITEM))			
			Loop

		Else

			If ! SC6->( DbSeek( FWxFilial("SC6") + Alltrim(cValToChar( oParseJSON:ITENS[i]:C6_ITEM )) ) )

				logZBE("ITEM NAO ENCONTRADO " + cPedido, "ITEM SF: " + Alltrim(cValToChar( oParseJSON:ITENS[i]:C6_ITEM )))
				RestArea(aArea)
				nRet := 0
				Return nRet

			EndIf

			//Monta string SalesForce.
			cJsonSF += Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_PRODUTO)) +"_"
			cJsonSF += Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_UNSVEN))  +"_"
			cJsonSF += Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_PRCVEN))  +"_"
			//cJsonSF += Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_QTDVEN))  +"_"		
			cJsonSF += FwNoAccent( Substr( Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_PEDCLI)), 1, TamSX3("C6_PEDCLI")[1]) )   +"_"
			//cJsonSF += Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_PEDCLI))  +"_"
			cJsonSF += Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_NFORI))   +"_"
			cJsonSF += Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_SERIORI)) +"_"			
			cJsonSF += FwNoAccent( Substr( Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_NUMPCOM)), 1, TamSX3("C6_NUMPCOM")[1]) ) +"_"
			//cJsonSF += Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_NUMPCOM)) +"_"
			cJsonSF += FwNoAccent( Substr( Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_ITEMPC)), 1, TamSX3("C6_ITEMPC")[1]) )   +"_"
			//cJsonSF += Alltrim(cValToChar(oParseJSON:ITENS[i]:C6_ITEMPC))  +"_"

			//Monta string Protheus.
			cJsonPr += Alltrim(cValToChar(SC6->C6_PRODUTO)) +"_"
			cJsonPr += Alltrim(cValToChar(SC6->C6_UNSVEN))  +"_"
			cJsonPr += Alltrim(cValToChar(SC6->C6_PRCVEN))  +"_"
			//cJsonPr += Alltrim(cValToChar(SC6->C6_QTDVEN))	+"_"	
			cJsonPr += FwNoAccent( Substr( Alltrim(cValToChar(SC6->C6_PEDCLI)), 1, TamSX3("C6_PEDCLI")[1]) )    +"_"
			cJsonPr += Alltrim(cValToChar(SC6->C6_NFORI))   +"_"
			cJsonPr += Alltrim(cValToChar(SC6->C6_SERIORI)) +"_"			
			cJsonPr += FwNoAccent( Substr( Alltrim(cValToChar(SC6->C6_NUMPCOM)), 1, TamSX3("C6_NUMPCOM")[1]) )  +"_"
			cJsonPr += FwNoAccent( Substr( Alltrim(cValToChar(SC6->C6_ITEMPC)), 1, TamSX3("C6_ITEMPC")[1]) )	+"_"

			If cJsonSF <> cJsonPr

				logZBE("ITEM DIFERENTE " + cPedido, "PR: " + cJsonPr + " SF: " + cJsonSF)

				RestArea(aArea)
				nRet := 0
				Return nRet

			EndIf

			cJsonSF := ""
			cJsonPr := ""

		EndIf

	Next i

	nRet := 1

	RestArea(aArea)

Return nRet
/*/{Protheus.doc} updStPut
	Executa update nos registros PUT pendentes. Chamado 037261.
	@type  Static Function
	@author Everson
	@since 11/05/2018 
	@version 01
/*/
Static Function updStPut(cPedido,cRecno)

	TCSqlExec("UPDATE " + RetSqlName("ZCI") + " SET ZCI_TMPR = 'DESCARTA' WHERE ZCI_FILIAL = '" + cFilAnt + "' AND ZCI_TMPR = 'PENDPROC' AND ZCI_NUMP = '" + cPedido + "' AND ZCI_TMPR = 'PENDPROC' AND ZCI_METD = 'PUT' AND D_E_L_E_T_ = '' AND R_E_C_N_O_ < '" + cRecno + "'")			

Return Nil
/*/{Protheus.doc} cSqlScript
	Script sql processamento ZCI. Chamado 037261.
	@type  Static Function
	@author Everson
	@since 13/05/2018
	@version 01
/*/
Static Function cSqlScript(cRecnos)

	//Variáveis.	
	Local cQuery := ""

	cQuery += " SELECT ZCI_FILIAL, ZCI_NUMP, R_E_C_N_O_ AS REC, ZCI_METD, ZCI_TPALT, ZCI_CONSIN "
	cQuery += " FROM "
	cQuery += " " + RetSqlName("ZCI") + " AS ZCI "
	cQuery += " WHERE "
	cQuery += " R_E_C_N_O_ IN (" + cRecnos + ") "

Return cQuery
/*/{Protheus.doc} ADVEN902
	MsExecauto pedido de venda (exclusão). Chamado 037261.
	@type  User Function
	@author Everson
	@since 06/06/2018
	@version 01
/*/
User Function ADVEN902(cErro, cNumPed, lTrava) //Everson - 25/01/2023 - ticket 18465.

	//Variáveis.
	Local aArea			:= GetArea()
	Local lRet			:= .F.	
	Local cDoc			:= ""
	Local aCabec		:= {}
	Local aItens		:= {}
	Local aItem			:= {}
	Local aErroLog		:= {}
	Local k				:= 1
	Local nAuxInvalido	:= 0

	Private nVlrCred		:= 0
	Private lMsErroAuto		:= .F.
	Private lAutoErrNoFile 	:= .T.

	Default cErro		:= ""
	Default lTrava		:= .T.

	cErro := ""
	If ! chkLiber(cNumPed, .T., .F., , , @lTrava)
		unlockAll()
		cErro := "Falha chkLiber para o pedido de venda número " + cNumPed + "."
		RestArea(aArea)
		Return .F.

	EndIf

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbGoTop())
	If ! SC5->(DbSeek(FWxFilial("SC5") + cNumPed))
		RestArea(aArea)
		Return .T.

	EndIf

	// Monta cabeçalho do pedido de venda.
	aCabec := {}
	Aadd(aCabec,{"C5_FILIAL" , FWxFilial("SC5")    ,Nil})           
	Aadd(aCabec,{"C5_NUM"    , SC5->C5_NUM         ,Nil})
	Aadd(aCabec,{"C5_TIPO"   , SC5->C5_TIPO        ,Nil}) 
	Aadd(aCabec,{"C5_CLIENTE", SC5->C5_CLIENTE     ,Nil})
	Aadd(aCabec,{"C5_LOJACLI", SC5->C5_LOJACLI     ,Nil}) 
	Aadd(aCabec,{"C5_DTENTR" , SToD(cValToChar(SC5->C5_DTENTR)) ,Nil})

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(DbGoTop())
	If ! SC6->(DbSeek(FWxFilial("SC6") + cNumPed))
		cErro := "Pedido de venda número " + cNumPed + " não encontrado(montagem dos itens)."
		RestArea(aArea)
		Return .F.

	EndIf

	While ! SC6->(Eof()) .And. SC6->C6_FILIAL == FWxFilial("SC6") .And. SC6->C6_NUM == cNumPed

		aItem := {} 
		Aadd(aItem,{"LINPOS","C6_ITEM",SC6->C6_ITEM})
		Aadd(aItem,{"AUTDELETA","S", Nil})        
		Aadd(aItem,{"C6_FILIAL" , FWxFilial("SC6") , Nil})  
		Aadd(aItem,{"C6_NUM"    , cNumPed        , Nil})          	      
		Aadd(aItem,{"C6_ITEM"   , SC6->C6_ITEM   , Nil})
		Aadd(aItem,{"C6_PRODUTO", SC6->C6_PRODUTO, Nil})
		Aadd(aItem,{"C6_QTDVEN" , SC6->C6_QTDVEN ,0 , Nil})
		Aadd(aItem,{"C6_PRCVEN" , SC6->C6_PRCVEN ,0 , Nil})
		Aadd(aItem,{"C6_VALOR"  , SC6->C6_VALOR  ,0 , Nil}) 
		Aadd(aItem,{"C6_UNSVEN" , SC6->C6_UNSVEN ,0 , Nil})

		aAdd(aItens,aItem)

		SC6->(DbSkip())

	End

	cErro := ""
	lMsErroAuto := .F.

	//Localiza o pedido na tabela SC9 e faz o estorno dos itens.
	DbSelectArea("SC9")
	SC9->(DbSetOrder(1))
	SC9->(DbGoTop())
	If SC9->(DbSeek(FWxFilial("SC9") + cNumPed))

		//Faz o estorno dos itens liberados.
		While Alltrim(cValToChar(SC9->C9_FILIAL)) == FWxFilial("SC9") .And.;
		Alltrim(cValToChar(SC9->C9_PEDIDO)) == cNumPed

			nVlrCred := 0

			SC9->(A460Estorna(/*lMata410*/,/*lAtuEmp*/,@nVlrCred))

			SC9->(DbSkip())

		EndDo

	EndIf	

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(DbGoTop())
	If SC6->(DbSeek(FWxFilial("SC6") + cNumPed ))

		//Zera quantidade liberada.
		While Alltrim(cValToChar(SC6->C6_FILIAL)) == FWxFilial("SC6") .And.;
		Alltrim(cValToChar(SC6->C6_NUM)) == cNumPed

			RecLock("SC6",.F.)
				SC6->C6_QTDLIB	:= 0			
				SC6->C6_QTDEMP	:= 0	
				SC6->C6_QTDLIB2	:= 0
				SC6->C6_QTDEMP2	:= 0     
			SC6->(MsUnlock())

			SC6->(DbSkip())

		EndDo

	EndIf

	MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, 5) 

	If lMsErroAuto

		cErro += MostraErro()

		lRet := .F.
		
		aErroLog := GetAutoGrLog()

		If Len(aErroLog) > 0
			cErro += EncodeUtf8(StrTran(StrTran(Alltrim(cValToChar(aErroLog[1])),Chr(13),""),Chr(10),""))

		EndIf

		nAuxInvalido := 0			
		For k := 1 to Len(aErroLog)

			If "INVALIDO" $ UPPER (aErroLog[k])
				cErro += EncodeUtf8(StrTran(StrTran(Alltrim(cValToChar(aErroLog[k])),Chr(13),""),Chr(10),""))
				nAuxInvalido++

			EndIf

		Next

		If nAuxInvalido == 0
			For k := 2 to Len(aErroLog)
				cErro += EncodeUtf8(StrTran(StrTran(Alltrim(cValToChar(aErroLog[k])),Chr(13),""),Chr(10),""))

			Next			

		EndIf

	Else
		cNumPed := cDoc
		lRet := .T.

	EndIf

	RestArea(aArea)

Return lRet
/*/{Protheus.doc} logZBE
	Gera log na tabela ZBE.
	@type  Static Function
	@author user
	@since 11/02/2022
	@version 01
/*/
Static Function logZBE(cLog, cParam, cMemo)
	
	//Variáveis.
	Default cParam	:= ""
	Default cMemo	:= ""

	DbSelectArea("ZBE")
	RecLock("ZBE",.T.)
		Replace ZBE_FILIAL 	   	With FWxFilial("ZBE")
		Replace ZBE_DATA 	   	With dDataBase
		Replace ZBE_HORA 	   	With Time()
		Replace ZBE_USUARI	    With "JOBPROC " + cValToChar(ThreadId())
		Replace ZBE_LOG	        With cLog
		Replace ZBE_MODULO	    With "COMERCIAL"
		Replace ZBE_ROTINA	    With "ADVEN090P" 
		Replace ZBE_PARAME      With cParam
		Replace ZBE_LOGMEM      With cMemo
	ZBE->( MsUnLock())

Return Nil
/*/{Protheus.doc} u_VEN090A0
Ticket 70142 - Substituicao de funcao Static Call por User Function MP 12.1.33
@type function
@version 1.0
@author Edvar   / Flek Solution
@since 16/03/2022
@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
/*/
Function u_VEN090A0( uPar1, uPar2 )

	Local lRet := chkLiber( uPar1, uPar2 )

	unlockAll()

Return lRet
