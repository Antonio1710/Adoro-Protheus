#INCLUDE "TOTVS.CH"
/*/{Protheus.doc} ADEST084P - Rotina de atualizacao da liberacao de credito
	Esta rotina realiza a atualizacao da liberacao de pedido de venda com base na tabela SC9.
	Baseada na Função padrão a450Grava ³ Rev.  ³ Eduardo Riera         ³ Data ³02.02.2002 ³±±
	@type  User Function
	@author Antonio Domingos
	@since 21/12/2022
	@version version
	@param 
		±±³Parametros³ExpC1  Filial                                                ³±±
		±±³          ³ExpN2: 1 - Liberacao                                         ³±±
		±±³          ³       2 - Rejeicao                                          ³±±
		±±³          ³ExpL3: Indica uma Liberacao de Credito                       ³±±
		±±³          ³ExpL4: Indica uma liberacao de Estoque                       ³±±
		±±³          ³ExpL5: Indica se exibira o help da liberacao                 ³±±
		±±³          ³ExpA6: Saldo dos lotes a liberar                             ³±±
		±±³          ³ExpA7: Forca analise da liberacao de estoque                 ³±±
		±±³          ³ExpL8: Indica se a funcao deve armazenar as mensagens de     ³±±
		±±³          ³       inconsistencias e alertas no processo de liberacao    ³±±
	@return nil
	@example
	(examples)
	@see (links_or_references)
	@history ticket 85037 	- Antonio Domingos  - 20/12/2022 - Ajuste de Filial - BAIXA AUTOMATICA PEDIDOS ANTECIPADO - BOLETOS.
	@history Ticket 90119 - Antonio Domingos - 16/03/2023 - PEDIDO DE FORNECEDOR BLOQUEANDO TIPO B e D
	/*/
User Function ADEST084P(_cFilial,nOpc,lAtuCred,lAtuEst,_lHelp,aSaldos,lAvEst,lLogMsg)

Local aArea      := GetArea()
Local aAreaC9    := SC9->(GetArea())
Local aSaldoP3   := {}
Local lCredito   := Empty(SC9->C9_BLCRED)
Local nQtdEst    := 0
Local nMCusto    :=  Val(SuperGetMv("MV_MCUSTO"))
Local nQtdPoder3 := 0
Local nQtdEmP3   := 0
Local nQtdALib   := 0
Local nQtdLib    := 0
Local lOrdSepLib := .F.
Local lEstoque   := .F.
Local lMvAvalEst := SuperGetMv("MV_AVALEST")==2
Local lBlqEst    := SuperGetMv("MV_AVALEST")==3 .And. Empty(aSaldos)
Local cLiberOk   := ""
Local cBlq       := ""
Local cBloquei   := ""
Local nX         
                 
Default  _lHelp   := .F.
Default aSaldos  := {}
Default lAvEst   := .F.
DEfault lLogMsg  := .F.

//- Status dos Bloqueios do pedido de venda. Se .T. DCF gerado, tem que estornar.
Private lbloqDCF := !Empty(SC9->C9_BLCRED+SC9->C9_BLEST)
lBlqEst := lBlqEst .And. !lAvEst
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona Registros                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC5")
dbSetOrder(1)
MsSeek(_cFilial+SC9->C9_PEDIDO) //ticket 85037 	- Antonio Domingos  - 20/12/2022

dbSelectArea("SC6")
dbSetOrder(1)
MsSeek(_cFilial+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO) //ticket 85037 	- Antonio Domingos  - 20/12/2022

dbSelectArea("SA1")
dbSetOrder(1)
MsSeek(xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA)

dbSelectArea("SF4")
dbSetOrder(1)
MsSeek(xFilial("SF4")+SC6->C6_TES)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Moeda Forte do Cliente                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMCusto:= If (SA1->A1_MOEDALC > 0, SA1->A1_MOEDALC, nMCusto)					
dbSelectArea("SB2")
dbSetOrder(1)
MsSeek(_cFilial+SC6->C6_PRODUTO+SC6->C6_LOCAL) //ticket 85037 	- Antonio Domingos  - 20/12/2022

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Liberacao do SC9                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( nOpc == 1 )
	Begin Transaction
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Travamento dos Registros                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SC5->C5_TIPO $ "DB")
			RecLock("SA1",.F.)
		EndIf
		RecLock("SC5",.F.)
		RecLock("SC6",.F.)
		RecLock("SC9",.F.)
		If ( SB2->(Found()) )
			RecLock("SB2",.F.)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Calcula a quantidade disponivel em estoque                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nQtdEst :=SC9->C9_QTDLIB
		If ( Empty(SC9->C9_RESERVA) .And. !Empty(SC9->C9_BLCRED+SC9->C9_BLEST) .And. SF4->F4_ESTOQUE == "S")				
			If lBlqEst
				lEstoque := .F.
			Else
				If Empty(aSaldos)
					lEstoque := A440VerSB2(@nQtdEst,lMvAvalEst)
				Else          
					lEstoque := A440VerSB2(@nQtdEst,lMvAvalEst,,,,.F.)
				EndIf
			EndIf
		Else
			lEstoque := .T.
		EndIf
		If ( nQtdEst == 0 )
			nQtdEst  := SC9->C9_QTDLIB
			lEstoque := .F.
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Avaliacao de Credito                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( lAtuCred .And. !Empty(SC9->C9_BLCRED) )
			MaAvalSC9("SC9",4,Nil,Nil,Nil,.F.)
			SC9->C9_BLCRED := ""
			SC9->C9_BLEST := "02"
			MaAvalSC9("SC9",3)
			lCredito := .T.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Regrava a quantidade empenha quando solicitado                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( lMvAvalEst )
				SC6->C6_QTDEMP -= SC9->C9_QTDLIB
				SC9->C9_QTDLIB := nQtdEst
				SC9->C9_QTDLIB2 := nQtdEst * ( SC6->C6_UNSVEN / SC6->C6_QTDVEN )
				SC6->C6_QTDEMP += SC9->C9_QTDLIB
			EndIf
		EndIf
		If ( Empty(SC9->C9_BLCRED) .And. (lAtuEst .Or. lEstoque))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Avaliacao do Estoque                                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !( SF4->F4_PODER3=='D' .And. !(SC5->C5_TIPO$"CIPD") )
				aSaldoP3   := MaNeedP3(SC9->C9_QTDLIB,IIf(Empty(SC9->C9_BLCRED+SC9->C9_BLEST),SC9->C9_QTDLIB,0))
				nQtdPoder3 := aSaldoP3[2]
				nQtdEmP3   := aSaldoP3[3]
			Else
				nQtdPoder3 := 0
				nQtdEmP3   := 0
			EndIf
			If Rastro(SC9->C9_PRODUTO) .Or. Localiza(SC9->C9_PRODUTO) .Or. !Empty(SC9->C9_RESERVA) .Or. nQtdPoder3 <> 0 .Or. nQtdEmP3 <> 0
				If (Rastro(SC9->C9_PRODUTO) .Or. Localiza(SC9->C9_PRODUTO)) .And. !lEstoque
					//Nao faz nada.
				Else

					RecLock("SC5")
					cLiberOk := SC5->C5_LIBEROK
					nQtdALib := SC9->C9_QTDLIB
					cBlq     := SC5->C5_BLQ
					cBloquei := SC6->C6_BLOQUEI
					SC9->(a460Estorna())
					SC5->C5_BLQ     := cBlq
					SC6->C6_BLOQUEI := cBloquei
					If Len(aSaldos)>0
						For nX := 1 To Len(aSaldos)
							RecLock("SC6")
							SC6->C6_LOTECTL := aSaldos[nX][1]
							SC6->C6_NUMLOTE := aSaldos[nX][2]
							SC6->C6_LOCALIZ := aSaldos[nX][3]
							SC6->C6_NUMSERI := aSaldos[nX][4]
							SC6->C6_DTVALID := aSaldos[nX][7]
							SC6->C6_POTENCI := aSaldos[nX][6]
							
							MaLibDoFat(SC6->(RecNo()),Min(aSaldos[nX][5],nQtdALib),@lCredito,@lEstoque,!(lAtuCred .Or. Empty(SC9->C9_BLCRED)),!Empty(SC9->C9_BLEST),.F.,.F.)
							nQtdALib -= Min(aSaldos[nX][5],nQtdALib)
							
							
											
						Next nX
					Else
						nQtdLib := MaLibDoFat(SC6->(RecNo())                        , SC9->C9_QTDLIB       , @lCredito, @lEstoque, ;
						                      !(lAtuCred .Or. Empty(SC9->C9_BLCRED)), !Empty(SC9->C9_BLEST), .F.      , .F.      , ;
						                                                            ,                      ,          ,          , ;
						                                                            ,                      ,          , lLogMsg  , ;
						                      @lOrdSepLib)
						If (Empty(nQtdLib) .And. lOrdSepLib) 
							DisarmTransaction()
							Break
						EndIf
					EndIf
					RecLock("SC5")
					SC5->C5_LIBEROK := cLiberOk
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Retira o Bloqueio de Estoque                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FatAtuEmpN("-")
				MaAvalSC9("SC9",6,{{ "","","","",SC9->C9_QTDLIB,SC9->C9_QTDLIB2,Ctod(""),"","","",SC9->C9_LOCAL}},Nil,Nil,.F.)
				SC9->C9_BLEST := ""
				MaAvalSC9("SC9",5,{{ "","","","",SC9->C9_QTDLIB,SC9->C9_QTDLIB2,Ctod(""),"","","",SC9->C9_LOCAL}})
				dbSelectArea("SC9")
				MsUnlock()
				dBCommit()
				FatAtuEmpN("+")
			EndIf
		EndIf
	End Transaction
	If ( (lAtuEst .And. !Empty(SC9->C9_BLEST)) ) .And. _lHelp .And. IsInCallStack("A455LibMan")
		Help(" ",1,"A455LIBMAN",, "Liberacao manual de estoque nao permitida.", 1, 1 ) //"Liberacao manual de estoque nao permitida."
		_lHelp := .F.
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Rejeicao do SC9                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Begin Transaction
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Efetua o Bloqueio de Credito por Rejeicao                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//Ticket 90119 - Antonio Domingos - 16/03/2023
		If SC5->C5_FILIAL+SC5->C5_NUM <> SC9->C9_FILIAL+SC9->C9_PEDIDO
			_cC5_TIPO := Posicione("SC5",1,SC9->C9_FILIAL+SC9->C9_PEDIDO,"C5_TIPO")
		else
			_cC5_TIPO := SC5->C5_TIPO
		EndIf
		If !(_cC5_TIPO $ "BD")
			RecLock("SC9")
			SC9->C9_BLCRED := "09"
			MsUnlock()	
		EndIf
	End Transaction
EndIf
RestArea(aAreaC9)
RestArea(aArea)
Return(Nil)
