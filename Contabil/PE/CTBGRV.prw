#Include "Protheus.Ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function CTBGRV
	PE para executar procedimento de usu�rio ap�s a grava��o do lan�amento cont�bil.
	Utilizado para efetuar o rastreamento dos lancamentos.
	Gravando as informacoes em campos customizados da CT2.
	@type  Function
	@author Ana Helena Barreta 
	@since 10/06/2013
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history Chamado 037647 - Ricardo Lima      - 27/11/2018 - Empresa 07 - Grava lote de cria��o com origem do PC
	@history Chamado 047931 - FWNM              - 20/03/2019 - OS 049195 || CONTROLADORIA || ANDRESSA || 45968437 || C.CUSTO X LOTE -RNX2
	@history Chamado 048129 - FWNM              - 03/06/2019 - OS 049388 || FISCAL || ALLAN || 8394 || CENTRAL XML - RATEIO
	@history Chamado 048047 - FWNM              - 11/06/2019 - OS 049306 || CONTROLADORIA || ANA_CAROLINA || 8464 || LP 596/597/588/589 COM CT2_ORIGEM ERRADA
	@history Chamado 051550 - FWNM              - 26/09/2019 - OS 052878 || CONTROLADORIA || MONIK_MACEDO || 8956 || INDEXADORES
	@history Chamado 054198 - FWNM              - 16/12/2019 - OS 055597 || CONTROLADORIA || THIAGO || 8439 || LP - 666-002
	@history Chamado 056799 - FWNM              - 19/03/2020 - || OS 058253 || CONTROLADORIA || FELIPE_CAPOVILA || 8464 || INDEXADORES CERES
	@history Chamado 058353 - Abel Babini       - 13/07/2020 - Adiciona fun��o FINA740/FINA460 para criar os indexadores na rotina de fun��es contas a receber
	@history Chamado 1438   - Wiliam Costa      - 16/09/2020 - Analisado que tinha duas regras para o LP 596 e 588, retirado de um lugar, ajustado em outro, pois os indexadores de NCC estavam vindo todos errados.
	@history ticket  1438   - FWNM              - 21/10/2020 - Indexadores de NCC incorretos
	@history ticket  2388   - FWNM              - 06/11/2020 - Requisi��o - Lan�amentos que custos da RNX2 e Safegg
	@history ticket  2388   - FWNM              - 06/11/2020 - Requisi��o - Lan�amentos que custos da RNX2 e Safegg
	@history ticket  5949   - Fernando Macieira - 10/12/2020 - Projeto - RM - CT2_SEQLAN - Raz�o Cont�bil concatena hist�ricos
	@history ticket  8938   - Fernando Macieira - 03/02/2021 - Hist�rico de Lan�amentos Origem Lote Folha bagun�ados no raz�o
	@history ticket  9307   - Abel Babini       - 15/02/2021 - Acrescentar indesxadores para rotinas do Ativo de Baixas e Transfer�ncias
	@history ticket 65263   - Fernando Macieira - 24/01/2022 - numero/nome da granja na contabiliza��o da deprecia��o
	@history ticket 72053   - Fernando Macieira - 05/05/2022 - INDEXADORES TROCADOS
	@history ticket 72858   - Fernando Macieira - 18/05/2022 - Lote 008870 - Deprecia��o deixa alterar o campo lote x cc mas nao assume a altera��o
	@history ticket 72835   - Abel Babini		- 30/05/2022 - Executa libera��o de pedidos do cliente ap�s baixas realizadas.
	@history Ticket 70142   - Rodrigo Mello/Flek- 10/06/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	@history ticket 73451   - Fernando Macieira - 04/07/2022 - Padroniza��o lote RM
	@history ticket 77295   - Fernando Macieira - 26/08/2022 - A INTEGRA��O DE CONTABILIZA��O DA CERES N�O ESTA FUNCIONANDO
	@history ticket 83115   - Antonio Domingos  - 26/08/2022 - Diferen�a nos indicadores nos lan�amentos de compensa��es de ciente e ncc de filiais diferentes..
	@history ticket 83115   - Antonio Domingos  - 26/08/2022 - Diferen�a nos indicadores nos lan�amentos de compensa��es de ciente e ncc de filiais diferentes.
	@history ticket 84225   - 12/01/2023 - Fernando Macieira - Altera��o da Regra de lan�amento de deprecia��o para inclus�o de lote X CC e Descri Lote
	@history ticket 89227 - 03/04/2023 - Fernando Macieira - Diferen�a nos indicadores nos lan�amentos de compensa��es de ciente e ncc de filiais diferentes
	@history ticket 90838 - 03/04/2023 - Fernando Macieira - TRANSFERENCIA DE ITENS DE ALMOXARIFADO - MATRIZES
    @history ticket 93088 - Antonio Domingos - 02/05/2023 - invalid field name in Alias SD1->D1_XLOTECC on NEWLOTEZCN(CTBGRV.PRW) 25/04/2023 15:54:55 line : 1989
    @history ticket 93253 - 04/05/2023 - Fernando Macieira - PROBLEMA NA INTEGRA��O - FATURAMENTO CERES
	@history ticket TI - Antonio Domingos - 20/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 23/05/2023 - Revis�o Ajuste Nova Empresa
/*/
User Function CTBGRV()

	Private _cEmpAt4 := SuperGetMv("MV_#EMPAT4",.F.,"01/02/07/09/13") //Codigo de Empresas Ativas Grupo 4 //ticket TI - Antonio Domingos - 17/05/2023
	
	// @history ticket 73451   - Fernando Macieira - 04/07/2022 - Padroniza��o lote RM
	//Local cLtFolha := GetMV("MV_#LOTERM",,"008890") 
	//Local lLockCTF := .t.
	//

	//If .not. cEmpAnt $ "01 02 07 09"    // Chamado n. 051550 || OS 052878 || CONTROLADORIA || MONIK_MACEDO || 8956 || INDEXADORES - fwnm - 26/09/2019 (conforme email da Monik/Wilson autorizando ap�s nosso questionamento antecipado)
	If .not. cEmpAnt $ _cEmpAt4   //ticket TI - Antonio Domingos - 20/05/2023 
		Return
	Endif

	// ticket 84085 - 01/12/2022 - Fernando Macieira - TRANSFERENCIA DE ATIVO IMOBILIZADO nota fiscal n�o aparece no Faturamento
	If AllTrim(FUNNAME())=="ATFA060" .or. IsInCallStack("ATFA060")
		Return
	EndIf
	              
	//Op��o para lan�amento (3-Inclus�o; 4-Alterac�o;5-Exclus�o).
	nOpcLct := ParamIxb[1]
	nProgra := ParamIxb[2]
	
	Private _aAreaSE1	:=SE1->(GetArea())
	Private _aAreaSE2	:=SE2->(GetArea())
	Private _aAreaSE5	:=SE5->(GetArea())
	Private _aAreaSD1	:=SD1->(GetArea())
	Private _aAreaSF1	:=SF1->(GetArea())
	Private _aAreaSD2	:=SD2->(GetArea())
	Private _aAreaSF2	:=SF2->(GetArea()) //ticket  9307   - Abel Babini       - 15/02/2021 - Acrescentar indesxadores para rotinas do Ativo de Baixas e Transfer�ncias
	
	//@history ticket  5949   - Fernando Macieira - 10/12/2020 - Projeto - RM - CT2_SEQLAN - Raz�o Cont�bil concatena hist�ricos
	//@history ticket  8938   - Fernando Macieira - 03/02/2021 - Hist�rico de Lan�amentos Origem Lote Folha bagun�ados no raz�o
	If AllTrim(CT2->CT2_SEQLAN) <> AllTrim(CT2->CT2_LINHA)
		RecLock("CT2", .F.)
			CT2->CT2_SEQLAN := AllTrim(CT2->CT2_LINHA)
		CT2->( msUnLock() )
	EndIf
	//

	// 	@history ticket 77295   - Fernando Macieira - 26/08/2022 - A INTEGRA��O DE CONTABILIZA��O DA CERES N�O ESTA FUNCIONANDO
	/*
	//@history ticket 73451   - Fernando Macieira - 04/07/2022 - Padroniza��o lote RM
	If AllTrim(CT2->CT2_ORIGEM) == "CTBI102" //.or. CT2->CT2_LOTE='******' .or. AllTrim(CT2->CT2_SBLOTE) == "000"

		If CT2->CT2_LOTE <> cLtFolha

			u_GrLogZBE(msDate(),TIME(),cUserName,"FOLHA","CONTABILIDADE","CTBGRV",;
			"LOTE RM, ORIGINAL " + cLtLct + " NOVO " + cLtFolha + " - DT/DOC " + DtoC(CT2->CT2_DATA)+"/"+CT2->CT2_DOC, ComputerName(), LogUserName() )

			RecLock("CT2", .F.)
				CT2->CT2_LOTE := cLtFolha
			CT2->( msUnLock() )

			// SEQUENCIA DOCUMENTO
			CTF->( DbSetOrder(1) ) // CTF_FILIAL, CTF_DATA, CTF_LOTE, CTF_SBLOTE, CTF_DOC, R_E_C_N_O_, D_E_L_E_T_
			If CTF->( dbSeek(FWxFilial("CTF")+DtoS(CT2->CT2_DATA)+cLtLct+CT2->CT2_SBLOTE+CT2->CT2_DOC) )
				
				RecLock("CTF", .F.)
					CTF->CTF_LOTE := cLtFolha
				CTF->( msUnLock() )
			
			Else

				lLockCTF := .t.
				CTF->( DbSetOrder(1) ) // CTF_FILIAL, CTF_DATA, CTF_LOTE, CTF_SBLOTE, CTF_DOC, R_E_C_N_O_, D_E_L_E_T_
				If CTF->( dbSeek(FWxFilial("CTF")+DtoS(CT2->CT2_DATA)+cLtFolha+CT2->CT2_SBLOTE+CT2->CT2_DOC) )
					lLockCTF := .f.
				EndIf

				RecLock("CTF", lLockCTF)
					CTF->CTF_FILIAL := FWxFilial("CTF")
					CTF->CTF_DATA   := CT2->CT2_DATA
					CTF->CTF_LOTE   := cLtFolha
					CTF->CTF_SBLOTE := CT2->CT2_SBLOTE
					CTF->CTF_DOC    := CT2->CT2_DOC
					CTF->CTF_USADO  := "S"
				CTF->( msUnLock() )

			EndIf

		EndIf

	EndIf
	*/
	//

	If nOpcLct == 3 //inclusao   

		// 058353 - Abel Babini - 13/07/2020 - Adiciona fun��o FINA740/FINA460 para criar os indexadores na rotina de fun��es contas a receber
		If Alltrim(nProgra) $ "FINA050/MATA103/FINA450/FINA370/FINA290/CONA230/CTBANFE/FINA740/CTBAFIN/FINA460"
		
			If Alltrim(nProgra) $ "FINA050" .And. Alltrim(SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_FORNECE) == ""   //Exclusao de tit a pagar

				Reclock("CT2",.F.)
					CT2->CT2_FILKEY := M->E2_FILIAL
					CT2->CT2_PREFIX := M->E2_PREFIXO
					CT2->CT2_NUMDOC := M->E2_NUM
					CT2->CT2_PARCEL := M->E2_PARCELA
					CT2->CT2_TIPODC := M->E2_TIPO
					CT2->CT2_CLIFOR := M->E2_FORNECE
					CT2->CT2_LOJACF := M->E2_LOJA
				MsUnlock()			                                

			// 058353 - Abel Babini - 13/07/2020 - Adiciona fun��o FINA740/FINA460 E LP 505 para criar os indexadores na rotina de fun��es contas a receber
			ElseIf (Alltrim(nProgra) $ "FINA450/FINA290" .And. Alltrim(SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_FORNECE) == "");
				.OR. (Alltrim(nProgra) $ "FINA370/FINA740/CTBAFIN/FINA460" .AND. CT2->CT2_LP $ "505/535/515/510/522/500/520/530/562/532/521/527/590/559") .OR. (Alltrim(nProgra) $ "CTBANFE") // CHAMADO 025498 ADICONADO 559 WILLIAM COSTA

				dbSelectArea("CTL")
				dbSetOrder(1)      
				dbGoTop()			
				//If dbSeek(xFilial("CT2")+CT2->CT2_LP)
				If dbSeek(FWxFilial("CTL")+CT2->CT2_LP) // Chamado n. 056799 || OS 058253 || CONTROLADORIA || FELIPE_CAPOVILA || 8464 || INDEXADORES CERES - FWNM - 19/03/2020
					dbSelectArea(CTL->CTL_ALIAS)
					dbSetOrder(Val(CTL->CTL_ORDER))
					dbGoTop()
					If dbSeek(CT2->CT2_KEY)				
						If Alltrim(CTL->CTL_ALIAS) == "SE2"				
							Reclock("CT2",.F.)
								CT2->CT2_FILKEY := SE2->E2_FILIAL
								CT2->CT2_PREFIX := SE2->E2_PREFIXO
								CT2->CT2_NUMDOC := SE2->E2_NUM
								CT2->CT2_PARCEL := SE2->E2_PARCELA
								CT2->CT2_TIPODC := SE2->E2_TIPO
								CT2->CT2_CLIFOR := SE2->E2_FORNECE
								CT2->CT2_LOJACF := SE2->E2_LOJA
							MsUnlock()
						Elseif Alltrim(CTL->CTL_ALIAS) == "SE5"					
							Reclock("CT2",.F.)
							If CT2->CT2_LP $ "562"
								CT2->CT2_FILKEY := SE5->E5_FILIAL
								CT2->CT2_NUMDOC := SUBSTR(SE5->E5_DOCUMEN,9,9)
							Else						
								CT2->CT2_FILKEY := SE5->E5_FILIAL
								CT2->CT2_PREFIX := SE5->E5_PREFIXO
								CT2->CT2_NUMDOC := SE5->E5_NUMERO
								CT2->CT2_PARCEL := SE5->E5_PARCELA
								CT2->CT2_TIPODC := SE5->E5_TIPO
								CT2->CT2_CLIFOR := SE5->E5_CLIFOR
								CT2->CT2_LOJACF := SE5->E5_LOJA
							Endif	
							MsUnlock()					
						ElseIf Alltrim(CTL->CTL_ALIAS) == "SE1"				
							Reclock("CT2",.F.)
								CT2->CT2_FILKEY := SE1->E1_FILIAL
								CT2->CT2_PREFIX := SE1->E1_PREFIXO
								CT2->CT2_NUMDOC := SE1->E1_NUM
								CT2->CT2_PARCEL := SE1->E1_PARCELA
								CT2->CT2_TIPODC := SE1->E1_TIPO
								CT2->CT2_CLIFOR := SE1->E1_CLIENTE
								CT2->CT2_LOJACF := SE1->E1_LOJA
							MsUnlock()		

							//ticket 72835   - Abel Babini				- 30/05/2022 - Executa libera��o de pedidos do cliente ap�s baixas realizadas.
							//StaticCall(M410STTS,fLibCred, SE1->E1_CLIENTE, SE1->E1_LOJA, MsDate())
							//@history Ticket 70142   - Rodrigo Mello/Flek- 10/06/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
							u_10STTSA1( SE1->E1_CLIENTE, SE1->E1_LOJA, MsDate() )

						ElseIf Alltrim(CTL->CTL_ALIAS) == "SD1"				
							Reclock("CT2",.F.)
								CT2->CT2_FILKEY := SD1->D1_FILIAL
								CT2->CT2_PREFIX := SD1->D1_SERIE
								CT2->CT2_NUMDOC := SD1->D1_DOC
								CT2->CT2_PARCEL := ""
								CT2->CT2_TIPODC := "NF"
								CT2->CT2_CLIFOR := SD1->D1_FORNECE
								CT2->CT2_LOJACF := SD1->D1_LOJA
							/*
							//Ricardo Lima-05/02/2019-CH:037647
							If cEmpAnt = "07"
								If !Empty(SD1->D1_PEDIDO)
									dbSelectArea("SC7")
									dbSetOrder(1)
									if dbSeek( FWxFilial("SC7") + SD1->D1_PEDIDO + SD1->D1_ITEMPC )
										CT2->CT2_XLTXCC := SC7->C7_XLOTECC
										CT2->CT2_XDLXCC := SC7->C7_XDLOTCC
									Endif
								Endif
							Endif
							*/
							
							// Chamado n. 047931 || OS 049195 || CONTROLADORIA || ANDRESSA || 45968437 || C.CUSTO X LOTE -RNX2 - FWNM - 20/03/2019
							If cEmpAnt = GetMV("MV_#ZCNEMP",,"07")
								
								// Checo Lote recria na NF
								If !Empty(SD1->D1_XLOTECC)
									CT2->CT2_XLTXCC := SD1->D1_XLOTECC
									CT2->CT2_XDLXCC := SD1->D1_XDLOTCC
									
								Else
									
									If !Empty(SD1->D1_PEDIDO)
										dbSelectArea("SC7")
										dbSetOrder(1)
										If dbSeek( FWxFilial("SC7") + SD1->D1_PEDIDO + SD1->D1_ITEMPC )
											CT2->CT2_XLTXCC := SC7->C7_XLOTECC
											CT2->CT2_XDLXCC := SC7->C7_XDLOTCC
										Endif
									Endif
									
								EndIf
								
							EndIf
							//
								
							MsUnlock()								
	
						ElseIf Alltrim(CTL->CTL_ALIAS) == "SF1"				
							Reclock("CT2",.F.) 
							CT2->CT2_FILKEY := SF1->F1_FILIAL
							CT2->CT2_PREFIX := SF1->F1_SERIE
							CT2->CT2_NUMDOC := SF1->F1_DOC
							CT2->CT2_PARCEL := ""
							CT2->CT2_TIPODC := "NF"
							CT2->CT2_CLIFOR := SF1->F1_FORNECE
							CT2->CT2_LOJACF := SF1->F1_LOJA						
							
							//Ricardo Lima-05/02/2019-CH:037647
							/*
							If cEmpAnt = "07"
								dbSelectArea("SD1")
								dbSetOrder(1)
								if dbSeek( FWxFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA	)
									If !Empty(SD1->D1_PEDIDO)
										dbSelectArea("SC7")
										dbSetOrder(1)
										if dbSeek( FWxFilial("SC7") + SD1->D1_PEDIDO + SD1->D1_ITEMPC )
											CT2->CT2_XLTXCC := SC7->C7_XLOTECC
											CT2->CT2_XDLXCC := SC7->C7_XDLOTCC
										Endif
									Endif
								Endif
							Endif
							*/
	
							// Chamado n. 047931 || OS 049195 || CONTROLADORIA || ANDRESSA || 45968437 || C.CUSTO X LOTE -RNX2 - FWNM - 20/03/2019
							If cEmpAnt = GetMV("MV_#ZCNEMP",,"07")
								
								// Checo Lote recria na NF
								dbSelectArea("SD1")
								dbSetOrder(1)
								If dbSeek( FWxFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA	)
								
									If !Empty(SD1->D1_XLOTECC)
										CT2->CT2_XLTXCC := SD1->D1_XLOTECC
										CT2->CT2_XDLXCC := SD1->D1_XDLOTCC
										
									Else
										
										If !Empty(SD1->D1_PEDIDO)
										
											dbSelectArea("SC7")
											dbSetOrder(1)
											If dbSeek( FWxFilial("SC7") + SD1->D1_PEDIDO + SD1->D1_ITEMPC )
												CT2->CT2_XLTXCC := SC7->C7_XLOTECC
												CT2->CT2_XDLXCC := SC7->C7_XDLOTCC
											Endif
										
										Endif
										
									EndIf
										
								EndIf
							
							Endif
							//
							
							MsUnlock()
															
						Endif	        
					Endif	
				Endif
			
				If CT2->CT2_LP $ "587"
					Reclock("CT2",.F.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := "MAN"
						CT2->CT2_NUMDOC := SUBSTR(SE5->E5_HISTOR,16,6)
						CT2->CT2_PARCEL := "A"
						CT2->CT2_TIPODC := "FT"
						CT2->CT2_CLIFOR := SE5->E5_CLIFOR
						CT2->CT2_LOJACF := SE5->E5_LOJA
					MsUnlock()			
				Endif
			
				If CT2->CT2_LP $ "593"	//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA                                   		
					Reclock("CT2",.F.)
						CT2->CT2_FILKEY := SUBSTR(CT2->CT2_KEY,1,2)
						CT2->CT2_PREFIX := SUBSTR(CT2->CT2_KEY,3,3)
						CT2->CT2_NUMDOC := SUBSTR(CT2->CT2_KEY,6,9)
						CT2->CT2_PARCEL := SUBSTR(CT2->CT2_KEY,15,3)
						CT2->CT2_TIPODC := SUBSTR(CT2->CT2_KEY,18,3)
						CT2->CT2_CLIFOR := SUBSTR(CT2->CT2_KEY,21,6)
						CT2->CT2_LOJACF := SUBSTR(CT2->CT2_KEY,27,2)
					MsUnlock()			
				Endif
			
				If CT2->CT2_LP $ "531"  //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ 			
					Reclock("CT2",.F.)
						CT2->CT2_FILKEY := SUBSTR(CT2->CT2_KEY,1,2)
						CT2->CT2_PREFIX := SUBSTR(CT2->CT2_KEY,5,3)
						CT2->CT2_NUMDOC := SUBSTR(CT2->CT2_KEY,8,9)
						CT2->CT2_PARCEL := SUBSTR(CT2->CT2_KEY,17,3)
						CT2->CT2_TIPODC := SUBSTR(CT2->CT2_KEY,20,2)
						CT2->CT2_CLIFOR := SUBSTR(CT2->CT2_KEY,31,6)
						CT2->CT2_LOJACF := SUBSTR(CT2->CT2_KEY,37,2)
					MsUnlock()			
				Endif  
				
				// *** INICIO CHAMADO 039907 WILLIAM COSTA 13/03/2018 *** // 
				If CT2->CT2_LP $ "559"  //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ 			
					Reclock("CT2",.F.)
						CT2->CT2_FILKEY := SEF->EF_FILIAL
						CT2->CT2_PREFIX := SEF->EF_PREFIXO
						CT2->CT2_NUMDOC := SEF->EF_TITULO
						CT2->CT2_PARCEL := SEF->EF_PARCELA
						CT2->CT2_TIPODC := SEF->EF_TIPO
						CT2->CT2_CLIFOR := SEF->EF_FORNECE
						CT2->CT2_LOJACF := SEF->EF_LOJA	
					MsUnlock()			
				Endif

				// INICIO 058353 - Abel Babini - 13/07/2020 - Adiciona fun��o FINA740/FINA460 para criar os indexadores na rotina de fun��es contas a receber
				If Alltrim(nProgra) $ "FINA460" .AND. CT2->CT2_LP $ "505"  //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ 			
					Reclock("CT2",.F.)
						CT2->CT2_FILKEY := SUBSTR(CT2->CT2_KEY,1,2)
						CT2->CT2_PREFIX := SUBSTR(CT2->CT2_KEY,11,3)
						CT2->CT2_NUMDOC := SUBSTR(CT2->CT2_KEY,14,9)
						CT2->CT2_PARCEL := SUBSTR(CT2->CT2_KEY,23,3)
						CT2->CT2_TIPODC := SUBSTR(CT2->CT2_KEY,26,3)
						CT2->CT2_CLIFOR := SUBSTR(CT2->CT2_KEY,3,6)
						CT2->CT2_LOJACF := SUBSTR(CT2->CT2_KEY,9,2)
					MsUnlock()			
				Endif
				// FIM 058353 - Abel Babini - 13/07/2020 - Adiciona fun��o FINA740/FINA460 para criar os indexadores na rotina de fun��es contas a receber

			// *** INICIO CHAMADO 039907 WILLIAM COSTA 13/03/2018 *** //
			Else
				Reclock("CT2",.F.)
				              		
				If CT2->CT2_LP $ "589/597" .and. Alltrim(SE2->E2_TIPO) $ "PA/NDF" 
					dbSelectArea("CTL")
					dbSetOrder(1)      
					dbGoTop()			
					//If dbSeek(xFilial("CT2")+CT2->CT2_LP)
					If dbSeek(FWxFilial("CTL")+CT2->CT2_LP) // Chamado n. 056799 || OS 058253 || CONTROLADORIA || FELIPE_CAPOVILA || 8464 || INDEXADORES CERES - FWNM - 19/03/2020
						dbSelectArea(CTL->CTL_ALIAS)
						dbSetOrder(Val(CTL->CTL_ORDER))
						dbGoTop()
						If dbSeek(CT2->CT2_KEY)
							if Alltrim(CTL->CTL_ALIAS) == "SE5"												
								CT2->CT2_FILKEY := SE5->E5_FILIAL
								CT2->CT2_PREFIX := SUBSTR(SE5->E5_DOCUMEN,1,3)
								CT2->CT2_NUMDOC := SUBSTR(SE5->E5_DOCUMEN,4,9)
								CT2->CT2_PARCEL := SUBSTR(SE5->E5_DOCUMEN,13,3)
								CT2->CT2_TIPODC := SUBSTR(SE5->E5_DOCUMEN,16,3)
								CT2->CT2_CLIFOR := SUBSTR(SE5->E5_DOCUMEN,19,6)
								CT2->CT2_LOJACF := SUBSTR(SE5->E5_DOCUMEN,25,2)
							Endif	
						Endif
					Endif		
				
				// ********************** INICIO ALTERACAO WILLIAM COSTA CHAMADO N 022317	********************
				ELSEIF CT2->CT2_LP $ "594" .and. Alltrim(SE2->E2_TIPO) $ "NF"
					dbSelectArea("CTL")
					dbSetOrder(1)      
					dbGoTop()			
					//If dbSeek(xFilial("CT2")+CT2->CT2_LP)
					If dbSeek(FWxFilial("CTL")+CT2->CT2_LP) // Chamado n. 056799 || OS 058253 || CONTROLADORIA || FELIPE_CAPOVILA || 8464 || INDEXADORES CERES - FWNM - 19/03/2020
						dbSelectArea(CTL->CTL_ALIAS)
						dbSetOrder(Val(CTL->CTL_ORDER))
						dbGoTop()
						If dbSeek(CT2->CT2_KEY)
							if Alltrim(CTL->CTL_ALIAS) == "SE5"												
								CT2->CT2_FILKEY := SE5->E5_FILIAL
								CT2->CT2_PREFIX := SE5->E5_PREFIXO //SUBSTR(SE5->E5_DOCUMEN,1,3)
								CT2->CT2_NUMDOC := SE5->E5_NUMERO //SUBSTR(SE5->E5_DOCUMEN,4,9)
								CT2->CT2_PARCEL := SE5->E5_PARCELA //SUBSTR(SE5->E5_DOCUMEN,13,3)
								CT2->CT2_TIPODC := SE5->E5_TIPO //SUBSTR(SE5->E5_DOCUMEN,16,3)
								CT2->CT2_CLIFOR := SE5->E5_CLIFOR //SUBSTR(SE5->E5_DOCUMEN,19,6)
								CT2->CT2_LOJACF := SE5->E5_LOJA //SUBSTR(SE5->E5_DOCUMEN,25,2)
							Endif	
						Endif
					Endif	
				// ********************** FINAL ALTERACAO WILLIAM COSTA CHAMADO N 022317	********************	
				
				// ***************** INICIO ALTERACAO CHAMADO 024322 ********************************************** //							
				ELSEIF CT2->CT2_LP $ "665"  .and. Alltrim(SE2->E2_TIPO) $ "TX" //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ 			
					//Reclock("CT2",.F.)
					CT2->CT2_FILKEY := SF1->F1_FILIAL
					CT2->CT2_PREFIX := SF1->F1_SERIE
					CT2->CT2_NUMDOC := SF1->F1_DOC
					CT2->CT2_PARCEL := ""
					CT2->CT2_TIPODC := "TX"
					CT2->CT2_CLIFOR := SF1->F1_FORNECE
					CT2->CT2_LOJACF := SF1->F1_LOJA
					//MsUnlock()			
					
				ELSEIF CT2->CT2_LP $ "655"  .and. Alltrim(SE2->E2_TIPO) $ "TX" //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ 			
					//Reclock("CT2",.F.)
					CT2->CT2_FILKEY := SF1->F1_FILIAL
					CT2->CT2_PREFIX := SF1->F1_SERIE
					CT2->CT2_NUMDOC := SF1->F1_DOC
					CT2->CT2_PARCEL := ""
					CT2->CT2_TIPODC := "TX"
					CT2->CT2_CLIFOR := SF1->F1_FORNECE
					CT2->CT2_LOJACF := SF1->F1_LOJA
					//MsUnlock()				
				
				// ***************** FINAL ALTERACAO CHAMADO 024322 ********************************************** //
				
				// ********************** INICIO ALTERACAO WILLIAM COSTA CHAMADO N 023208	********************
				ELSEIF CT2->CT2_LP $ "665" .and. Alltrim(SE2->E2_TIPO) $ "NF"
					dbSelectArea("CTL")
					dbSetOrder(1)      
					dbGoTop()			
					//If dbSeek(xFilial("CT2")+CT2->CT2_LP)
					If dbSeek(FWxFilial("CTL")+CT2->CT2_LP) // Chamado n. 056799 || OS 058253 || CONTROLADORIA || FELIPE_CAPOVILA || 8464 || INDEXADORES CERES - FWNM - 19/03/2020
						dbSelectArea(CTL->CTL_ALIAS)
						dbSetOrder(Val(CTL->CTL_ORDER))
						dbGoTop()
						If dbSeek(CT2->CT2_KEY)
							If Alltrim(CTL->CTL_ALIAS) == "SE5"
								If Alltrim(SE5->E5_TIPO) $ "NCC/BON/BOF/RA/"     //Alterado por Adriana em 11/12/2014
									Reclock("CT2",.F.)
										CT2->CT2_FILKEY := SE5->E5_FILIAL
										CT2->CT2_PREFIX := SUBSTR(SE5->E5_DOCUMEN,1,3)
										CT2->CT2_NUMDOC := SUBSTR(SE5->E5_DOCUMEN,4,9)
										CT2->CT2_PARCEL := SUBSTR(SE5->E5_DOCUMEN,13,3)
										CT2->CT2_TIPODC := SUBSTR(SE5->E5_DOCUMEN,16,3)
										dbSelectArea("SE1")
										dbSetOrder(1)
										dbGoTop()
										If dbSeek(xFilial("SE1")+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC)
											CT2->CT2_CLIFOR := SE1->E1_CLIENTE
											CT2->CT2_LOJACF := SE1->E1_LOJA
										Endif	
									MsUnlock()				
								Else
									Reclock("CT2",.F.)
										CT2->CT2_FILKEY := SE5->E5_FILIAL
										CT2->CT2_PREFIX := SE5->E5_PREFIXO
										CT2->CT2_NUMDOC := SE5->E5_NUMERO
										CT2->CT2_PARCEL := SE5->E5_PARCELA
										CT2->CT2_TIPODC := SE5->E5_TIPO
										CT2->CT2_CLIFOR := SE5->E5_CLIFOR
										CT2->CT2_LOJACF := SE5->E5_LOJA
									MsUnlock()
								Endif
							Endif	
						Endif
					
					ELSE //ERRO APOS ATUALIZACAO
					
						// ***************** INICIO ALTERACAO CHAMADO 024322 ********************************************** //
					    SqlTitPag(Xfilial("SE2"),SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_SERIE,SF1->F1_DOC)
					        
						/*BEGINDOC
						//����������������������������������������������������������������������������������������������������������Ŀ
						//�apos a atualizacao do sistema protheus no dia 03/08/2015, passou-se no momento do estorno da classificacao�
						//�da nota de entrada foi alterado pela totvs, anteriormente fazia o seguinte processo:                      �
						//�ESTORNO NF COMPRAS -> LANCAMENTOS PADROES -> EXCLUSAO DO TITULO                                           �
						//�agora com a alteracao ficou assim                                                                         �
						//�ESTORNO NF COMPRAS -> EXCLUSAO DO TITULO -> LANCAMENTOS PADROES                                           �
						//�portanto foi refeito esse select para ler arquivos do SE2 deletados mais ordenado por R_E_C_N_O_          �
						//�para garantir que pegue o ultimo excluido.                                                                �
						//�EXPLICACAO POR WILLIAM COSTA                                                                              �
						//������������������������������������������������������������������������������������������������������������
						ENDDOC*/
					    
					    While TRB->(!EOF())
					    	Reclock("CT2",.F.)			
						    	CT2->CT2_FILKEY := TRB->E2_FILIAL
								CT2->CT2_PREFIX := TRB->E2_PREFIXO
								CT2->CT2_NUMDOC := TRB->E2_NUM
								CT2->CT2_PARCEL := TRB->E2_PARCELA
								CT2->CT2_TIPODC := TRB->E2_TIPO
								CT2->CT2_CLIFOR := TRB->E2_FORNECE
								CT2->CT2_LOJACF := TRB->E2_LOJA	 
							MsUnlock()
							       	
					        TRB->(dbSkip())
						ENDDO
						TRB->(dbCloseArea()) 
						// ***************** INICIO ALTERACAO CHAMADO 024322 ********************************************** //
					Endif
				// ********************** FINAL ALTERACAO WILLIAM COSTA CHAMADO N 023208	********************	
				
				// ********************** INICIO ALTERACAO WILLIAM COSTA CHAMADO N 023963	********************
				
				// ********************** FINAL ALTERACAO WILLIAM COSTA CHAMADO N 023963	********************
				// *** INICIO CHAMADO 041818 WILLIAM COSTA 30/05/2018 *** //
				ELSEIF CT2->CT2_LP $ "524"
				
					Reclock("CT2",.F.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SE5->E5_PREFIXO
						CT2->CT2_NUMDOC := SE5->E5_NUMERO
						CT2->CT2_PARCEL := SE5->E5_PARCELA
						CT2->CT2_TIPODC := SE5->E5_TIPO
						CT2->CT2_CLIFOR := SE5->E5_CLIFOR
						CT2->CT2_LOJACF := SE5->E5_LOJA
					MsUnlock()
				
				// *** FINAL CHAMADO 041818 WILLIAM COSTA 30/05/2018 *** //
				Else		
					CT2->CT2_FILKEY := SE2->E2_FILIAL
					CT2->CT2_PREFIX := SE2->E2_PREFIXO
					CT2->CT2_NUMDOC := SE2->E2_NUM
					CT2->CT2_PARCEL := SE2->E2_PARCELA
					CT2->CT2_TIPODC := SE2->E2_TIPO
					CT2->CT2_CLIFOR := SE2->E2_FORNECE
					CT2->CT2_LOJACF := SE2->E2_LOJA				
				Endif	
				MsUnlock()
				 
			Endif	
		Endif
		
		If Alltrim(nProgra) $ "CTBANFS"
	
			dbSelectArea("CTL")
			dbSetOrder(1)      
			dbGoTop()			
			//If dbSeek(xFilial("CT2")+CT2->CT2_LP)
			If dbSeek(FWxFilial("CTL")+CT2->CT2_LP) // Chamado n. 056799 || OS 058253 || CONTROLADORIA || FELIPE_CAPOVILA || 8464 || INDEXADORES CERES - FWNM - 19/03/2020
				dbSelectArea(CTL->CTL_ALIAS)
				dbSetOrder(Val(CTL->CTL_ORDER))
				dbGoTop()
				If dbSeek(Alltrim(CT2->CT2_KEY))
					If Alltrim(CTL->CTL_ALIAS) == "SD2"				
						Reclock("CT2",.F.)
						CT2->CT2_FILKEY := SD2->D2_FILIAL
						CT2->CT2_PREFIX := SD2->D2_SERIE
						CT2->CT2_NUMDOC := SD2->D2_DOC
						CT2->CT2_PARCEL := "" 
						CT2->CT2_TIPODC := "NF"
						CT2->CT2_CLIFOR := SD2->D2_CLIENTE
						CT2->CT2_LOJACF := SD2->D2_LOJA
						MsUnlock()
					Endif
					If Alltrim(CTL->CTL_ALIAS) == "SF2"				
						Reclock("CT2",.F.)
						CT2->CT2_FILKEY := SF2->F2_FILIAL
						CT2->CT2_PREFIX := SF2->F2_SERIE
						CT2->CT2_NUMDOC := SF2->F2_DOC
						CT2->CT2_PARCEL := "" 
						CT2->CT2_TIPODC := "NF"
						CT2->CT2_CLIFOR := SF2->F2_CLIENTE
						CT2->CT2_LOJACF := SF2->F2_LOJA
						MsUnlock()
					Endif				
				Endif
			Endif			
		Endif
		If Alltrim(nProgra) $ "FINA330"
			dbSelectArea("CTL")
			dbSetOrder(1)      
			dbGoTop()			
			// If dbSeek(xFilial("CT2")+CT2->CT2_LP)
			If dbSeek(FWxFilial("CTL")+CT2->CT2_LP) // Chamado n. 056799 || OS 058253 || CONTROLADORIA || FELIPE_CAPOVILA || 8464 || INDEXADORES CERES - FWNM - 19/03/2020
				dbSelectArea(CTL->CTL_ALIAS)
				dbSetOrder(Val(CTL->CTL_ORDER))
				dbGoTop()
				If dbSeek(CT2->CT2_KEY)
					If Alltrim(CTL->CTL_ALIAS) == "SE5"
						If Alltrim(SE5->E5_TIPO) $ "NCC/BON/BOF/RA/"     //Alterado por Adriana em 11/12/2014
						
							// ***************** INICIO ALTERACAO CHAMADO 039907 WILLIAM COSTA 13/03/2018 ********************************************** //
							
								Reclock("CT2",.F.)
									CT2->CT2_FILKEY := SE5->E5_FILIAL
									CT2->CT2_PREFIX := SUBSTR(SE5->E5_DOCUMEN,1,3)
									CT2->CT2_NUMDOC := SUBSTR(SE5->E5_DOCUMEN,4,9)
									CT2->CT2_PARCEL := SUBSTR(SE5->E5_DOCUMEN,13,3)
									CT2->CT2_TIPODC := SUBSTR(SE5->E5_DOCUMEN,16,3)
									dbSelectArea("SE1")
									dbSetOrder(1)
									dbGoTop()
									If dbSeek(xFilial("SE1")+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC)
										CT2->CT2_CLIFOR := SE1->E1_CLIENTE
										CT2->CT2_LOJACF := SE1->E1_LOJA
									Endif	
								CT2->( msUnlock() )
							
						// Chamado n. 051550 || OS 052878 || CONTROLADORIA || MONIK_MACEDO || 8956 || INDEXADORES - fwnm - 26/09/2019
						Else
							Reclock("CT2",.F.)
								CT2->CT2_FILKEY := SE5->E5_FILIAL
								CT2->CT2_PREFIX := SE5->E5_PREFIXO
								CT2->CT2_NUMDOC := SE5->E5_NUMERO
								CT2->CT2_PARCEL := SE5->E5_PARCELA
								CT2->CT2_TIPODC := SE5->E5_TIPO
								CT2->CT2_CLIFOR := SE5->E5_CLIFOR
								CT2->CT2_LOJACF := SE5->E5_LOJA
							CT2->( msUnlock() )
						Endif
					Endif	
				Endif
			Endif			
		Endif			
		If Alltrim(nProgra) $ "FINA040/FINA060/FINA190" 
			Reclock("CT2",.F.)
				CT2->CT2_FILKEY := SE1->E1_FILIAL
				CT2->CT2_PREFIX := SE1->E1_PREFIXO
				CT2->CT2_NUMDOC := SE1->E1_NUM
				CT2->CT2_PARCEL := SE1->E1_PARCELA
				CT2->CT2_TIPODC := SE1->E1_TIPO
				CT2->CT2_CLIFOR := SE1->E1_CLIENTE
				CT2->CT2_LOJACF := SE1->E1_LOJA
			CT2->( MsUnlock() )
		Endif
		
		If Alltrim(nProgra) $ "FINA100" 
			Reclock("CT2",.F.)			
			CT2->CT2_FILKEY := SE5->E5_FILIAL
			CT2->CT2_NUMDOC := SUBSTR(SE5->E5_DOCUMEN,9,9)
			MsUnlock()
		Endif	
		
		If Alltrim(nProgra) $ "FINA070/FINA080/FINA300/FINA090/FINA430"
			If Alltrim(CT2_LP) == "527" //Cancelamento de baixa a receber
				dbSelectArea("CTL")
				dbSetOrder(1)      
				dbGoTop()			
				//If dbSeek(xFilial("CT2")+CT2->CT2_LP)
				If dbSeek(FWxFilial("CTL")+CT2->CT2_LP) // Chamado n. 056799 || OS 058253 || CONTROLADORIA || FELIPE_CAPOVILA || 8464 || INDEXADORES CERES - FWNM - 19/03/2020
					dbSelectArea(CTL->CTL_ALIAS)
					dbSetOrder(Val(CTL->CTL_ORDER))
					dbGoTop()
					If dbSeek(Alltrim(CT2->CT2_KEY))
						If Alltrim(CTL->CTL_ALIAS) == "SE5"		
							Reclock("CT2",.F.)
							CT2->CT2_FILKEY := SE5->E5_FILIAL
							CT2->CT2_PREFIX := SE5->E5_PREFIXO
							CT2->CT2_NUMDOC := SE5->E5_NUMERO
							CT2->CT2_PARCEL := SE5->E5_PARCELA
							CT2->CT2_TIPODC := SE5->E5_TIPO
							CT2->CT2_CLIFOR := SE5->E5_CLIFOR
							CT2->CT2_LOJACF := SE5->E5_LOJA
							MsUnlock()
							Reclock("SE5",.F.)
							SE5->E5_DTCANBX := DDATABASE
							MsUnlock()
						Endif
					Endif
				Endif	
				
			// *** INICIO WILLIAM COSTA CHAMADO 040461 29/03/2018 *** //
			
			//ELSEIF Alltrim(CT2_LP) == "530"
			ELSEIF Alltrim(CT2_LP) == "530" .or. Alltrim(CT2_LP) == "532" // Chamado n. 048173 - FWNM - 01/04/2019
			 
				Reclock("CT2",.F.)			
			    	CT2->CT2_FILKEY := SUBSTR(CT2->CT2_KEY,1,2)
					CT2->CT2_PREFIX := SUBSTR(CT2->CT2_KEY,5,3)
					CT2->CT2_NUMDOC := SUBSTR(CT2->CT2_KEY,8,9)
					CT2->CT2_PARCEL := SUBSTR(CT2->CT2_KEY,17,3)
					CT2->CT2_TIPODC := SUBSTR(CT2->CT2_KEY,20,3)
					CT2->CT2_CLIFOR := SUBSTR(CT2->CT2_KEY,31,6)
					CT2->CT2_LOJACF := SUBSTR(CT2->CT2_KEY,37,2)	 
				MsUnlock()
									
			// *** INICIO WILLIAM COSTA CHAMADO 040461 29/03/2018 *** //
						
			Else
				Reclock("CT2",.F.)
				CT2->CT2_FILKEY := SE5->E5_FILIAL
				CT2->CT2_PREFIX := SE5->E5_PREFIXO
				CT2->CT2_NUMDOC := SE5->E5_NUMERO
				CT2->CT2_PARCEL := SE5->E5_PARCELA
				CT2->CT2_TIPODC := SE5->E5_TIPO
				CT2->CT2_CLIFOR := SE5->E5_CLIFOR
				CT2->CT2_LOJACF := SE5->E5_LOJA
				MsUnlock()
			Endif
		Endif
		
		//FINA340 - UTILIZA OS PE: F340GRV e F340FCAN
					
	EndIf
	
	//Chamado n. 048129 || OS 049388 || FISCAL || ALLAN || 8394 || CENTRAL XML - RATEIO - FWNM - 03/06/2019
	If cEmpAnt = GetMV("MV_#ZCNEMP",,"07")
								
		//If Alltrim(nProgra) == "MATA103" .and. AllTrim(CT2->CT2_DC) <> "4"
		If AllTrim(CT2->CT2_DC) <> "4"
		
			If ( AllTrim(SD1->D1_RATEIO) == "1" .and. AllTrim(CT2->CT2_LP) == "651" ) .or. AllTrim(CT2->CT2_LP) == "656"
									
				aAreaSDE := SDE->( GetArea() )
				
				If AllTrim(CT2->CT2_LP) == "656"
					Set Deleted Off
				EndIf
										
				SDE->( dbSetOrder(1) ) // DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA+DE_ITEMNF+DE_ITEM                                                                                                  
				If SDE->( dbSeek( AllTrim(CT2->CT2_ORIGEM) ) )
	
					// Checo Lote recria na NF
					If !Empty(SDE->DE_XLOTECC)
						RecLock("CT2", .f.)
							CT2->CT2_XLTXCC := SDE->DE_XLOTECC
							CT2->CT2_XDLXCC := Posicione("ZCN",1,FWxFilial("ZCN")+SDE->DE_XLOTECC,"ZCN_DESCLT") 
						CT2->( msUnLock() )
					EndIf
											
				EndIf
										
				RestArea( aAreaSDE )
				
				If AllTrim(CT2->CT2_LP) == "656"
					Set Deleted On
				EndIf
				
			EndIf

			// Chamado n. 054198 || OS 055597 || CONTROLADORIA || THIAGO || 8439 || LP - 666-002 - FWNM - 16/12/2019
			If AllTrim(CT2->CT2_LP) $ "666|668"

				aAreaAtu := GetArea()
				aAreaSD3 := SD3->( GetArea() )
				aAreaSCP := SCP->( GetArea() )

				// Posiciono origem contabilizacao
				CTL->( dbSetOrder(1) )
				If CTL->( dbSeek(FWxFilial("CTL")+CT2->CT2_LP))

					dbSelectArea(CTL->CTL_ALIAS)
					dbSetOrder(Val(CTL->CTL_ORDER))
					dbGoTop()
					If dbSeek(CT2->CT2_KEY)

						// Posiciono SCP
						If AllTrim(CTL->CTL_ALIAS) == "SD3"
							
							If !Empty(SD3->D3_NUMSA)
									
								SCP->( dbSetOrder(1) ) // CP_FILIAL+CP_NUM+CP_ITEM+DTOS(CP_EMISSAO)
								If SCP->( dbSeek( SD3->(D3_FILIAL+D3_NUMSA+D3_ITEMSA) ) )

									// Gravo Lote recria
									RecLock("CT2", .f.)
										CT2->CT2_XLTXCC := SCP->CP_XLOTECC
										CT2->CT2_XDLXCC := Iif(Empty(SCP->CP_XDLOTCC),Posicione("ZCN",1,FWxFilial("ZCN")+SCP->CP_XLOTECC,"ZCN_DESCLT"),SCP->CP_XDLOTCC)
									CT2->( msUnLock() )

								EndIf

							EndIf

						EndIf

					EndIf

					RestArea( aAreaSD3 )
					RestArea( aAreaSCP )
					RestArea( aAreaAtu )

				EndIf

			EndIf
			//
			
		EndIf
		
	EndIf

	// Chamado n. 048047 || OS 049306 || CONTROLADORIA || ANA_CAROLINA || 8464 || LP 596/597/588/589 COM CT2_ORIGEM ERRADA - || FWNM - 11/06/2019
	If !IsInCallStack("CTBA102") .and. !IsInCallStack("CTBA101") .and. !IsInCallStack("CTBA103")
	
		// Chamado n. 048047 || OS 049306 || CONTROLADORIA || ANA_CAROLINA || 8464 || LP 596 COMP RECEB (RA) - FWNM - 05/06/2019                  		
		If AllTrim(CT2->CT2_LP) == "596"

			cCtaDeb := GetMV("MV_#596DEB",,"211510001")
			cCtaCre := GetMV("MV_#596CRE",,"111210001")
					
			If AllTrim(SubStr(CT2->CT2_ORIGEM,69,3)) <> "NF"
	
				If Left(AllTrim(CT2->CT2_DEBITO),3) == Left(cCtaDeb,3) 
							
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SubStr(CT2->CT2_ORIGEM,54,3)
						CT2->CT2_NUMDOC := SubStr(CT2->CT2_ORIGEM,57,9)
						CT2->CT2_PARCEL := SubStr(CT2->CT2_ORIGEM,66,3)
						CT2->CT2_TIPODC := SubStr(CT2->CT2_ORIGEM,69,3)
	
						SE1->( dbSetOrder(1) )
						//If SE1->( dbSeek(FWxFilial("SE1")+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) // @history ticket 72053   - Fernando Macieira - 05/05/2022 - INDEXADORES TROCADOS
						If SE1->( dbSeek(SE5->E5_FILIAL+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) )
							CT2->CT2_CLIFOR := SE1->E1_CLIENTE
							CT2->CT2_LOJACF := SE1->E1_LOJA
						Endif
					CT2->( msUnLock() )
	
				ElseIf Left(AllTrim(CT2->CT2_CREDIT),3) == Left(cCtaCre,3) 
	
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SubStr(CT2->CT2_ORIGEM,1,3)
						CT2->CT2_NUMDOC := SubStr(CT2->CT2_ORIGEM,4,9)
						CT2->CT2_PARCEL := SubStr(CT2->CT2_ORIGEM,13,3)
						CT2->CT2_TIPODC := SubStr(CT2->CT2_ORIGEM,16,3)
	
						SE1->( dbSetOrder(1) )
						//If SE1->( dbSeek(FWxFilial("SE1")+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) // @history ticket 72053   - Fernando Macieira - 05/05/2022 - INDEXADORES TROCADOS
						If SE1->( dbSeek(SE5->E5_FILIAL+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) )
							CT2->CT2_CLIFOR := SE1->E1_CLIENTE
							CT2->CT2_LOJACF := SE1->E1_LOJA
						Endif
					CT2->( msUnLock() )
											
				EndIf
			
			Else
			
				If Left(AllTrim(CT2->CT2_DEBITO),3) == Left(cCtaDeb,3)
							
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SubStr(CT2->CT2_ORIGEM,1,3)
						CT2->CT2_NUMDOC := SubStr(CT2->CT2_ORIGEM,4,9)
						CT2->CT2_PARCEL := SubStr(CT2->CT2_ORIGEM,13,3)
						CT2->CT2_TIPODC := SubStr(CT2->CT2_ORIGEM,16,3)
	
						SE1->( dbSetOrder(1) )
						//If SE1->( dbSeek(FWxFilial("SE1")+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) // @history ticket 72053   - Fernando Macieira - 05/05/2022 - INDEXADORES TROCADOS
						If SE1->( dbSeek(SE5->E5_FILIAL+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) )
							CT2->CT2_CLIFOR := SE1->E1_CLIENTE
							CT2->CT2_LOJACF := SE1->E1_LOJA
						Endif
					CT2->( msUnLock() )
							
				ElseIf Left(AllTrim(CT2->CT2_CREDIT),3) == Left(cCtaCre,3)
		
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SubStr(CT2->CT2_ORIGEM,54,3)
						CT2->CT2_NUMDOC := SubStr(CT2->CT2_ORIGEM,57,9)
						CT2->CT2_PARCEL := SubStr(CT2->CT2_ORIGEM,66,3)
						CT2->CT2_TIPODC := SubStr(CT2->CT2_ORIGEM,69,3)
	
						SE1->( dbSetOrder(1) )
						//If SE1->( dbSeek(FWxFilial("SE1")+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) // @history ticket 72053   - Fernando Macieira - 05/05/2022 - INDEXADORES TROCADOS
						If SE1->( dbSeek(SE5->E5_FILIAL+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) 
							CT2->CT2_CLIFOR := SE1->E1_CLIENTE
							CT2->CT2_LOJACF := SE1->E1_LOJA
						Endif
					CT2->( msUnLock() )

				ELSE

					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SubStr(CT2->CT2_ORIGEM,1,3)
						CT2->CT2_NUMDOC := SubStr(CT2->CT2_ORIGEM,4,9)
						CT2->CT2_PARCEL := SubStr(CT2->CT2_ORIGEM,13,3)
						CT2->CT2_TIPODC := SubStr(CT2->CT2_ORIGEM,16,3)
	
						SE1->( dbSetOrder(1) )
						//If SE1->( dbSeek(FWxFilial("SE1")+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) // @history ticket 72053   - Fernando Macieira - 05/05/2022 - INDEXADORES TROCADOS
						If SE1->( dbSeek(SE5->E5_FILIAL+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) )
							CT2->CT2_CLIFOR := SE1->E1_CLIENTE
							CT2->CT2_LOJACF := SE1->E1_LOJA
						Endif
					CT2->( msUnLock() )
							
				EndIf
				
			EndIf
		
		EndIf
		//
	
		// Chamado n. 048047 || OS 049306 || CONTROLADORIA || ANA_CAROLINA || 8464 || LP 588 ESTOR COMP RECEB (RA) - FWNM - 05/06/2019                  		
		If AllTrim(CT2->CT2_LP) == "588"
		
			cCtaDeb := GetMV("MV_#596CRE",,"111210001")
			cCtaCre := GetMV("MV_#596DEB",,"211510001")
					
			If AllTrim(SubStr(CT2->CT2_ORIGEM,69,3)) <> "NF"
	
				If Left(AllTrim(CT2->CT2_DEBITO),3) == Left(cCtaDeb,3)
							
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SubStr(CT2->CT2_ORIGEM,1,3)
						CT2->CT2_NUMDOC := SubStr(CT2->CT2_ORIGEM,4,9)
						CT2->CT2_PARCEL := SubStr(CT2->CT2_ORIGEM,13,3)
						CT2->CT2_TIPODC := SubStr(CT2->CT2_ORIGEM,16,3)
	
						SE1->( dbSetOrder(1) )
						//If SE1->( dbSeek(FWxFilial("SE1")+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) // @history ticket 72053   - Fernando Macieira - 05/05/2022 - INDEXADORES TROCADOS
						If SE1->( dbSeek(SE5->E5_FILIAL+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) 
							CT2->CT2_CLIFOR := SE1->E1_CLIENTE
							CT2->CT2_LOJACF := SE1->E1_LOJA
						Endif
					CT2->( msUnLock() )
	
				ElseIf Left(AllTrim(CT2->CT2_CREDIT),3) == Left(cCtaCre,3) 
	
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SubStr(CT2->CT2_ORIGEM,54,3)
						CT2->CT2_NUMDOC := SubStr(CT2->CT2_ORIGEM,57,9)
						CT2->CT2_PARCEL := SubStr(CT2->CT2_ORIGEM,66,3)
						CT2->CT2_TIPODC := SubStr(CT2->CT2_ORIGEM,69,3)
	
						SE1->( dbSetOrder(1) )
						//If SE1->( dbSeek(FWxFilial("SE1")+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) // @history ticket 72053   - Fernando Macieira - 05/05/2022 - INDEXADORES TROCADOS
						If SE1->( dbSeek(SE5->E5_FILIAL+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) 
							CT2->CT2_CLIFOR := SE1->E1_CLIENTE
							CT2->CT2_LOJACF := SE1->E1_LOJA
						Endif
					CT2->( msUnLock() )
											
				EndIf
			
			Else
			
				If Left(AllTrim(CT2->CT2_DEBITO),3) == Left(cCtaDeb,3)
							
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SubStr(CT2->CT2_ORIGEM,54,3)
						CT2->CT2_NUMDOC := SubStr(CT2->CT2_ORIGEM,57,9)
						CT2->CT2_PARCEL := SubStr(CT2->CT2_ORIGEM,66,3)
						CT2->CT2_TIPODC := SubStr(CT2->CT2_ORIGEM,69,3)
	
						SE1->( dbSetOrder(1) )
						//If SE1->( dbSeek(FWxFilial("SE1")+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) // @history ticket 72053   - Fernando Macieira - 05/05/2022 - INDEXADORES TROCADOS
						If SE1->( dbSeek(SE5->E5_FILIAL+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) )
							CT2->CT2_CLIFOR := SE1->E1_CLIENTE
							CT2->CT2_LOJACF := SE1->E1_LOJA
						Endif
					CT2->( msUnLock() )
							
				ElseIf Left(AllTrim(CT2->CT2_CREDIT),3) == Left(cCtaCre,3)
		
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SubStr(CT2->CT2_ORIGEM,1,3)
						CT2->CT2_NUMDOC := SubStr(CT2->CT2_ORIGEM,4,9)
						CT2->CT2_PARCEL := SubStr(CT2->CT2_ORIGEM,13,3)
						CT2->CT2_TIPODC := SubStr(CT2->CT2_ORIGEM,16,3)
	
						SE1->( dbSetOrder(1) )
						//If SE1->( dbSeek(FWxFilial("SE1")+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) // @history ticket 72053   - Fernando Macieira - 05/05/2022 - INDEXADORES TROCADOS
						If SE1->( dbSeek(SE5->E5_FILIAL+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) 
							CT2->CT2_CLIFOR := SE1->E1_CLIENTE
							CT2->CT2_LOJACF := SE1->E1_LOJA
						Endif
					CT2->( msUnLock() )

				ELSE

					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SubStr(CT2->CT2_ORIGEM,1,3)
						CT2->CT2_NUMDOC := SubStr(CT2->CT2_ORIGEM,4,9)
						CT2->CT2_PARCEL := SubStr(CT2->CT2_ORIGEM,13,3)
						CT2->CT2_TIPODC := SubStr(CT2->CT2_ORIGEM,16,3)
	
						SE1->( dbSetOrder(1) )
						//If SE1->( dbSeek(FWxFilial("SE1")+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) // @history ticket 72053   - Fernando Macieira - 05/05/2022 - INDEXADORES TROCADOS
						If SE1->( dbSeek(SE5->E5_FILIAL+CT2->CT2_PREFIX+CT2->CT2_NUMDOC+CT2->CT2_PARCEL+CT2->CT2_TIPODC) ) 
							CT2->CT2_CLIFOR := SE1->E1_CLIENTE
							CT2->CT2_LOJACF := SE1->E1_LOJA
						Endif
					CT2->( msUnLock() )	
							
				EndIf
				
			EndIf
		
		EndIf
		//
	
		// Chamado n. 048047 || OS 049306 || CONTROLADORIA || ANA_CAROLINA || 8464 || LP 597 COMP PAGAR (PA) - FWNM - 04/06/2019
		If AllTrim(CT2->CT2_LP) == "597"
		
			cCtaDeb := GetMV("MV_#597DEB",,"211110001")
			cCtaCre := GetMV("MV_#597CRE",,"111310001")
					
			//If AllTrim(SUBSTR(CT2->CT2_ORIGEM,16,3)) == "PA"
			If AllTrim(SUBSTR(CT2->CT2_ORIGEM,16,3)) <> "NF"
	
				If Left(AllTrim(CT2->CT2_DEBITO),3) == Left(cCtaDeb,3) 
							
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SUBSTR(CT2->CT2_ORIGEM,54,3)
						CT2->CT2_NUMDOC := SUBSTR(CT2->CT2_ORIGEM,57,9)
						CT2->CT2_PARCEL := SUBSTR(CT2->CT2_ORIGEM,66,3)
						CT2->CT2_TIPODC := SUBSTR(CT2->CT2_ORIGEM,69,3)
						CT2->CT2_CLIFOR := SUBSTR(CT2->CT2_ORIGEM,72,6)
						CT2->CT2_LOJACF := SUBSTR(CT2->CT2_ORIGEM,78,2)
					CT2->( msUnLock() )
	
				ElseIf Left(AllTrim(CT2->CT2_CREDIT),3) == Left(cCtaCre,3) 
	
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SUBSTR(CT2->CT2_ORIGEM,1,3)
						CT2->CT2_NUMDOC := SUBSTR(CT2->CT2_ORIGEM,4,9)
						CT2->CT2_PARCEL := SUBSTR(CT2->CT2_ORIGEM,13,3)
						CT2->CT2_TIPODC := SUBSTR(CT2->CT2_ORIGEM,16,3)
						CT2->CT2_CLIFOR := SUBSTR(CT2->CT2_ORIGEM,19,6)
						CT2->CT2_LOJACF := SUBSTR(CT2->CT2_ORIGEM,25,2)
					CT2->( msUnLock() )
											
				EndIf
			
			Else
			
				If Left(AllTrim(CT2->CT2_DEBITO),3) == Left(cCtaDeb,3)
							
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SUBSTR(CT2->CT2_ORIGEM,1,3)
						CT2->CT2_NUMDOC := SUBSTR(CT2->CT2_ORIGEM,4,9)
						CT2->CT2_PARCEL := SUBSTR(CT2->CT2_ORIGEM,13,3)
						CT2->CT2_TIPODC := SUBSTR(CT2->CT2_ORIGEM,16,3)
						CT2->CT2_CLIFOR := SUBSTR(CT2->CT2_ORIGEM,19,6)
						CT2->CT2_LOJACF := SUBSTR(CT2->CT2_ORIGEM,25,2)
					CT2->( msUnLock() )
							
				ElseIf Left(AllTrim(CT2->CT2_CREDIT),3) == Left(cCtaCre,3)
		
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SUBSTR(CT2->CT2_ORIGEM,54,3)
						CT2->CT2_NUMDOC := SUBSTR(CT2->CT2_ORIGEM,57,9)
						CT2->CT2_PARCEL := SUBSTR(CT2->CT2_ORIGEM,66,3)
						CT2->CT2_TIPODC := SUBSTR(CT2->CT2_ORIGEM,69,3)
						CT2->CT2_CLIFOR := SUBSTR(CT2->CT2_ORIGEM,72,6)
						CT2->CT2_LOJACF := SUBSTR(CT2->CT2_ORIGEM,78,2)
					CT2->( msUnLock() )
							
				EndIf
				
			EndIf
		
		EndIf
		//
	
		// Chamado n. 048047 || OS 049306 || CONTROLADORIA || ANA_CAROLINA || 8464 || LP 589 ESTOR COMP PAGAR (PA) - FWNM - 05/06/2019
		If AllTrim(CT2->CT2_LP) == "589"
		
			cCtaDeb := GetMV("MV_#597CRE",,"111310001")
			cCtaCre := GetMV("MV_#597DEB",,"211110001")
					
			If AllTrim(SUBSTR(CT2->CT2_ORIGEM,16,3)) <> "NF"
	
				If Left(AllTrim(CT2->CT2_DEBITO),3) == Left(cCtaDeb,3) 
							
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SUBSTR(CT2->CT2_ORIGEM,1,3)
						CT2->CT2_NUMDOC := SUBSTR(CT2->CT2_ORIGEM,4,9)
						CT2->CT2_PARCEL := SUBSTR(CT2->CT2_ORIGEM,13,3)
						CT2->CT2_TIPODC := SUBSTR(CT2->CT2_ORIGEM,16,3)
						CT2->CT2_CLIFOR := SUBSTR(CT2->CT2_ORIGEM,19,6)
						CT2->CT2_LOJACF := SUBSTR(CT2->CT2_ORIGEM,25,2)
					CT2->( msUnLock() )
	
				ElseIf Left(AllTrim(CT2->CT2_CREDIT),3) == Left(cCtaCre,3) 
	
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SUBSTR(CT2->CT2_ORIGEM,54,3)
						CT2->CT2_NUMDOC := SUBSTR(CT2->CT2_ORIGEM,57,9)
						CT2->CT2_PARCEL := SUBSTR(CT2->CT2_ORIGEM,66,3)
						CT2->CT2_TIPODC := SUBSTR(CT2->CT2_ORIGEM,69,3)
						CT2->CT2_CLIFOR := SUBSTR(CT2->CT2_ORIGEM,72,6)
						CT2->CT2_LOJACF := SUBSTR(CT2->CT2_ORIGEM,78,2)
					CT2->( msUnLock() )
											
				EndIf
			
			Else
			
				If Left(AllTrim(CT2->CT2_DEBITO),3) == Left(cCtaDeb,3)
							
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SUBSTR(CT2->CT2_ORIGEM,54,3)
						CT2->CT2_NUMDOC := SUBSTR(CT2->CT2_ORIGEM,57,9)
						CT2->CT2_PARCEL := SUBSTR(CT2->CT2_ORIGEM,66,3)
						CT2->CT2_TIPODC := SUBSTR(CT2->CT2_ORIGEM,69,3)
						CT2->CT2_CLIFOR := SUBSTR(CT2->CT2_ORIGEM,72,6)
						CT2->CT2_LOJACF := SUBSTR(CT2->CT2_ORIGEM,78,2)
					CT2->( msUnLock() )
							
				ElseIf Left(AllTrim(CT2->CT2_CREDIT),3) == Left(cCtaCre,3)
		
					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SUBSTR(CT2->CT2_ORIGEM,1,3)
						CT2->CT2_NUMDOC := SUBSTR(CT2->CT2_ORIGEM,4,9)
						CT2->CT2_PARCEL := SUBSTR(CT2->CT2_ORIGEM,13,3)
						CT2->CT2_TIPODC := SUBSTR(CT2->CT2_ORIGEM,16,3)
						CT2->CT2_CLIFOR := SUBSTR(CT2->CT2_ORIGEM,19,6)
						CT2->CT2_LOJACF := SUBSTR(CT2->CT2_ORIGEM,25,2)
					CT2->( msUnLock() )
							
				EndIf
				
			EndIf
		
		EndIf
		
	EndIf
	//
				
	// Chamado n. 048047 || OS 049306 || CONTROLADORIA || ANA_CAROLINA || 8464 || LP 596-007 - FWNM - 06/05/2019 (Inserido excecoes para NCC e Geracao Fatura)
	If !IsInCallStack("CTBA102") .and. !IsInCallStack("CTBA101") .and. !IsInCallStack("CTBA103") .and. !IsInCallStack("MATA330") .and. !IsInCallStack("FINA290") .and. !IsInCallStack("FINA330")
		CTBIndex()
	EndIf
	// 

	// @history ticket 1438 - FWNM - 21/10/2020 - Indexadores de NCC incorretos
	IndexNCC()
	//

	// @history ticket 84225   - 12/01/2023 - Fernando Macieira - Altera��o da Regra de lan�amento de deprecia��o para inclus�o de lote X CC e Descri Lote
	// @history ticket 65263   - Fernando Macieira - 24/01/2022 - numero/nome da granja na contabiliza��o da deprecia��o
	//ATFLoteZCN()
	NewLoteZCN() 
	// 
	
	//ticket  9307   - Abel Babini       - 15/02/2021 - Acrescentar indesxadores para rotinas do Ativo de Baixas e Transfer�ncias
	If IsInCallStack("ATFA036") .or. IsInCallStack("ATFA060") //(Alltrim(nProgra) $ "MATA460" .AND. IsInCallStack("ATFA036"))
		dbSelectArea("CTL")
		dbSetOrder(1)      
		dbGoTop()			
		If dbSeek(FWxFilial("CTL")+CT2->CT2_LP) // Chamado n. 056799 || OS 058253 || CONTROLADORIA || FELIPE_CAPOVILA || 8464 || INDEXADORES CERES - FWNM - 19/03/2020
			dbSelectArea(CTL->CTL_ALIAS)
			dbSetOrder(Val(CTL->CTL_ORDER))
			dbGoTop()
			If dbSeek(Alltrim(CT2->CT2_KEY))

				If Alltrim(CTL->CTL_ALIAS) == "SD2"
					Reclock("CT2",.F.)
						CT2->CT2_FILKEY := SD2->D2_FILIAL
						CT2->CT2_PREFIX := SD2->D2_SERIE
						CT2->CT2_NUMDOC := SD2->D2_DOC
						CT2->CT2_PARCEL := "" 
						CT2->CT2_TIPODC := "NF"
						CT2->CT2_CLIFOR := SD2->D2_CLIENTE
						CT2->CT2_LOJACF := SD2->D2_LOJA
					MsUnlock()
				ElseIf Alltrim(CTL->CTL_ALIAS) == "SF2"				
					Reclock("CT2",.F.)
					CT2->CT2_FILKEY := SF2->F2_FILIAL
					CT2->CT2_PREFIX := SF2->F2_SERIE
					CT2->CT2_NUMDOC := SF2->F2_DOC
					CT2->CT2_PARCEL := "" 
					CT2->CT2_TIPODC := "NF"
					CT2->CT2_CLIFOR := SF2->F2_CLIENTE
					CT2->CT2_LOJACF := SF2->F2_LOJA
					MsUnlock()
				Elseif (Alltrim(CTL->CTL_ALIAS) == "SN3" .OR. Alltrim(CTL->CTL_ALIAS) == "SN4") .AND. !EMPTY(ALLTRIM(SN4->N4_NOTA))
					dbSelectArea("SF2")
					dbSetOrder(1)
					dbGoTop()
					IF SF2->(DBSEEK(SN4->N4_FILIAL+SN4->N4_NOTA+SN4->N4_SERIE))
						Reclock("CT2",.F.)
							CT2->CT2_FILKEY := SF2->F2_FILIAL
							CT2->CT2_PREFIX := SF2->F2_SERIE
							CT2->CT2_NUMDOC := SF2->F2_DOC
							CT2->CT2_PARCEL := "" 
							CT2->CT2_TIPODC := "NF"
							CT2->CT2_CLIFOR := SF2->F2_CLIENTE
							CT2->CT2_LOJACF := SF2->F2_LOJA
						MsUnlock()
					ENDIF
				Endif
			Endif
		Endif

	ENDIF
	//FIM ticket  9307   - Abel Babini       - 15/02/2021 - Acrescentar indesxadores para rotinas do Ativo de Baixas e Transfer�ncias

	RestArea(_aAreaSE1)
	RestArea(_aAreaSE2)
	RestArea(_aAreaSE5) 
	RestArea(_aAreaSD1)
	RestArea(_aAreaSF1)
	RestArea(_aAreaSD2)
	RestArea(_aAreaSF2) //ticket  9307   - Abel Babini       - 15/02/2021 - Acrescentar indesxadores para rotinas do Ativo de Baixas e Transfer�ncias

Return 

/*              
FINA050 - CONTAS A PAGAR
FINA040 - CONTAS A RECEBER
FINA070 - BAIXAS A RECEBER
FINA080 - BAIXAS A PAGAR
FINA060 - TRANSFERENCIAS CR
FINA280 - FATURAS A REC
FINA290 - FATURAS A PAG
FINA370 - CONTAB OFF LINE
FINA300 - SISPAG
FINA340 - COMPENSACAO CP
FINA330 - COMPENSACAO CR
CTBANFE - CONTAB OFF LINE DOC ENTRADA
CONA230 - CONTAB OFF LINE COMPRAS
CTBANFS - CONTAB OFF LINE FATURAMENTO
CTBA102 - LCTO CONTAB AUTOM (LCTO MANUAL N�O HA COMO RASTREAR)
MATA103 - DOC DE ENTRADA
FINA450 - COMPENSACAO ENTRE CARTEIRAS
FINA090 - BAIXAS A PAG AUTOM
FINA430 - RETORNO PAGAMENTOS
FINA190 - GERACAO CHEQUES
FINA100 - MOVIMENTO BANCARIO
CTBA500 - CONTABILIZACAO TXT (LCTO MANUAL N�O HA COMO RASTREAR)
*/
                  

Static Function SqlTitPag(cFil,cFornece,cLoja,cPrefixo,cDoc)                        

	BeginSQL Alias "TRB"
			%NoPARSER%   
			SELECT TOP(1) E2_FILIAL,
			              E2_PREFIXO,
			              E2_NUM,
			              E2_PARCELA,
			              E2_TIPO,
			              E2_FORNECE,
			              E2_LOJA 
			  FROM %Table:SE2% WITH(NOLOCK) 
			WHERE E2_FILIAL  = %EXP:cFil%
			  AND E2_FORNECE = %EXP:cFornece%
			  AND E2_LOJA    = %EXP:cLoja%
			  AND E2_PREFIXO = %EXP:cPrefixo%
			  AND E2_NUM     = %EXP:cDoc%
			  
			  ORDER BY R_E_C_N_O_ DESC
			
	EndSQl             

RETURN(NIL)

/*/{Protheus.doc} User Function nomeFunction
	(long_description)
	@type  Function
	@author user
	@since 22/10/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function CTBIndex()

	Local aAreaCTL := {}
	
	If AllTrim(CT2->CT2_LP) == "596" // Comp clientes
		Return
	EndIf

	If AllTrim(CT2->CT2_LP) == "588" // Estor Compensacao clientes
		Return
	EndIf

	If AllTrim(CT2->CT2_LP) == "597" // Compensacao fornecedores
		Return
	EndIf

	If AllTrim(CT2->CT2_LP) == "589" // Estor Compensacao fornecedores
		Return
	EndIf

	aAreaCTL := CTL->( GetArea() )
	
	CTL->( dbSetOrder(1) ) // CTL_FILIAL+CTL_LP
	If CTL->( dbSeek( FWxFilial("CTL")+CT2->CT2_LP ) ) 
			
		If Left(AllTrim(CTL->CTL_ALIAS),2) == "SE"
				
			dbSelectArea( CTL->CTL_ALIAS )
			dbSetOrder( Val(CTL->CTL_ORDER) )
			If dbSeek( Alltrim(CT2->CT2_KEY) )
	
				RecLock("CT2", .f.)
							
					If AllTrim(CTL->CTL_ALIAS) == "SE1"
							
						CT2->CT2_FILKEY := SE1->E1_FILIAL
						CT2->CT2_PREFIX := SE1->E1_PREFIXO
						CT2->CT2_NUMDOC := SE1->E1_NUM
						CT2->CT2_PARCEL := SE1->E1_PARCELA
						CT2->CT2_TIPODC := SE1->E1_TIPO
						CT2->CT2_CLIFOR := SE1->E1_CLIENTE
						CT2->CT2_LOJACF := SE1->E1_LOJA
								
					ElseIf AllTrim(CTL->CTL_ALIAS) == "SE2"
							
						CT2->CT2_FILKEY := SE2->E2_FILIAL
						CT2->CT2_PREFIX := SE2->E2_PREFIXO
						CT2->CT2_NUMDOC := SE2->E2_NUM
						CT2->CT2_PARCEL := SE2->E2_PARCELA
						CT2->CT2_TIPODC := SE2->E2_TIPO
						CT2->CT2_CLIFOR := SE2->E2_FORNECE
						CT2->CT2_LOJACF := SE2->E2_LOJA
	
					ElseIf AllTrim(CTL->CTL_ALIAS) == "SE5"
							
						CT2->CT2_FILKEY := SE5->E5_FILIAL
						CT2->CT2_PREFIX := SE5->E5_PREFIXO
						CT2->CT2_NUMDOC := SE5->E5_NUMERO
						CT2->CT2_PARCEL := SE5->E5_PARCELA
						CT2->CT2_TIPODC := SE5->E5_TIPO
						CT2->CT2_CLIFOR := SE5->E5_CLIFOR
						CT2->CT2_LOJACF := SE5->E5_LOJA
	
					ElseIf AllTrim(CTL->CTL_ALIAS) == "SEF"
							
						CT2->CT2_FILKEY := SEF->EF_FILIAL
						CT2->CT2_PREFIX := SEF->EF_PREFIXO
						CT2->CT2_NUMDOC := SEF->EF_TITULO
						CT2->CT2_PARCEL := SEF->EF_PARCELA
						CT2->CT2_TIPODC := SEF->EF_TIPO
						CT2->CT2_CLIFOR := SEF->EF_FORNECE
						CT2->CT2_LOJACF := SEF->EF_LOJA
	
					EndIf
							
				CT2->( msUnLock() )
				CT2->( FKCommit() )
						
			EndIf

		EndIf
			
	EndIf
	
	RestArea( aAreaCTL )

Return

/*/{Protheus.doc} Static Function IndexNCC
	Regra para Indexadores de NCC
	@type  Function
	@author user
	@since 22/10/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	ticket 1438 - FWNM - 21/10/2020 - Indexadores de NCC incorretos
/*/
Static Function IndexNCC()

	Local nCV3_RECORI := 0
	
	/////////////////////////////////////////////////////////////
	If AllTrim(CT2->CT2_LP) == "596" // Comp clientes
	/////////////////////////////////////////////////////////////
	
		nCV3_RECORI := UpCV3RecOri()

		If nCV3_RECORI > 0

			// a d�bito gravar os dados da ncc
			SE5->( dbGoTo(nCV3_RECORI) )

			If AllTrim(SE5->E5_TIPO)=="NCC" .AND. !Empty(CT2->CT2_DEBITO)

				RecLock("CT2", .f.)
					CT2->CT2_FILKEY := SE5->E5_FILORIG //SE5->E5_FILIAL // @history ticket 89227 - 03/04/2023 - Fernando Macieira - Diferen�a nos indicadores nos lan�amentos de compensa��es de ciente e ncc de filiais diferentes
					CT2->CT2_PREFIX := SE5->E5_PREFIXO
					CT2->CT2_NUMDOC := SE5->E5_NUMERO
					CT2->CT2_PARCEL := SE5->E5_PARCELA
					CT2->CT2_TIPODC := SE5->E5_TIPO
					CT2->CT2_CLIFOR := SE5->E5_CLIFOR
					CT2->CT2_LOJACF := SE5->E5_LOJA
				CT2->( msUnLock() )

			Else

				If AllTrim(SE5->E5_TIPO)<>"RA"

					cE5_DOCUMEN := AllTrim(SE5->E5_DOCUMEN)
					cPrefixo := Left(cE5_DOCUMEN,3)
					cNum     := Subs(cE5_DOCUMEN,4,TamSX3("E1_NUM")[1])
					cParcela := Subs(cE5_DOCUMEN,13,TamSX3("E1_PARCELA")[1])
					cTipo    := Subs(cE5_DOCUMEN,16,TamSX3("E1_TIPO")[1])

					SE1->( dbSetOrder(1) ) // E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
					If SE1->( dbSeek(FWxFilial("SE1")+cPrefixo+cNum+cParcela+cTipo) )

						RecLock("CT2", .f.)
							CT2->CT2_FILKEY := SE1->E1_FILORIG //SE1->E1_FILIAL // @history ticket 89227 - 03/04/2023 - Fernando Macieira - Diferen�a nos indicadores nos lan�amentos de compensa��es de ciente e ncc de filiais diferentes
							CT2->CT2_PREFIX := SE1->E1_PREFIXO
							CT2->CT2_NUMDOC := SE1->E1_NUM
							CT2->CT2_PARCEL := SE1->E1_PARCELA
							CT2->CT2_TIPODC := SE1->E1_TIPO
							CT2->CT2_CLIFOR := SE1->E1_CLIENTE
							CT2->CT2_LOJACF := SE1->E1_LOJA
						CT2->( msUnLock() )
				
					EndIf
				
				EndIf

			EndIf

		EndIf
		
	/////////////////////////////////////////////////////////////
	ElseIf AllTrim(CT2->CT2_LP) == "588" // Estorno Comp clientes
	/////////////////////////////////////////////////////////////

		nCV3_RECORI := UpCV3RecOri()

		If nCV3_RECORI > 0

			// a d�bito gravar os dados da ncc
			SE5->( dbGoTo(nCV3_RECORI) )

			If AllTrim(SE5->E5_TIPO)=="NCC" 
			
				If !Empty(CT2->CT2_CREDIT)

					RecLock("CT2", .f.)
						CT2->CT2_FILKEY := SE5->E5_FILORIG //SE5->E5_FILIAL // @history ticket 89227 - 03/04/2023 - Fernando Macieira - Diferen�a nos indicadores nos lan�amentos de compensa��es de ciente e ncc de filiais diferentes
						CT2->CT2_PREFIX := SE5->E5_PREFIXO
						CT2->CT2_NUMDOC := SE5->E5_NUMERO
						CT2->CT2_PARCEL := SE5->E5_PARCELA
						CT2->CT2_TIPODC := SE5->E5_TIPO
						CT2->CT2_CLIFOR := SE5->E5_CLIFOR
						CT2->CT2_LOJACF := SE5->E5_LOJA
					CT2->( msUnLock() )

				Else

					cE5_DOCUMEN := AllTrim(SE5->E5_DOCUMEN)
					cPrefixo := Left(cE5_DOCUMEN,3)
					cNum     := Subs(cE5_DOCUMEN,4,TamSX3("E1_NUM")[1])
					cParcela := Subs(cE5_DOCUMEN,13,TamSX3("E1_PARCELA")[1])
					cTipo    := Subs(cE5_DOCUMEN,16,TamSX3("E1_TIPO")[1])

					SE1->( dbSetOrder(1) ) // E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
					If SE1->( dbSeek(FWxFilial("SE1")+cPrefixo+cNum+cParcela+cTipo) )

						RecLock("CT2", .f.)
							CT2->CT2_FILKEY := SE1->E1_FILORIG //SE5->E5_FILIAL // @history ticket 89227 - 03/04/2023 - Fernando Macieira - Diferen�a nos indicadores nos lan�amentos de compensa��es de ciente e ncc de filiais diferentes
							CT2->CT2_PREFIX := SE1->E1_PREFIXO
							CT2->CT2_NUMDOC := SE1->E1_NUM
							CT2->CT2_PARCEL := SE1->E1_PARCELA
							CT2->CT2_TIPODC := SE1->E1_TIPO
							CT2->CT2_CLIFOR := SE1->E1_CLIENTE
							CT2->CT2_LOJACF := SE1->E1_LOJA
						CT2->( msUnLock() )
				
					EndIf

				EndIf

			Else

				If AllTrim(SE5->E5_TIPO)<>"RA"

					If Empty(CT2->CT2_CREDIT)

						RecLock("CT2", .f.)
							CT2->CT2_FILKEY := SE5->E5_FILIAL
							CT2->CT2_PREFIX := SE5->E5_PREFIXO
							CT2->CT2_NUMDOC := SE5->E5_NUMERO
							CT2->CT2_PARCEL := SE5->E5_PARCELA
							CT2->CT2_TIPODC := SE5->E5_TIPO
							CT2->CT2_CLIFOR := SE5->E5_CLIFOR
							CT2->CT2_LOJACF := SE5->E5_LOJA
						CT2->( msUnLock() )

					Else

						cE5_DOCUMEN := AllTrim(SE5->E5_DOCUMEN)
						cPrefixo := Left(cE5_DOCUMEN,3)
						cNum     := Subs(cE5_DOCUMEN,4,TamSX3("E1_NUM")[1])
						cParcela := Subs(cE5_DOCUMEN,13,TamSX3("E1_PARCELA")[1])
						cTipo    := Subs(cE5_DOCUMEN,16,TamSX3("E1_TIPO")[1])

						SE1->( dbSetOrder(1) ) // E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
						If SE1->( dbSeek(FWxFilial("SE1")+cPrefixo+cNum+cParcela+cTipo) )

							RecLock("CT2", .f.)
								CT2->CT2_FILKEY := SE1->E1_FILIAL
								CT2->CT2_PREFIX := SE1->E1_PREFIXO
								CT2->CT2_NUMDOC := SE1->E1_NUM
								CT2->CT2_PARCEL := SE1->E1_PARCELA
								CT2->CT2_TIPODC := SE1->E1_TIPO
								CT2->CT2_CLIFOR := SE1->E1_CLIENTE
								CT2->CT2_LOJACF := SE1->E1_LOJA
							CT2->( msUnLock() )
					
						EndIf

					EndIf
				
				EndIf
			
			EndIf

		EndIf
	
	EndIf

Return

/*/{Protheus.doc} Static Function UpCV3RecOri()
	Busca RECNO de origem do tracker cont�bil
	@type  Function
	@author user
	@since 22/10/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function UpCV3RecOri()

	Local nCV3_RECORI := 0
	Local cQuery := ""

	If Select("WorkCV3") > 0
		WorkCV3->( dbCloseArea() )
	EndIf

	cQuery := " SELECT CV3_RECORI
	cQuery += " FROM " + RetSqlName("CV3") + " (NOLOCK)
	cQuery += " WHERE CV3_DTSEQ='"+DtoS(CT2->CT2_DTCV3)+"' 
	cQuery += " AND CV3_SEQUEN='"+CT2->CT2_SEQUEN+"'
	cQuery += " AND CV3_TABORI='SE5'
	cQuery += " AND CV3_KEY='"+CT2->CT2_KEY+"' 
	cQuery += " AND CV3_DC='"+CT2->CT2_DC+"' 
	cQuery += " AND CV3_DEBITO='"+CT2->CT2_DEBITO+"' 
	cQuery += " AND CV3_CREDIT='"+CT2->CT2_CREDIT+"' 
	cQuery += " AND D_E_L_E_T_=''

	tcQuery cQuery New Alias "WorkCV3"

	WorkCV3->( dbGoTop() )

	If WorkCV3->( !EOF() )
		nCV3_RECORI := Val(WorkCV3->CV3_RECORI)
	EndIf

	If Select("WorkCV3") > 0
		WorkCV3->( dbCloseArea() )
	EndIf

Return nCV3_RECORI

/*/{Protheus.doc} ATFLoteZCN()
	Preenche o lote recria na contabiliza��o da deprecia��o
	@type  Static Function
	@author FWNM
	@since 25/01/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 65263   - Fernando Macieira - 24/01/2022 - numero/nome da granja na contabiliza��o da deprecia��o
/*/
Static Function ATFLoteZCN()

	Local aArea      := {}
	Local cLP        := "820"
	Local cQuery     := ""
	Local cCodRecria := ""
	Local cNomRecria := ""

	// @history ticket 72858   - Fernando Macieira - 18/05/2022 - Lote 008870 - Deprecia��o deixa alterar o campo lote x cc mas nao assume a altera��o
	If nOpcLct == 4 .and. Upper(AllTrim(nProgra)) == "CTBA102"
		Return
	EndIf

	aArea      := GetArea()
	cLP        := GetMV("MV_#LPZCN",,"820")
	//

	If AllTrim(CT2->CT2_LP) $ cLP

		CTL->( dbSetOrder(1) ) // CTL_FILIAL, CTL_LP, R_E_C_N_O_, D_E_L_E_T_
		If CTL->( dbSeek(FWxFilial("CTL")+CT2->CT2_LP) )
			
			// Posiciona na SN3
			dbSelectArea( CTL->CTL_ALIAS ) // SN3
			dbSetOrder( Val(CTL->CTL_ORDER) ) // 1
			If dbSeek( Alltrim(CT2->CT2_KEY) ) // N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ

				// Posiciono na SN1 para bucar dados da NF ou CC do bem
				SN1->( dbSetOrder(1) ) // N1_FILIAL, N1_CBASE, N1_ITEM, R_E_C_N_O_, D_E_L_E_T_
				If SN1->( dbSeek(FWxFilial("SN1")+SN3->N3_CBASE+SN3->N3_ITEM) )

					// Busca precisa
					SD1->( dbSetOrder(26) ) // D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_ITEM, D1_COD, R_E_C_N_O_, D_E_L_E_T_
					If SD1->( dbSeek(FWxFilial("SD1")+SN1->N1_NFISCAL+SN1->N1_NSERIE+SN1->N1_FORNEC+SN1->N1_LOJA+SN1->N1_NFITEM) )

						cCodRecria := SD1->D1_XLOTECC
						cNomRecria := SD1->D1_XDLOTCC
				
						// Busco o novo lote sequencial do lote pois ele pode ser atualizado e neste caso ser� este que dever� ser levado para a contabiliza��o do ativo
						If Select("Work") > 0
							Work->( dbCloseArea() )
						EndIf

						cQuery := " SELECT ZCN_LOTE, ZCN_DESCLT 
						cQuery += " FROM " + RetSqlName("ZCN") + " (NOLOCK)
						cQuery += " WHERE ZCN_FILIAL='"+SD1->D1_FILIAL+"' 
						cQuery += " AND ZCN_LOTE='"+SD1->D1_XLOTECC+"'
						cQuery += " AND ZCN_CENTRO='"+SD1->D1_CC+"'
						cQuery += " AND ZCN_STATUS='A'
						cQuery += " AND D_E_L_E_T_=''

						tcQuery cQuery New Alias "Work"

						Work->( dbGoTop() )
						If Work->( !EOF() )
							cCodRecria := Work->ZCN_LOTE
							cNomRecria := Work->ZCN_DESCLT
						EndIf

						If Select("Work") > 0
							Work->( dbCloseArea() )
						EndIf

						// gravo lote na contabiliza��o da deprecia��o
						If !Empty(cCodRecria) .or. !Empty(cNomRecria)
							RecLock("CT2", .F.)
								CT2->CT2_XLTXCC := cCodRecria
								CT2->CT2_XDLXCC := cNomRecria
							CT2->( msUnLock() )
						EndIf

					Else
						
						// Busca sem item pois tem ativos que n�o possuem item
						SD1->( dbSetOrder(26) ) // D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_ITEM, D1_COD, R_E_C_N_O_, D_E_L_E_T_
						If SD1->( dbSeek(FWxFilial("SD1")+SN1->N1_NFISCAL+SN1->N1_NSERIE+SN1->N1_FORNEC+SN1->N1_LOJA) )

							cCodRecria := SD1->D1_XLOTECC
							cNomRecria := SD1->D1_XDLOTCC
					
							// Busco o novo lote sequencial do lote pois ele pode ser atualizado e neste caso ser� este que dever� ser levado para a contabiliza��o do ativo
							If Select("Work") > 0
								Work->( dbCloseArea() )
							EndIf

							cQuery := " SELECT ZCN_LOTE, ZCN_DESCLT 
							cQuery += " FROM " + RetSqlName("ZCN") + " (NOLOCK)
							cQuery += " WHERE ZCN_FILIAL='"+SD1->D1_FILIAL+"' 
							cQuery += " AND ZCN_CENTRO='"+SD1->D1_CC+"'
							cQuery += " AND ZCN_STATUS='A'
							cQuery += " AND D_E_L_E_T_=''

							tcQuery cQuery New Alias "Work"

							Work->( dbGoTop() )
							If Work->( !EOF() )
								cCodRecria := Work->ZCN_LOTE
								cNomRecria := Work->ZCN_DESCLT
							EndIf

							If Select("Work") > 0
								Work->( dbCloseArea() )
							EndIf

							// gravo lote na contabiliza��o da deprecia��o
							If !Empty(cCodRecria) .or. !Empty(cNomRecria)
								RecLock("CT2", .F.)
									CT2->CT2_XLTXCC := cCodRecria
									CT2->CT2_XDLXCC := cNomRecria
								CT2->( msUnLock() )
							EndIf

						EndIf
					
					EndIf

				EndIf

				// Busco direto pelo CC N3_CUSTBEM 
				If Empty(cCodRecria) .or. Empty(cNomRecria)

					If Select("Work") > 0
						Work->( dbCloseArea() )
					EndIf

					cQuery := " SELECT ZCN_LOTE, ZCN_DESCLT 
					cQuery += " FROM " + RetSqlName("ZCN") + " (NOLOCK)
					cQuery += " WHERE ZCN_FILIAL='"+SN3->N3_FILIAL+"' 
					cQuery += " AND ZCN_CENTRO='"+SN3->N3_CUSTBEM+"'
					cQuery += " AND ZCN_STATUS='A'
					cQuery += " AND D_E_L_E_T_=''

					tcQuery cQuery New Alias "Work"

					Work->( dbGoTop() )
					If Work->( !EOF() )
						cCodRecria := Work->ZCN_LOTE
						cNomRecria := Work->ZCN_DESCLT
					EndIf

					If Select("Work") > 0
						Work->( dbCloseArea() )
					EndIf

					// gravo lote na contabiliza��o da deprecia��o
					If !Empty(cCodRecria) .or. !Empty(cNomRecria)
						RecLock("CT2", .F.)
							CT2->CT2_XLTXCC := cCodRecria
							CT2->CT2_XDLXCC := cNomRecria
						CT2->( msUnLock() )
					EndIf

				EndIf
			
			EndIf

		EndIf

	EndIf

	RestArea( aArea )
	
Return

/*/{Protheus.doc} User Function nomeFunction
    Corrige indexadores dos lan�amentos cont�beis 
    @type  Function
    @author FWNM
    @since 02/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @ticket 72053 - ERRO DE CONTABILIZA��O - INDEXADORES TROCADOS
/*/
User Function FixIndex()

    Local cQuery := ""

    If Select("Work") > 0
        Work->( dbCloseArea() )
    EndIf

    cQuery := " SELECT CT2_LP, CT2_KEY, CT2_SEQUEN, CT2_FILKEY, CT2_PREFIX, CT2_NUMDOC, CT2_PARCEL, CT2_TIPODC, CT2_CLIFOR, CT2_LOJACF, CT2_DTCV3, R_E_C_N_O_ CT2RECNO
    cQuery += " FROM CT2010 (NOLOCK)
    cQuery += " WHERE CT2_DATA LIKE '202204%'
    cQuery += " AND CT2_LOTE='008850'
    cQuery += " AND CT2_CREDIT='111210001'
    cQuery += " AND CT2_LP='596'
    cQuery += " AND D_E_L_E_T_=''

    tcQuery cQuery New Alias "Work"

    aTamSX3	:= TamSX3("CT2_DTCV3")
	tcSetField("Work", "CT2_DTCV3", aTamSX3[3], aTamSX3[1], aTamSX3[2])

    Work->( dbGoTop() )
    Do While Work->( !EOF() )

        CV3->( dbSetOrder(1) ) // CV3_FILIAL, CV3_DTSEQ, CV3_SEQUEN, R_E_C_N_O_, D_E_L_E_T_
        If CV3->( dbSeek(FWxFilial("CV3")+Work->(DtoS(CT2_DTCV3)+CT2_SEQUEN)) )

            If AllTrim(CV3->CV3_TABORI) == "SE5"

                SE5->( dbGoTo( Val(CV3->CV3_RECORI) ) )
				cE5_DOCUMEN := AllTrim(SE5->E5_DOCUMEN)
					cFilE5   := SE5->E5_FILIAL
                    cPrefixo := Left(cE5_DOCUMEN,3)
					cNum     := Subs(cE5_DOCUMEN,4,TamSX3("E1_NUM")[1])
					cParcela := Subs(cE5_DOCUMEN,13,TamSX3("E1_PARCELA")[1])
					cTipo    := Subs(cE5_DOCUMEN,16,TamSX3("E1_TIPO")[1])

                // Posiciono SE5 da NF para ent�o gravar indexador da CT2
                SE1->( dbSetOrder(1) ) // E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
                If SE1->( dbSeek(cFilE5+cPrefixo+cNum+cParcela+cTipo))

                    CT2->( dbGoTo(Work->CT2RECNO) )
                    RecLock("CT2", .F.)
                        CT2->CT2_FILKEY := SE1->E1_FILIAL
                        CT2->CT2_PREFIX := SE1->E1_PREFIXO
                        CT2->CT2_NUMDOC := SE1->E1_NUM
                        CT2->CT2_PARCEL := SE1->E1_PARCELA
                        CT2->CT2_TIPODC := SE1->E1_TIPO
                        CT2->CT2_CLIFOR := SE1->E1_CLIENTE
                        CT2->CT2_LOJACF := SE1->E1_LOJA
                    CT2->( msUnLock() )

                EndIf

            EndIf

        EndIf

        Work->( dbSkip() )

    EndDo

    If Select("Work") > 0
        Work->( dbCloseArea() )
    EndIf

Return

/*/{Protheus.doc} newLoteZCN()
	Preenche o lote recria na contabiliza��o da deprecia��o
	Regra: De acordo com o centro de custo utilizado no lan�amento da deprecia��o, buscar no cadastro de Lote x CC o lote correspondente que estiver com status �Aberto�.
	@type  Static Function
	@author FWNM
	@since 12/01/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@ticket 84225   - 12/01/2023 - Fernando Macieira - Altera��o da Regra de lan�amento de deprecia��o para inclus�o de lote X CC e Descri Lote
/*/
Static Function newLoteZCN()

	Local aArea      := {}
	Local cLP        := "820"
	Local cQuery     := ""
	Local cCodRecria := ""
	Local cNomRecria := ""
	Local _cMVEUSALT  := SuperGetMV("MV_#EUSALT",.F.,'010/070/090') //Empresas que usam Lote. ticket 93088 - Antonio Domingos - 02/05/2023
	
	// @history ticket 72858   - Fernando Macieira - 18/05/2022 - Lote 008870 - Deprecia��o deixa alterar o campo lote x cc mas nao assume a altera��o
	If nOpcLct == 4 .and. Upper(AllTrim(nProgra)) == "CTBA102"
		Return
	EndIf

	aArea      := GetArea()
	aCT2Area   := CT2->(GetArea())
	cLP        := GetMV("MV_#LPZCN",,"820")
	//

	If AllTrim(CT2->CT2_LP) $ cLP

		// Gravo log com todos os lotes recrias encontrados daquele CC, independentemente do status e filial
		If Select("Work") > 0
			Work->( dbCloseArea() )
		EndIf

		cQuery := " SELECT ZCN_FILIAL, ZCN_LOTE, ZCN_DESCLT, ZCN_STATUS, ZCN_TIPO
		cQuery += " FROM " + RetSqlName("ZCN") + " (NOLOCK)
		cQuery += " WHERE ZCN_CENTRO='"+CT2->CT2_CCD+"'
		cQuery += " AND D_E_L_E_T_=''
		cQuery += " ORDER BY R_E_C_N_O_

		tcQuery cQuery New Alias "Work"

		Work->( dbGoTop() )
		Do While Work->( !EOF() )

			u_GrLogZBE(msDate(),TIME(),cUserName,"DEPRECIACAO","CONTABILIDADE","CTBGRV",;
			"LOG LOTES RECRIAS ENCONTRADOS " + Work->ZCN_FILIAL + "," + Work->ZCN_DESCLT + "," + Work->ZCN_LOTE + "," + Work->ZCN_STATUS + "," + Work->ZCN_TIPO, ComputerName(), LogUserName() )

			Work->( dbSkip() )

		EndDo

		// Busco o novo lote sequencial do lote pois ele pode ser atualizado e neste caso ser� este que dever� ser levado para a contabiliza��o do ativo
		If Select("Work") > 0
			Work->( dbCloseArea() )
		EndIf

		cQuery := " SELECT TOP 1 ZCN_FILIAL, ZCN_LOTE, ZCN_DESCLT 
		cQuery += " FROM " + RetSqlName("ZCN") + " (NOLOCK)
		cQuery += " WHERE ZCN_FILIAL='"+CT2->CT2_FILORI+"' 
		cQuery += " AND ZCN_CENTRO='"+CT2->CT2_CCD+"'
		cQuery += " AND ZCN_STATUS='A'
		cQuery += " AND D_E_L_E_T_=''
		cQuery += " ORDER BY R_E_C_N_O_

		tcQuery cQuery New Alias "Work"

		Work->( dbGoTop() )
		If Work->( !EOF() )
			cCodRecria := Work->ZCN_LOTE
			cNomRecria := Work->ZCN_DESCLT
		EndIf

		// gravo lote na contabiliza��o da deprecia��o
		If !Empty(cCodRecria) .or. !Empty(cNomRecria)

			RecLock("CT2", .F.)
				CT2->CT2_XLTXCC := cCodRecria
				CT2->CT2_XDLXCC := cNomRecria
			CT2->( msUnLock() )

			u_GrLogZBE(msDate(),TIME(),cUserName,"DEPRECIACAO","CONTABILIDADE","CTBGRV",;
			"LOTE RECRIA GRAVADO " + Work->ZCN_FILIAL + "," + cNomRecria + "," + cCodRecria + " - CT2 " + DtoC(CT2->CT2_DATA)+","+CT2->CT2_LOTE+","+CT2->CT2_DOC+","+CT2->CT2_LINHA+","+CT2->CT2_CCD, ComputerName(), LogUserName() )

		Else

			u_GrLogZBE(msDate(),TIME(),cUserName,"DEPRECIACAO","CONTABILIDADE","CTBGRV",;
			"NENHUM LOTE RECRIA EM ABERTO " + Work->ZCN_FILIAL + "," + cNomRecria + "," + cCodRecria + " - CT2 " + DtoC(CT2->CT2_DATA)+","+CT2->CT2_LOTE+","+CT2->CT2_DOC+","+CT2->CT2_LINHA+","+CT2->CT2_CCD, ComputerName(), LogUserName() )
		
		EndIf

		If Select("Work") > 0
			Work->( dbCloseArea() )
		EndIf
	
	EndIf

	// @history ticket 90838 - 03/04/2023 - Fernando Macieira - TRANSFERENCIA DE ITENS DE ALMOXARIFADO - MATRIZES
	If AllTrim(CT2->CT2_LP) == "610" .or. AllTrim(CT2->CT2_LP) == "650"

		// Sa�da - Origem
		If CV3->CV3_TABORI == "SD2"
			
			// @history ticket 93253 - 04/05/2023 - Fernando Macieira - PROBLEMA NA INTEGRA��O - FATURAMENTO CERES
			If SC6->(FieldPos("C6_XLOTECC")) > 0 .and.;
			   CT2->(FieldPos("CT2_XLTXCC")) > 0 .and.;
			   CT2->(FieldPos("CT2_XDLXCC")) > 0
			
				SD2->( dbGoTo(Val(CV3->CV3_RECORI)) )

				cCodRecria := Posicione("SC6",1,FWxFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEM,"C6_XLOTECC")
				cNomRecria := Posicione("ZCN",1,FWxFilial("ZCN")+cCodRecria,"ZCN_DESCLT")

				If !Empty(cCodRecria) .or. !Empty(cNomRecria)
					RecLock("CT2", .F.)
						CT2->CT2_XLTXCC := cCodRecria
						CT2->CT2_XDLXCC := cNomRecria
					CT2->( msUnLock() )
				EndIf
			
			EndIf

		EndIf

		// Entrada - Destino
		If CV3->CV3_TABORI == "SD1" .And. alltrim(cEmpAnt)  $ _cMVEUSALT //ticket 93088 - Antonio Domingos - 02/05/2023

			// @history ticket 93253 - 04/05/2023 - Fernando Macieira - PROBLEMA NA INTEGRA��O - FATURAMENTO CERES
			If SD1->(FieldPos("D1_XLOTECC")) > 0 .and.;
			   CT2->(FieldPos("CT2_XLTXCC")) > 0 .and.;
			   CT2->(FieldPos("CT2_XDLXCC")) > 0

				SD1->( dbGoTo(Val(CV3->CV3_RECORI)) )
				CT2->(DBORDERNICKNAME( "CT2KEY0001" ))
				cCodRecria := SD1->D1_XLOTECC 
				cNomRecria := Posicione("ZCN",1,FWxFilial("ZCN")+cCodRecria,"ZCN_DESCLT")
				If !Empty(cCodRecria) .or. !Empty(cNomRecria)
					RecLock("CT2", .F.)
						CT2->CT2_XLTXCC := cCodRecria
						CT2->CT2_XDLXCC := cNomRecria
					CT2->( msUnLock() )
				EndIf
			
			EndIf

		EndIf

	EndIf
	//ticket 93561 - Antonio Domingos - 02/05/2023
	If CV3->CV3_TABORI == "SD1" .And. alltrim(cEmpAnt)  $ _cMVEUSALT
	   If CV3->CV3_TABORI == "SD1" 
			SD1->( dbGoTo(Val(CV3->CV3_RECORI)) )
			CT2->(DBORDERNICKNAME( "CT2KEY0001" ))
			If CT2->(DBSEEK(CV3->CV3_FILIAL+CV3->CV3_KEY))
				//Aviso("Aten��o", " CV3_KEY "+CV3->CV3_KEY+" CT2_KEY "+CT2->CT2_KEY, {"OK"}, 3)
				If CT2->CT2_XLTXCC <> SD1->D1_XLOTECC .And. !Empty(SD1->D1_XLOTECC)
					RecLock("CT2", .F.)
						CT2->CT2_XLTXCC := SD1->D1_XLOTECC
						CT2->CT2_XDLXCC := Posicione("ZCN",1,FWxFilial("ZCN")+SD1->D1_XLOTECC,"ZCN_DESCLT")
					CT2->( msUnLock() )
					//Aviso("Aten��o", " CT2_XLTXCC "+CT2->CT2_XLTXCC+" D1_XLOTECC "+SD1->D1_XLOTECC, {"OK"}, 3)
				EndIf
	   		EndIf
	   EndIf
	EndIf
	
	RestArea(aCT2Area)
	RestArea( aArea )
	
Return
